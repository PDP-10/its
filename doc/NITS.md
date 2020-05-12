# Assembling a new ITS

Note: <code><kbd>$</kbd></code> means typing the Altmode or Escape key. `XX` refers to the name of the ITS you are building.

## Step 0. Preliminaries
Here are manuals for all programs mentioned below:
   - [MIDAS](info/midas.26)
   - [SALV](kshack/nsalv.order)
   - [DSKDMP](sysdoc/dskdmp.order)
   - [DDT](_info_/ddtord.1462)
   - [LOCK](_info_/lock.order)

## Step 1. Machine configuration
First examine `SYSTEM; CONFIG >` for changes you want to make.  Look for the text `IFE MCOND XX,[` to find the section for the machine named `XX`. If you are creating a new machine name, use one of the existing blocks as a base. For example, if you are giving your KA10 ITS the name `XX`, make a copy of the `KA` block and rename it `XX`. There are already preconfigured machines for several simulators.

If you want to connect your machine to a network, this is also where you define its network address.

   Common options you may want to consider:
   - NQS, the number of disk drives.
   - IMPP, whether there's an IMP interface.
   - IMPUS3, the machine's **IP address**.
   - NCPP, INETP, CHAOSP, network protocols.

   KA10 specific options:
   - DC10P, RP10P the kind of tape drives.
   - TM10A or TM10B, the kind of tape drive.
   - NUNITS and NEWDTP, number and kind of DECtape drives.
   - TEN11P to enable the Rubin 10-11 interface.  Subordinate options are Knight TV, XGP, CHAOS-11.
   - PDP6P to use an auxiliary PDP-6.
   - TK10P, DPKPP, MTYP, terminal ports.
   - CH10P or T11CHP, the kind of Chaosnet interface.

   KS10 specific options:
   - RM03P, RM80P, RP06P, RP07P, the kind of disk drive.
   - DZ11P, terminal ports.
   - CH11P, Chaosnet interface.

If you are creating a new machine name, you will have to add it to the terminal database too.
   To change properties for terminals, edit the file `SYSTEM; TTYTYP >`.
   Look for the section headed `MCONDX XX,{` or create it based on an existing one.


## Step 2. Disk re-configuration (optional)
If you changed the disk configuration, you should probably reassemble (N)SALV and DSKDMP too.

   SALV is used on the KA10 to check the disks, and is merged with ITS later.  NSALV is the corresponding program for the KS10.  DSKDMP is used for booting the machine, reading a program from disk, and starting it.

   Look for `IFCE MCH,XX,[` in SALV or NSALV.  Update parameters appropriately.

   For DSKDMP, use one of the default configurations, or use ASK and enter values for all parameters.
   - On a KA10, use the HRIFLG switch to make a new DSKDMP paper tape to boot from.
   - On a KS10, use the BOOTSW switch to make a new DSKDMP boot block and save it as `.; BT BIN`.  Then write it to the front end file system:
     ```
     :KSFEDR
     !WRITE
     Are you sure you want to scribble in the FE filesystem? YES
     Which file? BT
     Input from (Default DSK: FOO; BT BIN): .; BT BIN
     !QUIT
     ```

## Step 3. Assemble ITS
It's prudent to store the binary in the `.` directory with a new name.  E.g.

    :MIDAS DSK0:.;NITS BIN_SYSTEM; ITS

Answer the question `MACHINE NAME =` with `XX`.

Forgetting to specify `DSK0:` may later cause `FNF` and `PKNMTD` errors on `DKSDMP` during steps 5 and 6 if the ITS binary ends up on a disk pack other than the first one.

## Step 4. Update (N)SALV (optional)
If you made a change to (N)SALV, you should update @ (N)SALV.  The latter is just (N)SALV dumped with its symbol table and DDT in the core image.

   ```
   L$DDT
   T$(N)SALV BIN
   $U
   D$(N)SALV
   ```

## Step 5. Merge the ITS binary with DDT and (N)SALV

   There are two options for doing this.  The normal way is to reboot and do it in DSKDMP.  The other way is to do it in timesharing DDT.

### DSKDMP method
Use this unless you have a good reason not to.

  1. Shut down ITS with LOCK.  Reboot into DSKDMP.  Use the new DSKDMP if you made one above.
  2. Load DDT: <code>L<kbd>$</kbd>DDT</code>
  3. Give ITS and its symbols to DDT: <code>T<kbd>$</kbd>NITS BIN</code>
  4. You're now in DDT.  Exit back to DSKDMP: <code><kbd>$</kbd>U</code>
  5. Merge in (N)SALV.  For KA10: <code>M<kbd>$</kbd>SALV BIN</code>  For KS10: <code>M<kbd>$</kbd>NSALV BIN</code>
  6. Write the result to disk: <code>D<kbd>$</kbd>NITS</code>  Again, it's prudent to invent a new file name here.  Use <code>F<kbd>$</kbd></code> for a file listing.

If you forgot to specify `DSK0:` in Step 2, or the disk order has changed, you might get `FNF` (FileNotFound) and `PKNMTD` (PacKNotMounTeD) errors. You can mount (load) the other disk packs using the `L$n$` command (with `n` the disk pack to load) and then retry.

### Timesharing DDT method.

   1. Make a new job: <code>ITS<kbd>$</kbd>J</code>
   2. Load DDT without symbols: <code><kbd>$</kbd>1L .; @ DDT</code>
   3. Merge in (N)SALV without symbols.  For KA10: <code><kbd>$</kbd><kbd>$</kbd>1L .; @ SALV</code>  For KS10: <code><kbd>$</kbd><kbd>$</kbd>1L .; NSALV BIN</code>
   4. Merge in ITS with symbols: <code><kbd>$</kbd><kbd>$</kbd>L .; NITS BIN</code>
   5. Write the result to disk: <code><kbd>$</kbd>Y .; @ NITS</code>

## Step 6
If you're in DSKDMP and want to run ITS right away after dumping it, type <code>G<kbd>$</kbd></code>.  You're now in DDT.  You can examine ITS, set breakpoints, etc.  Type <code><kbd>$</kbd>G</code> to start ITS.

## Step 7
When the new ITS has passed testing, rename the old `.; @ ITS` to `.; @ OITS`.  Rename the new ITS to `.; @ ITS`.
