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
organization = "TekLibre"
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

[@!RFC2119]

despite rfcxyz... No viable alternate addressing mode has yet appeared.

Treating 240/4 as routable unicast is now a defacto standard, with support in all the major operating systems except windows.

Future experimentation should happen in ipv6 addressing, but due to a pressing shortage of unicast ipv4 addresses, 240/4 should be allocated for that purpose.

[@I.D.FULLER88]

[@!RFC1918] 

[@!RFC7289] CGNs

Tools have appeared to search the codebases of the world

While each of these solutions is inadaquate in their own way,

It is now evident that despite the failure of any of these drafts to become Internet Standards, the network community followed the spirit of the draft recommendations to actually implement. 

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
IOS have been confirmed to support the use of 240.0.0.0/4 as unicast,
globally reachable address space. Sun Solaris, Linux, Android, and
FreeBSD all treat it as such. Four out of the top 5 open source IoT stacks, also treat 240/4 as unicast, with a 3 line patch awaiting submission.

No plans have been announced for modifications to any version
of Microsoft Windows, in part because of uncertainty over how to
perform 6-to-4 tunneling in the absence of a definitive statement on
whether 240.0.0.0/4 is "public" or "private" space.

## Implementation guidelines

### Enable Reverse DNS

### Repair IN_MULTICAST check

### Remove 240/4 from Martian Addresses and bogon lists

   [@!RFC2827] recommends that ISPs police their customers' traffic by
   dropping traffic entering their networks that is coming from a source
   address not legitimately in use by the customer network.  The
   filtering includes but is in no way limited to the traffic whose
   source address is a so-called "Martian Address" - an address that is
   reserved [3], including any address within 0.0.0.0/8, 10.0.0.0/8,
   127.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 224.0.0.0/4, or
   240.0.0.0/4.

This memo removes 240.0.0.0/4 from the martian address spaces, keeping
only 255.255.255.255/32. 

Firewalls [@!CBR03], packet filters, and intrusion detection systems, 
MUST be upgraded to be capable of monitoring and managing these addresses.

Routing protocols MUST treat these as unicast, globally routable addresses.

# Related Work

The last attempts at making more ipv4 address space occurred in the 2008-2010
timeframe, with proposals for making it pure public routable unicast
[@I.D.FULLER88], or routable, but private, rfc1918 style address space [IFORGET]. Neither proposal gained traction in the IETF.

# IANA Considerations

IANA is directed to make the 240/4 address space available as reverse
dns space in in-addr.arpa.

# Security Considerations

Presently access to the 240/4 block is mostly assumed to be managed somewhere
along the edge of the network, and wider availability requires removal of
common bogon lists and hard coded martian files. In many other cases it will
"just work", but thought needs to be given to any additional security
exposures to existing firewall'd networks.

# Acknowledgements

Vince Fuller, Eliot Lear, Stephen Hemminger, Geoff Huston, Jason Ackley, Dan Mahoney, Vint Cerf, Rob Landley, Paul Wouters

{backmatter}

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

