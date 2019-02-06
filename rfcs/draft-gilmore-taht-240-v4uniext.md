%%%
title = "IPv4 Unicast Extension into 240/4"
abbrev = "240-v4uniext"
updates = [2827, 3330, 6890, 8190]
ipr = "trust200902"
area = "Internet"
docname = "draft-gilmore-taht-240-v4uniext"
workgroup = "Network Working Group"
submissiontype = "IETF"
keyword = [""]
#date = 2019-01-30T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "draft-gilmore-taht-240-v4uniext-01"
stream = "IETF"
status = "standard"

[[author]]
initials = "J."
surname = "Gilmore"
fullname = "John Gilmore"
#role = "editor"
organization = "Electronic Frontier Foundation"
  [author.address]
  email = "gnu@ietf-id.toad.com"
  phone = "+1 415 221 6524"
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
  [author.address.postal]
  street = "20600 Aldercroft Heights Rd"
  city = "Los Gatos"
  region = "CA"
  code = "95033"
  country = "USA"
%%%

.# Abstract

The set of unicast addresses is the largest and most useful block of
addresses in the Internet Protocol (IP).  Some portions of the IP address
space have been "reserved for future use" for decades.  The future
has arrived!  This memo reclassifies the address block 240.0.0.0/4 as
globally routable unicast address space.  Most implementations have
already treated it as such for a decade, and the remainder can and will
be extended to do so.
 	
{mainmatter}

# Terminology

The keywords **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL**, when they appear in this document, are to be interpreted as described in [@!RFC2119].

# History

In 1981, the Internet Protocol (IP version 4, IPv4) landed as a
replacement for the ARPAnet protocols.  The designers improved on
ARPAnet's 16-bit address space with IPv4's 32-bit address space.  The
32-bit address space was clearly chosen as a compromise; its inability
to address all the nodes that would likely want to use it was known
from the start, but resource limitations in early routers discouraged
the use of longer addresses.  @!RFC760 

The initial IP design designated almost 7/8ths of the possible
addresses as Unicast addresses.  These addresses identified individual
nodes and routers, and could be used as source and destination addresses
of packets designed to be forwarded with full global reachability,
and/or for packets on local area networks. @!RFC791; @!RFC796 The
term "unicast" only came into use when multicast was invented for the
Internet protocol in 1985.  Initially ALL the existing non-reserved IP
addresses were, by default, unicast addresses.  @!RFC966

1/8th of the 32 bit address space was left as "reserved for future
use", and a few other 256ths were reserved for simple protocol
functions or for future use.  @!RFC791(#3.2) @!RFC796

By 1984, subnets were made part of the IP protocol.  @!RFC917, @!RFC922 

Initially, subnets were only used "locally"; the global
Internet routing infrastructure still only knew how to route to Class
A, B, and C networks; local equipment in each such network would route
locally to any local subnets.

Also in 1984, broadcast addresses were added to IPv4. @!RFC919,
@!RFC922 This required reserving one IPv4 address within each and
every network or subnet (the final address in that network or subnet,
the "all-ones" host address).  The address 255.255.255.255 was also
reserved to make it easier to broadcast on "a local hardware network"
without knowing the details of those networks.  This made broadcast a
useful mechanism for discovering a node's own address on the network.

The 1984 broadcast extension also reserved the initial (zero) address
in each network or subnet, for no particular reason, with @!RFC919
stating that "There is probably no reason for such addresses to appear
anywhere" with a now-obsolete exception.  It documented a human
writing convention of designating a "network number" with the zero
address, such as 36.0.0.0.  This convention has confused subsequent
protocol designers into thinking that the initial (all-zero) address
in a network or subnet cannot be used as an ordinary unicast node
address.

Later (1988) designers chose to allocate 1/16th of the total space
(half of the formerly reserved space) for multicast use.  [@!RFC1054]
While multicast was a much better idea than the sole similar former
option (broadcast), its use on anything besides local area networks
has remained a tiny niche, in retrospect clearly not worth designating
1/16th of the entire address space for.  This address space is called
224/4 in Phil Karn's more modern CIDR [@!RFC4632] notation.

By 1989, the revisions to the basic Internet Protocol suite required
reading dozens and dozens of documents.  The basic requirements for
Internet hosts and gateways were consolidated into a few documents.
[@!RFC1022;@!RFC1023;@!RFC1024]

By 1992, the original network addressing and routing architecture was
straining at the seams.  The problems were "the lack of a network
class of a size which is appropriate for mid-sized organization[s]",
growth of routing tables beyond available capacities, and the
"eventual exhaustion of the 32-bit IP address space" as documented in
[@!RFC1338]. The proposed fix involved an extension of subnetting to
"supernetting" small Class C addresses, deploying classless routing
protocols, and generally deprecating the concept of "network address
classes".  Each network address would be represented by a pair: an
address and a mask.  This proposal reserved the address 0.0.0.0 with
mask 0.0.0.0 as the "default route" with special rules.  This was
adopted in 1993 as Classless Inter-Domain Routing (CIDR) for Class C,
and half of Class A (a quarter of the entire Internet address space)
was reserved for future subnetting after deployment of more capable
routing protocols.  [@!RFC1466], [@!RFC1518], [@!RFC1519]

By 1995, the implementation of subnetting for "Class A" addresses was
sufficiently buggy that the IANA began a global experiment by
allocating 256 subnetted Class A addresses to *every* existing address
space user, and encouraging them to be used to verify correct
operation of their gateways and hosts.  [@!RFC1797] Even in 1996,
[@!RFC2036] described that large parts of the Internet could not
correctly subnet Class A addresses.

The remaining 1/16th of the "EXPERIMENTAL" portion of the address
space has remained reserved and unused in the 38 years since 1981.
[@!RFC1054]#4 This portion is now called 240/4 in CIDR notation.

1/256th of the address space initially reserved for protocol functions
was "network 0".  The address 0.0.0.0 was reserved for use only as a
source address by nodes that do not know their own address
yet.  [@!RFC1122](#3.2.1.3) Addresses of the form 0.x.y.z were
initially defined only as a source address for "node number x.y.z on
THIS NETWORK" by nodes that do not yet know their network prefix
yet.  [@!RFC1122](#3.2.1.3) This definition was later repealed because
the expected mechanism for learning their network prefix had turned
out to be unworkable.  FIXME: @!RFCxxxx That repeal left 16 million
addresses reserved for future use.

The other 256th of the address space initially reserved for protocol
functions was network 127.  The entire set of 16 million addresses of
the form 127.x.y.z were reserved for "internal host loopback
addresses" and should never appear as a source or destination address
on a network outside of a single node.  [@!RFC1122](#3.2.1.3) When
IPv6 was designed in the 1990s, this was seen as excessive, and in
[@!RFC1884] the single IPv6 loopback address was defined.  But: in
IPv4, this reservation has continued to the present day.

Much has changed since the 240/4 address range was first set aside as EXPERIMENTAL.

IPv4 address exhaustion happened, on schedule, in 2011. Demand for
IPv4 and IPv6 to IPv4 translation technologies spiked, leveraging
[@!RFC1918], with [@!RFC7289] CGNs, [@!RFC6333] DS-Lite, and
[@!RFC6877] 464XLAT becoming widely adopted.  While each of these
solutions is inadequate in their own way, and pure IPv6 superior, the
need for IPv4 address space appears unslakable for the next 20 years.

Although a market has appeared for existing IPv4 allocations, and
small amounts of address space returned to the global pools, demand
for IPv4 addressing continues unabated. New edge and data center
technologies are creating new demands, and internet-accessible servers
will need to be dual stacked for a long time to come.

In 2008 [@I.D.FULLER08], and 2010 [@I.D.WILSON10] first proposed that
the 240/4 address space become usable - the first draft mandating no
explicit use; the second, as "private" RFC1918-like addresses.

It is now evident that despite the failure of either of these drafts
to become Internet Standards, the network community followed the
spirit of these draft recommendations to actually implement them in
the 2008-2010 time-frame.

Treating 240/4 as routable unicast is now a de facto standard, with
support in all the major operating systems except Windows, and only a
few edge cases left to fix.

This memo requires implementer to make the changes necessary to
receive, transmit, and forward packets that contain addresses in this
block as if they were within any other unicast address block.

It is envisioned that the utility of this block will grow over time.
Some devices may never be able to use it as their IP implementations
have no update mechanism.

Users are encouraged to treat 240/4 IPv4 allocations as a chance to
improve IPv4 handling generally, to allow for more protocols than just
UDP NAT and TCP to traverse it (such as UDP-Lite and SCTP) and to
address other long standing problems in the IPv4 blocks in new
allocations such as using /32 rather than /30 networks.

# Address space

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
specially in each case: it is illegal as a source IP address, it is
illegal as an network interface address, and it matches the local
system when used as the destination address in a received datagram.

{#fig-255}
          +----------------------+----------------------------+
          | Attribute            | Value                      |
          +----------------------+----------------------------+
          | Address Block        | 255.255.255.255/32         |
          | Name                 | Broadcast Address          |
          | RFC                  | This Internet-Draft        |
          | Allocation Date      | 1981                       |
          | Termination Date     | N/A                        |
          | Source               | False                      |
          | Destination          | False                      |
          | Forwardable          | False                      |
          | Global               | False                      |
          | Reserved-by-Protocol | True                       |
          +----------------------+----------------------------+

# Implementation status

As of the release of the first version of this draft, Apple OSX and
Apple IOS have been confirmed to support the use of 240.0.0.0/4 as
unicast, globally reachable address space. Solaris, Linux,
Android, and FreeBSD all treat it as such. These operating systems
have supported 240/4 since 2008. Four out of the top 5 open source IoT
stacks, also treat 240/4 as unicast, with a 3 line patch awaiting
submission for the last. The [@!RFC6126] Babel routing protocol fully
supports 240/4, and patches have been submitted to the
BGP/OSPF/ISIS/etc capable routing daemon projects, "Bird", and "FRR".

No plans have been announced for modifications to any version of
Microsoft Windows, however Windows developers are aware of the work
required and are considering it for a future version.

# Implementation guidelines

The following guidelines have been developed via [@IPv4CLEANUP] project.

## Allow configuration

In Linux -  patches were accepted into Linux 4.20 and backported into
OpenWrt to allow for the assignment of 240/4 addresses via the
otherwise obsolete ifconfig ioctl. Support for assignment and static
routing via netlink-enabled interfaces had otherwise been universally
enabled since 2010.

In FreeBSD - an incorrect ICMP check existed.

All the open source ARP, DHCP, and DNS implementations do no explicit
checking for 240/4 and thus "just work". No open source application we have scanned has any limitations regarding usage of these addresses.

## Repair IN\_MULTICAST and limit IN\_EXPERIMENTAL macros

One stack conflated an IN\_MULTICAST check with the 240/4 address space.
e.g. 

```
#define IN_MULTICAST(addr) (((addr & ntohl(0xfe000000)) == ntohl(0xfe000000)))
```

where a correct check is:

```
#define IN_MULTICAST(addr) (((addr & ntohl(0xff000000)) == ntohl(0xfe000000)))
```

Very few stacks actually check explicitly for the presence of 240/4
addresses otherwise. However as a macro that is extended to userspace,
some binary applications may have trouble reaching 240/4 until recompiled.

The almost entirely unused IN_EXPERIMENTAL macro also has been revised
to check for 255.255.255.255 only as a backwards compatible mechanism.

Other network stacks and applications bury these checks deep in their
libraries, however, searches for a key phrase of multicast usually
turns up whatever code nearby that might need to be patched to fix it.

## Remove 240/4 from Martian Addresses and Bogon Lists

[@!RFC2827] recommends that ISPs police their customers' traffic by
dropping traffic entering their networks that is coming from a source
address not legitimately in use by the customer network.  The
filtering includes but is in no way limited to the traffic whose
source address is a so-called "Martian Address" - an address that is
reserved [3], including any address within 0.0.0.0/8, 10.0.0.0/8,
127.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 224.0.0.0/4, or
240.0.0.0/4.

This memo removes 240.0.0.0/4 from the martian address spaces, keeping
the universal broadcast address 255.255.255.255/32. Bogon and martian
lists that currently reduce 224/4 and 240/4 to 224/3 MUST be altered
to block 224/4 and 255.255.255.255/32 only.

Firewalls [@!CBR03], packet filters, and intrusion detection systems, 
MUST be upgraded to be capable of monitoring and managing these addresses.

Routing protocols MUST treat these as unicast, globally routable addresses.

## Enable Reverse DNS for 255.0.0.0/8

Common deployments of the BIND routing daemon (e.g. Debian) map reverse DNS for 255. to a local empty domain and do not forward requests for that to in-addr.arpa. The daemon itself does not have such a limit, with modern versions correctly intercepting 255.255.255.255 only.

# Related Work

The last attempts at making more IPv4 address space occurred in the
2008-2010 timeframe, with proposals for making it pure public routable
unicast [@I.D.FULLER08], or routable, but private, RFC1918 style
address space [@I.D.WILSON10]. Neither proposal gained traction in the
IETF, however the first step - making 240/4 actually work - was almost
universally adopted in the field.

It is presently unknown if any organization is making use of 240/4.

# IANA Considerations

IANA is directed to make the 240/4 address space available as reverse
dns space in in-addr.arpa.

# Security Considerations

Presently access to the 240/4 block is mostly assumed to be managed
somewhere along the edge of the network, and wider availability merely
requires removal of this space from common bogon lists and hard coded
martian files. In many other cases it will "just work", but thought
needs to be given to any additional security exposures to existing
firewalled networks.

# Acknowledgements

Jason Ackley, Vint Cerf, Kevin Darbyshire-Bryant, Vince Fuller,
Stephen Hemminger, Geoff Huston, Rob Landley, Elliot Lear, Dan
Mahoney, and Paul Wouters all made contributions to this document,
directly or indirectly.

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
</reference>

<reference anchor='I.D.WILSON10' target='https://tools.ietf.org/id/draft-wilson-class-e-02'>
<front>
<title>Redesignation of 240/4 from "Future Use" to "Private Use"</title>
<author initials='G.' surname='Huston' fullname='Geoff Huston'>
<address>
<email>gih@apnic.net</email>
</address>
</author>
<author initials='G.' surname='Michaelson' fullname='George Michaelson'>
<email>ggm@apnic.net</email>
</author>
<author initials='P.' surname='Wilson' fullname='Paul Wilson'>
<email>pwilson@apnic.net</email>
</author>
<date year='2010' />
</front>
</reference>

<reference anchor='I.D.FULLER08' target='https://tools.ietf.org/id/draft-fuller-240space-02.txt'>
<front>
<title>240 address space</title>
<author initials='V.' surname='Fuller' fullname='Vince Fuller'>
<address>
<email>vince.fuller@gmail.com </email>
</address>
</author>

<author initials='E.' surname='Lear' fullname='Elliot Lear'></author>
<author initials='D.' surname='Meyer' fullname='David Meyer'></author>
<date year='2008' />
</front>
</reference>


<reference anchor='CBR03' target=''>
 <front>
 <title>Firewalls and Internet Security: Repelling the Wily Hacker, Second Edition</title>
  <author initials='W.R.' surname='Cheswick' fullname='W.R. Cheswick'></author>
  <author initials='S.M.' surname='Bellovin' fullname='S.M. Bellovin'></author>
  <author initials='A.D.' surname='Rubin' fullname='A.D. Rubin'></author>
  <date year='2003' />
 </front>
 <seriesInfo name="Addison-Wesley" value='' />
 </reference>

