%%%
title = "Reclassifying 240/4 as usable unicast address space"
abbrev = "classe-u"
updates = [2827, 3330, 6890, 8190]
ipr = "trust200902"
area = "Internet"
docname = "draft-gilmore-taht-240space"
workgroup = "Network Working Group"
submissiontype = "IETF"
keyword = [""]
#date = 2019-01-30T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "draft-gilmore-taht-240space-01"
stream = "IETF"
status = "standard"

[[author]]
initials = "J."
surname = "Gilmore"
fullname = "John Gilmore"
#role = "editor"
organization = "Electronic Frontier Foundation"
  [author.address]
  email = "gnu@toad.com"
  phone = "+14152216524"
  [author.address.postal]
  street = "PO Box 170608"
  city = "San Francisco"
  region = "Ca"
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
  phone = "+18312059740"
  [author.address.postal]
  street = "20600 Aldercroft Heights Rd"
  city = "Los Gatos"
  region = "Ca"
  code = "95033"
  country = "USA"
%%%

.# Abstract

This memo reclassifies the address block 240.0.0.0/4 as unicast
globally routable address space, in recognition that the vast majority
of operating systems and devices deployed now treat it as such.

It directs IANA to make the arrangements for reverse DNS. 
	
{mainmatter}

# Terminology

The keywords **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL**, when they appear in this document, are to be interpreted as described in [@!RFC2119].

# Introduction

Much has changed since the 240/4 address range was first set aside as EXPERIMENTAL.

IPv4 address exaustion happened, on schedule, in 2011. Demand for IPv4
and IPv6 to IPv4 translation technologies spiked, leveraging
[@!RFC1918], with [@!RFC7289] CGNs, [@!RFC6333] DS-Lite, and
[@!RFC6877] 464XLAT becoming widely adopted.  While each of these
solutions is inadaquate in their own way, and pure IPv6 superior,
the need for pure IPv4 address space appears unslakable for the next
20 years.

Although a market has appeared for existing IPv4 allocations, and small amounts of address space returned to the global pools, demand for IPv4 addressing continues unabated. New edge and data center technologies are creating new demands, and internet-accessible servers will need to be dual stacked for a long time to come.

In 2008 [@I.D.FULLER08], and 2010 [@I.D.WILSON10] first proposed that
the 240/4 address space become usable - the first draft mandating no
explicit use; the second, as "private" rfc1918-like addresses.

It is now evident that despite the failure of either of these drafts
to become Internet Standards, the network community followed the
spirit of these draft recommendations to actually implement them in
the 2008-2010 timeframe.

Treating 240/4 as routable unicast is now a defacto standard, with
support in all the major operating systems except Windows, and only a
few edge cases left to fix.

This memo requires implementors to make the changes necessary to
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

In freeBSD - an incorrect ICMP check existed.

All the open source ARP, DHCP, and DNS implementations do no explicit
checking for 240/4 and thus "just work". No open source application we have scanned has any limitations regarding usage of these addresses.

## Repair IN\_MULTICAST and limit IN\_EXPERIMENTAL macros

One stack conflated an IN\_MULTICAST check with the 240/4 address space.
e.g. 

```
#define IN_MULTICAST(addr) ((addr & ntohl(0xfe000000) == ntohl(0xfe000000))
```

where a correct check is:

```
#define IN_MULTICAST(addr) ((addr & ntohl(0xff000000) == ntohl(0xfe000000)))
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
the universal broadcast address 255.255.255.255/32. Bogon and martion
lists that currently reduce 224/4 and 240/4 to 224/3 MUST be altered
to suit to block 224/4 and 255.255.255.255/32 only.

Firewalls [@!CBR03], packet filters, and intrusion detection systems, 
MUST be upgraded to be capable of monitoring and managing these addresses.

Routing protocols MUST treat these as unicast, globally routable addresses.

## Enable Reverse DNS for 255.0.0.0/8

Common deployments of the BIND routing daemon (e.g. debian) map reverse DNS for 255. to a local empty domain and do not forward requests for that to in-addr.arpa. The daemon itself does not have such a limit, with modern versions correctly intercepting 255.255.255.255 only.

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
firewall'd networks.

# Acknowledgements

Vince Fuller, Eliot Lear, Stephen Hemminger, Geoff Huston, Jason Ackley, Dan Mahoney, Vint Cerf, Rob Landley, Paul Wouters all made contributions to this document, directly or indirectly.

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

