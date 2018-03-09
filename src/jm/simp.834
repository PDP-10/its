;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1982 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module simp)

(DECLARE (SPECIAL EXPTRLSW RULESW $%E/_TO/_NUMLOG *INV* SUBSTP
		  $%EMODE $RADEXPAND TIMESINP *CONST* LIMITP
		  PRODS NEGPRODS SUMS NEGSUMS EXPANDP $DOMAIN $LISTARITH
		  $LOGSIMP $LOGEXPAND $LOGNUMER $LOGNEGINT $M1PBRANCH
		  EXPANDFLAG $MAPERROR $SCALARMATRIXP NOUNL
		  DERIVFLAG $RATSIMPEXPONS $KEEPFLOAT $RATPRINT
		  $DEMOIVRE *ZEXPTSIMP? %E-VAL %PI-VAL FMAPLVL
		  BIGFLOATZERO BIGFLOATONE $ASSUMESCALAR $SUBNUMSIMP
		  OPERS-LIST *OPERS-LIST WFLAG $DONTFACTOR *N
		  *OUT *IN VARLIST GENVAR $FACTORFLAG RADCANP)
	 (*EXPR PSQUOREM1 PNTHROOTP)
	 (*LEXPR FMAPL1 $LIMIT OUTERMAP1 $RATSIMP $EXPAND)
	 (FIXNUM FMAPLVL L1 L2 XN NARGS I (SIGNUM1))
	 (NOTYPE N)
	 (GENPREFIX SM)
	 (MUZZLED T))

;; General purpose simplification and conversion switches.

(DEFMVAR $FLOAT NIL
	 "Causes non-integral rational numbers to be converted to
	 floating point."
	 EVFLAG
	 SEE-ALSO $NUMER)

(DEFMVAR $NEGDISTRIB T
	 "Causes negations to be distributed over sums, e.g. -(A+B) is
	 simplified to -A-B.")

(DEFMVAR $NUMER NIL
	 "Causes some mathematical functions (including exponentiation)
	 with numerical arguments to be evaluated in floating point.
	 It causes variables in an expression which have been given
	 NUMERVALs to be replaced by their values.  It also turns
	 on the FLOAT switch."
	 SEE-ALSO ($NUMERVAL $FLOAT))

(DEFMVAR $SIMP T "Enables simplification.")

(DEFMVAR $SUMEXPAND NIL
	 "If TRUE, products of sums and exponentiated sums go into nested 
	 sums.")

(DEFMVAR $NUMER_PBRANCH NIL)

;; Switches dealing with matrices and non-commutative multiplication.

(DEFMVAR $DOSCMXPLUS NIL
	 "Causes SCALAR + MATRIX to return a matrix answer.  This switch
	 is not subsumed under DOALLMXOPS.")

(DEFMVAR $DOMXEXPT T
	 "Causes SCALAR^MATRIX([1,2],[3,4]) to return
	 MATRIX([SCALAR,SCALAR^2],[SCALAR^3,SCALAR^4]).  In general, this
	 transformation affects exponentiations where the base is a scalar
	 and the power is a matrix or list.")

(DEFMVAR $DOMXPLUS NIL)

(DEFMVAR $DOMXTIMES NIL)

(DEFMVAR $MX0SIMP T)

;; Switches dealing with expansion.

(DEFMVAR $EXPOP 0
	 "The largest positive exponent which will be automatically
	 expanded.  (X+1)^3 will be automatically expanded if
	 EXPOP is greater than or equal to 3."
	 FIXNUM
	 SEE-ALSO ($EXPON $MAXPOSEX $EXPAND))

(DEFMVAR $EXPON 0
	 "The largest negative exponent which will be automatically
	 expanded.  (X+1)^(-3) will be automatically expanded if
	 EXPON is greater than or equal to 3."
	 FIXNUM
	 SEE-ALSO ($EXPOP $MAXNEGEX $EXPAND))

(DEFMVAR $MAXPOSEX 1000.
	 "The largest positive  exponent which will be expanded by
	 the EXPAND command."
	 FIXNUM
	 SEE-ALSO ($MAXNEGEX $EXPOP $EXPAND))

(DEFMVAR $MAXNEGEX 1000.
	 "The largest negative exponent which will be expanded by
	 the EXPAND command."
	 FIXNUM
	 SEE-ALSO ($MAXPOSEX $EXPON $EXPAND))

;; Lisp level variables

(DEFMVAR DOSIMP NIL
	 "Causes SIMP flags to be ignored.  $EXPAND works by binding
	 $EXPOP to $MAXPOSEX, $EXPON to $MAXNEGEX, and DOSIMP to T.")

(DEFMVAR ERRORSW NIL
	 "Causes a throw to the tag ERRORSW when certain errors occur
	 rather than the printing of a message.  Kludgy substitute for
	 error signalling.")

(DEFMVAR DERIVSIMP T "Hack in SIMPDERIV for RWG")

;; The following SETQs should be replaced with DEFMVARS in the correct places.

(SETQ $ROOTSEPSILON 1.0E-7 $/%RNUM 0
      $GRINDSWITCH NIL $ALGEPSILON 100000000. $ALGDELTA 1.0E-5) 

(PROG2 (SETQ $LISTARITH T WFLAG NIL $LOGNUMER NIL EXPANDP NIL $DOMAIN '$REAL
	     $M1PBRANCH NIL $%E/_TO/_NUMLOG NIL $%EMODE T TIMESINP NIL
	     $TRUE T $FALSE NIL $ON T $OFF NIL %E-VAL (MGET '$%E '$NUMER)
	     %PI-VAL (MGET '$%PI '$NUMER) $LOGABS NIL $LOGNEGINT NIL
	     DERIVFLAG NIL $RATSIMPEXPONS NIL EXPTRLSW NIL $LOGEXPAND T
	     EXPANDFLAG NIL $RADEXPAND T *ZEXPTSIMP? NIL $SUBNUMSIMP NIL
	     RISCHPF NIL $LIMITDOMAIN '$COMPLEX $LOGSIMP T
;	     $MATCHIDENT T $MATCHASSOC T $MATCHCOMM T $MATCHCRE NIL
	     RISCHP NIL RP-POLYLOGP NIL *CONST* 0)
       (MAPC #'(LAMBDA (X) (MPUTPROP X T '$CONSTANT) (PUTPROP X T 'SYSCONST))
	     '($%PI $%I $%E $%PHI $INF $MINF $INFINITY %I $%GAMMA)))

(DEFPROP MNCTIMES T ASSOCIATIVE)
(DEFPROP LAMBDA T LISP-NO-SIMP)

(DOLIST (X '(MPLUS MTIMES MNCTIMES MEXPT MNCEXPT %SUM))
	(PUTPROP X (CONS X '(SIMP)) 'MSIMPIND))

(PROG1 '(OPERATORS properties)
       (MAPC #'(LAMBDA (X) (PUTPROP (CAR X) (CADR X) 'OPERATORS))
	     '((MPLUS SIMPLUS) (MTIMES SIMPTIMES) (MNCEXPT SIMPNCEXPT)
	       (MMINUS SIMPMIN) (%GAMMA SIMPGAMMA) (MFACTORIAL SIMPFACT)
	       (MNCTIMES SIMPNCT) (MQUOTIENT SIMPQUOT) (MEXPT SIMPEXPT)
	       (%LOG SIMPLN) (%SQRT SIMPSQRT) (%DERIVATIVE SIMPDERIV)
	       (MABS SIMPABS) (%SIGNUM SIMPSIGNUM)
	       (%INTEGRATE SIMPINTEG) (%LIMIT SIMP-LIMIT) ($EXP SIMPEXP)
	       (BIGFLOAT SIMPBIGFLOAT) (LAMBDA SIMPLAMBDA) (MDEFINE SIMPMDEF)
	       (MQAPPLY SIMPMQAPPLY) (%GAMMA SIMPGAMMA) (%ERF SIMPERF) 
	       ($BETA SIMPBETA) (%SUM SIMPSUM) (%BINOMIAL SIMPBINOCOEF) 
	       (%PLOG SIMPPLOG) (%PRODUCT SIMPPROD) (%GENFACT SIMPGFACT)
	       ($ATAN2 SIMPATAN2) ($MATRIX SIMPMATRIX) (%MATRIX SIMPMATRIX)
	       ($BERN SIMPBERN) ($EULER SIMPEULER))))

(DEFPROP $LI LISIMP SPECSIMP)
(DEFPROP $PSI PSISIMP SPECSIMP)

(DEFPROP $EQUAL T BINARY)
(DEFPROP $NOTEQUAL T BINARY)

;; The following definitions of ONEP and ONEP1 are bummed for speed, and should
;; be moved to a special place for implementation dependent code.
;; ONEP is the same as (EQUAL A 1), but does the check inline rather than
;; calling EQUAL (uses more instructions, so this isn't done by default).  ONEP
;; seems to be used very rarely, so it seems hardly worth the effort.  On the
;; Lisp Machine, this is probably more efficient as simply (EQUAL A 1).

(DEFMFUN ONEP (A) (AND (EQ (TYPEP A) 'FIXNUM) (= A 1)))

#-Franz
(DEFMFUN ONEP1 (A) (OR (EQUAL A 1) (EQUAL A 1.0) (EQUAL A BIGFLOATONE)))

#+Franz
(DEFUN ONEP1 (A)
  (LET ((TYPE (TYPEP A)))
       (COND ((EQ TYPE 'FIXNUM) (EQUAL A 1))
	     ((EQ TYPE 'FLONUM) (EQUAL A 1.0))
	     ((EQ TYPE 'LISPT) (EQUAL A BIGFLOATONE)))))

(DEFMFUN ZEROP1 (A) (IF (NUMBERP A) (ZEROP A) (ALIKE1 A BIGFLOATZERO)))

(DEFMFUN $BFLOATP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) 'BIGFLOAT)))

(DEFMFUN MNUMP (X)
  (OR (NUMBERP X) (AND (NOT (ATOM X)) (MEMQ (CAAR X) '(RAT BIGFLOAT)))))

;; EVEN works for any arbitrary lisp object since it does an integer
;; check first.  In other cases, you may want the Lisp EVENP function
;; which only works for integers.

(DEFMFUN EVEN (A) (AND (FIXP A) (NOT (ODDP A))))

(DEFMFUN RATNUMP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) 'RAT)))

(DEFMFUN MPLUSP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) 'MPLUS)))

(DEFMFUN MTIMESP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) 'MTIMES)))

(DEFMFUN MEXPTP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) 'MEXPT)))

(DEFMFUN MNCTIMESP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) 'MNCTIMES)))

(DEFMFUN MNCEXPTP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) 'MNCEXPT)))

(DEFMFUN MLOGP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) '%LOG)))

(DEFMFUN MMMINUSP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) 'MMINUS)))

(DEFMFUN MNEGP (X) (COND ((NUMBERP X) (MINUSP X))
			 ((OR (RATNUMP X) ($BFLOATP X)) (MINUSP (CADR X)))))

(DEFMFUN MQAPPLYP (E) (AND (NOT (ATOM E)) (EQ (CAAR E) 'MQAPPLY)))

(DEFMFUN RATDISREP (E) (SIMPLIFYA ($RATDISREP E) NIL))

(DEFMFUN SRATSIMP (E) (SIMPLIFYA ($RATSIMP E) NIL))

(DEFMFUN SIMPCHECK (E FLAG)
  (COND ((SPECREPP E) (SPECDISREP E)) (FLAG E) (T (SIMPLIFYA E NIL))))

(DEFMFUN MRATCHECK (E) (IF ($RATP E) (RATDISREP E) E))

(DEFMFUN $NUMBERP (E) (OR ($RATNUMP E) ($FLOATNUMP E) ($BFLOATP E)))

(DEFMFUN $INTEGERP (X)
  (OR (FIXP X)
      (AND ($RATP X) (FIXP (CADR X)) (EQUAL (CDDR X) 1))))

;; The call to $INTEGERP in the following two functions checks for a CRE 
;; rational number with an integral numerator and a unity denominator.

(DEFMFUN $ODDP (X)
  (COND ((FIXP X) (ODDP X))
	(($INTEGERP X) (ODDP (CADR X)))))

(DEFMFUN $EVENP (X)
  (COND ((FIXP X) (EVENP X))
	(($INTEGERP X) (NOT (ODDP (CADR X))))))

(DEFMFUN $FLOATNUMP (X)
  (OR (FLOATP X)
      (AND ($RATP X) (FLOATP (CADR X)) (ONEP1 (CDDR X)))))

(DEFMFUN $RATNUMP (X)
  (OR (FIXP X)
      (RATNUMP X)
      (AND ($RATP X) (FIXP (CADR X)) (FIXP (CDDR X)))))

(DEFMFUN $RATP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) 'MRAT)))

(DEFMFUN SPECREPCHECK (E) (IF (SPECREPP E) (SPECDISREP E) E))
  
;; Note that the following two functions are carefully coupled.

(DEFMFUN SPECREPP (E) (AND (NOT (ATOM E)) (MEMQ (CAAR E) '(MRAT MPOIS))))
  
(DEFMFUN SPECDISREP (E)
 (COND ((EQ (CAAR E) 'MRAT) (RATDISREP E))
;      ((EQ (CAAR E) 'MPOIS) ($OUTOFPOIS E))
       (T ($OUTOFPOIS E))))
  
(DEFMFUN $POLYSIGN (X) (SETQ X (CADR (RATF X)))
  (COND ((EQUAL X 0) 0) ((PMINUSP X) -1) (T 1)))

;; These check for the correct number of operands within Macsyma expressions,
;; not arguments in a procedure call as the name may imply.

(DEFMFUN ONEARGCHECK (L)
 (IF (OR (NULL (CDR L)) (CDDR L)) (WNA-ERR (CAAR L))))

(DEFMFUN TWOARGCHECK (L)
 (IF (OR (NULL (CDDR L)) (CDDDR L)) (WNA-ERR (CAAR L))))

(DEFMFUN WNA-ERR (OP) (MERROR "Wrong number of arguments to ~:@M" OP))

(DEFMFUN IMPROPER-ARG-ERR (EXP FN)
 (MERROR "Improper argument to ~:M:~%~M" FN EXP))

(DEFMFUN SUBARGCHECK (FORM SUB/# ARG/# FUN)
  (IF (OR (NOT (= (LENGTH (SUBFUNSUBS FORM)) SUB/#))
	  (NOT (= (LENGTH (SUBFUNARGS FORM)) ARG/#)))
      (MERROR "Wrong number of arguments or subscripts to ~:@M" FUN)))

;; Constructor and extractor primitives for subscripted functions, e.g.
;; F[1,2](X,Y).  SUBL is (1 2) and ARGL is (X Y).

;; These will be flushed when NOPERS is finished.  They will be macros in
;; NOPERS instead of functions, so we have to be careful that they aren't
;; mapped or applied anyplace.  What we really want is open-codable routines.

(DEFMFUN SUBFUNMAKES (FUN SUBL ARGL)
  `((MQAPPLY SIMP) ((,FUN SIMP ARRAY) . ,SUBL) . ,ARGL))

(DEFMFUN SUBFUNMAKE (FUN SUBL ARGL)
  `((MQAPPLY) ((,FUN SIMP ARRAY) . ,SUBL) . ,ARGL))

(DEFMFUN SUBFUNNAME (EXP) (CAAADR EXP))

(DEFMFUN SUBFUNSUBS (EXP) (CDADR EXP))

(DEFMFUN SUBFUNARGS (EXP) (CDDR EXP))

(DEFMFUN $NUMFACTOR (X)
  (SETQ X (SPECREPCHECK X))
  (COND ((MNUMP X) X)
	((ATOM X) 1)
	((NOT (EQ (CAAR X) 'MTIMES)) 1)
	((MNUMP (CADR X)) (CADR X))
	(T 1)))

(DEFUN SCALAR-OR-CONSTANT-P (X FLAG)
 (IF FLAG (NOT ($NONSCALARP X)) ($SCALARP X)))

(DEFMFUN $CONSTANTP (X)
 (COND ((ATOM X) (OR ($NUMBERP X) (MGET X '$CONSTANT)))
       ((MEMQ (CAAR X) '(RAT BIGFLOAT)) T)
       ((SPECREPP X) ($CONSTANTP (SPECDISREP X)))
       ((OR (MOPP (CAAR X)) (MGET (CAAR X) '$CONSTANT))
	(DO ((X (CDR X) (CDR X))) ((NULL X) T)
	    (IF (NOT ($CONSTANTP (CAR X))) (RETURN NIL))))))

(DEFUN CONSTANT (X)
 (COND ((SYMBOLP X) (MGET X '$CONSTANT))
       (($SUBVARP X)
	(AND (MGET (CAAR X) '$CONSTANT)
	     (DO ((X (CDR X) (CDR X))) ((NULL X) T)
		 (IF (NOT ($CONSTANTP (CAR X))) (RETURN NIL)))))))

(DEFUN CONSTANTP (X) (OR (NUMBERP X) (MGET X '$CONSTANT)))

(DEFUN CONSTTERMP (X) (AND ($CONSTANTP X) (NOT ($NONSCALARP X))))

(DEFMFUN $SCALARP (X) (OR (CONSTTERMP X) (EQ (SCALARCLASS X) '$SCALAR)))

(DEFMFUN $NONSCALARP (X) (EQ (SCALARCLASS X) '$NONSCALAR))

(DEFUN SCALARCLASS (EXP);  Returns $SCALAR, $NONSCALAR, or NIL (unknown).
       (COND ((ATOM EXP)
	      (COND ((MGET EXP '$NONSCALAR) '$NONSCALAR)
		    ((MGET EXP '$SCALAR) '$SCALAR)))
	     ((SPECREPP EXP) (SCALARCLASS (SPECDISREP EXP)))
;  If the function is declared scalar or nonscalar, then return.  If it isn't
;  explicitly declared, then try to be intelligent by looking at the arguments
;  to the function.
	     ((SCALARCLASS (CAAR EXP)))
;  <number> + <scalar> is SCALARP because that seems to be useful.  This should
;  probably only be true if <number> is a member of the field of scalars.
;  <number> * <scalar> is SCALARP since <scalar> + <scalar> is SCALARP.
;  Also, this has to be done to make <scalar> - <scalar> SCALARP.
	     ((MEMQ (CAAR EXP) '(MPLUS MTIMES))
	      (DO ((L (CDR EXP) (CDR L))) ((NULL L) '$SCALAR)
		  (IF (NOT (CONSTTERMP (CAR L)))
		      (RETURN (SCALARCLASS-LIST L)))))
	     ((AND (EQ (CAAR EXP) 'MQAPPLY) (SCALARCLASS (CADR EXP))))
	     ((MXORLISTP EXP) '$NONSCALAR)
;  If we can't find out anything about the operator, then look at the arguments
;  to the operator.  I think NIL should be returned at this point.  -cwh
	     (T (DO ((EXP (CDR EXP) (CDR EXP)) (L))
		    ((NULL EXP) (SCALARCLASS-LIST L))
		    (IF (NOT (CONSTTERMP (CAR EXP)))
		        (SETQ L (CONS (CAR EXP) L)))))))

;  Could also do <scalar> +|-|*|/ |^ <declared constant>, but this is not
;  always correct and could screw somebody.

;  SCALARCLASS-LIST takes a list of expressions as its argument.  If their
;  scalarclasses all agree, then that scalarclass is returned.

(DEFUN SCALARCLASS-LIST (LIST)
       (COND ((NULL LIST) NIL)
	     ((NULL (CDR LIST)) (SCALARCLASS (CAR LIST)))
	     (T (LET ((SC-CAR (SCALARCLASS (CAR LIST)))
		      (SC-CDR (SCALARCLASS-LIST (CDR LIST))))
		     (COND ((OR (EQ SC-CAR '$NONSCALAR)
				(EQ SC-CDR '$NONSCALAR))
			    '$NONSCALAR)
			   ((AND (EQ SC-CAR '$SCALAR) (EQ SC-CDR '$SCALAR))
			    '$SCALAR))))))

(DEFMFUN MBAGP (X) (AND (NOT (ATOM X)) (MEMQ (CAAR X) '(MEQUAL MLIST $MATRIX))))

(DEFMFUN MEQUALP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) 'MEQUAL)))

(DEFMFUN MXORLISTP (X) (AND (NOT (ATOM X)) (MEMQ (CAAR X) '(MLIST $MATRIX))))

(DEFUN MXORLISTP1 (X)
       (AND (NOT (ATOM X))
	    (OR (EQ (CAAR X) '$MATRIX)
		(AND (EQ (CAAR X) 'MLIST) $LISTARITH))))

(DEFMFUN CONSTFUN (X)
	 X  ; Arg ignored.  Function used for mapping down lists.
	 *CONST*)

(DEFUN CONSTMX (*CONST* X) (SIMPLIFYA (FMAPL1 'CONSTFUN X) T))

(DEFMFUN ISINOP (EXP VAR)  ; VAR is assumed to be an atom
 (COND ((ATOM EXP) NIL)
       ((AND (EQ (CAAR EXP) VAR) (NOT (MEMQ 'ARRAY (CDAR EXP)))))
       (T (DO EXP (CDR EXP) (CDR EXP) (NULL EXP)
	      (COND ((ISINOP (CAR EXP) VAR) (RETURN T)))))))

(DEFMFUN FREE (EXP VAR)
  (COND ((ALIKE1 EXP VAR) NIL)
	((ATOM EXP) T)
	(T (AND (FREE (CAAR EXP) VAR) (FREEL (CDR EXP) VAR)))))

(DEFMFUN FREEL (L VAR)
 (DO ((L L (CDR L))) ((NULL L) T)
     (COND ((NOT (FREE (CAR L) VAR)) (RETURN NIL)))))

(DEFMFUN FREEARGS (EXP VAR)
  (COND ((ALIKE1 EXP VAR) NIL)
	((ATOM EXP) T)
	(T (DO ((L (MARGS EXP) (CDR L))) ((NULL L) T)
	       (COND ((NOT (FREEARGS (CAR L) VAR)) (RETURN NIL)))))))

(DEFMFUN SIMPLIFYA (X Y)
  (COND ((ATOM X) (COND ((AND (EQ X '$%PI) $NUMER) %PI-VAL) (T X)))
	((NOT $SIMP) X)				
	((ATOM (CAR X))
	 (COND ((AND (CDR X) (ATOM (CDR X)))
		(MERROR "~%~S is a cons with an atomic cdr - SIMPLIFYA" X))
	       ((GET (CAR X) 'LISP-NO-SIMP)
		; this feature is to be used with care. it is meant to be
		; used to implement data objects with minimum of consing.
		; forms must not bash the DISPLA package. Only new forms
		; with carefully chosen names should use this feature.
		X)
	       (T (CONS (CAR X)
			(MAPCAR (FUNCTION (LAMBDA (X) (SIMPLIFYA X Y)))
				(CDR X))))))
	((EQ (CAAR X) 'RAT) (*RED1 X))
	((AND (NOT DOSIMP) (MEMQ 'SIMP (CDAR X))) X)
	((EQ (CAAR X) 'MRAT) X)
	((AND (MEMQ (CAAR X) '(MPLUS MTIMES MEXPT))
	      (MEMQ (GET (CAAR X) 'OPERATORS) '(SIMPLUS SIMPEXPT SIMPTIMES))
	      (NOT (MEMQ 'ARRAY (CDAR X))))
	 (COND ((EQ (CAAR X) 'MPLUS) (SIMPLUS X 1 Y))
	       ((EQ (CAAR X) 'MTIMES) (SIMPTIMES X 1 Y))
	       (T (SIMPEXPT X 1 Y))))
	((NOT (ATOM (CAAR X)))
	 (COND ((OR (EQ (CAAAR X) 'LAMBDA)
		    (AND (NOT (ATOM (CAAAR X))) (EQ (CAAAAR X) 'LAMBDA)))
		(MAPPLY (CAAR X) (CDR X) (CAAR X)))
	       (T (MERROR "Illegal form - SIMPLIFYA:~%~S" X))))
	((GET (CAAR X) 'OPERS)
	 (LET ((OPERS-LIST *OPERS-LIST)) (OPER-APPLY X Y)))
	((AND (EQ (CAAR X) 'MQAPPLY)
	      (OR (ATOM (CADR X))
		  (AND SUBSTP (OR (EQ (CAR (CADR X)) 'LAMBDA)
				  (EQ (CAAR (CADR X)) 'LAMBDA)))))
	 (COND ((OR (SYMBOLP (CADR X)) (NOT (ATOM (CADR X))))
		(SIMPLIFYA (CONS (CONS (CADR X) (CDAR X)) (CDDR X)) Y))
	       ((OR (NOT (MEMQ 'ARRAY (CDAR X))) (NOT $SUBNUMSIMP))
		(MERROR "Improper value in functional position:~%~M" X))
	       (T (CADR X))))
	(T (LET ((W (GET (CAAR X) 'OPERATORS)))
		(COND ((AND W (OR (NOT (MEMQ 'ARRAY (CDAR X))) (RULECHK (CAAR X))))
		       (FUNCALL W X 1 Y))
		      (T (SIMPARGS X Y)))))))


(DEFMFUN EQTEST (X CHECK)
      ((LAMBDA (Y)
	(COND ((OR (ATOM X) (EQ (CAAR X) 'RAT) (EQ (CAAR X) 'MRAT)
		   (MEMQ 'SIMP (CDAR X)))
	       X)
	      ((AND (EQ (CAAR X) (CAAR CHECK)) (EQUAL (CDR X) (CDR CHECK)))
	       (COND ((AND (NULL (CDAR CHECK))
			   (SETQ Y (GET (CAAR CHECK) 'MSIMPIND)))
		      (CONS Y (CDR CHECK)))
		     ((MEMQ 'SIMP (CDAR CHECK)) CHECK)
		     (T (CONS (CONS (CAAR CHECK)
				    (COND ((CDAR CHECK) (CONS 'SIMP (CDAR CHECK)))
					  (T '(SIMP))))
			      (CDR CHECK)))))
	      ((SETQ Y (GET (CAAR X) 'MSIMPIND)) (RPLACA X Y))
	      ((OR (MEMQ 'ARRAY (CDAR X))
		   (AND (EQ (CAAR X) (CAAR CHECK))
			(MEMQ 'ARRAY (CDAR CHECK))))
	       (RPLACA X (CONS (CAAR X) '(SIMP ARRAY))))
	      (T (RPLACA X (CONS (CAAR X) '(SIMP))))))
       NIL))

(DEFUN RULECHK (X) (OR (MGET X 'OLDRULES) (GET X 'RULES)))

(DEFMFUN RESIMPLIFY (X) (LET ((DOSIMP T)) (SIMPLIFYA X NIL)))

(DEFMFUN SSIMPLIFYA (X) (LET ((DOSIMP T)) (SIMPLIFYA X NIL)))  ; temporary

(DEFMFUN SIMPARGS (X Y)
 (IF (OR (EQ (GET (CAAR X) 'DIMENSION) 'DIMENSION-INFIX)
	 (GET (CAAR X) 'BINARY))
     (TWOARGCHECK X))
 (EQTEST
  (COND (Y X)
	(T (LET ((FLAG (MEMQ (CAAR X) '(MLIST MEQUAL))))
		(CONS (NCONS (CAAR X))
		      (MAPCAR #'(LAMBDA (J)
				 (COND (FLAG (SIMPLIFYA J NIL))
				       (T (SIMPCHECK J NIL))))
			      (CDR X))))))
  X))

(DEFMFUN ADDK (X Y)  ; X and Y are assumed to be already reduced
 (COND ((EQUAL X 0) Y)
       ((EQUAL Y 0) X)
       ((AND (NUMBERP X) (NUMBERP Y)) (PLUS X Y))
       ((OR ($BFLOATP X) ($BFLOATP Y)) ($BFLOAT (LIST '(MPLUS) X Y)))
       (T (PROG (G A B)
		(COND ((NUMBERP X)
		       (COND ((FLOATP X) (RETURN (PLUS X (FPCOFRAT Y))))
			     (T (SETQ X (LIST '(RAT) X 1)))))
		      ((NUMBERP Y)
		       (COND ((FLOATP Y) (RETURN (PLUS Y (FPCOFRAT X))))
			     (T (SETQ Y (LIST '(RAT) Y 1))))))
		(SETQ G (GCD (CADDR X) (CADDR Y)))
		(SETQ A (*QUO (CADDR X) G) B (*QUO (CADDR Y) G))
		(SETQ G (TIMESKL (LIST '(RAT) 1 G)
				 (LIST '(RAT)
				       (PLUS (TIMES (CADR X) B)
					     (TIMES (CADR Y) A))
				       (TIMES A B))))
		(RETURN (COND ((NUMBERP G) G)
			      ((EQUAL (CADDR G) 1) (CADR G)) 
			      ($FLOAT (FPCOFRAT G))
			      (T G)))))))

#-Franz
(DEFUN *RED1 (X)
 (COND ((MEMQ 'SIMP (CDAR X)) (COND ($FLOAT (FPCOFRAT X)) (T X)))
       (T (*RED (CADR X) (CADDR X)))))

(DEFUN *RED (N D)
       (COND ((ZEROP N) 0)
	     ((EQUAL D 1) N)
	     (T (LET ((U (GCD N D)))
		     (SETQ N (*QUO N U) D (*QUO D U))
		     (IF (MINUSP D) (SETQ N (MINUS N) D (MINUS D)))
		     (COND ((EQUAL D 1) N)
			   ($FLOAT (FPCOFRAT1 N D))
			   (T (LIST '(RAT SIMP) N D)))))))

(DEFUN NUM1 (A) (IF (NUMBERP A) A (CADR A)))

(DEFUN DENOM1 (A) (IF (NUMBERP A) 1 (CADDR A)))

(DEFMFUN TIMESK (X Y)  ; X and Y are assumed to be already reduced
 (COND ((EQUAL X 1) Y)
       ((EQUAL Y 1) X)
       ((AND (NUMBERP X) (NUMBERP Y)) (TIMES X Y))
       ((OR ($BFLOATP X) ($BFLOATP Y)) ($BFLOAT (LIST '(MTIMES) X Y)))
       ((FLOATP X) (TIMES X (FPCOFRAT Y)))
       ((FLOATP Y) (TIMES Y (FPCOFRAT X)))
       (T (TIMESKL X Y))))

(DEFUN TIMESKL (X Y)
 (PROG (U V G)
       (SETQ U (*RED (NUM1 X) (DENOM1 Y)))
       (SETQ V (*RED (NUM1 Y) (DENOM1 X)))
       (SETQ G (COND ((OR (EQUAL U 0) (EQUAL V 0)) 0)
		     ((EQUAL V 1) U)
		     ((AND (NUMBERP U) (NUMBERP V)) (TIMES U V))
		     (T (LIST '(RAT SIMP)
			      (TIMES (NUM1 U) (NUM1 V))
			      (TIMES (DENOM1 U) (DENOM1 V))))))
       (RETURN (COND ((NUMBERP G) G)
		     ((EQUAL (CADDR G) 1) (CADR G))
		     ($FLOAT (FPCOFRAT G))
		     (T G)))))

(DEFMFUN FPCOFRAT (RATNO) (FPCOFRAT1 (CADR RATNO) (CADDR RATNO)))

(DEFUN FPCOFRAT1 (NU D)
 (IF (AND (BIGP NU) (BIGP D))
     (LET ((SIGN (IF (MINUSP NU) (PLUSP D) (MINUSP D)))
	   (LN (HAULONG NU)) (LD (HAULONG D)))
	  (IF (> LN LD)
	      (SETQ D (HAIPART D #-FRANZ 35. #+FRANZ 30.)
		    NU (HAIPART NU (- LN (- LD #-FRANZ 35. #+FRANZ 30.))))
	      (SETQ NU (HAIPART NU #-FRANZ 35. #+FRANZ 30.)
		    D (HAIPART D (- LD (- LN #-FRANZ 35. #+FRANZ 30.)))))
	  (IF SIGN (SETQ NU (MINUS NU)))))
 (*QUO (FLOAT NU) D))

; Definition of FPCOFRAT1 below semi-coloned out on 3/7/81 by JPG 
; until it gives 0.0 for FLOAT(33^-33); rather than 8.9684807E+26
;(DEFUN FPCOFRAT1 (NU D)
; (DECLARE (FIXNUM FP-PREC SCALE-FAC))
; (IF (OR (BIGP NU) (BIGP D))
;     (LET* ((SIGN (IF (MINUSP NU) (PLUSP D) (MINUSP D)))
;	    (FP-PREC 35.)
;	;; upper bound on number of bits of mantissa supplied for f.p. numbers
;	;; 35. is big enough to be ok for mc,multics,lispm
;	;; RJF said he was going to use his own code for franz.
;	;; Does he want a #-Franz around this code? - BMT and JPG
;	    (SCALE-FAC (- (MAX FP-PREC (HAULONG NU))
;			  (MAX FP-PREC (HAULONG D)))))
;  	   (SETQ NU (HAIPART (ABS NU) FP-PREC) D (HAIPART (ABS D) FP-PREC))
;	   (IF SIGN (SETQ NU (MINUS NU)))
;	   (FSC (*QUO (FLOAT NU) D) SCALE-FAC))
;	;; Does the LISPM have FSC?
;      (*QUO (FLOAT NU) D)))

(DEFUN EXPTA (X Y) (COND ((EQUAL Y 1) X)
			 ((NUMBERP X) (EXPTB X (NUM1 Y)))
			 (($BFLOATP X) ($BFLOAT (LIST '(MEXPT) X Y)))
			 ((MINUSP (NUM1 Y))
			  (*RED (EXPTB (CADDR X) (MINUS (NUM1 Y)))
				(EXPTB (CADR X) (MINUS (NUM1 Y)))))
			 (T (*RED (EXPTB (CADR X) (NUM1 Y))
				  (EXPTB (CADDR X) (NUM1 Y))))))

(DEFUN EXPTB (A B)
 (COND ((EQUAL A %E-VAL) (EXP B))
       ((OR (FLOATP A) (NOT (MINUSP B))) (EXPT A B))
       (T (SETQ B (EXPT A (MINUS B))) (*RED 1 B))))

(DEFMFUN SIMPLUS (X W Z)  ; W must be 1
  (PROG (RES CHECK EQNFLAG MATRIXFLAG SUMFLAG)
	(IF (NULL (CDR X)) (RETURN 0))
	(SETQ CHECK X)
   START(SETQ X (CDR X))
	(IF (NULL X) (GO END))
	(SETQ W (IF Z (CAR X) (SIMPLIFYA (CAR X) NIL)))
   ST1  (COND
	 ((ATOM W) NIL)
	 ((EQ (CAAR W) 'MRAT)
	  (COND ((OR EQNFLAG MATRIXFLAG SUMFLAG (SPSIMPCASES (CDR X)))
		 (SETQ W (RATDISREP W)) (GO ST1))
		(T (RETURN (RATF (CONS '(MPLUS)
				       (NCONC (MAPCAR #'SIMPLIFY (CONS W (CDR X)))
					      (CDR RES))))))))
	 ((EQ (CAAR W) 'MEQUAL)
	  (SETQ EQNFLAG
		(IF (NOT EQNFLAG)
		    W
		    (LIST (CAR EQNFLAG)
			  (ADD2 (CADR EQNFLAG) (CADR W))
			  (ADD2 (CADDR EQNFLAG) (CADDR W)))))
	  (GO START))
	 ((MEMQ (CAAR W) '(MLIST $MATRIX)) 
	  (SETQ MATRIXFLAG
		(COND ((NOT MATRIXFLAG) W)
		      ((AND (OR $DOALLMXOPS $DOMXMXOPS $DOMXPLUS
				(AND (EQ (CAAR W) 'MLIST) ($LISTP MATRIXFLAG)))
			    (OR (NOT (EQ (CAAR W) 'MLIST)) $LISTARITH))
		       (ADDMX MATRIXFLAG W))
		      (T (SETQ RES (PLS W RES)) MATRIXFLAG)))
	  (GO START))
	 ((EQ (CAAR W) '%SUM) (SETQ SUMFLAG (SUMPLS SUMFLAG W)) (GO START)))
	(SETQ RES (PLS W RES))
	(GO START)
   END  (IF SUMFLAG (SETQ RES (PLS (IF (NULL (CDR SUMFLAG))
				       (CAR SUMFLAG)
				       (CONS '(MPLUS) SUMFLAG))
				   RES)))
	(SETQ RES (TESTP RES))
	(IF MATRIXFLAG
	    (SETQ RES (COND ((ZEROP1 RES) MATRIXFLAG)
			    ((AND (OR ($LISTP MATRIXFLAG)
				      $DOALLMXOPS $DOSCMXPLUS $DOSCMXOPS)
				  (OR (NOT ($LISTP MATRIXFLAG)) $LISTARITH))
			     (MXPLUSC RES MATRIXFLAG))
			    (T (TESTP (PLS MATRIXFLAG (PLS RES NIL)))))))
	(RETURN
	 (IF EQNFLAG
	     (LIST (CAR EQNFLAG)
		   (ADD2 (CADR EQNFLAG) RES)
		   (ADD2 (CADDR EQNFLAG) RES))
	     (EQTEST RES CHECK)))))

(DEFUN MXPLUSC (SC MX)
     (COND ((MPLUSP SC)
	    (SETQ SC (PARTITION-NS (CDR SC)))
	    (COND ((NULL (CAR SC)) (CONS '(MPLUS) (CONS MX (CADR SC))))
		  ((NOT (NULL (CADR SC)))
		   (CONS '(MPLUS)
			 (CONS (SIMPLIFY
				(OUTERMAP1 'MPLUS (CONS '(MPLUS) (CAR SC)) MX))
			       (CADR SC))))
		  (T (SIMPLIFY (OUTERMAP1 'MPLUS (CONS '(MPLUS) (CAR SC)) MX)))))
	   ((NOT (SCALAR-OR-CONSTANT-P SC $ASSUMESCALAR)) (LIST '(MPLUS) SC MX))
	   (T (SIMPLIFY (OUTERMAP1 'MPLUS SC MX)))))

(DEFUN PARTITION-NS (X)
 ((LAMBDA (SP NSP) ; SP = scalar part, NSP = nonscalar part
   (MAPC (FUNCTION 
	  (LAMBDA (Z) (COND ((SCALAR-OR-CONSTANT-P Z $ASSUMESCALAR)
			     (SETQ SP (CONS Z SP)))
			    (T (SETQ NSP (CONS Z NSP))))))
	 X)
   (LIST (NREVERSE SP) (NREVERSE NSP)))
  NIL NIL))

(DEFUN ADDMX (X1 X2)
 (LET (($DOSCMXOPS T) ($DOMXMXOPS T) ($LISTARITH T))
      (SIMPLIFY (FMAPL1 'MPLUS X1 X2))))

(DEFUN PLUSIN (X FM)
  (PROG (X1 FLAG CHECK W XNEW)
	(SETQ W 1)
	(COND ((MTIMESP X)
	       (SETQ CHECK X)
	       (COND ((MNUMP (CADR X)) (SETQ W (CADR X) X (CDDR X)))
		     (T (SETQ X (CDR X)))))
	      (T (SETQ X (LIST X))))
	(SETQ X1 (COND ((NULL (CDR X)) (CAR X)) (T (CONS '(MTIMES) X)))
	      XNEW (CONS '(MTIMES) (CONS W X)))
   START(COND ((NULL (CDR FM)) (GO LESS))
	      ((MTIMESP (CADR FM)) (GO TIMES))
	      ((AND (ALIKE1 X1 (CADR FM)) (NULL (CDR X))) (GO EQU))
	      ((GREAT X1 (CADR FM)) (GO GR)))
   LESS	(SETQ FLAG (EQTEST (TESTT XNEW) (OR CHECK '((FOO)))))
	(RETURN (CDR (RPLACD FM (CONS FLAG (CDR FM)))))
   GR	(SETQ FM (CDR FM))
	(GO START)
   EQU	(RPLACA (CDR FM) (CONS '(MTIMES SIMP) (CONS (ADDK 1 W) X)))
   DEL	(COND ((ONEP1 (CADADR FM)) (RPLACD (CADR FM) (CDDADR FM)) (RETURN (CDR FM)))
	      ((NOT (ZEROP1 (CADADR FM))) (RETURN (CDR FM))))
	(RETURN (RPLACD FM (CDDR FM)))
   TIMES(SETQ FLAG (CDADR FM))
	(COND ((OR (AND (MNUMP (CAR FLAG)) (ALIKE X (CDR FLAG))) (ALIKE1 X1 (CADR FM)))
	       (GO EQUT))
	      ((OR (AND (MNUMP (CAR FLAG)) (GREAT XNEW (CADR FM))) (GREAT X1 (CADR FM)))
	       (GO GR)))
	(GO LESS)
   EQUT (SETQ X1 (CONS '(MTIMES SIMP)
		       (CONS (ADDK (COND ((MNUMP (CADADR FM)) (SETQ FLAG T) (CADADR FM))
					 (T (SETQ FLAG NIL) 1))
				   W)
			     X)))
	(COND ((AND (ONEP1 (CADAR (RPLACA (CDR FM) X1)))
		    FLAG (NULL (CDDR (CDADR FM))))
	       (RPLACA (CDR FM) (CADR (CDADR FM))) (RETURN (CDR FM))))
	(GO DEL)))

(DEFMFUN SIMPLN (X Y Z)
   (ONEARGCHECK X)
   (COND ((ONEP1 (SETQ Y (SIMPCHECK (CADR X) Z))) (ADDK -1 Y))
	 ((ZEROP1 Y)
	  (COND (RADCANP (LIST '(%LOG SIMP) 0))
		((NOT ERRORSW) (MERROR "LOG(0) has been generated."))
		(T (*THROW 'ERRORSW T))))
	 ((EQ Y '$%E) 1)
	 ((RATNUMP Y)
	  (COND ((EQUAL (CADR Y) 1) (SIMPLN1 (LIST NIL (CADDR Y) -1)))
		((EQ $LOGEXPAND '$SUPER)
		 (SIMPLIFYA (LIST '(MPLUS) (SIMPLIFYA (LIST '(%LOG) (CADR Y)) T)
				  (SIMPLN1 (LIST NIL (CADDR Y) -1))) T))
		(T (EQTEST (LIST '(%LOG) Y) X))))
	 ((AND $LOGEXPAND (MEXPTP Y)) (SIMPLN1 Y))
	 ((AND (MEMQ $LOGEXPAND '($ALL $SUPER)) (MTIMESP Y))
	  (PROG (B)
		(SETQ Y (CDR Y))
	   LOOP (SETQ B (CONS (COND ((NOT (MEXPTP (CAR Y))) 
				     (SIMPLIFYA (LIST '(%LOG) (CAR Y)) T))
				    (T (SIMPLN1 (CAR Y)))) B))
		(COND ((NULL (SETQ Y (CDR Y)))
		       (RETURN (SIMPLIFYA (CONS '(MPLUS) B) T))))
		(GO LOOP)))
	 (($BFLOATP Y) ($BFLOAT (LIST '(%LOG) Y)))
	 ((OR (FLOATP Y) (AND $NUMER (FIXP Y)))
	  (COND ((PLUSP Y) (LOG Y))
		($LOGNUMER (COND ((EQUAL Y -1) 0) (T (LOG (MINUS Y)))))
		(T (ADD2 (LOG (MINUS Y)) (MUL2 '$%I %PI-VAL)))))
	 ((AND $LOGNEGINT (INTEGERP Y) (EQ ($SIGN Y) '$NEG))
	  (ADD2 '((MTIMES SIMP) $%I $%PI)
		(COND ((EQUAL Y -1) 0) (T (LIST '(%LOG SIMP) (NEG Y))))))
	 (T (EQTEST (LIST '(%LOG) Y) X))))

(DEFUN SIMPLN1 (W)
       (SIMPLIFYA (LIST '(MTIMES) (CADDR W)
			(SIMPLIFYA (LIST '(%LOG) (CADR W)) T)) T))

(DEFMFUN SIMPSQRT (X VESTIGIAL Z)
 VESTIGIAL ;Ignored.       
 (ONEARGCHECK X)
 (SIMPLIFYA (LIST '(MEXPT) (CADR X) '((RAT SIMP) 1 2)) Z))

(DEFMFUN SIMPQUOT (X Y Z)
 (TWOARGCHECK X)
 (COND ((AND (FIXP (CADR X)) (FIXP (CADDR X)) (NOT (ZEROP (CADDR X))))
	(*RED (CADR X) (CADDR X)))
       ((AND (NUMBERP (CADR X)) (NUMBERP (CADDR X)) (NOT (ZEROP (CADDR X))))
	(*QUO (CADR X) (CADDR X)))
       (T (SETQ Y (SIMPLIFYA (CADR X) Z))
	  (SETQ X (SIMPLIFYA (LIST '(MEXPT) (CADDR X) -1) Z))
	  (IF (EQUAL Y 1) X (SIMPLIFYA (LIST '(MTIMES) Y X) T)))))

;; Obsolete.  Use DIV*.  All references to this should now be flushed.
;; This definition will go away soon.

;(DEFUN QSNT (X Y) (SIMPLIFY (LIST '(MTIMES) X (LIST '(MEXPT) Y -1))))

(DEFMFUN SIMPABS (X Y Z) 
  (ONEARGCHECK X)
  (SETQ Y (SIMPCHECK (CADR X) Z))
  (COND ((NUMBERP Y) (ABS Y)) 
	((OR (RATNUMP Y) ($BFLOATP Y)) (LIST (CAR Y) (ABS (CADR Y)) (CADDR Y))) 
	((EQ (SETQ Z (CSIGN Y)) T) (CABS Y))
	((MEMQ Z '($POS $PZ)) Y) 
	((MEMQ Z '($NEG $NZ)) (NEG Y)) 
	((EQ Z '$ZERO) 0)
	((AND (MEXPTP Y) (FIXP (CADDR Y)))
	 (LIST (CAR Y) (SIMPABS (LIST '(MABS) (CADR Y)) NIL T) (CADDR Y)))
	((MTIMESP Y)
	 (MULN (MAPCAR #'(LAMBDA (U) (SIMPABS (LIST '(MABS) U) NIL T)) (CDR Y)) T))
	((MMINUSP Y) (LIST '(MABS SIMP) (NEG Y)))
	((MBAGP Y)
	 (CONS (CAR Y)
	       (MAPCAR #'(LAMBDA (U) (SIMPABS (LIST '(MABS) U) NIL T)) (CDR Y))))
	(T (EQTEST (LIST '(MABS) Y) X))))

(DEFUN PLS (X OUT)
       (PROG (FM)
	     (COND ((MTIMESP X) (SETQ X (TESTTNEG X))))
	     (COND ((NULL OUT)
		    (RETURN
		     (CONS '(MPLUS)
			   (COND ((MNUMP X) (NCONS X))
				 ((NOT (MPLUSP X))
				  (LIST 0 (COND ((ATOM X) X) (T (APPEND X NIL)))))
				 ((MNUMP (CADR X)) (APPEND (CDR X) NIL))
				 (T (CONS 0 (APPEND (CDR X) NIL)))))))
		   ((MNUMP X)
		    (RETURN (CONS '(MPLUS)
				  (COND ((MNUMP (CADR OUT))
					 (CONS (ADDK (CADR OUT) X) (CDDR OUT)))
					(T (CONS X (CDR OUT)))))))
		   ((NOT (MPLUSP X)) (PLUSIN X (CDR OUT)) (RETURN OUT)))
	     (RPLACA (CDR OUT)
		     (ADDK (COND ((MNUMP (CADR OUT)) (CADR OUT)) (T 0))
			   (COND ((MNUMP (CADR X)) (SETQ X (CDR X)) (CAR X)) (T 0))))
	     (SETQ FM (CDR OUT))
	START(COND ((NULL (SETQ X (CDR X))) (RETURN OUT)))
	     (SETQ FM (PLUSIN (CAR X) FM))
	     (GO START)))

(DEFUN TESTT (X)
 (COND ((MNUMP X) X)
       ((NULL (CDDR X)) (CADR X))
       ((ONEP1 (CADR X))
	(COND ((NULL (CDDDR X)) (CADDR X)) (T (RPLACD X (CDDR X)))))
       (T (TESTTNEG X))))

(DEFUN TESTTNEG (X)
 (COND ((AND (EQUAL (CADR X) -1) (NULL (CDDDR X)) (MPLUSP (CADDR X)) $NEGDISTRIB)
	(ADDN (MAPCAR (FUNCTION (LAMBDA (Z) (MUL2 -1 Z))) (CDADDR X)) T))
       (T X)))

(DEFUN TESTP (X) (COND ((ATOM X) 0)
		       ((NULL (CDDR X)) (CADR X))
		       ((ZEROP1 (CADR X))
			(COND ((NULL (CDDDR X)) (CADDR X)) (T (RPLACD X (CDDR X)))))
		       (T X)))

(DEFUN SIMPMIN (X VESTIGIAL Z)
  VESTIGIAL ;Ignored       
 (ONEARGCHECK X)
 (COND ((NUMBERP (CADR X)) (MINUS (CADR X)))
       ((ATOM (CADR X)) (LIST '(MTIMES SIMP) -1 (CADR X)))
       (T (SIMPLIFYA (LIST '(MTIMES) -1 (SIMPLIFYA (CADR X) Z)) T))))

(DEFMFUN SIMPTIMES (X W Z)  ; W must be 1
  (PROG (RES CHECK EQNFLAG MATRIXFLAG SUMFLAG)
	(IF (NULL (CDR X)) (RETURN 1))
	(SETQ CHECK X)
   START(SETQ X (CDR X))
	(COND ((ZEROP1 RES)
	       (COND ($MX0SIMP
		      (COND ((AND MATRIXFLAG (MXORLISTP1 MATRIXFLAG))
			     (RETURN (CONSTMX RES MATRIXFLAG)))
			    (EQNFLAG (RETURN (LIST '(MEQUAL SIMP)
						   (MUL2 RES (CADR EQNFLAG))
						   (MUL2 RES (CADDR EQNFLAG)))))
			    (T (DOLIST (U X)
				(COND ((MXORLISTP1 U)
				       (RETURN
					(SETQ RES (CONSTMX RES U))))
				      ((AND (MEXPTP U)
					    (MXORLISTP1 (CADR U))
					    ($NUMBERP (CADDR U)))
				       (RETURN
					(SETQ RES (CONSTMX RES (CADR U)))))
				      ((MEQUALP U)
				       (RETURN
					(SETQ RES (LIST '(MEQUAL SIMP)
						        (MUL2 RES (CADR U))
						        (MUL2 RES (CADDR U))))))))))))
	       (RETURN RES))
	      ((NULL X) (GO END)))
	(SETQ W (IF Z (CAR X) (SIMPLIFYA (CAR X) NIL)))
   ST1  (COND
	 ((ATOM W) NIL)
	 ((EQ (CAAR W) 'MRAT)
	  (COND ((OR EQNFLAG MATRIXFLAG SUMFLAG (SPSIMPCASES (CDR X)))
		 (SETQ W (RATDISREP W)) (GO ST1))
		(T (RETURN (RATF (CONS '(MTIMES)
				       (NCONC (MAPCAR #'SIMPLIFY (CONS W (CDR X)))
					      (CDR RES))))))))
	 ((EQ (CAAR W) 'MEQUAL)
	  (SETQ EQNFLAG
		(IF (NOT EQNFLAG)
		    W
		    (LIST (CAR EQNFLAG)
			  (MUL2 (CADR EQNFLAG) (CADR W))
			  (MUL2 (CADDR EQNFLAG) (CADDR W)))))
	  (GO START))
	 ((MEMQ (CAAR W) '(MLIST $MATRIX))
	  (SETQ MATRIXFLAG
		(COND ((NOT MATRIXFLAG) W)
		      ((AND (OR $DOALLMXOPS $DOMXMXOPS $DOMXTIMES)
			    (OR (NOT (EQ (CAAR W) 'MLIST)) $LISTARITH)
			    (NOT (EQ *INV* '$DETOUT)))
		       (STIMEX MATRIXFLAG W))
		      (T (SETQ RES (TMS W 1 RES)) MATRIXFLAG)))
	  (GO START))
	 ((AND (EQ (CAAR W) '%SUM) $SUMEXPAND)
	  (SETQ SUMFLAG (SUMTIMES SUMFLAG W)) (GO START)))
	(SETQ RES (TMS W 1 RES))
	(GO START)
   END  (COND ((MTIMESP RES) (SETQ RES (TESTT RES))))
	(COND (SUMFLAG (SETQ RES (COND ((OR (NULL RES) (EQUAL RES 1)) SUMFLAG)
				       ((NOT (MTIMESP RES))
					(LIST '(MTIMES) RES SUMFLAG))
				       (T (NCONC RES (LIST SUMFLAG)))))))
	(COND ((OR (ATOM RES)
		   (NOT (MEMQ (CAAR RES) '(MEXPT MTIMES)))		  
		   (AND (ZEROP $EXPOP) (ZEROP $EXPON))
		   EXPANDFLAG))
	      ((EQ (CAAR RES) 'MTIMES) (SETQ RES (EXPANDTIMES RES)))
	      ((AND (MPLUSP (CADR RES))
		    (EQ (TYPEP (CADDR RES)) 'FIXNUM)
		    (NOT (OR (GREATERP (CADDR RES) $EXPOP)
			     (GREATERP (MINUS (CADDR RES)) $EXPON))))
	       (SETQ RES (EXPANDEXPT (CADR RES) (CADDR RES)))))
	(COND (MATRIXFLAG 
	       (SETQ RES (COND ((NULL RES) MATRIXFLAG)
			       ((AND (OR ($LISTP MATRIXFLAG) $DOALLMXOPS 
					 (AND $DOSCMXOPS (NOT (MEMBER RES '(-1 -1.0))))
			;;; RES should only be -1 here (not = 1)
					 (AND $DOMXMXOPS (MEMBER RES '(-1 -1.0))))
				     (OR (NOT ($LISTP MATRIXFLAG)) $LISTARITH))
				(MXTIMESC RES MATRIXFLAG))
			       (T (TESTT (TMS MATRIXFLAG 1 (TMS RES 1 NIL))))))))
	(RETURN
	 (COND (EQNFLAG
		(IF (NULL RES) (SETQ RES 1))
		(LIST (CAR EQNFLAG)
		      (MUL2 (CADR EQNFLAG) RES)
		      (MUL2 (CADDR EQNFLAG) RES)))
	      (T (EQTEST RES CHECK))))))

(DEFUN SPSIMPCASES (L)
       (DO L L (CDR L) (NULL L)
	   (COND ((AND (NOT (ATOM (CAR L)))
		       (MEMQ (CAAAR L) '(MEQUAL MLIST $MATRIX %SUM)))
		  (RETURN T)))))

(DEFUN MXTIMESC (SC MX) 
 (LET (SIGN OUT)
   (AND (MTIMESP SC) (MEMBER (CADR SC) '(-1 -1.0)) 
	$DOSCMXOPS (NOT (OR $DOALLMXOPS $DOMXMXOPS $DOMXTIMES))
	(SETQ SIGN (CADR SC)) (RPLACA (CDR SC) NIL))
   (SETQ OUT ((LAMBDA (SCP*) 
	   (COND  ((NULL SCP*)(LIST '(MTIMES SIMP) SC MX))
		  ((AND (NOT (ATOM SCP*)) (NULL (CAR SCP*)))
		   (APPEND '((MTIMES)) (CADR SCP*) (LIST MX)))
		  ((OR (ATOM SCP*) (AND (NULL (CDR SCP*)) 
					(NOT (NULL (CDR SC)))
					(SETQ SCP* (CONS '(MTIMES) (CAR SCP*))))
		       (NOT (MTIMESP SC)))
			(SIMPLIFYA (OUTERMAP1 'MTIMES SCP* MX) NIL))
		  (T (APPEND '((MTIMES))
					(LIST (SIMPLIFYA 
					   (OUTERMAP1 'MTIMES
			 (CONS '(MTIMES) (CAR SCP*)) MX) T)) (CADR SCP*)))))
	(COND ((MTIMESP SC) (PARTITION-NS (CDR SC)))
	      ((NOT (SCALAR-OR-CONSTANT-P SC $ASSUMESCALAR)) NIL)
	      (T SC))))
   (COND (SIGN (COND ((MTIMESP OUT) (RPLACD OUT (CONS SIGN (CDR OUT))))
		     (T (LIST '(MTIMES) SIGN OUT))))
	 ((MTIMESP OUT) (TESTT OUT))
	 (T OUT))))

(DEFUN STIMEX (X Y) 
 (LET (($DOSCMXOPS T) ($DOMXMXOPS T) ($LISTARITH T))
      (SIMPLIFY (FMAPL1 'MTIMES X Y))))

;  TMS takes a simplified expression FACTOR and a cumulative
;  PRODUCT as arguments and modifies the cumulative product so
;  that the expression is now one of its factors.  The
;  exception to this occurs when a tellsimp rule is triggered.
;  The second argument is the POWER to which the expression is
;  to be raised within the product.

(DEFUN TMS (FACTOR POWER PRODUCT)
 ((LAMBDA (RULESW Z)
   (COND ((MPLUSP PRODUCT) (SETQ PRODUCT (LIST '(MTIMES SIMP) PRODUCT))))
   (COND ((ZEROP1 FACTOR)
	  (COND ((MNEGP POWER)
		 (COND (ERRORSW (*THROW 'ERRORSW T))
		       (T (MERROR "Division by 0"))))
		(T FACTOR)))
	 ((AND (NULL PRODUCT)
	       (OR (AND (MTIMESP FACTOR) (EQUAL POWER 1))
		   (AND (SETQ PRODUCT (LIST '(MTIMES) 1)) NIL)))
	  (APPEND '((MTIMES)) (COND ((MNUMP (CADR FACTOR)) NIL) (T '(1))) 
		  (CDR FACTOR) NIL))
	 ((MNUMP FACTOR)
	  (RPLACA (CDR PRODUCT) (TIMESK (CADR PRODUCT) (EXPTA FACTOR POWER)))
	  PRODUCT)
	 ((MTIMESP FACTOR)
	  (COND ((MNUMP (CADR FACTOR))
		 (SETQ FACTOR (CDR FACTOR))
		 (RPLACA (CDR PRODUCT)
			 (TIMESK (CADR PRODUCT) (EXPTA (CAR FACTOR) POWER)))))
	  (DO ((FACTOR-LIST (CDR FACTOR) (CDR FACTOR-LIST)))
	      ((OR (NULL FACTOR-LIST) (ZEROP1 PRODUCT))  PRODUCT)
	      (SETQ Z (TIMESIN (CAR FACTOR-LIST) (CDR PRODUCT) POWER))
	      (COND (RULESW (SETQ RULESW NIL)
			    (SETQ PRODUCT (TMS-FORMAT-PRODUCT Z))))))
	 (T (SETQ Z (TIMESIN FACTOR (CDR PRODUCT) POWER))
	    (COND (RULESW (TMS-FORMAT-PRODUCT Z)) (T PRODUCT)))))
  NIL NIL))

(DEFUN TMS-FORMAT-PRODUCT (X)
       (COND ((ZEROP1 X) X)
	     ((MNUMP X) (LIST '(MTIMES) X))
	     ((NOT (MTIMESP X)) (LIST '(MTIMES) 1 X))
	     ((NOT (MNUMP (CADR X))) (CONS '(MTIMES) (CONS 1 (CDR X))))
	     (T X)))

(DEFUN PLSK (X Y) (COND ($RATSIMPEXPONS (SRATSIMP (LIST '(MPLUS) X Y)))
			((AND (MNUMP X) (MNUMP Y)) (ADDK X Y))
			(T (ADD2 X Y))))

(DEFUN MULT (X Y) (COND ((AND (MNUMP X) (MNUMP Y)) (TIMESK X Y))
			(T (MUL2 X Y))))

(DEFMFUN SIMP-LIMIT (X VESTIGIAL Z) 
 VESTIGIAL ;Ignored.
 ((LAMBDA (L1 Y) 
   (COND ((NOT (OR (= L1 2) (= L1 4) (= L1 5))) (WNA-ERR '%LIMIT)))
   (SETQ Y (SIMPMAP (CDR X) Z))
   (COND ((AND (= L1 5) (NOT (MEMQ (CADDDR Y) '($PLUS $MINUS))))
	  (MERROR "4th arg to LIMIT must be either PLUS or MINUS:~%~M"
		  (CADDDR Y)))
	 ((MNUMP (CADR Y))
	  (MERROR "Wrong second arg to LIMIT:~%~M" (CADR Y)))
	 ((EQUAL (CAR Y) 1) 1)
	 (T (EQTEST (CONS '(%LIMIT) Y) X))))
  (LENGTH X) NIL))

(DEFMFUN SIMPINTEG (X VESTIGIAL Z) 
 VESTIGIAL ;Ignored.
 ((LAMBDA (L1 Y) 
   (COND ((NOT (OR (= L1 3) (= L1 5)))
	  (MERROR "Wrong number of arguments to 'INTEGRATE")))
   (SETQ Y (SIMPMAP (CDR X) Z))
   (COND ((MNUMP (CADR Y))
	  (MERROR "Attempt to integrate with respect to a number:~%~M" (CADR Y)))
	 ((AND (= L1 5) (ALIKE1 (CADDR Y) (CADDDR Y))) 0)
	 ((AND (= L1 5) (FREE (SETQ Z (SUB (CADDDR Y) (CADDR Y))) '$%I)
	       (EQ ($SIGN Z) '$NEG))
	  (NEG (SIMPLIFYA (LIST '(%INTEGRATE) (CAR Y) (CADR Y) (CADDDR Y) (CADDR Y)) T)))
	 ((EQUAL (CAR Y) 1)
	  (COND ((= L1 3) (CADR Y))
		(T (COND ((OR (AMONG '$INF Z) (AMONG '$MINF Z)) (INFSIMP Z))
			 (T Z)))))
	 (T (EQTEST (CONS '(%INTEGRATE) Y) X))))
  (LENGTH X) NIL))

(DEFMFUN SIMPBIGFLOAT (X VESTIGIAL SIMP-FLAG)
       VESTIGIAL ;Ignored.
       SIMP-FLAG ;No interesting subexpressions
       (BIGFLOATM* X))

(DEFMFUN SIMPEXP (X VESTIGIAL Z)
 VESTIGIAL ;Ignored.
 (ONEARGCHECK X) (SIMPLIFYA (LIST '(MEXPT) '$%E (CADR X)) Z))

(DEFMFUN SIMPLAMBDA (X VESTIGIAL SIMP-FLAG)
       VESTIGIAL ;Ignored.
       SIMP-FLAG ;No interesting subexpressions
       (CONS '(LAMBDA SIMP) (CDR X)))

(DEFMFUN SIMPMDEF (X VESTIGIAL SIMP-FLAG)
       VESTIGIAL ;Ignored.
       SIMP-FLAG ;No interesting subexpressions
       (TWOARGCHECK X)
       (CONS '(MDEFINE SIMP) (CDR X)))

(DEFUN SIMPMAP (E Z) (MAPCAR #'(LAMBDA (U) (SIMPCHECK U Z)) E))

(defmfun infsimp (e)
 (let ((x ($expand e 1 1)))
      (cond ((or (not (free x '$ind)) (not (free x '$und))
		 (not (free x '$zeroa)) (not (free x '$zerob))
		 (not (free x '$infinity))
		 (mbagp x))
	     (infsimp2 x e))
	    ((and (free x '$inf) (free x '$minf)) x)
	    (t (infsimp1 x e)))))

(defun infsimp1 (x e)
  (let ((minf-coef (coeff x '$minf 1))
	(inf-coef (coeff x '$inf 1)))
    (cond ((or (and (equal minf-coef 0)
		    (equal inf-coef 0))
	       (and (not (free minf-coef '$inf))
		    (not (free inf-coef '$minf)))
	       (let ((new-exp (sub (add2 (mul2 minf-coef '$minf)
					 (mul2 inf-coef '$inf))
				   x)))
		 (and (not (free new-exp '$inf))
		      (not (free new-exp '$minf)))))
	   (infsimp2 x e))
	  (t (let ((sign-minf-coef ($asksign minf-coef))
		   (sign-inf-coef ($asksign inf-coef)))
	       (cond ((or (and (eq sign-inf-coef '$zero)
			       (eq sign-minf-coef '$neg))
			  (and (eq sign-inf-coef '$pos)
			       (eq sign-minf-coef '$zero))
			  (and (eq sign-inf-coef '$pos)
			       (eq sign-minf-coef '$neg)))  '$inf)
		     ((or (and (eq sign-inf-coef '$zero)
			       (eq sign-minf-coef '$pos))
			  (and (eq sign-inf-coef '$neg)
			       (eq sign-minf-coef '$zero))
			  (and (eq sign-inf-coef '$neg)
			       (eq sign-minf-coef '$pos)))  '$minf)
		     ((or (and (eq sign-inf-coef '$pos)
			       (eq sign-minf-coef '$neg))
			  (and (eq sign-inf-coef '$neg)
			       (eq sign-minf-coef '$neg)))  '$und)))))))

(defun infsimp2 (x e)
 (setq x ($limit x))
 (if (isinop x '%limit) e x))

(DEFMFUN SIMPDERIV (X Y Z)
  (PROG (FLAG W U)
	(COND ((NOT (EVEN (LENGTH X)))
	       (COND ((AND (CDR X) (NULL (CDDDR X))) (NCONC X '(1)))
		     (T (WNA-ERR '%DERIVATIVE)))))
	(SETQ W (CONS '(%DERIVATIVE) (SIMPMAP (CDR X) Z)))
	(SETQ Y (CADR W))
	(DO U (CDDR W) (CDDR U) (NULL U)
	    (COND ((MNUMP (CAR U))
		   (MERROR "Attempt to differentiate with respect to a number:~%~M"
			   (CAR U)))))
	(COND ((OR (ZEROP1 Y)
		   (AND (OR (MNUMP Y) (AND (ATOM Y) (CONSTANT Y)))
			(OR (NULL (CDDR W))
			    (AND (NOT (ALIKE1 Y (CADDR W)))
				 (DO U (CDDR W) (CDDR U) (NULL U)
				     (COND ((AND (NUMBERP (CADR U)) (NOT (ZEROP (CADR U))))
					    (RETURN T))))))))
	       (RETURN 0))
	      ((AND (NOT (ATOM Y)) (EQ (CAAR Y) '%DERIVATIVE) DERIVSIMP)
	       (RPLACD W (APPEND (CDR Y) (CDDR W)))))
	(IF (NULL (CDDR W))
	    (RETURN (IF (NULL DERIVFLAG) (LIST '(%DEL SIMP) Y) (DERIV (CDR W)))))
	(SETQ U (CDR W))
   ZTEST(COND ((NULL U) (GO NEXT))
	      ((ZEROP1 (CADDR U)) (RPLACD U (CDDDR U)))
	      (T (SETQ U (CDDR U))))
	(GO ZTEST)
   NEXT (COND ((NULL (CDDR W)) (RETURN Y))
	      ((AND (NULL (CDDDDR W)) (ONEP (CADDDR W))
		    (ALIKE1 (CADR W) (CADDR W)))
	       (RETURN 1)))
   AGAIN(SETQ Z (CDDR W))
   SORT	(COND ((NULL (CDDR Z)) (GO LOOP))
	      ((ALIKE1 (CAR Z) (CADDR Z))
	       (RPLACA (CDDDR Z) (ADD2 (CADR Z) (CADDDR Z)))
	       (RPLACD Z (CDDDR Z)))
	      ((GREAT (CAR Z) (CADDR Z))
	       (LET ((U1 (CAR Z)) (U2 (CADR Z)) (V1 (CADDR Z)) (V2 (CADDDR Z)))
		    (SETQ FLAG T) (RPLACA Z V1)
		    (RPLACD Z (CONS V2 (CONS U1 (CONS U2 (CDDDDR Z))))))))
	(COND ((SETQ Z (CDDR Z)) (GO SORT)))
   LOOP	(COND ((NULL FLAG) (RETURN (COND ((NULL DERIVFLAG) (EQTEST W X))
					 (T (DERIV (CDR W)))))))
	(SETQ FLAG NIL)
	(GO AGAIN)))

(DEFMFUN SIGNUM1 (X)
 (COND ((MNUMP X)
	(SETQ X (NUM1 X)) (COND ((PLUSP X) 1) ((MINUSP X) -1) (T 0))) 
       ((ATOM X) 1)
       ((MPLUSP X) (IF EXPANDP 1 (SIGNUM1 (CAR (LAST X)))))
       ((MTIMESP X) (IF (MPLUSP (CADR X)) 1 (SIGNUM1 (CADR X))))
       (T 1)))

(DEFMFUN SIMPSIGNUM (X Y Z) 
  (ONEARGCHECK X)
  (SETQ Y (SIMPCHECK (CADR X) Z))
  (COND ((MNUMP Y)
	 (SETQ Y (NUM1 Y)) (COND ((PLUSP Y) 1) ((MINUSP Y) -1) (T 0))) 
	((EQ (SETQ Z (CSIGN Y)) T) (EQTEST (LIST '(%SIGNUM) Y) X))
	((EQ Z '$POS) 1) 
	((EQ Z '$NEG) -1) 
	((EQ Z '$ZERO) 0) 
	((MMINUSP Y) (MUL2 -1 (LIST '(%SIGNUM SIMP) (NEG Y)))) 
	(T (EQTEST (LIST '(%SIGNUM) Y) X))))

(DEFMFUN EXPTRL (R1 R2)
  (COND ((EQUAL R2 1) R1)
	((EQUAL R2 1.0) (COND ((MNUMP R1) (ADDK 0.0 R1)) (T R1)))
	((EQUAL R2 BIGFLOATONE) (COND ((MNUMP R1) ($BFLOAT R1)) (T R1)))
	((ZEROP1 R1)
	 (COND ((OR (ZEROP1 R2) (MNEGP R2))
		(COND ((NOT ERRORSW)
		       (MERROR "~M has been generated" (LIST '(MEXPT) R1 R2)))
		      (T (*THROW 'ERRORSW T))))
	       (T (ZERORES R1 R2))))
	((OR (ZEROP1 R2) (ONEP1 R1))
	 (COND ((OR ($BFLOATP R1) ($BFLOATP R2)) BIGFLOATONE)
	       ((OR (FLOATP R1) (FLOATP R2)) 1.0)
	       (T 1)))
	((OR ($BFLOATP R1) ($BFLOATP R2)) ($BFLOAT (LIST '(MEXPT) R1 R2)))
	((AND (NUMBERP R1) (FIXP R2)) (EXPTB R1 R2))
	((AND (NUMBERP R1) (FLOATP R2) (EQUAL R2 (FLOAT (FIX R2))))
	 (EXPTB (FLOAT R1) (FIX R2)))
	((OR $NUMER (AND (FLOATP R2) (OR (PLUSP (NUM1 R1)) $NUMER_PBRANCH)))
	 (LET (Y)
	   (COND ((MINUSP (SETQ R1 (ADDK 0.0 R1)))
		  (COND ((OR $NUMER_PBRANCH (EQ $DOMAIN '$COMPLEX))
		;; for R1<0: R1^R2 = (-R1)^R2*cos(pi*R2) + i*(-R1)^R2*sin(pi*R2)
			 (SETQ R2 (ADDK 0.0 R2))
			 (SETQ Y (EXPTRL (-$ R1) R2) R2 (TIMES %PI-VAL R2))
			 (ADD2 (TIMES Y (COS R2))
			       (LIST '(MTIMES SIMP) (TIMES Y (SIN R2)) '$%I)))
			(T (SETQ Y (LET ($NUMER $FLOAT $KEEPFLOAT $RATPRINT)
					(POWER -1 (RATF R2))))
			   (SETQ Y (IF (AND (MEXPTP Y) (EQUAL (CADR Y) -1))
				       (LIST '(MEXPT SIMP) -1 (FPCOFRAT (CADDR Y)))
				       (SSIMPLIFYA Y)))
			   (MUL2 Y (EXPTRL (-$ R1) R2)))))
		 ((EQUAL (SETQ R2 (ADDK 0.0 R2)) (FLOAT (FIX R2))) (EXPTB R1 (FIX R2)))
		 ((AND (EQUAL (SETQ Y (*$ 2.0 R2)) (FLOAT (FIX Y))) (NOT (EQUAL R1 %E-VAL)))
		  (EXPTB (SQRT R1) (FIX Y)))
		 (T (EXP (TIMES R2 (LOG R1)))))))
	((FLOATP R2) (LIST '(MEXPT SIMP) R1 R2))
	((FIXP R2)
	 (COND ((MINUSP R2)
		(EXPTRL (COND ((EQUAL (ABS (CADR R1)) 1) (TIMES (CADR R1) (CADDR R1)))
			      ((MINUSP (CADR R1))
			       (LIST '(RAT) (MINUS (CADDR R1)) (MINUS (CADR R1))))
			      (T (LIST '(RAT) (CADDR R1) (CADR R1))))
			(MINUS R2)))
	       (T (LIST '(RAT SIMP) (EXPTB (CADR R1) R2) (EXPTB (CADDR R1) R2)))))
	((AND (FLOATP R1) (ALIKE1 R2 '((RAT) 1 2)))
	 (COND ((MINUSP R1) (LIST '(MTIMES SIMP) (SQRT (MINUS R1)) '$%I)) (T (SQRT R1))))
	((AND (FLOATP R1) (ALIKE1 R2 '((RAT) -1 2)))
	 (COND ((MINUSP R1) (LIST '(MTIMES SIMP) (//$ -1.0 (SQRT (MINUS R1))) '$%I))
	       (T (//$ 1.0 (SQRT R1)))))
	((AND (FLOATP R1) (PLUSP R1)) (EXPTRL R1 (FPCOFRAT R2)))
	(EXPTRLSW (LIST '(MEXPT SIMP) R1 R2))
	(T ((LAMBDA (EXPTRLSW)
	     (SIMPTIMES
	      (LIST '(MTIMES)
		    (EXPTRL R1 (*QUO (CADR R2) (CADDR R2)))
		    ((LAMBDA (Y Z)
		      (COND ((MEXPTP Y) (LIST (CAR Y) (CADR Y) (MUL2 (CADDR Y) Z)))
			    (T (POWER Y Z))))
		     (LET ($KEEPFLOAT $RATPRINT) (SIMPNRT R1 (CADDR R2)))
		     (REMAINDER (CADR R2) (CADDR R2))))
	      1 T))
	    T))))

(DEFMFUN SIMPEXPT (X Y Z)
  (PROG (GR POT CHECK RES RULESW W MLPGR MLPPOT)
	(SETQ CHECK X)
	(COND (Z (SETQ GR (CADR X) POT (CADDR X)) (GO CONT)))
	(TWOARGCHECK X)
	(SETQ GR (SIMPLIFYA (CADR X) NIL))
	(SETQ POT (SIMPLIFYA (IF $RATSIMPEXPONS ($RATSIMP (CADDR X)) (CADDR X)) NIL))
   CONT	(COND (($RATP POT) (SETQ POT (RATDISREP POT)) (GO CONT))
	      (($RATP GR)
	       (COND ((MEMQ 'TRUNC (CAR GR)) (RETURN (SRF (LIST '(MEXPT) GR POT))))
		     ((FIXP POT)
		      (LET ((VARLIST (CADDAR GR)) (GENVAR (CADDDR (CAR GR))))
			   (RETURN (RATREP* (LIST '(MEXPT) GR POT)))))
		     (T (SETQ GR (RATDISREP GR)) (GO CONT))))
	      ((OR (SETQ MLPGR (MXORLISTP GR)) (SETQ MLPPOT (MXORLISTP POT)))
	       (GO MATRIX))
	      ((ONEP1 POT) (GO ATGR))
	      ((OR (ZEROP1 POT) (ONEP1 GR)) (GO RETNO))
	      ((ZEROP1 GR)
	       (COND ((OR (MNEGP POT) (AND *ZEXPTSIMP? (EQ ($ASKSIGN POT) '$NEG)))
		      (COND ((NOT ERRORSW) (MERROR "Division by 0"))
			    (T (*THROW 'ERRORSW T))))
		     ((NOT (FREE POT '$%I))
		      (COND ((NOT ERRORSW)
			     (MERROR "0 to a complex quantity has been generated."))
			    (T (*THROW 'ERRORSW T))))
		     (T (RETURN (ZERORES GR POT)))))
	      ((AND (MNUMP GR) (MNUMP POT)
		    (OR (NOT (RATNUMP GR)) (NOT (RATNUMP POT))))
	       (RETURN (EQTEST (EXPTRL GR POT) CHECK)))
	      ((EQ GR '$%I) (RETURN (%ITOPOT POT)))
	      ((AND (NUMBERP GR) (MINUSP GR) (MEVENP POT)) (SETQ GR (MINUS GR)) (GO CONT))
	      ((AND (NUMBERP GR) (MINUSP GR) (MODDP POT))
	       (RETURN (MUL2 -1 (POWER (MINUS GR) POT))))
	      ((AND (EQUAL GR -1) (INTEGERP POT) (MMINUSP POT))
	       (SETQ POT (NEG POT)) (GO CONT))
	      ((AND (EQUAL GR -1) (INTEGERP POT) (MTIMESP POT)
		    (= (LENGTH POT) 3) (EQ (TYPEP (CADR POT)) 'FIXNUM)
		    (ODDP (CADR POT)) (INTEGERP (CADDR POT)))
	       (SETQ POT (CADDR POT)) (GO CONT))
	      ((ATOM GR) (GO ATGR))
	      ((AND (EQ (CAAR GR) 'MABS)
		    (EVNUMP POT)
		    (OR (AND (EQ $DOMAIN '$REAL) (NOT (DECL-COMPLEXP (CADR GR))))
			(AND (EQ $DOMAIN '$COMPLEX) (DECL-REALP (CADR GR)))))
	       (RETURN (POWER (CADR GR) POT)))
	      ((EQ (CAAR GR) 'MEQUAL)
	       (RETURN (EQTEST (LIST (NCONS (CAAR GR))
				     (POWER (CADR GR) POT)
				     (POWER (CADDR GR) POT))
			       GR)))
	      ((EQ (TYPEP POT) 'SYMBOL) (GO OPP))
	      ((EQ (CAAR GR) 'MEXPT) (GO E1))
	      ((AND (EQ (CAAR GR) '%SUM) $SUMEXPAND (FIXP POT)
		    (SIGNP G POT) (LESSP POT $MAXPOSEX))
	       (RETURN (DO ((I (1- POT) (1- I))
			    (AN GR (SIMPTIMES (LIST '(MTIMES) AN GR) 1 T)))
			   ((SIGNP E I) AN))))
	      ((EQUAL POT -1) (RETURN (EQTEST (TESTT (TMS GR POT NIL)) CHECK)))
	      ((EQ (TYPEP POT) 'FIXNUM)
	       (RETURN (EQTEST (COND ((AND (MPLUSP GR)
					   (NOT (OR (GREATERP POT $EXPOP)
						    (GREATERP (MINUS POT) $EXPON))))
				      (EXPANDEXPT GR POT))
				     (T (SIMPLIFYA (TMS GR POT NIL) T)))
			       CHECK))))
   OPP	(COND ((EQ (CAAR GR) 'MEXPT) (GO E1))
	      ((EQ (CAAR GR) 'RAT)
	       (RETURN (MUL2 (POWER (CADR GR) POT) (POWER (CADDR GR) (MUL2 -1 POT)))))
	      ((NOT (EQ (CAAR GR) 'MTIMES)) (GO UP))
	      ((OR (EQ $RADEXPAND '$ALL) (AND $RADEXPAND (SIMPLEXPON POT)))
	       (SETQ RES (LIST 1)) (GO START))
	      ((AND (OR (NOT (NUMBERP (CADR GR))) (EQUAL (CADR GR) -1))
		    (SETQ W (MEMBER ($NUM GR) '(1 -1))))
	       (SETQ POT (MULT -1 POT) GR (MUL2 (CAR W) ($DENOM GR))) (GO CONT))
	      ((NOT $RADEXPAND) (GO UP)))
   (RETURN (DO ((L (CDR GR) (CDR L)) (RES (NCONS 1)) (RAD))
	       ((NULL L)
		(COND ((EQUAL RES '(1))
		       (EQTEST (LIST '(MEXPT) GR POT) CHECK))
		      ((NULL RAD) (TESTT (CONS '(MTIMES SIMP) RES)))
		      (T (SETQ RAD (POWER*	; RADEXPAND=()?
				    (CONS '(MTIMES) (NREVERSE RAD)) POT))
			 (COND ((NOT (ONEP1 RAD))
				(SETQ RAD (TESTT (TMS RAD 1 (CONS '(MTIMES) RES))))
				(COND (RULESW (SETQ RULESW NIL RES (CDR RAD))))))
			 (EQTEST (TESTT (CONS '(MTIMES) RES)) CHECK))))
	       (SETQ Z (COND ((NOT (FREE (CAR L) '$%I)) '$PNZ)
			     (T ($SIGN (CAR L)))))
	       (SETQ W (COND ((MEMQ Z '($NEG $NZ))
			      (SETQ RAD (CONS -1 RAD)) (MULT -1 (CAR L)))
			     (T (CAR L))))
	       (COND ((ONEP1 W))
		     ((ALIKE1 W GR) (RETURN (LIST '(MEXPT SIMP) GR POT)))
;not needed?	     ((MEXPTP W)
;		      (SETQ Z (LIST '(MEXPT) (CAR L) POT))
;		      (COND ((ALIKE1 Z (SETQ Z (SIMPLIFYA Z NIL)))
;			     (SETQ RAD (CONS W RAD)))
;			    (T (SETQ W (TIMESIN Z RES 1)))))
		     ((MEMQ Z '($PN $PNZ)) (SETQ RAD (CONS W RAD)))
		     (T (SETQ W (TESTT (TMS (SIMPLIFYA (LIST '(MEXPT) W POT) T)
					    1 (CONS '(MTIMES) RES))))))
	       (COND (RULESW (SETQ RULESW NIL RES (CDR W))))))
   START(COND ((AND (CDR RES) (ONEP1 (CAR RES)) (RATNUMP (CADR RES)))
	       (SETQ RES (CDR RES))))
	(COND ((NULL (SETQ GR (CDR GR)))
	       (RETURN (EQTEST (TESTT (CONS '(MTIMES) RES)) CHECK)))
	      ((MEXPTP (CAR GR))
	       (SETQ Y (LIST (CAAR GR) (CADAR GR) (MULT (CADDAR GR) POT))))
	      ((EQ (CAR GR) '$%I) (SETQ Y (%ITOPOT POT)))
	      ((MNUMP (CAR GR)) (SETQ Y (LIST '(MEXPT) (CAR GR) POT)))
	      (T (SETQ Y (LIST '(MEXPT SIMP) (CAR GR) POT))))
	(SETQ W (TESTT (TMS (SIMPLIFYA Y T) 1 (CONS '(MTIMES) RES))))
	(COND (RULESW (SETQ RULESW NIL RES (CDR W))))
	(GO START)
   RETNO(RETURN (EXPTRL GR POT))
   ATGR (COND ((ZEROP1 POT) (GO RETNO))
	      ((ONEP1 POT)
	       ((LAMBDA (Y)
		 (COND ((AND Y (FLOATP Y) (OR $NUMER (NOT (EQUAL POT 1))))
			(RETURN
			 (COND ((AND (EQ GR '$%E) (EQUAL POT BIGFLOATONE))
				($BFLOAT '$%E))
			       (T Y))))
		       (T (GO RETNO))))
		(MGET GR '$NUMER)))
	      ((EQ GR '$%E)
	       (COND (($BFLOATP POT) (RETURN ($BFLOAT (LIST '(MEXPT) '$%E POT))))
		     ((OR (FLOATP POT) (AND $NUMER (FIXP POT)))
		      (RETURN (EXP POT)))
		     ((AND $LOGSIMP (AMONG '%LOG POT)) (RETURN (%ETOLOG POT)))
		     ((AND $DEMOIVRE (SETQ Z (DEMOIVRE POT))) (RETURN Z))
		     ((AND $%EMODE (SETQ Z (%ESPECIAL POT))) (RETURN Z))))
	      (T ((LAMBDA (Y) (AND Y (FLOATP Y)
				   (OR (FLOATP POT) (AND $NUMER (FIXP POT)))
				   (RETURN (EXPTRL Y POT)))) (MGET GR '$NUMER))))
   UP	(RETURN (EQTEST (LIST '(MEXPT) GR POT) CHECK))
   MATRIX
   (COND ((ZEROP1 POT)
	  (COND ((MXORLISTP1 GR) (RETURN (CONSTMX (ADDK 1 POT) GR))) (T (GO RETNO))))
	 ((ONEP1 POT) (RETURN GR))
	 ((OR $DOALLMXOPS $DOSCMXOPS $DOMXEXPT)
	  (COND ((OR (AND MLPGR (OR (NOT ($LISTP GR)) $LISTARITH)
				(SCALAR-OR-CONSTANT-P POT $ASSUMESCALAR))
		     (AND $DOMXEXPT MLPPOT (OR (NOT ($LISTP POT)) $LISTARITH)
				 (SCALAR-OR-CONSTANT-P GR $ASSUMESCALAR)))
		 (RETURN (SIMPLIFYA (OUTERMAP1 'MEXPT GR POT) T)))
		(T (GO UP))))
	((AND $DOMXMXOPS (MEMBER POT '(-1 -1.0)))
	 (RETURN (SIMPLIFYA (OUTERMAP1 'MEXPT GR POT) T)))
	(T (GO UP)))
   E1  (COND ((OR (EQ $RADEXPAND '$ALL) (SIMPLEXPON POT) (NONEG (CADR GR))
		  (EQUAL (CADDR GR) -1)
		  (AND (EQ $DOMAIN '$REAL) (ODNUMP (CADDR GR))))
	      (SETQ POT (MULT POT (CADDR GR)) GR (CADR GR)))
	     ((AND (EQ $DOMAIN '$REAL) (FREE GR '$%I) $RADEXPAND
		   (EVNUMP (CADDR GR)))
	      (SETQ POT (MULT POT (CADDR GR)) GR (RADMABS (CADR GR))))
	     ((MMINUSP (CADDR GR))
	      (SETQ POT (NEG POT)
		    GR (LIST (CAR GR) (CADR GR) (NEG (CADDR GR)))))
	     (T (GO UP)))
       (GO CONT)))

(DEFUN TIMESIN (X Y W)  ; Multiply X^W into Y
 (PROG (FM TEMP Z CHECK U)
       (IF (MEXPTP X) (SETQ CHECK X))
  TOP  (COND ((EQUAL W 1) (SETQ TEMP X))
	     (T (SETQ TEMP (CONS '(MEXPT) (IF CHECK (LIST (CADR X) (MULT (CADDR X) W))
						    (LIST X W))))
		(IF (AND (NOT TIMESINP) (NOT (EQ X '$%I)))
		    (LET ((TIMESINP T)) (SETQ TEMP (SIMPLIFYA TEMP T))))))
       (SETQ X (IF (MEXPTP TEMP) (CDR TEMP) (LIST TEMP 1)))
       (SETQ W (CADR X) FM Y)
  START(COND ((NULL (CDR FM)) (GO LESS))
	     ((MEXPTP (CADR FM))
	      (COND ((ALIKE1 (CAR X) (CADADR FM))
		     (COND ((ZEROP1 (SETQ W (PLSK (CADDR (CADR FM)) W))) (GO DEL))
			   ((AND (MNUMP W) (OR (MNUMP (CAR X)) (EQ (CAR X) '$%I)))
			    (RPLACD FM (CDDR FM))
			    (COND ((MNUMP (SETQ X (IF (MNUMP (CAR X))
						      (EXPTRL (CAR X) W)
						      (POWER (CAR X) W))))
				   (RETURN (RPLACA Y (TIMESK (CAR Y) X))))
				  ((MTIMESP X) (GO TIMES))
				  (T (SETQ TEMP X X (IF (MEXPTP X) (CDR X) (LIST X 1)))
				     (SETQ W (CADR X) FM Y) (GO START))))
			   ((CONSTANTP (CAR X)) (GO CONST))
			   ((ONEP1 W) (RETURN (RPLACA (CDR FM) (CAR X))))
			   (T (GO SPCHECK))))
		    ((OR (CONSTANTP (CAR X)) (CONSTANTP (CADADR FM)))
		     (IF (GREAT TEMP (CADR FM)) (GO GR)))
		    ((GREAT (CAR X) (CADADR FM)) (GO GR)))
	      (GO LESS))
	     ((ALIKE1 (CAR X) (CADR FM)) (GO EQU))
	     ((CONSTANTP (CAR X)) (IF (GREAT TEMP (CADR FM)) (GO GR)))
	     ((GREAT (CAR X) (CADR FM)) (GO GR)))
  LESS (COND ((AND (EQ (CAR X) '$%I) (EQ (TYPEP W) 'FIXNUM)) (GO %I))
	     ((AND (EQ (CAR X) '$%E) $NUMER (FIXP W))
	      (RETURN (RPLACA Y (TIMESK (CAR Y) (EXP W)))))
	     ((AND (ONEP1 W) (NOT (CONSTANT (CAR X)))) (GO LESS1))
	     ((AND (CONSTANTP (CAR X))
		   (DO L (CDR FM) (CDR L) (NULL (CDR L))
		       (WHEN (AND (MEXPTP (CADR L)) (ALIKE1 (CAR X) (CADADR L)))
			     (SETQ FM L) (RETURN T))))
	      (GO START))
	     ((OR (AND (MNUMP (CAR X)) (MNUMP W))
		  (AND (EQ (CAR X) '$%E) $%EMODE (SETQ U (%ESPECIAL W))))
	      (SETQ X (COND (U)
			    ((ALIKE (CDR CHECK) X) CHECK)
			    (T (EXPTRL (CAR X) W))))
	      (COND ((MNUMP X) (RETURN (RPLACA Y (TIMESK (CAR Y) X))))
		    ((MTIMESP X) (GO TIMES))
		    ((MEXPTP X) (RETURN (CDR (RPLACD FM (CONS X (CDR FM))))))
		    (T (SETQ TEMP X X (LIST X 1) W 1 FM Y) (GO START))))
	     ((ONEP1 W) (GO LESS1))
	     (T (SETQ TEMP (LIST '(MEXPT) (CAR X) W))
		(SETQ TEMP (EQTEST TEMP (OR CHECK '((FOO)))))
		(RETURN (CDR (RPLACD FM (CONS TEMP (CDR FM)))))))
  LESS1 (RETURN (CDR (RPLACD FM (CONS (CAR X) (CDR FM)))))
  GR	(SETQ FM (CDR FM)) (GO START)
  EQU   (COND ((AND (EQ (CAR X) '$%I) (EQUAL W 1))
	       (RPLACD FM (CDDR FM)) (RETURN (RPLACA Y (TIMESK -1 (CAR Y)))))
	      ((ZEROP1 (SETQ W (PLSK 1 W))) (GO DEL))
	      ((AND (MNUMP (CAR X)) (MNUMP W))
	       (RETURN (RPLACA (CDR FM) (EXPTRL (CAR X) W))))
	      ((CONSTANTP (CAR X)) (GO CONST)))
 SPCHECK(SETQ Z (LIST '(MEXPT) (CAR X) W))
	(COND ((ALIKE1 (SETQ X (SIMPLIFYA Z T)) Z) (RETURN (RPLACA (CDR FM) X)))
	      (T (RPLACD FM (CDDR FM)) (SETQ RULESW T) (RETURN (MULN (CONS X Y) T))))
  CONST (RPLACD FM (CDDR FM))
	(SETQ X (CAR X) CHECK NIL)
	(GO TOP)
  TIMES (SETQ Z (TMS X 1 (SETQ TEMP (CONS '(MTIMES) Y))))
	(RETURN (COND ((EQ Z TEMP) (CDR Z)) (T (SETQ RULESW T) Z)))
  DEL	(RETURN (RPLACD FM (CDDR FM)))
  %I    (IF (MINUSP (SETQ W (REMAINDER W 4))) (SETQ W (+ 4 W)))
	(RETURN (COND ((ZEROP W) FM) 
		      ((= W 2) (RPLACA Y (TIMESK -1 (CAR Y))))
		      ((= W 3) (RPLACA Y (TIMESK -1 (CAR Y))) 
			       (RPLACD FM (CONS '$%I (CDR FM))))
		      (T (RPLACD FM (CONS '$%I (CDR FM))))))))

(DEFMFUN SIMPMATRIX (X VESTIGIAL Z)
 VESTIGIAL ;Ignored.
 (IF (AND (NULL (CDDR X))
	  $SCALARMATRIXP
	  (OR (EQ $SCALARMATRIXP '$ALL) (MEMQ 'MULT (CDAR X)))
	  ($LISTP (CADR X)) (CDADR X) (NULL (CDDADR X)))
     (SIMPLIFYA (CADADR X) Z)
     (LET ((BADP (DOLIST (ROW (CDR X)) (IF (NOT ($LISTP ROW)) (RETURN T))))
	   (ARGS (SIMPMAP (CDR X) Z)))
	  (CONS (IF BADP '(%MATRIX SIMP) '($MATRIX SIMP)) ARGS))))

(DEFUN %ITOPOT (POT)
 (IF (EQ (TYPEP POT) 'FIXNUM)
     (LET ((I (BOOLE 1 POT 3)))
	  (COND ((= I 0) 1)
		((= I 1) '$%I)
		((= I 2) -1)
		(T (LIST '(MTIMES SIMP) -1 '$%I))))
     (POWER -1 (MUL2 POT '((RAT SIMP) 1 2)))))

(DEFUN MNLOGP (POT)
 (COND ((EQ (CAAR POT) '%LOG) (SIMPLIFYA (CADR POT) NIL))
       ((AND (EQ (CAAR POT) 'MTIMES)
	     (OR (INTEGERP (CADR POT)) (AND $%E/_TO/_NUMLOG ($NUMBERP (CADR POT))))
	     (NOT (ATOM (CADDR POT))) (EQ (CAAR (CADDR POT)) '%LOG)
	     (NULL (CDDDR POT)))
	(POWER (CADR (CADDR POT)) (CADR POT)))))
 
(DEFUN MNLOG (POT)
 (PROG (A B C)
  LOOP (COND ((NULL POT)
	      (COND (A (SETQ A (CONS '(MTIMES) A))))
	      (COND (C (SETQ C (LIST '(MEXPT SIMP) '$%E (ADDN C NIL))))) 
	      (RETURN (COND ((NULL C) (SIMPTIMES A 1 NIL))
			    ((NULL A) C)
			    (T (SIMPTIMES (APPEND A (LIST C)) 1 NIL)))))
	     ((AND (AMONG '%LOG (CAR POT)) (SETQ B (MNLOGP (CAR POT))))
	      (SETQ A (CONS B A)))
	     (T (SETQ C (CONS (CAR POT) C))))
       (SETQ POT (CDR POT))
       (GO LOOP)))

(DEFUN %ETOLOG (POT) (COND ((MNLOGP POT))
			   ((EQ (CAAR POT) 'MPLUS) (MNLOG (CDR POT)))
			   (T (LIST '(MEXPT SIMP) '$%E POT)))) 

(DEFUN ZERORES (R1 R2)
       (COND ((OR ($BFLOATP R1) ($BFLOATP R2)) BIGFLOATZERO)
	     ((OR (FLOATP R1) (FLOATP R2)) 0.0)
	     (T 0)))

(DEFMFUN $ORDERLESSP (A B)
 (SETQ A (SPECREPCHECK A) B (SPECREPCHECK B))
 (AND (NOT (ALIKE1 A B)) (GREAT B A)))

(DEFMFUN $ORDERGREATP (A B)
 (SETQ A (SPECREPCHECK A) B (SPECREPCHECK B))
 (AND (NOT (ALIKE1 A B)) (GREAT A B)))

(DEFUN EVNUMP (N) (OR (EVEN N) (AND (RATNUMP N) (EVEN (CADR N)))))
(DEFUN ODNUMP (N) (OR (AND (FIXP N) (ODDP N))
		      (AND (RATNUMP N) (ODDP (CADR N)))))

(DEFUN SIMPLEXPON (E)
 (OR (INTEGERP E)
     (AND (EQ $DOMAIN '$REAL) (RATNUMP E) (ODDP (CADDR E)))))

(DEFUN NONEG (P) (AND (FREE P '$%I) (MEMQ ($SIGN P) '($POS $PZ $ZERO))))

(DEFUN RADMABS (E)
 (IF (AND LIMITP (FREE E '$%I)) (ASKSIGN-P-OR-N E))
 (SIMPLIFYA (LIST '(MABS) E) T))

(DEFMFUN SIMPMQAPPLY (EXP Y Z)
 (LET ((SIMPFUN (AND (NOT (ATOM (CADR EXP))) (GET (CAAADR EXP) 'SPECSIMP))) U)
      (IF SIMPFUN
	  (FUNCALL SIMPFUN EXP Y Z)
	  (PROGN (SETQ U (SIMPARGS EXP Z))
		 (IF (SYMBOLP (CADR U))
		     (SIMPLIFYA (CONS (CONS (CADR U) (CDAR U)) (CDDR U)) Z)
		     U)))))

(DEFMFUN DECL-COMPLEXP (E)
 (AND (EQ (TYPEP E) 'SYMBOL)
      (KINDP E '$COMPLEX)
      (NOT (KINDP E '$REAL))))

(DEFMFUN DECL-REALP (E)
 (AND (EQ (TYPEP E) 'SYMBOL) (KINDP E '$REAL)))

(DEFMFUN GREAT (X Y)
 (COND ((ATOM X)
	(COND ((ATOM Y)
	       (COND ((NUMBERP X)
		      (COND ((NUMBERP Y)
			     (SETQ Y (*DIF X Y))
			     (COND ((ZEROP Y) (FLOATP X)) (T (PLUSP Y))))))
		     ((CONSTANT X)
		      (COND ((CONSTANT Y) (ALPHALESSP Y X)) (T (NUMBERP Y))))
		     ((MGET X '$SCALAR)
		      (COND ((MGET Y '$SCALAR) (ALPHALESSP Y X)) (T (CONSTANTP Y))))
		     ((MGET X '$MAINVAR)
		      (COND ((MGET Y '$MAINVAR) (ALPHALESSP Y X)) (T T)))
		     (T (OR (CONSTANTP Y) (MGET Y '$SCALAR) 
			    (AND (NOT (MGET Y '$MAINVAR)) (ALPHALESSP Y X))))))
	      (T (NOT (ORDFNA Y X)))))
       ((ATOM Y) (ORDFNA X Y))
       ((EQ (CAAR X) 'RAT)
	(COND ((EQ (CAAR Y) 'RAT)
	       (GREATERP (TIMES (CADDR Y) (CADR X)) (TIMES (CADDR X) (CADR Y))))))
       ((EQ (CAAR Y) 'RAT))
       ((MEMQ (CAAR X) '(MBOX MLABOX)) (GREAT (CADR X) Y))
       ((MEMQ (CAAR Y) '(MBOX MLABOX)) (GREAT X (CADR Y)))
       ((OR (MEMQ (CAAR X) '(MTIMES MPLUS MEXPT %DEL))
	    (MEMQ (CAAR Y) '(MTIMES MPLUS MEXPT %DEL)))
	(ORDFN X Y))
       ((AND (EQ (CAAR X) 'BIGFLOAT) (EQ (CAAR Y) 'BIGFLOAT)) (MGRP X Y))
       (T (DO ((X1 (MARGS X) (CDR X1)) (Y1 (MARGS Y) (CDR Y1))) (())
	      (COND ((NULL X1)
		     (RETURN (COND (Y1 NIL)
				   ((NOT (ALIKE1 (MOP X) (MOP Y)))
				    (GREAT (MOP X) (MOP Y)))
				   ((MEMQ 'ARRAY (CDAR X)) T))))
		    ((NULL Y1) (RETURN T))
		    ((NOT (ALIKE1 (CAR X1) (CAR Y1)))
		     (RETURN (GREAT (CAR X1) (CAR Y1)))))))))

;; Trivial function used only in ALIKE1.  Should be defined as an open-codable subr.

(DEFMACRO MEMQARR (L) `(IF (MEMQ 'ARRAY ,L) T))

;; Compares two Macsyma expressions ignoring SIMP flags and all other
;; items in the header except for the ARRAY flag.

(DEFMFUN ALIKE1 (X Y)
 (COND ((EQ X Y))
       ((ATOM X) (EQUAL X Y))
       ((ATOM Y) NIL)
       (T (AND (NOT (ATOM (CAR X)))
	       (NOT (ATOM (CAR Y)))
	       (EQ (CAAR X) (CAAR Y))
	       (EQ (MEMQARR (CDAR X)) (MEMQARR (CDAR Y)))
	       (ALIKE (CDR X) (CDR Y)))))) 

;; Maps ALIKE1 down two lists.

(DEFMFUN ALIKE (X Y)
 (DO ((X X (CDR X)) (Y Y (CDR Y))) ((ATOM X) (EQUAL X Y))
     (COND ((OR (ATOM Y) (NOT (ALIKE1 (CAR X) (CAR Y))))
	    (RETURN NIL)))))

#+Franz
(DEFUN ALIKE1-PART2 (X Y)
  (AND (NOT (ATOM (CAR X)))
       (NOT (ATOM (CAR Y)))
       (EQ (CAAR X) (CAAR Y))
       (EQ (MEMQARR (CDAR X)) (MEMQARR (CDAR Y)))
       (ALIKE (CDR X) (CDR Y))))

(DEFUN ORDFNA (E A)  ; A is an atom
 (COND ((NUMBERP A)
	(OR (NOT (EQ (CAAR E) 'RAT))
	    (GREATERP (CADR E) (TIMES (CADDR E) A))))
       ((AND (CONSTANT A) (NOT (MEMQ (CAAR E) '(MPLUS MTIMES MEXPT))))
	(NOT (MEMQ (CAAR E) '(RAT BIGFLOAT))))
       ((NULL (MARGS E)) NIL)
       ((EQ (CAAR E) 'MEXPT)
	(COND ((AND (CONSTANTP (CADR E))
		    (OR (NOT (CONSTANT A)) (NOT (CONSTANTP (CADDR E)))))
	       (OR (NOT (FREE (CADDR E) A)) (GREAT (CADDR E) A)))
	      ((EQ (CADR E) A) (GREAT (CADDR E) 1))
	      (T (GREAT (CADR E) A))))
       ((MEMQ (CAAR E) '(MPLUS MTIMES))
	(LET ((U (CAR (LAST E))))
	     (COND ((EQ U A) (NOT (ORDHACK E))) (T (GREAT U A)))))
       ((EQ (CAAR E) '%DEL))
       ((PROG2 (SETQ E (CAR (MARGS E)))
	       (AND (NOT (ATOM E)) (MEMQ (CAAR E) '(MPLUS MTIMES))))
	(LET ((U (CAR (LAST E)))) (OR (EQ U A) (GREAT U A))))
       ((EQ E A))
       (T (GREAT E A)))) 

(DEFUN ORDLIST (A B CX CY)
       (PROG (L1 L2 C D) 
	     (SETQ L1 (LENGTH A) L2 (LENGTH B))
	LOOP (COND ((= L1 0)
		    (RETURN (COND ((= L2 0) (EQ CX 'MPLUS))
				  ((AND (EQ CX CY) (= L2 1))
				   (GREAT (COND ((EQ CX 'MPLUS) 0) (T 1)) (CAR B))))))
		   ((= L2 0) (RETURN (NOT (ORDLIST B A CY CX)))))
	     (SETQ C (NTHELEM L1 A) D (NTHELEM L2 B))
	     (COND ((NOT (ALIKE1 C D)) (RETURN (GREAT C D))))
	     (SETQ L1 (1- L1) L2 (1- L2))
	     (GO LOOP)))

(DEFUN ORDFN (X Y)
 (LET ((CX (CAAR X)) (CY (CAAR Y)) U) 
      (COND ((EQ CX '%DEL) (COND ((EQ CY '%DEL) (GREAT (CADR X) (CADR Y))) (T T)))
	    ((EQ CY '%DEL) NIL)
	    ((MEMQ CX '(MPLUS MTIMES))
	     (COND ((MEMQ CY '(MPLUS MTIMES)) (ORDLIST (CDR X) (CDR Y) CX CY))
		   ((ALIKE1 (SETQ U (CAR (LAST X))) Y) (NOT (ORDHACK X)))
		   (T (GREAT U Y))))
	    ((MEMQ CY '(MPLUS MTIMES))
	     (COND ((ALIKE1 X (SETQ U (CAR (LAST Y)))) (ORDHACK Y)) (T (GREAT X U))))
	    ((EQ CX 'MEXPT)
	     (COND ((EQ CY 'MEXPT)
		    (COND ((ALIKE1 (CADR X) (CADR Y)) (GREAT (CADDR X) (CADDR Y)))
			  ((CONSTANTP (CADR X))
			   (COND ((CONSTANTP (CADR Y))
				  (COND ((OR (ALIKE1 (CADDR X) (CADDR Y))
					     (AND (MNUMP (CADDR X)) (MNUMP (CADDR Y))))
					 (GREAT (CADR X) (CADR Y)))
					(T (GREAT (CADDR X) (CADDR Y)))))
				 (T (GREAT X (CADR Y)))))
			  ((CONSTANTP (CADR Y)) (GREAT (CADR X) Y))
			  ((MNUMP (CADDR X))
			   (GREAT (CADR X) (COND ((MNUMP (CADDR Y)) (CADR Y)) (T Y))))
			  ((MNUMP (CADDR Y)) (GREAT X (CADR Y)))
			  (T (SETQ CX (SIMPLN1 X) CY (SIMPLN1 Y))
			     (COND ((ALIKE1 CX CY) (GREAT (CADR X) (CADR Y)))
				   (T (GREAT CX CY))))))
		   ((CONSTANTP (CADR X))
		    (COND ((ALIKE1 (CADDR X) Y) T) (T (GREAT (CADDR X) Y))))
		   ((ALIKE1 (CADR X) Y) (GREAT (CADDR X) 1))
		   ((MNUMP (CADDR X)) (GREAT (CADR X) Y))
		   (T (GREAT (SIMPLN1 X) (SIMPLN (LIST '(%LOG) Y) 1 T)))))
	    (T (NOT (ORDFN Y X))))))  ; (EQ CY 'MEXPT)

(DEFUN ORDHACK (X)
 (COND ((AND (CDDR X) (NULL (CDDDR X)))
	(GREAT (COND ((EQ (CAAR X) 'MPLUS) 0) (T 1)) (CADR X)))))

(DEFMFUN $MULTTHRU NARGS
 (LET (ARG1 ARG2)
      (COND ((= NARGS 2)
	     (SETQ ARG1 (SPECREPCHECK (ARG 1)) ARG2 (SPECREPCHECK (ARG 2)))
	     (COND ((OR (ATOM ARG2) (NOT (MEMQ (CAAR ARG2) '(MPLUS MEQUAL))))
		    (MUL2 ARG1 ARG2))
		   ((EQ (CAAR ARG2) 'MEQUAL)
		    (LIST (CAR ARG2) ($MULTTHRU ARG1 (CADR ARG2))
				     ($MULTTHRU ARG1 (CADDR ARG2))))
		   (T (EXPANDTERMS ARG1 (CDR ARG2)))))
	    ((= NARGS 1)
	     (PROG (P FLAG) 
		   (SETQ ARG1 (SPECREPCHECK (ARG 1)))
		   (COND ((ATOM ARG1) (RETURN ARG1))
			 ((EQ (CAAR ARG1) 'MNCTIMES) (SETQ FLAG T))
			 ((NOT (EQ (CAAR ARG1) 'MTIMES)) (RETURN ARG1)))
		   (SETQ ARG1 (CDR ARG1))
		   (COND ((NULL FLAG) (SETQ ARG1 (REVERSE ARG1))))
	      LOOP (COND ((MPLUSP (CAR ARG1))
			  (SETQ P (NRECONC P (CDR ARG1))) (GO OUT))
			 (T (COND (FLAG (SETQ FLAG 'TT)))
			    (SETQ P (CONS (CAR ARG1) P))))
		   (SETQ ARG1 (CDR ARG1))
		   (COND ((NULL ARG1) (RETURN (ARG 1))))
		   (GO LOOP)
	      OUT  (SETQ P (COND (FLAG (CAR P)) (T (MULN P T))))
		   (RETURN
		    (ADDN (MAPCAR #'(LAMBDA (Y) 
				     (COND
				      (FLAG
				       (SIMPLIFYA (CONS '(MNCTIMES) 
							(COND ((EQ FLAG 'TT)
							       (LIST P Y))
							      (T (LIST Y P))))
						  T))
				      (T (MUL2 P Y))))
				  (CDAR ARG1))
			  T))))
	     (T (WNA-ERR '$MULTTHRU)))))
 
;  EXPANDEXPT computes the expansion of (x1 + x2 + ... + xm)^n
;  taking a sum and integer power as arguments.
;  Its theory is to recurse down the binomial expansion of
;  (x1 + (x2 + x3 + ... + xm))^n using the Binomial Expansion
;  Thus it does a sigma:
;
;                n
;             -------
;              \         / n \    k		        (n - k)
;               >        |   |  x1  (x2 + x3 + ... + xm)
;	       /	 \ k / 
;             -------
;               k=0
;
;   The function EXPONENTIATE-SUM does this and recurses through the second
;   sum raised to a power.  It takes a list of terms and a positive integer
;   power as arguments.


(DEFUN EXPANDEXPT (SUM POWER)
       (DECLARE (FIXNUM POWER))
       (LET ((EXPANSION (EXPONENTIATE-SUM (CDR SUM) (ABS POWER))))
	    (COND ((PLUSP POWER) EXPANSION)
		  (T `((MEXPT SIMP) ,EXPANSION -1)))))

(DEFUN EXPONENTIATE-SUM (TERMS RPOWER)
   (DECLARE (FIXNUM RPOWER I))
   (COND ((= RPOWER 0) 1)
	 ((NULL (CDR TERMS)) (POWER (CAR TERMS) RPOWER))
	 ((= RPOWER 1) (CONS '(MPLUS SIMP) TERMS))
	 (T (DO ((I 0 (1+ I))
		 (RESULT 0 (ADD2 RESULT
				 (MULN (LIST (COMBINATION RPOWER I)
					     (EXPONENTIATE-SUM (CDR TERMS)
							       (- RPOWER I))
					     (POWER (CAR TERMS) I)) T))))
		((> I RPOWER) RESULT)))))
					
;  Computes the combination of n elements taken m at a time by the formula
;  
;     (n * (n-1) * ... * (n - m + 1)) / m! =
;  	(n / 1) * ((n - 1) / 2) * ... * ((n - m + 1) / m)
;  
;  Checks for the case when m is greater than n/2 and translates
;  to an equivalent expression.

(DEFUN COMBINATION (N M)
       (DECLARE (FIXNUM N M N1 M1))
       (COND ((> M (// N 2)) (COMBINATION N (- N M)))
	     (T (DO ((RESULT 1 (QUOTIENT (TIMES RESULT N1) M1))
		     (N1 N (1- N1))
		     (M1 1 (1+ M1)))
		    ((> M1 M) RESULT)))))

(DEFUN EXPANDSUMS (A B) 
       (ADDN (PROG (C)
		   (SETQ A (FIXEXPAND A) B (CDR B))
	      LOOP (COND ((NULL A) (RETURN C)))
		   (SETQ C (CONS (EXPANDTERMS (CAR A) B) C))
		   (SETQ A (CDR A))
		   (GO LOOP))
	     T))

(DEFUN EXPANDTERMS (A B) 
       (ADDN (PROG (C)
	      LOOP (COND ((NULL B) (RETURN C)))
		   (SETQ C (CONS (MUL2 A (CAR B)) C))
		   (SETQ B (CDR B))
		   (GO LOOP))
	     T))

(DEFUN GENEXPANDS (L) 
 (PROG NIL
  LOOP (SETQ L (CDR L))
       (COND ((NULL L)
	      (SETQ PRODS (NREVERSE PRODS) NEGPRODS (NREVERSE NEGPRODS)
		    SUMS (NREVERSE SUMS) NEGSUMS (NREVERSE NEGSUMS))
	      (RETURN NIL))
	     ((ATOM (CAR L)) (SETQ PRODS (CONS (CAR L) PRODS)))
	     ((EQ (CAAAR L) 'RAT)
	      (COND ((NOT (EQUAL (CADAR L) 1)) (SETQ PRODS (CONS (CADAR L) PRODS))))
	      (SETQ NEGPRODS (CONS (CADDAR L) NEGPRODS)))
	     ((EQ (CAAAR L) 'MPLUS) (SETQ SUMS (CONS (CAR L) SUMS)))
	     ((AND (EQ (CAAAR L) 'MEXPT) (EQUAL (CADDAR L) -1) (MPLUSP (CADAR L)))
	      (SETQ NEGSUMS (CONS (CADAR L) NEGSUMS)))
	     ((AND (EQ (CAAAR L) 'MEXPT) ((LAMBDA (EXPANDP) (MMINUSP (CADDAR L))) T))
	      (SETQ NEGPRODS
		    (CONS (COND ((EQUAL (CADDAR L) -1) (CADAR L))
				(T (LIST (CAAR L) (CADAR L) (NEG (CADDAR L)))))
			  NEGPRODS)))
	     (T (SETQ PRODS (CONS (CAR L) PRODS))))
       (GO LOOP)))

(DEFUN EXPANDTIMES (A) 
       (PROG (PRODS NEGPRODS SUMS NEGSUMS EXPSUMS EXPNEGSUMS) 
	     (GENEXPANDS A)
	     (SETQ PRODS (COND ((NULL PRODS) 1)
			       ((NULL (CDR PRODS)) (CAR PRODS))
			       (T (CONS '(MTIMES SIMP) PRODS))))
	     (SETQ NEGPRODS (COND ((NULL NEGPRODS) 1)
				  ((NULL (CDR NEGPRODS)) (CAR NEGPRODS))
				  (T (CONS '(MTIMES SIMP) NEGPRODS))))
	     (COND ((NULL SUMS) (GO DOWN))
		   (T (SETQ EXPSUMS (CAR SUMS))
		      (MAPC (FUNCTION (LAMBDA (C)
				       (SETQ EXPSUMS (EXPANDSUMS EXPSUMS C))))
			    (CDR SUMS))))
	     (SETQ PRODS (COND ((EQUAL PRODS 1) EXPSUMS)
			       (T (EXPANDTERMS PRODS (FIXEXPAND EXPSUMS)))))
	DOWN (COND
	      ((NULL NEGSUMS)
	       (COND
		((EQUAL 1 NEGPRODS) (RETURN PRODS))
		((MPLUSP PRODS) (RETURN (EXPANDTERMS (POWER NEGPRODS -1) (CDR PRODS))))
		(T (RETURN ((LAMBDA (EXPANDFLAG) (MUL2 PRODS (POWER NEGPRODS -1))) T)))))
	      (T (SETQ EXPNEGSUMS (CAR NEGSUMS))
		 (MAPC (FUNCTION (LAMBDA (C)
				  (SETQ EXPNEGSUMS (EXPANDSUMS EXPNEGSUMS C))))
		       (CDR NEGSUMS))))
	     (SETQ EXPNEGSUMS (EXPANDTERMS NEGPRODS (FIXEXPAND EXPNEGSUMS)))
	     (RETURN
	      (COND ((MPLUSP PRODS)
		     (EXPANDTERMS (LIST '(MEXPT SIMP) EXPNEGSUMS -1) (CDR PRODS)))
		    (T ((LAMBDA (EXPANDFLAG)
			 (MUL2 PRODS (LIST '(MEXPT SIMP) EXPNEGSUMS -1))) T))))))

(DEFMFUN EXPAND1 (EXP $EXPOP $EXPON)
  (SSIMPLIFYA (SPECREPCHECK EXP)))

;; When the arg-count checking code is implemented ...
;; (DEFMFUN $EXPAND (EXP &OPTIONAL ($EXPOP $MAXPOSEX) ($EXPON $MAXNEGEX))
;;   (SSIMPLIFYA (SPECREPCHECK EXP)))

(DEFMFUN $EXPAND NARGS
 (COND ((= NARGS 1) (EXPAND1 (ARG 1) $MAXPOSEX $MAXNEGEX))
       ((= NARGS 2) (EXPAND1 (ARG 1) (ARG 2) $MAXNEGEX))
       ((= NARGS 3) (EXPAND1 (ARG 1) (ARG 2) (ARG 3)))
       (T (WNA-ERR '$EXPAND))))

(DEFUN FIXEXPAND (A) (COND ((NOT (MPLUSP A)) (NCONS A)) (T (CDR A))))


(DEFMFUN SIMPNRT (X *N)  ; computes X^(1/*N)
       (PROG (*IN *OUT VARLIST GENVAR $FACTORFLAG $DONTFACTOR)
	     (SETQ $FACTORFLAG T)
	     (NEWVAR X)
	     (SETQ X (RATREP* X))
	     (COND ((EQUAL (CADR X) 0) (RETURN 0)))
	     (SETQ X (RATFACT (CDR X) 'PSQFR))
	     (SIMPNRT1 (MAPCAR #'PDIS X))
	     (SETQ *OUT (COND (*OUT (MULN *OUT NIL)) (T 1)))
	     (SETQ *IN (COND (*IN (SETQ *IN (MULN *IN NIL))
				  (NRTHK *IN *N))
			     (T 1)))
	     (RETURN
	      ((LAMBDA ($%EMODE) 
		       (SIMPLIFYA (LIST '(MTIMES) *IN *OUT)
				  (NOT (OR (ATOM *IN)
					   (ATOM (CADR *IN))
					   (MEMQ (CAAADR *IN) '(MPLUS MTIMES RAT))))))
	       T))))

(DEFUN SIMPNRT1 (X) 
 (DO ((X X (CDDR X)) (Y)) ((NULL X))
     (COND ((NOT (EQUAL 1 (SETQ Y (GCD (CADR X) *N))))
	    (PUSH (SIMPNRT (LIST '(MEXPT) (CAR X) (QUOTIENT (CADR X) Y))
			   (QUOTIENT *N Y))
		  *OUT))
	   ((AND (EQUAL (CADR X) 1) (FIXP (CAR X)) (PLUSP (CAR X))
		 (SETQ Y (PNTHROOTP (CAR X) *N)))
	    (PUSH Y *OUT))
	   (T (COND ((NOT (GREATERP *N (ABS (CADR X))))
		     (PUSH (LIST '(MEXPT) (CAR X) (QUOTIENT (CADR X) *N)) *OUT)))
	      (PUSH (LIST '(MEXPT) (CAR X) (REMAINDER (CADR X) *N)) *IN)))))

(DEFUN NRTHK (IN *N) 
 (COND ((EQUAL IN 1) 1)
       ((EQUAL IN -1)
	(COND ((EQUAL *N 2) '$%I)
	      ((EQ $DOMAIN '$REAL)
	       (COND ((EVEN *N) (NRTHK2 -1 *N))
		     (T -1)))
	      ($M1PBRANCH
	       ((LAMBDA ($%EMODE) 
		 (POWER* '$%E (LIST '(MTIMES) (LIST '(RAT) 1 *N) '$%PI '$%I)))
		T))
	      (T (NRTHK2 -1 *N))))
       ((OR (AND WFLAG (EQ ($ASKSIGN IN) '$NEG))
	    (AND (MNUMP IN) (EQUAL ($SIGN IN) '$NEG)))
	(NRTHK1 (MUL2* -1 IN) *N))
       (T (NRTHK2 IN *N))))

(DEFUN NRTHK1 (IN *N)  ; computes (-IN)^(1/*N)
 (COND ($RADEXPAND (MUL2 (NRTHK2 IN *N) (NRTHK -1 *N)))
       (T (NRTHK2 (MUL2* -1 IN) *N))))

(DEFUN NRTHK2 (IN *N) (POWER* IN (LIST '(RAT) 1 *N)))  ; computes IN^(1/*N)

;; The following was formerly in SININT.  This code was placed here because 
;; SININT is now an out-of-core file on MC, and this code is needed in-core
;; because of the various calls to it. - BMT & JPG

(DECLARE (SPECIAL VAR $RATFAC RATFORM CONTEXT) (FIXNUM NARGS)
	 (*LEXPR CONTEXT))	

(DEFMFUN $INTEGRATE NARGS
  (LET ($RATFAC)
       (COND ((= NARGS 2)
	      (WITH-NEW-CONTEXT (CONTEXT)
		(IF (MEMQ '%RISCH NOUNL) (RISCHINT (ARG 1) (ARG 2))
		  (SININT (ARG 1) (ARG 2)))))
	     ((= NARGS 4) ($DEFINT (ARG 1) (ARG 2) (ARG 3) (ARG 4)))
	     (T (WNA-ERR '$INTEGRATE))))) 

(DEFUN RATP (A VAR) (COND ((ATOM A) T)
			  ((MEMQ (CAAR A) '(MPLUS MTIMES))
			   (DO ((L (CDR A) (CDR L)))
			       ((NULL L) T)
			       (OR (RATP (CAR L) VAR) (RETURN NIL))))
			  ((EQ (CAAR A) 'MEXPT)
			   (COND ((FREE (CADR A) VAR) (FREE (CADDR A) VAR))
				 (T (AND (FIXP (CADDR A)) (RATP (CADR A) VAR)))))
			  (T (FREE A VAR))))

(DEFMFUN RATNUMERATOR (R)
  (COND ((ATOM R) R)
	((ATOM (CDR R)) (CAR R))
	((NUMBERP (CADR R)) R)
	(T (CAR R))))
	 
(DEFMFUN RATDENOMINATOR (R)
  (COND ((ATOM R) 1)
	((ATOM (CDR R)) (CDR R))
	((NUMBERP (CADR R)) 1)
	(T (CDR R))))

(DECLARE (SPECIAL VAR))

(DEFMFUN BPROG (R S)
  (PROG (P1B P2B COEF1R COEF2R COEF1S COEF2S F1 F2 A EGCD)
	(SETQ R (RATFIX R))
	(SETQ S (RATFIX S))
	(SETQ COEF2R (SETQ COEF1S 0))
	(SETQ COEF2S (SETQ COEF1R 1))
 	(SETQ A 1 EGCD 1)
	(SETQ P1B (CAR R))
	(UNLESS (ZEROP (PDEGREE P1B VAR)) (SETQ EGCD (PGCDEXPON P1B)))
	(SETQ P2B (CAR S))
	(UNLESS (OR (ZEROP (PDEGREE P2B VAR)) (= EGCD 1))
		(SETQ EGCD (GCD EGCD (PGCDEXPON P2B)))
		(SETQ P1B (PEXPON*// P1B EGCD NIL)
		      P2B (PEXPON*// P2B EGCD NIL)))
   B1   (COND ((LESSP (PDEGREE P1B VAR) (PDEGREE P2B VAR))
	       (EXCH P1B P2B)
	       (EXCH COEF1R COEF2R)
	       (EXCH COEF1S COEF2S)))
	(IF (ZEROP (PDEGREE P2B VAR))
	    (RETURN (CONS (RATREDUCE (PTIMES (CDR R) (PEXPON*// COEF2R EGCD T))
				     P2B)
			  (RATREDUCE (PTIMES (CDR S) (PEXPON*// COEF2S EGCD T))
				     P2B))))
	(SETQ F1 (PSQUOREM1 (CDR P1B) (CDR P2B) T))
	(SETQ F2 (PSIMP VAR (CADR F1)))
	(SETQ P1B (PQUOTIENTCHK (PSIMP VAR (CADDR F1)) A))
	(SETQ F1 (CAR F1))
	(SETQ COEF1R (PQUOTIENTCHK (PDIFFERENCE (PTIMES F1 COEF1R)
						(PTIMES F2 COEF2R))
				   A))
	(SETQ COEF1S (PQUOTIENTCHK (PDIFFERENCE (PTIMES F1 COEF1S)
						(PTIMES F2 COEF2S))
				   A))
	(SETQ A F1)
	(GO B1)))

(DEFUN RATDIFFERENCE (A B) (RATPLUS A (RATMINUS B)))

(DEFUN RATPL (A B) (RATPLUS (RATFIX A) (RATFIX B)))

(DEFUN RATTI (A B C) (RATTIMES (RATFIX A) (RATFIX B) C)) 

(DEFUN RATQU (A B) (RATQUOTIENT (RATFIX A) (RATFIX B))) 

(DEFUN RATFIX (A) (COND ((EQUAL A (RATNUMERATOR A)) (CONS A 1)) (T A)))
	 
(DEFUN RATDIVIDE (F G)
       (LET* (((FNUM . FDEN) (RATFIX F))
	      ((GNUM . GDEN) (RATFIX G))
	      ((Q R) (PDIVIDE FNUM GNUM)))
	     (CONS (RATQU (RATTI Q GDEN T) FDEN)
		   (RATQU R FDEN))))

(DEFUN POLCOEF (L N) (COND ((OR (ATOM L) (POINTERGP VAR (CAR L)))
			    (COND ((EQUAL N 0) L) (T 0)))
			   (T (PTERM (CDR L) N))))

(DEFUN DISREP (L) (COND ((EQUAL (RATNUMERATOR L) L)
			 ($RATDISREP (CONS RATFORM (CONS L 1))))
			(T ($RATDISREP (CONS RATFORM L)))))

(DECLARE (UNSPECIAL VAR))


;; The following was formerly in MATRUN.  This code was placed here because 
;; MATRUN is now an out-of-core file on MC, and this code is needed in-core 
;; so that MACSYMA SAVE files will work. - JPG

(SETQ *AFTERFLAG NIL)

(DEFMFUN MATCHERR NIL (*THROW 'MATCH NIL))

(DEFMFUN KAR (X) (IF (ATOM X) (MATCHERR) (CAR X)))

(DEFMFUN KDR (X) (IF (ATOM X) (MATCHERR) (CDR X)))

(DEFMFUN SIMPARGS1 (A VESTIGIAL C)
       VESTIGIAL ;Ignored.
       (SIMPARGS A C))

(DEFMFUN *KAR (X) (IF (NOT (ATOM X)) (CAR X)))

;MATCOEF is obsolete, only needed for old SAVE files. - JPG 5/12/80
#-NIL
(DEFUN MATCOEF FEXPR (L)
 (RATDISREP (RATCOEF (MEVAL (CAR L)) (MEVAL (CADR L)))))
; NIL doesn't handle fexprs, and the compatibility mode isn't
; hacked for it yet. The lexical scoping in the evaluator will
; absolutely shoot to hell any chance of running the output of
; the matchcompiler anyway, without a good bit of hacking to MATCOM
; to make sure all the special declarations are generated.
; The same problem comes up if one tried to compile the output of
; the match compiler in just about any lisp of course.
; The easiest thing to do is probably to write a simple
; dynamic-binding evaluator for use in lusing situations like
; this!
#-NIL
(DEFUN RETLIST FEXPR (L)
 (CONS '(MLIST SIMP)
       (MAPCAR #'(LAMBDA (Z) (LIST '(MEQUAL SIMP) Z (MEVAL Z))) L)))

(DEFMFUN NTHKDR (X C) (IF (ZEROP C) X (NTHKDR (KDR X) (SUB1 C))))


; Undeclarations for the file:
(DECLARE (NOTYPE L1 L2 XN NARGS I))

