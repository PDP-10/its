;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module rat3a)

;; This is the new Rational Function Package Part 1.
;; It includes most of the coefficient and polynomial routines required
;; by the rest of the functions.  Certain specialized functions are found
;; elsewhere.  Most low-level utility programs are also in this file.

(DECLARE (SPECIAL U* *A* *VAR* *X* V*)
	 (GENPREFIX A_1))

(LOAD-MACSYMA-MACROS RATMAC)

;; Global variables referenced throughout the rational function package.

(DEFMVAR MODULUS NIL "Global switch for doing modular arithmetic")
(DEFMVAR HMODULUS NIL "Half of MODULUS")
(DEFMVAR ERRRJFFLAG NIL "Controls action of ERRRJF (error or throw)")

(DEFMFUN POINTERGP (A B) (> (SYMEVAL A) (SYMEVAL B)))

(DEFMACRO BCTIMES (&REST L)
	  `(REMAINDER (TIMES . ,L) MODULUS))

(DEFUN CQUOTIENT (A B)
       (COND ((EQN A 0) 0)
	     ((NULL MODULUS)
	      (COND ((EQN 0 (CREMAINDER A B)) (QUOTIENT A B))
		    (T (ERRRJF "quotient is not exact"))))
	     (T (CTIMES A (CRECIP B)))))

(DEFUN ALG (L) (AND $ALGEBRAIC (NOT (ATOM L)) (GET (CAR L) 'TELLRAT)))

(DEFUN PACOEFP (X) (OR (PCOEFP X) (ALG X)))

(DEFUN LEADTERM (POLY)
       (COND ((PCOEFP POLY) POLY)
	     (T (MAKE-POLY (P-VAR POLY) (P-LE POLY) (P-LC POLY)))))

;; (DEFUN LCF (POLY)
;;        (COND ((PCOEFP POLY) POLY)
;; 	     (T (P-LC POLY))))

;; (DEFUN LEXP (POLY) (COND ((PCOEFP POLY) 0) (T (P-LE POLY))))

(DEFUN CREMAINDER (A B)
	(COND ((OR MODULUS (FLOATP A) (FLOATP B)) 0) 
	      ((REMAINDER A B))))

(DEFUN CBEXPT (P N)
       (DO ((N (QUOTIENT N 2) (QUOTIENT N 2))
	    (S (COND ((ODDP N) P) (T 1))))
	   ((ZEROP N) S)
	   (SETQ P (BCTIMES P P))
	   (AND (ODDP N) (SETQ S (BCTIMES S P)))))

#+PDP10
(DEFUN CDIFFERENCE (X Y) (CPLUS X (CMINUS Y)))

;; Coefficient Arithmetic -- coefficients are assumed to be something
;; that is NUMBERP in lisp.  If MODULUS is non-NIL, then all coefficients
;; are assumed to be less than its value.  Some functions use LOGAND
;; when MODULUS = 2.  This will not work with bignum coefficients.

;; The following five routines have been hand coded in RAT;RATLAP >.  Please
;; do not delete these definitions.  They are needed for Macsymas which run
;; on non-PDP10 systems

#-PDP10
(PROGN 'COMPILE

(DEFUN CMOD (N)
  (COND ((NULL MODULUS) N)
	((BIGP MODULUS)
	 (SETQ N (REMAINDER N MODULUS))
	 (COND ((LESSP N 0)
		(IF (LESSP (TIMES 2 N) (MINUS MODULUS))
		    (SETQ N (PLUS N MODULUS))))
	       ((GREATERP (TIMES 2 N) MODULUS) (SETQ N (DIFFERENCE N MODULUS)))) 
	 N)
	((BIGP N)
	 (SETQ N (REMAINDER N MODULUS))
	 (COND ((< N 0)
		(IF (< N (- (LSH MODULUS -1))) (SETQ N (+ N MODULUS))))
	       ((> N (LSH MODULUS -1)) (SETQ N (- N MODULUS))))
	 N)
	((= MODULUS 2) (LOGAND N 1))
	(T (LET ((NN (\ N MODULUS)))
	     (DECLARE (FIXNUM NN))
	     (COND ((< NN 0)
		    (AND (< NN (- (LSH MODULUS -1))) (SETQ NN (+ NN MODULUS))))
		   ((> NN (LSH MODULUS -1)) (SETQ NN (- NN MODULUS))))
	     NN))))

(DEFUN CPLUS (A B)
  (COND ((NULL MODULUS) (PLUS A B))
	((BIGP MODULUS) (CMOD (PLUS A B)))
	((= MODULUS 2) (LOGAND 1 (LOGXOR A B)))
	(T (LET ((NN (\ (+ A B) MODULUS)))
	     (DECLARE (FIXNUM NN))
	     ;; This is an efficiency hack which assumes that MINUSP is
	     ;; faster than <.  The first clause could simply be
	     ;; ((< NN (- (LSH MODULUS -1))) (+ NN MODULUS))
	     (COND ((MINUSP NN)
		    (IF (< NN (- (LSH MODULUS -1))) (+ NN MODULUS) NN))
		   ((> NN (LSH MODULUS -1)) (- NN MODULUS))
		   (T NN))))))

(DEFUN CDIFFERENCE (A B)
  (COND ((NULL MODULUS) (DIFFERENCE A B))
	((BIGP MODULUS) (CMOD (DIFFERENCE A B)))
	((= MODULUS 2) (LOGAND 1 (LOGXOR A B)))
	(T (LET ((NN (\ (- A B) MODULUS)))
	     (DECLARE (FIXNUM NN))
	     ;; This is an efficiency hack which assumes that MINUSP is
	     ;; faster than <.  The first clause could simply be
	     ;; ((< NN (- (LSH MODULUS -1))) (+ NN MODULUS))
	     (COND ((MINUSP NN)
		    (IF (< NN (- (LSH MODULUS -1))) (+ NN MODULUS) NN))
		   ((> NN (LSH MODULUS -1)) (- NN MODULUS))
		   (T NN))))))

;; (*DBLREM A B M) computes (A * B)/M in one swell foop so as not to
;; cons up a bignum intermediate for A*B.  MODULUS is known to be a fixnum
;; at the point where the call occurs, and thus A and B are known to be
;; fixnums.

(DECLARE (FIXNUM (*DBLREM FIXNUM FIXNUM FIXNUM)))

#+NIL
(DEFUN *DBLREM (A B M)
  ;; remind me to put the required primitives into NIL. -GJC
  (REMAINDER (TIMES A B) M))

#+LISPM
(DEFUN *DBLREM (A B C)		;(\ (* A B) C)
  (%REMAINDER-DOUBLE (%MULTIPLY-FRACTIONS A B) (%24-BIT-TIMES A B)
			 C))

(DEFUN CTIMES (A B)
  (COND ((NULL MODULUS) (TIMES A B))
	((BIGP MODULUS) (CMOD (TIMES A B)))
	((= MODULUS 2) (LOGAND 1 A B))
	(T (LET ((NN (*DBLREM A B MODULUS)))
	     (DECLARE (FIXNUM NN))
	     (COND ((MINUSP NN)
		    (IF (< NN (- (LSH MODULUS -1))) (+ NN MODULUS) NN))
		   ((> NN (LSH MODULUS -1)) (- NN MODULUS))
		   (T NN))))))

;; Takes the inverse of an integer N mod P.  Solve N*X + P*Y = 1 
;; I suspect that N is guaranteed to be less than P, since in the case
;; where P is a fixnum, N is also assumed to be one.

(DEFUN INVMOD (N MODULUS) (CRECIP N))

#-LISPM
(DEFUN CRECIP (N)
  (COND
    ;; Have to use bignum arithmetic if modulus is a bignum
    ((BIGP MODULUS) 
     (PROG (A1 A2 Y1 Y2 Q)
	   (IF (MINUSP N) (SETQ N (PLUS N MODULUS)))
	   (SETQ A1 MODULUS A2 N)
	   (SETQ Y1 0 Y2 1)
	   (GO STEP3)
	STEP2 (SETQ Q (QUOTIENT A1 A2))
	   (PSETQ A1 A2 A2 (DIFFERENCE A1 (TIMES A2 Q)))
	   (PSETQ Y1 Y2 Y2 (DIFFERENCE Y1 (TIMES Y2 Q)))
	STEP3 (COND ((ZEROP A2) (MERROR "Inverse of zero divisor?"))
		    ((NOT (EQUAL A2 1)) (GO STEP2)))
	   (RETURN (CMOD Y2))))
    ;; Here we can use fixnum arithmetic
    (T (PROG (A1 A2 Y1 Y2 Q NN PP)
	     (DECLARE (FIXNUM A1 A2 Y1 Y2 Q NN PP))
	     (SETQ NN N PP MODULUS)
	     (COND ((MINUSP NN) (SETQ NN (+ NN PP))))
	     (SETQ A1 PP A2 NN)
	     (SETQ Y1 0 Y2 1)
	     (GO STEP3)
	  STEP2 (SETQ Q (// A1 A2))
	     (PSETQ A1 A2 A2 (\ A1 A2))
	     (PSETQ Y1 Y2 Y2 (- Y1 (* Y2 Q)))
	  STEP3 (COND ((ZEROP A2) (MERROR "Inverse of zero divisor?"))
		      ((NOT (EQUAL A2 1)) (GO STEP2)))
	     ;; Is there any reason why this can't be (RETURN (CMOD Y2)) ? -cwh
	     (RETURN (COND ((= PP 2) (LOGAND 1 Y2))
			   (T (LET ((NN (\ Y2 PP)))
				(DECLARE (FIXNUM NN))
				(COND ((MINUSP NN)
				       (AND (< NN (- (LSH PP -1)))
					    (SETQ NN (+ NN PP))))
				      ((> NN (LSH PP -1))
				       (SETQ NN (- NN PP))))
				NN))))))))

;; Notice how much cleaner things are on the Lisp Machine.

#+LISPM
(DEFUN CRECIP (N &AUX (A1 MODULUS) A2 (Y1 0) (Y2 1) Q)
  (SETQ A2 (IF (< N 0) (+ N MODULUS) N))
  (DO ()
      ((= A2 1) (CMOD Y2))
      (IF (= A2 0)
	  (FERROR NIL "Inverse of zero divisor -- ~D modulo ~D" N MODULUS))
    (SETQ Q (// A1 A2))
    (PSETQ A1 A2 A2 (- A1 (* A2 Q)))
    (PSETQ Y1 Y2 Y2 (- Y1 (* Y2 Q)))))

(DEFUN CEXPT (N E)
  (COND	((NULL MODULUS) (EXPT N E))
	(T (CMOD (CBEXPT N E)))))

) ;; End of non-PDP10 definitions of CMOD, CPLUS, CDIFFERENCE, CTIMES, CRECIP, CEXPT.

(DEFUN SETQMODULUS (M)
   (COND ((NUMBERP M)
	  (COND ((GREATERP M 0)
		 (SETQ HMODULUS (QUOTIENT M 2))
		 (SETQ MODULUS M))
		(T (MERROR "Modulus must be a number > 0"))))
	 (T (SETQ HMODULUS (SETQ MODULUS NIL)))))

(DEFUN PCOEFADD (E C X) (COND ((PZEROP C) X)
			      ((BIGP E) (MERROR "Exponent out of range"))
			      (T (CONS E (CONS C X)))))

(DEFMFUN PPLUS (X Y)
  (COND ((PCOEFP X) (PCPLUS X Y))
	((PCOEFP Y) (PCPLUS Y X))
	((EQ (P-VAR X) (P-VAR Y))
	 (PSIMP (P-VAR X) (PPLUS1 (P-TERMS Y) (P-TERMS X))))
	((POINTERGP (P-VAR X) (P-VAR Y))
	 (PSIMP (P-VAR X) (PCPLUS1 Y (P-TERMS X))))
	(T (PSIMP (P-VAR Y) (PCPLUS1 X (P-TERMS Y))))))

(DEFUN PPLUS1 (X Y)
       (COND ((PTZEROP X) Y)
	     ((PTZEROP Y) X)
	     ((= (PT-LE X) (PT-LE Y))
	      (PCOEFADD (PT-LE X)
			(PPLUS (PT-LC X) (PT-LC Y))
			(PPLUS1 (PT-RED X) (PT-RED Y))))
	     ((> (PT-LE X) (PT-LE Y))
	      (CONS (PT-LE X) (CONS (PT-LC X) (PPLUS1 (PT-RED X) Y))))
	     (T (CONS (PT-LE Y) (CONS (PT-LC Y) (PPLUS1 X (PT-RED Y)))))))

(DEFUN PCPLUS (C P) (COND ((PCOEFP P) (CPLUS P C))
			  (T (PSIMP (P-VAR P) (PCPLUS1 C (P-TERMS P))))))

(DEFUN PCPLUS1 (C X)
       (COND ((NULL X)
	      (COND ((PZEROP C) NIL) (T (CONS 0 (CONS C NIL)))))
	     ((PZEROP (CAR X)) (PCOEFADD 0 (PPLUS C (CADR X)) NIL))
	     (T (CONS (CAR X) (CONS (CADR X) (PCPLUS1 C (CDDR X)))))))
	 

(DEFMFUN PDIFFERENCE (X Y)
  (COND ((PCOEFP X) (PCDIFFER X Y))
	((PCOEFP Y) (PCPLUS (CMINUS Y) X))
	((EQ (P-VAR X) (P-VAR Y))
	 (PSIMP (P-VAR X) (PDIFFER1 (P-TERMS X) (P-TERMS Y))))
	((POINTERGP (P-VAR X) (P-VAR Y))
	 (PSIMP (P-VAR X) (PCDIFFER2 (P-TERMS X) Y)))
	(T (PSIMP (P-VAR Y) (PCDIFFER1 X (P-TERMS Y))))))

(DEFUN PDIFFER1 (X Y)
       (COND ((PTZEROP X) (PMINUS1 Y))
	     ((PTZEROP Y) X)
	     ((= (PT-LE X) (PT-LE Y))
	      (PCOEFADD (PT-LE X)
			(PDIFFERENCE (PT-LC X) (PT-LC Y))
			(PDIFFER1 (PT-RED X) (PT-RED Y))))
	     ((> (PT-LE X) (PT-LE Y))
	      (CONS (PT-LE X) (CONS (PT-LC X) (PDIFFER1 (PT-RED X) Y))))
	     (T (CONS (PT-LE Y) (CONS (PMINUS (PT-LC Y))
				      (PDIFFER1 X (PT-RED Y)))))))

(DEFUN PCDIFFER (C P)
       (COND ((PCOEFP P) (CDIFFERENCE C P))
	     (T (PSIMP (CAR P) (PCDIFFER1 C (CDR P))))))	 

(DEFUN PCDIFFER1 (C X)
       (COND ((NULL X) (COND ((PZEROP C) NIL) (T (LIST 0 C))))
	     ((PZEROP (CAR X))
	      (PCOEFADD 0 (PDIFFERENCE C (CADR X)) NIL))
	     (T (CONS (CAR X)
		      (CONS (PMINUS (CADR X)) (PCDIFFER1 C (CDDR X)))))))

(DEFUN PCDIFFER2 (X C)
       (COND ((NULL X) (COND ((PZEROP C) NIL) (T (LIST 0 (PMINUS C)))))
	     ((PZEROP (CAR X)) (PCOEFADD 0 (PDIFFERENCE (CADR X) C) NIL))
	     (T (CONS (CAR X) (CONS (CADR X) (PCDIFFER2 (CDDR X) C))))))

(DEFUN PCSUBSTY (VALS VARS P)				;list of vals for vars
       (COND ((NULL VARS) P)
	     ((ATOM VARS) (PCSUB P (LIST VALS) (LIST VARS)))	;one val hack
	     (T (SETQ VARS (SORTCAR (MAPCAR #'CONS VARS VALS) #'POINTERGP))
		(PCSUB P (MAPCAR (FUNCTION CDR) VARS)
		         (MAPCAR (FUNCTION CAR) VARS)))))

(DEFUN PCSUBST (P VAL VAR)				;one val for one var
  (COND ((PCOEFP P) P)
	((EQ (CAR P) VAR) (PCSUB1 (CDR P) VAL () ()))
	((POINTERGP VAR (CAR P)) P)
	(T (PSIMP (CAR P) (PCSUB2 (CDR P) (NCONS VAL) (NCONS VAR)))))) 

(DEFUN PCSUB1 (A VAL VALS VARS)
       (if (EQUAL VAL 0) (PCSUB (PTERM A 0) VALS VARS)
	   (do ((p (pt-red a) (pt-red p))
		(ans (pcsub (pt-lc a) vals vars)
		     (pplus (ptimes ans
				    (pexpt val (- ld (pt-le p))))
			    (pcsub (pt-lc p) vals vars)))
		(ld (pt-le a) (pt-le p)))
	       ((null p) (ptimes ans (pexpt val ld))))))

(DEFUN PCSUB (P VALS VARS)
       (COND ((NULL VALS) P)
	     ((PCOEFP P) P)
	     ((EQ (p-var P) (CAR VARS)) (PCSUB1 (p-terms P) (car vals)
					      (cdr VALS) (cdr VARS)))
	     ((POINTERGP (CAR VARS) (p-var P))
	      (PCSUB P (CDR VALS) (CDR VARS)))
	     (T (PSIMP (p-var P) (PCSUB2 (p-terms P) VALS VARS)))))

(DEFUN PCSUB2 (terms VALS VARS)
  (loop for (exp coef) on terms by 'pt-red
	unless (pzerop (setq coef (pcsub coef vals vars)))
	nconc (list exp coef)))



;	THIS DERIVATIVE PROGRAM ASSUMES NO DEPENDENCIES HIDDEN ON VARLIST
;	OR ELSWHERE.  COMPARE TO RATDX.

(DEFMFUN PDERIVATIVE (P *VAR*)
  (IF (PCOEFP P) (CDERIVATIVE P *VAR*)
      (PSIMP (P-VAR P) (COND ((EQ *VAR* (P-VAR P))
			      (PDERIVATIVE2 (P-TERMS P)))
			     ((POINTERGP *VAR* (P-VAR P))
			      (PTZERO))
			     (T (PDERIVATIVE3 (P-TERMS P)))))))

(DEFUN PDERIVATIVE2 (X)
  (COND ((NULL X) NIL)
	((ZEROP (PT-LE X)) NIL)
	(T (PCOEFADD (1- (PT-LE X))
		     (PCTIMES (CMOD (PT-LE X)) (PT-LC X))
		     (PDERIVATIVE2 (PT-RED X))))))

(DEFUN PDERIVATIVE3 (X)
       (COND ((NULL X) NIL)
	     (T (PCOEFADD
		 (PT-LE X)
		 (PDERIVATIVE (PT-LC X) *VAR*)
		 (PDERIVATIVE3 (PT-RED X))))))

(DEFUN PDIVIDE (X Y)
       (COND ((PZEROP Y) (ERRRJF "Quotient by zero"))
	     ((PACOEFP Y) (LIST (RATREDUCE X Y) (RZERO)))
	     ((PACOEFP X) (LIST (RZERO) (CONS X 1)))
	     ((POINTERGP (CAR X) (CAR Y)) (LIST (RATREDUCE X Y) (RZERO)))
	     (T (PDIVIDE1 X Y))))

(DEFUN PDIVIDE1 (U V)
  (PROG (K INC LCU LCV Q R)
	(SETQ LCV (CONS (CADDR V) 1))
	(SETQ Q (RZERO))
	(SETQ R (CONS U 1) )
   A    (SETQ K (- (PDEGREE (CAR R) (P-VAR V)) (P-LE V)))
        (IF (MINUSP K) (RETURN (LIST Q R)))
	(SETQ LCU (CONS (P-LC (CAR R)) (CDR R)))
	(SETQ INC (RATQUOTIENT LCU LCV))
	(SETQ INC (CONS (PSIMP (CAR V) (LIST K (CAR INC)))
			(CDR INC)))
	(SETQ Q (RATPLUS Q INC))
	(SETQ R (RATPLUS R  (RATTIMES (CONS (PMINUS V) 1) INC T)))
	(GO A)))
	 

(DEFUN PEXPT (P N)
  (COND ((= N 0) 1)
	((= N 1) P)
	((MINUSP N) (PQUOTIENT 1 (PEXPT P (- N))))
	((PCOEFP P) (CEXPT P N))
	((ALG P) (PEXPTSQ P N))
	((NULL (P-RED P))
	 (PSIMP (P-VAR P)
		(PCOEFADD (* N (P-LE P)) (PEXPT (P-LC P) N) NIL)))
	(T (LET ((*A* (1+ N))
		 (*X* (PSIMP (P-VAR P) (P-RED P)))
		 (B (MAKE-POLY (P-VAR P) (P-LE P) (P-LC P))))
	     (DO ((BL (LIST (PEXPT B 2) B)
		      (CONS (PTIMES B (CAR BL)) BL))
		  (M 2 (1+ M)))
		 ((= M N) (PPLUS (CAR BL)
				 (PEXPT2 1 1 *X* (CDR BL)))))))))

(DEFUN NXTBINCOEF (M NOM) (QUOTIENT (TIMES NOM (DIFFERENCE *A* M)) M))

(DEFUN PEXPT2 (M NOM B L)
  (IF (NULL L) B
      (PPLUS (PTIMES (PCTIMES (CMOD (SETQ NOM (NXTBINCOEF M NOM))) B) (CAR L))
	     (PEXPT2 (1+ M)
		     NOM
		     (IF (EQ *X* B) (PEXPT B 2)
			 (PTIMES *X* B))
		     (CDR L)))))

(DEFMFUN PMINUSP (P) (IF (NUMBERP P) (MINUSP P)
			 (PMINUSP (P-LC P))))

(DEFMFUN PMINUS (P) (IF (PCOEFP P) (CMINUS P)
			(CONS (P-VAR P) (PMINUS1 (P-TERMS P)))))

(DEFUN PMINUS1 (X)
  (loop for (exp coef) on x by 'pt-red
	nconc (list exp (pminus coef))))

(DEFMFUN PMOD (P)
  (IF (PCOEFP P) (CMOD P)
      (PSIMP (CAR P)
	     (loop for (exp coef) on (p-terms p) by 'pt-red
		   unless (pzerop (setq coef (pmod coef)))
		   nconc (list exp coef)))))

(DEFMFUN PQUOTIENT (X Y)
 (COND ((PCOEFP X)
	(COND ((PZEROP X) (PZERO))
	      ((PCOEFP Y) (CQUOTIENT X Y))
	      ((ALG Y) (PAQUO X Y))
	      (T (ERRRJF "Quotient by a polynomial of higher degree"))))
       ((PCOEFP Y) (COND ((PZEROP Y) (ERRRJF "Quotient by zero"))
			 (MODULUS (PCTIMES (CRECIP Y) X))
			 (T (PCQUOTIENT X Y))))
       ((ALG Y) (OR (LET ((ERRRJFFLAG T) $ALGEBRAIC)
			  (*CATCH 'RATERR (PQUOTIENT X Y)))
		     (PATIMES X (RAINV Y))))
       ((POINTERGP (P-VAR X) (P-VAR Y)) (PCQUOTIENT X Y))
       ((OR (POINTERGP (P-VAR Y) (P-VAR X)) (> (P-LE Y) (P-LE X)))
	(ERRRJF "Quotient by a polynomial of higher degree"))
       (T (PSIMP (P-VAR X) (PQUOTIENT1 (P-TERMS X) (P-TERMS Y))))))

(DEFUN PCQUOTIENT (P Q)
  (psimp (P-VAR p)
	 (loop for (exp coef) on (P-TERMS p) by 'PT-RED
	       nconc (list exp (pquotient coef Q)))))

(DECLARE (SPECIAL K Q*)
	 (FIXNUM K I))

(DEFUN PQUOTIENT1 (U V &AUX Q*)
  (loop for k #-Multics fixnum = (- (pt-le u) (pt-le v))
	when (minusp k) do (ERRRJF "Polynomial quotient is not exact")
	nconc (list k (setq q* (pquotient (pt-lc u) (pt-lc v))))
	until (ptzerop (setq u (pquotient2 (pt-red u) (pt-red v))))))

(DEFUN PQUOTIENT2 (X Y &AUX (I 0))			;X-v^k*Y*Q*
  (COND ((NULL Y) X)
	((NULL X) (PCETIMES1 Y K (PMINUS Q*)))
	((MINUSP (SETQ I (- (PT-LE X) (PT-LE Y) K)))
	 (PCOEFADD (+ (PT-LE Y) K)
		   (PTIMES Q* (PMINUS (PT-LC Y)))
		   (PQUOTIENT2 X (PT-RED Y))))
	((ZEROP I) (PCOEFADD (PT-LE X)
			     (PDIFFERENCE (PT-LC X) (PTIMES Q* (PT-LC Y)))
			     (PQUOTIENT2 (PT-RED X) (PT-RED Y))))
	(T (CONS (PT-LE X) (CONS (PT-LC X) (PQUOTIENT2 (PT-RED X) Y))))))

(DECLARE (UNSPECIAL K Q*)
	 (NOTYPE K I))

(defun algord (var) (and $algebraic (get var 'algord)))

(DEFUN PSIMP (VAR X)
       (COND ((PTZEROP X) 0)
	     ((ATOM X) X)
	     ((ZEROP (PT-LE X)) (PT-LC X))
	     ((algord var)				;wrong alg ordering
	      (do ((p x (cddr p)) (sum 0))
		  ((null p) (cond ((pzerop sum) (cons var x))
				  (t (pplus sum (psimp2 var x)))))
		(unless (or (pcoefp (cadr p)) (pointergp var (caadr p)))
			(setq sum (pplus sum
					 (if (zerop (pt-le p)) (pt-lc p)
					     (ptimes 
					      (make-poly var (pt-le p) 1)
					      (pt-lc p)))))
			(setf (pt-lc p) 0))))
	     (T (CONS VAR X))))

(defun psimp1 (var x) (let ($algebraic) (psimp var x)))

(defun psimp2 (var x)
       (do ((p (setq x (cons nil x)) ))
	   ((null (cdr p)) (psimp1 var (cdr x)))
	   (cond ((pzerop (caddr p)) (rplacd p (cdddr p)))
		 (t (setq p (cddr p))))))

(DEFUN PTERM  (P N)
       (do ((p p (pt-red p)))
	   ((ptzerop p) (pzero))
	   (cond ((< (pt-le p) n) (return (pzero)))
		 ((= (pt-le p) n) (return (pt-lc p))))))


(DEFMFUN PTIMES (X Y)
  (COND ((PCOEFP X) (IF (PZEROP X) (PZERO) (PCTIMES X Y)))
	((PCOEFP Y) (IF (PZEROP Y) (PZERO) (PCTIMES Y X)))
	((EQ (P-VAR X) (P-VAR Y))
	 (PALGSIMP (P-VAR X) (PTIMES1 (P-TERMS X) (P-TERMS Y)) (ALG X)))
	((POINTERGP (P-VAR X) (P-VAR Y))
	 (PSIMP (P-VAR X) (PCTIMES1 Y (P-TERMS X))))
	(T (PSIMP (P-VAR Y) (PCTIMES1 X (P-TERMS Y))))))
	 
(DEFUN PTIMES1 (X Y &AUX U*)
  (DO ((V* (SETQ U* (PCETIMES1 Y (PT-LE X) (PT-LC X))))
       (X (PT-RED X) (PT-RED X)))
      ((PTZEROP X) U*)
    (PTIMES2 Y (PT-LE X) (PT-LC X))))

(DEFUN PCETIMES1 (Y E C)				;C*V^E*Y
  (LOOP FOR (EXP COEF) ON Y BY 'PT-RED
	UNLESS (PZEROP (SETQ COEF (PTIMES C COEF)))
	NCONC (LIST (+ E EXP) COEF)))

(DEFUN PTIMES2 (Y XE XC) 
  (PROG (E U C) 
     A1 (COND ((NULL Y) (RETURN NIL)))
	(SETQ E (+ XE (CAR Y)))
	(SETQ C (PTIMES (CADR Y) XC))
	(COND ((PZEROP C) (SETQ Y (CDDR Y)) (GO A1))
	      ((OR (NULL V*) (> E (CAR V*)))
	       (SETQ U* (SETQ V* (PPLUS1 U* (LIST E C))))
	       (SETQ Y (CDDR Y)) (GO A1))
	      ((= E (CAR V*))
	       (SETQ C (PPLUS C (CADR V*)))
	       (COND ((PZEROP C)
		      (SETQ U* (SETQ V* (PDIFFER1 U* (LIST (CAR V*) (CADR V*))))))
		     (T (RPLACA (CDR V*) C)))
	       (SETQ Y (CDDR Y))
	       (GO A1)))
     A  (COND ((AND (CDDR V*) (> (CADDR V*) E)) (SETQ V* (CDDR V*)) (GO A)))
	(SETQ U (CDR V*))
     B  (COND ((OR (NULL (CDR U)) (< (CADR U) E))
	       (RPLACD U (CONS E (CONS C (CDR U)))) (GO E)))
	(COND ((PZEROP (SETQ C (PPLUS (CADDR U) C)))
	       (RPLACD U (CDDDR U)) (GO D))
	      (T (RPLACA (CDDR U) C)))
     E  (SETQ U (CDDR U))
     D  (SETQ Y (CDDR Y))
	(COND ((NULL Y) (RETURN NIL)))
	(SETQ E (+ XE (CAR Y)))
	(SETQ C (PTIMES (CADR Y) XC))
     C  (COND ((AND (CDR U) (> (CADR U) E)) (SETQ U (CDDR U)) (GO C)))
	(GO B)))

(DEFUN PCTIMES (C P)
  (IF (PCOEFP P) (CTIMES C P)
      (PSIMP (P-VAR P) (PCTIMES1 C (P-TERMS P)))))

(DEFUN PCTIMES1 (C terms)
  (loop for (exp coef) on terms by 'pt-red
	unless (pzerop (setq coef (PTIMES C coef)))
	nconc (list exp coef)))

(DEFUN LEADALGCOEF (P)
       (COND ((PACOEFP P) P)
	     (T (LEADALGCOEF (P-LC P))) ))

(DEFUN PAINVMOD (Q)
       (COND ((PCOEFP Q) (CRECIP Q))
	     (T (PAQUO (LIST (CAR Q) 0 1) Q ))))

(DEFUN PALGSIMP (VAR P TELL)	;TELL=(N X) -> X^(1/N)
       (PSIMP VAR (COND ((OR (NULL TELL) (NULL P)
			     (< (CAR P) (CAR TELL))) P)
			((NULL (CDDR TELL)) (PASIMP1 P (CAR TELL) (CADR TELL)))
			(T (PGCD1 P TELL)) )))

(DEFUN PASIMP1 (P DEG KERNEL)				;assumes deg>=(car p)
       (DO ((A P (PT-RED A))
	    (B P A))
	   ((OR (NULL A) (< (PT-LE A) DEG))
	    (RPLACD (CDR B) NIL)
	    (PPLUS1 (PCTIMES1 KERNEL P) A))
	 (RPLACA A (- (PT-LE A) DEG))))

(DEFUN MONIZE (P) 
       (COND ((PCOEFP P) (IF (PZEROP P) P 1))
	     (T (CONS (P-VAR P) (PMONICIZE (COPY1 (P-TERMS P)))))))

(DEFUN PMONICIZE (P)					;CLOBBERS POLY
       (COND ((EQN (PT-LC P) 1) P)
	     (T (PMON1 (PAINVMOD (LEADALGCOEF (PT-LC P))) P) P)))

(DEFUN PMON1 (MULT L)
  (COND (L (PMON1 MULT (PT-RED L))
	   (SETF (PT-LC L) (PTIMES MULT (PT-LC L))))))

(DEFUN PMONZ (POLY &AUX LC)				;A^(N-1)*P(X/A)
  (SETQ POLY (PABS POLY))       
  (COND ((EQUAL (SETQ LC (P-LC POLY)) 1) POLY)
	(T (DO ((P (P-RED POLY) (PT-RED P))
		(P1 (MAKE-POLY (P-VAR POLY) (P-LE POLY) 1))
		(MULT 1)
		(DEG (1- (P-LE POLY)) (PT-LE P)))
	       ((NULL P) P1)
	     (SETQ MULT (PTIMES MULT (PEXPT LC (- DEG (PT-LE P)))))
	     (NCONC P1 (LIST (PT-LE P) (PTIMES MULT (PT-LC P))))))))

;	THESE ARE ROUTINES FOR MANIPULATING ALGEBRAIC NUMBERS

(DEFUN ALGNORMAL (P) (CAR (RQUOTIENT P (LEADALGCOEF P))))

(DEFUN ALGCONTENT (P)
       (LET* ((LCF (LEADALGCOEF P))
	      ((PRIM . DENOM) (RQUOTIENT P LCF)))
	     (LIST (RATREDUCE LCF DENOM) PRIM)))

(DEFUN RQUOTIENT (P Q &aux ALGFAC* A E)  ;FINDS PSEUDO QUOTIENT IF PSEUDOREM=0
   (COND ((EQUAL P Q) (CONS 1 1))
	 ((PCOEFP Q) (RATREDUCE P Q))
	 ((SETQ A (TESTDIVIDE P Q)) (CONS A 1))
	 ((ALG Q) (RATTIMES (CONS P 1) (RAINV Q) T))
	 (T (COND ((ALG (SETQ A (LEADALGCOEF Q)))
		   (SETQ A (RAINV A))
		   (SETQ P (PTIMES P (CAR A)))
		   (SETQ Q (PTIMES Q (CAR A)))
		   (SETQ A (CDR A)) ))
	    (COND ((MINUSP (SETQ E (+ 1 (- (CADR Q)) (PDEGREE P (CAR Q)))))
		   (ERRRJF "Quotient by a polynomial of higher degree")))
	    (SETQ A (PEXPT A E))
	    (RATREDUCE (OR (TESTDIVIDE (PTIMES A P) Q)
			   (PROG2 (SETQ A (PEXPT (P-LC Q) E))
				  (PQUOTIENT (PTIMES A P) Q)))
		       A)) ))

(DEFUN PATIMES (X R) (PQUOTIENTCHK (PTIMES X (CAR R)) (CDR R)))

(DEFUN PAQUO (X Y) (PATIMES X (RAINV Y)))

(DEFUN MPGET (VAR)
       (COND ((NULL (SETQ VAR (ALG VAR))) NIL)
	     ((CDDR VAR) VAR)
	     (T (LIST (CAR VAR) 1 0 (PMINUS (CADR VAR))))))

(DECLARE (SPECIAL VAR)) ;This can go back inside of the (let ((car (car q).
                        ;in a while temporary Multics bug.
(DEFUN RAINV (Q)
  (COND ((PCOEFP Q)
	 (COND (MODULUS (CONS (CRECIP Q) 1))
	       (T (CONS 1 Q))))
	(T (LET ((VAR (CAR Q)) (P (MPGET Q)))
	        (COND ((NULL P) (CONS 1 Q))
		      (T (SETQ P (CAR (LET ($RATALGDENOM)
					(BPROG Q (CONS VAR P)))))
			 (RATTIMES (CONS (CAR P) 1) (RAINV (CDR P)) T)))))))
(declare (unspecial var))

(DEFUN PEXPTSQ (P N)
  (DO ((N (QUOTIENT N 2) (QUOTIENT N 2))
       (S (COND ((ODDP N) P) (T 1))))
      ((ZEROP N) S)
    (SETQ P (PTIMES P P))
    (AND (ODDP N) (SETQ S (PTIMES S P))) ))

;	THIS IS THE END OF THE NEW RATIONAL FUNCTION PACKAGE PART 1.

;; Someone should determine which of the variables special in this file
;; (and others) are really special and which are used just for dynamic
;; scoping.  -- cwh

(DECLARE (UNSPECIAL V* *A* U* *VAR*))
