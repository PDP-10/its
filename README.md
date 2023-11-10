# Incompatible Timesharing System

![CI Build Status](https://github.com/PDP-10/its/workflows/Build/badge.svg)

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

### Building

To build ITS with this repository, you need some tools installed; see
the table below.  Ensure all submodules are checked out, and then type
`make EMULATOR=simh`, `make EMULATOR=pdp10-ka`, `make
EMULATOR=pdp10-kl`, `make EMULATOR=pdp10-ks`, or `make
EMULATOR=klh10`.  This will leave built files in the `out` directory,
some of which are disk images with ITS installed.

| Emulator | Dependencies |
| --- | --- |
| common to all | git, c compiler, make, expect, curses, autoconf
| klh10 | 
| simh | sdl2
| pdp10-ka | sdl2, sdl2-image, sdl2-net, gtk3
| pdp10-kl | sdl2, sdl2-image, gtk3
| pdp10-ks | sdl2

### Usage

To start ITS, type `./start`.  If you see `KLH10#`, type `go` and
Enter.  If you see the `DSKDMP` prompt, type `its`, press Enter, and
then <kbd>ESC</kbd><kbd>G</kbd>.  If you use the `pdp10-kl` emulator there is no prompt
and you need to type <kbd>ESC</kbd><kbd>L</kbd> `ITS`, press Enter, and then <kbd>ESC</kbd><kbd>G</kbd>.
Eventually, you will see `SYSTEM JOB USING THIS CONSOLE`.  You are now
ready to log in, so type <kbd>CTRL</kbd><kbd>Z</kbd>.  See [doc/DDT.md](doc/DDT.md) for
a list of useful commands.

Alternatively to logging in directly in the system console window, 
which will always be displaying daemon messages, you may prefer to 
use a seperate terminal session for logging in.  To do this just
run `telnet localhost <port>` from another shell window and press
<kbd>CTRL</kbd><kbd>Z</kbd> to log in there. The port should be determined as per this list:

| Port  | Type             | Emulator
| ----  | ----             | -------
| 10000 | TK10             | pdp10-ka
| 10002 | Datapoint kludge | pdp10-ka
| 10003 | Morton box       | pdp10-ka
| 10004 | DZ11             | simh, pdp10-ks
| 10007 | DTE2             | pdp10-kl
| 10008 | DL10             | (pdp10-kl in the future?)

To shut down ITS, type `:lock` and then `5down`.  Log yourself out to
avoid the 5 minute grace period: type `:logout`.  When ITS writes
`SHUTDOWN COMPLETE`, it's safe to stop the emulator.  Press <kbd>CTRL</kbd><kbd>\\</kbd>
to escape to the simulator command prompt and `quit` to close it.  If
you had a separate telnet user session running you can similary
press <kbd>CTRL</kbd><kbd>\[</kbd> and then exit telnet.

ITS can optionally use some additional peripheral devices.  To attach
a simulated GT40 graphics terminal, type `./start gt40`.  If you run
the KA10 emulator, you can use the Knight TV raster display by typing
`./start tv11 tvcon`.  On a TV, type <kbd>F1</kbd> instead of <kbd>CTRL</kbd><kbd>Z</kbd>.

Here is an overview of the repository:
- bin - PDP-10 binary files necessary to bootstrap the system.
- build - build scripts.
- conf - configuration for building ITS.
- doc - documentation, most of which appear in the INFO system.
- src - source code for ITS and all programs.
- tools - build tools.
- out - build output.
- user - optional user files installed in ITS.

### Terminal Emulators

Several emulators for terminals and peripheral processors are built
along with ITS.  They can be started conveniently with the `start`
script, or separately.  Not all terminal emulators are set up to work
with all PDP-10 emulators by default.

| Name    | Description       | Type   | klh10 | pdp10-ka | pdp10-kl | pdp10-ks | simh
| ------- | ----------------- | ------ | ----- | -------- | -------- | -------- | ----
| type340 | Type 340          | vector | no    | yes      | no       | no       | no
| gt40    | GT40 PDP-11       | vector | no    | yes      | no       | yes      | yes
| imlac   | Imlac PDS-1       | vector | no    | yes      | no       | no       | no
| simh_imlac | Imlac PDS-1    | vector | no    | yes      | no       | no       | no
| tv11    | Knight TV PDP-11  | cpu    | no    | yes      | no       | no       | no
| tvcon   | Knight TV console | raster | no    | yes      | no       | no       | no
| datapoint | Datapoint 3300  | text   | no    | yes      | no       | no       | no
| vt52    | VT52              | text   | no    | yes      | yes      | yes      | yes
| tek     | Tektronix 4010    | vector | no    | yes      | yes      | no       | no

### Documentation

See the [`doc` subdirectory](doc) for documentation.

There are some short introductions for beginners:
- [How to create a new user](doc/new-user.md)
- [DDT cheat sheet for Unix users](doc/DDT.md)
- [Basic editing with EMACS](doc/EMACS.md)
- [TECO survival guide](doc/TECO.md)
- [DDT debugging newbie guide](doc/debugging.md)
- [Hello MIDAS](doc/hello-midas.md)
- [Hello Maclisp](doc/hello-lisp.md)
- [Introduction to Muddle](doc/muddle.md)
- [DUMP and itstar](doc/DUMP-itstar.md)
- [Games](doc/games.md)
- [Printing](doc/printing.md)
- [Assembling ITS](doc/NITS.md)
- [Com link mode](doc/comlink.md)
- [Logo](doc/logo.md)
- [PDP-6](doc/pdp6.md)
- [Networking](doc/networking.md)

A list of [known ITS machines](doc/machines.md).

How [ITS is built](doc/build.md).

### Applications

Some major applications:

- Adventure, game
- C10, C compiler
- CLU, progamming language.
- DDT, debugger
- Emacs, editor
- Logo, interpreter
- Mac Hack VI and Tech II, chess programs
- Maclisp, interpreter and compiler
- Muddle, interpreter
- Macsyma, symbolic math
- Maze War, game
- Midas, assembler
- Muscom and musrun, for playing music
- PDP-11 simulator
- Scheme, interpreter
- Spacewar!, game
- Stanford University Drawing System
- TECO, editor
- TOPS-10 and WAITS emulator

There is a [detailed list of all installed programs](doc/programs.md).
