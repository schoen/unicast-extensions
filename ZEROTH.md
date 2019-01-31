# Fixing zeroth addressing

After CIDR rolled out

Is generally restricted to 

made in the early 80s, that made 0 the broadcast address in BSD 4.3. BSD
4.3 has long since been retired and we know of no operating system made
in the last 3 decades that uses '0' for broadcast. Why continue restricting it?

Finding and eliminating the last remaining vestiges of zeroth problems. So far, the "zeroth" problem, is generally limited to some variant "ping", where an attempt to ping the zeroth network address still results in "Did you want to ping broadcast? use -b to specify".

So: fixing ping is not a problem: patches

