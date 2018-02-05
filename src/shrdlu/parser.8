;;;################################################################
;;;
;;;   PARSER - setup file for parsing system in programmar
;;;
;;;################################################################

(defun setup (gram-num date)
	(suspend)
	(cursorpos 'c)
	(terpri)
	(princ 'shrdlu/'/s/ P/a/r/s/e/r/ / / )
	(princ '/u/s/i/n/g/ /g/r/a/m/m/a/r/ )
	(princ gram-num)
	(terpri)
	(princ date)
	(princ '/ / lisp/ )
	(princ (status lispversion))
	(terpri)
	(terpri)
	(say this is a read-eval-print loop)
	(say type "go/ " to enter ready state)
	(catch (ert) abort-parser)
	(sstatus toplevel '(parser))
	(parser))



(setq makeintern t ;;;  switch for interning the atoms created
;;;   for the node structure
  sh-standard-printout nil ;;;  switch for evaluating display functions
;;;   in the function SHSTPO (the SHOW file)
  sh-afteranswer-pause t  ;;;   switch for causing a break after each
;;;  sentence is processed.
	)

(setq annoyance t  ;;;  turns off the [1] printouts in SHRDLU
 smn t ;;;   turns off evaluation by real smn-fns
)

(setq car t cdr t ;;;  annoying patch to keep *RSET happy
     )

(DEFUN parser NIL 
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
(terpri)
(princ 'time/ spent/ parsing/ )
(princ p-time))
		     ((PRINT *3)
		      (APPLY 'SAY
			     (OR GLOBAL-MESSAGE
				 '(I DON/'T UNDERSTAND/.)))))
		    (AND MOBYTEST-IN-PROGRESS (AFTER-EACH-SENTENCE))
		    (AND SH-STANDARD-PRINTOUT (SHSTPO))
		    (AND SH-AFTERANSWER-PAUSE (ERT))
		    (GO LOOP))
	      ABORT-PARSER)
	     (GO CATCH-LOOP)))




(DEFUN ETAOIN NIL 
;;;  has a patch added to permit online definition
;;;  of an unknown word's syntactic features
;;;
       (PROG (WORD NEWWORD CHAR ALTN ALREADY-BLGING-NEWWRD WRD LAST features
	      NEXT Y WORD1 X RD POSS) 
	THRU (SETQ SENT (SETQ WORD (SETQ PUNCT (SETQ POSS NIL))))
	     (PRINT 'READY)
	     (TERPRI)
	     (AND MOBYREAD (IOC Q))
	CHAR (COND ((EQUAL (TYIPEEK) 24.) (READCH) (ERT) (GO THRU)); "cntrl-x" break
;left over from CMU
                   ((= (tyipeek) 3.)
(or (and mobyread (end-of-file-condition))
    (bug etaoin: about to read eof)) )
)
	     (setq char (cond ((greaterp 123. (setq char (tyi)) 96.) (- char 32.))
			      ((greaterp 91. char 64.) char)
			      (t char))
   	           char (ascii char)
                   ;;this little hack maps all lowercase letters into uppercase.
		   ;;a more reasonable thing to do would be to hack the chtrans
		   ;;property of the current readtable, but this was quicker to
		   ;;patch.
                   )
    	     (cond ((EQ char '/ ) (GO WORD))           ;DELIMITER
		   ((MEMQ CHAR ALTMODE)
		    (setq char (ascii (uppercase-ify-char (tyi))) )
		    (COND ((MEMQ char ALTMODE)
			   (ERT)
			   (GO THRU))
								       ;ALTMODE-ALTMODE
			  ((EQ CHAR 'C) (TYO 12.) (GO DO))
								       ;ALTMODE-C
			  ((EQ CHAR 'R) (TERPRI) (GO DO))
								       ;ALTMODE-R
			  ((AND (EQ CHAR 'S) SAVESENT)
								       ;ALTMODE-S CAUSES THE LAST SENTENCE TYPED IN TO
			   (SETQ SENT (CAR SAVESENT))
								       ;RETURNED AS THE SENTENCE TO BE INTERPRETED
			   (SETQ PUNCT (CDR SAVESENT))
			   (%)
			   (RETURN SENT))
			  ((EQ CHAR 'N)
			   (SETQ NEWWORD (NOT NEWWORD) 
				 ALTN (NOT ALTN))
			   (GO CHAR))
								       ;ALTMODE-N COMPLEMENTS THE NEWWORD FLAG, WHICH
			  ((EQ CHAR 'Q)
								       ;DETERMINES WHETHER UNRECOGNIZED WORDS WILL BE
			   (IOC Q)
								       ;CONSIDERED SPELLING ERRORS OR NEW WORDS.
			   (SETQ IGNORE NIL)
			   (GO THRU))
								       ;ALTMODE-Q CAUSES READIN FROM DISK FILE.
			  ((EQ CHAR 'M)
			   (IOC Q)
			   (SETQ IGNORE NIL MOBYREAD T)
			   (GO thru))
			  ((EQ CHAR 'I)
			   (SETQ IGNORE T)
			   (IOC Q)
			   (GO THRU))
								       ;ALTMODE-I IGNORES SENTENCE READ FROM FILE.
			  ((GO THRU))))
		   ((EQ CHAR RUBOUT)
		    (COND (WORD (PRINC (CAR WORD))
				(SETQ WORD (CDR WORD)))
			  (SENT (PRINT (CAR SENT))
				(SETQ SENT (CDR SENT))))
		    (GO CHAR))
		   ((EQ CHAR CARRET) (GO WORD))
		   ((MEMQ CHAR PUNCL)
		    (SETQ PUNCT CHAR)
								       ;DELIMITER
		    (AND WORD (GO WORD))
		    (GO PUNC)))
	     (AND
	      (OR (AND (EQ CHAR '")
		       (NOT ALREADY-BLGING-NEWRD)
		       (SETQ NEWWORD (SETQ ALREADY-BLGING-NEWRD T))
		       (GO CHAR))
		  (AND (EQ CHAR '")
		       ALREaDY-BLGING-NEWRD
		       (NOT (SETQ ALREADY-BLGING-NEWRD NIL))
		       (GO WORD))
								       ;WITHIN THIS "AND" ARE ALL THE CHARACTERS THAT
		  (NUMBERP CHAR)
								       ;ARE UNDERSTOOD BY THE SYSTEM
		  (AND (EQ CHAR '=) (NULL WORD))
		  (MEMQ CHAR VOWEL)
		  (MEMQ CHAR CONSO))
	      (SETQ WORD (CONS CHAR WORD)))
	     (GO CHAR)
	DO   (PRINT 'READY)
	     (TERPRI)
	     (MAPC (FUNCTION (LAMBDA (X) (PRINT2 X))) (REVERSE SENT))
	     (PRINC '/ )
	     (MAPC (FUNCTION PRINC) (REVERSE WORD))
	     (GO CHAR)
	WORD (COND ((NULL WORD) (GO CHAR))
		   ((EQUAL WORD '(P L E H)) (HELP) (GO THRU))
		   ((AND (SETQ WRD (ERRSET (READLIST (REVERSE WORD))))
			 (NUMBERP (SETQ WRD (CAR WRD))))
		    (SETQ SENT (CONS WRD SENT))
		    (BUILDWORD WRD
			       (OR (AND (ZEROP (SUB1 WRD))
					'(NUM NS))
				   '(NUM))
			       (LIST 'NUM WRD)
			       NIL))
								       ;NO ROOT FOR NUMBERS
		   ((NULL WRD) (SETQ WRD (REVERSE WORD)) (GO NO))
		   ((GET WRD 'FEATURES))
								       ;IF A WORD HAS FEATURES, IT'S PROPERTIES 
		   ((SETQ X (GET WRD 'IRREGULAR))
								       ;ARE ALL SET UP IN THE DICTIONARY
		    (BUILDWORD WRD
			       (MOD (GET (CAR X) 'FEATURES)
				    (CDR X))
			       (SM X)
			       (CAR X)))
		   ((EQ (CAR (LAST WORD)) '=)
		    (BUILDWORD WRD
			       (COND ((MEMQ '" WORD)
				      '(PROPN NS POSS))
				     ('(PROPN NS)))
			       '((PROPN T))
			       NIL))
		   ((GO CUT)))
	     (GO WRD)

	     ;;;---------------------------------------------
	     ;;;              MORPHOLOGY CODE
	     ;;;--------------------------------------------
	CUT  (COND ((STA WORD '(T " N))
		    (SETQ RD (CDDDR WORD))
		    (SETQ WORD (CONS '* WORD))
		    (GO TRY))
		   ((STA WORD '(S "))
		    (SETQ WORD (CDDR WORD))
		    (SETQ POSS WRD)
		    (GO WORD))
		   ((STA WORD '("))
		    (SETQ WORD (CDR WORD))
		    (SETQ POSS WRD)
		    (GO WORD))
		   ((STA WORD '(Y L))
		    (SETQ RD (CDDR WORD))
		    (GO LY))
		   ((STA WORD '(G N I)) (SETQ RD (CDDDR WORD)))
		   ((STA WORD '(D E)) (SETQ RD (CDDR WORD)))
		   ((STA WORD '(N E)) (SETQ RD (CDDR WORD)))
		   ((STA WORD '(R E)) (SETQ RD (CDDR WORD)))
		   ((STA WORD '(T S E)) (SETQ RD (CDDDR WORD)))
		   ((STA WORD '(S))
		    (SETQ RD (CDR WORD))
		    (GO SIB))
		   (T (GO NO)))
	     (SETQ LAST (CAR RD))
	     (SETQ NEXT (CADR RD))
	     (COND ((AND (MEMQ LAST CONSO)
			 (NOT (MEMQ LAST LIQUID))
			 (EQ LAST NEXT))
		    (SETQ RD (CDR RD)))
		   ((EQ LAST 'I)
		    (SETQ RD (CONS 'Y (CDR RD))))
		   ((OR (AND (MEMQ LAST CONSO)
			     (MEMQ NEXT VOWEL)
			     (NOT (EQ NEXT 'E))
			     (MEMQ (CADDR RD) CONSO))
			(AND (MEMQ LAST LIQUID)
			     (MEMQ NEXT CONSO)
			     (NOT (MEMQ NEXT LIQUID)))
			(AND (EQ LAST 'H) (EQ NEXT 'T))
			(AND (MEMQ LAST '(C G S J V Z))
			     (OR (MEMQ NEXT LIQUID)
				 (AND (MEMQ NEXT VOWEL)
				      (MEMQ (CADDR RD) VOWEL)))))
		    (SETQ RD (CONS 'E RD))))
	     (GO TRY)
	LY   (COND ((AND (MEMQ (CAR RD) VOWEL)
			 (NOT (EQ (CAR RD) 'E))
			 (MEMQ (CADR RD) CONSO))
		    (SETQ RD (CONS 'E RD))))
	     (COND ((MEMQ 'ADJ
			  (GET (SETQ ROOT (READLIST (REVERSE RD)))
			       'FEATURES))
		    (BUILDWORD WRD
			       '(ADV VBAD)
			       NIL
								       ;TEMP NIL SEMANTICS
			       ROOT)
								       ;ROOT IS THE ADJECTIVE
		    (GO WRD)))
	     (GO NO)
	SIB  (SETQ LAST (CAR RD))
	     (SETQ NEXT (CADR RD))
	     (COND ((NOT (EQ LAST 'E)))
		   ((EQ NEXT 'I)
		    (SETQ RD (CONS 'Y (CDDR RD))))
		   ((EQ NEXT 'X) (SETQ RD (CDR RD)))
		   ((AND (EQ NEXT 'H)
			 (NOT (EQ (CADDR RD) 'T)))
		    (SETQ RD (CDR RD)))
		   ((AND (MEMQ NEXT '(S Z))
			 (EQ NEXT (CADDR RD)))
		    (SETQ RD (CDDR RD))))
	TRY  (COND
	      ((OR
		(SETQ FEATURES
		      (GET (SETQ ROOT (READLIST (REVERSE RD)))
			   'FEATURES))
		(AND (SETQ X (GET ROOT 'IRREGULAR))
		     (SETQ FEATURES
			   (MOD (GET (SETQ ROOT (CAR X))
				     'FEATURES)
				(CDR X)))))
	       (BUILDWORD WRD
			  (MOD FEATURES (GET (CAR WORD) 'MOD))
			  (GET ROOT 'SEMANTICS)
			  ROOT))
	      ((EQ (CAR RD) 'E) (SETQ RD (CDR RD)) (GO TRY))
	      ((GO NO)))

	     ;;;----------------------------------------------------
	     ;;;  BUILD UP THE PROCESSED LIST OF WORDS TO BE RETURNED
	     ;;;----------------------------------------------------
	WRD  (SETQ 
	      SENT
	      (COND (POSS (COND ((OR (MEMQ 'NOUN
					   (SETQ FEATURES
						 (GET WRD
						      'FEATURES)))
								       ;IF IT'S A NOUN
				     (MEMQ 'PROPN FEATURES))
								       ;OR A PROPER NOUN
				 (BUILDWORD POSS
					    (APPEND (MEET FEATURES
								       ;MARK IT AS POSSESSIVE 
							  (GET 'POSS
							       'ELIM))
						    '(POSS))
					    (GET WRD
						 'SEMANTICS)
					    ROOT)
				 (CONS POSS SENT))
				((BUILDWORD '"S
								       ; CAN WE GENERALIZE IT???
					    '(VB BE V3PS PRES)
					    (GET 'BE
						 'SEMANTICS)
					    'BE)
				 (CONS '"S (CONS WRD SENT)))))
		    ((CONS WRD SENT))))
	PUNC (COND
	      (PUNCT (COND ((AND (EQ PUNCT '?) (NULL SENT))
			    (HELP)
			    (GO THRU))
			   ((MEMQ PUNCT FINAL)
			    (RETURN (CAR (SETQ SAVESENT
					       (CONS (REVERSE SENT)
								       ;RETURN POINT !!!!!!!!!!!!!
						     PUNCT)))))
			   ((SETQ SENT (CONS PUNCT SENT))))))
	     (SETQ PUNCT NIL)
	     (SETQ WORD (SETQ POSS NIL))
	     (GO CHAR)
	NO   (COND (NEWWORD (BUILDWORD WRD
				       '(NOUN NS)
				       '((NOUN (SMNEWNOUN))
					 (PROPN (SMNEWPROPN)))
				       WRD)
			    (OR ALTN (SETQ NEWWORD NIL))
			    (GO PUNC)))
	     (TERPRI)
	     (SAY *SORRY I DON/'T KNOW THE WORD ")
	     (PRINC WRD)
	     (PRINC '/ "/.)
	     (TERPRI)
(cond (define-online 
(terpri)
(say what are its syntactic features?)
(setq features (read))
(buildword wrd features 'dummy wrd)
(terpri)
(mapc '(lambda (w) (print2 w)) (reverse sent))
(print2 wrd)
(princ '/ )
(go char)
))
	     (SAY PLEASE TYPE <LF> AND CONTINUE THE SENTENCE/.)
	NOGO (OR (EQUAL (TYI) 10.) (GO NOGO))
	     (SETQ PUNCT NIL WORD NIL)
	     (GO DO)))


(defun build fexpr (foo)
 ;;;  this is a semantic function which packages
;;;  semantic nodes.
 t )

