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

The set of unicast addresses is the largest and most useful block of
addresses in the Internet Protocol (IP).  Some portions of the IP
address space have been "reserved for future use" for decades. The
future has arrived.

This memo updates [@!RFC6890], reclassifying multiple underused
address blocks as globally routable unicast address space.

{mainmatter}

# Terminology

The keywords **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL**, when they appear in this document, are to be interpreted as described in [@!RFC2119].

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
address space in [@RFC0760]. The 32-bit address space was clearly
chosen as a compromise; its inability to address all the nodes that
would likely want to use it was known from the start, but resource
limitations in early routers discouraged the use of longer addresses,
and the IPv4 Internet was considered experimental and temporary.

The initial IPv4 design designated almost 7/8ths of the possible
addresses as Unicast addresses.  These addresses identified individual
nodes and routers, and could be used as source and destination addresses
of packets designed to be forwarded with full global reachability,
and/or for packets on local area networks. [@RFC0791; @RFC0796] The
term "unicast" only came into use when multicast was invented for the
Internet protocol in 1985.  Initially ALL the existing non-reserved IP
addresses were, by default, unicast addresses in [@RFC0966].

1/8th of the 32-bit address space was left as "reserved for future
use", and a few other 256ths were reserved for simple protocol
functions or for future use in [@RFC0791] (section 3.2) and [@RFC0796].

1/256th of the address space initially reserved for protocol functions
was "network 0". "0" was originally an ARPAnet network address for
control messages. The IPv4 address 0.0.0.0 was reserved for use only
as a source address by nodes that do not know their own address yet in
[@!RFC1122] (section 3.2.1.3). Addresses of the form 0.x.y.z were
initially defined only as a source address for "node number x.y.z on
THIS NETWORK" by nodes that know their address on their local network,
but do not yet know their network prefix in [@RFC0972] (pg 19). This
requirement was later repealed in [@RFC1122] (section 3.2.2.7) because
the expected ICMP-based mechanism for learning the network prefix had
turned out to be unworkable and had been replaced by reverse ARP
[@RFC0903], and BOOTP ([@RFC0951]). This change left 16 million
addresses in 0.0.0.0/8 reserved for future use.

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
(half of the formerly reserved space) for multicast use in [@!RFC1112].
While multicast was a much better idea than the sole similar former
option (broadcast), its use on anything besides local area networks
has remained a tiny niche, in retrospect clearly not worth designating
1/16th of the entire address space for.  This address space is called
224/4 in Phil Karn's more modern CIDR [@RFC4632] notation.

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

Treating 240/4 as routable unicast is now a de facto standard, with
support in all the major operating systems except Windows, and only a
few edge cases left to fix.

240/4 and the additional address blocks outlined in this memo can become
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

These new Unicast addresses, 240.0.0.0 through 255.255.255.254,
replace the formerly reserved (by [@!RFC1112]) Class E address space,
and updates [@!RFC6890], table 15.

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
           | Global               | True                       |
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
          | Global               | False                      |
          | Reserved-by-Protocol | True                       |
          +----------------------+----------------------------+

## Unicast use of 0/8

These new Unicast addresses, 0.0.0.1 thru 0.255.255.255, replace the
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
           | Global               | True                       |
           | Reserved-by-Protocol | False                      |
           +----------------------+----------------------------+

The Unknown Local Address, 0.0.0.0, still must be treated specially:
it is usable only as a source IP address, and only in nodes that do
not know or have an IPv4 address on the network where the packet
appears; it is invalid as a network interface address.  Typically,
such an address is used when using a UDP-based protocol like BOOTP,
DHCP, or IGMP [@RFC4541] to ask another node to supply this node with
a usable address.  This behavior is unchanged from previously
specified behavior.

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
          | Global               | False                      |
          | Reserved-by-Protocol | True                       |
          +----------------------+----------------------------+

# Unicast use of address spaces formerly reserved for other functions

## Unicast use of 127/8

These new Unicast addresses, 127.1.0.0 thru 127.255.255.255, replace
more than 99% of the former reserved Loopback address space, and
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
           | Global               | True                       |
           | Reserved-by-Protocol | False                      |
           +----------------------+----------------------------+

The Loopback Addresses, 127.0.0.0 through 127.0.255.255, still must be
treated specially: they are usable only as a destination IP address;
they are invalid as a network interface address; and when used as a
destination address in a packet, the packet is received and consumed
only by the current node.  Typically, such an address is used when
communicating with another process on this particular node.  Multiple
addresses are provided, and can be distinguished by recipient processes,
to accommodate historical use patterns.  This behavior is unchanged
from previously specified behavior, though it now only applies to 65,536
addresses rather than to 16,777,216 addresses.

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
          | Global               | False                      |
          | Reserved-by-Protocol | True                       |
          +----------------------+----------------------------+

## Unicast re-use of former Class D (multicast) address space

These new Unicast addresses, 225.0.0.0 thru 231.255.255.255, replace
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
           | Global               | True                       |
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
          | Global               | True                       |
          | Reserved-by-Protocol | True                       |
          +----------------------+----------------------------+

Multiple other multicast address spaces have fallen into disuse,
a discussion of their re-use will take place in another document.

# Unicast use of formerly reserved per-network node addresses

## Unicast use of the zero node address in each network or subnet

The zeroth network address of any given CIDR network MUST be a fully
addressible, unicast, portion of that network, with the exception
of 0.0.0.0/32.

## Unicast use of the all-ones node address in each point-to-point network

255.255.255.255/32 MUST always be treated as broadcast.

# Issues

This document does not presently go into all the possible issues with
these reallocations. Prior documents conflate the end-purpose of these
IP addresses without mandating the simple requirement that they be
unicast and routable.

## Long Deployment Tail

With sufficient thrust, [@RFC1925], pigs can fly. 

## Interoperation with un-extended nodes

In nearly all cases a node without support for these address spaces,
will simply fail to assign, forward, or reach them.

Some potential for incorrect operation exists with the multicast
space re-allocation.

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

This memo removes 0.0.0.0/8, 240.0.0.0/4, 127.0.0.0/8, and
225.0.0.0/8-231.0.0.0/8 from the martian address spaces.

Martian addresses will now include:

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
MUST be upgraded to be capable of monitoring and managing these
addresses.

Routing protocols MUST treat these as unicast, globally routable
addresses.

## Enable Reverse DNS for 255.0.0.0/8

Common deployments of the BIND routing daemon (e.g. Debian) map reverse DNS for 255. to a local empty domain and do not forward requests for that to in-addr.arpa. The daemon itself does not have such a limit, with modern versions correctly intercepting 255.255.255.255 only.

# Implementation status

As of the release of the first version of this draft, Apple OSX and
Apple IOS have been confirmed to support the use of 240.0.0.0/4 as
unicast, globally reachable address space. Solaris, Linux, Android,
and FreeBSD all treat it as such, also. These operating systems have
supported 240/4 since 2008. Four out of the top 5 open source IoT
stacks, also treat 240/4 as unicast, with a 3 line patch awaiting
submission for the last. The [@RFC6126] Babel routing protocol fully
supports 240/4, and patches have been submitted to the
BGP/OSPF/ISIS capable routing daemon projects, "Bird", and "FRR".

No plans have been announced for modifications to any version of
Microsoft Windows, however Windows developers are aware of the work
required and are considering it for a future version.

Patches are available for Linux for the other address spaces.

# Related Work

The last attempts at making more IPv4 address space occurred in the
2008-2010 timeframe, with proposals for making it pure public routable
unicast [@I-D.fuller-240space], or routable, but private, RFC1918 style
address space [@I-D.wilson-class-e]. Neither proposal gained traction in the
IETF, however the first step - making 240/4 actually work - was almost
universally adopted in the field.

It is presently unknown if any organization is making use of 240/4,
0/8, or any of the reserved portions of multicast now re-assigned to
unicast. A network periscope study is planned.

# IANA Considerations

Although this memo requires implementations to treat these addresses
the same as any other unicast addresses, it does not change the
"reserved" status of any block.  The IANA is requested to mark these
new blocks as unallocated, with the understanding that future
standards action will define how they are to be allocated.
   
240.0.0.0/4 and 0.0.0.0/8 move from the "special purpose" registry (https://www.iana.org/assignments/iana-ipv4-special-registry/iana-ipv4-special-registry.xhtml) and are added to the regular "ipv4-address-space" registry (
https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.xhtml)

0.0.0.0/32 and 127.0.0.0/16 should be added to the special purpose registry.

In the ipv4-address-space registry, 240/4 should be moved from
future use to unallocated, and 225/8 - 231/8 should be moved from
multicast to unallocated. 127.1.0.0/16 and up should be added.

IANA is directed also to prepare the these address spaces to be
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
same bogon filter and martian list fixes, however it seems likely that
127 in particular, having been "localnet" so long, is on fewer
bogon/martian lists than it should.

# Acknowledgements

Jason Ackley, Brian Carpenter, Vint Cerf, Kevin Darbyshire-Bryant,
Vince Fuller, Stephen Hemminger, Geoff Huston, Rob Landley, Eliot
Lear, Dan Mahoney, and Paul Wouters all made contributions to this
document, directly or indirectly. Thanks also to the members of the
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

