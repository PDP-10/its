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
Unless you are running the current ITS on a current version of KLH10 (see [below](#KLH10)),
you need to [rebuild ITS](NITS.md) to change the machine's IP address.

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
matches the address configured in SYSTEM; CONFIG > (as IMPUS3),
but this is not important since the address is now updated at runtime (see below).

Finally, the HOST table source (SYSHST; H3TEXT >) and binary (SYSBIN; HOSTS3 >)
define a host called DB-ITS.EXAMPLE.COM at the IP address 192.168.1.100.

In order to change the IP address of the host, you only need to change
the `ipaddr` parameter in the KLH10 `.ini` file, and ITS will get the
address and netmask from (the IMP of) KLH10 at runtime. You will still
want/need to update `SYSHST;H3TEXT >` and recompile it using `SYSHST;H3MAKE BIN`.

You can also set/change a Chaosnet address of the `ch11` device in the
`.ini` file. The address is read by ITS at runtime. Note that to use
Chaosnet, you must have enabled it by `DEFOPT CH11P==1` in `SYSTEM; CONFIG >`.
This is done automatically if you specified a chaos address in the `.../conf/network` file.
If you use Chaosnet, you may be interested in joining the Global
Chaosnet: read more about it at https://chaosnet.net.

## DNS
To make ITS use DNS like a modern netizen, you need to do the following:

1. Compile the handler for the DOMAIN: device, which interfaces to DNS.
	```
	:midas device;jobdev domain,sysnet;dqdev
	```
2. Compile NAME and SUPDUP with a switch to use RESOLV library routines (with DNS support) if the NETWRK library routines (which uses HOSTS3 tables) fail. (`^C` below is Control-C.)
	```
	:midas sysbin;name_sysen2;/t
	DODNS==1
	^C
	:midas sysbin;supdup_sysnet;/t
	DODNS==1
	^C
	```
3. Purify NAME. (`$` below is Escape.)
	```
	name$j
	$l sysbin;name
	debug[ 0
	$g
	```
4. Compile COMSAT (the mail daemon) with a switch to use DOMAIN instead of DQ. (The "Limit to KA-10 instructions" question should be responded with "y" if you are using a KA-10, of course.)
	```
	:midas .mail.;comsat_sysnet;/t
	$$DQDQ==0
	^C
	Limit to KA-10 instructions: n
	```
5. Make sure your ITS system can reach a DNS resolver which allows recursive queries.
 	If you don't use Chaosnet, the default resolver in DQDEV, 1.1.1.1, should work fine as long as packets from ITS reach it.
	You might find the `iptables` incantation below useful:
	```
	iptables -I PREROUTING -t nat -s $YOUR_KLH10_ITS_IP -p udp --dport 53 -j DNAT --to-destination $YOUR_DNS_RESOLVER
	```

	If you use Chaosnet, you need a DNS resolver which knows how to find Chaosnet data, e.g. from the server at DNS.Chaosnet.NET (which does NOT allow recursion).
	Get in touch and I'll help you (@bictorv)!

## Mail
Check out this [external guide](https://its.victor.se/wiki/mail-setup)

## telnet, supdup, ftp
They work out of the box


# Chaosnet
Chaosnet SUPDUP, TELNET and FTP (CHTN and CFTP), are available
but this requires support and configuration
in the emulator to actually use. For KLH10, see [above](#KLH10).

Read more about Chaosnet at https://chaosnet.net.


# Useful resources
- [The ITS Wiki](https://its.victor.se/wiki/start)
