# Incompatible Timesharing System

[![Travis CI Build Status](https://travis-ci.org/PDP-10/its.svg?branch=master)](https://travis-ci.org/PDP-10/its)
[![GitLab CI Build Status](https://gitlab.com/PDP-10/its/badges/master/pipeline.svg)](https://gitlab.com/PDP-10/its/commits/master)

### About ITS

ITS, the Incompatible Timesharing System, is an operating system for
the PDP-10 computer family.  It was created by hackers at MIT in the
1960s.  The MIT site was shut down in 1990, but enthusiasts continue
to operate ITS systems to this day.

Some notable ITS features:

- Hosted the first versions of Emacs, Zork, Macsyma, Maclisp, Scheme, and
  multi-player Maze War
- Virtual memory
- User-space device drivers
- Networking: TCP/IP, ARPAnet, Chaosnet
- Transparent network file system
- Terminal-independent text output
- Graphical workstations

There is a mailing list for discussion about ITS.  Go to
http://its.victor.se/mailman/listinfo/its-hackers_its.victor.se
for more information.

### About this project

This repository contains source code, tools, and scripts to build an
ITS system from scratch.

The goals are:

- To provide an automated build from start to end.  No user
  intervention is necessary.

- To check which programs have source code, and [which programs are missing
  source code](https://github.com/PDP-10/its/issues/61).

- To ensure that we know how to build all programs.

- To update programs with the latest bug fixes and enhancements.

- To be able to set configurable options across the whole system, such
  as host name, IP address, hardware devices.

The build currently runs on the SIMH and KLH10 emulators.  Of course,
we'd be delighted to test this on a real KS10.

### Usage

To build ITS with this repository, you need some tools installed:
make, C compiler, and expect.  For KA10, you also need SDL or SDL2 for
the Type 340 display.  Ensure all submodules are checked out, and then
type `make EMULATOR=simh`, `make EMULATOR=sims`, or `make
EMULATOR=klh10`.  This will leave built files in the `out` directory,
one of which is a disk image with ITS installed.

To start ITS, type `./start`.  If you see `KLH10#`, type `go` and
Enter.  When you see the `DSKDMP` prompt, type `its`, press Enter, and
then `ESC g`.  Eventually, you will see `SYSTEM JOB USING THIS
CONSOLE`.  You are now ready to log in, so type Control-Z.  See
[doc/DDT.md](doc/DDT.md) for a list of useful commands.  When done,
shut down orderly by typing `:lock` and then `5down`.

ITS can optionally use some additional peripheral devices.  To attach
a simulated GT40 graphics terminal, type `./start gt40` when booting
ITS.

To install your personal user files, add a subdirectory under `user`
with your files inside.  They will be copied to ITS.  The directory
name is limited to six characters, and file names must have two
six-character parts separated by a period.

Here is an overview of the repository:
- bin - PDP-10 binary files necessary to bootstrap the system.
- build - build scripts.
- conf - configuration for building ITS.
- doc - documentation, most of which appear in the INFO system.
- src - source code for ITS and all programs.
- tools - build tools.
- out - build output.
- user - optional user files installed in ITS.

### Documentation

See the [`doc` subdirectory](doc) for documentation.

There are some short introductions for beginners:
- [DDT cheat sheet for Unix users](doc/DDT.md)
- [Basic editing with EMACS](doc/EMACS.md)
- [TECO survival guide](doc/TECO.md)
- [DDT debugging newbie guide](doc/debugging.md)
- [Hello MIDAS](doc/hello-midas.md)
- [DUMP and itstar](doc/DUMP-itstar.md)
- [Games](doc/games.md)
- [Printing](doc/printing.md)
- [Assembling ITS](doc/NITS.md)
- [Com link mode](doc/comlink.md)
- [Logo](doc/logo.md)
- [PDP-6](doc/pdp6.md)

A list of [known ITS machines](doc/machines.md).

How [ITS is built](doc/build.md).

### Applications

Some major applications:

- Adventure, game
- C10, C compiler
- DDT, debugger
- Emacs, editor
- Logo, interpreter
- Mac Hack VI and Tech II, chess programs
- Maclisp, interpreter and compiler
- Muddle, interpreter
- Macsyma, symbolic math
- Maze War, game
- Midas, assembler
- PDP-11 simulator
- Scheme, interpreter
- Spacewar!, game
- Stanford University Drawing System
- TECO, editor
- TOPS-10 and WAITS emulator

There is a [detailed list of all installed programs](doc/programs.md).

### Network Support

Currently, networking is only supported under the KLH10 and SIMH KA10
emulators. The SIMH KS10 does not have the necessary support. As of
this release, only the ITS monitor, host table tools, and binary host
table are installed.

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

In order to change the IP address of the host, you can edit IP, GW,
and NETMASK in the file conf/network.  You can also set a Chaosnet
address.  After that, a full rebuild (e.g. `make clean all`) is required.
