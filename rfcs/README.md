# How to build these internet drafts

- Download [mmark](https://github.com/mmarkdown/mmark/releases) for your platform
- Install xml2rfc (apt-get install xml2rfc)
- type make

For correct utf-8 support you will either need to use the [online xml2rfc
v3 converter](https://xml2rfc.tools.ietf.org/) or a [private copy of the latest xml2rfc code](https://pypi.org/project/xml2rfc/) that can be installed via pip or the tarball.

It pays to review the [mmark documentation](https://mmark.nl/) for tricky things like text diagrams
or how to format normative vs informative references.
