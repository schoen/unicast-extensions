#!/bin/sh

# This is work in progress toward an eventual submission to the Linux
# selftests (in linux/tools/testing/selftests).  It uses the network
# namespace kernel features (netns) together with virtual Ethernet
# (veth) to create userspace processes that are akin to processes on
# separate machines connected via an Ethernet, a technique used by many
# of the other tests in selftests/net.

# This test must be run as root (to manipulate the network namespaces
# and virtual interfaces).

# TODO: This needs to be updated to match coding style and success/failure
#       reporting conventions of existing network tests.

pingtest(){
result=0
ip netns add foo-ns
ip netns add bar-ns
ip link add foo netns foo-ns type veth peer name bar netns bar-ns
ip netns exec foo-ns ifconfig foo inet $1/$3 || result=1
ip netns exec bar-ns ifconfig bar inet $2/$3 || result=1
ip netns exec foo-ns timeout 2 ping -c 1 $2 || result=1
ip netns exec bar-ns timeout 2 ping -c 1 $1 || result=1
ip netns exec foo-ns arp -n
ip netns exec bar-ns arp -n

ip netns del foo-ns
ip netns del bar-ns
return $result
}

result=0

# Test support for 240/4
pingtest 240.1.2.1 240.1.2.4 24  || result=1
pingtest 250.1.2.1 250.1.2.4 24  || result=1

# Test support for 0/8
pingtest 0.1.2.17 0.1.2.23 24  || result=1

# Test support for zeroth host
pingtest 5.10.15.20 5.10.15.0 24  || result=1
# TODO: Let's also have some prefixes other than /24

exit ${result}
