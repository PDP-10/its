# Using NAT networking to run multiple ITS machines
To run multiple different ITS machines on the same physical host you can use the NAT networking capability provided in SIMH and KLH10 PDP-10 emulators.

There is a default networking configuration for each of the PDP-10 types (KA, KL, KS)

## NAT networking overview
The implementation of the network stack used to enable NAT networking uses the IMP interface for all SIMH PDP-10 machines. The KLH10 emulator follows a different approach enabling runtime network changes.

### SIMH - IMP interface
To enable and configure the IMP interface the respective SIMH initialization script will have to change. 
This change has to happen while the target system is not running.
Each ITS machine type has its own startup file containing the SIMH configuration.
For each IMP instance defined you need to specify unique MAC addresses, IP addresses and know the pre-configured host address of the ITS machine. 
#### How does Network Address Translation work
Network Address Translation (NAT) is a technique used in computer networking to allow devices on a private network to access resources on the Internet or share the same physical network adapter with multiple virtual machines. 
NAT works by translating the private IP addresses used by the virtual machine to an IP address that can be used to connect to the virtual machine. 
This allows multiple devices on a private network to share a single IP address.
In the context of running multiple ITS machines this looks roughly like this:

            +--------------------------+
            |                          |
            |       Internet Router    |
            |        192.168.0.1       |
            +-----------+--------------+
                        |
            +--------------------------+
            |                          |
            |   Host: 192.168.0.100    |
            |                          |
            +-----------+--------------+
                        |
            +-----------+--------------+
            |                          |
            |    virtual IMP device    |
            |       172.16.0.4         |
            +-----------+--------------+
                        |
            +-----------+--------------+
            |                          |
            |       ITS machine        |
            |        10.3.0.6          |
            +--------------------------+

In the example above, the physical adapter address is 192.168.0.100 and the virtual network adapter address is 172.16.0.4. 
The target host network address is 10.3.0.6. When a device on the local network sends a request to the target host via the physical host the host will use the routing information
programmed router will replace the private IP address of the device with the public IP address assigned by the ISP. When the response is received by the NAT router, it will use the mapping it created to send the response to the correct device on the local network.

By using NAT, a private network can use a single public IP address, which is often in short supply, to access the Internet. Additionally, NAT can provide a layer of security by hiding the private IP addresses of devices on the local network from the Internet.

#### Enabling Network Address Translation
To enable NAT networking you will need to add the following block with variations to the startup file
```
set imp enabled
set imp mac=e2:6c:84:1d:34:a3
set imp ip=172.16.0.4/24
set imp gw=172.16.0.2
set imp host=10.3.0.6
at imp nat:gateway=172.16.0.2,network=172.16.0.0/24,tcp=2023:172.16.0.4:23,tcp=2021:172.16.0.4:21
```
#### Parameters
##### enabled
defines if the IMP interface in SIMH will be enabled

##### mac
the MAC address used for this specific IMP instance. This will need to be unique on the enire network.

##### ip 
The virtual IP address of this specific IMP instance. THis needs to be unique on the host. The IP address range supported by IMP is 172.16.0.0/24, this gives you 
theoretically 252 IP addresses to use. 172.16.0.1 and 172.16.0.2 are reserved internally by the IMP implementation. 172.16.0.255 is the broadcast address.

##### gw
The default gateway for this specific IMP instance, it is alway 172.16.0.2 for the ITS networked machines.

##### host
The IP address of the ITS host running in the specific simulator instance. This is listed as the 'Default IP' below.

##### nat
Set the Network Address Translation configuration for the adapter, this will have a few of the above parameters repeated and also define the port mapping between the 
physical host and the ITS instance. 
- gateway is the same as the one above. i.e. 172.16.0.2
- network is the IP network used in CIDR notation. i.e. 172.16.0.0/24
- tcp= are port forwards. <Hostnetwork Port>:<imp IP>:<destination system port> i.e.: tcp=2023:172.16.0.4:23
In the example below the forwards are for both Telnet and FTP and you would Telnet to the system using `telnet 172.16.0.4 2023` to get a session open to the system
```
at imp nat:gateway=172.16.0.2,network=172.16.0.0/24,tcp=2023:172.16.0.4:23,tcp=2021:172.16.0.4:21
```
  

## PDP10-KA
Default IP: 192.168.1.100


## PDP10-KL
Default IP: 10.3.0.6



## PDP10-KS
Default IP: 

