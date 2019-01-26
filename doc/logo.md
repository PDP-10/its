# Logo

"I too see the computer presence as a potent influence on the human mind. 
 I am very much aware of the holding power of an interactive computer and 
 of how taking the computer as a model can influence the way we think about 
 ourselves. In fact the work on LOGO to which I have devoted much of the past
 years consists precisely of developing such forces in positive directions."

Seymour Papert

"Logo is the name for a philosophy of education and for a continually 
 evolving family of computer languages that aid its realization."

Harold Abelson

"Historically, this idea that Logo is mainly turtle graphics is a mistake. 
Logo’s name comes from the Greek word for word, because Logo was first
designed as a language in which to manipulate language: words and sentences."

Brian Harvey

Logo was initially created by Wally Feurzeig, Seymour Papert, and Cynthia
Solomon in 1967 as part of a National Science Foundation sponsored research
project conducted at Bolt, Beranek & Newman, Inc., in Cambridge, Massachusetts.
In 1969 Dr. Seymour Papert started the Logo Group at the MIT Artificial Intelligence
Lab. Throughout the 1970s the majority of Logo development was conducted at MIT
in the Artificial Intelligence Lab and the Division for Study and Research in
Education, using large research computer systems, such as ITS powered PDP-10.

Our goal is to make that early Logo systems available to a wider audience of
enthusiasts for exploration, experimenting and, of course, hacking.

### BBN Logo

The BBN PDP-10 LOGO system was implemented originally by Walter B. Weiner with
the assistance of Paul Wexelblat and Charles R. Morgan at BBN. 
We have the source file with a copyright from 1970. It is a version modified at
National Research Council, Ottawa, Canada by A.G. Smith and R.A.Orchard.
That version of BBN Logo for PDP-10 TOPS-10 and TENEX was assembled with MACRO-10
in ITS, and dumped with the DECUUO bootstrap to get an ITS executable binary. 

to run, type:
`:bbn;logo`

Here is some BBN Logo related documentation:

 Bolt Beranek and Newman, Inc., Report no. 2165 vol. 4 "The Logo Processor: A Guide 
 for System Programmers", pub date 30 June 1971.

 Bolt Beranek and Newman, Inc., Report no.1889 "Programming-Languages as a Conceptual 
 Framework for Teaching Mathematics" (Feurzeig, Papert at al., 1969)
 Appendix "A Description of the Logo Language and System".

 Both documents are available at:

 https://github.com/PDP-10/bbn-logo
 
### MIT CLOGO

MIT CLOGO is a direct BBN LOGO descendant. It is, in essence, BBN Logo ported to ITS
and MIDAS and enhanced with turtle graphics and other capabilities at MIT.

We have a pretty stable CLOGO version 49 binary as well as well-commented source code
for the version.

Uninished documentation for the CLOGO may be reached at:
https://github.com/PDP-10/its/blob/alexey/CLOGO/doc/_info_/clogo.manual

### MIT LISP LOGO

LISP LOGO is an implementation of the LOGO language written in MACLISP for the ITS, TEN50
and TENEX PDP-10 systems, and MULTICS. The system was implemented by Ira Goldstein,
Henry Lieberman in the early 70's at MIT.
One of the reason for this implementation was to provide a natural transition to the more
powerful computational world of LISP as the Logo programmer grows more sophisticated.
When desired, one has access to all of the capabilities of MACLISP.

As far as we know there were several LISP LOGO versions:
- LLOGO - Standard version which uses a vocabulary which is compatible with 11LOGO.
- CLLOGO - A version which uses a vocabulary which is compatible with CLOGO.
- NLLOGO - An experimental version of LISP LOGO.
- ELLOGO - Another experimental version of LISP LOGO.
- BWLOGO - LISP LOGO with black and white graphics.

LISP LOGO had available several packages of special functions:
- TV TURTLE - LISP LOGO package provides Knight TV system Logo Graphics.
- DISPLAY TURTLE - LISP LOGO package provides 340 / GT40 display Logo Graphics.
- GERMLAND - some kind of display turtle for character displays without grahics capabilities.
- MUSIC BOX - the package provides Logo music capabilities.

The LLOGO variant of LISP LOGO was recently brought back to life during several amazing
hacking session. As a result, we have LLOGO with TV TURTLE and DISPLAY TURTLE running
on ITS under emulation.

to run, type:
`:llogo`

If you start from a TV console, LLOGO will ask "DO YOU WANT TO USE THE TV TURTLE?".
In other cases, LLOGO will ask the question without the "TV" part and then it'll use
the Lisp display slave. The Lisp display slave has the option to use the PDP-6 or PDP-10
driving the 340 display, or to use the GT40. We don't have GT40 display slave in place yet.

To switch back and forth between LOGO and LISP top level loops type `LISP` from LOGO
prompt and `(LOGO)` from MACLSIP prompt respectively.

One more powerful feature of LISP LOGO is using the MACLISP compiler directly on LOGO
source programs and obtain a substantial gain in efficiency, once the programs are
thoroughly debugged.

Documentation:

[MIT A.I. Memo 307A "LLOGO: An Implementation of LOGO in LISP"](https://dspace.mit.edu/bitstream/handle/1721.1/6221/AIM-307a.pdf?sequence=2)

[MIT A.I. Memo 361 "The TV Turtle. A Logo Graphics System for Raster Displays"](https://dspace.mit.edu/bitstream/handle/1721.1/5773/AIM-361.pdf?sequence=2)

LISP LOGO is available in well-commented interpretive code. Timestamps for the TVRTLE file
versions in the five hundreds are from 1978-1979.


### MIT 11LOGO

MIT 11LOGO is the LOGO system implemented for the PDP 11/45 at the MIT Artificial
Intelligence Laboratory. We can run it on PDP-10 / ITS under emulation.

to run 11LOGO type:
```
*:pdp45
1145.427
CORE = 8.K
!56.:core
CORE = 56.K
!;a pk
!;a df
!;l system bin
!400;g
11LOGO 1007
?STARTDISPLAY
```
The emulator must be run on the KA10 simulator which supports the Type 340 display.

11LOGO system was one of the major logo versions of the 70s and included not only
the LOGO evaluator but also a dedicated time-sharing system which serviced about
dozen users. MIT AI MEMO 313 cites among the system developers Ron Label, Joe Cohen,
Nat Goodman, Hal Abelson, Roger Hale, Radia Perlman. The 11LOGO display controller
was designed and built by Tom Knight. The document also cited contributions of Richard
Greenblatt on matters of system design and, of course, Seymour Papert and Cynthina
Solomon on language specification.

But please note, that the 11LOGO version 1007 currently available on ITS is very early
MIT 11LOGO one. It is in essence just logo language evaluator with limited turtle display
340 grapics capabilities only. A brief description of the built-in procedures (primitives)
in 11LOGO version that we have is available at `its/doc/_info_/11logo.order document`.

### MIT PLOGO

In accordance with Leigh L Klotz Jr. talk at comp.lang.logo channel:
"around 1977-1978, Gary Drescher and someone else whose name escapes me at the moment
wrote a version of Logo in Pascal, as part of a project with Texas Instruments, for
the TI 99/4 Home Computer, because Pascal was the only high-level language supported.
They finished it and compiled it, and it produced something like a 300Kb program."  
It was written before the TI 9900 development machine arrived and when compiled it turned
into about 400Kb, way above the size of the 99/4, so Ed Hardebeck hand-compiled it into
9900 assembler. 

The MIT PLOGO was developed and cross-compilled on PDP-10. Lars Brinkhoff have obtained
blessing from Gary Drescher to publish PLOGO source code.

### MIT APLOGO

In accordance with Leigh L Klotz Jr., Hal Abelson directed the Logo for the Apple II
project at MIT.

MIT APLOGO was developed by Stephen Hain, Patrick G. Sobalvarro and Leigh L Klotz Jr.
It was developed and cross-compilled for the Apple-II-Plus Personal Microcomputer on
PDP-10 at the MIT LOGO Group. It is direct predecessor for Terrapin Logo.
We have a source code for assembling an improved version from 7/9/81 at `its/src/aplogo`

### LogoWorks

To quote Issac Newton "The best way to understanding is a few good examples."
We have a special issue to discuss interesting pieces of Logo code implemented
in Logo versions hosted on ITS.

Here is a link:
[#1538](https://github.com/PDP-10/its/issues/1538)
