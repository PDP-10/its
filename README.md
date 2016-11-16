# Incompatible Timesharing System

[![Build Status](https://travis-ci.org/PDP-10/its.svg?branch=master)]
(https://travis-ci.org/PDP-10/its)

### About ITS

ITS, the Incompatible Timesharing System, is an operating system for
the PDP-10 computer family.  It was written by hackers at MIT in the
1960s.  The MIT site was shut down in 1990, but enthusiasts continue
to operate ITS systems to this day.

### Documentation

See the [`doc` subdirectory](doc) for documentation.

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
   - TECO, editor.
   - DUMP, tape backup and restore.
   - PDSET, set time and date.
   - KSFEDR, manipulate front-end file system.
   - LOCK, shut down system.
   - ATSIGN DEVICE, load device drivers.
   - TCTYP and CRTSTY, terminal handling.
   - PEEK, system monitoring.
   - ARCDEV, transparent file system access to archive files.

4. Finally, the whole file system is dumped to tape.
