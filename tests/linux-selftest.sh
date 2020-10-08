#!/bin/sh
# SPDX-License-Identifier: GPL-2.0

# This is work in progress toward an eventual submission to the Linux
# selftests (in linux/tools/testing/selftests).  It uses the network
# namespace kernel features (netns) together with virtual Ethernet
# (veth) to create userspace processes that are akin to processes on
# separate machines connected via an Ethernet, a technique used by many
# of the other tests in selftests/net.

# This test must be run as root (to manipulate the network namespaces
# and virtual interfaces).

# TODO: This needs to be updated to match coding style and success/failure
#       reporting conventions of existing network tests.  (It now returns
#       success when the tests perform as expected, but the output is
#       still pretty noisy!)

result=0

pingtest(){
test_result=0
exec 3>&1
exec 4>&2
exec >/dev/null
exec 2>/dev/null
ip netns add foo-ns
ip netns add bar-ns
ip link add foo netns foo-ns type veth peer name bar netns bar-ns
ip netns exec foo-ns ifconfig foo inet $1/$3 || test_result=1
ip netns exec bar-ns ifconfig bar inet $2/$3 || test_result=1
ip netns exec foo-ns timeout 2 ping -c 1 $2 || test_result=1
ip netns exec bar-ns timeout 2 ping -c 1 $1 || test_result=1
ip netns exec foo-ns arp -n
ip netns exec bar-ns arp -n

ip netns del foo-ns
ip netns del bar-ns
exec >&3
exec 2>&4
if [ $test_result -eq 0 ]
then
	printf "TEST: %-60s  [ OK ]\n" "${4}"
else
	printf "TEST: %-60s  [FAIL]\n" "${4}"
	result=1
fi
}

invert_pingtest(){
test_result=0
exec 3>&1
exec 4>&2
exec >/dev/null
exec 2>/dev/null
ip netns add foo-ns
ip netns add bar-ns
ip link add foo netns foo-ns type veth peer name bar netns bar-ns
ip netns exec foo-ns ifconfig foo inet $1/$3 || test_result=1
ip netns exec bar-ns ifconfig bar inet $2/$3 || test_result=1
ip netns exec foo-ns timeout 2 ping -c 1 $2 || test_result=1
ip netns exec bar-ns timeout 2 ping -c 1 $1 || test_result=1
ip netns exec foo-ns arp -n
ip netns exec bar-ns arp -n

ip netns del foo-ns
ip netns del bar-ns
exec >&3
exec 2>&4

if [ $test_result -ne 0 ]   # inverted to expect failure!!
then
	printf "TEST: %-60s  [ OK ]\n" "${4}"
else
	printf "TEST: %-60s  [FAIL]\n" "${4}"
	result=1
fi
}


# Test support for 240/4
pingtest 240.1.2.1 240.1.2.4 24 "assign and ping within 240/4 (1 of 2)"
pingtest 250.100.2.1 250.100.30.4 16 "assign and ping within 240/4 (2 of 2)"

# Test support for 0/8
pingtest 0.1.2.17 0.1.2.23 24 "assign and ping within 0/8 (1 of 2)"
pingtest 0.77.240.17 0.77.2.23 16 "assign and ping within 0/8 (2 of 2)"

# It should still not be possible to use 0.0.0.0 or 255.255.255.255
# as a unicast address.  Thus, these tests expect failure.
invert_pingtest 0.0.1.5 0.0.0.0 16 "assigning 0.0.0.0 is forbidden"
invert_pingtest 255.255.255.1 255.255.255.255 16 "assigning 255.255.255.255 is forbidden"

# But, even 255.255/16 is OK!
pingtest 255.255.3.1 255.255.50.77 16 "assign and ping inside 255.255/16"

# Or 255.255.255/24
pingtest 255.255.255.1 255.255.255.254 16 "assign and ping inside 255.255.255/24"


# Test support for zeroth host
# pingtest 5.10.15.20 5.10.15.0 24 "assign and ping zeroth host"

# Test support for not having all of 127 be loopback
# pingtest 127.99.4.5 127.99.4.6 16 "assign and ping inside 127/8"

# Interestingly, the kernel is happy to assign these 127/8 addresses to veth
# interfaces, but even though there's no explicit routing table entry for
# them, the ping still gives "Invalid argument", like
#
# connect(5, {sa_family=AF_INET, sin_port=htons(1025), sin_addr=inet_addr("127.99.4.6")}, 16) = -1 EINVAL (Invalid argument)
#
# (a TCP socket connect yields the same error)  -- It's interesting because,
# if you give a different destination address inside of the netns where
# there's just no relevant route set, instead of EINVAL you'll get
# ENETUNREACH.  So that confirms that 127/8 is being treated specially by
# the kernel, seemingly outside of routing table/FIB lookups.


# TODO: It's slightly harder to have tests for TCP, not just ICMP, because
#       the ping responder is in the kernel, while answering TCP via netcat
#       requires a subprocess or subshell.  However this could certainly be
#       done with a subshell, like { echo hello | timeout 2 nc -l 12345; } &
#       or similar.

exit ${result}
