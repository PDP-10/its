!* -*-TECO-*- *!
!* This is the EMACS library TMACS.  Note that it requires the purifier in
 * EMACS;IVORY -- not the one in EMACS;PURIFY.
 * Note too that when making EMACS;TMACS :EJ, you need to compress this
 * source and also TMUCS >.  You can use M-X Compile, since this file
 * has a local Compile Command, which leaves the object in ECC;XTMACS :EJ.
 * The documentation strings starting with "I" indicate internal subroutines
 * not intended to be called from outside TMACS.
 * In general, for easy abstracting (Abstract File), the most generally
 * useful stuff should be at the top.  And, documentation should be filled
 * with a Fill Column of 70.  You can use (local to this file) M-X Edit TMACS
 * Documentation.
 *!
!~FILENAME~:! !Random collection of useful functions.!
TMACS

!Type Mailing List:! !C Prints an entry in ITS mailing list file.
This works on any ITS machine.  (.MAIL.;NAMES > has the ITS mailing
    lists.)
For instance, M-X Type Mailing Listbug-random-program<cr> will show
    you who is on the bug-random-program mailing list on your machine.
If string argument is of form <name>@<site>, <site>:.MAIL.;NAMES is
    used.  Only final @ indicates site, so you can do something like:
    M-X Type Mailing List$BUG-@@AI$
A numeric argument limits depth of recursion on EQV-LIST members.
    (Default depth is 3.)
<name>@<site> entries in EQV-LIST are not followed.
Prints "Done." when done, since it sometimes is slow.  Giving a
    pre-comma numeric argument inhibits done-printing, for use as a
    subroutine.!

 :i* [.1			    !* .1: Stringarg, the mailing list.!
 [f[.2[.3[.4[.5 [..o
 m.m& Maybe Flush Outputuf	    !* F: Flusher.!
 0fo..qTML Levelu.5		    !* .5: Our current invocation level.!

 q.5+1-(ff&1"E 3 '"#  ')"G '	    !* If recursed enuf, quit.!

 mF 				    !* If output flushed, quit.!

 q.5"E				    !* At top level, initialize.!
    m.m Kill Variable[K	    !* K: Kill Var.!
    qBuffer Name[B		    !* B: Original Buffer name.!
    [Previous Buffer		    !* Save default.!
    FN 1:< mKTML So far >w	    !* Kill our recursion-helpers if quit.!
       1:< mKTML NAMES >w	    !* ...!
       1:< mKTML Level >w	    !* ...!
       qBm(m.mSelect Buffer)	    !* Back to original buffer.!
       			    !* End of FN.!
    f[DFile			    !* Save filename defaults.!
    q.1u.2			    !* .2: Copy of mailing list name.!
    < @f.2f(:;)+1,fq.2:g.2u.2 >    !* .2: Stuff after final @.!
    0,fq.1-fq.2-1:g.1u.1	    !* .1: Stuff before final @.!
    fq.1"E q.2u.1		    !* .1: No @ present, is whole name.!
	   fsMachine :f6u.2'	    !* .2: No @, is machine name.!
				    !* .1: Name.!
    q.2:fcu.2			    !* .2: Site, uppercased.!
    m(m.m Select Buffer)NAMES@.2	    !* E.g. NAMES@ML.!
    z"E	@ftReading .2:.MAIL.;NAMES     !* May take a while, tell user.!
	-1,1m(m.mVisit File).2:.MAIL.;NAMES > !* Read names !
	'			    !* file if not in.!
    q..o m.vTML NAMESw		    !* Pass it on to recursive calls.!
    fsBCons m.vTML So farw	    !* Buffer for entries traced so far, so!
				    !* dont run into ugly-looking loops.!
    %.5 m.vTML Levelw		    !* Make recursion-level counter.!
    '				    !* End top level init.!

 "# %.5 uTML Levelw'		    !* Increment level count if not top level.!

 q..o[.7			    !* .7: Buffer to restore point in.!
 .[.6				    !* .6: Original point.!

 qTML So faru..o		    !* Switch to buf with entries traced.!
 bj :s
.1
   "L oEXIT'			    !* Quit if weve traced it before.!
 i
.1
				    !* If havent, add it to list now.!

 qTML NAMESu..o		    !* Switch to buffer with NAMES.!
 bj <:s
(.1"E oEXIT'		    !* Find the entry. ) !
    0af
	 ([;>			    !* Must end with Lisp atom break.!
 -ful				    !* Back to beginning of entry.!
 flu.4w				    !* .4: End of entry.!
 .,q.4x.2			    !* .2: The whole entry.!
 ft.2
				    !* Type whole entry.!
 .,q.4:fb(EQV-LIST"E oEXIT'	    !* Look for an eqv-list to expand. )!
 fkc flu.4w			    !* .4: End of EQV-LIST.!
 @ fwl				    !* Past the EQV-LIST atom.!
 < .-q.4;			    !* Go thru EQV-LIST.!
   mf1;			    !* Stop if output flushed.!
   @:fll			    !* To next S-EXP.!
   0,1a-("E @:fwl		    !* List: take first atom.!
	      @fwx.3		    !* .3: atom to look up.!
	      fm(m.m Type Mailing List).3w  !* Recurse.!
	      ful !<!>'		    !* Past end of list.!
   0,1a-;"E l !<!>'		    !* Comment: skip it.!
   0,1a-)"E q.4j !<!>'	    !* End of EQV-LIST, done.!
   @fwx.3 @fwl			    !* .3: EQV-LIST member atom. !
   fm(m.m Type Mailing List).3w	    !* Recurse.!
   >				    !* Look up all members of EQV-LIST.!

 !EXIT!

 q.5-1u.5			    !* .5: Decremented level count.!
 q.5uTML Level
 q.5"E				    !* At top level, cleanup.!
    qTML So far fsBKill	    !* Kill the list of entries traced.!
    mkTML So far		    !* Kill our recursion-helpers.!
    mkTML NAMES		    !* ...!
    mkTML Level		    !* ...!
    ff&2"e fsListen"e ftDone.
     '				    !* Type done only at top level.!
    "# ftFlushed.
      '''			    !* Done top-level cleanup.!
 "#				    !* Not at top level, restore buffer.*!
    q.7u..o			    !* Switch to original (+-) buffer.!
    q.6j'			    !* Back to original point.!
 w 1 				    !* Return.!

!^R Select Buffer:!!Buffer Menu:! !^R Display information about all buffers.
A recursive edit level is entered on a list of all buffers.
On exit the buffer on the current line is selected.
Point is initially on line of current buffer and space will exit (like
    ^R Exit), so this is very much like List Buffers but
    combines listing with selecting in a way that does not involve
    much typing or redisplay.  * means modified, - means modified and not
    auto-saved, and . means current buffer.
D will mark buffer for deletion on exit,
S will mark buffer for saving on exit,
U will unmark buffer, and
~ will clear modified flags of buffer.!

    [0[1[2[3[4[5[6[7[8			!* save regs!
    f[DFile				!* save default filename!
    fsQPPtru8				!* 8: point to unwind before!
					!* selecting a different buffer!
    fsBCons[..o			!* get us a buffer!
    i     # Buffer    (Mode)         Filename

   2u7					!* 7: line count!
    0u4 fq.b/5u5			!* 4: .B index, 5: stopping point!
    < q4-q5;				!* Go thru buffer table; stop at end!
      q:.b(q4+4!*bufbuf!)[..o		!* make the buffer current so can!
					!* check modified, readonly, etc.!
      0u1				!* 1: flag bits!
      fsModified"n q11u1'		!* 1&1: nonzero if modified!
      q:.b(q4+10!*bufsav!)"N	        !* Ignored unless auto save mode.!
        fsXModified"N q12u1''	!* 1&2: nonzero if Xmodified!
      fsZu3				!* 3: no. of characters in buffer!
      ]..o				!* back to listing buffer!
      .u0 4,32i				!* 0: start address of this line!
      q1&1"n .-2f*'			!* indicate if modified!
      q1&2"n .-1f-'			!* indicate if not auto saved!
      2,q:.b(q4+7!*bufnum!)\		!* Type the buffer's number!
      i  g:.b(q4+1!*bufnam!)		!* Type buffer's name,!
      17-(.-q0):f"gw 1',32i		!* move to column 17!
      q:.b(q4+3!*bufmod!)u1		!* 1: buffer's major mode!
      qBuffer Index-q4"e		!* if current buffer!
	qModeu1 q0u6			!* then use current mode, and save .!
	.( q0+3j 2a-32"e c' f. )j '	!* and put dot next to number!
      i(1)				!* Type major mode!
      32-(.-q0):f"gw 1',32i		!* move to column 32!
      q:.b(q4+2!*bufvis!)u1		!* 1: visited filename!
      q1"n g1				!* type filename if there is one!
        et1 q:.b(q4+9!*bufver!)u2	!* get actual version number.!
	fsDVersion:"g			!* ...!
           fsDVersion+1"n		!* ...!
	     i ( g2 i)'''		!* Print file version if valid.!
      "# q3\ i  Characters'		!* No filename, type the size.!
      q:.b(q4+12!*bufnwr!)u2		!* Say which if any read only modes.!
      q2"g i  File Read-Only'		!* ...!
      q2"l i  Buffer Read-only'	!* ...!
      i
     %7w				!* add CRLF, increment line count!
      q:.b(q4)+q4u4			!* advance past this buffer!
      >
    q6"n q6j'				!* goto line with current buffer!
    fsLinesu6 q6"e fsHeight-(fsEchoLines)-1u6'	!* 6: current fsLines!
    q7+1-q6"l q7+1f[Lines'		!* set fsLines so that only the amount!
					!* of screen needed is used, reducing!
					!* redisplay of rest of buffer.!
    0f[Window				!* start display at top!
    0fs^RInitf[^RNormal		!* make normals undefined!
    33.fs^Rinit[ w			!* space exits ^R mode!
    :i*Buffer Menu[..j			!* use reasonable mode line!
    0[..F				!* dont let user screw himself!
    !* Now bind some keys for editing the buffer menu!

    @:i*| 0f[Lines m(m.mDescribe)Buffer Menu h|f[HelpMac	!* HELP: describe us!
    @:i*| 0l @f DS*-.l \[1 q1"e 0l fg 1'	!* 1: buffer number!
	  q1m(m.m& Find Buffer)u1		!* 1: buffer index!
	  q:.b(q1+4!*bufbuf!)[..o 0fsModifiedw 0fsXModifiedw ]..o
	  0l .+2f   .+2,.+4 |[~	!* ~: clear modified flag!

    @:i*| 0l 0,1a-32"n fg 1'		!* insure not already marked!
          fD 1  |[D qD[.D	!* D, c-D: mark buffer for deletion!
    @:i*| 0l 0,1a-32"n fg 1'		!* insure not already marked!
          fS 1  |[S		!* S: mark buffer for saving!
    @:i*| 0l 0,1a-D"n 0,1a-S"n fg 1''	!* insure already marked!
	  f  1  |[U		!* U: unmark buffer!

    !BACK! 				!* let user see buffer, and move!
					!* around!
    0l 0,1a-D"e fg oBACK'		!* dont exit on marked buffer!
    @f S*-.l \u1			!* 1: buffer index of new buffer!
    q1"e fg oBACK'			!* dont exit on no buffer.!
    q..ou2 q8fsQPUnwind		!* 2: buffer menu buffer!
					!* cleanup all pushed stuff so that!
					!* it isnt stored in .B after buffer!
					!* selection!
    q2[..o jl				!* menu buffer, move past header!
    < :s
 ;					!* find first marked buffer!
	0a-D"e @f *-.l \u3 q3"n	!* D: kill it!
		q3-q:.b(qBuffer Index+7)"e	!* if killing selected buffer,!
		    q1"n ]..o q1m(m.mSelect Buffer)w q2[..o''
					!* select new one first!
		q3m(m.mKill Buffer)' !<!>'
	0a-S"e @f *-.l \u3 q3"n	!* S: save it!
		]..o q3m(m.mSelect Buffer)
		m(m.m^R Save File)w q2[..o' !<!>'
	>
    ]..o				!* restore selected buffer!
    q1"n q1-q:.b(qBuffer Index+7)"n	!* if new buffer index, and if!
					!* different from current buffer!
      q1m(m.mSelect Buffer)''		!* select new buffer!
    q2fsBKill 			!* kill menu buffer!

!Graph Buffer:! !C Call ^R Buffer Graph to show schematic of buffer.!
 @m(m.m^R Buffer Graph)w 	    !* Return no values.!

!^R Buffer Graph:! !^R Show a scale schematic of buffer in echo area.
(You can also use M-X Graph Buffer<cr>.)
Draws something like the following in the echo area:
|----B-----==[==--]---Z------------------------------------------|
     1      2     3      4      5     6      7      8     9
The |--...--| indicates the whole buffer, numbers approx tenths.
=== indicates the region.
B indicates the virtual buffer beginning.
Z indicates the virtual buffer end.
[---] indicates the window.!
 [.0[.1[.2[.3[.4
 :f				    !* Ensure a valid window.!
 .u.3 fnq.3j			    !* .3, ..N: Point, restored autoly.!
 fsWindow+bj			    !* Go to top of window.!
 fsLines f"E fsHeight-(fsEchoLines+1)' u.0	    !* .0: Height of window.!
 1:< q.0-1,0 :fm :l >		    !* Go to end of last screen line.!
 .u.4				    !* .4: Window bottom.!
 :i*CfsEchoDisplay		    !* Clear the echo area!

 fsZ"E				    !* Special case empty buffer.!
    @ft|mere corroborative padding intended to give artistic verisimilitude
 to an otherwise bald and unconvincing buffer|
    1 @v 0f[HelpMacro		    !* Allow HELP to get help here.!
         :fi-4110."E fiw :i*CfsEchoDisplay
		     @ft(Semi-quote from "The Mikado", by Wm. Gilbert)

		     0fsEchoActivew
		     :ft !''!'
    w 1 '

 m.m& Buffer Dashes[D		    !* D: Dash macro.  Uses qregs: !
				    !*    .0: dash.!
				    !*    .1: hpos.!
				    !*    .2: last buffer pointer.!
				    !*    .3: point.!
 :i.0-				    !* .0: Start with - as dash.!
 0u.1				    !* .1: Start hpos = 0.!
 -1u.2				    !* .2: Start last ptr at beginning.!

 @ft|				    !* Print buffer beginning.!
 fsVB mD @ftB			    !* Dash and print virt buffer begin.!
 fsWindow+b mD @ft[		    !* Dash and print window start.!
 q.4 mD @ft]			    !* Dash and print window end.!
 fsZ-(fsVZ) mD @ftZ		    !* Dash and print virt buffer end.!
 fsZ mD @ft|
				    !* Dash and print buffer end.!

 0u.1				    !* .1: 0, echo area hpos.!
 0u.0				    !* .0: 0, tenth number.!
 9< fsWidth-3*%.0/10-q.1f(+q.1+1u.1)< @ft  > q.0@:= >	    !* Print tenths.!

 0fsEchoActivew
 1

!^R Draw Vertical Line:! !^R Draws from current hpos, not inserting.
Line drawn only in current window, and column printed at base of line.
This only works on ITS machines.
If any ARG given, is displacement from current hpos.  E.g. -1 means
    draw line through position one column left.
If C-U is specified, together with an ARG then ARG is an absolute
    column.  E.g. M-3 C-U as argument makes line in column 3.  But
    M-3 as argument makes line in column 3+current_column.!

 [.2[.1 ff"G fs^Rarg'"# 0'+(fs^Rexpt"E fs^Rhpos')+8:i.1
 :i*TfsMPDisplay		    !* Home to top.!
 fsTop< :i*DfsMPDisplay >
 fsLinesf"E wfsHeight-(fsEchoLines)-1'(
    )< :i*H.1|HDfsMPDisplay >
  .1-8:\u.2 :i*H.1.2fsMPDisplay
 @ft  1

!=Abbrev:! !C Define or delete M-X abbreviations.
M-X =Abbrev$IF$Insert File$ will define M-X IF = Insert File$
    to be M-X Insert File$, evaluated by name each time
    M-X IF$ is used.  Thus if a new Insert File is created or loaded,
    that one will be used.  This works nicely with command-completion.
C-U 0 M-X =Abbrev$IF$ and
C-U - M-X =Abbrev$IF$ will remove definition for M-X IF$.!

 ff"G -1"L			!* 0 or neg argument, kill abbrev.!
    8,fKill command abbrev: [0	!* 0: command name of abbrev.!
    m.mKill Variable[K			!* K: Vlamdring, variable-slayer.!
    :fo..qMM 0"g mkMM 0w'		!* If name is complete or unambiguous!
					!* as given, ready to kill.!
    "# :fo..qMM 0 ="g		!* Perhaps just abbrev part given.!
      mkMM 0 =w'			!* ...!
    "# :i*Ambiguous or undefined command abbrev: 0fsErr''	!* Give up.!
    ''				!* ...!

 [1[2[3
 1,fCommand abbrev: (		!* STRARG1: abbrev!
    8,fFull command name: u2		!* 2: MM-name.!
    )u1					!* 1: MM-abbrev.!

 !* Give the abbrev some active documentation, so that it will always get the!
 !* latest documentation for the full command.  I.e. make the documentation!
 !* also "call by name".''!

 @:i*|C Command abbrev for 2.
1,m.m~DOC~ 2f"n[1 g1 j2d ]1'w|(
     )m.vMM ~DOC~ 1 = 2w

 !* Define the command abbrev MM-variable: !
 @:i*| f:m(m.m 2) 		!* ...!
       |m.vMM 1 = 2w		!* ...!

 

!^R Auto Fill Comments:! !^R Refill the comment and its continuations.
To handle comment starts (or parts of them) that are repeated, e.g.
";;; " in Lisp, or perhaps "/*** " in Pl1, it will treat a duplicated
last character of the comment start or begin as part of the comment
beginning when merging comment lines.!

 [1[2[3[4[5[6
 qComment Startu1			!* 1: Real, minimal start string.!
 qComment Endu2			!* 2: End string or 0.!
 fq2"e 0u2'				!* Either 0 or non-null.!
 qComment Beginu3			!* 3: Desired pretty-start string.!
 fq3:"g q1u3'				!* 3: If no begin, then use the!
					!* start string for convenience.!
 fq1-1:g1u5				!* 5: Last character in start string.!
 qFill Extra Space Listu6		!* 6: Characters that take 2 spaces.!

 0l :fb1"e fg 1'			!* Feep and exit if no comment.!

 !* Merge this comment and its continuations into one comment line: !

 <  q2"e :l'"# :fb2'			!* To end of comment.!
    .u4					!* 4: Point at comment end.!
    l @f	 l			!* After next lines indentation.!
    fq1 f~1:@;			!* Exit if not comment start.!
    q4,.k				!* Remove the whitespace between!
					!* comment and continuation comment.!
    q2"n -fq2d'				!* Delete the comment end.!
    fq3 f~3"e fq3d'"# fq1d'		!* Remove any comment begin or start.!
    @f5k			!* And iterated last character.!
    -@f	 l @f	 k	!* Kill surrounding whitespace.!
    0af6:"l 32i' 32i		!* Insert space to separate.  Or 2!
					!* spaces for some.!
    >					!* Keep merging.!

 !* Now repeatedly auto-fill this line until it fits.  Calling ^R!
 !* Auto-Fill Space with an argument of 0 tells it to insert no spaces but!
 !* fill once if necessary.  We limit the number of iterations to a!
 !* reasonable maximum (each auto-fill should rip off at least one space +!
 !* one char (word).  This is so some buggy auto-filler or tab wont!
 !* infinitely keep causing us to fill.!

 q4j 0l					!* Back to comment line.!
 .,(					!* Get bounds of change.!
    m.m^R Auto-Fill Spaceu1		!* 1: Space.!
    :l 0f  /2< .-(0m1f		!* Auto-fill maybe, tell ^R mode.!
		    ).@; >		!* Repeat until point doesnt change.!
    :l). 

!^^ TMACS Error Handler:! !S Q..P: handles TECO errors.
If first character typed is "?" then Backtrace is called.
A space makes us exit, with no action.
If option variable TMACS Error Dispatch is non-0, some other
    characters may be typed, in any order, ending with a space (no
    further action) or "?" (enter Backtrace):
	B	Display the offending buffer.
	D	Directory Lister is run.
	W	Who caused this? -- type function's name.
Typing HELP character describes the error handler.
Quits are not handled at all unless the variable Debug is nonzero.
    That is so a quit will cause the buffer and modeline to be
    restored and redisplayed immediately.
A QRP error (q-register PDL overflow) will cause automatic partial
    unwinding of the q-register PDL if you type anything but Space.
    You can thus enter Backtrace etc.!

 m(m.m& Declare Load-Time Defaults)
    TMACS Error Dispatch,
      * Non-0 enables several characters for TMACS error handler: 0


 !* It is dangerous to push anything on the q-register pdl before we have!
 !* checked for a QRP error.!

 :? fsErrorf"n@:fg		    !* Leave trace mode, print error message!
      0"n			    !* MM Make Space doesnt exist yet.!
      fsError-(@feURK)"e	    !* If out of address space, clean up right!
				    !* away.!
        ft executing Make Space... !* Tell user we are fixing things.!
        mMM Make Space'	    !* We can get there without consing any!
				    !* strings.!
      '				    !* End of dont-yet-execute.!
      '
 "#w 0fo..q Debug"e		    !* ^G -- just quit right away?!
         fsError fsErrThrow''	    !* Yes, so redisplay immediately.!
				    !* Debug allows a hacker to cause an!
				    !* asynchronous entry into Backtrace, e.g.!
				    !* to see what is looping.!


 !* Now, if QRP error and user types anything but Space (which exits), we!
 !* partially unwind to allow room to operate.!

 :fi- "e oSP'		    !* Must do this special case so avoid any!
				    !* q-register PDL pushing, which includes!
				    !* fs-flags.!
 fsError-(@feQRP)"e		    !* It is a QRP error.!
    :ftUnwinding partially to make room for error handler   !* ...!
    -9-9-6fsQPUnwindw'		    !* So unwind a little.  The -9-9-6 avoids!
				    !* assuming any base.!

 8f[I.Base			    !* 15. is base 8.  I guess in case we!
				    !* go into Backtrace.!
 f[SString			    !* Save search default.!

 @:i*| m(m.mDescribe)^^ TMACS Error Handler |f[HelpMacro
				    !* HELP gives options.!

 qTMACS Error Dispatch"n	    !* Check for special dispatch characters.!
    < @:fi@:fc-B"e fiw @v !<!>'   !* B -- display buffer.!
      @:fi@:fc-D"e fiw 1:<mDirectory Lister>w !<!>'
				    !* D -- display directory.!
      @:fi@:fc-W"e fiw	    !* W -- name who did it.!
	0[1 1:< -1fsBackStringm(m.m& Macro Name)u1 >w    !* 1: name!
	q1fp"l :i1unknown function'	    !* of culprit.!
	@ft(Error in 1) 0fsEchoActivew !<!>'    !* Tell.!
      1; >'			    !* Any other commands exit.!

 @:fi-32"e !SP! fiw 0fsErrFlgw 0u..h fsErrThrow'
				    !* Space -- no action, clear error!
				    !* and any HELP message printed.!
 @:fi-?"e fiw			    !* If user types ? we backtrace.!
    fsVerbose"e				!* if not verbose then!
       1f[Verbose fsErrorfg f]Verbose'	!* explain error verbosely!
    f[Error				!* save fsError!
    2m(m.mBacktrace)+0"n f)'		!* Backtrace.  If it says continue, do!
    f]Error'				!* restore fsError!
 "# fsEchoErr"e			!* if errors dont complain in echo!
    @:fi- "e fiw 0fsErrFlg'''	!* area and user typed a space,!
					!* forget the error since is still!
					!* showing.!
 fsErrThrow

!^R Change Case Letter:! !^R Next <argument> letters, moving past.
Numeric argument negative means move left.
Fast, does not move gap.!
 [1
 "g				    !* Positive NUMARG, move right.!
    .,( :< 1af"a#40.:i1	    !* 1: Changed case if letter.!
		  f1'w	    !* Change to that letter.!
	     c >w ).'
 				    !* Negative NUMARG, move left.!
 .,( -:< r 1af"a#40.:i1	    !* 1: Changed case if letter.!
		  f1'w	    !* Change to that letter.!
	   >w ).

!& Set ..D:! !S Create a new ..D with chars in arg as break characters.!
 -1[1 128*5,40.:i..d		!* setup completely blank ..D!
 128<%1*5:f..dA>		!* initialize to no break chars!
 i -fk<0a*5:f..d  -d>	!* make chars in arg into breaks!
 

!^R Get Macro Name:! !^R Inserts macro name for char typed.
MARK is set before inserted name.
Handles bit and char prefixes, e.g. Meta-, ^X, unless:
Given a numeric argument, gets the name of a prefixer (e.g. metizer).
Impure-strings that are uncompressed macros are handled if their names
    are present at the beginning of the macro.
Some characters run standard builtin functions whose names are found
    in the BARE library.  These work fine.  Others which are not found
    just insert their key names, e.g. Meta-O.!

 [0 [.1
 .:w				    !* Set MARK.!
 ff"e			    !* No NUMARG, follow prefixes.!
     m(m.m& Read Q-reg Name)u0'	    !* 0: Name of Q-Reg.!
 "# @fiu0			    !* 0: 9-bit for prefix key.!
    .,( g(q0 fs^RIndirect fs^Rcmacro m(m.m& Macro Name))
	).'			    !* Get the name of the prefix.!

 q0 fp"l f[:EJPage m(m.mLoad Library)BAREw'	!* If builtin, we!
					!* might find its name in BARE.!
 q0m(m.m& Macro Name)f"nu0		!* 0: Found its name.!
    .,(g0).'				!* Insert and return.!

 q0 fp+1"G			    !* Q-Reg contains bug, qv, or an impure!
				    !* string -- thus possible macro source.!
    f[BBind			    !* Grab temp buffer.!
    g0			    !* Get the q-reg contents.!
    j @ f
   r				    !* Move past initial CRLFs.!
    0,1a-!"N			    !* No possible macro name here.!
      :i*Not a valid macrofsErr'  !* Error.!
    .+1,( :s:!"e :i*Not a valid macrofsErr'    !* !
	2r).x0			    !* 0: Macro name.!
    f]BBind			    !* Back to original buffer.!
    .,(g0). '			    !* Insert macro name and exit.!

				    !* 0: Name of q-reg, possibly running a!
				    !* builtin function.!

 f[BBind			    !* Grab a temp buffer.!
 g0 j				    !* Insert the q-reg name.!
 0,1a-"E			    !* ^^-type name.!
    z-2"N :i*Bad ^^-type q-reg namefsErr' !* Only ^^x.!
    2a#100.u.1'			    !* .1: 9-bit ascii code for q-reg char.!
 "#				    !* Not ^^-type, see if ^R-type name.!
    :s"E			    !* Not ^R-type qreg name, !
	f]BBind .,(g0). '	    !* ...so just return qreg name.!
    bj 0u.1			    !* .1: Initialize 9-bit code.!
    3< 0,1a-."E		    !* For each period in name, !
	 d q.1+200.u.1'		    !* .1: ...update 9-bit shift bits.!
       >			    !* End of period-iter.!
    0,1a-"N			    !* Up to 3 dots, then ^R.!
      :i*Bad q-reg namefsErr'	    !* !
    z-2"N :i*Bad q-reg namefsErr' !* !
    2a+q.1u.1'			    !* .1: 9-bit ascii code for q-reg char.!
				    !* .1: 9-bit for q-reg char.!

 f]BBind			    !* Back to original buffer.!
 q.1 m(m.m& Get 9-Bit Character Name)    !* Insert name and exit.!

!& Get 9-Bit Character Name:! !S Inserts pretty name for 9-bit ARG.
Example:  415. MM & Get 9-Bit$ inserts "Meta-CR".
An arg of "2," means say "^M" instead of "CR", etc, and ^B instead of
    an alpha on TV's.!

&200."NiControl-'
&400."NiMeta-'
[0&177.U0
Q0-127"EiRubout'
Q0-27"EiAltmode'
-2"N
Q0-8"EiBackspace'
Q0-9"EiTab'
Q0-10"EiLinefeed'
Q0-13"EiReturn'
Q0-32"EiSpace''
-2"EQ0-32"Li^Q0+100.U0'''
i0

!Lock File:! !C Lock current buffer's file.
"Lock" the file in the current buffer by creating FN1 *LOCKED*.
Will complain if FN1 *LOCKED* already exists, and will tell who has it
    locked (since FN1 *LOCKED* contains that person's xuname).
Fails the critical-race test.
This assumes that others will cooperate and use M-X Lock File$ and the
    matching M-X Unlock File$.!
 f[DFile [1[2			    !* save filenames, q-regs!
 qBuffer Filenamesu1
 q1"e :i*No file in bufferfsErr'
 q1fsDFilew
 f[BBind			    !* explicitly popped!
 1:< er*LOCKED* >"e
    @y :x2 f]BBind
    :i*1 is locked by 2. fsErr'
 ec fsXUnamef6 ei hp ef f]BBind
 :i*CfsEchoDis @ftOk, you have 1 locked. 
 0fsEchoActivew

!* If creation date of file in buffer equals that on disk then just return.
   Otherwise issue a warning.
!
 q1fsDFilew			    !* get creation date of file on disk.!
 e[ er fsIFCdate( e]		    !* ...!
 )-q:.b(qBuffer Index+8)"e '    !* if same as in buffer then return!
 fsModified"n !"!
    ftWhile you've been editing this file, somebody has written a
new copy out!  You will lose some work if you are not careful.
I suggest that you file this out under a different name and
then SRCCOM the two files.
 '
 !"!
 ftSince you last read or wrote this file, somebody else
wrote a new version on disk.  Luckily, you haven't edited
the buffer since then.  Do you want the new version
 m(m.m& Yes or No)"l m(m.mRevert File)'
 0u..h 

!Unlock File:! !C "Unlock" file in buffer locked by M-X Lock File.!
 f[DFile [1[2			    !* save filenames, q-regs!
 qBuffer Filenamesu1
 q1"e :i*No file in bufferfsErr'
 q1fsDFilew
 1:< er*LOCKED* >"n	    !* Oops -- file isnt locked.!
   :i*1 is not locked. fsErr' !* Complain.!
 f[BBind			    !* explicitly popped!
 @y :x2 f]BBind		    !* Is locked, see who by.!
 f~(fsXUname:f6)2"n		    !* not us...!
   :i*2 has 1 locked -- not you. fsErr'	    !* So complain.!
 ed				    !* Fine, unlock ok.!
 :i*CfsEchoDis @ftOk, 1 is unlocked. 
 0fsEchoActivew 		    !* Exit keeping message on screen.!

!& Buffer Dashes:! !I Internal routine of ^R Buffer Graph.!
!* === or --- whether in region or not.
ARG = pointer in buffer.
Uses global qregs:
    .0: Dash to print, - or =.
    .1: Last echo area hpos.
    .2: Last buffer pointer.
    .3: Point in buffer.!
 -1[p				    !* p: Maybe point.!
 -1[m				    !* m: Maybe mark.!
 :+1"G :-(fsZ)-1"L		    !* Only indicate region if valid MARK.!
    q.3-q.2"G q.3--1"L q.3up''    !* .p: Point is in our range now.!
    :-q.2"G :--1"L :um''''  !* .m: Mark is in our range now.!
 qp,qmf umup			    !* Ensure p less than m.!

 qp+1"G fsWidth-8*qp/fsZ-q.1f(<@ft.0>  !* Dash to point.!
         )+q.1u.1		    !* .1: Hpos of point.!
	.0-="E :i.0-'"# :i.0='	    !* .0: Switch -/=.!
	'			    !* Done point.!

 qm+1"G fsWidth-8*qm/fsZ-q.1f(<@ft.0>  !* Dash to mark.!
         )+q.1u.1		    !* .1: Hpos of mark.!
	.0-="E :i.0-'"# :i.0='	    !* .0: Switch -/=.!
	'			    !* Done mark.!

 fsWidth-8*/fsZ-q.1f(<@ft.0> !* Dash to ARG.!
    )+q.1u.1			    !* .1: Hpos of ARG.!
 u.2				    !* .2: Update last ptr.!
 

!Flush Variables:! !C Kill some variables specified by search string.
Kill variables whose name contains the string argument.
String argument actually is a TECO search string, and so you can flush
    variables containing "foo" OR "bar" by using the string argument
    "foobar".
The list to be flushed is typed, asking Y, N, or ^R?
    N means abort, ^R allows editing of the list.!
 :i*[1[2				!* 1: Stringarg to match killees.!
 f[BBind				!* Temp buffer.!
 q..o m(m.m List Variables)1	!* Insert list of matching vars.!
 bj
 1f<!DONE!
  f<!KILL!
    :ftKilling Following Variables:
   ht
    ft
Ok? (Y, N, ^R) 
    fi:fcu2			    !* 2: Response.!
    1< q2 fYN"L ftAnswer must be Y, N, or ^R.
		      1;'	    !* Go type list etc again.!
       q2-Y"E f;KILL'	    !* Y, go kill these vars.!
       q2-N"E f;DONE'	    !* N, dont kill, just quit.!
       q2-"E		    !* ^R Edit, then reask.!
		  0u..h  1;'	    !* ...!
       >			    !* End YN^R check.!
    >				    !* After this, can kill.!

  bj				    !* Start killing at top.!
  m.m Kill Variable[K		    !* K: Killer.!
  < 1:< 0,25fm			    !* Go to probable end of varname.!
	-:fwl			    !* Back to end of last word.!

!* Now have to figure enough of variable name to be unambiguous:
 * I think with any algorithm, there will be ambiguous cases resulting in
 * mistakes -- having to do with variables whose names are prefixes of others.
 * But anyhow...:
 * The buffer has a list made by List Variables which includes a description
 * of the value, and we cant really tell where a long variable name ends and
 * the value description begins.  We will find out by trying the first 25
 * letters, which is definitely part of the name, and checking if that is
 * ambiguous.  If so, we append the next word of the line, which must be
 * another part of the variable name, and again check for ambiguity.  The
 * variable name will eventually be unambiguous.
!

	< 0x2			    !* 2: Up to first 25 lets of name.!
	  1:<fo..q2w>-(@feAVN)@:;	    !* See if 2 is unambig.!
	  fwl >			    !* If not, include next word.!

	1:<mK2>"n			!* Kill the variable if can.!
					!* Does KV ever give an error???!
	  ft2 [Not Deleted]
'					!* Unsuccessful ones listed.!
	>			    !* Error in fm means blank line.!
    l .-z; >			    !* Next line if any.!
  >				    !* End of done catch.!
 0u..h 			    !* Exit, refreshing screen.!

!List unused ^R characters:! !C Unused C-, M-, and C-M- characters.
If numeric argument then list unused prefix commands.!
 [1[2[3[4[5
 m.m& Charprint[P
 0u1 32< q1fs^RCMacro-(0fs^RInit)"e
	2,q1mP ft	is not defined
'	%1 >
 A+400.u1
 26< q1-(0fs^RInit)"e
	q1mP ft	is not defined
'   %1 >
 A+600.u1
 26< q1-(0fs^RInit)"e
	q1mP ft	is not defined
'
     q1-(Afs^RInit)"e
	q1mP ft	self-inserts
'   %1 >
 ff"e '
 qPrefix Char Listu4 0u5
 < q5-fq4;
   q5:g4*200.+(q5+1:g4)u3
   q5+2,q5+6:g4u2 q2u2
   0u1 32< q:2(q1)"e
	2,q3mP ft  2,q1mP ft	is not defined
'	%1 >
   Au1 26< q:2(q1)"e
	2,q3mP ft  2,q1mP ft	is not defined
'	%1 >
   q5+6u5
   >
 

!^R Argument:! !^R Put on digits, minus, and comma to get arguments!
 fsQPPtr[9			    !* 9: where to unwind to!
 [0[1				    !* save q-regs!
 q..0&127:i0			    !* 0: argument as string!
 < 1,m.i			    !* read next character!
   :fif0123456789-,:;	    !* if not digit, minus, or comma then exit!
   fiu1 :i001 >	    !* add character to string!
 @fiu..0			    !* ..0: terminating character!
 1fs^RArgpw  -1u1		    !* argument present, no digits yet!
 fq0< %1:g0"d 3fs^RArgpw 1;' >	    !* if find digit then set bit!
 0(q9fsQPUnwind)@:m(q..0fs^RIndirectfs^RCMacro)

!^R Break Line:! !^R Fill if too long, even out of Auto Fill mode.
Cursor may be anywhere within line.
Line will be broken (space inserted at margin) repeatedly until it
    fits within the margins.
Uses ^R Auto-Fill Space.!

!* Ugly on printing terminal.  Dont know how to fix that.  ^R Auto-Fill Space!
!* does its own redisplay that fouls us up.!

 .[0					!* 0: Original point.!
 0l .[1					!* 1: Start of line.!
 1[Auto Fill Mode			!* Temporarily in fill mode.!
 m.m^R Auto-Fill Space[S		!* S: Filler.!
 :l <.-(0msf).@;>			!* Fill as much as can.!
 q0:j"e :l'				!* Restore point, or end of line.!
 fsRGETTY"e 0t'			!* Printing tty.!
 1

!0:! !C Does nothing, returns nothing...
...but is good for something:
If you want to give some Teco commands from the bottom of the screen,
you can call ^R Extended Command (or any such "Meta-X") and give the
Teco commands as the "string argument".!
 

!UnSAILify:! !C Turn SAIL file into readable form.
M-X UnSAILify interchanges underscore and backarrow; this is good for
    mail.
1 M-X UnSAILify goes further and fixes lossage caused by image FTPing
    a SAIL file.!

 [1
 j 0s_			    !* interchange underscore and left arrow!
 <:s;0a#107.u1.-1f1>	    !* since SAIL has them backwards!
 ff&1"e j '		    !* if not 1 mmUnSAILify then we're done!
 j 0s 			    !* remove NULs!
 <:s;-d>			    !* ...!
 j 0s~				    !* SAIL has wedged ideas about codes!
 <:s;.-1f}>			    !* 175-176, 176 is their right brace!
 j 

!& Kill Prefixed Variable Names:! !S Kill variables if names STRARG-prefixed.
STRINGARG is prefix for variable name.  E.g. doing:

             m(m.m& Kill Prefixed Variable Names)Cache 

will kill all variables whose names start with "Cache ".!

 [1[2				    !* Save some regs.!
 q..q[..o			    !* Yank variable list into buffer.!
 :i1			    !* Get prefix to kill.!
 :fo..q1  *5,(		    !* get and save offset of first variable!
    fq1-1:g1+1u2		    !* clobber last character of string!
    fq1-1:f12		    !* to next character in ASCII sequence!
    :fo..q1  *5)k	    !* get offset of last variable and kill!
				    !* that range of buffer!
 

!& Insert Prefixed Variable Names:! !S Insert some variable names.
String argument is prefix for variable name.  One variable name to a
    line.
E.g. m(m.m& Insert Prefixed Variable Names)MM  will insert the names
    of all variables whose names start with "MM ".
Also see & Kill Prefixed Variable Names, and & List Prefixed Variable
    Names.!

 :i*[.1			    !* .1: STRINGARG, the prefix.!
 :fo..q.1,0f  [.2		    !* .2: Index to first variable with that!
				    !* prefix to its name.  The ,0f^@^@!
				    !* takes the absolute value, since may!
				    !* be there exactly or not.!

 [.3[.4

 < fq..q/5-1-q.2"L 1;'		    !* Stop if run off end of symtab.!
   q:..q(q.2)u.3		    !* .3: Maybe next matching varname.!
   f~(0,fq.1:g.3).1"G 1;'	    !* Stop after matches.!
   f~(0,fq.1:g.3).1"E	    !* Is a varname with matching prefix.!
     g.3			    !* Insert varname.!
     i
    '				    !* Done matching variable.!
   q.2+q:..q(0)u.2 >		    !* .2: Next variable index.!

 

!^R Uppercase Last Word:! !^R Uppercase word(s) before point.!
 -fwf(@fc) 

!^R Lowercase Last Word:! !^R Lowercase word(s) before point.!
 -fwf(fc) 

!^R Uppercase Last Initial:! !^R Capitalize word(s) before point.!
 .( -@m(m.m^R Uppercase Initial)f	    !* Capitalize backwards.!
    )j 1				    !* Restore point.!

!Uncontrolify:! !C Turn control chars into uparrowed chars.
This is good for listing a file with control characters in it on a
    line printer which would not show control characters well.
String argument is a string of characters NOT to change.
TABs are turned into spaces.  CRLF pairs are left alone.!
 [1[2[3[T			    !* save regs!
 :i3			    !* 3: characters not to convert!
 128*5fsBConsuT		    !* T: F^A q-vector!
 @fn|qTfsBKill|		    !* cleanup after ourselves!
 -1u1				    !* 1: index into q-vector!
 :i2-D94IQ..0#64I		    !* 2: control character converter!
 32< q2u:T(%1) >		    !* initialize all control characters!
 95< 201004020100.u:T(%1) >	    !* initialize all printing characters!
 q2u:T(%1)			    !* initialize rubout!
 @:i:T(9)|-D8-(FSSHPOS&7),32I|	    !* expanding tab!
 @:i:T(13)|0,1A-10"EC'-DI^M|	    !* CR is ^M unless followed by LF!
 @:i:T(27)|-D36I|		    !* ESC is $!
 -1u1				    !* 1: index into 3!
 fq3< 201004020100.u:T(%1:g3) >	    !* skip characters in string argument!
 ff"e h'"# f':fT	    !* H if no argument!
 

!Abort Recursive Edit:! !C Abnormal exit from recursive editing command.
The recursive edit is exited and the command that invoked it is
    aborted.
For a normal exit, you should use ^R Exit, NOT this command.
The command can put a string in Abort Resumption Message
to tell the user how to resume the command after aborting it.
If the option variable Less Asking is non-0, no message will be
    printed, and you will not be asked for confirmation.!

 m(m.m& Declare Load-Time Defaults)
    Less Asking,
      * Non-0 prevents Abort and Revert from asking: 0

    -fsBackStr-(m.m& Toplevel ^R)"e
      :i*Already at top levelfsErr'
    0fo..qLess Asking"e
      qAbort Resumption Message[0
      q0"e @ftAbort this recursive edit
          1m(m.m& Yes or No)"e 0''
      q0"n @ft
0''
    1f[NoQuit
    -1fsQuit
    fs^RExit			    !* Exit the ^R.  This will pop fs noquit,!
				    !* causing a quit afterward.!

!Revert File:! !C Undo changes to a file.
Reads back the file being edited from disk
(or the most recent save file, if that isn't the same thing).
A numeric argument means ignore the Auto Save files.
If the option variable Less Asking is non-0, you will not be asked for
    confirmation.
A nonzero pre-comma argument also waives confirmation.!

 m(m.m& Declare Load-Time Defaults)
    Less Asking,
      * Non-0 prevents Abort and Revert from asking: 0

    mMM & Check Top Levelfiles
    QBuffer Filenames[0
    .[1
    QBuffer Index[2 [3

    FF&1"E			    !* Choose visited filenames or auto save filenames.!
      Q:.B(Q2+10!*bufsav!)U3 FQ3"G  !* If we recently wrote an auto-save file, read it.!
	QAuto Save Count"N
	  Q3U0'''
    q0"e :i*No file to revert from fsErr'

    "E			    !* Query, unless that is inhibited by precomma arg.!
      0fo..qLess Asking"e
        @ftRestore file from disk
        1m(m.m& Yes or No)"e 0'''

    B[B 0,fsZfsBound
    ER0
    qBuffer Index[2
    fsIFCDateu:.B(Q2+8!*bufdat!)
    fsIFVersu:.B(Q2+9!*Bufver!)
    @Y  0fsModifw 0fsXModif
    fsWindow+QB:J"L 0L .fsWindow'
    Q1:J
    fs^RMDlyfs^RMCnt
    m(m.m& Process File Options)  !* Reprocess local modes!
    0fo..qVisit File HookU1	    !* Redo user's own processing.!
    Q1"N M1' 

!~TMACS Loaded~:! !For checking if loaded or compressed in.!
TMACS				    !* Must have some body.!

!& SetUp TMACS Library:! !I Load-time setup.!
 1,m.m& SetUp Compressed TMACS Librariesf"n[1 m1'w
 

!& Default Variable:! !I Just like M.C.
Kept around so old libraries generated by IVORY still work.!
!* This must be a subroutine and not something in an MM-variable put there by!
!* & setup since unfortunately the old IVORY-generated & Setups map in TMACS!
!* instead of just loading it.  Thus the & setup isnt run.!

 f:m.c				!* Let M.C do all the work.!

!* Following should be kept as a long comment so will compress out:
 * Local Modes:
 * Fill Column:78
 * Comment Column:40
 * MM Edit TMACS Documentation: 70[Fill Column  1
 * Compile Command: m(m.mGenerate Library)ECC;XTMACSEMACS1;TMACSTMUCS
 * End:
 *!
