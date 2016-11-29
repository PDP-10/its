# Incompatible Timesharing System

[![Build Status](https://travis-ci.org/PDP-10/its.svg?branch=master)]
(https://travis-ci.org/PDP-10/its)

### About ITS

ITS, the Incompatible Timesharing System, is an operating system for
the PDP-10 computer family.  It was written by hackers at MIT in the
1960s.  The MIT site was shut down in 1990, but enthusiasts continue
to operate ITS systems to this day.

### About this project

The goals are:

- To provide an automated build from start to end.  No user
  invervention is necessary.

- To check whether source code exists for all programs.  Actually, we
  already found a few cases where they don't.

- To ensure that we know how to build all programs.  In many cases we
  can just invoke MIDAS, but some require the use of DDT.

- To update programs with the latest bug fixes and enhancements.

- To be able to set configurable options across the whole system, such
  as host name, IP address, hardware devices.

The build currently runs on the SIMH and KLH10 emulators.  Of course,
we'd be delighted to test this on a real KS10.

### Documentation

See the [`doc` subdirectory](doc) for documentation.

There's a [DDT cheat sheet](doc/DDT.md) for Unix users.

### Building it from scratch

This repository contains source code, tools, and scripts to build ITS
from scratch.

1. First, magnetic tape images are created from files in `src` and
   `bin`.  There are two bootable tapes, and two tapes with files in
   DUMP backup format.

2. Then the tapes are used to create a file system on an RP06 disk and
   populate it with a minimal system.

3. Next, the system is booted from the disk.  Source code is loaded
   from tape, and the following programs are rebuilt:

   - MIDAS, the assembler.
   - DDT, debugger and HACTRN user login shell.
   - The ITS monitor (kernel).
   - Exec DDT, standalone debugger.
   - NSALV, standalone file system tool.
   - DSKDMP, disk bootstrap and file access.
   - KSFEDR, manipulate front-end file system.

4. The new DSKDMP is installed, and the rebuilt monitor and salvager
   are combined into a new ITS binary, which is then started.

5. Remaining programs are rebuilt:

   - TECO, editor.
   - EMACS, binaries only.
   - DUMP, tape backup and restore.
   - PDSET, set time and date.
   - LOCK, shut down system.
   - ATSIGN DEVICE, load device drivers.
   - TCTYP and CRTSTY, terminal handling.
   - PEEK, system monitoring.
   - ARCDEV, transparent file system access to archive files.
   - DIRDEV, list directories, sorted or subsetted.
   - ATSIGN TARAKA, starts dragons.
   - Dragons: DMPCPY, MODEMS, NETIME, PFTHMG.
   - MTBOOT, make bootable tapes.
   - HOSTS3, the host table compiler.
   - H3MAKE, a job that requests DRAGON to build host table.
   - ATSIGN TCP, TCP support
   - TELSER, Telnet/Supdup server
   - TELNET, Telnet client
   - SUPDUP, Supdup client
   - FTPS, FTP Server
   - FTPU, FTP Client
   - NAME, Shows logged in users and locations, aka FINGER
   - TALK/WHO/WHOJ/WHOM/USERS, list users.
   - MLDEV, MLSLV, Allows access to remote systems as devices (e.g. DB:)
   - CHTN, CFTP, Chaosnet TELNET and FTP support
   - FIND, search for files.
   - TTLOC, Advertises physical location of logged in users
   - SRCCOM, Compares/merges source files, compares binary files
   - DDTDOC, interactive DDT documentation.
   - COMSAT, Mail server
   - MAIL, Mail sending client
   - RMAIL, Mail reading client
   - DQ Device, for doing hostname resolutions. Used by COMSAT.
   - DSKUSE, disk usage information.

6. A brand new host table is built from the host table source and
   installed into SYSBIN; HOSTS3 > using H3MAKE.

7. Finally, the whole file system is dumped to tape.

### Network Support

Currently, networking is only supported under the KLH10 emulator. SIMH does
not have the necessary support. As of this release, only the ITS monitor,
host table tools, and binary host table are installed. 

Currently, basic TCP network support is in the build, in addition to
both a TELNET/SUPDUP server, and both TELNET and SUPDUP clients.
Additionally, both an FTP server and client are included. Chaosnet TELNET 
and FTP (CHTN and CFTP), but this requires support and configuration
in the emulator to actually use. SMTP mail inbound and outbound is included,
as well as local mail delivery.

The KLH10 dskdmp.ini file has an IP address (192.168.1.100) and gateway IP 
address (192.168.0.45) configured for the ITS system. The IP address 
matches the address configured in SYSTEM; CONFIG > (as IMPUS3). Finally,
the HOST table source (SYSHST; H3TEXT >) and binary (SYSBIN; HOSTS3 >)
defined a host called DB-ITS.EXAMPLE.COM at the IP address 192.168.1.100.

In order to change the IP address of the host, you must update multiple
places and rebuild ITS and the host table. You will also have to modify
dskdmp.ini.  Here are the places where the IP address is configured (and all
of these must agree):

dskdmp.ini (in build/klh10 directory on the host)  
SYSTEM; CONFIG > (ITS configuration file)  
SYSHST; H3TEXT > (host table source file)  
SYSBIN; HOSTS3 > (binary file compiled from SYSHST; H3TEXT >)
