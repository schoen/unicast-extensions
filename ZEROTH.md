# Making the lowest address usable

## Background

The original IPv4 design was a 32 bit "address extension" to the existing
ARPANET design, which was only 8 bits. Unfortunately, not all special cases
were initially defined in IPv4, and when they were subsequently added, they
were often defined in wasteful ways (for instance, the entire 127/8 network
as loopback, or the entire 0/8 network as "unspecified").

The "segment-directed broadcast address" was also not well-defined. Some
thought it should be zero, others, 255, and thus a few years of confusion
reigned.

## 0 as broadcast

This was a mistake made in the early 80s, that made 0 (as the "host part" of an IP address) the broadcast address in 4.2BSD. 4.2BSD has long since been retired and we know of no operating system made in the last 3 decades that uses '0' for broadcast. Why continue restricting it?

## Tasklist for fixing lowest address

1) Find and eliminate the last remaining vestiges of lowest address problems.

Contrary to the statement in a previous version of this file, Linux requires a (tiny) kernel patch to stop enforcing this. After that, it works in Linux 5.4.0 for all purposes tested so far (including routing and DHCP). The fact that it was implemented in the kernel means we'll also need to check on other operating systems, although the best case is that they follow existing standards by ignoring non-broadcast uses of the lowest address. In that case, they won't interoperate on the local segment with a patched machine numbered with this address, but they'll simply ignore it, without any other harm done.

Almost all systems already interoperate with "distant" (non-local-segment) lowest-address-numbered hosts elsewhere on the Internet; since they can't see inside of distant networks to determine how they are subnetted, they can't even tell, and standards don't expect (or even permit) them to treat these addresses any differently when they occur elsewhere.

2) Eliminate the last vestige of "0" from the IPv4 related standards.

RFC 1122 says (footnote style edited):

         There is a class of hosts¹ that use non-standard broadcast
         address forms, substituting 0 for -1.  All hosts SHOULD
         recognize and accept any of these non-standard broadcast
         addresses as the destination address of an incoming datagram.
         A host MAY optionally have a configuration option to choose the
         0 or the -1 form of broadcast address, for each physical
         interface, but this option SHOULD default to the standard (-1)
         form.

  ¹ 4.2BSD Unix and its derivatives, but not 4.3BSD.

This should be updated with an RFC that says that the only form of
broadcast address is the standard (-1) form, and hosts SHOULD not
treat the 0 form of broadcast address specially. We have a draft I-D
for this.
