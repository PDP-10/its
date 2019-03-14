# The PDP-6

### History

The MI AI Lab traded in a PDP-1 for a PDP-6 in the mid 1960s and used
it stand alone for some years.  ITS was first written for this machine
and it was operational in 1967.  The following year a PDP-10 arrived,
and it was arranged to share the I/O and memory buses with the PDP-6.
The PDP-6 continued to be the main timesharing machine at first, with
the PDP-10 as a subordinate processor.  ITS was ported to the PDP-10
and eventually became the master.

The Dynamic Modeling group also received a PDP-6 in 1969, but quickly
moved on to a PDP-10.  Their PDP-6 never saw much use.

### Simulator

Angelo Papenhoff's PDP-6 simulator is checked out in the `tools/pdp6`
directory.  Using it is still in an experimental state.  To run it, go
to `tools/pdp6/emu` and run the `pdp6` program.  For shared memory to
work, the KA10 simulator must be started first.

### Stand alone operation

These programs work on stand alone on the PDP-6 simulator:

- SYSTEM GEN - Marks a bootable Microtape.
- MACDMP - Read, write, and start programs from Microtape.
- TECO - Text editor.
- MIDAS - Assembler.

### Shared memory

When the PDP-6 simulator is properly configured and started after the
KA10 simulator, the processors will share the PDP-6 core memory
between them.  ITS has a facility to create a job and have it's
virtual memory range map to the PDP-6 core.

To make use of this, make a job named `PDP6` or `PDP10`.  The latter
is from when the PDP-10 was the secondary processor.  Reading or
writing locations in this job will now access the PDP-6 memory.  It's
possible to load a program with `$L` or`:LOAD`.  Starting, stopping,
stepping, or setting breakpoints is not possible.  These must be done
from the PDP-6 console panel, or from DDT running on the PDP-6.
