# Build ITS from scratch

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
   `bin`.  There are two bootable tapes, and one tape with files in
   DSKDMP backup format.

2. Then the tapes are used to create a file system on an RP06 disk and
   populate it with a minimal system, and also source code.

3. Finally, the system is booted from the disk, and MIDAS is invoked
   to assemble ITS from source code.
