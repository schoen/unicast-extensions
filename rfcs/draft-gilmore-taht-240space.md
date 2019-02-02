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

This memo reclassifies the address block 240.0.0.0/4 as unicast,
globally routable address space, in recognition that the majority of
operating systems now treat it as such.

It directs IANA to make the arrangements for reverse DNS. 
	
{mainmatter}

# Terminology

The keywords **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL**, when they appear in this document, are to be interpreted as described in [@!RFC2119].

# Introduction

despite rfcxyz... No viable alternate addressing mode has yet appeared.

Treating 240/4 as routable unicast is now a defacto standard, with support in all the major operating systems except windows.

Future experimentation should happen in ipv6 addressing, but due to a pressing shortage of unicast ipv4 addresses, 240/4 should be allocated for that purpose.

IPv4 Address exaustion happened, on schedule. Demand for 

[@I.D.FULLER88]

[@!RFC1918] 

[@!RFC7289] CGNs

Tools have appeared to search the codebases of the world

[@!RFC6333] DS-Lite

While each of these solutions is inadaquate in their own way,

It is now evident that despite the failure of any of these drafts to become Internet Standards, the network community followed the spirit of the draft recommendations to actually implement. 

This memo requires implementors to make the changes necessary to
receive, transmit, and forward packets that contain addresses in this
block as if they were within any other unicast address block.

It is envisioned that the utility of this block will grow over time.
Some devices may never be able to use it as their IP implementations
have no update mechanism.
   
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

# Implementation status

As of the release of the first version of this draft, Apple OSX and
Apple IOS have been confirmed to support the use of 240.0.0.0/4 as
unicast, globally reachable address space. Sun Solaris, Linux,
Android, and FreeBSD all treat it as such. These operating systems
have supported 240/4 since 2008. Four out of the top 5 open source IoT
stacks, also treat 240/4 as unicast, with a 3 line patch awaiting
submission for the last. The [@RFC6126] Babel routing protocol fully
supports 240/4, and patches have been submitted to the
BGP/OSPF/ISIS/etc capable routing daemon projects, "Bird", and "FRR".

No plans have been announced for modifications to any version of
Microsoft Windows, however Windows developers are aware of the work
required and are considering it for a future version.

# Implementation guidelines

The following guidelines have been developed via [@IPv4cleanup] project.

## Allow configuration via ifconfig ioctl

In Linux... patches were accepted into Linux 4.20 and backported into
openwrt to allow for the assignment of 240/4 addresses via the
otherwise obsolete ifconfig ioctl. (Support for assignment and static
routing via netlink-enabled interfaces has otherwise been universally
enabled since 2012)

In freeBSD - an incorrect ICMP check existed.

## Repair IN_MULTICAST check

One stack conflated an IN_MULTICAST check with the 240/4 address space.
e.g. 

```
#define IN_MULTICAST(addr) ((addr & ntohl(0xfe000000) == ntohl(0xfe000000))
```

where a correct check is:

```
#define IN_MULTICAST(addr) ((addr & ntohl(0xff000000) == ntohl(0xfe000000)))
```

Very few stacks actually check explicitly for the presence of 240/4
address otherwise. However as a macro that is extended to userspace,
some binary applications may have trouble reaching 240/4 until recompiled.

The almost entirely unused IN_EXPERIMENTAL macro also has been revised
to check for 255.255.255.255 only as a backwards compatible mechanism.

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
only the universal broadcast 255.255.255.255/32. Bogon lists that
currently conflate 224/3 MUST be altered to suit.

Firewalls [@!CBR03], packet filters, and intrusion detection systems, 
MUST be upgraded to be capable of monitoring and managing these addresses.

Routing protocols MUST treat these as unicast, globally routable addresses.

## Enable Reverse DNS for 255.0.0.0/8

Common deployments of the BIND routing daemon (e.g. debian) map reverse DNS for 255. to a local empty domain and do not forward requests for that to in-addr.arpa. The daemon itself does not have such a limit, with modern versions correctly intercepting 255.255.255.255 only.

# Related Work

The last attempts at making more IPv4 address space occurred in the
2008-2010 timeframe, with proposals for making it pure public routable
unicast [@I.D.FULLER88], or routable, but private, rfc1918 style
address space [I.D.HUSTON]. Neither proposal gained traction in the
IETF, however the first step - making 240/4 actually work - was almost
universally adopted in the field. It is presently unknown if any
organisation is making use of 240/4 in a non-standard way.

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

Vince Fuller, Eliot Lear, Stephen Hemminger, Geoff Huston, Jason Ackley, Dan Mahoney, Vint Cerf, Rob Landley, Paul Wouters

{backmatter}

<reference anchor='IPv4cleanup' target='https://github.com/dtaht/ipv4-cleanup'>
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

<reference anchor='I.D.FULLER88' target='https://tools.ietf.org/id/draft-fuller-240space-02.txt'>
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

