#!/usr/bin/env python

# Relative reachability: what fraction of devices that can reach host X
# can also reach host Y?  (A relevant example using the machines at
# https://ec2-reachability.amazonaws.com/
# is X = 13.56.63.251, Y = 13.52.0.0, both in Amazon us-west-1.  In
# this case, as both are in the same data center, the only distinguishing
# factor that should* affect reachability is that host Y ends in .0 --
# indeed its host address is the lowest on its network according to the
# subnet prefix mentioned on that page.)

# (* However, they are not reached via the same aggregated route.  AWS
#    notes that 13.53/16 is in Stockholm and 13.54/16 is in Sydney.)
 

# Using https://atlas.ripe.net/ and creating two ping experiments using
# the same set of probes, download the results and provide them as command
# line arguments.

import json
import sys

a = json.load(open(sys.argv[1]))
b = json.load(open(sys.argv[2]))

if len(a) == len(b):
    print("Total probes:", len(a))
else:
    print("Number of participating probes differs!", len(x), "vs.", len(y))

okid = set(x["prb_id"] for x in a if x["rcvd"])
both_success = [y for y in b if y["prb_id"] in okid and y["rcvd"]]
second_fail  = [y for y in b if y["prb_id"] in okid and not y["rcvd"]]

print()
print("Out of", len(okid), "probes with a successful ping in", sys.argv[1])
print(len(both_success), "had a successful ping in", sys.argv[2], "while")
print(len(second_fail), "had only unsuccessful pings.")
print()
print("Unsuccessful pings came from:")
for y in second_fail:
    print("\t",y["prb_id"],y["from"])
