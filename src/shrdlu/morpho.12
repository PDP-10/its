
(declare (genprefix morpho))


;;;********************************************************************************
;;;
;;;               MORPHO  - code for morphological analysis
;;;
;;;           includes ETAOIN, the input handler for the system
;;;
;;;********************************************************************************


(DEFUN ETAOIN NIL 
       (PROG (WORD NEWWORD CHAR ALTN ALREADY-BLGING-NEWWRD WRD LAST
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
	     (SAY PLEASE TYPE <LF> AND CONTINUE THE SENTENCE/.)
	NOGO (OR (EQUAL (TYI) 10.) (GO NOGO))
	     (SETQ PUNCT NIL WORD NIL)
	     (GO DO))) 

(DEFUN PROPNAME (X) (EQ (CAR (EXPLODE X)) '=)) 

(DEFUN BCWL FEXPR (A) 
								       ;DEFINES COMBINATIONS OF WORDS
       (MAPC 
	'(LAMBDA (X) 
	  (MAPC 
	   '(LAMBDA (Y) 
	     (BUILDWORD
	      (INTERN (MAKNAM (NCONC (EXPLODE (CAR X))
				     (CONS '-
					   (EXPLODE (CAR Y))))))
	      (CONS 'COMBINATION (CADR Y))
	      (CADDR Y)
	      (LIST (CAR X) (CAR Y))))
	   (CDR X)))
	A)
       T) 

(DEFUN BUILDWORD (WORD FEATURES SEMANTICS ROOT) 
       (PUTPROP WORD FEATURES 'FEATURES)
       (PUTPROP WORD (OR SMN SEMANTICS) 'SEMANTICS)
       (AND ROOT (PUTPROP WORD ROOT 'ROOT))
       WORD) 

(DEFUN BUILDWORDLIST FEXPR (A) 
								       ;DEFINES WORDS
       (MAPC '(LAMBDA (X) 
								       ;ROOT IS OPTIONAL
		      (PRINT (BUILDWORD (CAR X)
					(CADR X)
					(CADDR X)
					(AND (CDDDR X) (CADDDR X)))))
	     A)) 

(SETQ CARRET '/
) 

(DEFUN ETNEW NIL 
       (AND (EQ (CAR WORD) '")
	    (EQ (CAR (LAST WORD)) '")
	    (SETQ WRD (READLIST (CDR (REVERSE (CDR WORD)))))
	    (BUILDWORD WRD
		       '(NOUN NS)
		       '((NOUN (NEWWORD)))
		       NIL))) 

(SETQ FINAL '(/. ? !)) 

(SETQ CONSO '(B C D F G H J K L M N P Q R S T V W X Z)) 

0. 

(SETQ LIQUID '(L R S Z V)) 

(SETQ PUNCL '(/. ? : /; " !)) 

(SETQ RUBOUT (ASCII 127.)) 

(DEFPROP UNDEFINED
	 (LAMBDA NIL (PROG2 (PRINC (WORD N)) (ERT UNDEFINED)))
	 EXPR) 

(DEFUN UPPERCASE-IFY-CHAR (CHAR) (COND ((GREATERP 123. CHAR 96.) (- CHAR 32.)) (T CHAR)))


(SETQ VOWEL '(NIL A E I O U Y)) 

(SETQ SPACE '/ ) 
