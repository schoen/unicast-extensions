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

pingtest(){
test_result=0
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
return $test_result
}

result=0

# Test support for 240/4
pingtest 240.1.2.1 240.1.2.4 24  || result=1
pingtest 250.1.2.1 250.1.2.4 24  || result=1

# Test support for 0/8
pingtest 0.1.2.17 0.1.2.23 24  || result=1

# It should still not be possible to use 0.0.0.0 or 255.255.255.255
# as a unicast address.  Thus, these tests expect failure.
pingtest 0.0.1.5 0.0.0.0 16 && result=1
pingtest 255.255.255.1 255.255.255.255 16 && result=1

# But, even 255.255/16 is OK!
pingtest 255.255.3.1 255.255.50.77 16 || result=1

# Test support for zeroth host
# pingtest 5.10.15.20 5.10.15.0 24  || result=1
# TODO: Let's also have some prefixes other than /24
# TODO: It's slightly harder to have tests for TCP, not just ICMP, because
#       the ping responder is in the kernel, while answering TCP via netcat
#       requires a subprocess or subshell.  However this could certainly be
#       done with a subshell, like { echo hello | timeout 2 nc -l 12345; } &
#       or similar.

exit ${result}
