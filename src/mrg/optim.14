;;; -*- Mode:LISP; Package:MACSYMA -*-

;	** (c) Copyright 1982 Massachusetts Institute of Technology **

(macsyma-module optim)

(DECLARE (SPECIAL VARS SETQS OPTIMCOUNT XVARS)
	 (FIXNUM N (OPT-HASH))
	 (ARRAY* (NOTYPE (SUBEXP 1)))
	 (UNSPECIAL ARGS))

(ARRAY SUBEXP T 64.)

(DEFMVAR $OPTIMPREFIX '$%)

(DEFMVAR $OPTIMWARN T "warns if OPTIMIZE encounters a special form.")

;; $OPTIMIZE takes a Macsyma expression and returns a BLOCK form which is
;; equivalent, but which uses local variables to store the results of computing
;; common subexpressions.  These subexpressions are found by hashing them.

(DEFMFUN $OPTIMIZE (X0)
  (LET (($OPTIMWARN $OPTIMWARN))
    (PROG (VARS SETQS OPTIMCOUNT XVARS X)
      (SETQ OPTIMCOUNT 0 XVARS (CDR ($LISTOFVARS X0)))
      (FILLARRAY 'SUBEXP '(NIL))
      (SETQ X (COLLAPSE (OPFORMAT (COLLAPSE X0))))
      (IF (ATOM X) (RETURN X))
      (COMEXP X)
      (SETQ X (OPTIM X))
      (RETURN (PROG1 (COND ((NULL VARS) X0)
			   (T (IF (OR (NOT (EQ (CAAR X) 'MPROG))
				      (AND ($LISTP (CADR X)) (CDADR X)))
				  (SETQ X (NREVERSE (CONS X SETQS)))
				  (SETQ X (NCONC (NREVERSE SETQS) (CDDR X))))
			      `((MPROG SIMP) ((MLIST) . ,(NREVERSE VARS)) . ,X)))
		     (FILLARRAY 'SUBEXP '(NIL)))))))

(DEFUN OPFORMAT (X)
  (COND ((ATOM X) X)
	((SPECREPP X) (OPFORMAT (SPECDISREP X)))
	((AND $OPTIMWARN
	      (MSPECFUNP (CAAR X))
	      (PROG2 (MTELL "OPTIMIZE has met up with a special form - ~
			     answer may be wrong.")
		     (SETQ $OPTIMWARN NIL))))
	((EQ (CAAR X) 'MEXPT) (OPMEXPT X))
	(T (LET ((NEWARGS (MAPCAR #'OPFORMAT (CDR X))))
	     (IF (ALIKE NEWARGS (CDR X)) X (CONS (CAR X) NEWARGS))))))

(DEFUN OPMEXPT (X)
  (LET ((*BASE (OPFORMAT (CADR X))) (EXP (OPFORMAT (CADDR X))) XNEW NEGEXP)
    (SETQ NEGEXP
	  (COND ((AND (NUMBERP EXP) (MINUSP EXP)) (MINUS EXP))
		((AND (RATNUMP EXP) (MINUSP (CADR EXP)))
		 (LIST (CAR EXP) (MINUS (CADR EXP)) (CADDR EXP)))
		((AND (MTIMESP EXP) (NUMBERP (CADR EXP)) (MINUSP (CADR EXP)))
		 (IF (EQUAL (CADR EXP) -1)
		     (IF (NULL (CDDDR EXP)) (CADDR EXP)
					    (CONS (CAR EXP) (CDDR EXP)))
		     (LIST* (CAR EXP) (MINUS (CADR EXP)) (CDDR EXP))))
		((AND (MTIMESP EXP) (RATNUMP (CADR EXP)) (MINUSP (CADADR EXP)))
		 (LIST* (CAR EXP)
			(LIST (CAADR EXP) (MINUS (CADADR EXP)) (CADDR (CADR EXP)))
			(CDDR EXP)))))
    (SETQ XNEW
	  (COND (NEGEXP
		 `((MQUOTIENT)
		   1
		   ,(COND ((EQUAL NEGEXP 1) *BASE)
			  (T (SETQ XNEW (LIST (CAR X) *BASE NEGEXP))
			     (IF (AND (RATNUMP NEGEXP) (EQUAL (CADDR NEGEXP) 2))
				 (OPMEXPT XNEW)
				 XNEW)))))
		((AND (RATNUMP EXP) (EQUAL (CADDR EXP) 2)) 
		 (SETQ EXP (CADR EXP))
		 (IF (EQUAL EXP 1) `((%SQRT) ,*BASE)
				   `((MEXPT) `((%SQRT) ,*BASE) ,EXP)))
		(T (LIST (CAR X) *BASE EXP))))
    (IF (ALIKE1 X XNEW) X XNEW)))

(DEFMFUN $COLLAPSE (X)
  (FILLARRAY 'SUBEXP '(NIL))
  (PROG1 (COLLAPSE X) (FILLARRAY 'SUBEXP '(NIL))))
       
(DEFUN COLLAPSE (X)
  (COND ((ATOM X) X)
	((SPECREPP X) (COLLAPSE (SPECDISREP X)))
	(T (LET ((N (OPT-HASH (CAAR X))))
	     (DO ((L (CDR X) (CDR L)))
		 ((NULL L))
		 (IF (NOT (EQ (COLLAPSE (CAR L)) (CAR L)))
		     (RPLACA L (COLLAPSE (CAR L))))
		 (SETQ N (\ (+ (OPT-HASH (CAR L)) N) 12553.)))
	     (SETQ N (LOGAND 63. N))
	     (DO ((L (SUBEXP N) (CDR L)))
		 ((NULL L) (STORE (SUBEXP N) (CONS (LIST X) (SUBEXP N))) X)
		 (IF (ALIKE1 X (CAAR L)) (RETURN (CAAR L))))))))

(DEFUN COMEXP (X)
  (IF (NOT (OR (ATOM X) (EQ (CAAR X) 'RAT)))
      (LET ((N (OPT-HASH (CAAR X))))
	(DOLIST (U (CDR X)) (SETQ N (\ (+ (OPT-HASH U) N) 12553.)))
	(SETQ X (ASSOL X (SUBEXP (LOGAND 63. N))))
	(COND ((NULL (CDR X)) (RPLACD X 'SEEN) (MAPC #'COMEXP (CDAR X)))
	      (T (RPLACD X 'COMEXP))))))

(DEFUN OPTIM (X)
  (COND ((ATOM X) X)
	((AND (MEMQ 'ARRAY (CDAR X)) (NOT (MGET (CAAR X) 'ARRAYFUN-MODE))) X)
	((EQ (CAAR X) 'RAT) X)
	(T (LET ((N (OPT-HASH (CAAR X))) (NX (LIST (CAR X))))
	     (DOLIST (U (CDR X))
		(SETQ N (\ (+ (OPT-HASH U) N) 12553.)
		      NX (CONS (OPTIM U) NX)))
	     (SETQ X (ASSOL X (SUBEXP (LOGAND 63. N))) NX (NREVERSE NX))
	     (COND ((EQ (CDR X) 'SEEN) NX)
		   ((EQ (CDR X) 'COMEXP)
		    (RPLACD X (GETOPTIMVAR))
		    (SETQ SETQS (CONS `((MSETQ) ,(CDR X) ,NX) SETQS))
		    (CDR X))
		   (T (CDR X)))))))

(DEFUN OPT-HASH (EXP)  ; EXP is in general representation.
  (\ (IF (ATOM EXP)
	 (SXHASH EXP)
	 (DO ((N (OPT-HASH (CAAR EXP)))
	      (ARGS (CDR EXP) (CDR ARGS)))
	     ((NULL ARGS) N)
	     (SETQ N (\ (+ (OPT-HASH (CAR ARGS)) N) 12553.))))
     12553.))  ; a prime number < 2^14 ; = PRIME(1500)

(DEFUN GETOPTIMVAR ()
  (PROG (VAR)
   LOOP (INCREMENT OPTIMCOUNT)
	(SETQ VAR (INTERN #-Lispm (MAKNAM (NCONC (EXPLODEN $OPTIMPREFIX)
						 (MEXPLODEN OPTIMCOUNT)))
			  #+Lispm (MAKE-SYMBOL
				   (FORMAT NIL "~A~D" $OPTIMPREFIX OPTIMCOUNT))))
	(IF (MEMQ VAR XVARS) (GO LOOP))
	(SETQ VARS (CONS VAR VARS))
	(RETURN VAR)))
