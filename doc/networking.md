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
To get the `pdp10-ka` online with reasonably low effort, use the included SIMH NAT interface via DHCP.
PDP10-KL instructions are in the making and while they should be the same as for KA they are not tested completely yet.

#### Using the host's TAP interface
This enables networking with Network Address Translation (NAT) where the SIMH network adapter gets an IP address from a on network DHCP server. If you are running multiple SIMH instances with diffrerent networking requirements make sure to look at **Configuring networking in KA/KL with static IP assignment**.
Depending on your host you will need to create a 
- TAP network interface
- Network Bridge
- Add your Ethernet adapter and the TAP interface to the network bridge

To do this first install the dependencies if you do not have them
```
apt-get update && apt-get upgrade -y
apt-get install make
apt-get install libpcap-dev
apt-get install bridge-utils
apt-get install uml-utilities
apt-get install net-tools
apt-get install gawk
```

On Raspian/Debian based host systems this script will setup everything automatically.
Make sure you look at your primary ethernet adapter in this case `eth0`
Edit the first lines to reflect your host.
Run this command to get the values for the script
```
$ ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1280
        inet 192.168.1.10  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::215:5dff:fe49:af43  prefixlen 64  scopeid 0x20<link>
        ether 00:15:5d:49:9d:77  txqueuelen 1000  (Ethernet)
        
$ ip route
default via 192.168.1.1 dev eth0 proto kernel        
```
The above are examples from an Ubuntu 20.x system.


> **Note**
>  Edit the script below to match your system!   
>  Especially the adapter name for the ethernet adapter in my case it is `eth0` 

If you are running multiple ITS systems on the same host you can create more TAP adapters and attach them to the same bridge.

```
#!/bin/sh
HOSTIP='<Your ETH0 Host IP Address>' # i.e. 192.168.1.10
HOSTNETMASK='<Your ETH0 Host IP Subnnet mask>' # i.e. 255.255.255.0
HOSTBCASTADDR='<Your ETH0 Broadcast address>' # i.e. 192.168.1.255
HOSTDEFAULTGATEWAY='<Your ETH0 default gateway>' # i.e. 192.168.1.1
ENETADAPTERNAME='eth0'
BRIDGENAME='br0'
TAPNAME='tap0'
#
/usr/bin/tunctl -t $TAPNAME
/sbin/ifconfig $TAPNAME up
#
# Now convert eth0 to a bridge and bridge it with the TAP interface
/usr/sbin/brctl addbr $BRIDGENAME
/usr/sbin/brctl addif $BRIDGENAME $ENETADAPTERNAME
/usr/sbin/brctl setfd $BRIDGENAME 0
/sbin/ifconfig $ENETADAPTERNAME 0.0.0.0
/sbin/ifconfig $BRIDGENAME $HOSTIP netmask $HOSTNETMASK broadcast $HOSTBCASTADDR up
# set the default route to the br0 interface
/sbin/route add -net 0.0.0.0/0 gw $HOSTDEFAULTGATEWAY
# bridge in the tap device
/usr/sbin/brctl addif $BRIDGENAME $TAPNAME
/sbin/ifconfig $TAPNAME 0.0.0.0
```
Verify you have the TAP0 and BR0 interfaces and check you have internet access.

Next configure SIMH
Under your root folder for the project i.e. `/home/<user>/its` edit the SIMH configuration file `out/pdp10-ka/run` or `out/pdp10-kl/run` and configure the `IMP` interface as follows:
```
; enable SIMH network emulation
set imp enabled
; if you are running multiple SIMH instances on the same host you might have to change the MAC address
set imp mac=e2:6c:84:1d:34:a3
; enable DHCP, this will allow SIMH to get an IP address from your home network
set imp DHCP
; configure the ITS host IP
set imp host=10.3.0.6
; Only on PDP10-KA! Set the network interface interrupt
set imp mpx=4
; map the host tap interface
at imp tap:tap0
```
Now start ITS as you normally would.
To find the IP address the SIMH adapter interrupt the simulation by hitting `CTRL+\` and at the `simh>` prompt type `sho imp` the output will give you the IP address of the simulated network card.

```
sim> sho imp
IMP     MAC=E2:6C:84:1D:34:A3, MPX=4, IP=192.168.1.85/24
        GW=192.168.1.1, HOST=10.3.0.6, DHCP Server IP=192.168.1.1, Lease Expires in 5906 seconds
        attached to tap:tap0, DHCP, MIT
```
to return to ITS type `cont` at the `simh>` prompt.

### Configuring networking in KA/KL with static IP assignment

You do not need a TAP or Bridge interface for this type of configuration but it is a bit more involved on the configuration side.
#### Configure SIMH
Under your root folder for the project i.e. `/home/<user>/its` edit the SIMH configuration file `out/pdp10-ka/run` or `build/pdp10-kl/run` and configure the `IMP` interface as follows:

```
set imp enabled    ; enable the SIMH IMP interface
; set the IP address for the emulated system. This needs to be configured correctly in ITS as well.
set imp host=10.0.2.4
; set the IP address of the IMP interface, this is the address the interface will be reachable through on your network.
; adapt this to your own network configuration. 
; uses the CIDR notation IP/SUBNET MASK
set imp ip=172.16.0.4/24 
; set the default gateway for your network
set imp gw=172.16.0.2
; set the nat configuration
; gateway is the same as the one above
; network is the IP network used in CIDR notation
; tcp= are port forwards. <Hostnetwork Port>:<imp IP>:<destination system port>
; in the example below the forwards are for both Telnet and FTP
; you would Telnet to the system using `telnet 172.16.0.4 2023` to get a session open to the system
at imp nat:gateway=172.16.0.2,network=172.16.0.0/24,tcp=2023:172.16.0.4:23,tcp=2021:172.16.0.4:21
; only for KA based emulation set the interrupt for the interface in ITS, normally 4.
set imp mpx=4
```
### SIMH KS10
Albeit untested the above IMP interface should also work with KS10 based emulation.

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
To make ITS use DNS like a modern netizen, you need to do the following. The result will be that the `H3TEXT` table mentioned above will be consulted first, but if it doesn't contain the info you need, DNS will be used.

1. Compile the handler for the DOMAIN: device, which interfaces to DNS.
	```
	:midas device;jobdev domain,sysnet;dqdev
	```
2. Initialize the database for DOMAIN:
	```
	:print domain:xyzzy;..new. (dat)
	```
2. Compile NAME and SUPDUP with a switch to use RESOLV library routines (with DNS support) if the NETWRK library routines (which uses HOSTS3 tables) fail. (`^C` below is Control-C.)
	```
	:midas sysbin;name_sysen2;/t
	DNSP==1
	^C
	:midas sysbin;supdup_sysnet;/t
	DNSP==1
	^C
	```
3. Purify NAME. (`$` below is Escape.)
	```
	name$j
	$l sysbin;name
	debug[ 0
	$g
	```
4. Compile COMSAT (the mail daemon) with a switch to use DOMAIN instead of DQ. In this case, *only* DNS will be used, not the HOSTS3 tables. (The "Limit to KA-10 instructions" question should be responded with "y" if you are using a KA-10, of course.)
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
6. You may want to compile DIG, a test program:
	```
	:midas sysbin;dig_sysnet;
	:link sys;ts dig,sysbin;dig bin
	:dig in;a;hactrn.org
	:dig ch;hinfo;up.update.uu.se
	```

So far, you can configure some parameters by editing the code:
- The DNS server is hardcoded at `ROOHST`/`ROOADR` in `SYSNET;DQDEV`, but it might be more convenient to use the `iptables` trick above to redirect all DNS packets elsewhere.
- The domain search list is hardcoded at `DOMS` in `SYSNET;RESOLV`. When you change it, remember to recompile `NAME`, `SUPDUP`, `COMSAT` and perhaps `DIG` (see above).
- The Chaosnet address-to-name translation domain is hardcoded to `CH-ADDR.NET` in `SYSNET;DQDEV` and in `SYSNET;RESOLV`, but chances are that you want to keep it that way if you join the [Global Chaosnet](https://chaosnet.net).


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
