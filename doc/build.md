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

5. Remaining programs are rebuilt.

6. A brand new host table is built from the host table source and
   installed into SYSBIN; HOSTS3 > using H3MAKE.

7. Finally, the whole file system is dumped to tape.
