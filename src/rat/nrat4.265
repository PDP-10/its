;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1982 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module nrat4)

(DECLARE (GENPREFIX FQZ_)
	 (SPECIAL $RATSIMPEXPONS *EXP *EXP2 *RADSUBST *LOGLIST $RADSUBSTFLAG 
		  $RADEXPAND $LOGSIMP *V *VAR FR-FACTOR RADCANP RATSUBVL)
	 (*LEXPR $RATSIMP)
	 (FIXNUM NARGS))

(LOAD-MACSYMA-MACROS RZMAC RATMAC)

(DEFUN PDIS (X) ($RATDISREP (PDIS* X)))

(DEFUN PDIS* (X) `((MRAT SIMP ,VARLIST ,GENVAR) ,X . 1))

(DEFUN RDIS (X) ($RATDISREP (RDIS* X)))

(DEFUN RDIS* (X) `((MRAT SIMP ,VARLIST ,GENVAR) . ,X))

(DEFUN RFORM (X) (CDR (RATF X)))

(SETQ RADCANP NIL)

(DEFMFUN $RATCOEF NARGS
 (COND ((= NARGS 3) (RATCOEFF (ARG 1) (ARG 2) (ARG 3)))
       ((= NARGS 2) (RATCOEFF (ARG 1) (ARG 2) 1))
       (T (WNA-ERR '$RATCOEFF))))  ; The spelling "RATCOEFF" is nicer.

(DEFMFUN RATCOEFF (A B C)
  (LET* ((FORMFLAG ($RATP A))
	 (TAYLORFORM (AND FORMFLAG (MEMQ 'TRUNC (CDAR A)))))
        (COND ((ZEROP1 B) (IMPROPER-ARG-ERR B '$RATCOEFF))
	      ((MBAGP A) (CONS (CAR A)
			       (MAPCAR #'(LAMBDA (A) (RATCOEFF A B C))
				       (CDR A))))
	      ((AND TAYLORFORM (MNUMP C) (ASSOLIKE B (CADDDR (CDAR A))))
	       (PSCOEFF1 A B C))
	      ((AND TAYLORFORM (MEXPTP B) (MNUMP C) (MNUMP (CADDR B))
		    (ASSOLIKE (CADR B) (CADDDR (CDAR A))))
	       (PSCOEFF1 A (CADR B) (MUL2 C (CADDR B))))
	      ((AND TAYLORFORM (EQUAL C 0)) A)
	      (TAYLORFORM (SETQ A (RATDISREP A)))
	      (T (SETQ A (IF (EQUAL C 0)
		             (RATCOEF (MUL2* A B) B)
		             (RATCOEF A (IF (EQUAL C 1) B (LIST '(MEXPT) B C)))))
	         (IF (AND FORMFLAG (NOT TAYLORFORM))
		     (MINIMIZE-VARLIST A)
		     (RATDISREP A))))))

(DEFUN MINIMIZE-VARLIST (RATFUN)
  (IF (NOT ($RATP RATFUN)) (SETQ RATFUN (RATF RATFUN)))
  (MINVARLIST-MRAT (CADDR (CAR RATFUN)) (CADDDR (CAR RATFUN))
		   (CDR RATFUN)))

(DEFUN MINVARLIST-MRAT (VARS GENS RATFORM)
  (LET ((NEWGENS (UNION* (LISTOVARS (CAR RATFORM))
			 (LISTOVARS (CDR RATFORM)))))
    (DO ((LV VARS (CDR LV))
	 (LG GENS (CDR LG))
	 (NLV ())
	 (NLG ()))
	((NULL LG)
	 (CONS (LIST 'MRAT 'SIMP (NREVERSE NLV) (NREVERSE NLG))
	       RATFORM))
      (COND ((MEMQ (CAR LG) NEWGENS)
	     (PUSH (CAR LG) NLG)
	     (PUSH (CAR LV) NLV))))))

(DEFUN RATCOEF (EXP VAR)
  (PROG (VARLIST GENVAR $RATFAC $ALGEBRAIC $RATWTLVL BAS MINVAR)
	(SETQ VAR (RATDISREP VAR))
	(SETQ BAS (IF (AND (MEXPTP VAR) (MNUMP (CADDR VAR))) (CADR VAR) VAR))
	(NEWVAR VAR)
	(NEWVAR BAS)
	(SETQ MINVAR (CAR VARLIST))
	(NEWVAR EXP)
	(SETQ EXP (CDR (RATREP* EXP)))
	(SETQ VAR (CDR (RATREP* VAR)))
	(SETQ BAS (CADR (RATREP* BAS)))
	(IF (AND (EQUAL (CDR EXP) 1) (EQUAL (CDR VAR) 1) (PUREPROD (CAR VAR)))
	    (RETURN (PDIS* (PRODCOEF (CAR VAR) (CAR EXP)))))
	(SETQ EXP (RATQUOTIENT EXP VAR))
	(IF (NULL MINVAR) (RETURN (PDIS* (PRODCOEF (CDR EXP) (CAR EXP)))))
	(SETQ MINVAR (CAADR (RATREP* MINVAR)))
LOOP	(IF (OR (PCOEFP (CDR EXP)) (POINTERGP MINVAR (CADR EXP)))
	    (RETURN (RDIS* (CDR (RATDIVIDE EXP BAS)))))
	(SETQ EXP (RATCOEF1 (CAR EXP) (CDR EXP)))
	(GO LOOP)))

(DEFUN RATCOEF1 (NUM DEN)
       (COND ((PCOEFP NUM) (RZERO))
	     ((EQ (CAR NUM) (CAR DEN)) (CAR (PDIVIDE NUM DEN)))
	     ((POINTERGP (CAR DEN) (CAR NUM)) (RZERO))
	     (T (RATCOEF1 (CONSTCOEF (CDR NUM)) DEN))))

(DEFUN CONSTCOEF (P)
       (COND ((NULL P) 0)
	     ((ZEROP (CAR P)) (CADR P))
	     (T (CONSTCOEF (CDDR P)))))

(SETQ *RADSUBST NIL RATSUBVL T)			;SUBST ON VARLIST

(DEFMFUN $RATSUBST (A B C)	;NEEDS CODE FOR FAC. FORM 
  (PROG (VARLIST NEWVARLIST DONTDISREPIT $RATFAC GENVAR)
	;;hard to maintain user ordering info.
	(IF ($RATP C) (SETQ DONTDISREPIT T))
	(WHEN (AND $RADSUBSTFLAG
		   (PROG2 (NEWVAR B) (ORMAPC #'MEXPTP VARLIST)))
	      (LET (($FACTORFLAG T) *EXP *EXP2 *RADSUBST)
		(SETQ B (FULLRATSIMP B))
		(SETQ C (FULLRATSIMP C))
		(SETQ VARLIST NIL)
		(FNEWVAR B)
		(FNEWVAR C)
		(SETQ *EXP (CDR (RATREP* B)))
		(SETQ *EXP2 (CDR (RATREP* C)))
     ;;	since *radsubst is t, both *exp and *exp2 will be radcan simplified
		(SETQ *RADSUBST T)
		(SPC0)
		(SETQ B (RDIS *EXP) C (RDIS *EXP2))
		(SETQ VARLIST NIL)))
       (SETQ A ($RATDISREP A) B ($RATDISREP B) C ($RATDISREP C))
       (COND ((FIXP B) (SETQ C (RATF (SUBSTITUTE A B C)))
		       (RETURN (COND (DONTDISREPIT C) (T ($RATDISREP C))))))
       (NEWVAR C)
       (SETQ
	NEWVARLIST
	(IF RATSUBVL
	    (MAPCAR
	     #'(LAMBDA (Z)
		 (COND ((ATOM Z) Z)
		       (T (RESIMPLIFY
			   (CONS (CAR Z)
				 (MAPCAR #'(LAMBDA (ZZ)
					     (COND ((ALIKE1 ZZ B) A)
						   ((ATOM ZZ) ZZ)
						   (T ($RATDISREP
						       ($RATSUBST A B ZZ)))))
					 (CDR Z)))))))
	     VARLIST)
	    VARLIST))
       (NEWVAR A) (NEWVAR B)
       (SETQ NEWVARLIST (REVERSE (PAIROFF (REVERSE VARLIST)
					  (REVERSE NEWVARLIST))))
       (SETQ A (CDR (RATREP* A)))
       (SETQ B (CDR (RATREP* B)))
       (SETQ C (CDR (RATREP* C)))
       (WHEN (PMINUSP (CAR B))
	     (SETQ B (RATMINUS B))
	     (SETQ A (RATMINUS A)))
       (WHEN (AND (EQN 1 (CAR B)) (NOT (EQN 1 (CDR B)))(NOT (EQN (CAR A) 0)))
	     (SETQ A (RATINVERT A))
	     (SETQ B (RATINVERT B)))
       (COND ((NOT (EQN 1 (CDR B)))
	      (SETQ A (RATTIMES A (CONS (CDR B) 1) T))
	      (SETQ B (CONS (CAR B) 1))))
       (SETQ C
	(COND ((MEMBER (CAR B) '(0 1))
	       (RATF (SUBSTITUTE (RDIS A) B (RDIS C))))
	      (T (CONS (LIST 'MRAT 'SIMP VARLIST GENVAR)
		       (IF (EQN (CDR A) 1)
			   (RATREDUCE (EVERYSUBST0 (CAR A) (CAR B) (CAR C))
				      (EVERYSUBST0 (CAR A) (CAR B) (CDR C)))
			   (ALLSUBST00 A B C))))))
       (UNLESS (ALIKE NEWVARLIST VARLIST)
	       (SETQ VARLIST NEWVARLIST
		     C (RDIS (CDR C))
		     VARLIST NIL
		     C (RATF C)))
       (RETURN (COND (DONTDISREPIT C) (T ($RATDISREP C))))))

(DEFUN ALLSUBST00 (A B C)
      (COND ((EQUAL A B) C)
	     (T (RATQUOTIENT (EVERYSUBST00 A (CAR B) (CAR C))
			     (EVERYSUBST00 A (CAR B) (CDR C))))))

(DEFUN EVERYSUBST00 (X I Z)
  (LOOP WITH ANS = (RZERO)
	FOR (EXP COEF) ON (EVERYSUBST I Z *ALPHA) BY 'PT-RED
	DO (SETQ ANS (RATPLUS ANS (RATTIMES (CONS COEF 1) (RATEXPT X EXP) T)))
	FINALLY (RETURN ANS)))

(DEFUN EVERYSUBST0 (X I Z)
  (LOOP WITH ANS = (PZERO)
	FOR (EXP COEF) ON (EVERYSUBST I Z *ALPHA) BY 'PT-RED
	DO (SETQ ANS (PPLUS ANS (PTIMES COEF (PEXPT X EXP))))
	FINALLY (RETURN ANS)))

(DEFUN EVERYSUBST1 (A B MAXPOW)
  (LOOP FOR (EXP COEF) ON (P-TERMS B) BY 'PT-RED
	FOR PART = (EVERYSUBST A COEF MAXPOW)
	NCONC (IF (= 0 EXP) PART
		  (EVERYSUBST2 PART (MAKE-POLY (P-VAR B) EXP 1)))))

(DEFUN EVERYSUBST2 (L H)
  (DO ((PTR L (CDDR PTR)))
      ((NULL PTR) L)
    (SETF (CADR PTR) (PTIMES H (CADR PTR)))))

(DEFUN PAIROFF (L M)
       (COND ((NULL M) L) (T (CONS (CAR M) (PAIROFF (CDR L) (CDR M))))))

(DEFUN EVERYSUBST (A B MAXPOW)
  (COND ((PCOEFP A)
	 (COND ((EQN A 1) (LIST MAXPOW B))
	       ((PCOEFP B)
		(LIST (SETQ MAXPOW
			    (DO ((B B (QUOTIENT B A))
				 (ANS 0 (1+ ANS)))
				((OR (GREATERP (ABS A) (ABS B))
				     (EQN MAXPOW ANS))
				  ANS)))
		      (QUOTIENT B (SETQ MAXPOW (EXPT A MAXPOW)))
		      0
		      (REMAINDER B MAXPOW)))
	       (T (EVERYSUBST1 A B MAXPOW))))
	((OR (PCOEFP B) (POINTERGP (CAR A) (CAR B))) (LIST 0 B))
	((EQ (CAR A) (CAR B))
	 (COND ((NULL (CDDDR A)) (EVERYPTERMS B (CADDR A) (CADR A) MAXPOW))
	       (T (SUBSTFORSUM A B MAXPOW))))
	(T (EVERYSUBST1 A B MAXPOW))))

(DEFUN EVERYPTERMS (X P N MAXPOW)
  (IF (LESSP (CADR X) N) (LIST 0 X)
      (PROG (K ANS Q PART)
	    (SETQ K (CAR X))
	    (SETQ X (CDR X))
       L    (SETQ Q (MIN MAXPOW (QUOTIENT (CAR X) N)))
       M    (COND ((EQN Q 0)
		   (RETURN (COND ((NULL X) ANS)
				 (T (CONS 0
					  (CONS (PSIMP K X) ANS)))))))
            (SETQ PART (EVERYSUBST P (CADR X) Q))
	    (SETQ ANS (NCONC (EVERYPTERMS1 PART K N (CAR X)) ANS))
	    (SETQ X (CDDR X))
	    (COND ((NULL X) (SETQ Q 0) (GO M)))
	    (GO L))))

(DEFUN EVERYPTERMS1 (L K N J)
  (DO ((PTR L (CDDR PTR)))
      ((NULL PTR) L)
    (SETF (CADR PTR)
	  (PTIMES (PSIMP K (LIST (- J (* N (CAR PTR))) 1))
		  (CADR PTR)))))

(DEFUN SUBSTFORSUM (A B MAXPOW)
  (DO ((POW 0 (ADD1 POW))
       (QUOT) (REM) (ANS))
      ((NOT (LESSP POW MAXPOW)) (LIST* MAXPOW B ANS))
    (DESETQ (QUOT REM) (PDIVIDE B A))
    (UNLESS (AND (EQN (CDR QUOT) 1)
		 (NOT (PZEROP (CAR QUOT)))
		 (EQN (CDR REM) 1))
	    (RETURN (CONS POW (CONS B ANS))))
    (UNLESS (PZEROP (CAR REM))
	    (SETQ ANS (CONS POW (CONS (CAR REM) ANS))))
    (SETQ B (CAR QUOT))))

(DEFUN PRODCOEF (A B)
       (COND ((PCOEFP A)
	      (COND ((PCOEFP B) (QUOTIENT B A)) (T (PRODCOEF1 A B))))
	     ((PCOEFP B) (PZERO))
	     ((POINTERGP (CAR A) (CAR B)) (PZERO))
	     ((EQ (CAR A) (CAR B))
	      (COND ((NULL (CDDDR A))
		     (PRODCOEF (CADDR A) (PTERM (CDR B) (CADR A))))
		    (T (SUMCOEF A B))))
	     (T (PRODCOEF1 A B))))

(DEFUN SUMCOEF (A B)
  (DESETQ (A B) (PDIVIDE B A))
  (IF (AND (EQUAL (CDR A) 1) (EQUAL (CDR B) 1))
      (CAR A)
      (PZERO)))

(DEFUN PRODCOEF1 (A B)
  (LOOP WITH ANS = (PZERO)
	FOR (BEXP BCOEF) ON (P-TERMS B) BY 'PT-RED
	FOR PART = (PRODCOEF A BCOEF)
	UNLESS (PZEROP PART)
	DO (SETQ ANS (PPLUS ANS (PSIMP (P-VAR B) (LIST BEXP PART))))
	FINALLY (RETURN ANS)))

(DEFUN PUREPROD (X)
       (OR (ATOM X)
	   (AND (NOT (ATOM (CDR X)))
		(NULL (CDDDR X))
		(PUREPROD (CADDR X)))))

(DEFMFUN $BOTHCOEF (R VAR) 
       (PROG (*VAR H VARLIST GENVAR $RATFAC)
	     (UNLESS ($RATP R)
		     (RETURN `((MLIST)
			       ,(SETQ H (COEFF R VAR 1.))
			       ((MPLUS) ,R ((MTIMES) -1 ,H ,VAR)))))
	     (NEWVAR VAR)
	     (SETQ H (AND VARLIST (CAR VARLIST)))
	     (NEWVAR R)
	     (SETQ VAR (CDR (RATREP* VAR)))
	     (SETQ R (CDR (RATREP* R)))
	     (AND H (SETQ H (CAADR (RATREP* H))))
	     (COND ((AND H (OR (PCOEFP (CDR R)) (POINTERGP H (CADR R)))
			 (EQUAL 1 (CDR VAR)))
		    (SETQ VAR (BOTHPRODCOEF (CAR VAR) (CAR R)))
		    (RETURN (LIST '(MLIST)
				  (RDIS* (RATREDUCE (CAR VAR) (CDR R)))
				  (RDIS* (RATREDUCE (CDR VAR) (CDR R))))))
		   (T (MERROR "Bad arguments to BOTHCOEFF")))))
	 
;COEFF OF A IN B

(DEFUN BOTHPRODCOEF (A B) 
       (LET ((C (PRODCOEF A B)))
	    (COND ((PZEROP C) (CONS (PZERO) B))
		  (T (CONS C (PDIFFERENCE B (PTIMES C A)))))))

(DEFVAR ARGSFREEOFP NIL)

(DEFMFUN ARGSFREEOF (VAR EXP)
  (LET ((ARGSFREEOFP T)) (FREEOF VAR EXP)))
 
(DEFMFUN $FREEOF NARGS
       (PROG (L EXP) 
	     (SETQ L (MAPCAR #'$TOTALDISREP (NREVERSE (LISTIFY NARGS)))
		   EXP (CAR L))
	LOOP (OR (SETQ L (CDR L)) (RETURN T))
	     (IF (FREEOF (GETOPR (CAR L)) EXP) (GO LOOP))
	     (RETURN NIL)))

(DEFMFUN FREEOF (VAR EXP) 
       (COND ((ALIKE1 VAR EXP) NIL)
	     ((ATOM EXP) T)
	     ((MEMQ (CAAR EXP) '(%INTEGRATE %PRODUCT %SUM %LAPLACE))
	      (FANCYFREEOF VAR EXP (CAAR EXP) (CADDR EXP)))
	     (ARGSFREEOFP (FREEOF1 VAR (MARGS EXP)))
	     (T (AND (FREEOF VAR (CAAR EXP)) (FREEOF1 VAR (CDR EXP))))))

(DEFUN FANCYFREEOF (VAR EXP OP VARBL-OF-OP)
       (COND ((AND (OR (MEMQ OP '(%SUM %PRODUCT))
		       (AND (EQ OP '%INTEGRATE) (CDDDR EXP)))
		   (ALIKE1 VAR VARBL-OF-OP))
	      (FREEOF1 VAR (CDDDR EXP)))
	     ((AND (EQ OP '%LAPLACE) (ALIKE1 VAR VARBL-OF-OP))
	      (FREEOF VAR (CADDDR EXP)))
	     (T (AND (FREEOF VAR OP) (FREEOF1 VAR (CDR EXP))))))

(DEFUN FREEOF1 (VAR L)
  (LOOP FOR X IN L ALWAYS (FREEOF VAR X)))

(COMMENT Subtitle RADCAN)

(SETQ $RADSUBSTFLAG NIL)
;	RADSUBSTFLAG T MAKES RATSUBS CALL RADCAN WHEN IT APPEARS USEFUL

(DEFMFUN $RADCAN (EXP)
       (COND ((MBAGP EXP) (CONS (CAR EXP) (MAPCAR '$RADCAN (CDR EXP))))
	     (T (LET (($RATSIMPEXPONS T))
		     (SIMPLIFY (LET (($EXPOP 0) ($EXPON 0))
				    (RADCAN1 (FR1 EXP NIL))))))))

(DEFUN RADCAN1 (*EXP)
       (COND ((ATOM *EXP) *EXP)
	     (T (LET (($FACTORFLAG T) VARLIST GENVAR $RATFAC $NOREPEAT
		      ($GCD (OR $GCD (CAR *GCDL*)))
		      (RADCANP T))
		     (NEWVAR *EXP)
		     (SETQ *EXP (CDR (RATREP* *EXP)))
		     (SETQ VARLIST
			   (MAPCAR
			    #'(LAMBDA (X) (COND
				     ((ATOM X) X)
				     (T (CONS (CAR X)
					      (MAPCAR 'RADCAN1 (CDR X))))))
			    VARLIST))
		     (SPC0)
		     (FR1 (RDIS *EXP) NIL)))))

(DEFUN SPC0 ()
  (PROG (*V *LOGLIST) 
	(IF (ALLATOMS VARLIST) (RETURN NIL))
	(SETQ VARLIST (MAPCAR (FUNCTION SPC1) VARLIST));make list of logs
	(SETQ *LOGLIST (FACTORLOGS *LOGLIST))
	(MAPC (FUNCTION SPC2) *LOGLIST)		      ;subst log factorizations
	(MAPC (FUNCTION SPC3) VARLIST GENVAR)	      ;expand exponents
	(MAPC (FUNCTION SPC4) VARLIST)		      ;make exponent list
	(DESETQ (VARLIST . GENVAR) (SPC5 *V VARLIST GENVAR))
						      ;find expon dependencies
	(SETQ VARLIST (MAPCAR (FUNCTION RJFSIMP) VARLIST));restore radicals
	(MAPC (FUNCTION SPC7) VARLIST)))	      ;simplify radicals

(DEFUN ALLATOMS (L)
  (LOOP FOR X IN L ALWAYS (ATOM X)))

(DEFUN RJFSIMP (X &AUX EXPON) 
  (COND ((AND *RADSUBST $RADSUBSTFLAG) X)
	((NOT (M$EXP? (SETQ X (LET ($LOGSIMP) (RESIMPLIFY X))))) X)
	((MLOGP (SETQ EXPON (CADDR X))) (CADR EXPON))
	((NOT (AND (MTIMESP EXPON) (OR $LOGSIMP *VAR))) X)
	(T (DO ((RISCHFLAG (AND *VAR (NOT $LOGSIMP) (NOT (FREEOF *VAR X))))
		(POWER (CDR EXPON) (CDR POWER))) ;POWER IS A PRODUCT
	       ((NULL POWER) X)
	       (COND ((NUMBERP (CAR POWER)))
		     ((MLOGP (CAR POWER))
		      (AND RISCHFLAG (CDR POWER) (RETURN X))
		      (RETURN
		       `((MEXPT) ,(CADAR POWER)
				 ,(MULN	(REMOVE (CAR POWER) (CDR EXPON) 1)
					NIL))))
		     (RISCHFLAG (RETURN X)))))))

(DEFUN DSUBSTA (X Y ZL) 
 (COND ((NULL ZL) ZL)
       (T (COND ((ALIKE1 Y (CAR ZL)) (RPLACA ZL X))
		((NOT (ATOM (CAR ZL))) (DSUBSTA X Y (CDAR ZL))))
	  (DSUBSTA X Y (CDR ZL))
	  ZL)))

(DEFUN RADSUBST (A B)
  (SETQ *EXP (ALLSUBST00 A B *EXP))
  (IF *RADSUBST (SETQ *EXP2 (ALLSUBST00 A B *EXP2))))

(SETQ *VAR NIL)

(DEFUN SPC1 (X)
  (COND ((MLOGP X) (PUTONLOGLIST X))
	((AND (MEXPTP X) (NOT (EQ (CADR X) '$%E)))
	 ($EXP (LIST '(MTIMES)
		     (CADDR X)
		     (PUTONLOGLIST (LIST '(%LOG SIMP RATSIMP)
					 (CADR X))))))
	(T X)))

(DEFUN PUTONLOGLIST (L)
  (UNLESS (MEMALIKE L *LOGLIST) (PUSH L *LOGLIST))
  L)

(DEFUN SPC2 (P)
  (RADSUBST (RFORM (CDR P)) (RFORM (CAR P)))
  (DSUBSTA (CDR P) (CAR P) VARLIST))

(DEFUN SPC2A (X)					;CONVERTS FACTORED
       ((LAMBDA (SUM)					;RFORM LOGAND TO SUM 
		(IF (CDR SUM) (CONS '(MPLUS) SUM)	;OF LOGS
		    (CAR SUM)))
	(MAPCAR (FUNCTION SPC2B) X)))
	 
(DEFUN SPC2B (X)
  (LET ((LOG `((%LOG SIMP RATSIMP IRREDUCIBLE) ,(PDIS (CAR X)))))
    (IF (EQUAL 1 (CDR X)) LOG
	(LIST '(MTIMES) (CDR X) LOG))))
	 
(DEFUN SPC3 (X V &AUX Y) 
  (WHEN
   (AND (M$EXP? X)
	(NOT (ATOM (SETQ Y (CADDR X))))
	(MPLUSP (SETQ Y (EXPAND1 (IF *VAR ($PARTFRAC Y *VAR) Y)
				 10 10))))
   (SETQ Y (CONS '(MTIMES) (MAPCAR #'(LAMBDA (Z) ($RATSIMP ($EXP Z)))
				   (CDR Y))))
   (RADSUBST (RFORM Y) (RGET V))
   (DSUBSTA Y X VARLIST)))

(DEFUN SPC4 (X) 
  (IF (AND (M$EXP? X)
	   (NOT (MEMALIKE (CADDR X) *V)))
      (PUSH (CADDR X) *V)))

(DEFUN RZCONTENT (R)
  (LET (((C1 P) (PCONTENT (CAR R)))
	((C2 Q) (PCONTENT (CDR R))))
    (IF (PMINUSP P) (SETQ P (PMINUS P) C1 (CMINUS C1)))
    (CONS (CONS C1 C2) (CONS P Q))))

;;The GCDLIST looks like (( GCM1pair occurrencepair11 occurrencepair12 ...) ...
;;(GCMnpair occurrencepairn1 occurrencepairn2 ...))
;;where GCMpairs are lists of ratforms and prefix forms for the greatest common
;;multiple of the occurrencepairs.  Each of these pairs is a list of a ratform
;;and a prefix form.  The prefix form is a pointer into the varlist.  
;;The occurrences are exponents of the base %E.

(DEFUN SPC5 (VL OLDVARLIST OLDGENVAR &AUX GCDLIST VARLIST GENVAR)
  (DOLIST (V VL)
	  (LET* ((((NIL . C) . R) (RZCONTENT (RFORM V)))
		 (G (ASSOC R GCDLIST)))
	    (COND (G (SETF (CADR G) (PLCM C (CADR G)))
		     (PUSH (LIST ($EXP V) C) (CDDR G)))
		  (T (PUSH (LIST R C (LIST ($EXP V) C)) GCDLIST)))))
  (DOLIST (G GCDLIST)
	  (LET ((RD (RDIS (CAR G))))
	    (WHEN (AND (MLOGP RD) (MEMALIKE (CADR RD) OLDVARLIST))
		  (PUSH (LIST (CADR RD) 1) (CDDR G)))
	    (RPLACA G ($EXP (DIV RD (CADR G))))))
  (SPC5B GCDLIST OLDVARLIST OLDGENVAR))
 
(DEFUN SPC5B (V VARLIST GENVAR) 
  (DOLIST (L V)
     (DOLIST (X (CDDR L))
	     (UNLESS (EQUAL (CADR L) (CADR X))
			    (RADSUBST (RATEXPT (RFORM (CAR L))
					       (QUOTIENT (CADR L) (CADR X)))
				      (RFORM (CAR X))))))
  (CONS VARLIST GENVAR)) 

(DEFUN SPC7 (X)
  (IF (EQ X '$%I) (SETQ X '((MEXPT) -1 ((RAT) 1 2))))
  (WHEN (AND (MEXPTP X)
	     (RATNUMP (CADDR X)))
	(LET ((RAD (RFORM X))
	      (RBASE (RFORM (CADR X)))
	      (EXPON (CADDR (CADDR X))))
	  (RADSUBST RBASE (RATEXPT RAD EXPON)))))


(defun goodform (l) 			;;bad -> good
   (loop for (exp coef) on l by 'pt-red
	 collect (cons exp coef)))

(defun factorlogs (l)
       (prog (negl posl maxpl maxnl maxn)
	     (dolist (log l)
		     (setq log
			   (cons log (goodform
				      (ratfact (rform (radcan1 (cadr log)))
					       (function pfactor)))))
		     (cond ((equal (caadr log) -1) (push log negl))
			   (t (push log posl))))
	     (setq negl (flsort negl) posl (flsort posl) l (append negl posl))
	     (setq negl (mapcar (function cdr) negl)
		   posl (mapcar (function cdr) posl))
       a     (setq negl (delete '((-1 . 1)) negl))
             (or negl
		 (return (mapc #'(lambda (x) (rplacd x (spc2a (cdr x)))) l)))
	     (setq maxnl (flmaxl negl)
		   maxn (caaar maxnl))
       b     (setq maxpl (flmaxl posl))
             (cond ((and maxpl (flgreat (caaar maxpl) maxn))
		    (setq posl (flred posl (caaar maxpl)))
		    (go b))
		   ((and maxpl
			 (not (equal (caaar maxpl) maxn)))
		    (setq maxpl nil)))
	     (cond ((and (flevenp maxpl) (not (flevenp maxnl)))
		    (mapc #'(lambda (fp) (rplaca (car fp) (pminus (caar fp)))
			      (cond ((oddp (cdar fp))
				     (delete '(-1 . 1) fp)
				     (setq negl (delete fp negl))
				     (and (cdr fp) (push (cdr fp) posl)))))
			  maxnl)
		    (go a))
		   (t (setq posl (flred posl maxn)
			    negl (flred negl maxn))
		      (go a)))))

(defun flevenp (pl)
  (loop for l in pl never (oddp (cdar l))))

(defun flred (pl p)
       (map #'(lambda (x) (if (equal p (caaar x))
			      (rplaca x (cdar x))))
	    pl)
       (delete nil pl))

(defun flmaxl (fpl)				   ;lists of fac. polys
       (cond ((null fpl) nil)
	     (t (do ((maxl (list (car fpl))
			   (cond ((equal (caaar maxl) (caaar ll))
				  (cons (car ll) maxl))
				 ((flgreat (caaar maxl) (caaar ll)) maxl)
				 (t (list (car ll)))))
		     (ll (cdr fpl) (cdr ll)))
		    ((null ll) maxl)))))

(defun flsort (fpl)
  (mapc #'(lambda (x) (rplacd x (sortcar (cdr x) #'flgreat)))
	fpl))

(defun nmt (p any)
       (cond ((pcoefp p)
	      (if (or any (cminusp p)) 1 0))
	     (t (loop for lp on (p-terms p) by 'pt-red
		      sum (nmt (cadr lp) any) fixnum))))

(defun nmterms (p)
       (cond ((equal p -1) (cons 0 0))
	     (t (cons (nmt p nil) (nmt p t)))))

(defun flgreat (p q)
       (let ((pn (nmterms p)) (qn (nmterms q)))
	    (cond ((> (car pn) (car qn)) t)
		  ((< (car pn) (car qn)) nil)
		  ((> (cdr pn) (cdr qn)) t)
		  ((< (cdr pn) (cdr qn)) nil)
		  (t (flgreat1 p q)))))

(defun flgreat1 (p q)
       (cond ((numberp p)
	      (cond ((numberp q) (greaterp p q))
		    (t nil)))
	     ((numberp q) t)
	     ((pointergp (car p) (car q)) t)
	     ((pointergp (car q) (car p)) nil)
	     ((> (cadr p) (cadr q)) t)
	     ((< (cadr p) (cadr q)) nil)
	     (t (flgreat1 (caddr p) (caddr q)))))


; Undeclarations for the file:
(DECLARE (NOTYPE NARGS))
