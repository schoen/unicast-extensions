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

# Tasklist for fixing zeroth

1) Find and eliminate the last remaining vestiges of zeroth problems.

So far, the "zeroth" problem, is generally limited to some variant of "ping", where an attempt to ping the zeroth network address still results in "Did you want to ping broadcast? use -b to specify".

which is a few line patch to every ping and traceroute implementation in
the world. We know of *no* kernel or other usespace application that actually enforces the zeroth problem - just these two utilities.

2) Eliminate the last vestige of "0" from the IPv4 related standards.

3) Encourage IPv4 network operators to use /31 or /32 suballocations and stop using /30 networks (wasting "0").


