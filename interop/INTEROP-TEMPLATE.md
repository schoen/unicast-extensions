
# Example: Foonet R-1000 5.1.0 :x:

Additional example can be found in the [live repo](/inter)

## H1 Header format (remove this section when submitting results)

The H1 header format is:

```none
# (Vendor) (VendorProduct) (VendorVersion) (emoji of status)
```

Emojis are used to communicate quick-glance status information.

- `:x:` for failure :x:
- `:large_orange_diamond:` for partial :large_orange_diamond:
- `:white_check_mark:` for success :white_check_mark:
- `:large_blue_diamond:` indicates that test results are pending or in progress. :large_blue_diamond:

These should match the entry on the main page and should be used in each of the specific category headers (Addressing, Traffic, Aux, Notes) to communicate quick-glance information for that specific category (e.g. failure for addressing but success for traffic)

By default in this template each of the sections is set to `:x:` :x: . This is to make sure information is updated properly and not communicate successful test results by mistake.

## Summary

**Last Updated**: (day) (month) (year). Eg 17 Feb 2019

**Status Summary**: A short description of status/support for the System Under Test (**SUT**) / Device Under Test (**DUT**). This should be a quick-read two to 5 line section.

Remember that each version of the vendor and vendor product can have specific notes in a different markdown file so there is no need to overload a single markdown file with information that pertains to multiple versions.


### Vendor Statement

Include any information that the vendor has stated on the issue related to supportability. Some vendors are not expected to be able to support the new ranges until there is a published standard.

*Only public information that is **not** bound by a Non Disclosure Agreement (**NDA**) should be included here!*

If you are a vendor and would like to update this section please contact a member of the team from your company email address or open a GitHub issue/PR with proper information included.

Statements made on public mailing lists should be archived into the repo in order to preserve the content and not rely on external mailing-list archives.

## Addressing :x:

Addressing refers to the ability to assign a new IP range to the SUT. Generally this means configuring an IP address on an interface for networked devices.

Include any notes / examples of success or failures.

```
Use code blocks for fixed-width font examples of any CLI error messages/logs
```

## Traffic (To/From/Through) :x:

Traffic is tested for:

- **To** - Traffic originates from the SUT IP stack TO new IP space.
- **From** - Traffic arrives FROM new IP space and terminates on the SUT IP stack.
- **Through** - Traffic traversing THROUGH the SUT but does not terminate on the IP stack of the SUT.

Since each of these can have different processing code blocks within the SUT they need to all be verified independently from each other as they may have different statuses.

## Auxiliary Configurations :x:

Modern devices have many configuration elements. Each of these elements needs to verified in order to have a sense of the full supportability on the SUT.

Examples include:

- DHCPv4 pool(s) (where the SUT serves as the server)
- Misc services (DNS, HTTP, NTP, syslog, RADIUS, SIP, etc)
- Adding a static route to new IP space
- Adding a filter/firewall rule that uses new IP space
- Configuring IPsec/VPN peers that make use of new IP space
- Configuring routing peers via various protocols (BGP, OSPF, etc)
- TX/RX of address information within neighbor discovery (e.g. LLDP)

Due to the use of open source components - it is expected that once some of the 'core' FOSS packages are updated a great deal of platforms will benefit as long as the vendors have implemented the working versions of the external packages.

## Notes :x:

Any additional notes or quirks of implementation testing in free-form format.

- must reboot after ...
- memleak after ..
- Allows configuration but does not pass traffic




