
(DECLARE (GENPREFIX SYSCOM)) 

;;;*********************************************************************
;;;
;;;                 SYSCOM    - TOPLEVEL AND GENERAL UTILITY FUNCTIONS
;;;
;;;**********************************************************************

(DEFUN SHRDLU NIL 
       (PROG (ERT-TIME END AMB TIMAMB BOTH BACKREF BACKREF2 ANSNAME
	      LASTREL WHO PT PTW SENT PUNCT IGNORE H N NB FE SM RE
	      MES MESP C CUT CURTIME STATE GLOBAL-MESSAGE LEVEL
	      P-TIME SMN-TIME PLNR-TIME ANS-TIME ANS-PLNR-TIME
	      SH-GCTIME) 
	     (CLEANOUT TSS EVX NODE ANS OSS RSS X)		       ;FLUSH OLD GENSYMS
	CATCH-LOOP
	     (CATCH
	      (PROG NIL 
	       LOOP (SETQ SENTNO (ADD1 SENTNO) 
			  PARSINGS 0. 
			  LEVEL 0. 
			  LASTSENTNO (ADD1 LASTSENTNO) 
			  LASTSENT C 
			  GLOBAL-MESSAGE NIL 
			  MES 'NOPE 
			  BACKREF NIL 				       ;???????????????????
			  RUNTIME (RUNTIME) 
			  SH-GCTIME (STATUS GCTIME) 
			  PLNR-TIME 0. 
			  ANS-PLNR-TIME 0. 
			  SMN-TIME 0. 
			  ERT-TIME 0.)
	       UP   (SETQ N (SETQ SENT (ETAOIN)))
		    (OR ANNOYANCE (PRINT *1))
		    (AND ^Q (%))
		    (IOC S)
		    (AND IGNORE (GO UP))
		    ;;;
		    (COND
		     ((AND
		       (COND
			(TOPLEVEL-ERRSET?
			 (ERRSET
			  (SETQ PT (SETQ C (PARSEVAL PARSEARGS)))))
			(T (SETQ PT (SETQ C (PARSEVAL PARSEARGS)))))
		       C)
		      (OR ANNOYANCE (PRINT *2))
		      (SETQ FE (FE C))
		      (SETQ NB SENT)
		      (SETQ H (H C))
		      (SETQ INTERPRETATION (SM C))
		      (AND SH-BEFOREANSWER-PAUSE
			   (ERT BEFORE ANSWERING))
		      (COND
		       (SMN (AND SH-PARSE-PAUSE
				 (ERT PARSING COMPLETED))
			    (GO LOOP))
		       ((NOT ANSWER?)
			(AND SH-PARSESMNTC-PAUSE
			     (ERT ANALYSIS COMPLETED)))
		       ((COND
			 (TOPLEVEL-ERRSET?
			  (ERRSET (TIME-ANSWER '(ANSWER C))))
			 (T (TIME-ANSWER '(ANSWER C)))))
		       ((APPLY 'SAY
			       (OR GLOBAL-MESSAGE
				   '(I DON/'T UNDERSTAND/.))))))
		     ((PRINT *3)
		      (APPLY 'SAY
			     (OR GLOBAL-MESSAGE
				 '(I DON/'T UNDERSTAND/.)))))
		    (SHRDLU-TIMER)
		    (AND MOBYTEST-IN-PROGRESS (AFTER-EACH-SENTENCE))
		    (AND SH-STANDARD-PRINTOUT (SHSTPO))
		    (AND SH-AFTERANSWER-PAUSE (ERT))
		    (GO LOOP))
	      ABORT-PARSER)
	     (GO CATCH-LOOP))) 

(DEFUN TIMER (T0 T1) (QUOTIENT (- T1 T0) 1000000.0)) 

(DEFUN PARSEVAL (A) 
       (PROG (P-TTIME P-GC SM-TIME MP-TIME RETURN-NODE) 
	     (SETQ P-GC (STATUS GCTIME) 
		   SM-TIME 0. 
		   MP-TIME 0. 
		   P-TTIME (RUNTIME))
	     (SETQ RETURN-NODE (EVAL (CONS 'PARSE A)))
	     (SETQ P-TIME (DIFFERENCE (TIMER P-TTIME (RUNTIME))
				      SM-TIME
				      PLNR-TIME))
	     (OR (= P-GC (STATUS GCTIME))
		 (SETQ P-TIME
		       (DIFFERENCE P-TIME
				   (TIMER P-GC (STATUS GCTIME)))))
	     (SETQ SMN-TIME SM-TIME PLNR-TIME MP-TIME)
	     (RETURN RETURN-NODE))) 

(SETQ PARSEARGS '(CLAUSE MAJOR TOPLEVEL)) 

;;*page

;;;********************************************
;;;
;;;   test package !!  -experimental version
;;;
;;;********************************************
;;; how to use:
;;;
;;;   from within an  break at "READY", open, via uread, the file that
;;;   contains the sentences to be tested (see sample files on LANG;) and
;;;   open a file to write onto and do a (IOC r) whenever thing are set
;;;   up (remember that all prints will copy to the file after the ioc
;;;   is executed so a sneaky way to comment the output file is to say
;;;   "(say ...)" or some such.) 
;;;     Next set the (global) variable "mobytest-in-progress" to non-nil.
;;;   This will evade every break that the system does via ERTEX - that
;;;   should be all of them but at the moment (8/6/74) that can't be
;;;   guarenteed.
;;;     Functions below trap at the obvious places and could be tailored
;;;   to desired stuff.
;;;     At this point, the preliminaries are over; proceed the  break
;;;   and type a "m" and the next READY. - it should take off. 
;;;

(DEFUN AFTER-EACH-SENTENCE NIL 
       (COND (C (WALLP C) (DP (CAR (SM C)))))
       (TYO 12.)) 						       ;form feed

(DEFUN END-OF-FILE-CONDITION NIL 
       (AND ^R (UFILE SHTRCE >))
       (AND GO-AWAY (VALRET 'U))) 

(SETQ GO-AWAY NIL MOBYTEST-IN-PROGRESS NIL) 

;;*page

;;;********************************************************************************
;;;                        Fancy timing package
;;;********************************************************************************

(DEFUN SHRDLU-TIMER NIL 
       (PROG (BASE) 
	     (OR SH-PRINT-TIME (RETURN T))
	     (SETQ BASE 10.)
	     (TERPRI)
	     (PRINC 'TOTAL/ TIME/ USED:/ )
	     (PRINC (TIMER RUNTIME (RUNTIME)))
	     (PRINTC '/ / AMOUNT/ SPENT/ IN/ GARBAGE/ COLLECTION)
	     (PRINC (TIMER SH-GCTIME (STATUS GCTIME)))
	     (OR (EQ SH-PRINT-TIME 'FANCY) (RETURN T))
	     (TERPRI)
	     (PRINC 'BREAKDOWN:)
	     (PRINTC '/ / / PARSING)
	     (PRINC P-TIME)
	     (PRINTC '/ / / SEMANTICS)
	     (PRINC SMN-TIME)
	     (PRINTC '/ / / MICROPLANNER)
	     (PRINTC '/ / / / / / FOR/ SEMANTICS)
	     (PRINC PLNR-TIME)
	     (PRINTC '/ / / / / / FOR/ ANSWERING)
	     (PRINC ANS-PLNR-TIME)
	     (PRINTC '/ / / ANSWERING)
	     (PRINC ANS-TIME)
	     (TERPRI))) 

(DEFUN TIME-ANSWER (REAL-CALL) 
       (PROG (MP-TIME SM-TIME PLNR-TIME ANS-TTIME GC RESULT) 
	     (SETQ MP-TIME 0. 
		   SM-TIME 0. 
		   GC (STATUS GCTIME) 
		   ANS-TTIME (RUNTIME) 
		   PLNR-TIME 0.)
	     (SETQ RESULT (EVAL REAL-CALL))
	     (SETQ ANS-TIME
		   (DIFFERENCE (TIMER ANS-TTIME (RUNTIME)) PLNR-TIME))
	     (OR (= GC (STATUS GCTIME))
		 (SETQ ANS-TIME
		       (DIFFERENCE ANS-TIME
				   (TIMER GC (STATUS GCTIME)))))
	     (SETQ ANS-PLNR-TIME MPLNR-TIME 
		   SMN-TIME (PLUS SMN-TIME SM-TIME))
	     (RETURN RESULT))) 

(DEFUN PARSE-STATISTICS NIL 
       (COND ((= PARSINGS 0.)					       ;initialization
	      (PUTPROP 'PARSINGS 0. 'WINS)))
       (AND RE
	    (PUTPROP 'PARSINGS
		     (1+ (GET 'PARSINGS 'WINS))
		     'WINS))
       (SETQ PARSINGS (1+ PARSINGS))) 

;;; these next two are left over from previous incarnations
;;;(DEFUN TIMER NIL 
;;;       (AND SH-PRINT-TIME
;;;	    (PRINT 'TIME-USED)
;;;	    (PRINC (DIFFERENCE (TIME-SINCE RUNTIME) ERT-TIME)))) 

(DEFUN TIME-SINCE (X) (QUOTIENT (- (RUNTIME) X) 1000000.0)) 

;;*page

;;;****************************************************************
;;;        Functions that extract input from the user
;;;****************************************************************

(DEFUN INTEROGATE FEXPR (MESSAGE) 
       (PROG (CH) 
	MES  (MAPC (FUNCTION PRINT3) MESSAGE)
	     (TERPRI)
	     (COND ((MEMQ (SETQ CH (READCH)) '(Y /y))
		    (RETURN T))
		   ;;;  ((EQ CH '?)
		   ;;;   (EVAL (GET 'FLUSH 'EXPLANATION))
		   ;;;   (GO MES))
		   (T (RETURN NIL))))) 

(DEFPROP DEFLIST
	 (LAMBDA (LIST) (MAPC (FUNCTION (LAMBDA (A) 
						(PUTPROP (CAR A)
							 (CADR A)
							 (CAR LIST))))
			      (CDR LIST))
			(CAR LIST))
	 FEXPR) 

;;*PAGE

;;;****************************************************************
;;;           specialized and not so, output routines
;;;**************************************************************** 

(DEFUN % NIL 							       ;THIS FUNCTION PRINTS THE CURRENT SENTENCE
       (TERPRI)
       (MAPC 'PRINT3 SENT)
       (PRINC PUNCT)) 

(DEFUN DA (X) 
       (AND
	(GET X 'THASSERTION)
	(DISP
	 (APPLY 'APPEND
		(MAPCAR 'CDDR
			(APPLY 'APPEND
			       (MAPCAR 'CDR
				       (CDR (GET X
						 'THASSERTION))))))))) 

(DEFPROP DISP
	 (LAMBDA (0A) 
		 (AND (STATUS TTY) (TYO 12.))
		 (TERPRI)
		 (AND (CDR 0A)
		      (PRINC (CAR 0A))
		      (PRINC '/ >>/ )
		      (PRINC (CADR 0A))
		      (TERPRI))
		 (SPRINT (COND ((CDR 0A) (GET (CAR 0A) (CADR 0A)))
			       ((EVAL (CAR 0A))))
			 LINEL
			 0.)
		 *4)
	 FEXPR) 

(DEFUN DTABLE (L) 
       (PRINT =LINE)
       (MAPC '(LAMBDA (X) 
		      (PRINTC (TAB 5.) X (TAB 22.) '= (EVAL X))
		      (COND ((GET X 'TURNED)
			     (TAB 30.)
			     (PRINC (LIST (GET X 'TURNED))))))
	     L)
       (PRINTC =LINE)) 

(DEFUN DP (X) 
       (PROG (PLIST) 
	     (TERPRI)
	     (TERPRI)
	     (PRINC '[)
	     (PRINC X)
	     (PRINC '])
	     (SETQ PLIST (plist X))
	A    (COND ((MEMQ (CAR PLIST) '(PNAME VALUE)) (GO B)))
	     (TERPRI)
	     (TAB 4.)
	     (PRINC (CAR PLIST))
	     (SPRINT (CADR PLIST) (*DIF LINEL 18.) 18.)
	B    (COND ((SETQ PLIST (CDDR PLIST)) (GO A)))
	     (TERPRI)
	     (AND DPSTOP (ERT))
	     (RETURN '*))) 

(DEFUN FEXPR DSAY (L) (APPLY 'SAY L)) 

;;*page

;;;****************************************************************
;;;        functions for hand-tailored garbage collection
;;;****************************************************************

(DEFUN FORGET NIL 
       (SETQ LASTSENT NIL 
	     LASTREL NIL 
	     BACKREF NIL 
	     BACKREF2 NIL 
	     LASTTIME NIL 
	     LASTPLACE NIL)
       (SETQ LASTSENTNO 0.)
       (MAPC '(LAMBDA (PN) (MAPC '(LAMBDA (PROP) (REMPROP PN PROP))
				 '(BIND LASTBIND)))
	     '(IT THEY ONE))
       (AND EVENTLIST (PROGN (THFLUSH HISTORY) (STARTHISTORY)))) 

;;; THIS FUNCTION HAS ALSO INCLUDED A CALL TO "PLNRCLEAN"
;;; TO SCRUB AWAY THE EVENTLIST - BUT THE DETAILS OF ITS
;;; MICROPLANNER MANIPULATIONS ARE STILL BEING CHECKED FOR
;;; VERACTITY IN THE PRESENT DAY ENVIRONMENT (6/24/74)
;;; THE CODE WAS:
;;;  (DEFUN PLNRCLEAN (X)
;;;     (MAPC '(LAMBDA (Y)
;;;               (MAPC '(LAMBDA (Z)
;;;                         (THREMOVE (CAR Z)) )
;;;                     (CDDR Y)))
;;;           (GET X 'THASSERTION)) )
;;;
;;; AND THE CALL WAS:
;;;    (MAPC 'PLNRCLEAN EVENTLIST)
;;;

(DEFUN CLEANOUT FEXPR (LIST) 					       ;REMOB'S ALL GENSYMS OF THE MEMBERS OF LIST
       (MAPC (FUNCTION (LAMBDA (A) 
			       (CLEANX A 0. (GET A 'MAKESYM))
			       (PUTPROP A 0. 'MAKESYM)))
	     LIST)) 

(DEFUN CLEANUP FEXPR (SYMBOL-LIST) 
       ;;CLEANUP IS USED TO GET RID OF GENSYMS NO LONGER NEEDED ALL
       ;;GENSYMS FROM THE NUMBER "OLD" TO THE NUMBER "NEW" ARE
       ;;REMOB'ED THE "OLD" AND "NEW" PROPERTIES ARE UPDATED
       (MAPC '(LAMBDA (SYMBOL) 
		      (CLEANX SYMBOL
			      (GET SYMBOL 'OLD)
			      (PUTPROP SYMBOL
				       (GET SYMBOL 'NEW)
				       'OLD))
		      (PUTPROP SYMBOL
			       (GET SYMBOL 'MAKESYM)
			       'NEW))
	     SYMBOL-LIST)) 

(DEFUN CLEANX (A B C) 
       ;; CLEANX REMOB'S GENSYMS OF THE SYMBOL "A" FROM B+1 UP TO AND
       ;;INCLUDING C
       (PROG (SAVE I) 
	     (SETQ B (OR B 0.))
	     (SETQ SAVE (GET A 'MAKESYM))
	     (AND C
		  (GREATERP C B)
		  (PUTPROP A B 'MAKESYM)
		  (DO I B (ADD1 I) (EQUAL I C) (REMOB (MAKESYM A))))
	     (RETURN (PUTPROP A SAVE 'MAKESYM)))) 

;;*PAGE

;;;****************************************************************
;;;        a most complete and sophisticated break package
;;;****************************************************************

(DEFPROP THERT ERT FEXPR) 

(DEFUN ERT FEXPR (MESSAGE) (ERTEX MESSAGE NIL T)) 		       ;ALWAYS STOPS, NEVER CAUSES ABORTION. USED FOR
								       ;GUARENTEED STOPS AS IN DEBUGGING OR ETAOIN

(DEFUN ERTERR FEXPR (MESSAGE) (ERTEX MESSAGE T NIL)) 		       ;USED FOR KNOWN WIERD STATES SUCH AS CHOP. USES
								       ;"NOSTOP" SWITCH, CAUSES ABORTION

(DEFUN BUG FEXPR (MESSAGE) 
       (ERTEX (CONS 'BUG!!!!!!!!!! MESSAGE) T NIL)) 		       ; MARKES UNANTICIPATED WIERD STATES WHICH
								       ;INDICATE MISTAKES IN THE CODE.

(DEFUN GLOBAL-ERR FEXPR (MESSAGE) 
       (ERTEX (SETQ GLOBAL-MESSAGE MESSAGE) T NIL)) 		       ; MARKES KNOWN INADEQUACIES OF THE SYSTEM.
								       ;SWITCHABLE STOP, CAUSES ABORTION

(DEFUN ERTEX (MESSAGE CAUSE-ABORTION IGNORE-NOSTOP-SWITCH?) 
       (PROG (ERT-TIME GLOP EXP ST-BUFFER BUILDING-ST-FORM ^W ^Q
	      FIRSTWORD) 
	     (AND MOBYTEST-IN-PROGRESS (IOC W))
	     (AND NOSTOP
		  (NOT IGNORE-NOSTOP-SWITCH?)
		  (AND CAUSE-ABORTION
		       (THROW CAUSE-ABORTION ABORT-PARSER))
		  (RETURN T))
	     (SETQ ERT-TIME (RUNTIME))
	     (TERPRI)
	     (MAPC (FUNCTION PRINT3) MESSAGE)
	     (AND MOBYTEST-IN-PROGRESS
		  (THROW 'MOBYTEST ABORTPARSER))
	PRINT(SETQ FIRSTWORD T ST-BUFFER NIL BUILDING-ST-FORM NIL)     ;"ST" REFERS TO SHOW, TELL.
	     (COND (ZOG-USER (PRINT 'LISTENING--->))
		   (T (PRINT '>>>)))
	LISTEN
	     (COND
	      ;;SHELP UP SPURIOUS CHARACTERS
	      ((MEMBER (TYIPEEK) '(32. 10.))			       ;SP, LF
	       (READCH)
	       (GO LISTEN))
	      ;;CHECK FOR DELIMITER
	      ((EQ (TYIPEEK) 13.)				       ;CARRIAGE RETURN
	       (COND (BUILDING-ST-FORM (SETQ EXP		       ;DELIMITER CASE
					     (REVERSE ST-BUFFER))
				       (GO EVAL-EXP))
		     (T (READCH)				       ;SPURIOUS CHARACTER CASE
			(GO LISTEN)))))
	     ;;;
	     (OR (ERRSET (SETQ GLOP (READ))) (GO PRINT))
	     ;;;
	     (COND ((ATOM GLOP)
		    (SETQ GLOP (OR (GET GLOP 'ABBREV) GLOP))
		    (COND ((MEMQ GLOP '(T P NIL))		       ;LEAVE-LOOP CHARS
			   (SETQ ERT-TIME
				 (PLUS (TIME-SINCE ERT-TIME)
				       ERT-TIME))		       ;ERT-TIME IS BOUND BY SHRDLU
			   (RETURN GLOP))
			  ((EQ GLOP 'GO)			       ;CAUSE RETURN TO READY-STATE
			   (THROW 'GO ABORT-PARSER))
			  (BUILDING-ST-FORM (SETQ ST-BUFFER
						  (CONS GLOP
							ST-BUFFER))
					    (GO LISTEN))
			  ((AND FIRSTWORD
				(MEMQ GLOP '(SHOW TELL)))
			   (SETQ BUILDING-ST-FORM T 
				 ST-BUFFER (CONS GLOP ST-BUFFER) 
				 FIRSTWORD NIL)
			   (GO LISTEN))
			  (ZOGUSER (PRINC GLOP)
				   (SAY ISN/'T A COMMAND)
				   (TERPRI)
				   (GO PRINT))
			  (T (SETQ EXP GLOP) (GO EVAL-EXP))))
		   (T (COND ((EQ (CAR GLOP) 'RETURN)
			     (RETURN (EVAL (CADR GLOP))))
			    (T (SETQ EXP GLOP) (GO EVAL-EXP)))))
	     ;;;
	EVAL-EXP
	     (COND (ERT-ERRSET? (ERRSET (PRINT (EVAL EXP))))
		   (T (PRINT (EVAL EXP))))
	     (GO PRINT))) 

;;*PAGE


(DEFUN COMBINATION? FEXPR (WORDS) 
       ;;THIS FUNCTION CHECKS TO SEE IF THE WORDS PASSED AS ARGS FORM
       ;;A COMBINATION SUCH AS "STACK-UP" OR "ON-TOP-OF" COMBINATIONS
       ;;ARE IN THE DICTIONARY AS A SINGLE ATOM COMPOSED OF THE WORDS
       ;;IN THE COMBINATION SEPARATED BY DASHES ALL COMBINATIONS HAVE
       ;;THE FEATURE "COMBINATION" AND HAVE A ROOT WHICH IS A LIST OF
       ;;THE WORDS IN THE COMBINATION
       (PROG (COMBINE) 
	     (MAPC 
	      '(LAMBDA (X) 
		(SETQ COMBINE (NCONC COMBINE
				     (CONS '-
					   (EXPLODE (EVAL X))))))
	      WORDS)
	     (SETQ COMBINE (LIST (INTERN (MAKNAM (CDR COMBINE)))))
	     (AND (ISQ COMBINE COMBINATION) (RETURN COMBINE))
	     (RETURN NIL))) 

(SETQ CONSO '(B C D F G H J K L M N P Q R S T V W X Z)) 

(DEFPROP FINDB
	 (LAMBDA (X Y) (COND ((NULL X) NIL)
			     ((EQ Y (CDR X)) X)
			     (T (FINDB (CDR X) Y))))
	 EXPR) 

(DEFPROP FROM
	 (LAMBDA (A B) (COND ((OR (NOT A) (EQ A B)) NIL)
			     (T (CONS (WORD A) (FROM (CDR A) B)))))
	 EXPR) 

(DEFUN MAKESYM (A) 
       ;; FUNCTION MAKESYM MAKES UP A GENSYM OF ITS ARG
       (PUTPROP A
		(ADD1 (OR (GET A 'MAKESYM) 0.))
		'MAKESYM)
       (SETQ A (MAKNAM (APPEND (OR (GET A 'EXPLO)
				   (PUTPROP A
					    (EXPLODE A)
					    'EXPLO))
			       (EXPLODE (GET A 'MAKESYM)))))
       (COND (MAKEINTERN (INTERN A)) (A))) 

(DEFUN LIS2FY (X) 
       (COND ((ATOM X) (LIST (LIST X)))
	     ((ATOM (CAR X)) (LIST X))
	     (X))) 

(DEFUN MEET (A MEET) 
       ;; MEET RETURNS THE INTERSECTION OF 2 LISTS TREATED AS SETS
       (PROG (SET) 
	GO   (COND ((NULL A) (RETURN (REVERSE SET)))
		   ((MEMQ (CAR A) MEET)
		    (SETQ SET (CONS (CAR A) SET))))
	     (SETQ A (CDR A))
	     (GO GO))) 

(DEFPROP MOD (LAMBDA (A B) (UNION (SETDIF A (CADR B)) (CAR B))) EXPR) 

(DEFUN NTH (NUM LIST) 
       (COND ((ATOM LIST) (ERT NTH - ILLEGAL LIST))
	     ((LESSP NUM 1.) (ERT NTH - ILLEGAL NUMBER)))
       (PROG NIL 
	UP   (COND ((EQUAL NUM 1.) (RETURN (CAR LIST)))
		   ((SETQ LIST (CDR LIST))
		    (SETQ NUM (SUB1 NUM))
		    (GO UP))
		   (T (ERT NTH - LIST TOO SHORT))))) 

(DEFPROP PR1
	 (LAMBDA (A) 
		 (COND ((ATOM (H A)) (LIST (WORD (NB A)) (FE A)))
		       ((PR2 (SM A))
			(LIST (FROM (NB A) (N A))
			      (FE A)
			      (SM A)
			      (COND ((ATOM (H A)) '/ )
				    ((MAPLIST (FUNCTION PR1)
					      (REVERSE (H A)))))))))
	 EXPR) 

(DEFPROP
 PR2
 (LAMBDA (A) 
  (OR
   (ATOM A)
   (MAPC 
    (FUNCTION (LAMBDA (B) 
		      (AND (GET B 'SM)
			   (OR (MEMQ B ALIST)
			       (SETQ ALIST
				     (CONS (LIST B
						 (GET B 'SM)
						 (GET B
						      'REFER))
					   ALIST))))))
    A)))
 EXPR) 

(DEFUN PRINT2 (X) 
       (COND ((GREATERP CHRCT (FLATSIZE X)) (PRINC '/ ))
	     (T (TERPRI)))
       (PRINC X)) 

(DEFUN PRINT3 (X) 
       (PROG2 (OR (GREATERP CHRCT (FLATSIZE X)) (TERPRI))
	      (PRINC X)
	      (PRINC '/ ))) 

(DEFUN PRINTEXT (TEXT) 
       (COND (TEXT (TERPRI)
		   (EVAL (CONS 'SAY (LISTIFY TEXT)))))) 

(DEFPROP PRINTC
	 (LAMBDA (L) (PROG (TEST) 
			   (TERPRI)
		      =>   (COND ((NULL L) (RETURN NIL)))
			   (SETQ TEST (EVAL (CAR L)))
			   (COND ((EQ TEST '<TAB>))
				 (T (PRINC TEST) (PRINC '/ )))
			   (SETQ L (CDR L))
			   (GO =>)))
	 FEXPR) 

(DEFUN QUOTIFY (X) (LIST 'QUOTE X)) 

(DEFPROP SAY (LAMBDA (A) (MAPC (FUNCTION PRINT3) A)) FEXPR) 

(DEFUN SETDIF (A SETDIF) 
       (PROG (SET) 
	GO   (COND ((NULL A) (RETURN (REVERSE SET)))
		   ((MEMQ (CAR A) SETDIF))
		   ((SETQ SET (CONS (CAR A) SET))))
	     (SETQ A (CDR A))
	     (GO GO))) 

(DEFPROP STA
	 (LAMBDA (A B) (PROG NIL 
			GO   (COND ((NULL B) (RETURN T))
				   ((NULL A))
				   ((EQ (CAR A) (CAR B))
				    (SETQ A (CDR A))
				    (SETQ B (CDR B))
				    (GO GO)))))
	 EXPR) 

(DEFUN UNION (A B) 
       (PROG (SET) 
	     (SETQ SET (REVERSE A))
	GO   (COND ((NULL B) (RETURN (REVERSE SET)))
		   ((MEMQ (CAR B) SET))
		   ((SETQ SET (CONS (CAR B) SET))))
	     (SETQ B (CDR B))
	     (GO GO))) 

(DEFPROP WALLP
	 (LAMBDA (A) (PROG (ALIST LINEL) 
			   (SETQ LINEL WPLINEL)
			   (AND (STATUS TTY) (TYO 12.))
			   (TERPRI)
			   (SPRINT (LIST (PR1 A) (REVERSE ALIST))
				   LINEL
				   0.)))
	 EXPR) 

(SETQ WPLINEL 72.) 

(DEFUN DEFS FEXPR (L) 
       (PROG (A) 
	     (AND (NULL (CDR L)) (RETURN L))
	     (SETQ A (CAR L))
	     (SETQ L (CDR L))
	LOOP (PUTPROP A (CADR L) (CAR L))
	     (COND ((SETQ L (CDDR L)) (GO LOOP)))
	     (RETURN A))) 

(DEFPROP TAB
	 (LAMBDA (N) (PROG (P) 
			   (COND ((GREATERP N LINEL)
				  (RETURN '<TAB>)))
		      A	   (SETQ P (DIFFERENCE LINEL CHRCT))
			   (COND ((NOT (GREATERP N P))
				  (RETURN '<TAB>)))
			   (PRINC '/ )
			   (GO A)))
	 EXPR) 

(DEFUN SPACE (N) 
       (PROG (NN) 
	A    (COND ((GREATERP N 0.)
		    (PRINC '/ )
		    (SETQ N (SUB1 N))
		    (GO A))))) 
