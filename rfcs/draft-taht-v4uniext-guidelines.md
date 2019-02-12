%%%
title = "IPv4 Unicast Extension Guidelines"
abbrev = "IPv4-uniext-guidelines"
updates = []
ipr = "trust200902"
area = "Internet"
docname = "draft-taht-v4uniext-guidelines"
workgroup = "Internet Area Working Group"
submissiontype = "IETF"
keyword = [""]
#date = 2019-01-30T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "draft-taht-v4uniext-guidelines-01"
stream = "IETF"
status = "standard"

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
space have been "reserved for future use" for decades. 

This memo outlines some basic guidelines for converting more address
space to unicast, using primarily our experiences so far with
re-allocating the address block 240.0.0.0/4 as globally routable
unicast address space.  {mainmatter}

# Terminology

The keywords **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL**, when they appear in this document, are to be interpreted as described in [@!RFC2119].

# Introduction

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

This Internet-Draft proposes that all implementers should make the
small changes required to receive, transmit, and forward packets that
contain addresses in this block as if they were within any other
unicast address block.

It is envisioned that the utility of this block will grow over time.
Some devices may never be able to use it as their IP implementations
have no update mechanism.

Users are encouraged to treat 240/4 IPv4 allocations as a chance to
improve IPv4 handling generally, to allow for more protocols than just
UDP NAT and TCP to traverse it (such as UDP-Lite) and to
address other long standing problems in the IPv4 blocks in new
allocations such as using /32 rather than /30 networks. 

# Unicast use of address space formerly reserved for future use

The attributes of blocks of address space are described by the IANA and
in IETF publications by structured, boxed tables; see [@!RFC6890].
This document proposes replacing the former description tables of these
blocks, with those included in this document.

# Unicast use of formerly reserved per-network node addresses

## Unicast use of the zero node address in each network or subnet

FIXME

## Unicast use of the all-ones node address in each point-to-point network

FIXME

# Discussion

# Interoperation with unextended nodes

# Implementation status

As of the release of the first version of this draft, Apple OSX and
Apple IOS have been confirmed to support the use of 240.0.0.0/4 as
unicast, globally reachable address space. Solaris, Linux, Android,
and FreeBSD all treat it as such. These operating systems have
supported 240/4 since 2008. Four out of the top 5 open source IoT
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

``` c
#define IN_MULTICAST(addr) (((addr & ntohl(0xfe000000)) == ntohl(0xfe000000)))
```

where a correct check is:

``` c
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
unicast [@I-D.fuller-240space], or routable, but private, RFC1918 style
address space [@I-D.wilson-class-e]. Neither proposal gained traction in the
IETF, however the first step - making 240/4 actually work - was almost
universally adopted in the field.

It is presently unknown if any organization is making use of 240/4.

# IANA Considerations

None.

# Security Considerations

Presently access to the 240/4 block is mostly assumed to be managed
somewhere along the edge of the network, and wider availability merely
requires removal of this space from common bogon lists and hard coded
martian files. In many other cases it will "just work", but thought
needs to be given to any additional security exposures to existing
firewalled networks.

# Acknowledgements

Jason Ackley, Brian Carpenter, Vint Cerf, Kevin Darbyshire-Bryant,
Vince Fuller, Stephen Hemminger, Geoff Huston, Rob Landley, Eliot
Lear, Dan Mahoney, and Paul Wouters all made contributions to this
document, directly or indirectly.

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


<reference anchor='CBR03' target=''>
 <front>
 <title>Firewalls and Internet Security: Repelling the Wily Hacker, Second Edition</title>
  <author initials='W.R.' surname='Cheswick' fullname='Bill Cheswick'></author>
  <author initials='S.M.' surname='Bellovin' fullname='Steve Bellovin'></author>
  <author initials='A.D.' surname='Rubin' fullname='Avi Rubin'></author>
  <date year='2003' />
 </front>
 <seriesInfo name="Addison-Wesley" value='' />
 </reference>

