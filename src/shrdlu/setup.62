(declare (genprefix setup))

;;;################################################################
;;;
;;;           SETUP - initialization file for SHRDLU
;;;
;;;################################################################

(setq parsings 0) ;atom used in the timing package

(SETQ ELSE
      T
      SAVESENT
      NIL
      ALTMODE
      (ASCII 27.)
      DOT
      (ASCII 46.)
      *1
      '[1]
      *2
      '[2]
      *3
      '[3]
      *4
      '[4]
      *5
      '[5]
      *6
      '[6]
      LASTSENTNO
      0.
      SENTNO
      1.
      UNMKD
      '(COMPONENT BOTH)
      LASTIME
      NIL) 

(SETQ DPSTOP
      NIL
      NODE-STOP
      NIL
      SMN-STOP
      NIL
      ERT-TIME
      0.
      ALTMODE
      (LIST (ASCII 27.))
      BREAKCHARS
      (LIST (ASCII 32.) (ASCII 13.) (ASCII 46.))
      LINEL
      65.
      =LINE
      '========================================================) 

(OR (GET 'CLAUSE 'SUBR)
    (LABELTRACE CLAUSE NG VG ADJG PREPG CONJOIN)) 

;;*PAGE

;;;**********************************************************************
;;;            SWITCHES AND SWITCH-SETTING PACKAGES
;;;**********************************************************************

(SETQ FEATURESWITCHES '(MOBYREAD DISCOURSE NOMEM IASSUME TIMID)) 

(SETQ PAUSESWITCHES
      '(ANS-AFTEREVALUATION-PAUSE ANS-AFTERFORMULATION-PAUSE
				  EVALANS-PAUSE
				  SH-SENT-PAUSE
				  SH-BEFOREANSWER-PAUSE
				  SH-FINISHED-PAUSE
				  PNS-BK
				  PLNRSEE-PAUSE)) 

(SETQ CONTROLSWITCHES '(NOSTOP ANSWER?
			       SMN
			       TOPLEVEL-ERRSET?
			       ERT-ERRSET?
			       MAKEINTERN)) 

(SETQ DISPLAYSWITCHES '(PARSETRACE PARSEBREAK
				   PARSENODE-SEE
				   LABELTRACE
				   MAKE-VERBOSE
				   LABELBREAK
				   BUILDSEE
				   BUILD-SEE
				   PLANNERSEE
				   SH-PRINT-TIME)) 

;;;*************************

(SETQ MAKE-VERBOSE
      NIL
      PARSETRACE
      NIL
      PARSEBREAK
      NIL
      PARSENODE-SEE
      NIL
      LABELTRACE
      NIL
      LABELBREAK
      NIL
      BUILDSEE
      NIL
      BUILD-SEE
      NIL
      PLANNERSEE
      NIL
      SH-PRINT-TIME
      NIL) 

(SETQ MOBYREAD
      NIL
      DISCOURSE
      T
      WANT-DISPLAY
      NIL
      NOMEM
      NIL
      IASSUME
      T
      TIMID
      200.) 

(SETQ MAKEINTERN NIL) 

(SETQ SH-BEFOREANSWER-PAUSE
      NIL
      ANS-AFTEREVALUATION-PAUSE
      NIL
      ANS-AFTERFORMULATION-PAUSE
      NIL
      EVALANS-PAUSE
      NIL
      NOSTOP
      NIL
      ANSWER?
      T
      SMN
      NIL
      DOIT
      NIL
      TOPLEVEL-ERRSET?
      NIL
      ERT-ERRSET?
      T
      SH-PARSE-PAUSE
      NIL
      SH-PARSESMNTC-PAUSE
      NIL
      SH-AFTERANSWER-PAUSE
      NIL
      PNS-BK
      NIL
      PLNRSEE-PAUSE
      NIL) 

;;;***********************************

(DEFUN QUIETMODE NIL 
       (MAPC '(LAMBDA (X) (SET X NIL)) DISPLAYSWITCHES)) 

(DEFUN NOPAUSES NIL 
       (MAPC '(LAMBDA (X) (SET X NIL)) PAUSESWITCHES)) 

(DEFUN NORMALFEATUREMODE NIL 
       (SETQ MOBYREAD NIL DISCOURSE T NOMEM NIL IASUME T TIMID 200.)) 

(DEFUN USERMODE NIL 
       (QUIETMODE)
       (NORMALFEATUREMODE)
       (NOPAUSES)
       (SETQ NOSTOP
	     T
	     ANSWER?
	     T
	     SMN
	     NIL
	     TOPLEVEL-ERRSET?
	     T
	     ERT-ERRSET
	     T)
       (SETQ *RSET NIL)
       (IOC C)
       (SETQ SH-PRINT-TIME T)) 

(DEFUN DEBUGMODE NIL 
       (QUIETMODE)
       (NORMALFEATUREMODE)
       (NOPAUSES)
       (SETQ NOSTOP
	     NIL
	     ANSWER?
	     T
	     SMN
	     NIL
	     TOPLEVEL-ERRSET?
	     NIL
	     ERT-ERRSET
	     T)
       (SETQ *RSET T)
       (IOC D)
) 

(SETQ ZOG-USER NIL ZOGUSER NIL) 

;;;*******************************

 

;;*PAGE

;;;*****************************************************************
;;;           INITIALIZATION ROUTINES
;;;*****************************************************************

(DEFUN INITIALSTUFF (version date note) 
       (SUSPEND)
       (CURSORPOS 'C)
       (TERPRI)
       (PRINC 'SHRDLU/ VERSION/ )
       (princ version)
       (princ '/ / / )
       (PRINC 'LOADED/ )
       (PRINC date )
       (princ '/ )
       (PRINC 'IN/ BLISP/ )
       (princ (status lispversion))
       (TERPRI)
       (SAY REFER COMMENTS AND QUESTIONS TO DDM)
       (TERPRI)
       (TERPRI)
(and note (progn (terpri)(apply 'say note)
            (terpri)(terpri)))
;;;       (SAY -IF YOU ARE NEAR A DEC-340)
;;;       (TERPRI)
;;;       (PRINC '/ / / / / )
;;;       (OR (AND (INTEROGATE DO YOU WANT THE DISPLAY /(TYPE "Y/ " OR "N/ "/))
;;;		(SETQ WANT-DISPLAY T))
;;;	   (SETQ WANT-DISPLAY NIL))
;;;       (COND ((NOT WANT-DISPLAY) (NO340)))
;;;       (COND ((EQ WANT-DISPLAY T)
;;;	      (UREAD GRAPHF INIT DSK RBRN)
;;;	      (IOC Q)
;;;	      (PROG (D V) 
;;;		    (SETQ D '((NIL)))
;;;	       MORE (COND ((NOT (EQ D (SETQ V (READ D))))
;;;			   (EVAL V)
;;;			   (GO MORE)))))
;;;	     (T (SETQ PH-TURN-ON
;;;		      NIL
;;;		      GP-LINES
;;;		      NIL
;;;		      GP-SURFACE
;;;		      NIL
;;;		      GP-HANDIT
;;;		      NIL
;;;		      GP-NEWOBLOCAT
;;;		      NIL
;;;		      PH-BLOCKS
;;;		      NIL)
;;;		(GP-INITIAL)))
;;;       (TERPRI)
       (SAY YOU ARE NOW IN A READ-EVAL-PRINT LOOP)
       (TERPRI)
       (SAY TYPE "GO/ " TO ENTER READY STATE)
       (CATCH (ERT) ABORT-PARSER)
       (sstatus toplevel '(shrdlu))
       (SHRDLU)) 

(DEBUGMODE) 

(setq sh-standard-printout t smnbreak nil smntrace nil makintern t annoyance nil)

(SSTATUS PAGEPAUSE T) 

(IOC D) 
(setq errlist nil)

(SETQ Z (status tty) w1 (car z) w2 (cadr z))
(setq w1 (boole 7 w1 020202020202)
      w2 (boole 7 w2 020202020202) )
(sstatus tty w1 w2)
