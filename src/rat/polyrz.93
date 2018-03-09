;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module polyrz)

(DECLARE (SPECIAL ERRRJFFLAG $PROGRAMMODE VARLIST 
		  $RATEPSILON $RATPRINT $FACTORFLAG GENVAR
		  EQUATIONS $KEEPFLOAT $RATFAC $ROOTSEPSILON
		  $MULTIPLICITIES))

(DECLARE (GENPREFIX A_5))

(LOAD-MACSYMA-MACROS RATMAC)


;	PACKAGE FOR FINDING REAL ZEROS OF UNIVARIATE POLYNOMIALS
;	WITH INTEGER COEFFICIENTS USING STURM SEQUENCES.

;; Better programming technology.  To be installed with new argument
;; checking scheme.
;; (DEFMFUN $REALROOTS (EXP (EPS $ROOTSEPSILON))
;;        (SETQ EXP (MEQHK EXP))
;;        (IF ($RATP EXP) (SETQ EXP ($RATDISREP EXP)))
;;        (COND ((OR (NOT (MNUMP EPS)) (MNEGP EPS) (EQUAL EPS 0))
;; 	      (DISPLA EPS)
;; 	      (MERROR "Second argument must be a positive number - REALROOTS")))
;;        (LET (($KEEPFLOAT NIL)) (STURMSEQ EXP EPS)))

(DEFMFUN $REALROOTS N
  (LET ((EXP NIL) (EPS NIL)) 
       (COND ((= N 1) (SETQ EPS $ROOTSEPSILON))
	     ((= N 2) (SETQ EPS (ARG 2)))
	     (T (MERROR "Wrong number of arguments - REALROOTS")))
       (SETQ EXP (MEQHK (ARG 1)))
       (IF ($RATP EXP) (SETQ EXP ($RATDISREP EXP)))
       (COND ((OR (NOT (MNUMP EPS)) (MNEGP EPS) (EQUAL EPS 0))
	      (MERROR "Second argument to REALROOTS was not a~
		      positive number: ~M" EPS)))
       (LET (($KEEPFLOAT NIL)) (STURMSEQ EXP EPS))))

(DEFUN UNIPOLY (EXP) 
	(SETQ EXP (CADR (RATF EXP)))
	(COND ((AND (NOT (ATOM EXP))
		    (APPLY 'AND (MAPCAR 'ATOM (CDR EXP)))) EXP)
	      (T (MERROR "Argument must be a univariate polynomial"))))

(DEFUN MAKRAT (PT)
  (COND ((FLOATP PT) (RATIONALIZE PT))
	((NUMBERP PT) (CONS PT 1))
	(($BFLOATP PT) (BIGFLOAT2RAT PT))
	((ATOM PT) (MERROR "~M Non-numeric argument" PT))
	((EQUAL (CAAR PT) 'RAT) (CONS (CADR PT) (CADDR PT)))
	(T (MERROR "~M Non-numeric argument" PT))))

(DEFUN STURMSEQ (EXP EPS)
  (LET (VARLIST EQUATIONS $FACTORFLAG $RATPRINT $RATFAC)
    (COND ($PROGRAMMODE
	   (CONS '(MLIST)
		 (MULTOUT (FINDROOTS (PSQFR (PABS (UNIPOLY EXP)))
				     (MAKRAT EPS)))))
	  (T (SOLVE2 (FINDROOTS (PSQFR (PABS (UNIPOLY EXP)))
				(MAKRAT EPS)))
	     (CONS '(MLIST) EQUATIONS)))))

(DEFUN STURM1 (POLY EPS &AUX B LIST)
  (SETQ B (cons (ROOT-BOUND (CDR POLY)) 1))
  (SETQ LIST (ISOLAT POLY (CONS (MINUS (CAR B)) (CDR B)) B))
  (MAPCAR #'(LAMBDA (INT) (REFINE POLY (CAR INT) (CDR INT) EPS)) LIST))

(DEFUN ROOT-BOUND (P)
       (PROG (N LCF LOGLCF COEF LOGB)
	     (SETQ N (CAR P))
	     (SETQ LCF (ABS (CADR P)))
	     (SETQ LOGLCF (1- (LOG2 LCF)))
	     (SETQ LOGB 1)
	LOOP (COND ((NULL (SETQ P (CDDR P))) (RETURN (EXPT 2 LOGB)))
		   ((LESSP (SETQ COEF (ABS (CADR P))) LCF) (GO LOOP)) )
	     (SETQ LOGB (MAX LOGB (+ 1 (CEIL (- (LOG2 COEF) LOGLCF)
					     (- N (CAR P)) )))) 
	     (GO LOOP) ))

(DEFUN CEIL (A B) (PLUS (QUOTIENT A B)			;CEILING FOR POS A,B
			(SIGNUM (REMAINDER A B))))

(DEFUN STURMAPC (FN LIST MULTIPLICITY)
       (COND ((NULL LIST) NIL)
	     (T  (CONS (FUNCALL FN (CAR LIST))
		       (CONS  MULTIPLICITY 
			      (STURMAPC FN (CDR LIST) MULTIPLICITY)))) ))

(DEFUN FINDROOTS (L EPS)
  (COND ((NULL L) NIL)
	((NUMBERP (CAR L)) (FINDROOTS (CDDR L) EPS))
	(T (APPEND (STURMAPC 'STURMOUT (STURM1 (CAR L) EPS)(CADR L))
		   (FINDROOTS (CDDR L) EPS) )) ))

(DEFUN STURMOUT (INT)
  (LIST '(MEQUAL SIMP) (CAR VARLIST)
	(MIDOUT (RHALF (RPLUS* (CAR INT) (CADR INT)))) ))

(DEFUN MIDOUT (PT)
       (COND ((EQUAL (CDR PT) 1) (CAR PT))
	     ($FLOAT (FPCOFRAT1 (CAR PT) (CDR PT)))
	     (T (LIST '(RAT SIMP) (CAR PT) (CDR PT))) ))

(DEFUN UPRIMITIVE (P) (PQUOTIENT P (UCONTENT P)))   ;PRIMITIVE UNIVAR. POLY

(DEFUN STURM (P)
       (PROG (P1 P2 SEQ R)
	     (SETQ P1 (UPRIMITIVE  P))
	     (SETQ P2 (UPRIMITIVE (PDERIVATIVE P1 (CAR P1))))
	     (SETQ SEQ (LIST P2 P1))
	A    (SETQ R (PREM P1 (PABS P2)))
	     (COND ((PZEROP R) (RETURN (REVERSE SEQ))))
	     (SETQ P1 P2)
	     (SETQ P2 (PMINUS (UPRIMITIVE R)))
	     (PUSH P2 SEQ)
	     (GO A) ))

(DEFUN SIGNUM(X)
       (COND ((ZEROP X) 0)
	     ((MINUSP X) -1)
	     (T 1)))

;	IVAR COUNTS SIGN CHANGES IN A STURM SEQUENCE

(DEFUN IVAR (SEQ PT)
       (PROG (V S LS)
	     (SETQ V 0)
	     (SETQ LS 0)
	A    (COND ((NULL SEQ)(RETURN V)))
	     (SETQ S (REVAL (CAR SEQ) PT))
	     (SETQ SEQ (CDR SEQ))
	     (COND ((MINUSP (TIMES S  LS))(SETQ V (ADD1 V)))
		   ((NOT (ZEROP LS))(GO A)))
	     (SETQ LS S)
	     (GO A) ))

(DEFUN IVAR2 (SEQ PT)
       (COND ((NOT (ATOM PT)) (IVAR SEQ PT))
	     (T (SETQ SEQ (MAPCAR (FUNCTION LEADTERM) SEQ))
		(IVAR SEQ (CONS PT 1)) )))

;	OUTPUT SIGN(P(R)) , R RATIONAL (A.B)

(DEFUN REVAL (P R)
       (COND ((PCOEFP P) (SIGNUM P))
	     ((ZEROP (CAR R)) (SIGNUM (PTERM (CDR P) 0)))
	     (T (PROG (A B BI V M C)
		      (SETQ BI 1)
		      (SETQ V 0)
		      (SETQ P (CDR P))
		      (SETQ M (CAR P))
		      (SETQ A (CAR R))
		      (SETQ B (CDR R))
		 A    (COND ((EQUAL M (CAR P)) (SETQ C (CADR P))
					       (SETQ P (CDDR P)))
			    (T (SETQ C 0)))
		      (COND ((ZEROP M) (RETURN (SIGNUM (PLUS V (TIMES BI C))))))
		      (SETQ V (TIMES A (PLUS V (TIMES BI C))))
		      (SETQ BI (TIMES BI B))
		      (SETQ M (SUB1 M))
		      (GO A) ))))

(DEFUN MAKPOINT (PT)
       (COND ((EQ PT '$INF) 1)
	     ((EQ PT '$MINF) -1)
	     (T (MAKRAT ((LAMBDA ($NUMER) (MEVAL PT)) T)))))

(DEFMFUN $NROOTS N
  (PROG (VARLIST $KEEPFLOAT $RATFAC L R)
	(COND ((= N 1) (SETQ L '$MINF R '$INF))
	      ((= N 3) (SETQ L (ARG 2) R (ARG 3)))
	      (T (MERROR "Wrong number of arguments - NROOTS")))
       (RETURN (NROOTS (UNIPOLY (MEQHK (ARG 1))) (MAKPOINT L) (MAKPOINT R)))))

(DEFUN NROOTS (P L R) (ROOTADDUP (PSQFR P) L R))

(DEFUN ROOTADDUP (LIST L R)
       (COND ((NULL LIST) 0)
	     ((NUMBERP (CAR LIST)) (ROOTADDUP (CDDR LIST) L R))
	     (T (PLUS (ROOTADDUP (CDDR LIST) L R)
		      (TIMES (CADR LIST) (NROOT1 (CAR LIST) L R)))) ))

(DEFUN NROOT1 (P L R)
       (LET ((SEQ (STURM P)))
	    (DIFFERENCE (IVAR2 SEQ L) (IVAR2 SEQ R))))

;	RETURNS ROOT IN INTERVAL OF FORM (A,B])

(DEFUN ISOLAT (P L R)
	(PROG (SEQ LV RV MID MIDV TLIST ISLIST RTS)
		(SETQ SEQ (STURM P))
		(SETQ LV (IVAR SEQ L))
		(SETQ RV (IVAR SEQ R))
		(SETQ TLIST (SETQ ISLIST NIL))
		(COND ((EQUAL LV RV) (RETURN NIL)))
	A	(COND ((GREATERP (SETQ RTS (DIFFERENCE LV RV)) 1)(GO B))
			((EQUAL RTS 1)(SETQ ISLIST (CONS (CONS L R) ISLIST))))
		(COND ((NULL TLIST) (RETURN ISLIST)))
		(SETQ LV (CAR TLIST))
		(SETQ RV (CADR TLIST))
		(SETQ L (CADDR TLIST))
		(SETQ R (CADDDR TLIST))
		(SETQ TLIST (CDDDDR TLIST))
		(GO A)
	B	(SETQ MID (RHALF (RPLUS* L R)))
		(SETQ MIDV (IVAR SEQ MID))
		(COND ((NOT (EQUAL LV MIDV))
			(SETQ TLIST (APPEND (LIST LV MIDV L MID) TLIST))))
		(SETQ L MID)
		(SETQ LV MIDV)
		(GO A) ))

(DEFUN REFINE (P L R EPS)
       (PROG (SR MID SMID)
		(COND ((ZEROP (SETQ SR (REVAL P R)))
			(RETURN (LIST R R))) )
	A	(COND ((RLESSP (RDIFFERENCE* R L) EPS)
			(RETURN (LIST L R))) )
		(SETQ MID (RHALF (RPLUS* L R)))
		(SETQ SMID (REVAL P MID))
		(COND ((ZEROP SMID)(RETURN (LIST MID MID)))
			((EQUAL SMID SR)(SETQ R MID))
			(T (SETQ L MID)) )
		(GO A) ))

(DEFUN RHALF (R) (RREDUCE (CAR R) (TIMES 2 (CDR R))))

(DEFUN RREDUCE (A B) 
       (LET ((G (ABS (GCD A B))))
	    (CONS (QUOTIENT A G) (QUOTIENT B G))) )

(DEFUN RPLUS* (A B)
	(CONS (PLUS (TIMES (CAR A) (CDR B))(TIMES (CAR B) (CDR A)))
		(TIMES (CDR A) (CDR B))))

(DEFUN RDIFFERENCE* (A B)
       (RPLUS* A (CONS (MINUS (CAR B)) (CDR B))) )

(DEFUN RLESSP (A B)
       (LESSP (TIMES (CAR A) (CDR B))
	      (TIMES (CAR B) (CDR A)) ))


;;; This next function is to do what SOLVE2 should do in programmode
(defun multout (ROOTLIST)
       (progn
	(setq ROOTLIST (do ((rtlst)
			    (multlst)
			    (lunch ROOTLIST))
			   ((null lunch) (cons (reverse rtlst)
					       (reverse multlst)))
			   (setq rtlst (cons (car lunch) rtlst))
			   (setq multlst (cons (cadr lunch) multlst))
			   (setq lunch (cddr lunch))))
	(setq $multiplicities (cons '(MLIST)  (cdr ROOTLIST)))
	(car ROOTLIST)))

(declare (unspecial equations))
