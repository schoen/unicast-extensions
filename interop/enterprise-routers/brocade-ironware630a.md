
# Example: Brocade IronWare 6.3.0a :large_blue_diamond:

## Summary

**Last Updated**: `25 Feb 2019`

**Status Summary**: NetIron / Ironware is used as the software for `Extreme Networks` `CES/CER` and `MLXe` products. 

`Ironware version 6.3.0a` has a date of `9 Nov 2018`.

The `CES/CER` and `MLXe` are formerly from `Brocade Networks` , formerly from `Foundry Networks`.

The software may be encountered in OEM versions of the platform as well.


### Vendor Statement

- `Not Contacted` - Awaiting more testing.


## Addressing :large_blue_diamond:

Unable to configure `net240` on an interface:

```
telnet@ces2048c.lab(config)#int et 1/1
telnet@ces2048c.lab(config-if-e1000-1/1)#ip addr 240.0.0.1/24
Error: Address has to belong to CLASS A, B, or C
telnet@ces2048c.lab(config-if-e1000-1/1)#
```

Initial testing of setting an IP address within `127net` or `0net` appears to work - but more testing is needed for services.

```
telnet@ces2048c.lab(config-if-e1000-1/1)#ip addr 0.1.0.1/24
telnet@ces2048c.lab(config-if-e1000-1/1)#ip addr 127.1.1.1/24
telnet@ces2048c.lab(config-if-e1000-1/1)#^Z
telnet@ces2048c.lab#show ip route
Total number of IP routes: 3
Type Codes - B:BGP D:Connected I:ISIS O:OSPF R:RIP S:Static; Cost - Dist/Metric
BGP  Codes - i:iBGP e:eBGP
ISIS Codes - L1:Level-1 L2:Level-2
OSPF Codes - i:Inter Area 1:External Type 1 2:External Type 2 s:Sham Link
STATIC Codes - d:DHCPv6
        Destination        Gateway         Port           Cost          Type Uptime src-vrf
1       0.1.0.0/24         DIRECT          eth 1/1        0/0           D    0m10s  - 
(snip)
3       127.1.1.0/24       DIRECT          eth 1/1        0/0           D    0m4s   - 
telnet@ces2048c.lab#
```


## Traffic (To/From/Through) :large_blue_diamond:

- **To** - TBD.
- **From** - TBD.
- **Through** - TBD.


## Auxiliary Configurations :large_blue_diamond:

### Routing Protocols

### System Services

## Notes :large_blue_diamond:

TBD
