# Frequently Asked Questions

## "Focus on IPv6!"

The trivial amount of effort required to improve IPv4 pales in comparison
to the amount of effort to make IPv6 universal.

## "It will take too long to deploy!"

Any rational assessment of IPv4's continued existence stretches out
another 20 years, or longer. 

Increasing the amount of even semi-usable IPv4 addresses better
enables innovation and newcomers to the field, to at least "get
something" on IPv4 when it would otherwise be cost prohibitive or
impossible.

## "These addresses will never work globally"

They won't unless we try. They already work fine with the patchsets we
have on linux, freebsd, & osx, on a local lan, in tunnels, and via the two major routing daemons we've patched, and nearly every IOT OS we've tried.

## "We could allocate all these addresses in a year!"

If "normal" IPv4 allocation policies were followed, yes. However:

* A market is emerging for "regular" IPv4 addresses to be reallocated.

* As semi-useless addresses, these can be addresses of "last resort" when IPv6 is the primary transport and IPv4 is only the backup. Think of this as the reverse of "happy eyeballs", in the long term.

## "IPv6 is better! Just use that!"

IPv4 is universal, moreover, IPv4 is needed everywhere IPv6 hasn't
quite deployed. Wherever IPv6 coverage cracks 100%, IPv6 should
certainly be used. We certainly applaud every attempt to make
IPv6 more generally available.

## "Class-E is easy!"

It is. Thanks to nearly 10 years of quiet deployment.

So far in our testing, technically, extending IPv4 systems to do Class E (240/4), 0/8, 127/8, and taking out chunks of multicast is a few very short patches.

There is a huge installed base of course, but the majority of the billions of systems to be deployed in the future already "just work" with 240/4, it's just a few cleanups and pieces of infrastructure that need fixes. Doing the other address ranges is also a matter of trivial fixes that can take place at the
same time, as part of the same effort.

## Why try to make 0/8 and 240/4 globally routable?

Any attempt to make these address ranges fully usable stumbles on the
fact that manufacturers, data centers, ISPs, corporations, and users
need to be incented to support them. Some piece of gear will
inevitably not allow ipv4 addresses in this range unless a formal, and
not just defacto, standard also exists.

Plenty of limited use IPv4 address spaces exist - not just RFC1918,
but CGN networks are wildly popular.

As a totally new address range, making class-e in particular globally
routable makes it more possible to address other long-standing bugs in
ipv4 implementations like [zeroth networks](ZEROTH.md), attempt to make
more protocols available through NAT (such as udp-lite, sctp), and so on.

