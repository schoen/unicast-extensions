#!/bin/sh
# SPDX-License-Identifier: GPL-2.0

# Self-tests for IPv4 address extensions: the kernel's ability to accept
# certain traditionally unused or unallocated IPv4 addresses. Currently
# the kernel accepts addresses in 0/8 and 240/4 as valid. These tests
# check this for interface assignment, ping, TCP, and forwarding. Must
# be run as root (to manipulate network namespaces and virtual interfaces).

# This is work in progress toward an eventual submission to the Linux
# selftests (in linux/tools/testing/selftests).

# TODO: This needs a nettest binary, from linux/tools/testing/selftests/net;
#       either integrate this with the selftests so this is guaranteed to
#       be available, or use a different dependency for TCP socket testing!

# TODO: can we make this faster by having nettest indicate exactly
#       when the listening socket has been bound or something?

if [ -x ./nettest ]; then
	NETTEST=./nettest
elif [ -x /tmp/nettest ]; then
	NETTEST=/tmp/nettest   # XXX this is only for testing because
	                       # we should definitely not run a script
			       # with a fixed name from /tmp as root!
else
	NETTEST=`which nettest`
fi

result=0

hide_output(){ exec 3>&1; exec 4>&2; exec >/dev/null; exec 2>/dev/null; }
show_output(){ exec >&3; exec 2>&4; }

show_result(){
if [ $1 -eq 0 ]; then
	printf "TEST: %-60s  [ OK ]\n" "${2}"
else
	printf "TEST: %-60s  [FAIL]\n" "${2}"
	result=1
fi
}

_do_pingtest(){
# expects caller to set up foo-ns and bar-ns namespaces
# and clean them up afterward
ip netns exec foo-ns ifconfig foo inet $1/$3 || return 1
ip netns exec bar-ns ifconfig bar inet $2/$3 || return 1
ip netns exec foo-ns timeout 2 ping -c 1 $2 || return 1
ip netns exec bar-ns timeout 2 ping -c 1 $1 || return 1

# using nettest (for this simple test, it's akin to netcat)
ip netns exec foo-ns "$NETTEST" -s &
sleep 0.5
ip netns exec bar-ns "$NETTEST" -r $1 || return 1

ip netns exec bar-ns "$NETTEST" -s &
sleep 0.5
ip netns exec foo-ns "$NETTEST" -r $2 || return 1

wait
return 0
}

_do_route_test(){
# expects caller to set up foo-ns, bar-ns, and router_ns before,
# and clean them up afterward

ip netns exec foo-ns ifconfig foo inet $1/$5 || return 1
ip netns exec bar-ns ifconfig bar inet $4/$5 || return 1
ip netns exec router-ns ifconfig foo1 inet $2/$5 || return 1
ip netns exec router-ns ifconfig bar1 inet $3/$5 || return 1
echo 1 | ip netns exec router-ns tee /proc/sys/net/ipv4/ip_forward
ip netns exec foo-ns route add -net default gw $2 || return 1
ip netns exec bar-ns route add -net default gw $3 || return 1
ip netns exec foo-ns timeout 2 ping -c 1 $2 || return 1
ip netns exec foo-ns timeout 2 ping -c 1 $4 || return 1
ip netns exec bar-ns timeout 2 ping -c 1 $3 || return 1
ip netns exec bar-ns timeout 2 ping -c 1 $1 || return 1

ip netns exec foo-ns "$NETTEST" -s &
sleep 0.5
ip netns exec bar-ns "$NETTEST" -r $1 || return 1

ip netns exec bar-ns "$NETTEST" -s &
sleep 0.5
ip netns exec foo-ns "$NETTEST" -r $4 || return 1

wait
return 0
}

pingtest(){
hide_output
ip netns add foo-ns
ip netns add bar-ns
ip link add foo netns foo-ns type veth peer name bar netns bar-ns

test_result=0
_do_pingtest "$@" || test_result=1

ip netns del foo-ns
ip netns del bar-ns
show_output

# inverted tests will expect failure instead of success
[ -n "$expect_failure" ] && test_result=`expr 1 - $test_result`

show_result $test_result "$4"
}


route_test(){
	# [a] <---> [b]-[c] <---> [d]   /mask
test_result=0
hide_output
ip netns add foo-ns
ip netns add bar-ns
ip netns add router-ns
ip link add foo netns foo-ns type veth peer name foo1 netns router-ns
ip link add bar netns bar-ns type veth peer name bar1 netns router-ns

test_result=0
_do_route_test "$@" || test_result=1

ip netns del foo-ns
ip netns del bar-ns
ip netns del router-ns

show_output
show_result $test_result "$6"
}

# Test support for 240/4
pingtest 240.1.2.1   240.1.2.4    24 "assign and ping within 240/4 (1 of 2)"
pingtest 250.100.2.1 250.100.30.4 16 "assign and ping within 240/4 (2 of 2)"

# Test support for 0/8
pingtest 0.1.2.17    0.1.2.23  24 "assign and ping within 0/8 (1 of 2)"
pingtest 0.77.240.17 0.77.2.23 16 "assign and ping within 0/8 (2 of 2)"

# It should still not be possible to use 0.0.0.0 or 255.255.255.255
# as a unicast address.  Thus, these tests expect failure.
expect_failure=true
pingtest 0.0.1.5       0.0.0.0         16 "assigning 0.0.0.0 is forbidden"
pingtest 255.255.255.1 255.255.255.255 16 "assigning 255.255.255.255 is forbidden"
unset expect_failure

# But, even 255.255/16 is OK!
pingtest 255.255.3.1 255.255.50.77 16 "assign and ping inside 255.255/16"

# Or 255.255.255/24
pingtest 255.255.255.1 255.255.255.254 24 "assign and ping inside 255.255.255/24"

#    Test support for zeroth host
# pingtest 5.10.15.20 5.10.15.0 24 "assign and ping zeroth host"

#    Test support for not having all of 127 be loopback
# pingtest 127.99.4.5 127.99.4.6 16 "assign and ping inside 127/8"

# Routing between different networks
route_test 240.5.6.7 240.5.6.1  255.1.2.1    255.1.2.3      24 "route between 240.5.6/24 and 255.1.2/24"
route_test 0.200.6.7 0.200.38.1 245.99.101.1 245.99.200.111 16 "route between 0.200/16 and 245.99/16"

#   Routing using zeroth host as a gateway/endpoint (also requires zeroth host
#   patch)!
# route_test 192.168.42.1 192.168.42.0 9.8.7.6 9.8.7.0 24 "route using zeroth host"

# TODO: It's slightly harder to have tests for TCP, not just ICMP, because
#       the ping responder is in the kernel, while answering TCP via netcat
#       requires a subprocess or subshell.  However this could certainly be
#       done with a subshell, like { echo hello | timeout 2 nc -l 12345; } &
#       or similar.

exit ${result}
