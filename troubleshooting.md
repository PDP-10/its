# Troubleshooting guide

This guide will help you sort out the most common issues of running ITS on the PiDP-10.
Issues covered so far:

* [COMSAT is crashing on start](#comsat-is-crashing-on-start)

through out the document you will see certain special characters mentioned. They are slightly different depending on your keyboard and terminal
* `$` means the ALT or ESC key
* `^` means the CTRL or STRG key
* `<escape>` means the ALT or ESC key in EMACS
* `<control>` means the Control key in EMACS

## COMSAT is crashing on start
Thanks to eswenson for the intial steps here

In order for INQUIR entries to stick, you must have COMSAT running. 

If you run PEEK, you should see two COMSAT jobs. One has the JNAME IV and the other JOB.nn.  If these jobs are not present, then COMSAT may have started and died or not started at all
```
*:peek
KA ITS 1651  Peek 631   8/14/2024 09:59:35  Up time = 5:05
Memory: Free=457   Runnable Total=11 Out=3     Users: High=13 Runnable=0
Index Uname Jname Sname     Status   TTY    Core Out %Time    Time PIs
  0 SYS    SYS    SYS        HANG    ?        71   0   0%          1
  1 CORE   JOB    CORE       UUO     ?         0   0   0%
  2 MIKEK  HACTRN MIKEK      HANG    >        30   9   0%
 12  MIKEK  PEEK   MIKEK     +TTYBO  T52 C    11   2   0%
  3 .BATCH BATCHN .BATCH     SLEEP   ?       126  23   0%
  4 TARAKA CNAVRL CNAVRL     10!0    ? DSN    29   0   0%          .VALUE
  5 GUNNER GUNNER GUNNER    _SLEEP   ?        11   3   0%
  6 TARAKA PAPSAV PAPSAV     HANG    ?         1   0   0%
  7 TARAKA NAMDRG NAMDRG     HANG    ?        29   0   0%
 10 PFTHMG DRAGON PFTHMG     HANG    ?         6   0   0%
 11 TARAKA JOB.07 SYS        HANG    ?         3   0   0%
Fair Share 99%     Totals:                   317       0%          1
Logout time =         Lost 0%  Idle 98%  Null time = 5:07
```
As you can see above none of the COMSAT processes are running.

There are several reasons why COMSAT may die upon startup The most common are:
Lets start going through those one by one:

### Network parameters for COMSAT are not correct.
When you bring up KA ITS, you'll see a message on the operator console like this:

 LOGIN  TARAKA 0 12:09:11
TOP LEVEL INTERRUPT 200 DETACHED JOB # 4, USR:COMSAT IV     12:09:12

This means that COMSAT has crashed.

If you look at the IP address that COMSAT is configured with:
```
comsat$j
$l .mail.;comsat launch
bughst/'NEW$:   SHOWQ+50,,PAT+6   =30052000544
```

you'll note that that octal address is: 192.168.1.100

If you look at the value that ITS has for the machine's IP address:

```
sys$j!
*impus3=1200600006
```

You'll see that that that octal address is: 10.3.0.6

And if you look at the host table (SYSHST;H3TEXT >), you'll find an entry like this:
```
HOST : CHAOS 177002, 192.168.1.100 : DB-ITS.EXAMPLE.COM, DB : PDP-10 : ITS : :
```

(And there is no HOST entry for a machine with the name KA).

The easiest fix is to:

1) fix the host table
2) fix COMSAT's variables
3) generate COMSAT's database files
4) fix COMSAT's mailing lists file
5) restart COMSAT

To fix the host table, change the line:
```
HOST : CHAOS 177002, 192.168.1.100 : DB-ITS.EXAMPLE.COM, DB : PDP-10 : ITS : :
```
to
```
HOST : CHAOS 177002, 10.3.0.6 : KA : PDP-10 : ITS : :
```
Save the updated `SYSHST;H3TEXT >` and then compile the host table:
```
:SYSHST;H3MAKE
```
Make sure that there were no errors (look for a `H3ERR` file) and make
sure that there exists a file `SYSBIN;HOSTS3 NNNNNN` where `NNNNNN` matches
the `FN2` of the `SYSHST;H3TEXT NNNNNN` you just created.

Now your host table matches your ITS IP address.

Next, you need to fix COMSAT.

To do that, create a job for COMSAT:
```
comsat$j
```
Then load in the compiled (but not dumped) binary for COMSAT
```
$l .mail.;comsat bin
```
And now set various variables:
```
BUGHST/1200600006
DEBUG/0
xvers/0
```
And then purify the binary:
```
purify$g
```
and when DDT prints out:
```
:PDUMP DSK:.MAIL.;COMSAT LAUNCH
```
Type an `<enter>` to confirm.

Now, you have an correct `.MAIL.;COMSAT LAUNCH` executable.  This will be
launched by `TARAKA` on startup, or by `:MAIL` when invoked if `COMSAT` isn't
running.

However, before you do this, you need to make sure that COMSAT's database
files are created.

To do that, do this:
```
comsat$j
$l .mail.;comsat launch
debug/-1
mfinit$g
```
You should see a message like:
```
:$ File Directory Initialization successfully completed...
Proceeding will launch Comsat. $
*
```
Don't proceed the COMSAT job, because it will be run as your
UNAME rather than COMSAT's.  Simply kill the COMSAT job:
```
:kill
```
Now, there is one last step.  The file `.MAIL.;NAMES >` has entries
for DB (ITS) rather than KA.  It needs updating.

In emacs, open up `.mail.;names >` and do a query replace of all instances of DB
with KA.

To do that, enter the Query Replace command:
```
<escape>%
```
The echo area should display:
```
MM Query Replace$
```
Type in `DB<escape>KA<escape><escape>`

Your cursor will be positioned at the first instance of the string DB.

Type in

`!`
Yes, just the exclamation point character.  This will replace all instances
of `DB` with `KA`.

Save the file. (`<control>x<control>s`) and return to DDT (`<control>x<control>c`).

Now, you are ready to launch `COMSAT`.

But first, make sure there is no (dead) comsat running, but running `peek^k`

Look for any job with the UNAME COMSAT (and the JNAME IV).  If you find one,
kill the job by typing:

`<job number>X`

Then, exit PEEK with the "q" command.

Now, send yourself a message:
```
:MAIL <your-uname>
<some message>
<control>c
```
You should see the message:
```
C Communications satellite apparently dead.
Re-launching, hang on... now in orbit!
```
Now, COMSAT should be running.  You can check with PEEK.

You also should see that your mail was delivered. Type:
```
:PRMAIL<enter>
```
to read (and optionally delete) it.



