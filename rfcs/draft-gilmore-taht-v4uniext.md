%%%
title = "IPv4 Unicast Extensions"
abbrev = "v4unicast-ext"
updates = [2827, 6890]
ipr = "trust200902"
area = "Internet"
docname = "draft-gilmore-taht-v4uniext"
workgroup = "Internet Area Working Group"
submissiontype = "IETF"
keyword = [""]
#date = 2019-01-30T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "draft-gilmore-taht-v4uniext-01"
stream = "IETF"
status = "bcp"

[[author]]
initials = "J."
surname = "Gilmore"
fullname = "John Gilmore"
#role = "editor"
organization = "Electronic Frontier Foundation"
  [author.address]
  email = "gnu@ietf-id.toad.com"
  phone = "+1 415 221 6524"
  uri = "http://www.toad.com"
  [author.address.postal]
  street = "PO Box 170608-ietf-id"
  city = "San Francisco"
  region = "CA"
  code = "94117"
  country = "USA"
[[author]]
initials = "D."
surname = "Täht"
fullname = "David M. Täht"
#role = "editor"
organization = "TekLibre"
  [author.address]
  email = "dave@taht.net"
  phone = "+1 831 205 9740"
  uri = "http://www.teklibre.com"
[author.address.postal]
  street = "20600 Aldercroft Heights Rd"
  city = "Los Gatos"
  region = "CA"
  code = "95033"
  country = "USA"
%%%

.# Abstract

>Editor's note: This draft has not been submitted to any formal process.  It may
change significantly if it is ever submitted.  You are reading it because we trust you and we value your opinions. Feel free to link, but please do not recirculate it.  Please join us in testing patches and equipment!

Unicast addresses are the most successful and most useful kind of
addresses in the Internet Protocol (IP).  Non-unicast portions have
been allocated greater space than their usage requires, including some
unused portions that have been "reserved for future use" for decades.
Meanwhile, rapid uptake of unicast IPv4 throughout the world has exhausted
the supply of unicast addresses.  New IPv4 users are now regularly charged
US$15 or more per address to reclaim them from older users.

To reduce the barrier to new entrants, keeping the Internet's evolution
open to all, this document extends the unicast address space to include
several hundred million more unicast IPv4 addresses, worth billions
of dollars to end users.  It updates [@!RFC6890] to reclassify these
addresses as globally reachable unicast address space.

Global implementation of these changes requires reprogramming some fraction
of the IPv4-compatible equipment worldwide, a multi-year project that is
not centrally funded nor organized.  We also discuss that transition.

{mainmatter}

# Terminology

The keywords **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL**, when they appear in this document, are to be interpreted as described in [@!RFC2119].

# Introduction

Unicast traffic has been the primary use of IPv4.  Broadcast, multicast,
and reserved IP addresses are only used in tiny niches by comparison.
If IPv4 should evolve in small ways to better meet modern requirements,
it should evolve to provide better support for unicast traffic.

The largest issue with IPv4 unicast traffic today is caused by the
shortage of IPv4 addresses.  This document specifies that all formerly
"reserved for future use" addresses, plus some other non-unicast
addresses that can most easily be reclaimed, should be dedicated for
globally reachable unicast use.

# A brief history of the Internet Addressing models

The Internet Protocol version 4 addressing model started off simple
and has evolved over 40 years.  This Internet-Draft briefly summarizes
that evolution, and proposes that as IPv4 approaches the end of its
design life, significant benefits to the Internet community can ensue
from simplifying a few of the vestigial choices made during that
evolution.

## ARPANET -> IPv4

The Internet Protocol (IP version 4, IPv4) was designed from scratch
as a replacement for the ARPANET [@RFC6529] protocols.  Rather than
enforcing uniformity, it followed the "Catenet Model" [@IEN48] of a
concatenated network of diversely implemented underlying networks,
connected by simple and relatively memoryless gateways.

The IP address, then expressed in x.x.x.x notation, could be used to
specify both a particular network and a Host address on that network.
There were several different classes of IP address, each having
different numbers of bits allocated for the network # and address
within that network.  Class A networks used 8 bits for network # and
allowed 24 bits for address-on-that-network.  The ARPANET addresses
could be encoded into 24 bits.  So, for ARPANET (and some of its
clones), an IP address like 10.2.0.5 would mean network #10, Host #2
on IMP #5.  Host #2 identified a specific physical connector on the
back of the IMP cabinet.

Routers (then known as gateways), hosts, and anybody else could take
an IP address, and figure out the network address on that particular
network by simple algorithm. This worked for ARPANET, SATNET, and
PRNETs.

LANs broke this scheme.  In particular, Ethernet addresses were too
big to be stuffed into even the 24 bits of a class-A IP address.  So
algorithmic translations were not possible with those types of
networks.  That ultimately led to the creation of ARP, and the use of
broadcast capabilities of Ethernets, to implement a mechanism for
doing translations.

By the year 1981, IPv4 had landed as a simple and well-edited
specification in [@RFC0791], [@RFC0792].

The designers improved on ARPANET's addressing [@RFC0635], and the
addressing of several other common networks, with IPv4's 32-bit
address space in [@RFC0760]. The 32-bit address space was chosen as a
compromise; its inability to address all the nodes that would likely
want to use it was known from the start, but resource limitations in
early routers, and development timelines, discouraged the use of
longer addresses, and the IPv4 Internet was considered experimental
and temporary.

The initial IPv4 design designated almost 7/8ths of the possible
addresses as ordinary unicast addresses.  These addresses identified
individual nodes, routers, and interfaces, and could be used as source
and destination addresses of packets designed to be forwarded with
full global reachability, and/or for packets on local area
networks. [@RFC0791; @RFC0796]

Early standards do not use the term "unicast" because it only came to
be used by contrast to multicast and broadcast, which came later in
Internet protocol evolution.  [@RFC0966] is the first to use the word
"unicast", stating: "In this paper, we describe a model of multicast
service we call host groups and propose this model as a way to support
multicast in the DARPA Internet environment.  We argue that it is
feasible to implement this facility as an extension of the existing
'unicast' IP datagram model and mechanism."

1/8th of the 32-bit address space was left as "reserved for future
use", and a few other 256ths were reserved for simple protocol
functions or for future use in [@RFC0791] (section 3.2) and
[@RFC0796].

1/256th of the address space initially reserved for protocol functions
was "network 0".  The IPv4 address 0.0.0.0 was reserved for use only
as a source address by nodes that do not know their own address yet in
[@!RFC1122] (section 3.2.1.3).  Addresses of the form 0.x.y.z were
initially defined only as a source address in an ICMP datagram,
indicating "node number x.y.z on this IPv4 network", by nodes that
know their address on their local network, but do not yet know their
network prefix, in [@RFC0792] (page 19). This usage of 0.x.y.z was
later repealed in [@RFC1122] (section 3.2.2.7), because the original
ICMP-based mechanism for learning the network prefix was unworkable on
many networks such as Ethernet (which have longer addresses that would
not fit into the 24 "node number" bits).  Modern networks use reverse
ARP [@RFC0903] or BOOTP ([@RFC0951])/DHCP ([@RFC2131]) to find their
full 32-bit address and CIDR netmask (and other parameters such as
default gateways).  Eliminating this usage of 0.x.y.z left 16,777,215
addresses in 0.0.0.0/8 unused and reserved for future use.

The other 1/256th of the address space initially reserved for protocol
functions was network 127.  The entire set of 16 million addresses of
the form 127.x.y.z were reserved in [@!RFC1122](section 3.2.1.3) for
"internal host loopback addresses" and "should never appear as a
source or destination address on a network outside of a single
node". When IPv6 was designed in the 1990s, this was seen as
excessive. In [@RFC1884] the single IPv6 loopback address was
defined, but in IPv4, this reservation has continued to the present
day.

The remaining 1/16th of the "EXPERIMENTAL" portion of the address
space has remained reserved and unused [@!RFC1112] (section 4) in the
38 years since 1981. This portion is now called 240/4 in CIDR notation
and contains 268,435,455 addresses.

## Subnetting and broadcast extensions

In 1984, subnets were made part of the IP protocol by [@RFC0917] and
[@RFC0922].

Initially, subnets were only used "locally".  The global Internet
routing infrastructure still only knew how to route to Class A, B, and
C networks.  Local equipment in each such network could route locally
to any local subnets, such as multiple Ethernets on a university
campus.

Also in 1984, broadcast addresses were added to IPv4 by [@RFC0919],
and [@RFC0922]. This required reserving one IPv4 address within each
and every network or subnet (the final address in that network or
subnet, the "all-ones" host address).  The address 255.255.255.255 was
also reserved to make it easier to broadcast on "a local hardware
network" without knowing the details of those networks.  This made
broadcast a useful mechanism for discovering a node's own address on
the network.

The 1984 broadcast extension also reserved the initial (zero) address
in each network or subnet, with [@RFC0919] stating that "There is
probably no reason for such addresses to appear anywhere", with a
now-obsolete exception.  It also, apparently by coincidence,
documented a human writing convention of designating a "network
number" with the zero address, such as 36.0.0.0.  This convention has
confused subsequent protocol users into thinking that the initial
(zero) address in a network or subnet cannot be used as an ordinary
unicast node address.

Before those standards were finalized, one popular IPv4 implementation,
4.2 BSD, used the zero node address for broadcast, rather than the
all-ones node address.  When these mismatched implementations tried to
interoperate on an Ethernet, it was easy to produce "broadcast storms"
that would consume all available network bandwidth until manually
stopped.  The offending implementation was upgraded in the subsequent
4.3 BSD release to meet the standards.  The problem has not recurred
for decades, but a remnant of the gaffe exists in the prohibition in
[@!RFC1122] (section 3.2.2.7) on using the zero node address in a
network or subnet.

## Multicast

Later (1988) designers chose to allocate 1/16th of the total space
(half of the formerly reserved space) for multicast use in
[@!RFC1112].  While multicast was a much better idea than the sole
similar former option (broadcast), its use on anything besides local
area networks has remained a tiny niche, in retrospect clearly not
worth designating 1/16th of the entire address space for.  This
address space is called 224/4 in Phil Karn's more modern CIDR
[@RFC4632] notation.

By 1989, the revisions to the basic Internet Protocol suite required
reading dozens and dozens of documents.  The basic requirements for
Internet hosts and gateways were then consolidated into
[@RFC1022;@RFC1023;@RFC1024].

## CIDR and NAT

By 1992, the original network addressing and routing architecture was
straining at the seams.  The problems were "the lack of a network
class of a size which is appropriate for mid-sized organization[s]",
growth of routing tables beyond available capacities, and the
"eventual exhaustion of the 32-bit IP address space" as documented in
[@RFC1338]. After a convincing extrapolation that Class-B space would
be exhausted by mid-1994 [@IETF-13], the ROAD working group was
formed.

Their proposed fixes involved an extension of subnetting to
"supernetting" multiple Class C networks, deploying classless routing
protocols, and generally deprecating the concept of "network address
classes".  Each network address would be represented by a "pair": an
address and a mask.  This proposal reserved the address 0.0.0.0 with
mask 0.0.0.0 as the "default route" with special rules.  This was
adopted in 1993 as Classless Inter-Domain Routing (CIDR) for Class C,
and half of Class A (a quarter of the entire Internet address space)
was reserved for future subnetting after deployment of more capable
routing protocols by [@RFC1466], [@RFC1518], [@RFC1519].

In 1994, NAT [@RFC1631] also appeared as an interim solution to
address depletion.

By 1995, the implementation of subnetting for "Class A" addresses
proved sufficiently buggy that the IANA began a global experiment by
allocating 256 subnetted Class A addresses to *every* existing address
space user, and encouraging them to be used to verify correct
operation of their gateways and hosts, in [@RFC1797]. Even in 1996,
[@RFC2036] described that large parts of the Internet could not
correctly subnet Class A addresses.

## IPv6 address extension

IPv6 was first standardized in 1995 [@RFC1883], and refined by many
successive RFCs, currently culminating in [@RFC8200]. It has an 128 bit
address space.

## IPv4 Address exhaustion

In 2011, IPv4 address exhaustion happened, on schedule. Demand for
IPv4 and IPv6 to IPv4 translation technologies spiked, leveraging
[@RFC1918], with CGNS ([@RFC7289]), DS-Lite ([@RFC6333]), and
 464XLAT ([@RFC6877]) becoming widely adopted.  While each of these
solutions is inadequate in their own way, and pure IPv6 is superior,
the need for IPv4 address space appears unslakeable for the next 20
years.

Although a market has appeared for existing IPv4 allocations, and
small amounts of address space returned to the global pools, demand
for IPv4 addressing continues unabated. New edge and data center
technologies are creating new demands, and internet-accessible servers
will need to be dual stacked for a long time to come.

In 2008 [@I-D.fuller-240space], and 2010 [@I-D.wilson-class-e] first
proposed that the 240/4 address space become usable - the first draft
mandating no explicit use; the second, as "private" RFC1918-like
addresses.  Neither of these drafts became Internet Standards, yet the
network community generally implemented them in major operating
systems anyway.  Few people have noticed, since there was and still is
no straightforward way to have such an IPv4 address block globally
allocated for your network.

Treating 240/4 as globally reachable unicast is now a de facto standard,
with support in all the major operating systems except Microsoft Windows,
and only a few edge cases left to fix.

240/4 and the additional address blocks outlined in this document can become
viable unicast address blocks.

This Internet-Draft proposes that all implementers should make the
small changes required to receive, transmit, and forward packets that
contain addresses in these blocks as if they were within any other
unicast address block.

It is envisioned that the utility of these blocks will grow over time.
Some devices may never be able to use them as their IP implementations
have no update mechanism.

# Unicast use of address space formerly reserved for future use

The attributes of blocks of address space are described by the IANA and
in IETF publications by structured, boxed tables; see [@!RFC6890].
This document proposes replacing the former description tables of these
blocks, with those included in this document.

## Unicast use of Class-E address space

These new unicast addresses, 240.0.0.0 through 255.255.255.254, replace
the Class E address space, which was formerly reserved (by [@!RFC1112]).
This document updates [@!RFC6890], table 15.

{#fig-240}
           +----------------------+----------------------------+
           | Attribute            | Value                      |
           +----------------------+----------------------------+
           | Address Block        | 240.0.0.0/4                |
           |                      | (except 255.255.255.255)   |
           | Name                 | Ordinary Unicast Addresses |
           | RFC                  | This Internet-Draft        |
           | Allocation Date      | 2019                       |
           | Termination Date     | N/A                        |
           | Source               | True                       |
           | Destination          | True                       |
           | Forwardable          | True                       |
           | Globally Reachable   | True                       |
           | Reserved-by-Protocol | False                      |
           +----------------------+----------------------------+

The broadcast address, 255.255.255.255, still must be treated
specially: it is invalid as a source IP address, and it is invalid as
a network interface address. When used as the destination in a
datagram sent by a node, it causes the packet to be broadcast on one
of the hardware networks directly accessible to the node.  This
behavior is unchanged from previously specified behavior in
[@!RFC6890], table 16, e.g.:

{#fig-255}
          +----------------------+----------------------------+
          | Attribute            | Value                      |
          +----------------------+----------------------------+
          | Address Block        | 255.255.255.255/32         |
          | Name                 | Limited Broadcast          |
          | RFC                  | RFC919                     |
          | Allocation Date      | 1984                       |
          | Termination Date     | N/A                        |
          | Source               | False                      |
          | Destination          | True                       |
          | Forwardable          | False                      |
          | Globally Reachable   | False                      |
          | Reserved-by-Protocol | True                       |
          +----------------------+----------------------------+

## Unicast use of 0/8

These new unicast addresses, 0.0.0.1 through 0.255.255.255, replace the
obsolete "This host on this network" concept from [@RFC0791],
replacing table 1 of [@!RFC6890].

{#fig-0}
           +----------------------+----------------------------+
           | Attribute            | Value                      |
           +----------------------+----------------------------+
           | Address Block        | 0.0.0.0/8                  |
           |                      | (except 0.0.0.0)           |
           | Name                 | Ordinary Unicast Addresses |
           | RFC                  | This Internet-Draft        |
           | Allocation Date      | 2019                       |
           | Termination Date     | N/A                        |
           | Source               | True                       |
           | Destination          | True                       |
           | Forwardable          | True                       |
           | Globally Reachable   | True                       |
           | Reserved-by-Protocol | False                      |
           +----------------------+----------------------------+

The Unknown Local Address, 0.0.0.0, still must be treated specially:
it is usable only as a source IP address, and only in nodes that do not
know or have an IPv4 address on the network where the packet appears; it
is invalid as a network interface address.  Typically, such an address
is used as the source address in a UDP-based protocol like BOOTP or
DHCP to ask another node to supply this node with a usable address.
This behavior is unchanged from previously specified behavior.

(IGMP [@RFC4541] also uses 0.0.0.0 in an address field in some of its
payload, for unrelated functions; these are also unchanged.)

{#fig-0000}
          +----------------------+----------------------------+
          | Attribute            | Value                      |
          +----------------------+----------------------------+
          | Address Block        | 0.0.0.0/32                 |
          | Name                 | Unknown Local Address      |
          | RFC                  | This Internet-Draft        |
          | Allocation Date      | 1981                       |
          | Termination Date     | N/A                        |
          | Source               | True                       |
          | Destination          | False                      |
          | Forwardable          | False                      |
          | Globally Reachable   | False                      |
          | Reserved-by-Protocol | True                       |
          +----------------------+----------------------------+

# Unicast use of address spaces formerly reserved for other functions

## Unicast use of 127/8

These new unicast addresses, 127.1.0.0 through 127.255.255.255, replace
more than 99% of the former reserved Loopback address space, updating
table 4 of [@!RFC6890].

{#fig-127-8}
           +----------------------+----------------------------+
           | Attribute            | Value                      |
           +----------------------+----------------------------+
           | Address Block        | 127.0.0.0/8                |
           |                      | (except 127.0.0.0/16)      |
           | Name                 | Ordinary Unicast Addresses |
           | RFC                  | This Internet-Draft        |
           | Allocation Date      | 2019                       |
           | Termination Date     | N/A                        |
           | Source               | True                       |
           | Destination          | True                       |
           | Forwardable          | True                       |
           | Globally Reachable   | True                       |
           | Reserved-by-Protocol | False                      |
           +----------------------+----------------------------+

To the extent that any existing users had special uses for some small
subsets of this space, those subsets may be allocated to those users by
administrative action of IANA.

A smaller set of Loopback Addresses, 127.0.0.0 through 127.0.255.255,
still must be treated specially: they are usable only as a destination
IP address; they are invalid as a network interface address; and when
used as a destination address in a packet, the packet is received
and consumed only by the current node.  Typically, such an address is
used when communicating with another process on this particular node.
Multiple addresses are provided, and can be distinguished by recipient
processes, to accommodate historical use patterns.  This behavior is
unchanged from previously specified behavior, though it now only applies
to 65,536 addresses rather than to 16,777,216 addresses.

{#fig-127-16}
          +----------------------+----------------------------+
          | Attribute            | Value                      |
          +----------------------+----------------------------+
          | Address Block        | 127.0.0.0/16               |
          | Name                 | Loopback Addresses         |
          | RFC                  | This Internet-Draft        |
          | Allocation Date      | 1981                       |
          | Termination Date     | N/A                        |
          | Source               | False                      |
          | Destination          | True                       |
          | Forwardable          | False                      |
          | Globally Reachable   | False                      |
          | Reserved-by-Protocol | True                       |
          +----------------------+----------------------------+

## Unicast re-use of former Class D (multicast) address space

These new unicast addresses, 225.0.0.0 through 231.255.255.255, replace
more than 40% of the address space formerly reserved for future
Multicast use.

{#fig-class-d-uni}
           +----------------------+----------------------------+
           | Attribute            | Value                      |
           +----------------------+----------------------------+
           | Address Block        | 225.0.0.0/8 - 231.0.0.0/8  |
           | Name                 | Ordinary Unicast Addresses |
           | RFC                  | This Internet-Draft        |
           | Allocation Date      | 2019                       |
           | Termination Date     | N/A                        |
           | Source               | True                       |
           | Destination          | True                       |
           | Forwardable          | True                       |
           | Globally Reachable   | True                       |
           | Reserved-by-Protocol | False                      |
           +----------------------+----------------------------+

The principal Multicast Addresses, 224.0.0.0 through 224.255.255.255,
still must be treated specially.  They are only usable as a
destination address; they are invalid as a network interface address;
and when used as a destination address in a packet, the packet is sent
to zero or more attached networks by using lower level network
multicast capabilities that allow it to be received by multiple nodes
on those networks.

Multiple addresses are provided, and can be distinguished by recipient
processes, to accommodate historical use patterns.  This behavior is
unchanged from previously specified behavior, though it now only
applies to 150,994,944 addresses rather than to 268,435,456 addresses.

{#fig-class-d-multi}
          +----------------------+----------------------------+
          | Attribute            | Value                      |
          +----------------------+----------------------------+
          | Address Block        | 224.0.0.0/8                |
          | Name                 | Multicast Addresses        |
          | RFC                  | RFC1112                    |
          | Allocation Date      | 1989                       |
          | Termination Date     | N/A                        |
          | Source               | True                       |
          | Destination          | True                       |
          | Forwardable          | True                       |
          | Globally Reachable   | True                       |
          | Reserved-by-Protocol | True                       |
          +----------------------+----------------------------+

Multiple other multicast address spaces have fallen into disuse, and a
discussion of possibilities for their re-use will take place in another
document.

# Unicast use of formerly reserved per-network node addresses

In order to extend the usable unicast addresses in every existing subnet,
this document redefines the zeroth address of each subnet, and also
redefines the final address in subnets that do not support broadcasting.
These changes reduce the wastage of address space by allowing these
formerly-reserved addresses to be used as ordinary unicast addresses.

For example, a /29 network that formerly allowed 6 unique interface
addresses on an Ethernet can now use 7.  A /31 network that formerly
allowed no unique interface addresses at all can be used for the two
interfaces in a point-to-point network as per [@!RFC3021]. 

## Unicast use of the zero node address in each network or subnet

The zeroth network address of any given network MUST be a fully
addressable, globally reachable, unicast, interface address on that
network.

As a minor exception, now that 0/8 is designated as global unicast
space, it is possible to define a network whose zeroth address overlaps
the reserved address 0.0.0.0.  Such a network does not have a fully
addressable, globally reachable, unicast zeroth address, because 0.0.0.0
is always reserved and always has its reserved meaning.  For example,
despite the preceding paragraph, network 0.0.0.0/24 only includes 253
usable addresses, starting from 0.0.0.1 and ending at 0.0.0.254.

When configuring or describing the IPv4 address of an interface on a
network, the full 32-bit interface address is traditionally used along
with the CIDR network mask.  For example, interface 37 on a network
with a 24-bit prefix could be configured as 198.51.100.37/24.  When the
zeroth address is in use at a host as a network interface, that interface
should be configured in the identical way, as e.g. 198.51.100.0/24.
This usage does not conflict with the informal usage of 198.51.100.0/24
to refer to the entire network whose addresses range from 198.51.100.0
through 198.51.100.255.

## Unicast use of the all-ones node address in each point-to-point network

The final network address of any given network that supports broadcasting
has traditionally been used as the broadcast address on that network.
(The final address is also referred to as the "all-ones" address, since
all of the bits after the network prefix are all one-bits.)  This usage
remains unchanged.

This document clarifies that, on networks which do not support
broadcasting, the final network address MUST be an ordinary, fully
addressable, globally reachable unicast address.  In particular, on
point-to-point networks that only contain two interfaces, such as one
running the Point-to-Point Protocol ([@RFC1331]), the zeroth address
and the final address SHOULD be configured as the addresses of the two
interfaces, thus only requiring a /31 network prefix.

As a minor exception, now that 255/8 is designated as global unicast
space, it is possible to define a network whose final address overlaps
the reserved address 255.255.255.255.  Such a network does not have a
final all-ones address, because 255.255.255.255 is reserved.  So, for
example, there is no way to address a broadcast to the entire network
255.255.0.0/16; and the all-ones address on a point-to-point network
at 255.255.255.252/30 does not refer to an interface on that network.
The address 255.255.255.255 MUST always be treated as the reserved
"Local Broadcast" address, which could cause a broadcast packet to be
sent on any interface on the local node (not necessarily on the network
that includes the address 255.255.255.254).

# Issues

This document does not presently go into all the possible issues with
these reallocations.  As with any specification change, there will
be interoperability issues between nodes which follow the original
specification, and nodes which follow the changed specification.

## Long Deployment Tail

With sufficient thrust, [@RFC1925], pigs can fly. 

## Interoperation with un-extended nodes

This document seeks to minimize the operational impact of those issues,
by only allocating new unicast addresses from addresses that were not
in use on the global Internet. 

In nearly all cases a node without support for these address spaces,
will simply fail to assign, forward, or reach them.

The most usual failure mode when these new unicast addresses are used,
is simply a failure to communicate with nodes that follow the original
specification, because the original nodes check for and refuse to allow
such addresses.  As these nodes go out of service, or are gradually
replaced or upgraded, these addresses will become usable in more and
more applications.

On the other hand, the new unicast addresses may be immediately
usable in new applications, where interoperation with legacy nodes
is not an issue.

Reallocation of the former multicast addresses as unicast can cause
unique issues, since unmodified nodes will transmit to such destination
addresses by using link-level multicast packets, while extended nodes
will use link-level unicast packets.  The full implications of this
issue have not yet been explored.

## Martians lists, bogons and BCP38

[@RFC3704] states:

> [@!RFC2827] recommends that ISPs police their customers' traffic by
> dropping traffic entering their networks that is coming from a source
> address not legitimately in use by the customer network.  The
> filtering includes but is in no way limited to the traffic whose
> source address is a so-called "Martian Address" - an address that is
> reserved [3], including any address within 0.0.0.0/8, 10.0.0.0/8,
> 127.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 224.0.0.0/4, or
> 240.0.0.0/4.

ISPs that filter their customers' traffic based on source address MUST
NOT discard traffic solely because it has a source addresses in the
ranges 0.0.0.0/8, 240.0.0.0/4, 127.0.0.0/8, and 225.0.0.0/8 through
231.0.0.0/8, except the addresses 0.0.0.0, 255.255.255.255, and the
loopback addresses 127.0.0.0/16.  However, if a customer network has
not been allocated a source address in these ranges, then they can be
filtered out as attempts to spoof someone else's network.

No ISP filter should ever discard datagrams based on destination
addresses within these newly extended unicast ranges.

The only remaining Martian addresses now include:

* 0.0.0.0/32
* 100.64.0.0/10
* 10.0.0.0/8
* 127.0.0.0/16
* 172.16.0.0/12
* 169.254.0.0/16
* 192.0.0.0/24
* 192.0.2.0/24
* 192.168.0.0/16
* 198.18.0.0/15
* 198.51.100.0/24
* 203.0.113.0/24
* 224.0.0.0/8
* 232.0.0.0/5
* 255.255.255.255/32

Firewalls [@CBR03], packet filters, and intrusion detection systems,
MUST be capable of monitoring and managing the newly extended unicast
addresses.

Routing protocols MUST treat the newly extended unicast addresses
as unicast, globally reachable addresses.

# Implementation status

## Address Range: 0/8

No implementation is currently known to allow the unicast use of 0/8.
However, small Linux and FreeBSD kernel patches provide this function.

## Address Range: 127/8

All implementations currently allow the use of 127/8 for local traffic, however
they do not allow its use for globally routable unicast traffic. 
There are preliminary Linux and FreeBSD kernel patches to restrict
the "local" requirement of the existing specification to 127.0/16 and permit
globally routable unicast traffic in the rest of 127/8.
NTP uses 127.127 for the clock interface, and several chassis control systems
have been found that use an address in the 127 range.
 
In addition, system configuration scripts that configure
the internal "loopback interface" probably need modification.

## Address Range: 225/8 through 231/8

No implementation is currently known to allow the unicast use of 225/8 - 231/8.
Some bridges (usually wifi) are known to convert multicast in all ranges to
unicast. Converting these spaces to unicast beforehand has thus far been
observed to cause no problems.

Small Linux and FreeBSD kernel patches provide this extension.

## Address Range: 240/4

The following operating systems support the use of 240.0.0.0/4 as
unicast, globally reachable address space: Solaris, Linux, Android,
Apple OSX, Apple IOS, and FreeBSD.  This support has existed since
approximately 2008. There are some issues with parts of BSD network
stack that treat Class-E addresses as "invalid". There are also cases of
translation (NAT64) where checks reject Class-E addresses and need small
fixes. In both cases we have the patches under review for FreeBSD.
Four out of the top 5 open source IoT stacks already treat 240/4 as
unicast, with a 3 line patch awaiting submission for the fifth.

Some deployments of the BIND Domain Name System implementation
(e.g. Debian) override the reverse DNS for 255.in-addr.arpa. with a
local empty domain, and do not forward requests for those addresses.
These packages will require revision.

Recent versions of Microsoft Windows will not accept nor forward any
packet with either a source or destination address in 240/4.  Nor will
they assign an interface address in this range, if one is offered via
DHCP.  No plans have been announced for modifications to any version of
Microsoft Windows.  Windows developers are aware of the work required,
and are considering it for a future version.

Juniper routers block traffic for 240/4 by default, but there has been a simple
configuration switch to disable that check since 2010, at which point they are fully functional.

Some cisco routers can assign and route 240/4, most don't.

## Routing to extended unicast networks

The reaction of free software routing applications to receiving
routing updates that include the extended unicast addresses is as yet
somewhat undetermined.

Cisco and Juniper routers' reaction to seeing routing updates that
include the extended unicast addresses is as yet undetermined.

The [@RFC6126] Babel routing protocol and its primary implementation
fully supports unicast 240/4. 

Patches for allowing unicast 240/4 routes have been submitted to the
BGP/OSPF/ISIS capable routing daemon projects, "Bird", and "FRR".
However, there may be interoperability issues with unmodified daemons.

All we have observed is an increase in logfile messages, no session drops,
no crashes, for as-yet unpatched routing daemons.

## Zeroth and final addresses in subnets

The specific configuration of a distant subnet is not generally known to
a node that is sending traffic to an address in that subnet.  The sender
does not know the network mask of the destination subnet, so it cannot
prohibit sending packets to the zeroth or final addresses in that subnet.
Therefore, the main issue is not with distant nodes that communicate
with these addresses, which should work without trouble, but with local
area network equipment that does know the subnet address mask.

Informally, most operating systems and networking equipment already supports
the use of the zeroth address as a unicast address.

Informally, most operating systems and networking equipment already supports
the use of the final address in a point-to-point network as a unicast address.

# Related Work

The last previous attempts at making more unicast IPv4 address space
occurred in 2008-2010, with proposals for making 240/4 into pure
public routable unicast [@I-D.fuller-240space], or routable, but
private, RFC1918 style unicast address space
[@I-D.wilson-class-e]. Neither proposal gained rough consensus in the
IETF.  However, "running code" - making 240/4 actually work - was
almost universally adopted in the field.

It is presently unknown if any organization is making local or global
use on the network of 240/4, 0/8, 127/8, or any of the reserved portions
of multicast now re-assigned to unicast.  A network telescope study of
existing traffic is planned.

# IANA Considerations

Although this document requires implementations to treat these addresses
the same as any other unicast addresses, it does not determine how
these addresses will be administratively allocated to Internet users.

240.0.0.0/4 and 0.0.0.0/8 move from the "special purpose" registry (https://www.iana.org/assignments/iana-ipv4-special-registry/iana-ipv4-special-registry.xhtml) and are added to the regular "ipv4-address-space" registry (
https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.xhtml)

0.0.0.0/32 and 127.0.0.0/16 should be added to the special purpose registry.

In the ipv4-address-space registry, 240/4 should be moved from
future use to unallocated, and 225/8 - 231/8 should be moved from
multicast to unallocated. 127.1.0.0/16 and up should be added.

IANA is also requested to prepare the these address spaces to be
available as reverse DNS space in in-addr.arpa.

# Security Considerations

Presently access to the 240/4 and 0/8 blocks are mostly assumed to be
managed somewhere along the edge of the network, and wider
availability merely requires removal of this space from common bogon
lists and hard coded martian files. In many other cases it will "just
work", but thought needs to be given to any additional security
exposures to existing firewalled networks.

Address space in the localnet and multicast blocks are also primarily
assumed to be managed elsewhere in the network, and subject to the
same bogon filter and martian list fixes.

# Acknowledgements

Jason Ackley, John Perry Barlow, Brian Carpenter, Vint Cerf,
Kevin Darbyshire-Bryant, Vince Fuller, Stephen Hemminger, Geoff Huston,
Rob Landley, Eliot Lear, Dan Mahoney, and Paul Wouters all made contributions
to this document, directly or indirectly. Thanks also to the members of the
internet history mailing list [@IHML] for helping get the early
details straight.

{backmatter}

<reference anchor='IPv4CLEANUP' target='https://github.com/dtaht/ipv4-cleanup'>
<front>
<title>IPv4 cleanup project</title>
<author initials='D.' surname='Taht' fullname='Dave Taht'>
<address>
<email>dave@taht.net</email>
</address>
</author>
<date year='2019' />
</front>
<format type='HTML' target='https://github.com/dtaht/ipv4-cleanup' />
</reference>

<reference anchor='IETF-13' target='https://www.ietf.org/proceedings/13.pdf'>
<front>
<title>IETF Proceedings</title>
<author initials='P.' surname='Gross' fullname='Phill Gross'>
</author>
<author initials='K.L' surname='Bowers' fullname='Karen Bowers'>
</author>
<date year='1989' />
</front>
<abstract>
<t>
</t></abstract><format type='PDF' octets='' target='https://www.ietf.org/proceedings/13.pdf' />
</reference>

<reference anchor='IHML' target='http://mailman.postel.org/pipermail/internet-history/2019-February/004865.html'>
<front>
<title>Internet History Mailing list</title>
<author initials='T.' surname='Many' fullname='Too Many'>
</author>
<date year='2019' />
</front>

<format type='HTML' target='http://mailman.postel.org/pipermail/internet-history/2019-February/004865.html' />
</reference>

<reference anchor='CBR03' target=''>
 <front>
 <title>Firewalls and Internet Security: Repelling the Wily Hacker, Second Edition</title>
  <author initials='W.R.' surname='Cheswick' fullname='Bill Cheswick'></author>
$  <author initials='S.M.' surname='Bellovin' fullname='Steve Bellovin'></author>
  <author initials='A.D.' surname='Rubin' fullname='Avi Rubin'></author>
  <date year='2003' />
 </front>
 <seriesInfo name="Addison-Wesley" value='' />
 </reference>


<reference anchor='IEN48' target='http://www.postel.org/ien/pdf/ien048.pdf'>
 <front>
 <title>The CATENET MODEL FOR INTERNETWORKING</title>
  <author initials='V.' surname='Cerf' fullname='Vint Cerf'></author>
  <date year='1978' />
 </front>
 </reference>

