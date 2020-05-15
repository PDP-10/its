# TCP/IP

Currently, networking is only supported under the KLH10 and SIMH KA10
and KL10 emulators. The SIMH KS10 does not have the necessary
support. As of this release, only the ITS monitor, host table tools,
and binary host table are installed.

Currently, basic TCP network support is in the build, in addition to
both a TELNET/SUPDUP server, and both TELNET and SUPDUP clients.
Additionally, both an FTP server and client are included.
SMTP mail inbound and outbound is included,
as well as local mail delivery.

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
The KLH10 dskdmp.ini file has an IP address (192.168.1.100) and gateway IP
address (192.168.0.45) configured for the ITS system. The IP address
matches the address configured in SYSTEM; CONFIG > (as IMPUS3). Finally,
the HOST table source (SYSHST; H3TEXT >) and binary (SYSBIN; HOSTS3 >)
defined a host called DB-ITS.EXAMPLE.COM at the IP address 192.168.1.100.

In order to change the IP address of the host, you can edit IP, GW,
and NETMASK in the file conf/network.  You can also set a Chaosnet
address.  After that, a full rebuild (e.g. `make clean all`) is required.

## DNS
Check out this [external guide](https://its.victor.se/wiki/dqdev)

## Mail
Check out this [external guide](https://its.victor.se/wiki/mail-setup)

## telnet, supdup, ftp
They work out of the box


# Chaosnet
Chaosnet TELNET and FTP (CHTN and CFTP), are available
but this requires support and configuration
in the emulator to actually use.

TBC...


# Useful resources
- [The ITS Wiki](https://its.victor.se/wiki/start)
