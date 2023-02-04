This directory contains patches which are probably not going to be merged
upstream for various reasons (or were not merged upstream in time for
particular software releases), but if you're building a relevant software
version yourself, you can still make use of them.

* 0001-Backport-5.14-lowest-address-is-not-broadcast.patch

This patch is included with Linux 5.14 and later, and makes the lowest
address on an IPv4 segment non-broadcast.  You can apply this version
to a Linux 5.10 LTS kernel (or likely to other kernel versions prior
to 5.14).

* 0001-Don-t-treat-0-8-and-240-4-specially-in-IPv4-classifi.patch

This patch is for use with the BIRD routing daemon, and increases the
extent to which it can support Internet routes within 0/8 and 240/4.
