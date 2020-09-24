# Fixing zeroth addressing

## Background

The original IPv4 design was a 32 bit "address extension" to the existing
ARPANET design, which was only 8 bits. Things like "this" network were
"0", and "this machine", 127, and these arbitrary abstractions were carried
forth into the IPv4 rollout.

The "broadcast address" was not well defined. Some thought it should be zero
others, 255, and thus a few years of confusion reigned.

## 0 as broadcast

This was a mistake made in the early 80s, that made 0 the broadcast address in BSD 4.3. BSD 4.3 has long since been retired and we know of no operating system made in the last 3 decades that uses '0' for broadcast. Why continue restricting it?

## Tasklist for fixing zeroth

1) Find and eliminate the last remaining vestiges of zeroth problems.

Contrary to the statement previous version of this file, Linux requires a (tiny) kernel patch to stop enforcing this. After that, it works in Linux 5.4.0 for all purposes tested so far. The fact that it was implemented in the kernel means we'll also need to check on other operating systems.

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
treat the 0 form of broadcast address specially.

3) Encourage IPv4 network operators to use /31 or /32 suballocations and stop using /30 networks (wasting "0").


