# Troubleshooting guide

This guide will help you sort out the most common issues of running ITS on the PiDP-10

## INQUIR not saving changes
Thanks to eswenson for the intial steps here

In order for INQUIR entries to stick, you must have COMSAT running. 

If you run PEEK, you should see two COMSAT jobs. One has the JNAME IV and the other JOB.nn.  If these jobs are not present, then COMSAT may have started and died.
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
As you can see above none of the COMSAT process is running.

There are several reasons why COMSAT may die upon startup The most common are:

1) network parameters for COMSAT are not correct.

2) host configured for the BUGHST doesn’t match ITS’ IMPUS3 value.

3) Mail initialization files were not created.

4) .MAIL. directory is full.

You can check the network parameters by doing:
```
foo$j     ; $ is <escape>
$l .mail.;comsat launch
bughst/
tcpgat/
domgat/
```
this produces this output
```
bughst/   SHOWQ+50,,PAT+6   tcpgat/   SHOWQ+50,,55   domgat/   SHOWQ+50,,55
```
BUGHST should match IMPUS3 in ITS and be the IP address of your ITS.

You can check the value of IMPUS3 by doing:
```
Its$j
impus3=
```
TCPGAT and DOMGAT should be the IP address of your host (eg raspberry pi).

If all these are correct, check to see if your .MAIL. directory is full:

:dskuse .mail.

List out your .MAIL. directory to see if you have these files:
