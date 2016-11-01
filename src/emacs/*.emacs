!* -*-TECO-*- *!

!* This is the default init file for EMACS.
   Anything in the buffer when you start this
   will be used instead of the JCL.

It is generally a bad idea to try to make an init file
by copying this one with changes.  The right way, usually, is
to make your own small init file which jumps to this one at the end,
as described in INFO;CONV >. *!

    fs qp ptr[9		    !* save pdl pointer for unwinding!

    FQ(0FO..QAuto Save Filenames)-1"L
      FS MSNAME:F6[0
      :I*DSK:0;_SAV00 > M.VAuto Save Filenames ]0'

!* On non-meta keyboards, allow Alt 1 2 to mean an arg of 12, as long as user!
!* has not reconnected meta-digits.  Similarly for meta-minus.!
    FS %TOFCI"E				!* 9-bit keyboard.!
      M.M ^R Autoarg[0 460.-1[1 f..0fs^RInit[2
      10< %1@fs^RCMac-q2"e q0,q1@fs^RCMac' >
      f..-fs^RInit-q..-"e Q0U..-'
      ]2 ]1 ]0'

    fsxunamef(:f6[1)-(fshsname)"e et.FOO. >'"# et1 >' ]1
    FS MSNAME FS D SNAME

!* Now we have done enough that things will be OK if the EVARS file gets an!
!* error and throws back to the ^R.  The EVARS file should not be processed!
!* twice, e.g. in case it loads libraries, and a dumped EMACS should be able!
!* to jump to the default init.  Hence the variable check.!

    0fo..qInit Vars Processed"e	!* If not yet done it, process!
      M(M.M & Process Init Vars)	!* FOO;FOO EVARS or EMACS.VARS.!
      1m.vInit Vars Processedw'	!* Do not do it again.!

    FS XJNAME :F6 [J
    F[D FILE
    FS %OPLSP(F~JLISPT"'E)(F~JMACST"'E)"N
       1,M(M.M& Get Library Pointer)LISPT"e	!* Load LISPT if not!
          m(m.m Load Library)LISPT''	    	!* loaded already.!
    F~JMAILT "E :IEditor TypeMAILT
	:iDefault Major ModeText
	f~ModeText"n M(M.MTEXT MODE)' fr	!* Text mode if not in it yet.!
	0FO..Q Inhibit Help Message"E
	  FTEdit escape from :MAIL to EMACS.  Type ^C^C to return to MAIL.
''
    F]D FILE

    1:< QFind File Inhibit Write UInhibit Write >

!* Process the JCL!
    0[0 0[1
    Z"E FJ' ZJ			!* Get JCL, or use whatever previous init file left in buffer.!
    ."N				!* Process JCL command - extract filenames and commands!
       0,-1A-î"E -2D'	    !* REMOVE CRLF AT END IF ANY *!
       J :S"N .,Z^ FX1 -D'	    !* IF COMMANDS TO EXECUTE, PUT THEM IN Q1!
       HFX0'			    !* IF FILE TO BE READ, PUT NAME IN Q0!
    HK 0FS MODIFIED
    0FO..Q Inhibit Help Message"E
      Q0"E Q1"E			    !* If no commands / file to read, offer help.!
	qEMACS Version:\[1	    !* get version no. as string!
	FTEMACS Editor, version 1 - type Help
	FS %TOFCI"N FT(Top-H)'
	"# FT(^_H)'
	FT for help.
	]1
	'''
    FQ0"G
	0fo..qTags Find File"e
	  QInhibit Write, M(M.M Visit File)0' !* Visit file specified.!
	"# m(m.mFind File)0''   !* unless user generally likes Find File,!
				    !* in which case use it!
    Q1"N M1'			    !* Execute any commands from JCL!
    q9fsqpunwind
