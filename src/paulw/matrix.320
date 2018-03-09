;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1982 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module matrix)

(DECLARE (SPECIAL ERRRJFFLAG *INV* ONEOFF* EI* EJ* *RANK* *ECH* *TRI* 
		  MDL DOSIMP $DETOUT VLIST MUL* TOP* *DET* GENVAR $RATFAC
		  *MOSESFLAG VARLIST HEADER LININD* $SCALARMATRIXP $SPARSE
		  $ALGEBRAIC) 
	 (*LEXPR FMAPL1) (FIXNUM NN LEN)
	 (GENPREFIX X))

(DEFMVAR *RANK* NIL)
(DEFMVAR $DETOUT NIL)
(DEFMVAR TOP* NIL)
(DEFMVAR $RATMX NIL)
(DEFMVAR $MATRIX_ELEMENT_MULT '|&*|)    ;;; Else, most useful when '|&.|
(DEFMVAR $MATRIX_ELEMENT_ADD '|&+|)
(DEFMVAR $MATRIX_ELEMENT_TRANSPOSE NIL)
 
#+MacLisp
(DEFUN GET-ARRAY-POINTER (X)
  (COND ((EQ (TYPEP X) 'ARRAY) X)
	((GET X 'ARRAY))
	(T (MERROR "~S is not an array." X))))

#+Franz
(defun get-array-pointer (x)
   (cond ((arrayp x) x)
	 ((and (symbolp x) (arrayp (getd x))) x)
	 (t (merror "~s is not an array." x))))

#+LISPM
(DEFUN GET-ARRAY-POINTER (X)
  (COND ((ARRAYP X) X)
	((FBOUNDP X) (FSYMEVAL X))
	(T (FERROR NIL "~S is not an array." X))))

#+NIL
(DEFUN GET-ARRAY-POINTER (X)
  (OLDLISP-TO-ARRAY X))

(DEFUN MXC (X) (MAPCAR #'(LAMBDA (Y) (CONS '(MLIST) Y)) X))
	; Matrix to MACSYMA conversion

(DEFUN MCX (X) (MAPCAR #'CDR X))  ; MACSYMA to Matrix conversion

(DEFUN TRANSPOSE (M)
       (PROG (B NN LEN)
	     (SETQ LEN (LENGTH (CAR M)) NN 1)
	LOOP (COND ((> NN LEN) (RETURN B))) 
	     (SETQ B (NCONC B (NCONS (NTHCOL M NN))) NN (1+ NN))
	     (GO LOOP)))

(DEFUN NTHCOL (X NN)
       (COND ((OR (NULL X) (> NN (LENGTH (CAR X)))) NIL) (T (NTHCOL1 X NN))))

(DEFUN NTHCOL1 (X NN)
       (COND ((OR (NULL X) (= NN 0)) NIL)
	     (T (CONS (ITH (CAR X) NN) (NTHCOL1 (CDR X) NN)))))

(DEFUN CHECK (X) (COND ((ATOM X) (MERROR "Not matrix:~%~M" X))
		       ((EQ (CAAR X) '$MATRIX) X)
		       ((EQ (CAAR X) 'MLIST) (LIST '($MATRIX) X))
		       (T (MERROR "Not matrix:~%~M" X)))) 

(DEFUN CHECK1 (X) (COND ((ATOM X) NIL)
			((EQ (CAAR X) '$MATRIX) X)
			((EQ (CAAR X) 'MLIST) (LIST '($MATRIX) X)))) 

(DEFMFUN $MATRIXP (X) (AND (NOT (ATOM X)) (EQ (CAAR X) '$MATRIX)))

(DEFMFUN $CHARPOLY (MAT VAR) 
       (SETQ MAT (CHECK MAT))
       (IF (NOT (= (LENGTH MAT) (LENGTH (CADR MAT))))
	   (MERROR "Matrix must be square - CHARPOLY")) 
       (COND ((NOT $RATMX) (DET1 (ADDMATRIX1
			    (SETQ MAT (MCX (CDR MAT))) 
			    (DIAGMATRIX (LENGTH MAT) (LIST '(MTIMES) -1 VAR) '$CHARPOLY))))
	     (T (NEWVAR VAR) (NEWVARMAT1 MAT)
		(SETQ MAT (MCX (CDR MAT)))
		(DETERMINANT1 (ADDMATRIX MAT (DIAGMATRIX (LENGTH MAT) 
							 (LIST '(MTIMES) -1 VAR)
							 '$CHARPOLY))))))

(DEFUN DISREPLIST1 (A) (SETQ HEADER (LIST 'MRAT 'SIMP VARLIST GENVAR))
		       (MAPCAR #'DISREPLIST A))

(DEFUN DISREPLIST (A) (MAPCAR #'(LAMBDA (E) (CONS HEADER E)) A))
 
(DEFUN REPLIST1 (A) (MAPCAR #'REPLIST A)) 

(DEFUN REPLIST (A) (MAPCAR #'(LAMBDA (E) (CDR (RATREP* E))) A))


(DEFUN TIMEX (MAT1 MAT2)
 (COND ((EQUAL MAT1 1) MAT2)
       ((AND ($MATRIXP MAT1) ($MATRIXP MAT2) (NULL (CDR MAT1)))
	(NCONS '($MATRIX SIMP)))
       (T (NEWVARMAT MAT1 MAT2)
	  (LET (($SCALARMATRIXP
		 (IF (AND ($LISTP MAT1) ($LISTP MAT2)) T $SCALARMATRIXP)))
	       (SIMPLIFYA (TIMEX0 MAT1 MAT2) NIL)))))

(DEFUN LNEWVAR (A)
       ((LAMBDA (VLIST)
		(LNEWVAR1 A)
		(SETQ VARLIST (NCONC (SORTGREAT VLIST) VARLIST)))
	NIL))

(DEFUN LNEWVAR1 (A)
       (COND ((ATOM A) (NEWVAR1 A))
	     ((MEMQ (CAAR A) '(MLIST MEQUAL $MATRIX)) (MAPC #'LNEWVAR1 (CDR A)))
	     (T (NEWVAR1 A))))

(DEFUN NEWVARMAT (MAT1 MAT2)
       (COND ($RATMX
	      ((LAMBDA (VLIST)
		(LNEWVAR1 MAT1) (LNEWVAR1 MAT2)
		(SETQ VARLIST (NCONC (SORTGREAT VLIST) VARLIST))) NIL))))

(DEFUN NEWVARMAT1 (A)
       (COND ($RATMX (LNEWVAR A))))

(DEFUN ADDMATRIX (X Y) (SETQ X (REPLIST1 X) Y (REPLIST1 Y))
		       (DISREPLIST1 (ADDMATRIX1 X Y)))
 
(DEFUN ADDMATRIX1 (B C)
       (COND ((NOT (AND (= (LENGTH B) (LENGTH C))
			(= (LENGTH (CAR B)) (LENGTH (CAR C)))))
	      (MERROR "Attempt to add stuff of unequal length")))
       (MAPCAR #'ADDROWS B C))
 
(DEFUN ADDROWS (A B)
       (COND ((NOT $RATMX) (MAPCAR #'(LAMBDA (I J)
					     (SIMPLUS (LIST '(MPLUS) I J) 1 NIL)) A B))
	     (T (MAPCAR #'RATPLUS A B)))) 

(DEFMFUN $DETERMINANT (MAT)
  (COND ((ATOM MAT) (LIST '(%DETERMINANT) MAT))
	(T (SETQ MAT (CHECK MAT))
	   (IF (NOT (= (LENGTH MAT) (LENGTH (CADR MAT))))
	       (MERROR "DETERMINANT called on a non-square matrix."))
           (COND ((NOT $RATMX) (DET1 (MCX (CDR MAT))))
	         (T (NEWVARMAT1 MAT) (DETERMINANT1 (MCX (CDR MAT))))))))

(DEFUN DET (M)
  (IF (= (LENGTH M) 1)
      (CAAR M)
      (LET (*DET* MUL*)
	(MTOA 'M* (SETQ *DET* (LENGTH M)) *DET* M)
	(SETQ *DET* (TFGELI0 'M* *DET* *DET*))
	(RATREDUCE *DET* MUL*)))) 
 
(DEFUN DETERMINANT1 (X) (*CATCH 'DZ (RDIS (DET (REPLIST1 X))))) 

(DEFUN TREEDET (MAT)
(PROG (ROW MDL LINDEX TUPLEL N ID MD LT)
(SETQ MAT (REVERSE MAT))
(SETQ N (LENGTH MAT) MD (CAR MAT))
(SETQ MAT (CDR MAT))(SETQ LINDEX (NREVERSE (INDEX* N)) TUPLEL (MAPCAR #'LIST LINDEX))
LOOP1(COND ((NULL MAT) (RETURN (CAR MD))))
 (SETQ MDL NIL)
(MAPCAR #'(LAMBDA(A B) (SETQ MDL(NCONC MDL (LIST A B)))) TUPLEL MD)
(SETQ MD NIL)
(SETQ ROW (CAR MAT)MAT (CDR MAT))
(SETQ LT (SETQ TUPLEL (NEXTLEVEL TUPLEL LINDEX)))
LOOP2(COND ((NULL LT) (SETQ MD (NREVERSE MD)) (GO LOOP1)))
(SETQ ID (CAR LT) LT (CDR LT)) (SETQ MD (CONS (COMPUMD ID ROW) MD)) (GO LOOP2) ))

(DEFUN ASSOO (E L) (PROG()
LOOP(COND ((NULL L) (RETURN NIL))
((EQUAL E (CAR L)) (RETURN (CADR L))))
(SETQ L (CDDR L))(GO LOOP)))

(DEFUN COMPUMD (ID ROW)
(PROG(E MINOR I D SIGN ANS)
(SETQ ANS 0 SIGN -1 I ID)
LOOP(COND ((NULL I)(RETURN ANS))) 
(SETQ D (CAR I) I (CDR I) SIGN (TIMES -1 SIGN))
(COND ((EQUAL (SETQ E(ITH ROW D)) 0)(GO LOOP))
((EQUAL (SETQ MINOR(ASSOO (DELETE D(COPY ID)) MDL)) 0)(GO LOOP)))
(SETQ ANS (SIMPLUS (LIST '(MPLUS) ANS (SIMPTIMES (LIST '(MTIMES) SIGN E MINOR) 1 NIL)) 1 NIL)) (GO LOOP)))

(DECLARE(SPECIAL LTP*))

(DEFUN APDL (L1 L2)
((LAMBDA(LTP*)(MAPCAR #'(LAMBDA(J) (SETQ LTP*(CONS(APPEND L1 (LIST J))LTP*))) L2)(NREVERSE LTP*))NIL)
)

(DECLARE(UNSPECIAL LTP*))

(DEFUN NEXTLEVEL (TUPLEL LINDEX)
(PROG(ANS L LI)
LOOP (COND ((NULL TUPLEL )(RETURN ANS)))
(SETQ L (CAR TUPLEL) TUPLEL (CDR TUPLEL) LI (CDR (NCDR LINDEX (CAR (LAST L)))))
(COND ((NULL LI) (GO LOOP)))
(SETQ ANS(NCONC ANS (APDL L LI))) (GO LOOP)))

(DEFUN DET1 (X)
  (COND ($SPARSE (MTOA 'M* (LENGTH X) (LENGTH X) 
		       (MAPCAR #'(LAMBDA (X) (MAPCAR #'(LAMBDA (Y) (NCONS Y)) X))X))
		 (SPRDET 'M* (LENGTH X)))
	(T (TREEDET X))))

(DEFMFUN $IDENT (N) (CONS '($MATRIX) (MXC (DIAGMATRIX N 1 '$IDENT))))
 
(DEFMFUN $DIAGMATRIX (N VAR)
 (CONS '($MATRIX) (MXC (DIAGMATRIX N VAR '$DIAGMATRIX))))

(DEFUN DIAGMATRIX (N VAR FN)
       (PROG (I ANS)
	     (IF (OR (NOT (EQ (TYPEP N) 'FIXNUM)) (MINUSP N))
		 (IMPROPER-ARG-ERR N FN))
	     (SETQ I N)
	LOOP (IF (ZEROP I) (RETURN ANS))
	     (SETQ ANS (CONS (ONEN I N VAR 0) ANS) I (1- I))
	     (GO LOOP)))

; ATOMAT GENERATES A MATRIX FROM A MXN ARRAY BY TAKING COLUMNS S TO N

(DEFUN ATOMAT (NAME M N S)
       (PROG (J D ROW MAT)
	     (SETQ M (1+ M) N (1+ N)) 
	LOOP1(COND ((= M 1) (RETURN MAT)))
	     (SETQ M (1- M) J N)
	LOOP2(COND ((= J S) (SETQ MAT (CONS ROW MAT) ROW NIL) (GO LOOP1)))
	     (SETQ J (1- J))
	     (SETQ D (COND (TOP* (MEVAL (LIST (LIST NAME 'ARRAY) M J)))
			   (T (FUNCALL NAME M J))))
	     (SETQ ROW (CONS (OR D '(0 . 1)) ROW))
	     (GO LOOP2)))

(DEFMFUN $INVERTMX (K) 
  (LET ((*INV* T) *DET* LININD* TOP* MUL* ($RATMX T) (RATMX $RATMX) $RATFAC
	$SPARSE)
    (COND ((ATOM K) ($NOUNIFY '$INVERX) (LIST '(%INVERX) K))
	  (T (NEWVARMAT1 (SETQ K (CHECK K)))
	     (SETQ K (INVERT1 (REPLIST1 (MCX (CDR K)))))
	     (SETQ K (COND ($DETOUT `((MTIMES)
				      ((MEXPT) ,(RDIS (OR *DET* '(1 . 1))) -1)
				      (($MATRIX) ,@(MXC (DISREPLIST1 K)))))
			   (T (CONS '($MATRIX) (MXC (DISREPLIST1 K))))))
	     (COND ((AND RATMX (NOT $DETOUT))
		    (FMAPL1 #'(LAMBDA (X) X) K))
		   ((NOT RATMX) ($TOTALDISREP K))
		   (T K))))))

(DEFUN DIAGINV (AX M)
       (SETQ AX (GET-ARRAY-POINTER AX))
       (COND ($DETOUT (SETQ *DET* 1)
		      (DO I 1 (1+ I) (> I M)
			  (SETQ *DET* (PLCM *DET* (CAR (ARRAYCALL T AX I I)))))
		      (SETQ *DET* (CONS *DET* 1))))
       (DO ((I 1 (1+ I))(ELM))
	   ((> I M))
	   (SETQ ELM (ARRAYCALL T AX I I))
	   (STORE (ARRAYCALL T AX I (+ M I))
		  (COND ($DETOUT (CONS (PTIMES (CDR ELM)
					       (PQUOTIENT (CAR *DET*) (CAR ELM))) 1))
			(T (RATINVERT ELM))))))

(DEFUN INVERT1 (K) 
       (PROG (L R G I M N EI* EJ* ONEOFF*) 
	     (SETQ L (LENGTH K) I 1) 
	     (COND ((= L (LENGTH (CAR K))) NIL)
		   (T(MERROR "Non-square matrix in inverse")))
	LOOP (COND ((NULL K) (GO L1))) 
	     (SETQ R (CAR K)) 
	     (SETQ G (NCONC G (LIST (NCONC R (ONEN I L '(1 . 1) '(0 . 1)))))) 
	     (SETQ K (CDR K) I (1+ I)) 
	     (GO LOOP) 
	L1   (SETQ K G)
	     (MTOA 'M* (SETQ M (LENGTH K)) (SETQ N (LENGTH (CAR K))) K)
	     (SETQ K NIL)
	     (COND ((DIAGP 'M* M) (DIAGINV 'M* M)) (T (TFGELI0 'M* M N)))
	     (SETQ K (ATOMAT 'M* M N (1+ M)))
	     (*REARRAY 'M*)
	     (RETURN K)))

(DEFUN DIAGP (AX M)
   (DECLARE (FIXNUM M I J))
   (PROG (I J)
	 (SETQ AX (GET-ARRAY-POINTER AX))
	 (SETQ I 0)
    LOOP1(SETQ I (1+ I) J 0)
         (COND((> I M) (RETURN T)))
    LOOP2(SETQ J (1+ J))
         (COND((> J M) (GO LOOP1))
	      ((AND (NOT (= I J))(EQUAL (ARRAYCALL T AX I J) '(0 . 1))) NIL)
	      ((AND(= I J)(NOT (EQUAL (ARRAYCALL T AX I J) '(0 . 1)))) NIL)
	      (T(RETURN NIL)))
	 (GO LOOP2)))

(DEFUN TFGELI0 (X M N) (COND((OR $SPARSE *DET*) (TFGELI X M N))
			    (T(TFGELI X M N) (DIAGLIZE1 X M N))))

	;  TWO-STEP FRACTION-FREE GAUSSIAN ELIMINATION ROUTINE

(DEFUN RITEDIV (X M N A)
  (DECLARE(FIXNUM J I M N))
  (PROG (J I D ERRRJFFLAG)
	(SETQ ERRRJFFLAG T)
	(SETQ I M)
  LOOP1 (COND ((ZEROP I) (RETURN NIL)))
	(STORE (FUNCALL X I I) NIL)
	(SETQ J M)
   LOOP (COND ((= J N) (SETQ I (1- I)) (GO LOOP1)))
	(SETQ J (1+ J))
	(COND ((EQUAL A 1)
	       (STORE (FUNCALL X I J) (CONS (FUNCALL X I J) 1))
	       (GO LOOP)))
	(SETQ D (*CATCH 'RATERR (PQUOTIENT (FUNCALL X I J) A)))
	(SETQ D (COND (D (CONS D 1)) (T (RATREDUCE (FUNCALL X I J) A))))
	(STORE (FUNCALL X I J) D)
	(GO LOOP)))

(DEFUN DIAGLIZE1 (X M N)
       (PROG NIL
	     (COND (*DET* (RETURN (PTIMES *DET* (FUNCALL X M M)))))
	     (SETQ *DET* (CONS (FUNCALL X M M) 1))
	     (COND ((NOT $DETOUT) (RETURN (RITEDIV X M N (FUNCALL X M M))))
		   (T (RETURN (RITEDIV X M N 1))))))

;; Takes an M by N matrix and creates an array containing the elements
;; of the matrix.  The array is associated "functionally" with the
;; symbol NAME.

(DEFUN MTOA (NAME M N MAT)
       (DECLARE (FIXNUM M N I J))
       (*ARRAY NAME T (1+ M) (1+ N))
       (SETQ NAME (GET-ARRAY-POINTER NAME))
       (DO ((I 1 (1+ I))
	    (MAT MAT (CDR MAT)))
	   ((> I M) NIL)
	   (DO ((J 1 (1+ J))
		(ROW (CAR MAT) (CDR ROW)))
	       ((> J N))
	       (STORE (ARRAYCALL T NAME I J) (CAR ROW)))))


(DEFMFUN $ECHELON (X)
 ((LAMBDA ($RATMX) (NEWVARMAT1 (SETQ X (CHECK X)))) T)
 ((LAMBDA (*ECH*)
   (SETQ X (CONS '($MATRIX) (MXC (DISREPLIST1 (ECHELON1 (REPLIST1 (MCX (CDR X)))))))))
  T)
 (COND ($RATMX X) (T ($TOTALDISREP X))))

(DEFUN ECHELON1 (X)
       ((LAMBDA (M N)
	 (MTOA 'M* M N X)
(SETQ X (*CATCH 'RANK (TFGELI 'M* M N)))
(COND ((AND *RANK* X)(*THROW 'RNK X))(T (ECHELON2 'M* M N))))
	(LENGTH X) (LENGTH (CAR X))))

(DEFUN ECHELON2 (NAME M N)
(DECLARE (FIXNUM M N J))
       (PROG (J ROW MAT A)
	     (SETQ M (1+ M)) 
	LOOP1(COND ((= M 1) #+MacLisp (*REARRAY NAME) (RETURN MAT)))
	     (SETQ M (1- M) J 0 A NIL)
	LOOP2(COND ((= J N) (SETQ MAT (CONS ROW MAT) ROW NIL) (GO LOOP1)))
	     (SETQ J (1+ J))
	     (SETQ ROW (NCONC
			ROW (NCONS
			     (COND ((OR(> M J)(EQUAL (FUNCALL NAME M J)  0))
				    '(0 . 1))
				   (A (RATREDUCE (FUNCALL NAME M J)A))
				   (T (SETQ A (FUNCALL NAME M J)) '(1 . 1))))))
	     (GO LOOP2)))



(DEFUN TRIANG (X)
       ((LAMBDA (M N *TRI*)
	 (MTOA 'M* M N X) 
	 (TFGELI 'M* M N)
	 (TRIANG2 'M* M N))
	(LENGTH X) (LENGTH (CAR X)) T))


(DEFUN TRIANG2 (NAM M N)
(DECLARE (FIXNUM M N J))
       (PROG (J ROW MAT)
(STORE (FUNCALL NAM 0 0) 1)
	     (SETQ M (1+ M)) 
	LOOP1(COND ((= M 1) #+MacLisp (*REARRAY NAM) (RETURN MAT)))
	     (SETQ M (1- M) J 0)
	LOOP2(COND ((= J N) (SETQ MAT (CONS ROW MAT) ROW NIL) (GO LOOP1)))
	     (SETQ J (1+ J))
	     (SETQ ROW (NCONC ROW (NCONS
				   (COND ((> M J) '(0 . 1))
					 (T (CONS (FUNCALL NAM M J) 1))))))
	     (GO LOOP2)))

(DEFMFUN ONEN (N I VAR FILL)
       (PROG (G)
	LOOP (COND ((= I N) (SETQ G (CONS VAR G)))
		   ((ZEROP I) (RETURN G)) 
		   (T (SETQ G (CONS FILL G))))
	     (SETQ I (1- I))
	     (GO LOOP)))

(DEFUN TIMEX0 (X Y)
 ((LAMBDA (U V)
   (COND ((AND (NULL U) (NULL V)) (LIST '(MTIMES) X Y))
	 ((NULL U) (TIMEX1 X (CONS '($MATRIX) (MCX (CDR V)))))
	 ((NULL V) (TIMEX1 Y (CONS '($MATRIX) (MCX (CDR U)))))
	 (T (CONS '($MATRIX MULT) (MXC (MULTIPLYMATRICES (MCX (CDR U)) (MCX (CDR V))))))))
  (CHECK1 X) (CHECK1 Y)))
 
(DEFUN TIMEX1 (X Y)
       (SETQ Y (CHECK Y))
       (COND ((NOT $RATMX) (SETQ Y (CDR Y)))
	     (T (SETQ X (CDR (RATF X)) Y (REPLIST1 (CDR Y)))))
       (CTIMESX X Y))

(DEFUN CTIMESX (X Y)
       (PROG (C)
	LOOP (COND ((NULL Y) 
		    (RETURN (CONS '($MATRIX MULT)
				  (MXC (COND ((NOT $RATMX) C) (T (DISREPLIST1 C)))))))) 
	     (SETQ C (NCONC C (LIST (TIMESROW X (CAR Y)))) Y (CDR Y))
	     (GO LOOP)))
 
(DEFUN MULTIPLYMATRICES (X Y) 
       (COND ((AND (NULL (CDR Y)) (NULL (CDR X)))
	      (AND (CDAR X) (SETQ Y (TRANSPOSE Y))))
	     ((AND (NULL (CDAR X)) (NULL (CDAR Y)))
	      (AND (CDR Y) (SETQ X (TRANSPOSE X)))))
       (COND ((NOT (= (LENGTH (CAR X)) (LENGTH Y)))
	      (COND ((AND (NULL (CDR Y)) (= (LENGTH (CAR X)) (LENGTH (CAR Y))))
		     (SETQ Y (TRANSPOSE Y)))
		    (T (MERROR "incompatible dimensions - cannot multiply")))))
       (COND ((NOT $RATMX) (MULTMAT X Y))
	     (T (SETQ X (REPLIST1 X) Y (REPLIST1 Y)) 
		(DISREPLIST1 (MULTMAT X Y))))) 

(DEFUN MULTMAT (X Y)
       (PROG (MAT ROW YT ROWX)
	     (SETQ YT (TRANSPOSE Y))
	LOOP1(COND ((NULL X) (RETURN MAT)))
	     (SETQ ROWX (CAR X) Y YT)
	LOOP2(COND ((NULL Y)
		    (SETQ MAT (NCONC MAT (NCONS ROW)) X (CDR X) ROW NIL)
		    (GO LOOP1)))
	     (SETQ ROW (NCONC ROW (NCONS (MULTL ROWX (CAR Y)))) Y (CDR Y))
	     (GO LOOP2)))


;;; This actually takes the inner product of the two vectors.
;;; I check for the most common cases for speed. '|&*| is a slight
;;; violation of data abstraction here. The parser should turn "*" into
;;; MTIMES, well, it may someday, which will break this code. Don't
;;; hold your breath.

(DEFUN MULTL (A B)
       (COND ((EQ $MATRIX_ELEMENT_ADD '|&+|)
	      (DO ((ANS (IF (NOT $RATMX) 0 '(0 . 1))
			(COND ((NOT $RATMX)
			       (COND ((EQ $MATRIX_ELEMENT_MULT '|&*|)
				      (ADD ANS (MUL (CAR A) (CAR B))))
				     ((EQ $MATRIX_ELEMENT_MULT '|&.|)
				      (ADD ANS (NCMUL (CAR A) (CAR B))))
				     (T
				      (ADD ANS
					   (MEVAL `((,(GETOPR $MATRIX_ELEMENT_MULT))
						    ((MQUOTE SIMP) ,(CAR A))
						    ((MQUOTE SIMP) ,(CAR B))))))))
			      (T
			       (RATPLUS ANS (RATTIMES (CAR A) (CAR B) T)))))
		   (A A (CDR A))
		   (B B (CDR B)))
		  ((NULL A) ANS)))
	     (T
	      (MAPPLY (GETOPR $MATRIX_ELEMENT_ADD)
		      (MAPCAR #'(LAMBDA (U V)
				 (MEVAL `((,(GETOPR $MATRIX_ELEMENT_MULT))
					  ((MQUOTE SIMP) ,U)
					  ((MQUOTE SIMP) ,V))))
			      A B)
		      (GETOPR $MATRIX_ELEMENT_ADD)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	   
;; I leave this for your historical enjoyment. har har.
;       (PROG (ANS)
;	     (SETQ ANS (COND ((NOT $RATMX) 0) (T '(0 . 1))))
;	LOOP (COND ((NULL A) (RETURN ANS))) 
;	     (SETQ ANS (COND ((NOT $RATMX)
;			      (SIMPLUS (LIST '(MPLUS)  ANS  (SIMPTIMES
;							     (LIST '(MTIMES)
;								   (CAR A)(CAR B))
;							     1 T)) 1 T)
;			      )
;			     (T (RATPLUS ANS (RATTIMES (CAR A) (CAR B) T)))))
;	     (SETQ A (CDR A) B (CDR B))
;	     (GO LOOP))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(DEFMFUN BBSORT (L FN) (NREVERSE (SORT (APPEND L NIL) FN)))

(DEFMFUN POWERX (MAT X) 
       (PROG (N Y) 
	     (COND ((NOT (EQ (TYPEP X) 'FIXNUM))
		    (RETURN (LIST '(MNCEXPT SIMP) MAT X)))
		   ((= X 1) (RETURN MAT))
		   ((MINUSP X)
		    (SETQ X (MINUS X) MAT ($INVERTMX MAT))
		    (COND ($DETOUT
			   (RETURN (LET ((*INV* '$DETOUT))
					(MUL2*
					 (POWER* (CADR MAT) X)
					 (FMAPL1 #'(LAMBDA (X) X)
						 (POWERX (CADDR MAT) X)))))))))
	     (NEWVARMAT1 (SETQ MAT (CHECK MAT)))
	     (SETQ N 1 MAT (MCX (CDR MAT)) Y MAT) 
	LOOP (IF (= N X)
		 (LET (($SCALARMATRIXP (IF (EQ $SCALARMATRIXP '$ALL) '$ALL)))
		   (RETURN (SIMPLIFY (CONS '($MATRIX MULT) (MXC Y))))))
	     (SETQ Y (MULTIPLYMATRICES Y MAT) N (1+ N)) 
	     (GO LOOP))) 

;; The following $ALGEBRAIC code is so that 
;; RANK(MATRIX([1-SQRT(5),2],[-2,1+SQRT(5)])); will give 1.
;; - JPG and BMT
 
(DEFMFUN $RANK (X)
 (LET ((*RANK* T) ($RATMX T) ($ALGEBRAIC $ALGEBRAIC))
      (NEWVARMAT1 (SETQ X (CHECK X)))
      (AND (NOT $ALGEBRAIC) (ORMAPC #'ALGP VARLIST) (SETQ $ALGEBRAIC T))
      (SETQ X (REPLIST1 (MCX (CDR X))))
      (MTOA 'M* (LENGTH X) (LENGTH (CAR X)) X)
      (TFGELI 'M* (LENGTH X) (LENGTH (CAR X)))))

(DEFUN REPLACEROW (I Y X)
 (IF (= I 1) (NCONC (LIST Y) (CDR X))
	     (NCONC (LIST (CAR X)) (REPLACEROW (1- I) Y (CDR X)))))
 
(DEFUN TIMESROW (Y ROW)
 (PROG (ANS)
       (COND ((AND $RATMX (ATOM Y) Y) (SETQ Y (CDR (RATF Y)))))
  LOOP (COND ((NULL ROW) (RETURN ANS)))
       (SETQ ANS (NCONC ANS (LIST (COND ((NOT $RATMX)
					 (SIMPTIMES
					  (LIST '(MTIMES) Y (CAR ROW)) 1 NIL))
					(T (RATTIMES Y (CAR ROW) T))))))
       (SETQ ROW (CDR ROW))
       (GO LOOP)))
 
(DEFMFUN $TRIANGULARIZE (X) 
  ((LAMBDA ($RATMX) (NEWVARMAT1 (SETQ X (CHECK X)))) T)
  (SETQ X (CONS '($MATRIX) (MXC (DISREPLIST1 (TRIANG (REPLIST1 (MCX (CDR X)))))))) 
  (COND ($RATMX X) (T ($TOTALDISREP X))))

(DEFMFUN $COL (MAT N)
  (CONS '($MATRIX) (MXC (TRANSPOSE (LIST (NTHCOL (MCX (CDR (CHECK MAT))) N)))))) 

(DEFUN DELETECOL (N X)
       (PROG (M G)
	     (SETQ M X)
	LOOP (COND ((NULL M) (RETURN G)))
	     (SETQ G (NCONC G (NCONS (DELETEROW N (CAR M)))) M (CDR M))
	     (GO LOOP)))
 
(DEFUN DELETEROW (I M) 
       (COND ((OR(NULL M)(LESSP I 0))(MERROR "Incorrect index - MATRIX"))
((= I 1) (CDR M)) 
	     (T (CONS (CAR M) (DELETEROW (1- I) (CDR M)))))) 
 
(DEFMFUN $MINOR (MAT M N) (CONS '($MATRIX) (MXC (MINOR M N (MCX (CDR (CHECK MAT)))))))
 
(DEFUN MINOR (I J M) (DELETECOL J (DELETEROW I M))) 

(DEFMFUN $ROW (MAT M) (CONS '($MATRIX) (MXC (LIST (ITH (MCX (CDR (CHECK MAT))) M)))))

(DEFMFUN $SETELMX (ELM M N MAT) 
       (COND ((NOT (AND (FIXP M) (FIXP N) ($MATRIXP MAT)))
	      (MERROR "Wrong arg to SETELMX"))
	     ((NOT (AND (> M 0) (> N 0) (> (LENGTH MAT) M) (> (LENGTH (CADR MAT)) N)))
	      (MERROR "No such entry - SETELMX")))
       (RPLACA (NCDR (CAR (NCDR MAT (1+ M))) (1+ N)) ELM) MAT) 
 
;;; Here the function transpose can actually do simplification of
;;; its argument. TRANSPOSE(TRANSPOSE(FOO)) => FOO.
;;; If you think this is a hack, well, realize that the hack is
;;; actually the fact that TRANSPOSE can return a noun form.

(DEFMFUN $TRANSPOSE (MAT)
       (COND ((NOT (MXORLISTP MAT))
	      (COND ((AND (NOT (ATOM MAT))
			  (EQ (CAAR MAT) '%TRANSPOSE))
		     (CADR MAT))
		    (($SCALARP MAT) MAT)
		    ((MPLUSP MAT)
		     `((MPLUS) .,(MAPCAR #'$TRANSPOSE (CDR MAT))))
		    ((MTIMESP MAT)
		     `((MTIMES) .,(MAPCAR #'$TRANSPOSE (CDR MAT))))
		    ((MNCTIMESP MAT)
		     `((MNCTIMES) .,(NREVERSE (MAPCAR #'$TRANSPOSE (CDR MAT)))))
		    ((MNCEXPTP MAT)
		     (LET (((MAT POW) (CDR MAT)))
			  `((MNCEXPT) ,($TRANSPOSE MAT) ,POW)))
			   
		    (T ($NOUNIFY '$TRANSPOSE) (LIST '(%TRANSPOSE) MAT))))
	     (T
	      (LET ((ANS (TRANSPOSE (MCX (CDR (CHECK MAT))))))
		   (COND ($MATRIX_ELEMENT_TRANSPOSE
			  (SETQ ANS (MAPCAR #'(LAMBDA (U)
						      (MAPCAR #'TRANSPOSE-ELS
							      U))
					    ANS))))
		   `(($MATRIX) . ,(MXC ANS))))))

;;; THIS IS FOR TRANSPOSING THE ELEMENTS OF A MATRIX
;;; A hack for Block matricies and tensors.

(DEFUN TRANSPOSE-ELS (ELEM)
       (COND ((EQ $MATRIX_ELEMENT_TRANSPOSE '$TRANSPOSE)
	      ($TRANSPOSE ELEM))
	     ((EQ $MATRIX_ELEMENT_TRANSPOSE '$NONSCALARS)
	      (COND (($NONSCALARP ELEM)
		     ($TRANSPOSE ELEM))
		    (T ELEM)))
	     (T
	      (MEVAL `((,(GETOPR $MATRIX_ELEMENT_TRANSPOSE)) ((MQUOTE SIMP) ,ELEM))))))


(DEFMFUN $SUBMATRIX NARGS
 (PROG (R C X)
       (SETQ X (LISTIFY NARGS))
  L1   (COND ((NUMBERP (CAR X)) (SETQ R (CONS (CAR X) R) X (CDR X)) (GO L1)))
       (SETQ C (NREVERSE (BBSORT (CDR X) 'GREATERP)) R (NREVERSE (BBSORT R 'GREATERP)))
       (SETQ X (MCX (CDAR X)))
  L2   (COND ((NULL R) (GO B)) (T (SETQ X (DELETEROW (CAR R) X))))
       (SETQ R (CDR R))
       (GO L2)
  B    (COND ((NULL C) (RETURN (CONS '($MATRIX) (MXC X)))))
       (SETQ X (DELETECOL (CAR C) X) C (CDR C))
       (GO B)))


; Undeclarations for the file:
(DECLARE (NOTYPE NN LEN))

