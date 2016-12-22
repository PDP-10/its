!* -*-TECO-*- *!

!* This is the EMACS init for TEACH-EMACS.
   It visits the teaching file and dumps out the
   runnable EMACS tutorial program.!

!* Create startup macro to be run when we're 'd.!
 @:i*| :i..9 f[bbind
       fs rgetty"e
!"! ftUnfortunately, the EMACS tutorial cannot be used on a printing
terminal.  Your terminal is a printing terminal, or at least that
is what the system believes.  If you have access to a CRT terminal,
try this program again from there.  If your terminal really is a CRT
but the system doesn't know it,
         fs osteco"n !"! ft
you should use the EXEC command Terminal Type to tell it, and try again.
If the system doesn't know about your type of terminal but EMACS does,
you should use the EXEC commands Terminal Length and Terminal Width to
tell the system the size of your screen, try again, and when the tutorial
gets to this point that time, type the EMACS codename for the terminal.

	   < 1:< @m(m.mSet Terminal Type) >;
	     !"! ft
Sorry, that isn't a known terminal type.  Here are the known types:

	     m(m.mList Library)TRMTYP
	     !"! ft
 ft
You don't type the "# TRMTYP ".  For example, if you are on a
Datamedia Elite 2500, type "DM2500".
 ft
Try again now.
 ft
 !''''!
	     >
	   fs rgetty"e !"! ft
It looks like your terminal really can't do the job.  Sorry.
	     fsexit'
	   f+'
         fs osteco"e ft
you should try telling the system, and try again.
For information on display terminals supported by ITS, do :TCTYP ?<cr>,
or look in INFO;CRTSTY > for info on indirectly supported terminals.
           140000.FS EXIT''
       fs osteco"n er <emacs>emacs.init @y'
       "# er emacs;* emacs @y'
       m(hfx*(i )) f]bbind
       fsosteco"e etdsk:teach text'
       "# etdsk:teach-emacs.tutorial'
       fshsnamefsdsnamew fsdfileu0	    !* Compute desired visited file!
       q0uBuffer Filenames	    !* Put that name in right places.!
       q0u:.b(qBuffer Index+2)
       m(m.m & Set Mode Line)
       jsblank lines inserted here !* grow text to fit screen size.!
       0l:k fsheight-24< i
> j
       !* On non-meta keyboards, allow Alt 1 2 to mean an arg of 12.!
       FS %TOFCI"E
         M.M ^R Autoarg[0 460.-1[1
	 10< %1W Q0U1>  Q0U..-
	 ]1 ]0'
       0fsmodif
       0u..h :m..l
       F+
      | m.vMM & Startup EMACS

 m(m.mLoad Lib)Docond
 0fsmodified
 0u*Initialization*   !* Make this work if run in a just-built EMACS.!

 fsosteco"e
   -1,m(m.m Visit File)EMACS;TEACH >
   m(m.m Fundamental Mode)
   m(m.mDocond Set Flag)+ITS'
 "#
   -1,m(m.m Visit File)<EMACS>TEACH-EMACS.TXT
   m(m.m Fundamental Mode)
   m(m.mDocond Set Flag)+Twenex'

!* Do the DOCONDing, inside an ^R in case we aren't already in one.!
 70[Fill Column
 @:i*| m(m.mDocond) fs^r exit|f[^r enter
 
 -2fs qp unwind

 fsosteco"e
   m(m.aPURIFYDump Environment)EMACS;TSTCH >'
 "#
   fs osteco-1"e
     m(m.aPURIFYDump Environment)<EMACS>TEACH-EMACS.EXE'
   "#  m(m.aPURIFYDump Environment)<EMACS>TEACH-EMACS.SAV''

 FTEMACS tutorial dumped.

 160000. fs exit

