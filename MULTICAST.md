# What's wrong with IPv4 multicast?

Thin layer above the MAC that translates a 224/4 address into a multicast
request. Converting the former RESERVED range (225-232) into unicast requests

While multicast is a needed, *essential* feature of any modern network, it
is rarely used for anything besides configuration and initial services
discovery. Reserving 268 million addresses for it is a waste.

* there are no restrictions on converting a multicast address into a multicast


