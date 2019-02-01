%%%
title = "Making Class E reachable"
abbrev = "classe-u"
updates = [2827, 6890, 8190]
ipr = "trust200902"
area = "Internet"
docname = "draft-gilmore-taht-class-e-01"
workgroup = "Network Working Group"
submissiontype = "IETF"
keyword = [""]
date = 2019-01-30T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "draft-gilmore-taht-class-e-01"
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
  phone = "+"
  [author.address.postal]
  street = "PO Box XXX"
  city = "San Francisco"
  region = "Ca"
  code = "95033"
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

This memo declares the former class-e address space (240/4) to be
unicast, globally reachable address space. It directs IANA to make
the arrangements for reverse DNS. 

{mainmatter}

# Introduction

[@!RFC2119]

despite rfcxyz... No viable alternate addressing mode has yet appeared.

Treating 240/4 as routable unicast is now a defacto standard, with support in all the
major operating systems except windows.

Future experimentation should happen in ipv6 addressing, but due to a pressing shortage
of unicast ipv4 addresses, 240/4 should be allocated for that purpose.

# Martian Addresses

   RFC 2827 recommends that ISPs police their customers' traffic by
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

## Terminology

The keywords **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**,
**SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL**, when they appear in this
document, are to be interpreted as described in [@!RFC2119].

# Address space

{#fig-240}
                             Table M: Former Class-e
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


# Related Work

The last attempts at making more ipv4 address space occurred in the 2008-2010
timeframe, with proposals for making it pure public routable unicast [FULLER88], or routable, but
private, rfc1918 style address space [IFORGET]. Neither proposal gained traction in
the IETF.

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

Vince Fuller, Eliot Lear, Stephen Hemminger, Geoff Huston, Jason Ackley, Dan Mahoney, 
Vint Cerf, Rob Landley.

{backmatter}

<reference anchor='FULLER88' target=''>
 <front>
 <title>240 address space</title>
  <author initials='W.R.' surname='Cheswick' fullname='W.R. Cheswick'></author>
  <author initials='S.M.' surname='Bellovin' fullname='S.M. Bellovin'></author>
  <author initials='A.D.' surname='Rubin' fullname='A.D. Rubin'></author>
  <date year='2003' />
 </front>
 <seriesInfo name="Addison-Wesley" value='' />
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

