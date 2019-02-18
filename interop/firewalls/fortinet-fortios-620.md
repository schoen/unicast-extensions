
# Fortinet FortiOS 6.2.0 :large_blue_diamond:

## Summary

**Last Updated**:  17 Feb 2019

**Status Summary**: Interface configuration fails.


### Vendor Statement

N/A

## Addressing :x:

Addressing fails to apply via the CLI
```
firewall (port2) # set ip 240.0.0.1/24
ip address must be a class A, B, or C ip

value parse error before '240.0.0.1/24'
Command fail. Return code -8

firewall (port2) # 
```
When attempted via the WebUI - an error of 'invalid netmask' is given and the element remains red, preventing submission via the submit button.


## Traffic (To/From/Through)

### To
Traffic destinted for `240/4` appears to be generated without problems from the IP space. Additional testing is needed.

```

```


## Auxiliary Configurations

TBD



## Notes

NOTE: Tested on `FortiOS 6.2.0 build 0776` This is a beta image/release and may not represent the final version.
