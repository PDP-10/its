# Incompatible Timesharing System

[![Build Status](https://travis-ci.org/PDP-10/its.svg?branch=master)](https://travis-ci.org/PDP-10/its)

### About ITS

ITS, the Incompatible Timesharing System, is an operating system for
the PDP-10 computer family.  It was created by hackers at MIT in the
1960s.  The MIT site was shut down in 1990, but enthusiasts continue
to operate ITS systems to this day.

Some notable ITS features:

- Hosted the first versions of Emacs, Zork, Macsyma, Maclisp, and Scheme
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

A list of [known ITS machines](doc/machines.md).

### Build procedure

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

   - 11SIM, PDP-11 emulator.
   - 20XCVT, convert TOPS-20 CSAVE file to PDUMP.
   - @, cross reference generation tool.
   - ACCLNK, sets com-link accept bit for specified TTY.
   - ACOUNT, dummy account program used for users from safe sites.
   - ADVENT, (Colossal Cave) Adventure by Will Crowther.
   - ARCCPY, copies and old-format archive, converting to new format.
   - ARCDEV, transparent file system access to archive files.
   - ARCSAL, archive salvager.
   - ARGUS, alerts you when specified users login or logout.
   - ATSIGN CHAOS, Chaosnet support.
   - ATSIGN DEVICE, load device drivers.
   - ATSIGN TARAKA, starts dragons.
   - ATSIGN TCP, TCP support.
   - BALANC, MOVDIR, balances directories.
   - BDAY, happy birthday demon.
   - BINPRT, display information about binary executable file.
   - BITPRT, print JCL as bits.
   - BYE, say goodbye to user. Used in LOGOUT scripts.
   - CALPRT, decode a .CALL instructions CALL block.
   - CC, C compiler (binary only).
   - CHADEV, Chaosnet jobdev (binary only).
   - CHARFC/CHARFS, Chaos RFC.
   - CHATST, Chaos test.
   - CHESS2, Greenblatt chess program.
   - CHTN, CFTP, Chaosnet TELNET and FTP support.
   - COMIFY, convert HEX to COM format.
   - COMPLR, lisp compiler.
   - COMSAT, Mail server.
   - CREATE, creates a text file in your home directory from console input.
   - CROCK, analog watch.
   - CROSS, cross assembler for micros.
   - CTIMES, Chaosnet time server.
   - CTIMSR, Chaosnet time server.
   - DATE, print date and time.
   - DATSRV, server for RFC 867 Daytime protocol.
   - DCROCK, digital watch.
   - DDTDOC, interactive DDT documentation.
   - DECUUO, TOPS-10 and WAITS emulator.
   - DIRCPY, copy directory.
   - DIRDEV, list directories, sorted or subsetted.
   - DIRED, directory editor (independent from EMACS DIRED).
   - DMPCPY, crach dump copy dragon.
   - DP Device, 7-bit conversions?
   - DQ Device, for doing hostname resolutions. Used by COMSAT.
   - DSKDEV, D - short disk device.
   - DSKUSE, disk usage information.
   - DUMP/LOAD, tape backup and restore.
   - EMACS, editor.
   - EXECVT, convert 20x.exe (SSAVE) file to ITS BIN (PDUMP) file.
   - EXPN/VRFY - query remote SMTP server.
   - FAIL, assembler from SAIL.
   - FCDEV, talk to LispM file server.
   - FDIR, fast directory listing.
   - FED, font editor.
   - FIDO, watch for system events and bark.
   - FILE, Chaosnet file server.
   - FIND, search for files.
   - FRETTY, display list of free TTYs.
   - FTPS, FTP Server.
   - FTPU, FTP Client.
   - GETSYM, copy all symbols from running ITS to a file.
   - GMSGS, copy system messages to mail file.
   - H3MAKE, a job that requests DRAGON to build host table.
   - HEXIFY, convert COM file into Intel HEX format.
   - HOST, display information about network host.
   - HOSTAB, display HOSTS2 format host table.
   - HOSTS3, the host table compiler.
   - HSNAME, displays user's HSNAME.
   - HSNDEV, HSNAME device.
   - IDLE, list idle users.
   - IFILE, Chaosnet file service.
   - INIT, a helper program for LOGIN, LOGOUT, and other script files.
   - INLINE, reads line from TTY and adds to JCL (for DDT init files).
   - INQUIR, user account database.
   - INQUPD, processes INQUIR change requests.
   - INSTAL, install executables on other ITS machines.
   - ITSDEV, ITS device server.
   - JEDGAR, counter spying tool.
   - JOBS, list jobs by category.
   - LISP, lisp interpreter and runtime library (autoloads only).
   - LOADP, displays system load.
   - LOCK, shut down system.
   - LOOKUP, looks up user info in INQUIR database.
   - LOSS (device).
   - LSPEED, set tty line parameters.
   - LUSER, request help from registered list of logged-in users.
   - MAGDMP, standalone program loader/dumper for magtape.
   - MAGFRM, create tapes for use with MAGDMP.
   - MAIL, Mail sending client.
   - MAILT, allows editing mail (from :MAIL) in EMACS.
   - METER, displays system metering information.
   - MLDEV, MLSLV, Allows access to remote systems as devices (e.g. DB:).
   - MODEMS, modems gragon.
   - MSPLIT, split a file into smaller parts.
   - MTBOOT, make bootable tapes.
   - NAME, Shows logged in users and locations, aka FINGER.
   - NETIME, network time dragon.
   - NICNAM/NICWHO, look up someone in the ARPAnet directory.
   - NUDIR, create user directory.
   - NWATCH, small watch display.
   - OBS, observe system activities.
   - OCM, chess program.
   - OCTPUS, print character representations.
   - OS, realtime TTY spy.
   - PALX, PDP-11 cross assembler.
   - PANDA, user account management program.
   - PDSET, set time and date.
   - PEEK, system monitoring.
   - PFTHMG, Puff the magic dragon.
   - PHOTO, capture STY session output.
   - PLAN (CREATE), creates a PLAN file in your home directory from console input.
   - PORTS, display free network ports.
   - PR, print out various system documentation.
   - PRINT, print long-named files.
   - PROBE, probe inside job and display various information about it.
   - PRUFD, list files on disk volume.
   - PSEND, super sender.
   - PT, pager test.
   - PTY, pseudo-tty.
   - PWMAIL, a limited version of MAIL when not yet logged in under PWORD.
   - PWORD, replacement for sys;atsign hactrn that requires registered logins.
   - QUOTE, prints out a random quote.
   - REATTA, reattaches disowned jobs to terminal.
   - REDRCT, redirect IP routing.
   - RIPDEV, replacement for MLDEV for no-longer-existing machines.
   - RMAIL, Mail reading client.
   - RMTDEV, MLDEV for non-ITS hosts.
   - SALV, old file system tool for KA and KL.
   - SCANDL, TTY OUTPUT SPY.
   - SEND, REPLY, replacements for DDT :SEND.
   - SENDS, Chaosnet SEND server.
   - SENSOR, sends censor.
   - SENVER, Chaosnet SEND server.
   - SN, snoop terminal.
   - SPCWAR, Spacewar game.
   - SPELL, ESPELL spell checker.
   - SRCCOM, Compares/merges source files, compares binary files.
   - STINK, linker.
   - STINKR, new linker (binary only).
   - STTY, set terminal parameters.
   - STY, pseudo-terminal for multiple sessions.
   - STYLOG, convert PTY output file into ascii file.
   - SUPDUP, Supdup client.
   - SYSCHK, check up on system job.
   - SYSLOD, system load histogram.
   - SYSMSG, displays system messages.
   - TAGS, generate tags table for sources.
   - TALK/WHO/WHOJ/WHOM/USERS, list users.
   - TCTYP and CRTSTY, terminal handling.
   - TEACHE, Emacs tutorial.
   - TECO, editor.
   - TELNET, Telnet client.
   - TELSER, Telnet/Supdup server.
   - TEN50, TOPS-10 emulator.
   - TIME, displays date/time/uptime and other info.
   - TIMES, TCP time server.
   - TIMOON, displays the time and phase of the moon.
   - TIMSRV, RFC 868 network time protocol.
   - TMPKIL, clean out old files in .TEMP.;.
   - TTLOC, Advertises physical location of logged in users.
   - TTY, displays TTYs with UNAME/JNAME/CORE and other info.
   - TTYSWP, swap TTYs.
   - TYPE8, type 8-bit file.
   - UFIND, find users.
   - UNTALK, split-screen comm-link program.
   - UP/DOWN, check if host is online.
   - UPTIME, Chaosnet uptime server.
   - USQ, unsqueeze/uncram a file.
   - VV/VJ/DETREE, list jobs.
   - XHOST, tool for replacing host nicnames with real hostnames.
   - WHAT, humorous quips to various "what" questions.
   - WHO%, list index/uname/jname/%time in sorted list.
   - WHOLIN, mode line for display terminals (with date/time/job/etc info).
   - WHOSEN, print author of last send.
   - X, Y, Z, remember DDT command and re-execute it.

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

In order to change the IP address of the host, you can edit IP, GW,
and NETMASK in the file conf/network.  You can also set a Chaosnet
address.  After that, a full rebuild (e.g. `make clean all`) is required.
