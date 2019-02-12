%%%
title = "Converting Additional IPv4 multicast allocations to unicast"
abbrev = "224-v4uniext"
updates = [2827, 3330, 6890]
ipr = "trust200902"
area = "Internet"
docname = "draft-taht-landley-v4uniext-mcast"
workgroup = "Internet Area Working Group"
submissiontype = "IETF"
keyword = [""]
# date = 2019-01-30T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "draft-taht-landley-v4uniext-mcast-01"
stream = "IETF"
status = "standard"

[[author]]
initials = "R."
surname = "Landley"
fullname = "Rob Landley"
#role = "editor"
organization = "Landley.net"
  [author.address]
  email = "rob@landley.net"
#  phone = " "
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
role = "editor"
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

Continuing to reserve 268 million IPv4 addresses for multicast is a
complete waste of address space. This memo outlines ways in which much
of this space can be reclaimed for general unicast use.

{mainmatter}

# Terminology

The keywords **MUST**, **MUST NOT**, **REQUIRED**, **SHALL**, **SHALL NOT**, **SHOULD**, **SHOULD NOT**, **RECOMMENDED**, **MAY**, and **OPTIONAL**, when they appear in this document, are to be interpreted as described in [@!RFC2119].

# Introduction

Bla

# History

Many attempts to make multicast scale followed. 

However, when napster

Should we leave maybe 65536 multicast addresses for multicast (so turn
224/4 into 224/16)? There are a few remaining users of multicast
(hotel cable TV systems) and they special case this address range in
the routers to do it. The one semi-live usage of it I've seen in the
past 5 years (the 224.0.1.1 multicast address from [@!RFC5905] is used
in some johnson controls building control equipment).

None of these uses are world routable, but the IPv4 routers seem to
special case this address range to enable multicast packet
duplication?

Multicast failed to take off because improved compression schemes
(like mp3 and mp4) greatly restricted storage and bandwith
requirements of media while rendering partial delivery of data
useless, and due to the widespread deployment of broadband internet
via cable modem and DSL. The decline of multicast started in 1999 when
Napster provided a proof of concept that distributing MP3 files via
unicast could scale. RealAudio quickly lost market share to unicast
media delivery solutions. These days Youtube, Netflix, Hulu, and
Amazon Prime all use unicast distribution.

The decline started 20 years ago and the multicast mbone (which this
address range was reserved for) essentially ceased operations about 15
years ago:

```
https://en.wikipedia.org/wiki/Mbone

https://wiki.videolan.org/index.php?title=MBONE&action=history

http://www.caida.org/tools/measurement/mantra/
```

It was never widely used, the range was allocated for growth that did
not occur, and remaining users are treating it as a LAN protocol which
_could_ use any other LAN-local address range if the routers were
reprogrammed, but leaving them a /16 seems polite? (Heck a /24 would
probably be plenty, but a /16 means you don't have to update the NTP
RFC...)

In [@!RFC5771] IANA was directed to re-evaluate the multicast allocations
periodically.

GLOP Addressing [@!RFC3180], 

Even the largest multicast block is only 5% allocated.
https://www.iana.org/assignments/multicast-addresses/multicast-addresses.xhtml

## The multicast mess

224.5 and up have no reservations
224.252/14 – DIS transient groups
https://tools.ietf.org/html/rfc5771  Asked 
225/-231/8 Reserved for future use
232/8 - Source-Specific Multicast Block
233.0.0.0-233.251.255.255	GLOP Block	[RFC3180]
233.252.0.0/24 – MCAST-TEST-NET
233.252/14 AD-HOC Block III
234.0.0.0-234. 255.255.255	Unicast-Prefix-based IPv4 Multicast Addresses	[RFC6034]
235.0.0.0-238.255.255.255	Reserved	[IANA]			
239/8 reserved for the mbone (obsolete for 12 years)
https://tools.ietf.org/html/rfc2365

https://tools.ietf.org/html/rfc3180

https://tools.ietf.org/html/rfc4607 SSM

# Implementation guidelines

IN_MULTICAST macro, which looks like this:

{backmatter}

