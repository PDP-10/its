;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module trgred)

(DECLARE (GENPREFIX PS)
	 (FIXNUM %N %NN)
	 (NOTYPE (SIN^N FIXNUM) (COS^N FIXNUM) (SINH^N FIXNUM)
		 (COSH^N FIXNUM) (CS^N FIXNUM))
	 (*LEXPR $GCD $DIVIDE $RATSIMP $FACTOR)
	 (SPECIAL VAR *N *A *SP1LOGF SPLIST *VAR USEXP $VERBOSE ANS *TRIGRED
		  *NOEXPAND SC^NDISP *LIN *TRIG LAWS TRIGLAWS HYPERLAWS
		  $TRIGEXPAND TRIGBUCKETS HYPERBUCKETS HALF%PI
		  TRANS-LIST-PLUS $RATPRINT $KEEPFLOAT))

(load-macsyma-macros rzmac)


;The Trigreduce file contains a group of routines which can be used to
;make trigonometric simplifications of expressions.  The bulk of the 
;routines here involve the reductions of products of sin's and cos's.
;
;	*TRIGRED	indicates that the special simplifications for
;			$TRIGREDUCE are to be used.
;	*NOEXPAND	indicates that trig functions of sums of 
;			angles are not to be used.

(DEFMFUN $TRIGREDUCE N
 (LET ((*TRIGRED T) (*NOEXPAND T) VAR $TRIGEXPAND $VERBOSE $RATPRINT)
      (COND ((= N 2) (SETQ VAR (ARG 2)))
	    ((= N 1) (SETQ VAR '*NOVAR))
	    (T (merror "Wrong number of args to TRIGREDUCE")))
      (GCDRED (SP1 (ARG 1)))))

(DEFUN SP1 (E)
    (COND ((ATOM E) E)
	  ((EQ (CAAR E) 'MPLUS)
	   (DO ((L TRANS-LIST-PLUS (CDR L)) (A))
	       ((NULL L) (M+L (MAPCAR 'SP1 (CDR E))))
	       (AND (SETQ A (M2 E (CAAR L) NIL))
		    (RETURN (SP1 (SCH-REPLACE A (CADAR L)))))))
	  ((EQ (CAAR E) 'MTIMES)
	   (SP1TIMES E))
	  ((EQ (CAAR E) 'MEXPT)
	   (SP1EXPT (SP1 (CADR E)) (SP1 (CADDR E))))
	  ((EQ (CAAR E) '%LOG)
	   (SP1LOG (SP1 (CADR E))))
	  ((MEMQ (CAAR E) '(%COS %SIN %TAN %COT %SEC %CSC
			    %COSH %SINH %TANH %COTH %SECH %CSCH))
	   (SP1TRIG (LIST (CAR E) ((LAMBDA (*NOEXPAND) (SP1 (CADR E))) T))))
	  ((MEMQ (CAAR E) '(%ASIN %ACOS %ATAN %ACOT %ASEC %ACSC
			    %ASINH %ACOSH %ATANH %ACOTH %ASECH %ACSCH))
	   (SP1ATRIG (CAAR E) ((LAMBDA (*NOEXPAND) (SP1 (CADR E))) T)))
	  ((EQ (CAAR E) 'MRAT) (SP1 (RATDISREP E)))
	  ((MBAGP E) (CONS (CAR E) (MAPCAR #'SP1 (CDR E))))
	  ((EQ (CAAR E) '%INTEGRATE)
	   (LIST* '(%INTEGRATE) (SP1 (CADR E)) (CDDR E)))
	  (T E)))

(SETQ TRANS-LIST-PLUS
'( (((MPLUS) ((COEFFPT) (C TRUE) ((MEXPT) ((%TAN) (X TRUE)) 2))
	     (VAR* (UVAR) C))   
    ((MTIMES) C ((MEXPT) ((%SEC) X) 2)))
   (((MPLUS) ((COEFFPT) (C TRUE) ((MEXPT) ((%COT) (X TRUE)) 2))
	     (VAR* (UVAR) C))
    ((MTIMES) C ((MEXPT) ((%CSC) X) 2)))
   (((MPLUS) ((COEFFPT) (C TRUE) ((MEXPT) ((%TANH) (X TRUE)) 2))
	     ((MTIMES) -1 (VAR* (UVAR) C)))
    ((MTIMES) -1 C ((MEXPT) ((%SECH) X) 2)))
   (((MPLUS) ((COEFFPT) (C TRUE) ((MEXPT) ((%COTH) (X TRUE)) 2))
	     ((MTIMES) -1 (VAR* (UVAR) C)))
    ((MTIMES) C ((MEXPT) ((%CSCH) X) 2))) ))

(DEFUN TRIGFP (E) (OR (AND (NOT (ATOM E)) (TRIGP (CAAR E))) (EQUAL E 1)))

(DEFUN GCDRED (E)
    (COND ((ATOM E) E)
	  ((EQ (CAAR E) 'MPLUS) (M+L (MAPCAR 'GCDRED (CDR E))))
	  ((EQ (CAAR E) 'MTIMES)
	   ((LAMBDA (NN ND GCD)
		(DO ((E (CDR E) (CDR E)))
		    ((NULL E)
		     (SETQ NN (M*L NN) ND (M*L ND)))
		    (COND ((AND (MEXPTP (CAR E))
				(OR (SIGNP L (CADDAR E))
				    (AND (MTIMESP (CADDAR E))
					 (SIGNP L (CADR (CADDAR E))))))
			   (SETQ ND (CONS (M^ (CADAR E) (M- (CADDAR E))) ND)))
			  ((RATNUMP (CAR E))
			   (SETQ NN (CONS (CADAR E) NN)
				 ND (CONS (CADDAR E) ND)))
			  ((SETQ NN (CONS (CAR E) NN)))))
		(COND ((EQUAL ND 1) NN)
		      ((EQUAL (SETQ GCD ($GCD NN ND)) 1) E)
		      ((DIV* (CADR ($DIVIDE NN GCD))
			     (CADR ($DIVIDE ND GCD))))))
	     '(1) '(1) NIL))
	  (T E)))

(DEFUN SP1TIMES (E)
  ((LAMBDA (FR G TRIGBUCKETS HYPERBUCKETS TR HYP *LIN)
    (DO ((E (CDR E) (CDR E)))
	((NULL E) (SETQ G (MAPCAR 'SP1 G)))
	(COND ((OR (MNUMP (CAR E))
		   (AND (NOT (EQ VAR '*NOVAR)) (FREE (CAR E) VAR)))
	       (SETQ FR (CONS (CAR E) FR)))
	      ((ATOM (CAR E)) (SETQ G (CONS (CAR E) G)))
	      ((OR (TRIGFP (CAR E))
		   (AND (EQ (CAAAR E) 'MEXPT) (TRIGFP (CADAR E))))
	       (SP1ADD (CAR E)))
	      ((SETQ G (CONS (CAR E) G)))))
    (MAPCAR '(LAMBDA (Q) (SP1SINCOS Q T)) TRIGBUCKETS)
    (MAPCAR '(LAMBDA (Q) (SP1SINCOS Q NIL)) HYPERBUCKETS)
    (SETQ FR (CONS (M^ (1//2) (M+L *LIN)) FR)
	  *LIN NIL)
    (SETQ TR (CONS '* (MAPCAN 'SP1UNTREP TRIGBUCKETS)))
    (SETQ G (NCONC (SP1TLIN TR T) (SP1TPLUS *LIN T) G)
	  *LIN NIL)
    (SETQ HYP (CONS '* (MAPCAN 'SP1UNTREP HYPERBUCKETS)))
    (SETQ G (NCONC (SP1TLIN HYP NIL) (SP1TPLUS *LIN NIL) G))
    (SETQ G ($EXPAND ((LAMBDA ($KEEPFLOAT) ($RATSIMP (CONS '(MTIMES) G))) T)))
    (COND ((MTIMESP G) (SETQ G (MAPCAR 'SP1 (CDR G))))
	  ((SETQ G (LIST (SP1 G)))))
    (M*L (CONS 1 (NCONC G FR (CDR TR) (CDR HYP)))))
   NIL '(1) NIL NIL NIL NIL '(0)))

(SETQ TRIGLAWS
'(* %SIN (* %COT %COS %SEC %TAN) %COS (* %TAN %SIN %CSC %COT)
    %TAN (* %COS %SIN %CSC %SEC) %COT (* %SIN %COS %SEC %CSC)
    %SEC (* %SIN %TAN %COT %CSC) %CSC (* %COS %COT %TAN %SEC)))

(SETQ HYPERLAWS
'(* %SINH (* %COTH %COSH %SECH %TANH) %COSH (* %TANH %SINH %CSCH %COTH)
    %TANH (* %COSH %SINH %CSCH %SECH) %COTH (* %SINH %COSH %SECH %CSCH)
    %SECH (* %SINH %TANH %COTH %CSCH) %CSCH (* %COSH %COTH %TANH %SECH)))

(DEFUN SP1TLIN (L *TRIG) (SP1TLIN1 L))

(DEFUN SP1TLIN1 (L)
    (COND ((NULL (CDR L)) NIL)
	  ((AND (EQ (CAAADR L) 'MEXPT)
		(FIXP (CADDR (CADR L)))
	 	(MEMQ (CAAADR (CADR L))
		      (OR (AND *TRIG '(%SIN %COS)) '(%SINH %COSH))))
	   (CONS (FUNCALL (CDR (ASSQ (CAAADR (CADR L)) SC^NDISP))
			  (CADDR (CADR L)) (CADADR (CADR L)))
		 (SP1TLIN1 (RPLACD L (CDDR L)))))
	  ((MEMQ (CAAADR L) (OR (AND *TRIG '(%SIN %COS)) '(%SINH %COSH)))
	   (SETQ *LIN (CONS (CADR L) *LIN))
	   (SP1TLIN1 (RPLACD L (CDDR L))))
	  ((SP1TLIN1 (CDR L)))))

(DEFUN SP1TPLUS (L *TRIG)
    (COND ((OR (NULL L) (NULL (CDR L))) L)
	  ((DO ((C (LIST '(RAT) 1 (EXPT 2 (1- (LENGTH L)))))
		(ANS (LIST (CAR L)))
		(L (CDR L) (CDR L)))
	       ((NULL L) (LIST C (M+L ANS)))
	       (SETQ ANS 
		(M+L
		 (MAPCAR '(LAMBDA (Q)
			    (COND ((MTIMESP Q)
				   (M* (CADR Q) (SP1SINTCOS (CADDR Q) (CAR L))))
				  ((SP1SINTCOS Q (CAR L)))))
			  ANS)))
	       (SETQ ANS (COND ((MPLUSP ANS) (CDR ANS)) (T (NCONS ANS))))))))

(DEFUN SP1SINTCOS (A B)
  ((LAMBDA (X Y)
    (COND ((OR (ATOM A) (ATOM B)
	       (NOT (MEMQ (CAAR A) '(%SIN %COS %SINH %COSH)))
	       (NOT (MEMQ (CAAR B) '(%SIN %COS %SINH %COSH))))
	   (MUL3 2 A B))
	  ((PROG2 (SETQ X (M+ (CADR A) (CADR B)) Y (M- (CADR A) (CADR B)))
		  (NULL (EQ (CAAR A) (CAAR B))))
	   (SETQ B (OR (AND *TRIG '(%SIN)) '(%SINH)))
	   (OR (EQ (CAAR A) '%SIN) (EQ (CAAR A) '%SINH)
	       (SETQ Y (M- Y)))
	   (M+ (LIST B X) (LIST B Y)))
	  ((MEMQ (CAAR A) '(%COS %COSH))
	   (M+ (LIST (LIST (CAAR A)) X)
	       (LIST (LIST (CAAR A)) Y)))
	  (*TRIG
	   (M- (LIST '(%COS) Y) (LIST '(%COS) X)))
	  ((M- (LIST '(%COSH) X) (LIST '(%COSH) Y)))))
   NIL NIL))

; For COS(X)^2, TRIGBUCKET is (X (1 (COS . 2))) or, more generally, 
; (arg (numfactor-of-arg (operator . exponent)))

(DEFUN SP1ADD (E)
  ((LAMBDA (N ARG BUC LAWS)
    (COND ((MEMQ (CAAR E) '(%SIN %COS %TAN %COT %SEC %CSC))
	   (COND ((SETQ BUC (ASSOC (CDR ARG) TRIGBUCKETS))
		  (SETQ LAWS TRIGLAWS)
		  (SP1ADDBUC (CAAR E) (CAR ARG) N BUC))
		 ((SETQ TRIGBUCKETS
			(CONS (LIST (CDR ARG) (LIST (CAR ARG) (CONS (CAAR E) N)))
			      TRIGBUCKETS)))))
	  ((SETQ BUC (ASSOC (CDR ARG) HYPERBUCKETS))
	   (SP1ADDBUC (CAAR E) (CAR ARG) N BUC))
	  ((SETQ HYPERBUCKETS
		 (CONS (LIST (CDR ARG) (LIST (CAR ARG) (CONS (CAAR E) N)))
		       HYPERBUCKETS)))))
   (COND ((EQ (CAAR E) 'MEXPT)
	  (COND ((= (SIGNUM1 (CADDR E)) -1)
		 (PROG2 0 (M- (CADDR E))
			  (SETQ E (CONS (LIST (GET (CAAADR E) 'RECIP)) (CDADR E)))))
		((PROG2 0 (CADDR E) (SETQ E (CADR E))))))
	 ( 1 ))
   (SP1KGET (CADR E)) NIL HYPERLAWS))

(DEFUN SP1ADDBUC (F ARG N B)			;FUNCTION, ARGUMENT, EXPONENT, BUCKET LIST
    (COND ((AND (CDR B) (ALIKE1 ARG (CAADR B)))	;GOES IN THIS BUCKET
	   (SP1PUTBUC F N (CADR B)))
	  ((OR (NULL (CDR B)) (GREAT (CAADR B) ARG))
	   (RPLACD B (CONS (LIST ARG (CONS F N)) (CDR B))))
	  ((SP1ADDBUC F ARG N (CDR B)))))

(DEFUN SP1PUTBUC (F N *BUC)				;PUT IT IN THERE
  (DO ((BUC *BUC (CDR BUC)))
      ((NULL (CDR BUC))
       (RPLACD BUC (LIST (CONS F N))))
    (COND ((EQ F (CAADR BUC))				;SAME FUNCTION
	   (RETURN
	    (RPLACD (CADR BUC) (M+ N (CDADR BUC)))))	;SO BOOST EXPONENT
	  ((EQ (CAADR BUC) (GET F 'RECIP))		;RECIPROCAL FUNCTIONS
	   (SETQ N (M- (CDADR BUC) N))
	   (RETURN
	    (COND ((SIGNP E N) (RPLACD BUC (CDDR BUC)))
		  ((= (SIGNUM1 N) -1)
		   (RPLACA (CADR BUC) F)
		   (RPLACD (CADR BUC) (NEG N)))
		  (T (RPLACD (CADR BUC) N)))))
	  (T ((LAMBDA (NF M)
		(COND ((NULL NF))			;NO SIMPLIFICATIONS HERE
		      ((EQUAL N (CDADR BUC))		;EXPONENTS MATCH
		       (RPLACD BUC (CDDR BUC))
		       (RETURN
			(SP1PUTBUC1 NF N *BUC)))	;TO MAKE SURE IT DOESN'T OCCUR TWICE
		      ((EQ (SETQ M (SP1GREAT N (CDADR BUC))) 'NOMATCH))
		      (M (SETQ M (CDADR BUC))
			 (RPLACD BUC (CDDR BUC))
			 (SP1PUTBUC1 NF M *BUC)
			 (SP1PUTBUC1 F (M- N M) *BUC)
			 (RETURN T))
		      (T (RPLACD (CADR BUC) (M- (CDADR BUC) N))
			 (RETURN (SP1PUTBUC1 NF N *BUC)))))
	    (GET (GET LAWS (CAADR BUC)) F) NIL)))))

(DEFUN SP1PUTBUC1 (F N BUC)
    (COND ((NULL (CDR BUC))
	   (RPLACD BUC (LIST (CONS F N))))
	  ((EQ F (CAADR BUC))
	   (RPLACD (CADR BUC) (M+ N (CDADR BUC))))
	  ((SP1PUTBUC1 F N (CDR BUC)))))

(DEFUN SP1GREAT (X Y)
  ((LAMBDA (A B)
    (COND ((MNUMP X)
	   (COND ((MNUMP Y) (GREAT X Y)) (T 'NOMATCH)))
	  ((OR (ATOM X) (ATOM Y)) 'NOMATCH)
	  ((AND (EQ (CAAR X) (CAAR Y))
		(ALIKE (COND ((MNUMP (CADR X))
			      (SETQ A (CADR X)) (CDDR X))
			     (T (SETQ A 1) (CDR X)))
		       (COND ((MNUMP (CADR Y))
			      (SETQ B (CADR Y)) (CDDR Y))
			     (T (SETQ B 1) (CDR Y)))))
	   (GREAT A B))
	  (T 'NOMATCH)))
    NIL NIL))

(DEFUN SP1UNTREP (B)
    (MAPCAN
     '(LAMBDA (BUC)
	(MAPCAR '(LAMBDA (TERM)
		   ((LAMBDA (BAS)
			(COND ((EQUAL (CDR TERM) 1) BAS)
			      ((M^ BAS (CDR TERM)))))
		     (SIMPLIFYA (LIST (LIST (CAR TERM))
				      (M* (CAR B) (CAR BUC)))
				T)))
		(CDR BUC)))
     (CDR B)))

(DEFUN SP1KGET (E)			;FINDS NUMERIC COEFFICIENTS
    (OR (AND (MTIMESP E) (NUMBERP (CADR E))
	     (CONS (CADR E) (M*L (CDDR E))))
	(CONS 1 E)))

(DEFUN SP1SINCOS (L *TRIG)
    (MAPCAR '(LAMBDA (Q) (SP1SINCOS2 (M* (CAR L) (CAR Q)) Q)) (CDR L)))

(DEFUN SP1SINCOS2 (ARG L)
  ((LAMBDA (A)
    (COND ((NULL (CDR L)))
	  ((AND
	    (SETQ A (MEMQ (CAADR L)
			  (COND ((NULL *TRIG)
				 '(%SINH %COSH %SINH %CSCH %SECH %CSCH))
				('(%SIN %COS %SIN %CSC %SEC %CSC)))))
	    (CDDR L))			;THERE MUST BE SOMETHING TO MATCH TO.
	   (SP1SINCOS1 (CADR A) L ARG))
	  ((SP1SINCOS2 ARG (CDR L)))))
   NIL))

(DEFUN SP1SINCOS1 (S L ARG)
  ((LAMBDA (G E)
    (DO ((LL (CDR L) (CDR LL)))
	((NULL (CDR LL)) T)
	(COND ((EQ S (CAADR LL))
	       (SETQ ARG (M* 2 ARG))
	       (COND (*TRIG
		      (COND ((MEMQ S '(%SIN %COS))
			     (SETQ S '%SIN))
			    ((SETQ S '%CSC E -1))))
		     (T 
		      (COND ((MEMQ S '(%SINH %COSH))
			     (SETQ S '%SINH))
			    ((SETQ S '%CSCH E -1)))))
	       (COND ((ALIKE1 (CDADR LL) (CDADR L))
		      (SP1ADDTO S ARG (CDADR L))
		      (SETQ *LIN (CONS (M* E (CDADR L)) *LIN))
		      (RPLACD LL (CDDR LL))	;;;MUST BE IN THIS ORDER!!
		      (RPLACD L (CDDR L))
		      (RETURN T))
		     ((EQ (SETQ G (SP1GREAT (CDADR L) (CDADR LL))) 'NOMATCH))
		     ((NULL G)
		      (RPLACD (CADR LL) (M- (CDADR LL) (CDADR L)))
		      (SP1ADDTO S ARG (CDADR L))
		      (SETQ *LIN (CONS (M* E (CDADR L)) *LIN))
		      (RPLACD L (CDDR L))
		      (RETURN T))
		     (T
		      (RPLACD (CADR L) (M- (CDADR L) (CDADR LL)))
		      (SP1ADDTO S ARG (CDADR LL))
		      (SETQ *LIN (CONS (M* E (CDADR LL)) *LIN))
		      (RPLACD LL (CDDR LL))
		      (RETURN T)))))))
   NIL 1))

(DEFUN SP1ADDTO (FN ARG EXP)
    (SETQ ARG (LIST (LIST FN) ARG))
    (SP1ADD (COND ((EQUAL EXP 1) ARG) (T (M^ ARG EXP)))))

(SETQ SC^NDISP '((%SIN . SIN^N) (%COS . COS^N) (%SINH . SINH^N) (%COSH . COSH^N)))

(DEFUN SP1EXPT (B E)
    (COND ((MEXPTP B)
	   (SP1EXPT (CADR B) (M* E (CADDR B))))
	  ((AND (NULL (TRIGFP B)) (FREE E VAR))
	   (M^ B E))
	  ((EQUAL B '$%E)
	   (SP1EXPT2 E))
	  ((AND (NULL (EQ VAR '*NOVAR)) (FREE B VAR))
	   (SP1EXPT2 (M* (LIST '(%LOG) B) E)))
	  ((MEMQ (CAAR B) '(%SIN %COS %TAN %COT %SEC %CSC
			    %SINH %COSH %TANH %COTH %SECH %CSCH))
	   (COND ((= (SIGNUM1 E) -1)
		  (SP1EXPT (LIST (LIST (GET (CAAR B) 'RECIP)) (CADR B))
			   (NEG E)))
		 ((AND (SIGNP G E)
		       (MEMQ (CAAR B) '(%SIN %COS %SINH %COSH)))
		  (FUNCALL (CDR (ASSQ (CAAR B) SC^NDISP)) E (CADR B)))
		 ((M^ B E))))
	  ((M^ B E))))

(DEFUN SP1EXPT2 (E)
    ((LAMBDA (ANS FR EXP)
	(SETQ ANS (M2 E '((MPLUS) ((COEFFPP) (FR FREEVAR))
				  ((COEFFPP) (EXP TRUE)))
			NIL)
	      FR (CDR (ASSQ 'FR ANS))
	      EXP (CDR (ASSQ 'EXP ANS)))
	(COND ((EQUAL FR 0)
	       (M^ '$%E EXP))
	      ((M* (M^ '$%E FR) (M^ '$%E EXP)))))
     NIL NIL NIL))

(SETQ *SP1LOGF NIL)

(DEFUN SP1LOG (E)
    (COND ((OR *TRIGRED (ATOM E) (FREE E VAR))
	   (LIST '(%LOG) E))
	  ((EQ (CAAR E) 'MPLUS)
	   ((LAMBDA (EXP *A *N)
		(COND ((SMONO EXP VAR)
		       (LIST '(%LOG) E))
		      (*SP1LOGF (SP1LOG2 E))
		      (((LAMBDA (*SP1LOGF) (SP1LOG ($FACTOR E)))
			T))))
	    (M1- E) NIL NIL))
	  ((EQ (CAAR E) 'MTIMES)
	   (SP1 (M+L (MAPCAR 'SP1LOG (CDR E)))))
	  ((EQ (CAAR E) 'MEXPT)
	   (SP1 (M* (CADDR E) (LIST '(%LOG) (CADR E)))))
	  ((SP1LOG2 E))))

(DEFUN SP1LOG2 (E)
  (AND $VERBOSE
       (PROG2 (MTELL "Can't expand ")
	      (SHOW-EXP (LIST '(%LOG) E))
	      (MTELL "So we'll try again after applying the rule:~2%~M~%~%"
		     (LIST '(MLABLE) NIL
			   (OUT-OF
			    (LIST '(MEQUAL)
				  (LIST '(%LOG) E)
				  (LIST '(%INTEGRATE)
					(LIST '(MQUOTIENT)
					      (LIST '(%DERIVATIVE) E VAR 1)
					      E)
					VAR)))))))
  (LIST '(%INTEGRATE)
	(SP1 ($RATSIMP (LIST '(MTIMES) (SDIFF E VAR) (LIST '(MEXPT) E -1))))
	VAR))

(DEFUN SP1TRIG (E)
    (COND ((ATOM (CADR E)) (SIMPLIFY E))
	  ((EQ (CAAADR E) (GET (CAAR E) '$INVERSE)) (SP1 (CADADR E)))
	  ((EQ (CAAADR E) (GET (GET (CAAR E) 'RECIP) '$INVERSE))
	   (SP1 (M// (CADADR E))))
	  ((AND (NULL *TRIGRED) (NULL *NOEXPAND) (EQ (CAAADR E) 'MPLUS))
	   (SP1TRIGEX E))
	  ( E )))

(DEFUN SP1TRIGEX (E)
    ((LAMBDA (ANS FR EXP)
	(SETQ ANS (M2 (CADR E) '((MPLUS) ((COEFFPP) (FR FREEVAR))
				  ((COEFFPP) (EXP TRUE)))
			NIL)
	      FR (CDR (ASSQ 'FR ANS))
	      EXP (CDR (ASSQ 'EXP ANS)))
	(COND ((SIGNP E FR)
	       (SETQ FR (CADR EXP)
		     EXP (COND ((CDDDR EXP)
				(CONS (CAR EXP) (CDDR EXP)))
			       ((CADDR EXP))))))
	(COND ((OR (EQUAL FR 0)
		   (NULL (MEMQ (CAAR E) '(%SIN %COS %SINH %COSH))))
	       E)
	      ((EQ (CAAR E) '%SIN)
	       (M+ (M* (SP1TRIG (LIST '(%SIN) EXP))
		       (SP1TRIG (LIST '(%COS) FR)))
		   (M* (SP1TRIG (LIST '(%COS) EXP))
		       (SP1TRIG (LIST '(%SIN) FR)))))
	      ((EQ (CAAR E) '%COS)
	       (M- (M* (SP1TRIG (LIST '(%COS) EXP))
		       (SP1TRIG (LIST '(%COS) FR)))
		   (M* (SP1TRIG (LIST '(%SIN) EXP))
		       (SP1TRIG (LIST '(%SIN) FR)))))
	      ((EQ (CAAR E) '%SINH)
	       (M+ (M* (SP1TRIG (LIST '(%SINH) EXP))
		       (SP1TRIG (LIST '(%COSH) FR)))
		   (M* (SP1TRIG (LIST '(%COSH) EXP))
		       (SP1TRIG (LIST '(%SINH) FR)))))
	      ((EQ (CAAR E) '%COSH)
	       (M+ (M* (SP1TRIG (LIST '(%COSH) EXP))
		       (SP1TRIG (LIST '(%COSH) FR)))
		   (M* (SP1TRIG (LIST '(%SINH) EXP))
		       (SP1TRIG (LIST '(%SINH) FR)))))))
     NIL NIL NIL))

(DEFUN SP1ATRIG (FN EXP)
    (COND ((ATOM EXP)
	   (SP1ATRIG2 FN EXP))
	  ((EQ FN (GET (CADR EXP) '$INVERSE))
	   (SP1 (CADR EXP)))
	  (T (SP1ATRIG2 FN EXP))))

(DEFUN SP1ATRIG2 (FN EXP)
     (COND ((MEMQ FN '(%COT %SEC %CSC %COTH %SECH %CSCH))
	    (SETQ EXP (SP1 (M// EXP))
		  FN (CDR (ASSQ FN '((%ACOT . %ATAN) (%ASEC . %ACOS) (%ACSC . %ASIN)
				     (%ACOTH . %ATANH) (%ASECH . %ACOSH) (%ACSCH . %ASINH)))))))
     (COND ((AND (NULL *TRIGRED)
		 (MEMQ FN '(%ACOS %ACOSH)))
	    (M+ HALF%PI (LIST
			 (LIST (CDR (ASSQ FN '((%ACOS . %ASIN) (%ACOSH . %ASINH)))))
				 EXP)))
	   ((LIST (LIST FN) EXP))))

(DEFUN SIN^N (%N V)
	        (SC^N %N V (COND ((ODDP %N) '(%SIN))('(%COS))) (NOT (ODDP %N))
				(M^ -1 (M+ (// %N 2) 'K))))

(DEFUN SINH^N (%N V)
       (M- (SC^N %N V (COND ((ODDP %N) '(%SINH))
			      ('(%COSH)))
		 (NOT (ODDP %N))
		 (M^ -1 (M+ (// %N 2) 'K)))))

(DEFUN COS^N (%N V) (SC^N %N V '(%COS) (NOT (ODDP %N)) 1))

(DEFUN COSH^N (%N V) (SC^N %N V '(%COSH) (NOT (ODDP %N)) 1))

(DEFUN SC^N (%N V FN FL COEF)
    (COND ((MINUSP %N) (MERROR "Bug in TRIGREDUCE.  Please report.")))
    (M* (LIST '(RAT) 1 (EXPT 2 %N))
	(M+ (COND (FL (LIST '(%BINOMIAL) %N (// %N 2))) (T 0))
	    (SUBSTITUTE V 'TRIG-VAR
			(DOSUM (M+ (M* 2
				       (LIST '(%BINOMIAL) %N 'K)
				       COEF
				       (LIST FN (M* 'TRIG-VAR
						    (M+ %N (M* -2 'K))))))
			'K 0 (// (1- %N) 2) T)))))