# Troubleshooting guide

This guide will help you sort out the most common issues of running ITS on the PiDP-10.
Issues covered so far:

* [COMSAT is crashing on start](#comsat-is-crashing-on-start)

Throughout the document you will see certain special characters mentioned. They are slightly different depending on your keyboard and terminal
* `$` means the ESC key
* `^` means the CTRL or STRG key
* `<escape>` means the ESC key
* `<control>` means the CTRL or STRG key

## COMSAT is crashing on start
Thanks to eswenson for the intial steps here

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
* Network configuration issues
* Uninitialzed Mail directory structure
* Other configuration issues
* 
Lets start going through those one by one:

### Network parameters for COMSAT are not correct.
When you bring up KA ITS, you'll see a message on the operator console like this:

 LOGIN  TARAKA 0 12:09:11
TOP LEVEL INTERRUPT 200 DETACHED JOB # 4, USR:COMSAT IV     12:09:12

This means that COMSAT has crashed.
The next series of steps assumes you have logged into ITS using
```
< your username>$$u
```

If you look at the IP address that COMSAT is configured with:
```
comsat$j
$l .mail.;comsat launch
bughst/'NEW$:   SHOWQ+50,,PAT+6   =30052000544
```

you'll note that that octal address translates to: 192.168.1.100

>![NOTE]
> To convert from the Octal representation of the IP Address to the tuple representation you can use the approach listed below at
>(Convert IP address)[#convert-ip-address]


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

### Fixing the host table
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

### Fixing the COMSAT binary
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

### Create the COMSAT database files
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

### Verify the changes
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

### Convert IP address
If you are wondering how to convert octal IP addresses on ITS to the familiar octet pattern, see this example:

Let’s say you want to convert 1200600006 to a standard-formatted IP address.  First ensure that the value has 12 octal digits.  In this case, you’ll have to add two 0s at the left to get:

001200600006

Then, break that value up into octal values:

001 200 600 006

Then, convert the above to binary:

000 000 001 010 000 000 110 000 000 000 000 110

Then, group into 4 (ignored) bits, followed by 4 8-bit bytes:

0000  00001010 00000011 00000000 00000110

Then, ignoring the first 4 bits, convert each 8-bit byte to decimal:

      10      3        0        6

So 10.3.0.6 is the same as 1200600006 octal.

Lars created a shell script that will do the trick too.  You *have* to make sure the input is 12 octal digits long when invoking it:

```
#!/bin/bash

if [ $# -eq 0 ]; then
 echo "Please provide an IP address as an argument"
 exit 1
fi

octal=$1
ip=""
for i in {1..4}; do
 octet=$(echo $(( $octal >> 8*(4-$i) & 255 )))
 ip="$ip$octet."
done

echo ${ip%?}
```
You could invoke it like this:

`./ipconvert.sh 001200600006`

And it should respond:

`10.3.0.6`

But it’s much more fun to do it the hard/manual way!

