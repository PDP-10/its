;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module float)

;; EXPERIMENTAL BIGFLOAT PACKAGE VERSION 2- USING BINARY MANTISSA 
;; AND POWER-OF-2 EXPONENT.  EXPONENTS MAY BE BIG NUMBERS NOW (AUG. 1975 --RJF)
;; Modified:	July 1979 by CWH to run on the Lisp Machine and to comment
;;              the code.
;;		August 1980 by CWH to run on Multics and to install
;;		new FIXFLOAT.
;;		December 1980 by JIM to fix BIGLSH not to pass LSH a second
;;		argument with magnitude greater than MACHINE-FIXNUM-PRECISION.

;; Number of bits of precision in a fixnum and in the fields of a flonum for
;; a particular machine.  These variables should only be around at eval
;; and compile time.  These variables should probably be set up in a prelude
;; file so they can be accessible to all Macsyma files.

#.(SETQ MACHINE-FIXNUM-PRECISION
	#+(OR PDP10 H6180)   36.
	#+LISPM		     24.
	#+NIL		     30.
	#+Franz		     32.

	MACHINE-MANTISSA-PRECISION
	#+(OR PDP10 H6180)   27.
	#+LISPM		     32.
	#+(OR NIL Franz)     56.

	;; Not used anymore, but keep it around anyway in case
	;; we need it later.

	MACHINE-EXPONENT-PRECISION
	#+(OR PDP10 H6180)    8.
	#+LISPM		     11.
	#+(OR NIL Franz)      8.
	)

;; External variables

(DEFMVAR $FLOAT2BF NIL
  "If TRUE, no error message is printed when a floating point number is
converted to a bigfloat number.")

(DEFMVAR $BFTORAT NIL
  "Controls the conversion of bigfloat numbers to rational numbers.  If
FALSE, RATEPSILON will be used to control the conversion (this results in
relatively small rational numbers).  If TRUE, the rational number generated
will accurately represent the bigfloat.")

(DEFMVAR $BFTRUNC T
  "Needs to be documented")

(DEFMVAR $FPPRINTPREC 0
  "Needs to be documented"
  FIXNUM)

(DEFMVAR $FPPREC 16.
  "Number of decimal digits of precision to use when creating new bigfloats.
One extra decimal digit in actual representation for rounding purposes.")

(DEFMVAR BIGFLOATZERO '((BIGFLOAT SIMP 56.) 0 0)
  "Bigfloat representation of 0" IN-CORE)
(DEFMVAR BIGFLOATONE  #-NIL '((BIGFLOAT SIMP 56.) #.(EXPT 2 55.) 1)
                      ;; DARN. Got to fix the NIL assembler to hack SQUIDS.
                      #+NIL `((BIGFLOAT SIMP 56.) ,(EXPT 2 55.) 1)
  "Bigfloat representation of 1" IN-CORE)
(DEFMVAR BFHALF	      #-NIL '((BIGFLOAT SIMP 56.) #.(EXPT 2 55.) 0)
                      #+NIL `((BIGFLOAT SIMP 56.) ,(EXPT 2 55.) 0)
  "Bigfloat representation of 1/2")
(DEFMVAR BFMHALF      #-NIL '((BIGFLOAT SIMP 56.) #.(MINUS (EXPT 2 55.)) 0)
                      #+NIL `((BIGFLOAT SIMP 56.) ,(MINUS (EXPT 2 55.)) 0)
  "Bigfloat representation of -1/2")
(DEFMVAR BIGFLOAT%E   #-NIL '((BIGFLOAT SIMP 56.) 48968212118944587. 2)
                      #+NIL `((BIGFLOAT SIMP 56.)
			      ,(SI:INTEGER-INPUT "48968212118944587.") 2)
  "Bigfloat representation of %E")
(DEFMVAR BIGFLOAT%PI  #-NIL '((BIGFLOAT SIMP 56.) 56593902016227522. 2)
                      #+NIL `((BIGFLOAT SIMP 56.)
			      ,(SI:INTEGER-INPUT "56593902016227522.") 2)
  "Bigfloat representation of %PI")

;; Internal specials

;; Number of bits of precision in the mantissa of newly created bigfloats. 
;; FPPREC = ($FPPREC+1)*(Log base 2 of 10)

(DEFVAR FPPREC)
(DECLARE (FIXNUM FPPREC))

;; FPROUND uses this to return a second value, i.e. it sets it before
;; returning.  This number represents the number of binary digits its input
;; bignum had to be shifted right to be aligned into the mantissa.  For
;; example, aligning 1 would mean shifting it FPPREC-1 places left, and
;; aligning 7 would mean shifting FPPREC-3 places left.

(DEFVAR *M)
(DECLARE (FIXNUM *M))

;; *DECFP = T if the computation is being done in decimal radix.  NIL implies
;; base 2.  Decimal radix is used only during output.

(DEFVAR *DECFP NIL)

(DEFVAR MAX-BFLOAT-%PI BIGFLOAT%PI)
(DEFVAR MAX-BFLOAT-%E  BIGFLOAT%E)

(DECLARE (SPECIAL *CANCELLED $FLOAT $BFLOAT $RATPRINT $RATEPSILON
		  $DOMAIN $M1PBRANCH ADJUST)
	 ;; *** Local fixnum declarations ***
	 ;; *** Be careful of this brain-damage ***
	 (FIXNUM I N EXTRADIGS)
	 (*EXPR $BFLOAT $FLOAT)
	 (MUZZLED T)) 

;; Representation of a Bigfloat:  ((BIGFLOAT SIMP precision) mantissa exponent)
;; precision -- number of bits of precision in the mantissa.  
;; 		precision = (haulong mantissa)
;; mantissa -- a signed integer representing a fractional portion computed by
;; 	       fraction = (// mantissa (^ 2 precision)).
;; exponent -- a signed integer representing the scale of the number.
;; 	       The actual number represented is (* fraction (^ 2 exponent)).

(DEFUN HIPART (X NN) (COND ((BIGP NN) (ABS X)) (T (HAIPART X NN))))

(DEFUN FPPREC1 (ASSIGN-VAR Q) 
      ASSIGN-VAR ; ignored
      (IF (OR (NOT (EQ (TYPEP Q) 'FIXNUM)) (< Q 1))
	  (MERROR "Improper value for FPPREC:~%~M" Q))
      (SETQ FPPREC (+ 2 (HAULONG (EXPT 10. Q)))
	    BIGFLOATONE ($BFLOAT 1) BIGFLOATZERO ($BFLOAT 0)
	    BFHALF (LIST (CAR BIGFLOATONE) (CADR BIGFLOATONE) 0)
	    BFMHALF (LIST (CAR BIGFLOATONE) (MINUS (CADR BIGFLOATONE)) 0))
      Q) 

;; FPSCAN is called by lexical scan when a
;; bigfloat is encountered.  For example, 12.01B-3
;; would be the result of (FPSCAN '(/1 /2) '(/0 /1) '(/- /3))
;; Arguments to FPSCAN are a list of characters to the left of the
;; decimal point, to the right of the decimal point, and in the exponent.

(DEFUN FPSCAN (LFT RT EXP &AUX (IBASE 10.))
       (SETQ EXP (READLIST EXP))
       ;; Log[2](10) is 3.3219 ...
       ;; This should be computed at compile time.
       (BIGFLOATP
	(LET ((FPPREC (PLUS 4 FPPREC (HAULONG EXP)
			    (FIX (ADD1 (TIMES 3.322 (LENGTH LFT))))))
	      $FLOAT TEMP)
	     (SETQ TEMP (ADD (READLIST LFT)
			     (DIV (READLIST RT) (EXPT 10. (LENGTH RT)))))
	     ($BFLOAT (COND ((GREATERP (ABS EXP) 1000.)
			     (CONS '(MTIMES) (LIST TEMP (LIST '(MEXPT) 10. EXP))))
			    (T (MUL2 TEMP (POWER 10. EXP))))))))

(DEFUN DIM-BIGFLOAT (FORM RESULT) (DIMENSION-ATOM (MAKNAM (FPFORMAT FORM)) RESULT))

(DEFUN FPFORMAT (L)
 (IF (NOT (MEMQ 'SIMP (CDAR L)))
     (SETQ L (CONS (CONS (CAAR L) (CONS 'SIMP (CDAR L))) (CDR L))))
 (COND ((EQUAL (CADR L) 0)
	(IF (NOT (EQUAL (CADDR L) 0))
	    (MTELL "Warning - an incorrect form for 0.0B0 has been generated."))
        (LIST '/0 '/. '/0 'B '/0))
 (T   ;; L IS ALWAYS POSITIVE FP NUMBER
  (LET ((EXTRADIGS (FIX (ADD1 (QUOTIENT (HAULONG (CADDR L)) 3.32))))) 
       (SETQ L
	     ((LAMBDA (*DECFP FPPREC OF L EXPON)
		      (SETQ EXPON (DIFFERENCE (CADR L) OF))
		      (SETQ L
			    (COND ((MINUSP EXPON)
				   (FPQUOTIENT (INTOFP (CAR L))
					       (FPINTEXPT 2 (MINUS expon) OF)))
				  (T (FPTIMES* (INTOFP (CAR L))
					       (FPINTEXPT 2 expon OF)))))
		      (SETQ FPPREC (PLUS (MINUS EXTRADIGS) FPPREC))
		      (LIST (FPROUND (CAR L))
			    (PLUS (MINUS EXTRADIGS) *M (CADR L))))
	       T
	       (PLUS EXTRADIGS (DECIMALSIN (DIFFERENCE (CADDAR L) 2)))
	       (CADDAR L)
	       (CDR L)
	       NIL)))
      ((LAMBDA (BASE *NOPOINT L1)
	(SETQ L1 (COND ((NOT $BFTRUNC) (EXPLODEC (CAR L)))
		    (T (DO ((L (NREVERSE (EXPLODEC (CAR L))) (CDR L)))
			   ((NOT (EQ '/0 (CAR L))) (NREVERSE L))))))
	(NCONC (NCONS (CAR L1)) (NCONS '/.)
	       (OR (AND (CDR L1)
			(COND ((OR (ZEROP $FPPRINTPREC)
				   (NOT (< $FPPRINTPREC $FPPREC))
				   (NULL (CDDR L1)))
			       (CDR L1))
			      (T (SETQ L1 (CDR L1))
				 (DO ((I $FPPRINTPREC (1- I)) (L2))
				     ((OR (< I 2) (NULL (CDR L1)))
				      (COND ((NOT $BFTRUNC) (NREVERSE L2))
					    (T (DO ((L3 L2 (CDR L3)))
						   ((NOT (EQ '/0 (CAR L3)))
						    (NREVERSE L3))))))
				     (SETQ L2 (CONS (CAR L1) L2) L1 (CDR L1))))))
		   (NCONS '/0))
	       (NCONS 'B)
	       (EXPLODEC (SUB1 (CADR L)))))
  10. T NIL))))

(DEFUN BIGFLOATP (X) 
 (PROG NIL
       (COND ((NOT ($BFLOATP X)) (RETURN NIL))
	     ((= FPPREC (CADDAR X)) (RETURN X))
	     ((> FPPREC (CADDAR X))
	      (SETQ X (BCONS (LIST (FPSHIFT (CADR X) (DIFFERENCE FPPREC (CADDAR X)))
				   (CADDR X)))))
	     (T (SETQ X (BCONS (LIST (FPROUND (CADR X))
				     (PLUS (CADDR X) *M FPPREC (MINUS (CADDAR X))))))))
       (RETURN (COND ((EQUAL (CADR X) 0) (BCONS (LIST 0 0))) (T X))))) 

(DEFUN BIGFLOAT2RAT (X)
 (SETQ X (BIGFLOATP X))
 ((LAMBDA ($FLOAT2BF EXP Y SIGN) 
   (SETQ EXP (COND ((MINUSP (CADR X))
		    (SETQ SIGN T Y (FPRATION1 (CONS (CAR X) (FPABS (CDR X)))))
		    (RPLACA Y (TIMES -1 (CAR Y))))
		   (T (FPRATION1 X))))
   (COND ($RATPRINT (PRINC "RAT replaced ")
		    (COND (SIGN (PRINC "-")))
		    (PRINC (MAKNAM (FPFORMAT (CONS (CAR X) (FPABS (CDR X))))))
		    (PRINC " by ") (PRINC (CAR EXP)) (TYO #//) (PRINC (CDR EXP))
		    (PRINC " = ") (SETQ X ($BFLOAT (LIST '(RAT SIMP) (CAR EXP) (CDR EXP))))
		    (COND (SIGN (PRINC "-")))
		    (PRINC (MAKNAM (FPFORMAT (CONS (CAR X) (FPABS (CDR X))))))
		    (TERPRI)))
   EXP) 
  T NIL NIL NIL))

(DEFUN FPRATION1 (X)
 ((LAMBDA (FPRATEPS)
       (OR (AND (EQUAL X BIGFLOATZERO) (CONS 0 1))
	   (PROG (Y A)
		 (RETURN (DO ((XX X (SETQ Y (INVERTBIGFLOAT
					     (BCONS (FPDIFFERENCE (CDR XX) (CDR ($BFLOAT A)))))))
			      (NUM (SETQ A (FPENTIER X))
				   (PLUS (TIMES (SETQ A (FPENTIER Y)) NUM) ONUM))
			      (DEN 1 (PLUS (TIMES A DEN) ODEN))
			      (ONUM 1 NUM)
			      (ODEN 0 DEN))
			     ((AND (NOT (ZEROP DEN))
				   (NOT (FPGREATERP
					 (FPABS (FPQUOTIENT
						    (FPDIFFERENCE (CDR X)
								  (FPQUOTIENT (CDR ($BFLOAT NUM))
									      (CDR ($BFLOAT DEN))))
						    (CDR X)))
						FPRATEPS)))
			      (CONS NUM DEN)))))))
  (CDR ($BFLOAT (COND ($BFTORAT (LIST '(RAT SIMP) 1 (EXPTRL 2 (1- FPPREC))))
		      (T $RATEPSILON))))))

;; Convert a floating point number into a bigfloat.
(DEFUN FLOATTOFP (X) 
       (UNLESS $FLOAT2BF
	       (MTELL "Warning:  Float to bigfloat conversion of ~S~%" X))
       (SETQ X (FIXFLOAT X))
       (FPQUOTIENT (INTOFP (CAR X)) (INTOFP (CDR X))))

;; Convert a bigfloat into a floating point number.
(DEFMFUN FP2FLO (L)
  (LET ((PRECISION (CADDAR L))
	(MANTISSA (CADR L))
	(EXPONENT (CADDR L))
	(FPPREC #.MACHINE-MANTISSA-PRECISION)
	(*M 0))
    ;;Round the mantissa to the number of bits of precision of the machine,
    ;;and then convert it to a floating point fraction.
    (SETQ MANTISSA (QUOTIENT (FPROUND MANTISSA)
			     #.(EXPT 2.0 MACHINE-MANTISSA-PRECISION)))
    ;;Multiply the mantissa by the exponent portion.  I'm not sure
    ;;why the exponent computation is so complicated.
    (SETQ PRECISION
	  (ERRSET (TIMES MANTISSA (EXPT 2.0 (+ EXPONENT (MINUS PRECISION) *M
					       #.MACHINE-MANTISSA-PRECISION))) NIL))
    (IF PRECISION
	(CAR PRECISION)
	(MERROR "Floating point overflow in converting ~:M to flonum" L))))

;; New machine-independent version of FIXFLOAT.  This may be buggy. - CWH
;; It is buggy!  On the PDP10 it dies on (RATIONALIZE -1.16066076E-7) 
;; which calls FLOAT on some rather big numbers.  ($RATEPSILON is approx. 
;; 7.45E-9) - JPG

#-PDP10 (DEFUN FIXFLOAT (X)
  (LET (($RATEPSILON #.(EXPT 2.0 (- MACHINE-MANTISSA-PRECISION))))
       (RATIONALIZE X)))

;; Takes a flonum arg and returns a rational number corresponding to the flonum
;; in the form of a dotted pair of two integers.  Since the denominator will
;; always be a positive power of 2, this number will not always be in lowest
;; terms.

;; PDP-10 Floating Point number format:
;; 1 bit sign -- 0 = negative 1 = positive
;; 8 bit exponent -- If positive, excess 128 encoding used, i.e.
;;   -128 exponent = 0 and +127 exponent = 255.  If number is negative,
;;   ones complement of excess 128 is used.  This is done so that the
;;   representation of the negation of a floating point number is the twos
;;   complement of the number interpreted as an integer.  If x is the number in
;;   the 8 bit field, x-128 will yield the exponent if the sign bit is off, and
;;   127-x will yield the exponent if the sign bit is on.
;; 27 bit fraction -- If the number is normalized, this fraction will be
;;   between 1/2 and 1-2^-27 inclusive, i.e. the msb of the fraction will
;;   always be 1.  The fraction is stored in two's complement so the most
;;   negative flonum is (fsc (rot 3 -1) 0) and the most positive flonum is
;;   (fsc (lsh -1 -1) 0).

;; Old definition which explicitly hacks floating point representations.
#+PDP10 (PROGN 'COMPILE
  (DECLARE (CLOSED T))
  (DEFUN FIXFLOAT (X) 
 	(PROG (NEG NUM EXPONENT DENOM) 
 	      (COND ((LESSP X 0.0) (SETQ NEG -1.) (SETQ X (MINUS X))))
 	      (SETQ X (LSH X 0))
 	      (SETQ EXPONENT (DIFFERENCE (LSH X -27.) 129.))
 	      (SETQ NUM (LSH (LSH X 9.) -9.))
 	      (SETQ DENOM 1_26.)		;(^ 2 26)
 	      (COND ((LESSP EXPONENT 0)
 		     (SETQ DENOM (TIMES DENOM (EXPT 2 (MINUS EXPONENT)))))
 		    (T (SETQ NUM (TIMES NUM (EXPT 2 EXPONENT)))))
 	      (IF NEG (SETQ NUM (MINUS NUM)))
 	      (RETURN (CONS NUM DENOM)))) 
  (DECLARE (CLOSED NIL))
 )

;; Format of a floating point number on the Lisp Machine:
;; 
;; High 8 bits of mantissa (plus sign bit) ---------\
;; Exponent (excess 1024) --------------\           |
;; Type of extended number --\          |           |
;; DTP-HEADER (7) ---\       |          |           |
;; Not used --\      |       |          |           |
;;            |      |       |          |           |
;;         ------------------------------------------------
;;         |  3  |   5   |   5   |     11     |     8     |
;;         ------------------------------------------------
;;         ------------------------------------------------
;;         |  3  |   5   |             24                 |
;;         ------------------------------------------------
;;            |      |                  |
;; Not used --/      |                  |
;; DTP-FIX (5) ------/                  |
;; Low 24 bits of mantissa -------------/

;; #+LISPM
;; (DEFUN FIXFLOAT (X)
;;   (LET ((EXPONENT (- (%P-LDB-OFFSET #O 1013 X 0) #O 2000))
;; 	(NUM (%P-LDB-OFFSET #O 0010 X 0))
;; 	(DENOM 1_31.))
;;     ;;Extract the high portion of the mantissa and left justify it within
;;     ;;a fixnum.
;;     (SETQ NUM (LSH NUM 16.))
;;     ;;Then extract the high 16 bits of the low portion of the mantissa and
;;     ;;store into the fixnum.
;;     (SETQ NUM (LOGIOR NUM (%P-LDB-OFFSET #O 1020 X 1)))
;;     ;;Finally, convert what we've got into a bignum by shifting left by
;;     ;;8 bits and add in low 8 bits of the low portion of the mantissa.
;;     (SETQ NUM (LOGIOR (* NUM 1_8) (%P-LDB-OFFSET #O 0010 X 1)))
;;     (COND ((< EXPONENT 0)
;; 	   (SETQ DENOM (* DENOM (^ 2 (- EXPONENT)))))
;; 	  (T (SETQ NUM (* NUM (^ 2 EXPONENT)))))
;;     (CONS NUM DENOM)))

;; The format of a floating point number on the H6180 is very similar
;; to that on the PDP-10.  There are 8 bits of exponent, 1 bit of sign,
;; and 27 bits of mantissa in that order.  The exponent is stored
;; in twos complement, and the low order 28 bits are the mantissa
;; in twos complement.

;; #+H6180
;; (DEFUN FIXFLOAT (X) 
;;       (PROG (NEG NUM EXPONENT DENOM) 
;; 	     (COND ((LESSP X 0.0) (SETQ NEG -1.) (SETQ X (-$ X))))
;; 	     (SETQ X (LSH X 0))
;; 	     (SETQ EXPONENT (LSH X -28.))
;; 	     (AND (> EXPONENT 177) (SETQ EXPONENT (DIFFERENCE EXPONENT 400)))
;; 	     (SETQ NUM (BOOLE 1 X 1777777777))	;2^29-1
;; 	     (SETQ DENOM
;; 		   (TIMES 1000000000	;2^27
;; 			  (COND ((LESSP EXPONENT 0)
;; 				 (EXPT 2 (MINUS EXPONENT)))
;; 				(T (SETQ NUM
;; 					 (TIMES NUM
;; 						(EXPT 2 EXPONENT)))
;; 				   1))))
;; 	     (COND ((NULL NEG)) (T (SETQ NUM (MINUS NUM))))
;; 	     (RETURN (CONS NUM DENOM)))) 

(DEFUN BCONS (S) `((BIGFLOAT SIMP ,FPPREC) . ,S)) 

(DEFMFUN $BFLOAT (X) 
 (LET (Y)
   (COND ((BIGFLOATP X))
	 ((OR (NUMBERP X) (MEMQ X '($%E $%PI)))
	  (BCONS (INTOFP X)))
	 ((OR (ATOM X) (MEMQ 'ARRAY (CDAR X)))
	  (COND ((EQ X '$%PHI)
		 ($BFLOAT '((MTIMES SIMP) ((RAT SIMP) 1 2)
			    ((MPLUS SIMP) 1 ((MEXPT SIMP) 5 ((RAT SIMP) 1 2))))))
	        (T X)))
	 ((EQ (CAAR X) 'MEXPT)
	  (COND ((EQUAL (CADR X) '$%E) (*FPEXP (CADDR X)))
		(T (EXPTBIGFLOAT ($BFLOAT (CADR X)) (CADDR X)))))
	 ((EQ (CAAR X) 'MNCEXPT)
	  (LIST '(MNCEXPT) ($BFLOAT (CADR X)) (CADDR X)))
	 ((SETQ Y (GET (CAAR X) 'FLOATPROG)) (FUNCALL Y (MAPCAR '$BFLOAT (CDR X))))
	 ((OR (TRIGP (CAAR X)) (ARCP (CAAR X)) (EQ (CAAR X) '$ENTIER))
	  (SETQ Y ($BFLOAT (CADR X)))
	  (COND (($BFLOATP Y)
		 (COND ((EQ (CAAR X) '$ENTIER) ($ENTIER Y))
		       ((ARCP (CAAR X))
			(SETQ Y ($BFLOAT (LOGARC (CAAR X) Y)))
			(COND ((FREE Y '$%I) Y) (T (LET ($RATPRINT) ($RECTFORM Y)))))
		       ((MEMQ (CAAR X) '(%COT %SEC %CSC))
			(INVERTBIGFLOAT
			 ($BFLOAT (LIST (NCONS (GET (CAAR X) 'RECIP)) Y))))
		       (T ($BFLOAT (EXPONENTIALIZE (CAAR X) Y)))))
		(T (SUBST0 (LIST (NCONS (CAAR X)) Y) X))))
	 (T (RECUR-APPLY #'$BFLOAT X))))) 

(DEFPROP MPLUS ADDBIGFLOAT FLOATPROG)
(DEFPROP MTIMES TIMESBIGFLOAT FLOATPROG)
(DEFPROP %SIN SINBIGFLOAT FLOATPROG)
(DEFPROP %COS COSBIGFLOAT FLOATPROG)
(DEFPROP RAT RATBIGFLOAT FLOATPROG)
(DEFPROP %ATAN ATANBIGFLOAT FLOATPROG)
(DEFPROP %TAN TANBIGFLOAT FLOATPROG)
(DEFPROP %LOG LOGBIGFLOAT FLOATPROG)
(DEFPROP MABS MABSBIGFLOAT FLOATPROG)

(DEFMFUN ADDBIGFLOAT (H)
       (PROG (FANS TST R NFANS)
	     (SETQ FANS (SETQ TST BIGFLOATZERO) NFANS 0)
	     (DO L H (CDR L) (NULL L)
		 (COND ((SETQ R (BIGFLOATP (CAR L)))
			(SETQ FANS (BCONS (FPPLUS (CDR R) (CDR FANS)))))
		       (T (SETQ NFANS (LIST '(MPLUS) (CAR L) NFANS)))))
	     (RETURN (COND ((EQUAL NFANS 0) FANS)
			   ((EQUAL FANS TST) NFANS)
			   (T (SIMPLIFY (LIST '(MPLUS) FANS NFANS))))))) 

(DEFMFUN RATBIGFLOAT (L) (BCONS (FPQUOTIENT (CDAR L) (CDADR L)))) 

(DEFUN DECIMALSIN (X) 
 (DO I (QUOTIENT (TIMES 59. X) 196.)	;log[10](2)=.301029
     (1+ I) NIL (IF (> (HAULONG (EXPT 10. I)) X) (RETURN (1- I))))) 

(DEFMFUN ATANBIGFLOAT (X) (*FPATAN (CAR X) (CDR X))) 

(DEFMFUN *FPATAN (A Y) 
 (FPEND (LET ((FPPREC (PLUS 8. FPPREC)))
	     (IF (NULL Y)
		 (IF ($BFLOATP A) (FPATAN (CDR ($BFLOAT A)))
				  (LIST '(%ATAN) A))
		 (FPATAN2 (CDR ($BFLOAT A))
			  (CDR ($BFLOAT (CAR Y))))))))

(DEFUN FPATAN (X)
       (PROG (TERM X2 ANS OANS ONE TWO TMP)
	     (SETQ ONE (INTOFP 1) TWO (INTOFP 2))
	     (COND ((FPGREATERP (FPABS X) ONE)
		    (SETQ TMP (FPQUOTIENT (FPPI) TWO))
		    (SETQ ANS (FPDIFFERENCE TMP (FPATAN (FPQUOTIENT ONE X))))
		    (RETURN (COND ((FPGREATERP ANS TMP) (FPDIFFERENCE ANS (FPPI)))
				  (T ANS))))
		   ((FPGREATERP (FPABS X) (FPQUOTIENT ONE TWO))
		    (SETQ TMP (FPQUOTIENT X (FPPLUS (FPTIMES* X X) ONE)))
		    (SETQ X2 (FPTIMES* X TMP) TERM (SETQ ANS ONE))
		    (DO N 0 (1+ N) (EQUAL ANS OANS)
			(SETQ TERM
			      (FPTIMES* TERM (FPTIMES* X2 (FPQUOTIENT
							   (INTOFP (+ 2 (* 2 N)))
						           (INTOFP (+ (* 2 N) 3))))))
			(SETQ OANS ANS ANS (FPPLUS TERM ANS)))
		    (SETQ ANS (FPTIMES* TMP ANS)))
		   (T (SETQ ANS X X2 (FPMINUS (FPTIMES* X X)) TERM X)
		      (DO N 3 (+ N 2) (EQUAL ANS OANS)
			  (SETQ TERM (FPTIMES* TERM X2))
			  (SETQ OANS ANS 
			        ANS (FPPLUS ANS (FPQUOTIENT TERM (INTOFP N)))))))
	     (RETURN ANS)))

(DEFUN FPATAN2 (Y X) ; ATAN(Y/X) from -PI to PI
       (COND ((EQUAL (CAR X) 0)       ; ATAN(INF), but what sign?
	      (COND ((EQUAL (CAR Y) 0) (MERROR "ATAN(0//0) has been generated."))
		    ((MINUSP (CAR Y))
		     (FPQUOTIENT (FPPI) (INTOFP -2)))
		    (T (FPQUOTIENT (FPPI) (INTOFP 2)))))
	     ((SIGNP G (CAR X))
	      (COND ((SIGNP G (CAR Y)) (FPATAN (FPQUOTIENT Y X)))
		    (T (FPMINUS (FPATAN (FPQUOTIENT Y X))))))
	     ((SIGNP G (CAR Y))
	      (FPPLUS (FPPI) (FPATAN (FPQUOTIENT Y  X))))
	     (T (FPDIFFERENCE (FPATAN (FPQUOTIENT Y X)) (FPPI))))) 

(DEFUN TANBIGFLOAT (A)
 (SETQ A (CAR A)) 
 (FPEND (LET ((FPPREC (PLUS 8. FPPREC)))
	     (COND (($BFLOATP A)
		    (SETQ A (CDR ($BFLOAT A)))
		    (FPQUOTIENT (FPSIN A T) (FPSIN A NIL)))
		   (T (LIST '(%TAN) A))))))	 

;; Returns a list of a mantissa and an exponent.
(DEFUN INTOFP (L) 
       (COND ((NOT (ATOM L)) ($BFLOAT L))
	     ((FLOATP L) (FLOATTOFP L))
	     ((EQUAL 0 L) '(0 0))
	     ((EQ L '$%PI) (FPPI))
	     ((EQ L '$%E) (FPE))
	     (T (LIST (FPROUND L) (PLUS *M FPPREC))))) 

;; It seems to me that this function gets called on an integer
;; and returns the mantissa portion of the mantissa/exponent pair.

;; "STICKY BIT" CALCULATION FIXED 10/14/75 --RJF
;; BASE must not get temporarily bound to NIL by being placed
;; in a PROG list as this will confuse stepping programs.

(DEFUN FPROUND (L &AUX (BASE 10.) (*NOPOINT T))
  (PROG () 
	(COND
	 ((NULL *DECFP)
	  ;;*M will be positive if the precision of the argument is greater than
	  ;;the current precision being used.
	  (SETQ *M (- (HAULONG L) FPPREC))
	  (COND ((= *M 0) (SETQ *CANCELLED 0) (RETURN L)))
	  ;;FPSHIFT is essentially LSH.
	  (SETQ ADJUST (FPSHIFT 1 (SUB1 *M)))
	  (COND ((MINUSP L) (SETQ ADJUST (MINUS ADJUST))))
	  (SETQ L (PLUS L ADJUST))
	  (SETQ *M (- (HAULONG L) FPPREC))
	  (SETQ *CANCELLED (ABS *M))
	     
	  (COND ((SIGNP E (HIPART L (MINUS *M)))	;ONLY ZEROES SHIFTED OFF
		 (RETURN (FPSHIFT (FPSHIFT L (DIFFERENCE -1 *M))
				  1)))			; ROUND TO MAKE EVEN
		(T (RETURN (FPSHIFT L (MINUS *M))))))
	 (T
	  (SETQ *M (DIFFERENCE (FLATSIZE (ABS L)) FPPREC))
	  (SETQ ADJUST (FPSHIFT 1 (SUB1 *M)))
	  (COND ((MINUSP L) (SETQ ADJUST (MINUS ADJUST))))
	  (SETQ ADJUST (TIMES 5 ADJUST))
	  (SETQ *M
		(DIFFERENCE (FLATSIZE (ABS (SETQ L (PLUS L ADJUST))))
			    FPPREC))
	  (RETURN (FPSHIFT L (MINUS *M)))))))

(DEFUN FPSHIFT (L N) 
       (COND ((NULL *DECFP) (BIGLSH L N))
	     ((GREATERP N 0.) (TIMES L (EXPT 10. N)))
	     ((LESSP N 0.) (QUOTIENT L (EXPT 10. (MINUS N))))
	     (T L))) 

;; Bignum LSH -- N is assumed (and declared above) to be a fixnum.
;; This isn't really LSH, since the sign bit isn't propagated when
;; shifting to the right, i.e. (BIGLSH -100 -3) = -40, whereas
;; (LSH -100 -3) = 777777777770 (on a 36 bit machine).
;; This actually computes (TIMES X (EXPT 2 N)).  As of 12/21/80, this function
;; was only called by FPSHIFT.  I would like to hear an argument as why this
;; is more efficient than simply writing (TIMES X (EXPT 2 N)).  Is the
;; intermediate result created by (EXPT 2 N) the problem?  I assume that
;; EXPT tries to LSH when possible.

(DEFUN BIGLSH (X N)
  (COND
   ;; In MacLisp, the result is undefined if the magnitude of the
   ;; second argument is greater than 36.
   ((AND (NOT (BIGP X))
	 (< N #.(- MACHINE-FIXNUM-PRECISION))) 0)
   ;; Either we are shifting a fixnum to the right, or shifting
   ;; a fixnum to the left, but not far enough left for it to become
   ;; a bignum.
   ((AND (NOT (BIGP X)) 
	 (OR (<= N 0)
	     (< (PLUS (HAULONG X) N) #.MACHINE-FIXNUM-PRECISION)))
    ;; The form which follows is nearly identical to (ASH X N), however
    ;; (ASH -100 -20) = -1, whereas (BIGLSH -100 -20) = 0.
    (IF (> X 0)
	(LSH X N)
	(- (LSH (- X) N))))
   ;; If we get here, then either X is a bignum or our answer is
   ;; going to be a bignum.
   ((< N 0)
    (COND ((> (ABS N) (HAULONG X)) 0)
	  ((GREATERP X 0)
	   (HIPART X (PLUS (HAULONG X) N)))
	  (T (MINUS (HIPART X (PLUS (HAULONG X) N))))))
   ((= N 0) X)
   ;; Isn't this the kind of optimization that compilers are
   ;; supposed to make?
   ((< N #.(1- MACHINE-FIXNUM-PRECISION)) (TIMES X (LSH 1 N)))
   (T (TIMES X (EXPT 2 N)))))


(DEFUN FPEXP (X)       
  (PROG (R S)
	(IF (NOT (SIGNP GE (CAR X)))
	    (RETURN (FPQUOTIENT (FPONE) (FPEXP (FPABS X)))))
	(SETQ R (FPINTPART X))
	(RETURN (COND ((LESSP R 2) (FPEXP1 X))
		      (T (SETQ S (FPEXP1 (FPDIFFERENCE X (INTOFP R))))
			 (FPTIMES* S
				   (CDR (BIGFLOATP
					 ((LAMBDA (FPPREC R) (BCONS (FPEXPT (FPE) R)))	; patch for full precision %E
					  (PLUS FPPREC (HAULONG R) -1)
					  R)))))))))

(DEFUN FPEXP1 (X) 
       (PROG (TERM ANS OANS) 
	     (SETQ ANS (SETQ TERM (FPONE)))
	     (DO N
		 1.
		 (ADD1 N)
		 (EQUAL ANS OANS)
		 (SETQ TERM (FPQUOTIENT (FPTIMES* X TERM) (INTOFP N)))
		 (SETQ OANS ANS)
		 (SETQ ANS (FPPLUS ANS TERM)))
	     (RETURN ANS))) 

;; Does one higher precision to round correctly.
;; A and B are each a list of a mantissa and an exponent.
(DEFUN FPQUOTIENT (A B) 
       (COND ((EQUAL (CAR B) 0)
	      (MERROR "PQUOTIENT by zero"))
	     ((EQUAL (CAR A) 0) '(0 0))
	     (T (LIST (FPROUND (QUOTIENT (FPSHIFT (CAR A)
						  (PLUS 3 FPPREC))
					 (CAR B)))
		      (PLUS -3 (DIFFERENCE (CADR A) (CADR B)) *M))))) 

(DEFUN FPGREATERP (A B) (FPPOSP (FPDIFFERENCE A B))) 

(DEFUN FPLESSP (A B) (FPPOSP (FPDIFFERENCE B A))) 

(DEFUN FPPOSP (X) (GREATERP (CAR X) 0)) 

(DEFUN FPMIN NA
 (PROG (MIN) 
	  (SETQ MIN (ARG 1))
	  (DO I 2 (1+ I) (> I NA)
	      (IF (FPLESSP (ARG I) MIN) (SETQ MIN (ARG I))))
	  (RETURN MIN)))

;; (FPE) RETURN BIG FLOATING POINT %E.  IT RETURNS (CDR BIGFLOAT%E) IF RIGHT
;; PRECISION.  IT RETURNS TRUNCATED BIGFLOAT%E IF POSSIBLE, ELSE RECOMPUTES.
;; IN ANY CASE, BIGFLOAT%E IS SET TO LAST USED VALUE. 

(DEFUN FPE NIL
       (COND ((= FPPREC (CADDAR BIGFLOAT%E)) (CDR BIGFLOAT%E))
	     ((< FPPREC (CADDAR BIGFLOAT%E))
	      (CDR (SETQ BIGFLOAT%E (BIGFLOATP BIGFLOAT%E))))
	     ((< FPPREC (CADDAR MAX-BFLOAT-%E))
	      (CDR (SETQ BIGFLOAT%E (BIGFLOATP MAX-BFLOAT-%E))))
	     (T (CDR (SETQ MAX-BFLOAT-%E (SETQ BIGFLOAT%E (*FPEXP 1)))))))

(DEFUN FPPI NIL
       (COND ((= FPPREC (CADDAR BIGFLOAT%PI)) (CDR BIGFLOAT%PI))
	     ((< FPPREC (CADDAR BIGFLOAT%PI))
	      (CDR (SETQ BIGFLOAT%PI (BIGFLOATP BIGFLOAT%PI))))
	     ((< FPPREC (CADDAR MAX-BFLOAT-%PI))
	      (CDR (SETQ BIGFLOAT%PI (BIGFLOATP MAX-BFLOAT-%PI))))
	     (T (CDR (SETQ MAX-BFLOAT-%PI (SETQ BIGFLOAT%PI (FPPI1)))))))

(DEFUN FPONE NIL 
       (COND (*DECFP (INTOFP 1)) ((= FPPREC (CADDAR BIGFLOATONE)) (CDR BIGFLOATONE))
	     (T (INTOFP 1)))) 

;; COMPPI computes PI to N bits.
;; That is, (COMPPI N)/(2.0^N) is an approximation to PI.

(DEFUN COMPPI (N) 
       (PROG (A B C) 
	     (SETQ A (EXPT 2 N))
	     (SETQ C (PLUS (TIMES 3 A) (SETQ B (*QUO A 8.))))
 	     (DO I 4 (+ I 2)
		 (ZEROP B)
		 (SETQ B (*QUO (TIMES B (1- I) (1- I))
			       (TIMES 4 I (1+ I))))
		 (SETQ C (PLUS C B)))
	     (RETURN C))) 

(DEFUN FPPI1 NIL 
       (BCONS (LIST (FPROUND (COMPPI (PLUS FPPREC 3))) (PLUS -3 *M)))) 

(DEFUN FPMAX NA
 (PROG (MAX) 
	  (SETQ MAX (ARG 1))
	  (DO I 2 (1+ I) (> I NA)
	      (IF (FPGREATERP (ARG I) MAX) (SETQ MAX (ARG I))))
	  (RETURN MAX)))

(DEFUN FPDIFFERENCE (A B) (FPPLUS A (FPMINUS B))) 

(DEFUN FPMINUS (X) (IF (EQUAL (CAR X) 0) X (LIST (MINUS (CAR X)) (CADR X)))) 

(DEFUN FPPLUS (A B) 
       (PROG (*M EXP MAN STICKY) 
	     (SETQ *CANCELLED 0)
	(COND ((EQUAL (CAR A) 0) (RETURN B))
	      ((EQUAL (CAR B) 0) (RETURN A)))
	(SETQ EXP (DIFFERENCE (CADR A) (CADR B)))
	(SETQ MAN (COND ((EQUAL EXP 0)
			  (SETQ STICKY 0)
			  (FPSHIFT (PLUS (CAR A) (CAR B)) 2))
			 ((GREATERP EXP 0)
			  (SETQ STICKY (HIPART (CAR B) (DIFFERENCE 1 EXP)))
			  (SETQ STICKY (COND ((SIGNP E STICKY) 0)
					     ((SIGNP L (CAR B)) -1)
					     (T 1)))
								       ; COMPUTE STICKY BIT
			  (PLUS (FPSHIFT (CAR A) 2)
								       ; MAKE ROOM FOR GUARD DIGIT & STICKY BIT
				(FPSHIFT (CAR B) (DIFFERENCE 2 EXP))))
			 (T (SETQ STICKY (HIPART (CAR A) (ADD1 EXP)))
			    (SETQ STICKY (COND ((SIGNP E STICKY) 0)
					       ((SIGNP L (CAR A)) -1)
					       (T 1)))
			    (PLUS (FPSHIFT (CAR B) 2)
				  (FPSHIFT (CAR A) (PLUS 2 EXP))))))
	     (SETQ MAN (PLUS MAN STICKY))
	     (RETURN (COND ((EQUAL MAN 0) '(0 0))
			   (T (SETQ MAN (FPROUND MAN))
			      (SETQ EXP
				    (PLUS -2 *M (MAX (CADR A) (CADR B))))
			      (LIST MAN EXP)))))) 

(DEFUN FPTIMES* (A B) 
       (COND ((OR (EQUAL (CAR A) 0) (EQUAL (CAR B) 0)) '(0 0))
	     (T (LIST (FPROUND (TIMES (CAR A) (CAR B)))
		      (PLUS *M (CADR A) (CADR B) (MINUS FPPREC)))))) 

;; Don't use the symbol BASE since it is SPECIAL.

(DEFUN FPINTEXPT (INT NN FIXPREC)			;INT is integer
       (SETQ FIXPREC (QUOTIENT FIXPREC (LOG2 INT)))	;NN is pos
       (LET ((BAS (INTOFP (EXPT INT (MIN NN FIXPREC))))) 
	    (COND ((GREATERP NN FIXPREC)
		   (FPTIMES* (INTOFP (EXPT INT (REMAINDER NN FIXPREC)))
			     (FPEXPT BAS (QUOTIENT NN FIXPREC))))
		  (T BAS))))

;; NN is positive or negative integer

(DEFUN FPEXPT (P NN) 
       (COND ((EQUAL NN 0.) (FPONE))
	     ((EQUAL NN 1.) P)
	     ((LESSP NN 0.) (FPQUOTIENT (FPONE) (FPEXPT P (MINUS NN))))
	     (T (PROG (U) 
		      (COND ((ODDP NN) (SETQ U P))
			    (T (SETQ U (FPONE))))
		      (DO II (QUOTIENT NN 2.) (QUOTIENT II 2.)
			  (ZEROP II)
			  (SETQ P (FPTIMES* P P))
			  (COND ((ODDP II) (SETQ U (FPTIMES* U P)))))
		      (RETURN U))))) 

(DECLARE (NOTYPE N))

(DEFUN EXPTBIGFLOAT (P N) 
  (COND ((EQUAL N 1) P)
	((EQUAL N 0) ($BFLOAT 1))
	((NOT ($BFLOATP P)) (LIST '(MEXPT) P N))
	((EQUAL (CADR P) 0) ($BFLOAT 0))
	((AND (LESSP (CADR P) 0) (RATNUMP N))
	 ($BFLOAT
	  ($EXPAND (LIST '(MTIMES)
			 ($BFLOAT ((LAMBDA ($DOMAIN $M1PBRANCH) (POWER -1 N))
				   '$COMPLEX T))
			 (EXPTBIGFLOAT (BCONS (FPMINUS (CDR P))) N)))))
	((AND (LESSP (CADR P) 0) (NOT (FIXP N)))
	 (COND ((OR (EQUAL N 0.5) (EQUAL N BFHALF))
		(EXPTBIGFLOAT P '((RAT SIMP) 1 2)))
	       ((OR (EQUAL N -0.5) (EQUAL N BFMHALF))
		(EXPTBIGFLOAT P '((RAT SIMP) -1 2)))
	       (($BFLOATP (SETQ N ($BFLOAT N)))
		(COND ((EQUAL N ($BFLOAT (FPENTIER N)))
		       (EXPTBIGFLOAT P (FPENTIER N)))
		      (T  ;; for P<0: P^N = (-P)^N*cos(pi*N) + i*(-P)^N*sin(pi*N)
			 (SETQ P (EXPTBIGFLOAT (BCONS (FPMINUS (CDR P))) N)
			       N ($BFLOAT `((MTIMES) $%PI ,N)))
			 (ADD2 ($BFLOAT `((MTIMES) ,P ,(*FPSIN N NIL)))
			       `((MTIMES SIMP) ,($BFLOAT `((MTIMES) ,P ,(*FPSIN N T)))
					       $%I)))))
	       (T (LIST '(MEXPT) P N))))
	((AND (RATNUMP N) (LESSP (CADDR N) 10.))
	 (BCONS (FPEXPT (FPROOT P (CADDR N)) (CADR N))))
	((NOT (FIXP N))
	 (SETQ N ($BFLOAT N))
	 (COND
	  ((NOT ($BFLOATP N)) (LIST '(MEXPT) P N))
	  (T
	   ((LAMBDA (EXTRABITS) 
	     (SETQ 
	      P
	      ((LAMBDA (FPPREC) 
		       (FPEXP (FPTIMES* (CDR (BIGFLOATP N))
					(FPLOG (CDR (BIGFLOATP P))))))
	       (PLUS EXTRABITS FPPREC)))
	     (SETQ P (LIST (FPROUND (CAR P))
			   (PLUS (MINUS EXTRABITS) *M (CADR P))))
	     (BCONS P))
	    (MAX 1 (PLUS (CADDR N) (HAULONG (CADDR P))))))))
			       ; The number of extra bits required 
	((LESSP N 0) (INVERTBIGFLOAT (EXPTBIGFLOAT P (MINUS N))))
	(T (BCONS (FPEXPT (CDR P) N)))))

(defun fproot (a n) ; computes a^(1/n)  see Fitch, SIGSAM Bull Nov 74
 (let* ((ofprec fpprec) (fpprec (+ fpprec 2))		;assumes a>0 n>=2
        (bk (fpexpt (intofp 2)
		    (add1 (quotient (cadr (setq a (cdr (bigfloatp a)))) n)))))
      (do ((x bk
	      (fpdifference
	       x (setq bk (fpquotient (fpdifference
				       x (fpquotient a (fpexpt x n1))) n))))
	   (n1 (sub1 n))
	   (n (intofp n)))
	  ((or (equal bk '(0 0))
	       (greaterp (difference (cadr x) (cadr bk)) ofprec)) (setq a x))))
 (list (fpround (car a)) (plus -2 *m (cadr a))))

(DEFUN TIMESBIGFLOAT (H) 
       (PROG (FANS TST R NFANS) 
	     (SETQ FANS (SETQ TST (BCONS (FPONE))) NFANS 1)
	     (DO L
		 H
		 (CDR L)
		 (NULL L)
		 (COND ((SETQ R (BIGFLOATP (CAR L)))
			(SETQ FANS (BCONS (FPTIMES* (CDR R)
						    (CDR FANS)))))
		       (T (SETQ NFANS (LIST '(MTIMES)
					    (CAR L)
					    NFANS)))))
	     (RETURN (COND ((EQUAL NFANS 1) FANS)
			   ((EQUAL FANS TST) NFANS)
			   (T (RETURN (SIMPLIFY (LIST '(MTIMES)
						      FANS
						      NFANS)))))))) 

(DEFUN INVERTBIGFLOAT (A) 
  (IF (BIGFLOATP A) (BCONS (FPQUOTIENT (FPONE) (CDR A)))
		    (SIMPLIFY (LIST '(MEXPT) A -1))))

(DEFUN *FPEXP (A) 
 (FPEND (LET ((FPPREC (PLUS 8. FPPREC)))
	     (IF ($BFLOATP (SETQ A ($BFLOAT A)))
		 (FPEXP (CDR A))
		 (LIST '(MEXPT) '$%E A)))))

(DEFUN *FPSIN (A FL) 
 (FPEND (LET ((FPPREC (PLUS 8. FPPREC)))
	     (COND (($BFLOATP A) (FPSIN (CDR ($BFLOAT A)) FL))
		   (FL (LIST '(%SIN) A))
		   (T (LIST '(%COS) A))))))

(DEFUN FPEND (A)
 (COND ((EQUAL (CAR A) 0) (BCONS A))
       ((NUMBERP (CAR A))
	(SETQ A (LIST (FPROUND (CAR A)) (PLUS -8. *M (CADR A))))
	(BCONS A))
       (T A))) 

(DECLARE (FIXNUM N))

(DEFUN SINBIGFLOAT (X) (*FPSIN (CAR X) T)) 

(DEFUN COSBIGFLOAT (X) (*FPSIN (CAR X) NIL)) 

;; THIS VERSION OF FPSIN COMPUTES SIN OR COS TO PRECISION FPPREC,
;; BUT CHECKS FOR THE POSSIBILITY OF CATASTROPHIC CANCELLATION DURING
;; ARGUMENT REDUCTION (E.G. SIN(N*%PI+EPSILON)) 
;; *FPSINCHECK WILL CAUSE PRINTOUT OF ADDITIONAL INFO WHEN
;; EXTRA PRECISION IS NEEDED FOR SIN/COS CALCULATION.  KNOWN
;; BAD FEATURES:  IT IS NOT NECESSARY TO USE EXTRA PRECISION FOR, E.G.
;; SIN(PI/2), WHICH IS NOT NEAR ZERO, BUT  EXTRA
;; PRECISION IS USED SIN IT IS NEEDED FOR COS(PI/2).
;; PRECISION SEEMS TO BE 100% SATSIFACTORY FOR LARGE ARGUMENTS, E.G.
;; SIN(31415926.0B0), BUT LESS SO FOR SIN(3.1415926B0).  EXPLANATION
;; NOT KNOWN.  (9/12/75  RJF)
(DECLARE (SPECIAL *FPSINCHECK))
(SETQ *FPSINCHECK NIL)

(DEFUN FPSIN (X FL) 
  (PROG (PIBY2 R SIGN RES K *CANCELLED) 
	(SETQ SIGN (COND (FL (SIGNP G (CAR X))) (T)) X (FPABS X))
	(COND ((EQUAL (CAR X) 0)
	       (RETURN (COND (FL (INTOFP 0)) (T (INTOFP 1))))))
	(RETURN 
	 (CDR
	  (BIGFLOATP
	   ((LAMBDA (FPPREC XT *CANCELLED OLDPREC) 
	      (PROG (X) 
               LOOP (SETQ X (CDR (BIGFLOATP XT)))
	            (SETQ PIBY2 (FPQUOTIENT (FPPI) (INTOFP 2)))
		    (SETQ R (FPINTPART (FPQUOTIENT X PIBY2)))
		    (SETQ X
			  (FPPLUS X
				  (FPTIMES* (INTOFP (MINUS R))
					    PIBY2)))
		    (SETQ K *CANCELLED)
		    (FPPLUS X (FPMINUS PIBY2))
		    (SETQ *CANCELLED (MAX K *CANCELLED))
		    (COND (*FPSINCHECK
			   (PRINT `(*CANC= ,*CANCELLED FPPREC= ,FPPREC
					   OLDPREC= ,OLDPREC))))

		    (COND
		     ((NOT (GREATERP OLDPREC
				     (DIFFERENCE FPPREC
						 *CANCELLED)))
		      (SETQ R (REMAINDER R 4))
		      (SETQ RES
			    (COND (FL (COND ((= R 0) (FPSIN1 X))
					    ((= R 1) (FPCOS1 X))
					    ((= R 2) (FPMINUS (FPSIN1 X)))
					    ((= R 3) (FPMINUS (FPCOS1 X)))))
				  (T (COND ((= R 0) (FPCOS1 X))
					   ((= R 1) (FPMINUS (FPSIN1 X)))
					   ((= R 2) (FPMINUS (FPCOS1 X)))
					   ((= R 3) (FPSIN1 X))))))
		      (RETURN (BCONS (COND (SIGN RES) (T (FPMINUS RES))))))
		     (T (SETQ FPPREC (PLUS FPPREC *CANCELLED))
			(GO LOOP)))))
	    (MAX FPPREC (PLUS FPPREC (CADR X)))
	    (BCONS X)
	    0
	    FPPREC)))))) 

(DEFUN FPCOS1 (X) (FPSINCOS1 X NIL))

;; Compute SIN or COS in (0,PI/2).  FL is T for SIN, NIL for COS.
(DEFUN FPSINCOS1 (X FL)
       (PROG (ANS TERM OANS X2)
	     (SETQ ANS (IF FL X (INTOFP 1))
		   X2 (FPMINUS(FPTIMES* X X)))
	     (SETQ TERM ANS)
	     (DO N (COND (FL 3) (T 2)) (PLUS N 2) (EQUAL ANS OANS)
		 (SETQ TERM (FPTIMES* TERM (FPQUOTIENT X2 (INTOFP (* N (SUB1 N))))))
		 (SETQ OANS ANS ANS (FPPLUS ANS TERM)))
	     (RETURN ANS)))

(DEFUN FPSIN1(X) (FPSINCOS1 X T)) 

(DEFUN FPABS (X) 
       (COND ((SIGNP GE (CAR X)) X)
	     (T (CONS (MINUS (CAR X)) (CDR X))))) 

(DEFMFUN FPENTIER (F) (LET ((FPPREC (CADDAR F))) (FPINTPART (CDR F))))

(DEFUN FPINTPART (F) 
       (PROG (M) 
	     (SETQ M (DIFFERENCE FPPREC (CADR F)))
	     (RETURN (COND ((GREATERP M 0)
			    (QUOTIENT (CAR F) (EXPT 2 M)))
			   (T (TIMES (CAR F) (EXPT 2 (MINUS M)))))))) 

(DEFUN LOGBIGFLOAT (A) 
 ((LAMBDA (MINUS)
   (SETQ A ((LAMBDA (FPPREC) 
	     (COND (($BFLOATP (CAR A))
		    (SETQ A ($BFLOAT (CAR A)))
		    (COND ((ZEROP (CADR A)) (MERROR "LOG(0.0B0) has been generated"))
			  ((MINUSP (CADR A))
			   (SETQ MINUS T) (FPLOG (LIST (MINUS (CADR A)) (CADDR A))))
			  (T (FPLOG (CDR A)))))
		   (T (LIST '(%LOG) (CAR A)))))
	    (PLUS 2 FPPREC)))
   (COND ((NUMBERP (CAR A))
	  (SETQ A (LIST (FPROUND (CAR A)) (PLUS -2 *M (CADR A))))
	  (SETQ A (BCONS A))))
   (COND (MINUS (ADD A (MUL '$%I ($BFLOAT '$%PI)))) (T A)))
  NIL)) 

(DEFUN FPLOG (X) 
       (PROG (OVER TWO ANS OLDANS TERM E) 
	     (IF (NOT (GREATERP (CAR X) 0))
		 (MERROR "Non-positive argument to FPLOG"))
	     (SETQ E (FPE) OVER (FPQUOTIENT (FPONE) E) ANS 0)
	     (DO () (NIL)
		 (COND ((EQUAL X E) (SETQ X NIL) (RETURN NIL))
		       ((AND (FPLESSP X E) (FPLESSP OVER X))
			(RETURN NIL))
		       ((FPLESSP X OVER)
			(SETQ X (FPTIMES* X E))
			(SETQ ANS (SUB1 ANS)))
		       (T (SETQ ANS (ADD1 ANS))
			  (SETQ X (FPQUOTIENT X E)))))
	     (COND ((NULL X) (RETURN (INTOFP (ADD1 ANS)))))
	     (SETQ X (FPDIFFERENCE  X (FPONE)) ANS (INTOFP ANS))
	     (SETQ 
	      X
	      (FPEXPT (SETQ TERM
			    (FPQUOTIENT X (FPPLUS X (SETQ TWO (INTOFP 2)))))
		      2))
	     (DO N 0 (1+ N) (EQUAL ANS OLDANS)
	      (SETQ OLDANS ANS)
	      (SETQ 
	       ANS
	       (FPPLUS
		ANS
		(FPTIMES* TWO (FPQUOTIENT TERM (INTOFP (1+ (* 2 N)))))))
	      (SETQ TERM (FPTIMES* TERM X)))
	     (RETURN ANS))) 

(DEFUN MABSBIGFLOAT (L) 
       (PROG (R) 
	     (SETQ R (BIGFLOATP (CAR L)))
	     (RETURN (COND ((NULL R) (LIST '(MABS) (CAR L)))
			   (T (BCONS (FPABS (CDR R)))))))) 

#-NIL
(FPPREC1 NIL $FPPREC)  ; Set up user's precision


; Undeclarations for the file:
(DECLARE (NOTYPE I N EXTRADIGS))

