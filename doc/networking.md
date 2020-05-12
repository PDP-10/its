# TCP/IP

## IP address
To change the machine's IP address you need to [rebuild ITS](NITS.md).

### SIMH KA10 / KL10
To get the `pdp10-ka` or `pdp10-kl` online with the lowest effort, use the included NAT interface via DHCP.
This will assign ITS the ip `10.0.2.15`, set up routing automatically, and forward the ports you specify.
Edit `build/pdp10-ka/run` and configure the `IMP` interface as follows:
```
# IMP Network Interface
set imp mac=xx:xx:xx:xx:xx:xx
set imp dhcp
at imp nat:tcp=2123:10.0.2.15:23,tcp=2121:10.0.2.15:21,tcp=2195:10.0.2.15:95
```
This example adds port forwarding for telnet, ftp, and supdup. Modify according to your needs.

### SIMH KS10
The `simh` (KS) simulator does not currently support networking.

### KLH10
TBC...

## DNS
Check out this [external guide](https://its.victor.se/wiki/dqdev)

## Mail
Check out this [external guide](https://its.victor.se/wiki/mail-setup)

## telnet, supdup
They work out of the box


# Chaosnet
TBC...

# Useful resources
- [The ITS Wiki](https://its.victor.se/wiki/start)
