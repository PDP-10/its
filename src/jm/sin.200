;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1982 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module sin)

(DECLARE (SPECIAL RATFORM EXPTSUM $RADEXPAND $%E/_TO/_NUMLOG
		  EXPTIND QUOTIND SPLIST L ANS SPLIST ARCPART COEF
		  AA DICT EXPTFLAG BASE* POWERLIST A B K STACK
		  RATROOT ROOTLIST SQUARE E W Y EXPRES ARG VAR
		  POWERL C D EXP CHEBYFORM RATROOTFORM TRIGARG
		  NOTSAME YY B1 YZ VARLIST GENVAR REPSWITCH $LIFLAG
		  NOPARTS TOP MAXPARTS NUMPARTS BLANK $OPSUBST)
	 (*EXPR POWERLIST RATROOT)
	 (*LEXPR $FACTOR $EXPAND)
	 (GENPREFIX SIN))

(DEFMVAR $INTEGRATION_CONSTANT_COUNTER 0)

(DEFUN SASSQ1 (ARG LIST FN) 
		 (COND ((NULL LIST) (FUNCALL FN))
		       ((EQUAL (CAAR LIST) ARG) (CAR LIST))
		       (T (SASSQ1 ARG (CDR LIST) FN))))
	 

(DEFUN OP MACRO (L) (LIST 'GET (CADR L) ''OPERATORS))

(DEFUN INTEGERP1 (X) (INTEGERP2 (MUL2* 2 X)))

(DEFUN SUPEREXPT (EXP VAR BASE*) 
  (PROG (EXPTFLAG Y W) 
	(SETQ Y (ELEMXPT EXP))
	(COND (EXPTFLAG (RETURN NIL)))
	(RETURN
	 (SUBSTINT
	  (LIST '(MEXPT) BASE* VAR)
	  VAR
	  (INTEGRATOR
	   (DIV Y (MUL2 VAR (SIMPLOG (LIST BASE*))))
	   VAR)))))
 
(DEFUN ELEMXPT (EXP) 
	 (COND ((FREEVAR EXP) EXP)
	       ((ATOM EXP) (SETQ EXPTFLAG T))
	       ((NOT (EQ (CAAR EXP) 'MEXPT))
		(CONS (CAR EXP)
		      (MAPCAR 
		       (FUNCTION (LAMBDA (C) (ELEMXPT C)))
		       (CDR EXP))))
	       ((NOT (FREEVAR (CADR EXP)))
		(LIST '(MEXPT)
		      (ELEMXPT (CADR EXP))
		      (ELEMXPT (CADDR EXP))))
	       ((NOT (EQ (CADR EXP) BASE*))
		(ELEMXPT (LIST '(MEXPT)
			       BASE*
			       (SIMPLIFY (LIST '(MTIMES)
					   (LIST '(%LOG)
						 (CADR EXP))
					   (CADDR EXP))))))
	       ((NOT (SETQ W
			   (M2 (CADDR EXP)
			       '((MPLUS)
				 ((COEFFPT) (A FREEVAR) (VAR VARP))
				 ((COEFFPT) (B FREEVAR)))
			       NIL)))
		(LIST (CAR EXP) BASE* (ELEMXPT (CADDR EXP))))
	       (T (SUBSTITUTE BASE*
			      'BASE*
			      (SUBLISS W
				       '((MTIMES)
					 ((MEXPT) BASE* B)
					 ((MEXPT) VAR A)))))))
 

(DEFUN SUBST10 (EXP) 
	 (COND ((ATOM EXP) EXP)
	       ((AND (EQ (CAAR EXP) 'MEXPT)
		     (EQ (CADR EXP) VAR))
		(LIST '(MEXPT)
		      VAR
		      (INTEGERP2 (QUOTIENT (CADDR EXP) D))))
	       (T (CONS (NCONS (CAAR EXP))
			(MAPCAR (FUNCTION (LAMBDA (C) (SUBST10 C)))
			   (CDR EXP))))))

(DEFUN CHOICESIN (X1 X2) 
 (COND ((EQ X1 (CAR X2)) (CDR X2))
       (T (CONS (CAR X2) (CHOICESIN X1 (CDR X2))))))
	 
(DEFUN RATIONALIZER (X)
 ((LAMBDA (EXP1) (COND ((NOT (ALIKE1 EXP1 X)) EXP1)))
  (SIMPLIFY ($FACTOR X))))

(DEFUN INTFORM (EXPRES) 
  (COND
   ((FREEVAR EXPRES) NIL)
   ((ATOM EXPRES) NIL)
   ((MEMQ (CAAR EXPRES) '(MPLUS MTIMES))
    ((LAMBDA (L) (PROG (Y) 
		  LOOP (COND ((SETQ Y (INTFORM (CAR L))) (RETURN Y))
			     ((NOT (SETQ L (CDR L))) (RETURN NIL))
			     (T (GO LOOP)))))
     (CDR EXPRES)))
   ((OR (EQ (CAAR EXPRES) '%LOG) (ARCP (CAAR EXPRES)))
    (COND
     ((SETQ ARG (M2 EXP 
;;; (LIST '(MTIMES) (CONS (LIST (CAAR EXPRES)) '((B RAT8)))'((COEFFTT)(C RAT8PRIME)))
		    `((MTIMES) (( ,(CAAR EXPRES) ) (B RAT8)) ((COEFFTT) (C RAT8PRIME)) )
		    NIL))
      (RATLOG EXP VAR (CONS (CONS 'A EXPRES) ARG)))
     (T
      (PROG (Y Z) 
	    (COND
	     ((SETQ Y (INTFORM (CADR EXPRES))) (RETURN Y))
	     ((AND (EQ (CAAR EXPRES) '%LOG)
		   (SETQ Z (M2 (CADR EXPRES) C NIL))
		   (SETQ Y (M2 EXP
			       '((MTIMES)
				 ((COEFFTT) (C RAT8))
				 ((COEFFTT) (D ELEM)))
			       NIL)))
	      (RETURN
	       ((LAMBDA (A B C D) 
		 (SUBSTINT
		  EXPRES
		  VAR
		  (INTEGRATOR
		   (MULN
		    (LIST (SUBSTITUTE
                              `((MQUOTIENT) ((MPLUS) ((MEXPT) $%E ,VAR)
                                                     ((MTIMES) -1 ,A))
                                            ,B)
                              VAR
                              C)
                          `((MQUOTIENT) ((MEXPT) $%E ,VAR) ,B)
			  (SUBSTITUTE VAR EXPRES D))
		    NIL)
		   VAR)))
		(CDR (SASSQ 'A Z 'NILL))
		(CDR (SASSQ 'B Z 'NILL))
		(CDR (SASSQ 'C Y 'NILL))
		(CDR (SASSQ 'D Y 'NILL)))))
	     (T (RETURN NIL)))))))
   ((OPTRIG (CAAR EXPRES))
    (COND ((NOT (SETQ W (M2 (CADR EXPRES) C NIL)))
	   (INTFORM (CADR EXPRES)))
	  (T (PROG2 (SETQ POWERL T)
		    (MONSTERTRIG EXP VAR (CADR EXPRES))))))
   ((AND (EQ (CAAR EXPRES) '%DERIVATIVE)
	 (EQ (CAAR EXP) (CAAR EXPRES))
	 (OR (ATOM (CADR EXP)) (NOT (EQ (CAAADR EXP) 'MQAPPLY))
	     (merror "Invalid arg to INTEGRATE:~%~M" EXP))
	 (CHECKDERIV EXP)))
   ((NOT (EQ (CAAR EXPRES) 'MEXPT)) NIL)
   ((FIXP (CADDR EXPRES)) (INTFORM (CADR EXPRES)))
   ((FREEVAR (CADR EXPRES))
    (COND ((M2 (CADDR EXPRES) C NIL)
	   (SUPEREXPT EXP VAR (CADR EXPRES)))
	  ((INTFORM (CADDR EXPRES)))
	  (T (LET* (($%E/_TO/_NUMLOG T) (NEXP (RESIMPLIFY EXP)))
		   (COND ((ALIKE1 EXP NEXP) NIL)
			 (T (INTFORM (SETQ EXP NEXP))))))))
   ((NOT (RAT8 (CADR EXPRES))) (INTFORM (CADR EXPRES)))
   ((AND (SETQ W (M2 (CADR EXPRES) RATROOTFORM NIL))	;e*(a*x+b) / (c*x+d)
	 (DENOMFIND (CADDR EXPRES)))			;expon is ratnum
    (COND((SETQ W(PROG2 (SETQ POWERL T) (RATROOT EXP VAR (CADR EXPRES) W))) W)
	 (T(INTE EXP VAR))))
   ((NOT (INTEGERP1 (CADDR EXPRES)))			;2*exponent not integer
    (COND ((M2 EXP CHEBYFORM NIL) (CHEBYF EXP VAR))
	  (T (INTFORM (CADR EXPRES)))))
   ((SETQ W (M2 (CADR EXPRES) D NIL))			;sqrt(c*x^2+b*x+a)
    (INTE EXP VAR))
   ((M2 EXP CHEBYFORM NIL) (CHEBYF EXP VAR))
   ((NOT (M2 (SETQ W ($EXPAND (CADR EXPRES))) (CADR EXPRES) NIL))
    (PROG2 (SETQ EXP (SUBSTITUTE W (CADR EXPRES) EXP))
	   (INTFORM (SIMPLIFY (LIST '(MEXPT) W (CADDR EXPRES))))))
   ((SETQ W (RATIONALIZER (CADR EXPRES)))
    (PROG2 (SETQ EXP (LET (($RADEXPAND '$ALL))
			  (SUBSTITUTE W (CADR EXPRES) EXP)))
	   (INTFORM (LET (($RADEXPAND '$ALL))
			 (SIMPLIFY (LIST '(MEXPT) W (CADDR EXPRES)))))))))
 
(DEFUN SEPARC (EXP)
       (COND ((ARCFUNCP EXP)
	      (SETQ ARCPART EXP
		    COEF 1))
	     ((EQ (CAAR EXP) 'MTIMES)
	      (ARCLIST (CDR EXP))
	      (SETQ COEF (COND ((NULL (CDR COEF)) (CAR COEF))
			       (T (SETQ COEF (CONS (CAR EXP) COEF))))))))
(DEFUN ARCLIST (LIST)
       (COND ((NULL LIST) NIL)
	     ((AND (ARCFUNCP (CAR LIST))
		   (NULL ARCPART))
	      (SETQ ARCPART (CAR LIST))
	       (ARCLIST (CDR LIST)))
	     (T (SETQ COEF (CONS (CAR LIST) COEF))
		(ARCLIST (CDR LIST)))))

(DEFUN ARCFUNCP (EXP)
       (AND (NOT (ATOM EXP))
	    (OR (ARCP (CAAR EXP))
		(EQ (CAAR EXP) '%LOG)	     ;experimentally treat logs also
		(AND (EQ (CAAR EXP) 'MEXPT)
		     (INTEGERP2 (CADDR EXP))
		     (GREATERP (INTEGERP2 (CADDR EXP)) 0)
		     (ARCFUNCP (CADR EXP))))))

(DEFUN INTEGRATOR (EXP VAR) 
  (PROG (Y ARG POWERL CONST B W C D E RATROOTFORM
	   CHEBYFORM ARCPART COEF INTEGRAND)
	(COND ((FREEVAR EXP) (RETURN (MUL2* EXP VAR))))
	(SETQ W (PARTITION EXP VAR 1))
	(SETQ CONST (CAR W))
	(SETQ EXP (CDR W))
	(COND ((MPLUSP EXP) (RETURN (MUL2* CONST (INTEGRATE1 (CDR EXP)))))
	      ((AND (NOT (ATOM EXP)) (EQ (CAAR EXP) '$ATAN2))
	       (RETURN (MUL2* CONST (INTEGRATOR
				     (SIMPLIFYA (LIST '(%ATAN) (DIV (CADR EXP) (CADDR EXP))) T)
				     VAR))))
	      ((AND (NOT (ATOM EXP)) (EQ (CAAR EXP) '%SUM))
	       (RETURN (MUL2* CONST (INTSUM EXP VAR)))))
        (COND ((SETQ Y (DIFFDIV EXP VAR)) (RETURN (MUL2* CONST Y))))
	(SETQ Y (COND ((EQ (CAAR EXP) 'MTIMES) (CDR EXP)) (T (LIST EXP))))
	(SETQ C '((MPLUS)
		  ((COEFFPT) (B FREEVAR) (X VARP))
		  ((COEFFPT) (A FREEVAR))))
	(SETQ RATROOTFORM '((MTIMES)
			    ((COEFFTT) (E FREEVAR))
			    ((MPLUS)
			     ((COEFFPT) (A FREEVAR) (VAR VARP))
			     ((COEFFPT) (B FREEVAR)))
			    ((MEXPT)
			     ((MPLUS)
			      ((COEFFPT) (C FREEVAR) (VAR VARP))
			      ((COEFFPT) (D FREEVAR)))
			     -1)))
	(SETQ CHEBYFORM '((MTIMES)
			  ((MEXPT) (VAR VARP) (R1 NUMBERP))
			  ((MEXPT)
			   ((MPLUS)
			    ((MTIMES)
			     ((COEFFTT) (C2 FREEVAR))
			     ((MEXPT) (VAR VARP) (Q FREE1)))
			    ((COEFFPP) (C1 FREEVAR)))
			   (R2 NUMBERP))
			  ((COEFFTT) (A FREEVAR))))
	(SETQ D '((MPLUS)
		  ((COEFFPT) (C FREEVAR) ((MEXPT) (X VARP) 2))
		  ((COEFFPT) (B FREEVAR) (X VARP))
		  ((COEFFPT) (A FREEVAR))))
	(SETQ E '((MTIMES)
		  ((MPLUS)
		   ((COEFFPT) (A FREEVAR) (VAR VARP))
		   ((COEFFPT) (B FREEVAR)))
		  ((MPLUS)
		   ((COEFFPT) (C FREEVAR) (VAR VARP))
		   ((COEFFPT) (D FREEVAR)))))
   LOOP (COND ((RAT8 (CAR Y)) (GO SKIP))
	      ((SETQ W (INTFORM (CAR Y))) (RETURN (MUL2* CONST W)))
	      (T (GO SPECIAL)))
   SKIP (SETQ Y (CDR Y))
	(COND ((NULL Y)
	       (RETURN (MUL2* CONST (COND ((SETQ Y (POWERLIST EXP VAR)) Y)
					  (T (RATINT EXP VAR)))))))
	(GO LOOP)
   SPECIAL
	   (SEPARC EXP)    ;SEPARC SETQS ARCPART AND COEF SUCH THAT
	                   ;COEF*ARCEXP=EXP WHERE ARCEXP IS OF THE FORM
                           ;ARCFUNC^N AND COEF IS ITS ALGEBRAIC COEFFICIENT
	   
	   (COND ((AND (NOT (NULL ARCPART))
		       (DO  ((STACKLIST STACK (CDR STACKLIST)))
			    ((NULL STACKLIST) T)
			    (COND ((ALIKE1 (CAR STACKLIST) COEF)
				   (RETURN NIL))))
		       (NOT (ISINOP (SETQ W ((LAMBDA (STACK)
					      (INTEGRATOR COEF VAR))
					     (CONS COEF STACK)))
				    '%INTEGRATE))
		       (SETQ INTEGRAND (MUL2 W (SDIFF ARCPART VAR)))
		       (DO ((STACKLIST STACK (CDR STACKLIST)))
			   ((NULL STACKLIST) T)
			   (COND ((ALIKE1 (CAR STACKLIST) INTEGRAND)
				  (RETURN NIL))))
		       (NOT (ISINOP
			     (SETQ Y
				   ((LAMBDA (STACK INTEG)
					    (INTEGRATOR INTEG VAR))
				    (CONS INTEGRAND STACK)
				    INTEGRAND))
			     '%INTEGRATE)))
		  (RETURN (ADD2* (LIST '(MTIMES) CONST W ARCPART)
				 (LIST '(MTIMES) -1 CONST Y))))
		 (T (RETURN
		     (MUL2 CONST
			   (COND ((SETQ Y (SCEP EXP VAR))
				  (COND ((CDDR Y)
					 (INTEGRATOR ($TRIGREDUCE EXP) VAR))
					(T (SCE-INT (CAR Y) (CADR Y) VAR))))
				 ((NOT (ALIKE1 EXP (SETQ Y ($EXPAND EXP))))
				  (INTEGRATOR Y VAR))
				 ((AND (NOT POWERL)
				       (SETQ Y (POWERLIST EXP VAR)))
				  Y)
				 ((SETQ Y (RISCHINT EXP VAR)) Y)
				 (T (LIST '(%INTEGRATE) EXP VAR)))))))))
 
(DEFUN RAT8 (EXP)
  (COND ((OR (ALIKE1 EXP VAR) (FREEVAR EXP)) T)
	((MEMQ (CAAR EXP) '(MPLUS MTIMES))
	 (AND (RAT8 (CADR EXP))
	      (COND ((CDDR EXP) (RAT8 (CONS (CAR EXP) (CDDR EXP)))) (T T))))
	((NOT (EQ (CAAR EXP) 'MEXPT)) NIL)
	((FIXP (CADDR EXP)) (RAT8 (CADR EXP)))))
	 
(DEFUN OPTRIG (X) (MEMQ X '(%SIN %COS %SEC %TAN %CSC %COT)))
	 
;after finding a non-integrable summand usually better to pass rest to risch
(DEFUN INTEGRATE1 (EXP)
  (DO ((TERMS EXP (CDR TERMS))
       (ANS))
      ((NULL TERMS) (ADDN ANS NIL))
    (LET ($LIFLAG)					;don't gen li's for
      (PUSH (INTEGRATOR (CAR TERMS) VAR) ANS))		;parts of integrand
    (WHEN (AND (NOT (FREE (CAR ANS) '%INTEGRATE))
	       (CDR TERMS))
	  (RETURN (ADDN (CONS (RISCHINT (CONS '(MPLUS) TERMS) VAR) (CDR ANS))
			NIL)))))

;(DEFUN ABSSUBST (EXP)
; (COND ((ATOM EXP) EXP)
;       ((EQ (CAAR EXP) 'MABS) (CADR EXP))
;       (T (CONS (CAR EXP) (MAPCAR 'ABSSUBST (CDR EXP))))))

(DEFUN SCEP (EXPR VAR &AUX TRIGL EXP)			;PROD OF SIN, COS, EXP
  (AND (MTIMESP EXPR)					;OF LINEAR ARGS
       (LOOP FOR FAC IN (CDR EXPR) DO
	     (COND ((ATOM FAC) (RETURN NIL))
		   ((TRIG1 (CAR FAC))
		    (IF (LINEARP (CADR FAC) VAR) (PUSH FAC TRIGL)
			(RETURN NIL)))
		   ((AND (MEXPTP FAC)
			 (EQ (CADR FAC) '$%E)
			 (LINEARP (CADDR FAC) VAR))
			;should be only 1 exponential factor
		    (SETQ EXP FAC))
		   (T (RETURN NIL)))
	     FINALLY (RETURN (CONS EXP TRIGL)))))

;integrates exponential * sin or cos, all with linear args.
(DEFUN SCE-INT (EXP S-C VAR)				;EXP is non-trivial
  (LET ((E-COEF (CAR (ISLINEAR (CADDR EXP) VAR)))
	(SC-COEF (CAR (ISLINEAR (CADR S-C) VAR)))
	(SC-ARG (CADR S-C)))
       (MUL (DIV EXP (ADD (POWER E-COEF 2) (POWER SC-COEF 2)))
	    (ADD (MUL E-COEF S-C)
		 (IF (EQ (CAAR S-C) '%SIN)
		     (MUL* (NEG SC-COEF) `((%COS) ,SC-ARG))
		     (MUL* SC-COEF `((%SIN) ,SC-ARG)))))))

(defun checkderiv (expr)
  (checkderiv1 (cadr expr) (cddr expr) () ))

;; CHECKDERIV1 gets called on the expression being differentiated,
;; an alternating list of variables being differentiated with
;; respect to and powers thereof, and a reversed list of the latter
;; that have already been examined.  It returns either the antiderivative
;; or (), saying this derivative isn't wrt the variable of integration.

(defun checkderiv1 (expr wrt old-wrt)
  (cond ((alike1 (car wrt) var)
	 (if (equal (cadr wrt) 1)		;Power = 1?
	     (if (null (cddr wrt))		;single or partial
		 expr				;single
		 `((%derivative) ,expr		;Partial, return rest
		   ,.(nreverse old-wrt)
		   ,@(cddr wrt)))
	     `((%derivative) ,expr			;Higher order, reduce order
	       ,.(nreverse old-wrt)
	       ,(car wrt) ,(add2* (cadr wrt) -1)
	       ,@ (cddr wrt))))
	((null (cddr wrt)) () )			;Say it doesn't apply here
	(t (checkderiv1 expr (cddr wrt)		;Else we check later terms
			(list* (cadr wrt) (car wrt) old-wrt)))))

(DEFUN ELEM (A) 
  (COND ((FREEVAR A) T)
	((ATOM A) NIL)
	((M2 A EXPRES NIL) T)
	(T (EVAL (CONS 'AND (MAPCAR #'ELEM (CDR A)))))))

(DEFUN FREEVAR (A) 
       (COND ((ATOM A) (NOT (EQ A VAR)))
	     ((ALIKE1 A VAR) NIL)
	     ((AND (NOT (ATOM (CAR A)))
		   (MEMQ 'ARRAY (CDAR A)))
	      (COND ((FREEVAR (CDR A)) T)
		    (T (MERROR "Variable of integration appeared in subscript"))))
	     (T (AND (FREEVAR (CAR A)) (FREEVAR (CDR A))))))

(DEFUN VARP (X) (ALIKE1 X VAR)) 

(DEFUN INTEGRALLOOKUPS (EXP) 
	 (COND ((EQ (CAAR EXP) '%LOG)
		(SUBSTITUTE (CADR EXP)
			    'X
			    '((MPLUS)
			      ((MTIMES) X ((%LOG) X))
			      ((MTIMES) -1 X))))
	       ((EQ (CAAR EXP) 'MPLUS)
		(MULN (LIST '((RAT SIMP) 1 2) EXP EXP) NIL))
	       ((EQ (CAAR EXP) 'MEXPT)
		(COND ((FREEVAR (CADR EXP))
		       (SIMPLIFYA (SUBSTITUTE EXP
					      'A
					      (SUBSTITUTE (CADR EXP)
							  'B
							  '((MTIMES)
							    A
							    ((MEXPT)
							     ((%LOG)
							      B)
							     -1))))
				  NIL))
		      ((OR (EQUAL (CADDR EXP) -1)
			   (AND (NOT (MNUMP (CADDR EXP)))
				(FREEOF '$%I (CADDR EXP))
				(EQ (ASKSIGN (POWER (ADD2 (CADDR EXP) 1) 2)) '$ZERO)))
		       (SUBSTITUTE (CADR EXP) 'X (LOGMABS 'X)))
		      (T (SUBSTITUTE (ADD2* (CADDR EXP) 1)
				     'N
				     (SUBSTITUTE (CADR EXP)
						 'X
						 '((MTIMES)
						   ((MEXPT) N -1)
						   ((MEXPT) X N)))))))
	       (T (SUBSTITUTE (CADR EXP)
			      'X
			      (CDR (SASSQ (CAAR EXP)
					  '((%SIN (MTIMES) -1 ((%COS) X))
					    (%COS (%SIN) X)
					    (%TAN (%LOG)
						  ((%SEC) X))
					    (%SEC (%LOG) ((MPLUS) ((%SEC) X) ((%TAN) X)))
					    (%COT (%LOG)
						  ((%SIN) X))
					    (%SINH (%COSH) X)
					    (%COSH (%SINH) X)
					    (%TANH (%LOG)
						   ((%COSH) X))
					    (%COTH (%LOG) ((%SINH) X))
					    (%SECH (%ATAN)
						   ((%SINH) X))
					    (%CSCH (%LOG) ((%TANH) ((MTIMES) ((RAT SIMP) 1 2) X)))
					    (%CSC (MTIMES)
						  -1
						  ((%LOG)
						   ((MPLUS)
						    ((%CSC) X)
						    ((%COT)
						     X)))))
					  'NILL))))))
 

(DEFUN TRUE (IGNORE) IGNORE T) 

(DEFUN RAT10 (EXP) 
		 (COND ((FREEVAR EXP) T)
		       ((ALIKE1 EXP VAR) NIL)
		       ((EQ (CAAR EXP) 'MEXPT)
			(COND ((ALIKE1 (CADR EXP) VAR)
			       (COND ((INTEGERP2 (CADDR EXP))
				      (SETQ POWERLIST
					    (CONS (CADDR EXP)
						  POWERLIST)))
				     (T NIL)))
			      (T (AND (RAT10 (CADR EXP))
				      (RAT10 (CADDR EXP))))))
		       ((MEMQ (CAAR EXP) '(MPLUS MTIMES))
			(AND (RAT10 (CADR EXP))
			     (OR (NULL (CDDR EXP))
				 (RAT10 (CONS (CAR EXP)
					      (CDDR EXP))))))
		       ((EQ (CAAR EXP) '%LOG)
			(RAT10 (CADR EXP)))
		       (T (RAT10 (CADR EXP)))))
	 

(DEFUN LISTGCD (POWERLIST) 
		 (PROG (D) 
		       (SETQ D (CAR POWERLIST))
		  LOOP (SETQ POWERLIST (CDR POWERLIST))
		       (COND ((equal D 1) (RETURN NIL)))
		       (COND ((NULL POWERLIST) (RETURN D)))
		       (SETQ D (GCD D (CAR POWERLIST)))
		       (GO LOOP)))
	 

(DEFUN INTEGRATE5 (EXP VAR)
 (IF (RAT8 EXP) (RATINT EXP VAR) (INTEGRATOR EXP VAR)))
	 
(DEFUN INTEGERP2 (X)
 (LET (Y) (COND ((NOT (NUMBERP X)) NIL)
		((NOT (FLOATP X)) X)
		((PROG2 (SETQ Y (RATIONALIZE X)) (EQUAL (CDR Y) 1)) (CAR Y))
		(T NIL))))
	 

(DEFUN RAT3 (EXP IND) 
		 (COND ((FREEVAR EXP) T)
		       ((ATOM EXP) IND)
		       ((MEMQ (CAAR EXP) '(MTIMES MPLUS))
			(AND (RAT3 (CADR EXP) IND)
			     (OR (NULL (CDDR EXP))
				 (RAT3 (CONS (CAR EXP) (CDDR EXP))
				       IND))))
		       ((NOT (EQ (CAAR EXP) 'MEXPT))
			(RAT3 (CADR EXP) T))
		       ((FREEVAR (CADR EXP)) (RAT3 (CADDR EXP) T))
		       ((FIXP (CADDR EXP)) (RAT3 (CADR EXP) IND))
		       ((AND (M2 (CADR EXP) RATROOT NIL)
			     (DENOMFIND (CADDR EXP)))
			(SETQ ROOTLIST
			      (CONS (DENOMFIND (CADDR EXP))
				    ROOTLIST)))
		       (T (RAT3 (CADR EXP) NIL))))
	 

(DEFUN SUBST4 (EXP) 
       (COND ((FREEVAR EXP) EXP)
	     ((ATOM EXP) A)
	     ((NOT (EQ (CAAR EXP) 'MEXPT))
	      (MAPCAR (FUNCTION (LAMBDA (C) (SUBST4 C)))
		      EXP))
	     ((M2 (CADR EXP) RATROOT NIL)
	      (LIST (CAR EXP)
		    B
		    (INTEGERP2 (TIMESK K (CADDR EXP)))))
	     (T (LIST (CAR EXP)
		      (SUBST4 (CADR EXP))
		      (SUBST4 (CADDR EXP))))))
	 

(DEFUN FINDINGK (LIST)
       (do ((k 1) (l list (cdr l)))
	   ((null l) k)
	   (setq k (lcm k (car l)))))

(DEFUN DENOMFIND (X) 
 (COND ((RATNUMP X) (CADDR X))
       ((NOT (NUMBERP X)) NIL)
       ((NOT (FLOATP X)) 1)
       (T (CDR (RATIONALIZE X)))))
	 


(DEFUN RATROOT (EXP VAR RATROOT W) 
	 (PROG (ROOTLIST K Y W1) 
	       (COND ((SETQ Y (CHEBYF EXP VAR)) (RETURN Y)))
	       (COND ((NOT (RAT3 EXP T)) (RETURN NIL)))
	       (SETQ K (FINDINGK ROOTLIST))
	       (SETQ W1 (CONS (CONS 'K K) W))
	       (SETQ Y
		     (SUBST41
		      EXP
		      (SIMPLIFY
		       (SUBLISS W1
				'((MQUOTIENT)
				  ((MPLUS) ((MTIMES) B E)
					   ((MTIMES) -1 D ((MEXPT) VAR K)))
				  ((MPLUS) ((MTIMES) C ((MEXPT) VAR K))
					   ((MTIMES) -1 E A)))))
		      VAR))
	       (SETQ Y
		     (INTEGRATOR
		      (SIMPLIFY
		       (LIST '(MTIMES)
			     Y
			     (SUBLISS
			      W1 '((MQUOTIENT)
				   ((MTIMES)
				    E ((MPLUS)
				       ((MTIMES) A D K
						 ((MEXPT) VAR ((MPLUS) -1 K)))
				       ((MTIMES)
					-1
					((MTIMES) B C K
						  ((MEXPT) VAR ((MPLUS) -1 K))))))
				   ((MEXPT) ((MPLUS)
					     ((MTIMES) C ((MEXPT) VAR K))
					     ((MTIMES) -1 A))
					    2)))))
		      VAR))
	       (RETURN (SUBSTINT (SIMPLIFY (LIST '(MEXPT)
						 RATROOT
						 (LIST '(MEXPT) K -1)))
				 VAR
				 Y))))
 

(DEFUN SUBST41 (EXP A B) (SUBST4 EXP)) 

(DEFUN CHEBYF (EXP VAR) 
  (PROG (R1 R2 D1 D2 N1 N2 W Q) 
	(COND ((NOT (SETQ W
			  (M2 EXP
			      '((MTIMES)
				((MEXPT) (VAR VARP) (R1 NUMBERP))
				((MEXPT)
				 ((MPLUS)
				  ((MTIMES)
				   ((COEFFTT) (C2 FREEVAR))
				   ((MEXPT) (VAR VARP) (Q FREE1)))
				  ((COEFFPP) (C1 FREEVAR)))
				 (R2 NUMBERP))
				((COEFFTT) (A FREEVAR)))
			      NIL)))
	       (RETURN NIL)))
	(SETQ Q (CDR (SASSQ 'Q W 'NILL)))
	(SETQ 
	 W
	 (LIST*
	  (CONS 'A (DIV* (CDR (SASSQ 'A W 'NILL)) Q))
	  (CONS
	   'R1
	   (DIV* (ADDN (LIST 1 (NEG (SIMPLIFY Q)) (CDR (SASSQ 'R1 W 'NILL))) NIL) Q))
	  W))
	(SETQ R1 (CDR (SASSQ 'R1 W 'NILL)) R2 (CDR (SASSQ 'R2 W 'NILL)))
	(COND
	 ((NOT (AND (SETQ D1 (DENOMFIND R1))
		    (SETQ D2 (DENOMFIND R2))
		    (SETQ N1 (INTEGERP2 (TIMESK R1 D1)))
		    (SETQ N2 (INTEGERP2 (TIMESK R2 D2)))
		    (SETQ W (LIST* (CONS 'D1 D1)
				   (CONS 'D2 D2)
				   (CONS 'N1 N1)
				   (CONS 'N2 N2)
				   W))))
	  (RETURN NIL))
	 ((AND (INTEGERP2 R1) (GREATERP R1 0))
	  (RETURN
	   (SUBSTINT
	    (SUBLISS W '((MPLUS) C1 ((MTIMES) C2 ((MEXPT) VAR Q))))
	    VAR
	    (INTEGRATOR
	     (EXPANDS (LIST (SUBLISS W
				     '((MTIMES)
				       A
				       ((MEXPT) VAR R2)
				       ((MEXPT)
					C2
					((MTIMES)
					 -1
					 ((MPLUS) R1 1))))))
		      (CDR (EXPANDEXPT (SUBLISS W
						 '((MPLUS)
						   VAR
						   ((MTIMES) -1 C1)))
					R1)))
	     VAR))))
	 ((INTEGERP2 R2)
	  (RETURN
	   (SUBSTINT (SUBLISS W '((MEXPT) VAR ((MQUOTIENT) Q D1)))
		       VAR
		       (RATINT (SIMPLIFY (SUBLISS W
						    '((MTIMES)
						      D1
						      A
						      ((MEXPT)
						       VAR
						       ((MPLUS)
							N1
							D1
							-1))
						      ((MEXPT)
						       ((MPLUS)
							((MTIMES)
							 C2
							 ((MEXPT)
							  VAR
							  D1))
							C1)
						       R2))))
		 VAR))))
	 ((AND (INTEGERP2 R1) (LESSP R1 0))
	  (RETURN
	   (SUBSTINT (SUBLISS W
				'((MEXPT)
				  ((MPLUS)
				   C1
				   ((MTIMES) C2 ((MEXPT) VAR Q)))
				  ((MQUOTIENT) 1 D2)))
		       VAR
		       (RATINT (SIMPLIFY (SUBLISS W
						    '((MTIMES)
						      A
						      D2
						      ((MEXPT)
						       C2
						       ((MTIMES)
							-1
							((MPLUS)
							 R1
							 1)))
						      ((MEXPT)
						       VAR
						       ((MPLUS)
							N2
							D2
							-1))
						      ((MEXPT)
						       ((MPLUS)
							((MEXPT)
							 VAR
							 D2)
							((MTIMES)
							 -1
							 C1))
						       R1))))
			VAR))))
	 ((INTEGERP2 (ADD2* R1 R2))
	  (RETURN
	   (SUBSTINT (SUBLISS W
				'((MEXPT)
				  ((MQUOTIENT)
				   ((MPLUS)
				    C1
				    ((MTIMES) C2 ((MEXPT) VAR Q)))
				   ((MEXPT) VAR Q))
				  ((MQUOTIENT) 1 D1)))
		       VAR
		       (RATINT (SIMPLIFY (SUBLISS W
						    '((MTIMES)
						      -1
						      A
						      D1
						      ((MEXPT)
						       C1
						       ((MPLUS)
							R1
							R2
							1))
						      ((MEXPT)
						       VAR
						       ((MPLUS)
							N2
							D1
							-1))
						      ((MEXPT)
						       ((MPLUS)
							((MEXPT)
							 VAR
							 D1)
							((MTIMES)
							 -1
							 C2))
						       ((MTIMES)
							-1
							((MPLUS)
							 R1
							 R2
							 2))))))
			VAR))))
	 (T (RETURN (LIST '(%INTEGRATE) EXP VAR))))))

(DEFUN RAT6 (EXP) 
	 (COND ((FREEVAR EXP) T)
	       ((ATOM EXP) T)
	       ((MEMQ (CAAR EXP) '(MPLUS MTIMES))
		(AND (RAT6 (CADR EXP))
		     (OR (NULL (CDDR EXP))
			 (RAT6 (CONS (CAR EXP) (CDDR EXP))))))
	       ((NOT (EQ (CAAR EXP) 'MEXPT)) NIL)
	       ((FIXP (CADDR EXP)) (RAT6 (CADR EXP)))
	       ((NOT (INTEGERP2 (MUL2* 2 (CADDR EXP))))
		NIL)
	       (T (M2 (CADR EXP) SQUARE NIL))))
 

(DEFUN SUBST6 (EXP A B) 
	 (COND ((FREEVAR EXP) EXP)
	       ((ATOM EXP) A)
	       ((MEMQ (CAAR EXP) '(MPLUS MTIMES))
		(CONS (CAR EXP)
		      (MAPCAR 
		       (FUNCTION (LAMBDA (C) (SUBST6 C A B)))
		       (CDR EXP))))
	       ((NOT (EQ (CAAR EXP) 'MEXPT))
		(MERROR "SUBST6"))
	       ((FIXP (CADDR EXP))
		(LIST (CAR EXP) (SUBST6 (CADR EXP) A B) (CADDR EXP)))
	       (T (LIST (CAR EXP)
			B
			(INTEGERP2 (TIMESK 2 (CADDR EXP)))))))
 

(DEFUN GREATERRATP (X1 X2) 
       (COND ((AND (NUMBERP X1) (NUMBERP X2)) (GREATERP X1 X2))
	     ((RATNUMP X1)
	      (GREATERRATP (QUOTIENT (FLOAT (CADR X1)) (CADDR X1)) X2))
	     ((RATNUMP X2)
	      (GREATERRATP X1 (QUOTIENT (FLOAT (CADR X2)) (CADDR X2))))))

(DEFUN TRIG1 (X) (MEMQ (CAR X) '(%SIN %COS))) 

(DEFUN SUPERTRIG (EXP) 
		 (COND ((FREEVAR EXP) T)
		       ((ATOM EXP) NIL)
		       ((MEMQ (CAAR EXP) '(MPLUS MTIMES))
			(AND (SUPERTRIG (CADR EXP))
			     (OR (NULL (CDDR EXP))
				 (SUPERTRIG (CONS (CAR EXP)
						  (CDDR EXP))))))
		       ((EQ (CAAR EXP) 'MEXPT)
			(AND (SUPERTRIG (CADR EXP))
			     (SUPERTRIG (CADDR EXP))))
		       ((EQ (CAAR EXP) '%LOG)
			(SUPERTRIG (CADR EXP)))
		       ((MEMQ (CAAR EXP)
			      '(%SIN %COS %TAN %SEC %COT %CSC))
			(COND ((M2 (CADR EXP) TRIGARG NIL) T)
			      ((M2 (CADR EXP)
				   '((MPLUS)
				     ((COEFFPT) (B FREEVAR) (X VARP))
				     ((COEFFPT) (A FREEVAR)))
				   NIL)
			       (AND (SETQ NOTSAME T) NIL))
			      (T (SUPERTRIG (CADR EXP)))))
		       (T (SUPERTRIG (CADR EXP)))))
	 

(DEFUN SUBST2S (EXP PAT) (COND ((NULL EXP) NIL)
				 ((M2 EXP PAT NIL) VAR)
				 ((ATOM EXP) EXP)
				 (T (CONS (SUBST2S (CAR EXP) PAT)
					  (SUBST2S (CDR EXP) PAT)))))
	 

(DEFUN MONSTERTRIG (EXP VAR TRIGARG) 
  (PROG (NOTSAME W A B Y D) 
	(COND
	 ((SUPERTRIG EXP) (GO A))
	 ((NULL NOTSAME) (RETURN NIL))
	 ((NOT (SETQ Y (M2 EXP
			   '((MTIMES)
			     ((COEFFTT) (A FREEVAR))
			     (((B TRIG1))
			      ((MTIMES)
			       (X VARP)
			       ((COEFFTT) (M FREEVAR))))
			     (((D TRIG1))
			      ((MTIMES)
			       (X VARP)
			       ((COEFFTT) (N FREEVAR)))))
			   NIL)))
	  (GO B))
	 ((NOT (AND (MEMQ (CAR (SETQ B
				     (CDR (SASSQ 'B
						 Y
						 'NILL))))
			  '(%SIN %COS))
		    (MEMQ (CAR (SETQ D
				     (CDR (SASSQ 'D
						 Y
						 'NILL))))
			  '(%SIN %COS))))
	  (RETURN NIL))
	 ((AND (EQ (CAR B) '%SIN) (EQ (CAR D) '%SIN))
	  (RETURN (SUBVAR (SUBLISS Y
				   '((MTIMES)
				     A
				     ((MPLUS)
				      ((MQUOTIENT)
				       ((%SIN)
					((MTIMES)
					 ((MPLUS) M ((MTIMES) -1 N))
					 X))
				       ((MTIMES)
					2
					((MPLUS) M ((MTIMES) -1 N))))
				      ((MTIMES)
				       -1
				       ((MQUOTIENT)
					((%SIN)
					 ((MTIMES) ((MPLUS) M N) X))
					((MTIMES)
					 2
					 ((MPLUS) M N))))))))))
	 ((AND (EQ (CAR B) '%COS) (EQ (CAR D) '%COS))
	  (RETURN (SUBVAR (SUBLISS Y
				   '((MTIMES)
				     A
				     ((MPLUS)
				      ((MQUOTIENT)
				       ((%SIN)
					((MTIMES)
					 ((MPLUS) M ((MTIMES) -1 N))
					 X))
				       ((MTIMES)
					2
					((MPLUS) M ((MTIMES) -1 N))))
				      ((MQUOTIENT)
				       ((%SIN)
					((MTIMES) ((MPLUS) M N) X))
				       ((MTIMES)
					2
					((MPLUS) M N)))))))))
	 ((OR (AND (EQ (CAR B) '%COS)
		   (SETQ W (CDR (SASSQ 'M Y 'NILL)))
		   (RPLACD (SASSQ 'M Y 'NILL)
			   (CDR (SASSQ 'N Y 'NILL)))
		   (RPLACD (SASSQ 'N Y 'NILL) W))
	      T)
	  (RETURN (SUBVAR (SUBLISS Y
				   '((MTIMES)
				     -1
				     A
				     ((MPLUS)
				      ((MQUOTIENT)
				       ((%COS)
					((MTIMES)
					 ((MPLUS) M ((MTIMES) -1 N))
					 X))
				       ((MTIMES)
					2
					((MPLUS) M ((MTIMES) -1 N))))
				      ((MQUOTIENT)
				       ((%COS)
					((MTIMES) ((MPLUS) M N) X))
				       ((MTIMES)
					2
					((MPLUS) M N))))))))))
   B    (COND ((NOT (SETQ Y (PROG2 (SETQ TRIGARG VAR)
				   (M2 EXP
				       '((MTIMES)
					 ((COEFFTT) (A FREEVAR))
					 (((B TRIG1))
					  ((MTIMES)
					   (X VARP)
					   ((COEFFTT) (N INTEGERP2))))
					 ((COEFFTT) (C SUPERTRIG)))
				       NIL))))
	       (RETURN NIL)))
	(RETURN
	 (INTEGRATOR
	  ($EXPAND
	   (LIST '(MTIMES)
		 (SCH-REPLACE Y 'A)
		 (SCH-REPLACE Y 'C)
		 (COND ((EQ (CAR (SETQ B (SCH-REPLACE Y 'B))) '%COS)
			(SUBSTITUTE VAR
				    'X
				    (SUPERCOSNX (SCH-REPLACE Y 'N))))
		       (T (SUBSTITUTE VAR
				      'X
				      (SUPERSINX (SCH-REPLACE Y 'N)))))))
	  VAR))
   A    (SETQ W (SUBST2S EXP TRIGARG))
	(SETQ B (CDR (SASSQ 'B
			    (M2 TRIGARG
				'((MPLUS)
				  ((COEFFPT) (B FREEVAR) (X VARP))
				  ((COEFFPT) (A FREEVAR)))
				NIL)
			    'NILL)))
	(SETQ A (SUBSTINT TRIGARG
			    VAR
			    (TRIGINT (DIV* W B) VAR)))
(COND((M2 A '((MTIMES)((COEFFTT)(D FREEVAR)) ((%INTEGRATE ) (B TRUE) (C TRUE)))NIL) 
  (RETURN(LIST '(%INTEGRATE) EXP VAR))))
(RETURN A)  ))

(DEFUN TRIG2 (X) (MEMQ (CAR X) '(%SIN %COS %TAN %COT %SEC %CSC)))

(DEFUN SUPERSINX (N) ((LAMBDA (I) 
			      ($EXPAND (LIST '(MTIMES)
					      I
					      (SINNX (TIMESK I N)))))
		      (COND ((LESSP N 0) -1) (T 1))))
	 

(DEFUN SUPERCOSNX (N) ((LAMBDA (I) ($EXPAND (COSNX (TIMESK I N))))
		      (COND ((LESSP N 0) -1) (T 1))))
	 

(DEFUN SINNX (N) (COND ((EQUAL N 1) '((%SIN) X))
			   (T (LIST '(MPLUS)
				    (LIST '(MTIMES)
					  '((%SIN) X)
					  (COSNX (SUB1 N)))
				    (LIST '(MTIMES)
					  '((%COS) X)
					  (SINNX (SUB1 N)))))))
	 

(DEFUN COSNX (N) (COND ((EQUAL N 1) '((%COS) X))
			   (T (LIST '(MPLUS)
				    (LIST '(MTIMES)
					  '((%COS) X)
					  (COSNX (SUB1 N)))
				    (LIST '(MTIMES)
					  -1
					  '((%SIN) X)
					  (SINNX (SUB1 N)))))))
	 

(DEFUN POSEVEN (X) (AND (EVEN X) (GREATERP X -1))) 

(DEFUN TRIGFREE (X) 
	 (COND ((ATOM X) (NOT (MEMQ X '(SIN* COS* SEC* TAN*))))
	       (T (AND (TRIGFREE (CAR X)) (TRIGFREE (CDR X))))))

(DEFUN RAT1 (EXP) (PROG (B1 NOTSAME) 
			     (COND ((AND (NUMBERP EXP) (ZEROP EXP))
				    (RETURN NIL)))
			     (SETQ B1 (SUBST B 'B '((MEXPT) B (N EVEN))))
			     (RETURN (PROG2 (SETQ YY (RATS EXP))
					    (COND ((NOT NOTSAME) YY))))))

(DEFUN RATS (EXP) 
  (PROG (Y) 
	(RETURN
	 (COND ((EQ EXP A) 'X)
	       ((ATOM EXP)
		(COND ((MEMQ EXP '(SIN* COS* SEC* TAN*))
		       (SETQ NOTSAME T))
		      (T EXP)))
	       ((SETQ Y (M2 EXP B1 NIL)) (F3 Y))
	       (T (CONS (CAR EXP)
			(MAPCAR 
			 (FUNCTION (LAMBDA (G) (RATS G)))
			 (CDR EXP))))))))
 

(DEFUN F3 (Y) 
	 (SUBSTITUTE C
		     'C
		     (SUBSTITUTE (QUOTIENT (CDR (SASSQ 'N Y NIL)) 2)
				 'N
				 '((MEXPT)
				   ((MPLUS)
				    1
				    ((MTIMES)
				     C
				     ((MEXPT) X 2)))
				   N))))

(DEFUN ODD1 (N) 
	 (COND ((NOT (NUMBERP N)) NIL)
	       ((NOT (EQUAL (REMAINDER N 2) 0))
		(SETQ YZ
		      (SUBSTITUTE C
				  'C
				  (LIST '(MEXPT)
					'((MPLUS)
					  1
					  ((MTIMES)
					   C
					   ((MEXPT) X 2)))
					(QUOTIENT (SUB1 N) 2)))))
	       (T NIL)))

(DEFUN SUBVAR (X) (SUBSTITUTE VAR 'X X)) 

(DEFUN SUBVARDLG (X) 
       (MAPCAR #'(LAMBDA (M) (CONS (SUBSTITUTE VAR 'X (CAR M))
				   (CDR M)))
	       X))

(DEFUN TRIGINT (EXP VAR) 
  (PROG (Y REPL Y1 Y2 YY Z M N C YZ A B ) 
	(SETQ Y2
	      (SUBLISS (SUBVARDLG '((((%SIN) X) . SIN*)
				    (((%COS) X) . COS*)
				    (((%TAN) X) . TAN*)
				    (((%COT) X) (MEXPT) TAN* -1)
				    (((%SEC) X) . SEC*)
				    (((%CSC) X) (MEXPT) SIN* -1)))
		       (SIMPLIFYA EXP NIL)))
	(SETQ Y1 (SETQ Y (SIMPLIFY (SUBLISS '((TAN* (MTIMES)
						SIN*
						((MEXPT) COS* -1))
					  (SEC* (MEXPT) COS* -1))
					Y2))))
	(COND ((NULL (SETQ Z (M2 Y
				 '((MTIMES)
				   ((COEFFTT) (B TRIGFREE))
				   ((MEXPT) SIN* (M POSEVEN))
				   ((MEXPT) COS* (N POSEVEN)))
				 NIL)))
	       (GO L1)))
	(SETQ M (CDR (SASSQ 'M Z 'NILL)))
	(SETQ N (CDR (SASSQ 'N Z 'NILL)))
	(SETQ A (INTEGERP2 (TIMES 0.5
				 (COND ((LESSP M N) 1) (T -1))
				 (PLUS N (TIMES -1 M)))))
	(SETQ Z (CONS (CONS 'A A) Z))
	(RETURN
	 (SIMPLIFY
	  (LIST
	   '(MTIMES)
	   (CDR (SASSQ 'B Z 'NILL))
	   '((RAT SIMP) 1 2)
	   (SUBSTINT
	    (LIST '(MTIMES) 2 VAR)
	    'X
	    (INTEGRATOR (SIMPLIFY (COND ((LESSP M N)
				     (SUBLISS Z
					      '((MTIMES)
						((MEXPT)
						 ((MTIMES)
						  ((RAT SIMP) 1 2)
						  ((%SIN) X))
						 M)
						((MEXPT)
						 ((MPLUS)
						  ((RAT SIMP) 1 2)
						  ((MTIMES)
						   ((RAT SIMP) 1 2)
						   ((%COS) X)))
						 A))))
				    (T (SUBLISS Z
						'((MTIMES)
						  ((MEXPT)
						   ((MTIMES)
						    ((RAT SIMP) 1 2)
						    ((%SIN) X))
						   N)
						  ((MEXPT)
						   ((MPLUS)
						    ((RAT SIMP) 1 2)
						    ((MTIMES)
						     ((RAT SIMP)
						      -1
						      2)
						     ((%COS) X)))
						   A))))))
			'X)))))
   L1   (SETQ C -1)
	(SETQ A 'SIN*)
	(SETQ B 'COS*)
	(COND ((AND (M2 Y
			'((COEFFPT) (C RAT1) ((MEXPT) COS* (N ODD1)))
			NIL)
		    (SETQ REPL (LIST '(%SIN) VAR)))
	       (GO GETOUT)))
	(SETQ A B)
	(SETQ B 'SIN*)
	(COND ((AND (M2 Y
			'((COEFFPT) (C RAT1) ((MEXPT) SIN* (N ODD1)))
			NIL)
		    (SETQ REPL (LIST '(%COS) VAR)))
	       (GO GET3)))
	(SETQ Y
	      (SIMPLIFY (SUBLISS '((SIN* (MTIMES) TAN* ((MEXPT) SEC* -1))
			       (COS* (MEXPT) SEC* -1))
			     Y2)))
	(SETQ C 1)
	(SETQ A 'TAN*)
	(SETQ B 'SEC*)
	(COND ((AND (RAT1 Y) (SETQ REPL (LIST '(%TAN) VAR)))
	       (GO GET1)))
	(SETQ A B)
	(SETQ B 'TAN*)
	(COND ((AND (M2 Y
			'((COEFFPT) (C RAT1) ((MEXPT) TAN* (N ODD1)))
			NIL)
		    (SETQ REPL (LIST '(%SEC) VAR)))
	       (GO GETOUT)))
(COND((NOT (ALIKE1(SETQ REPL ($EXPAND EXP))EXP))(RETURN(INTEGRATOR REPL VAR))))
	(SETQ Y
	      (SIMPLIFY (SUBLISS '((SIN* (MTIMES)
				     2
				     X
				     ((MEXPT)
				      ((MPLUS) 1 ((MEXPT) X 2))
				      -1))
			       (COS* (MTIMES)
				     ((MPLUS)
				      1
				      ((MTIMES) -1 ((MEXPT) X 2)))
				     ((MEXPT)
				      ((MPLUS) 1 ((MEXPT) X 2))
				      -1)))
			     Y1)))
	(SETQ Y (LIST '(MTIMES)
		      Y
		      '((MTIMES)
			2
			((MEXPT) ((MPLUS) 1 ((MEXPT) X 2)) -1))))
	(SETQ REPL (SUBVAR '((MQUOTIENT)
			     ((%SIN) X)
			     ((MPLUS) 1 ((%COS) X)))))
	(GO GET2)
   GET3 (SETQ Y (LIST '(MTIMES) -1 YY YZ))
	(GO GET2)
   GET1 (SETQ Y (LIST '(MTIMES)
		      '((MEXPT) ((MPLUS) 1 ((MEXPT) X 2)) -1)
		      YY))
	(GO GET2)
   GETOUT
	(SETQ Y (LIST '(MTIMES) YY YZ))
   GET2 (SETQ Y (SIMPLIFY Y))
	(RETURN (SUBSTINT REPL 'X (INTEGRATOR Y 'X)))))

(DEFUN SININT (EXP VAR)
 (FIND-FUNCTION 'RATINT)  ; Make sure that RATINT is in core.
 (COND ((NONVARCHK VAR '$INTEGRATE T T))
       (($RATP VAR) (SININT EXP (RATDISREP VAR)))
       (($RATP EXP) (SININT (RATDISREP EXP) VAR))
       ((MXORLISTP EXP)
	(CONS (CAR EXP) (MAPCAR #'(LAMBDA (Y) (SININT Y VAR)) (CDR EXP))))
       ((MEQUALP EXP)
	(LIST (CAR EXP) (SININT (CADR EXP) VAR)
			(ADD2 (SININT (CADDR EXP) VAR)
			      (CONCAT '$INTEGRATIONCONSTANT
				      (SETQ $INTEGRATION_CONSTANT_COUNTER 
					    (1+ $INTEGRATION_CONSTANT_COUNTER))))))
       ((AND (ATOM VAR) (ISINOP EXP VAR)) (LIST '(%INTEGRATE) EXP VAR))
       ((LET
	 ((ANS (SIMPLIFY
		(LET ($OPSUBST VARLIST GENVAR STACK) (INTEGRATOR EXP VAR)))))
	 (IF (SUM-OF-INTSP ANS) (LIST '(%INTEGRATE) EXP VAR) ANS)))))

(DEFUN SUM-OF-INTSP (ANS)
       (COND ((ATOM ANS) (NOT (EQ ANS VAR)))
	     ((MPLUSP ANS) (ANDMAPC #'SUM-OF-INTSP (CDR ANS)))
	     ((EQ (CAAR ANS) '%INTEGRATE) T)
	     ((MTIMESP ANS)
	      (DO ((FACS (CDR ANS) (CDR FACS))
		   (INTS))
		  ((NULL FACS) (< (LENGTH INTS) 2))
		  (UNLESS (FREEOF VAR (CAR FACS))
			  (IF (SUM-OF-INTSP (CAR FACS)) (PUSH (CAR FACS) INTS)
			      (RETURN NIL)))))
	     ((FREEOF VAR ANS) T)
	     (T NIL)))

(DEFUN INTSUM (FORM VAR)
 (PROG (EXP IDX LL UL PAIR VAL)
       (SETQ EXP (CADR FORM) IDX (CADDR FORM)
	     LL (CADDDR FORM) UL (CAR (CDDDDR FORM)))
       (IF (OR (NOT (ATOM VAR)) (NOT (FREE IDX VAR))
	       (NOT (FREE LL VAR)) (NOT (FREE UL VAR)))
	   (RETURN (LIST '(%INTEGRATE) FORM VAR)))
       (SETQ PAIR (PARTITION EXP VAR 1))
       (WHEN (AND (MEXPTP (CDR PAIR)) (EQ (CADDR PAIR) VAR))
	     (SETQ VAL (SUBSTITUTE LL IDX (CADDDR PAIR)))
	     (COND ((EQUAL VAL -1)
		    (RETURN (ADD2 (INTEGRATOR (SUBSTITUTE LL IDX EXP) VAR)
				  (INTSUM1 EXP IDX (ADD2 1 LL) UL VAR))))
		   ((MLSP VAL -1)
		    (RETURN (LIST '(%INTEGRATE) FORM VAR)))))
       (RETURN (INTSUM1 EXP IDX LL UL VAR))))

(DEFUN INTSUM1 (EXP IDX LL UL VAR)
 (ASSUME (LIST '(MGEQP) IDX LL))
 (IF (NOT (EQ UL '$INF)) (ASSUME (LIST '(MGEQP) UL IDX)))
 (SIMPLIFYA (LIST '(%SUM) (INTEGRATOR EXP VAR) IDX LL UL) T))

(DEFUN RAT8PRIME (C) (AND (RAT8 C) (OR (NOT (MNUMP C)) (NOT (ZEROP1 C)))))

(DEFUN FINDS (X) 
 (IF (ATOM X) (MEMQ X '(%LOG %INTEGRATE %ATAN))
	      (OR (FINDS (CAR X)) (FINDS (CDR X)))))

(DEFUN RATLOG (EXP VAR FORM) 
  (PROG (A B C D Y Z W) 
	(SETQ Y FORM)
	(SETQ B (CDR (SASSQ 'B Y 'NILL)))
	(SETQ C (CDR (SASSQ 'C Y 'NILL)))
	(SETQ Y (INTEGRATOR C VAR))
	(COND ((FINDS Y) (RETURN NIL)))
	(SETQ D (SDIFF (CDR (SASSQ 'A FORM 'NILL))
		       VAR))

        (SETQ Z (INTEGRATOR (MUL2* Y D) VAR))
        (SETQ D (CDR (SASSQ 'A FORM 'NILL)))
	(RETURN (SIMPLIFY (LIST '(MPLUS)
			    (LIST '(MTIMES) Y D)
			    (LIST '(MTIMES) -1 Z))))))

(DEFUN FIND1 (Y A) 
	 (COND ((EQ Y A) T)
	       ((ATOM Y) NIL)
	       (T (OR (FIND1 (CAR Y) A) (FIND1 (CDR Y) A)))))
(DEFUN MATCHSUM (ALIST BLIST) 
  (PROG (R S C D) 
	(SETQ S (M2 (CAR ALIST)
		    '((MTIMES)
		      ((COEFFTT) (A FREEVAR))
		      ((COEFFTT) (C TRUE)))
		    NIL))
	(SETQ C (CDR (SASSQ 'C S 'NILL)))
	(COND ((NOT (SETQ R
			  (M2 (CONS '(MPLUS) BLIST)
			      (LIST '(MPLUS)
				    (CONS '(MTIMES)
					  (CONS '((COEFFTT) (B FREE1))
						(COND ((MTIMESP C)
						       (CDR C))
						      (T (LIST C)))))
				    '(D TRUE))
			      NIL)))
	       (RETURN NIL)))
	(SETQ D (SIMPLIFY (LIST '(MTIMES)
			    (SUBLISS S 'A)
			    (LIST '(MEXPT)
				  (SUBLISS R 'B)
				  -1))))
	(COND ((M2 (CONS '(MPLUS) ALIST)
		   (TIMESLOOP D BLIST)
		   NIL)
	       (RETURN D))
	      (T (RETURN NIL)))))
 
(DEFUN TIMESLOOP (A B)
 (CONS '(MPLUS) (MAPCAR (FUNCTION (LAMBDA (C) (MUL2* A C))) B)))   

(DEFUN SIMPLOG (A) (SIMPLIFYA (CONS '(%LOG) A) NIL))

(DEFUN EXPANDS (AA B) 
 (ADDN (MAPCAR (FUNCTION (LAMBDA (C) (TIMESLOOP C AA))) B) NIL))

(DEFUN POWERLIST (EXP VAR) 
  (PROG (Y Z C D POWERLIST B) 
	(SETQ Y (M2 EXP
		    '((MTIMES)
		      ((MEXPT) (VAR VARP) (C INTEGERP2))
		      ((COEFFTT) (A FREEVAR))
		      ((COEFFTT) (B TRUE)))
		    NIL))
	(SETQ B (CDR (SASSQ 'B Y 'NILL)))
	(SETQ C (CDR (SASSQ 'C Y 'NILL)))
	(COND ((NOT (SETQ Z (RAT10 B))) (RETURN NIL)))
	(SETQ D (LISTGCD (CONS (ADD1 C) POWERLIST)))
	(COND ((OR (NULL D) (ZEROP D)) (RETURN NIL)))
	(RETURN
	 (SUBSTINT
	  (LIST '(MEXPT) VAR D)
	  VAR
	  (INTEGRATE5 (SIMPLIFY (LIST '(MTIMES)
				  (POWER* D -1)
				  (CDR (SASSQ 'A
					      Y
					      'NILL))
				  (LIST '(MEXPT)
					VAR
					(SUB1 (QUOTIENT (ADD1 C) D)))
				  (SUBST10 B)))
		      VAR)))))

(DEFUN DIFFDIV (EXP VAR) 
  (PROG (Y A X V D Z W R) 
	(COND
	 ((AND (MEXPTP EXP)
	       (MPLUSP (CADR EXP))
	       (INTEGERP2 (CADDR EXP))
	       (LESSP (CADDR EXP) 6)
	       (GREATERP (CADDR EXP) 0))
	  (RETURN (INTEGRATOR (EXPANDEXPT (CADR EXP) (CADDR EXP)) VAR))))
	(SETQ EXP (COND ((MTIMESP EXP) EXP) (T (LIST '(MTIMES) EXP))))
	(SETQ Z (CDR EXP))
   A    (SETQ Y (CAR Z))
	(SETQ R (LIST '(MPLUS)
		      (CONS '(COEFFPT)
			    (CONS '(C FREE1)
				  (CHOICESIN Y (CDR EXP))))))
	(COND
	 ((SETQ W (M2 (SDIFF Y VAR) R NIL))
	  (RETURN (MULN (LIST Y Y (POWER* (MUL2* 2 (CDR (SASSQ 'C W 'NILL))) -1)) NIL))))
	(SETQ W (COND ((OR (ATOM Y) (MEMQ (CAAR Y) '(MPLUS MTIMES))) Y)
		      ((EQ (CAAR Y) 'MEXPT)
		       (COND ((FREEVAR (CADR Y)) (CADDR Y))
			     ((FREEVAR (CADDR Y)) (CADR Y))
			     (T 0)))
		      (T (CADR Y))))
	(COND
	 ((SETQ W (COND ((AND (SETQ X (SDIFF W VAR))
			      (MPLUSP X)
			      (SETQ D (CHOICESIN Y (CDR EXP)))
			      (SETQ V (CAR D))
			      (MPLUSP V)
			      (NOT (CDR D)))
			 (COND ((SETQ D (MATCHSUM (CDR X) (CDR V)))
				(LIST (CONS 'C D)))
			       (T NIL)))
			(T (M2 X R NIL))))
	  (RETURN (COND ((NULL (SETQ X (INTEGRALLOOKUPS Y))) NIL)
			((EQ W T) X)
			(T (MUL2* X (POWER* (CDR (SASSQ 'C W 'NILL)) -1)))))))
	(SETQ Z (CDR Z))
	(COND ((NULL Z) (RETURN NIL)))
	(GO A)))
 
(DEFUN SUBLISS (A B) 
       (PROG (X Y Z) 
	     (SETQ X B)
	     (SETQ Z A)
	LOOP (COND ((NULL Z) (RETURN X)))
	     (SETQ Y (CAR Z))
	     (SETQ X (SUBSTITUTE (CDR Y) (CAR Y) X))
	     (SETQ Z (CDR Z))
	     (GO LOOP)))

(DEFUN SUBSTINT (X Y EXPRES)
       (COND ((AND (NOT (ATOM EXPRES)) (EQ (CAAR EXPRES) '%INTEGRATE))
	      (LIST (CAR EXPRES) EXP VAR))
	     (T (SUBSTINT1 (SUBSTITUTE X Y EXPRES)))))

(DEFUN SUBSTINT1 (EXP)
       (COND ((ATOM EXP) EXP)
	     ((AND (EQ (CAAR EXP) '%INTEGRATE) (NULL (CDDDR EXP))
		   (NOT (SYMBOLP (CADDR EXP))) (NOT (FREE (CADDR EXP) VAR)))
	      (SIMPLIFY (LIST '(%INTEGRATE) (MUL2 (CADR EXP) (SDIFF (CADDR EXP) VAR))
			       VAR)))
	     (T (RECUR-APPLY #'SUBSTINT1 EXP))))
