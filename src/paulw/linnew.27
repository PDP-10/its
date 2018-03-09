;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module linnew)

;; This is a matrix package which uses minors, basically.
;; TMLINSOLVE(LIST-OF-EQUAIONS,LIST-OF-VARIABLES,LIST-OF-VARIABLES-TO-BE-OBTAINED)
;; solves the linear equation. LIST-OF-VARIABLES-TO-BE-OBTAINED can be omitted,
;; in which case all variables are obtained. TMNEWDET(MATRIX,DIMENSION)
;; computes the determinant.  DIMENSION can be omitted.  The default is
;; DIMENSION=(declared dimension of MATRIX). TMINVERSE(MATRIX) computes the
;; inverse of matrix.

;; The program uses hash arrays to remember the minors if N > threshold.  If
;; $WISE is set to T, the program knocks out unnecessary elements.  But also it
;; kills necessary ones in the case of zero elements! The $WISE flag should
;; not be set to T for inverse.  The default of $WISE is NIL.

(DECLARE (ARRAY* (NOTYPE TMARRAYS 1 A2 2 B 2 AA 2
			 ROW 1 COL 1 ROWINV 1 COLINV 1 INDX 1))) 

(DECLARE (SPECIAL N NX IX)) 

(DECLARE (SPECIAL $LINENUM $DISPFLAG $LINECHAR $WISE $FOOL)) 

;; If N < threshold declared array is used, otherwise hashed array.

(DEFMACRO THRESHOLD () 10.)

(DEFUN TMINITIALFLAG NIL 
       (COND ((NOT (BOUNDP '$WISE)) (SETQ $WISE NIL)))
       (COND ((NOT (BOUNDP '$FOOL)) (SETQ $FOOL NIL))))

;; TMDET returns the determinant of N*N matrix A2 which is in an globally
;; declared array A2.

(DEFUN TMDET (A4 N) 
       (PROG (INDEX RESULT IX) 
	     (TMINITIALFLAG)
	     (TMHEADING)
	     (SETQ IX 0. NX 0.)
	     (DO ((I 1. (1+ I)))
		 ((> I N))
		 (SETQ INDEX (CONS I INDEX)))
	     (SETQ INDEX (REVERSE INDEX))
	     (SETQ RESULT (TMINOR A4 N 1. INDEX 0.))
	(RETURN RESULT)))

;; TMLIN SOLVES M SETS OF LINEAR EQUATIONS WHITH N UNKNOWN VARIABLES. IT SOLVES
;; ONLY FOR THE FIRST NX UNKNOWNS OUT OF N. THE EQUATIONS ARE EXPRESSED IN
;; MATRIX FORM WHICH IS IN N*(N+M) ARRAY A2. AS USUAL , THE LEFT HAND SIDE N*N
;; OF A2 REPRESENTS THE COEFFICIENT MATRIX, AND NEXT N*M OF A2 IS THE RIGHT
;; HAND SIDE OF THE M SETS OF EQUATIONS.  SUPPOSE N=3, M=2, AND THE UNKKNOWNS
;; ARE (X1 Y1 Z1) FOR THE FIRST SET AND (X2 Y2 Z2) FOR THE SECOND. THEN THE
;; RESULT OF TMLIN IS ((DET) (U1 U2) (V1 V2) (W1 W2)) WHERE DET IS THE
;; DETERMINANT OF THE COEFFICIENT MATRIX AND X1=U1/DET, X2=U2/DET, Y1=V1/DET,
;; Y2=V2/DET ETC.

(DEFUN TMLIN (A4 N M NX) 
       (PROG (INDEX R) 
	     (TMDEFARRAY N)
	     (TMINITIALFLAG)
	     (TMHEADING)
	     (DO ((I 1. (1+ I)))
		 ((> I N))
		 (SETQ INDEX (CONS I INDEX)))
	     (SETQ INDEX (REVERSE INDEX))
	     (SETQ R
		   (DO ((IX 0. (1+ IX)) (RESULT))
		       ((> IX NX) (REVERSE RESULT))
		       (SETQ RESULT
			     (CONS (DO ((I 1. (1+ I)) (RES))
				       ((> I
					   (COND ((= IX 0.) 1.)
						 (T M)))
					(REVERSE RES))
				       (COND ((NOT $WISE)
					      (TMKILLARRAY IX)))
				       (SETQ RES
					     (CONS (TMINOR A4
							   N
							   1.
							   INDEX
							   I)
						   RES)))
				   RESULT))
		       (COND ((AND (= IX 0.)
				   (EQUAL (CAR RESULT)
					  '(0. . 1.)))
			      (merror "COEFFICIENT MATRIX IS SINGULAR")))))
	     (TMREARRAY N)
	     (RETURN R)))

;; TMINOR ACTUALLY COMPUTES THE MINOR DETERMINANT OF A SUBMATRIX OF A2, WHICH
;; IS CONSTRUCTED BY EXTRACTING ROWS (K,K+1,K+2,...,N) AND COLUMNS SPECIFIED BY
;; INDEX. N IS THE DIMENSION OF THE ORIGINAL MATRIX A2.  WHEN TMINOR IS USED
;; FOR LINEAR EQUATION PROGRAM, JRIGHT SPECIFIES A COLUMN OF THE CONSTANT
;; MATRIX WHICH IS PLUGED INTO AN IX-TH COLUMN OF THE COEFFICIENT MATRIX FOR
;; ABTAINING IX-TH UNKNOWN. IN OTHER WORDS, JRIGHT SPECIFIES JRIGHT-TH
;; EQUATION.


(DEFUN TMINOR (A4 N K INDEX JRIGHT) 
       (PROG (SUBINDX L RESULT NAME AORB) 
	     (COND
	      ((= K N)
	       (SETQ RESULT
		     (COND ((= K IX) (FUNCALL A4 (CAR INDEX) (+ JRIGHT N)))
			   (T (FUNCALL A4 (CAR INDEX) K)))))
	      (T
	       (DO
		((J 1. (1+ J)) (SUM '(0. . 1.)))
		((> J (1+ (- N K))) (SETQ RESULT SUM))
		(SETQ L (EXTRACT INDEX J))
		(SETQ SUBINDX (CADR L))
		(SETQ L (CAR L))
		(SETQ AORB (COND ((= K IX) (FUNCALL A4 L (+ JRIGHT N)))
				 (T (FUNCALL A4 L K))))
		(COND
		 ((NOT (EQUAL AORB '(0. . 1.)))
		  (SETQ NAME (TMACCESS SUBINDX))
		  (SETQ 
		   SUM
		   (FUNCALL (COND ((ODDP J) 'RATPLUS)
				  (T 'RATDIFFERENCE))
		    SUM
		    (RATTIMES
		     AORB
		     (COND ($FOOL (TMINOR A4 N (1+ K) SUBINDX JRIGHT))
			   (T (COND ((NOT (NULL (TMEVAL NAME)))
				     (TMEVAL NAME))
				    ((TMNOMOREUSE J L K)
				     (TMSTORE NAME NIL)
				     (TMINOR A4
					     N
					     (1+ K)
					     SUBINDX
					     JRIGHT))
				    (T (TMSTORE NAME
						(TMINOR A4
							N
							(1+ K)
							SUBINDX
							JRIGHT))))))
		     T)))))
		(COND ($WISE (COND ((TMNOMOREUSE J L K)
				    (TMKILL SUBINDX K))))))))
	     (RETURN RESULT))) 

(DEFUN EXTRACT (INDEX J) 
       (DO ((IND INDEX (CDR IND)) (COUNT 1. (1+ COUNT)) (SUBINDX))
	   ((NULL IND))
	   (COND ((= COUNT J)
		  (RETURN (LIST (CAR IND) (NCONC SUBINDX (CDR IND)))))
		 (T (SETQ SUBINDX (NCONC SUBINDX (LIST (CAR IND)))))))) 

(DECLARE (SPECIAL VLIST VARLIST GENVAR)) 

(DEFUN TMRATCONV (BBB N M) 
       (PROG (CCC) 
	     (SET 'CCC BBB)
	     (DO ((K 1. (1+ K)))
		 ((> K N))
		 (DO ((J 1. (1+ J)))
		     ((> J M))
		     (NEWVAR1 (STORE (A2 K J)
				     (MEVAL (LIST (LIST 'CCC
							'ARRAY)
						  K
						  J))))))
	     (NEWVAR (CONS '(MTIMES) VLIST))
	     (DO ((K 1. (1+ K)))
		 ((> K N))
		 (DO ((J 1. (1+ J)))
		     ((> J M))
		     (STORE (A2 K J)
			    (CDR (RATREP* (A2 K J)))))))) 

(DEFMFUN $TMNEWDET N 
       (PROG (AA R VLIST) 
	     (COND ((= N 2.)
		    (COND ((NOT (FIXP (SETQ N (ARG 2.))))
			   (merror  "WRONG ARG")))
		    (SETQ AA (ARG 1.)))
		   ((AND (= N 1.) ($MATRIXP (SETQ AA (ARG 1.))))
		    (SETQ N (LENGTH (CDR (ARG 1.)))))
		   (T (merror "WRONG ARG")))
	     (ARRAY A2 T (1+ N) (1+ N))
	     (TMDEFARRAY N)
	     (TMRATCONV AA N N)
	     (SETQ R (CONS (LIST 'MRAT
				 'SIMP
				 VARLIST
				 (CDR GENVAR))
			   (TMDET 'A2 N)))
	     (*TMREARRAY 'A2)
	     (TMREARRAY N)
	     (RETURN R))) 

(DEFMFUN $TMLINSOLVE NARG (TMLINSOLVE (LISTIFY NARG))) 

(DEFUN TMLINSOLVE (ARGLIST) 
       (PROG (EQUATIONS VARS OUTVARS RESULT AA) 
	     (SETQ EQUATIONS (CDAR ARGLIST) 
		   VARS (CDADR ARGLIST) 
		   OUTVARS (COND ((NULL (CDDR ARGLIST)) VARS)
				 (T (CDADDR ARGLIST))) 
		   ARGLIST NIL)
	     (SETQ VARS (TMERGE VARS OUTVARS))
	     (SETQ NX (LENGTH OUTVARS))
	     (SETQ N (LENGTH VARS))
	     (COND ((NOT (= N (LENGTH EQUATIONS)))
		    (RETURN (PRINT 'TOO-FEW-OR-MUCH-EQUATIONS))))
	     (SETQ 
	      AA
	      (CONS
	       '($MATRIX SIMP)
	       (MAPCAR 
		'(LAMBDA (EXP) 
		  (APPEND
		   '((MLIST))
		   (MAPCAR '(LAMBDA (V) 
				    (PROG (R) 
					  (SETQ EXP
						($BOTHCOEF EXP V)
						R
						(CADR EXP)
						EXP
						(MEVAL (CADDR EXP)))
					  (RETURN R)))
			   VARS)
		   (LIST (LIST '(MMINUS) EXP))))
		(MAPCAR '(LAMBDA (E) (MEVAL (LIST '(MPLUS)
						  ($LHS E)
						  (LIST '(MMINUS)
							($RHS E)))))
			EQUATIONS))))
	     (SETQ RESULT (CDR ($TMLIN AA N 1. NX)))
	     (RETURN
	      (DO
	       ((VARS (CONS NIL OUTVARS) (CDR VARS))
		(LABELS)
		(DLABEL)
		(NAME))
	       ((NULL VARS)
		(CONS '(MLIST) (CDR (REVERSE LABELS))))
	       (SETQ NAME (MAKELABEL $LINECHAR))
	       (SETQ $LINENUM (1+ $LINENUM))
	       (SET NAME
		    (COND ((NULL (CAR VARS))
			   (SETQ DLABEL NAME)
			   (CADAR RESULT))
			  (T (LIST '(MEQUAL)
				   (CAR VARS)
				   (LIST '(MTIMES SIMP)
					 (CADAR RESULT)
					 (LIST '(MEXPT SIMP)
					       DLABEL
					       -1.))))))
	       (SETQ LABELS (CONS NAME LABELS))
	       (SETQ RESULT (CDR RESULT))
	       (COND
		($DISPFLAG (MTELL-OPEN "~M" (NCONC (NCONS '(MLABLE))
					  (NCONS NAME)
					  (NCONS (EVAL NAME)))))))))) 

(DEFUN TMERGE (VARS OUTVARS) 
       (APPEND OUTVARS
	       (PROG (L) 
		     (MAPCAR '(LAMBDA (V) 
				      (COND ((MEMBER V OUTVARS) NIL)
					    (T (SETQ L (CONS V L)))))
			     VARS)
		     (RETURN (REVERSE L))))) 

(DEFMFUN $TMLIN (AA N M NX) 
       (PROG (R VLIST) 
	     (ARRAY A2 T (1+ N) (1+ (+ M N)))
	     (TMRATCONV AA N (+ M N))
	     (SETQ 
	      R
	      (CONS
	       '(MLIST)
	       (MAPCAR 
		'(LAMBDA (RES) 
		  (CONS '(MLIST)
			(MAPCAR '(LAMBDA (RESULT) 
					 (CONS (LIST 'MRAT
						     'SIMP
						     VARLIST
						     (CDR GENVAR))
					       RESULT))
				RES)))
		(TMLIN 'A2 N M NX))))
	     (*TMREARRAY 'A2)
	     (RETURN R))) 

(DEFUN TMKILL (INDX K) 
       (PROG (NAME SUBINDX J L) 
	     (COND ((NULL INDX) (RETURN NIL)))
	     (SETQ NAME (TMACCESS INDX))
	     (COND ((NOT (NULL (TMEVAL NAME))) (TMSTORE NAME NIL))
		   (T (DO ((IND INDX (CDR IND)) (COUNT 1. (1+ COUNT)))
			  ((NULL IND))
			  (SETQ L (EXTRACT INDX COUNT) 
				J (CAR L) 
				SUBINDX (CADR L))
			  (COND ((= J COUNT)
				 (TMKILL SUBINDX (1+ K))))))))) 

(DEFUN TMNOMOREUSE (J L K) 
       (COND ((AND (= J L) (OR (> K NX) (< K (1+ IX)))) T) (T NIL))) 

(DEFUN TMDEFARRAY (N) 
       (PROG (NAME) 
	     (COND
	      ((GET 'TMARRAYS 'ARRAY)
	       (TMREARRAY (1- (COND ((CADR (ARRAYDIMS 'TMARRAYS)))
				    (T 1.))))))
	     (ARRAY TMARRAYS T (1+ N))
	     (DO ((I 1. (1+ I)))
		 ((> I N))
		 (SETQ NAME (COND ((= I 1.) (GENSYM 'M))
				  (T (GENSYM))))
		 (COND ((< N (THRESHOLD))
			(STORE (TMARRAYS I) NAME)
			(*ARRAY NAME T (1+ (TMCOMBI N I))))
		       (T (STORE (TMARRAYS I)
				 (LIST NAME
				       'SIMP
				       'ARRAY)))))
	     (GENSYM 'G)))

;; TMREARRAY kills the TMARRAYS which holds pointers to minors. If (TMARRAYS I)
;; is an atom, it is declared array.  Otherwise it is hashed array.

(DEFUN TMREARRAY (N) 
       (PROG NIL 
	     (DO ((I 1. (1+ I)))
		 ((> I N))
		 (COND ((ATOM (TMARRAYS I)) (*TMREARRAY (TMARRAYS I)))
		       (T (TM$KILL (CAR (TMARRAYS I))))))
	     (*TMREARRAY 'TMARRAYS))) 

(DEFUN TMACCESS (INDEX) 
       (PROG (L) 
	     (COND ($FOOL (RETURN NIL)))
	     (SETQ L (LENGTH INDEX))
	     (RETURN
	      (COND ((< N (THRESHOLD))
		     (LIST (TMARRAYS L)
			   (DO ((I 1. (1+ I))
				(X 0. (CAR Y))
				(Y INDEX (CDR Y))
				(SUM 0.))
			       ((> I L) (1+ SUM))
			       (DO ((J (1+ X) (1+ J)))
				   ((= J (CAR Y)))
				   (SETQ SUM (+ SUM
						(TMCOMBI (- N J)
							 (- L I))))))))
		    (T (CONS (TMARRAYS L) INDEX)))))) 

(DEFUN TMCOMBI (N I) 
       (COND ((> (- N I) I)
	      (// (TMFACTORIAL N (- N I)) (TMFACTORIAL I 0.)))
	     (T (// (TMFACTORIAL N I) (TMFACTORIAL (- N I) 0.))))) 

(DEFUN TMFACTORIAL (I J) 
       (COND ((= I J) 1.) (T (* I (TMFACTORIAL (1- I) J))))) 

(DEFUN TMSTORE (NAME X) 
       (COND ((< N (THRESHOLD))
	      (EVAL (LIST 'STORE NAME (LIST 'QUOTE X))))
	     (T (MSET NAME (LIST '(MQUOTE SIMP) X)) X)))

;; TMKILLARRAY kills all (N-IX+1)*(N-IX+1) minors which are not necessary for
;; the computation of IX-TH variable in the linear equation.  Otherwise, they
;; will do harm.

(DEFUN TMKILLARRAY (IX) 
       (DO ((I (1+ (- N IX)) (1+ I)))
	   ((> I N))
	   (COND ((< N (THRESHOLD))
		  (FILLARRAY (TMARRAYS I) '(NIL)))
		 (T (TM$KILL (CAR (TMARRAYS I))))))) 

(DEFUN TMHEADING NIL NIL) 

(DEFUN TMEVAL (E) 
       (PROG (RESULT) 
	     (RETURN (COND ((< N (THRESHOLD)) (EVAL E))
			   (T (SETQ RESULT (MEVAL E))
			      (COND ((EQUAL RESULT E) NIL)
				    (T (CADR RESULT)))))))) 

(DEFUN TM$KILL (E) (KILL1 E))

(DEFMFUN $TMINVERSE (AA) 
       (PROG (R VLIST N M NX) 
	     (SETQ N (LENGTH (CDR AA)) M N NX N)
	     (ARRAY A2 T (1+ N) (1+ (+ M N)))
	     (TMRATCONV AA N N)
	     (DO ((I 1. (1+ I)))
		 ((> I N))
		 (DO ((J 1. (1+ J)))
		     ((> J M))
		     (STORE (A2 I (+ N J))
			    (COND ((= I J) '(1. . 1.))
				  (T '(0. . 1.))))))
	     (SETQ 
	      R
	      (MAPCAR 
	       '(LAMBDA (RES) 
		 (CONS
		  '(MLIST)
		  (MAPCAR 
		   '(LAMBDA (RESULT) 
			    ($RATDISREP (CONS (LIST 'MRAT
						    'SIMP
						    VARLIST
						    (CDR GENVAR))
					      RESULT)))
		   RES)))
	       (TMLIN 'A2 N M NX)))
	     (SETQ R
		   (LIST '(MTIMES SIMP)
			 (LIST '(MEXPT SIMP) (CADAR R) -1.)
			 (CONS '($MATRIX SIMP) (CDR R))))
	     (*TMREARRAY 'A2)
	     (RETURN R))) 

(DEFUN *TMREARRAY (X) (*REARRAY X)) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			       
;;THIS IS A UTILITY PACKAGE FOR SPARSE
;;MATRIX INVERSION. A3 IS A N*N MATRIX.
;;IT RETURNS A LIST OF LISTS, SUCH AS
;;((I1 I2 ...) (J1 J2...) ...) WHERE (I1
;;I2 ..) SHOWS THE ROWS WHICH BELONGS TO
;;THE FIRST BLOCK, AND SO ON.  THE ROWS
;;SHOUD BE REORDERED IN THIS ORDER. THE
;;COLUMNS ARE NOT CHANGED. IT RETURNS NIL
;;IF A3 IS "OBVIOUSLY" SINGULAR.

;; (DEFUN TMISOLATE (A3 N)
;;        (PROG (NODELIST)
;; 	     (SETQ A3 (GET A3 'ARRAY))
;; 	     (ARRAY B T (1+ N) (1+ N))
;; 	     (ARRAY ROW T (1+ N))
;; 	     (ARRAY COL T (1+ N))
;; 	     (DO ((I 1. (1+ I)))
;; 		 ((> I N))
;; 		 (STORE (ROW I) I)
;; 		 (STORE (COL I) I))
;; 	     (DO ((I 1. (1+ I)))
;; 		 ((> I N))
;; 		 (DO ((J 1. (1+ J)))
;; 		     ((> J N))
;; 		     (STORE (B I J)
;; 			    (NOT (EQUAL (ARRAYCALL T A3 I J)
;; 					'(0. . 1.))))))
;; 	     (COND ((NULL (TMPIVOT-ISOLATE 1.))
;; 		    (SETQ NODELIST NIL)
;; 		    (GO EXIT)))
;; 	     (DO ((I 1. (1+ I)))
;; 		 ((> I N))
;; 		 (DO ((J 1. (1+ J)))
;; 		     ((> J I))
;; 		     (STORE (B (ROW J) (COL I))
;; 			    (OR (B (ROW I) (COL J))
;; 				(B (ROW J) (COL I))))
;; 		     (STORE (B (ROW I) (COL J)) (B (ROW J) (COL I))))
;; 		 (STORE (B (ROW I) (COL I)) T))
;; 	     (DO ((I 1. (1+ I)))
;; 		 ((> I N))
;; 		 (COND ((EQ (B (ROW I) (COL I)) T)
;; 			(SETQ NODELIST
;; 			      (CONS (TMPULL-OVER I N) NODELIST)))))
;; 	     EXIT
;; 	     (*TMREARRAY 'B)
;; 	     (*TMREARRAY 'ROW)
;; 	     (*TMREARRAY 'COL)
;; 	     (RETURN (REVERSE NODELIST))))) 

;; (DEFUN TMPULL-OVER (P N) 
;;        (PROG (Q) 
;; 	     (STORE (B (ROW P) (COL P)) NIL)
;; 	     (DO ((J 1. (1+ J)))
;; 		 ((> J N) (SETQ Q NIL))
;; 		 (COND ((EQ (B (ROW P) (COL J)) T)
;; 			(RETURN (SETQ Q J)))))
;; 	     (COND ((NULL Q) (RETURN (LIST (ROW P))))
;; 		   (T (DO ((J 1. (1+ J)))
;; 			  ((> J N))
;; 			  (STORE (B (ROW Q) (COL J))
;; 				 (OR (B (ROW Q) (COL J))
;; 				     (B (ROW P) (COL J))))
;; 			  (STORE (B (ROW J) (COL Q))
;; 				 (B (ROW Q) (COL J))))
;; 		      (TMCRIP P)
;; 		      (RETURN (CONS (ROW P) (TMPULL-OVER Q N))))))) 

;; (DEFUN TMCRIP (P) 
;;        (DO ((I 1. (1+ I)))
;; 	   ((> I N))
;; 	   (STORE (B (ROW P) (COL I)) NIL)
;; 	   (STORE (B (ROW I) (COL P)) NIL)))		

;;TMPIVOT-ISOLATE CARRIES OUT PIVOTTING
;;SO THAT THE ALL DIAGONAL ELEMENTS ARE
;;NONZERO. THIS GARANTIES WE HAVE MAXIMUM
;;NUMBER OF BLOCKS ISOLATED.

(DEFUN TMPIVOT-ISOLATE (K) 
       (COND ((> K N) T)
	     (T (DO ((I K (1+ I)))
		    ((> I N) NIL)
		    (COND ((B (ROW I) (COL K))
			   (TMEXCHANGE 'ROW K I)
			   (COND ((TMPIVOT-ISOLATE (1+ K)) (RETURN T))
				 (T (TMEXCHANGE 'ROW
						K
						I))))))))) 

(DEFUN TMEXCHANGE (ROWCOL I J) 
       (PROG (DUMMY) 
	     (SETQ ROWCOL (GET ROWCOL 'ARRAY))
	     (SETQ DUMMY (ARRAYCALL T ROWCOL I))
	     (STORE (ARRAYCALL T ROWCOL I) (ARRAYCALL T ROWCOL J))
	     (STORE (ARRAYCALL T ROWCOL J) DUMMY)))	


;; PROGRAM TO PREDICT ZERO ELEMENTS IN
;; THE SOLUTION OF INVERSE OR LINEAR
;; EQUATION. A IS THE COEFFICIENT MATRIX.
;; B IS THE RIGHT HAND SIDE MATRIX FOR
;; LINEAR EQUATIONS. A3 IS N*N AND B IS
;; M*M. X IS AN N*M MATRIX WHERE T -NIL
;; PATTERN SHOWING THE ZERO ELEMENTS IN
;; THE RESULT IS RETURND. T CORRESPONDS TO
;; NON-ZERO ELEMENT. IN THE CASE OF
;; INVERSE, YOU CAN PUT ANYTHING (SAY,NIL)
;; FOR B AND 0 FOR M.  NORMALLY IT RETURNS
;; T, BUT IN CASE OF SINGULAR MATRIX, IT
;; RETURNS NIL.

;; (DEFUN TMPREDICT (A3 B X N M)
;;   (PROG (FLAGINV FLAG-NONSINGULAR)
;; 	(SETQ A3 (GET A3 'ARRAY) B (GET B 'ARRAY) X (GET X 'ARRAY))
;; 	(ARRAY AA T (1+ N) (1+ N))
;; 	(ARRAY ROW T (1+ N))
;; 	(SETQ FLAGINV (= M 0.))
;; 	(COND (FLAGINV (SETQ M N)))
;; 	(DO ((I 1. (1+ I)))
;; 	    ((> I N))
;; 	    (DO ((J 1. (1+ J)))
;; 		((> J N))
;; 		(STORE (AA I J)
;; 		       (NOT (EQUAL (ARRAYCALL T A3 I J) '(0. . 1.))))))
;; 	(DO ((I 1. (1+ I)))
;; 	    ((> I N))
;; 	    (DO ((J 1. (1+ J)))
;; 		((> J M))
;; 		(STORE (ARRAYCALL T X I J)
;; 		       (COND (FLAGINV (EQ I J))
;; 			     (T (EQUAL (ARRAYCALL T B I J)
;; 				       '(0. . 1.)))))))
;; 	(DO ((I 1. (1+ I))) ((> I N)) (STORE (ROW I) I))
;; 		;FORWARD ELIMINATION.
;; 	(DO ((I 1. (1+ I)))
;; 	    ((> I N))
;; 	    (SETQ FLAG-NONSINGULAR
;; 		  (DO ((II I (1+ II)))
;; 		      ((> II N) NIL)
;; 		      (COND ((AA (ROW II) I)
;; 			     (TMEXCHANGE 'ROW II I)
;; 			     (RETURN T)))))
;; 	    (COND ((NULL FLAG-NONSINGULAR) (RETURN NIL)))
;; 	    (DO ((II (1+ I) (1+ II)))
;; 		((> II N))
;; 		(COND ((AA (ROW II) I)
;; 		       (DO ((JJ (1+ I) (1+ JJ)))
;; 			   ((> JJ N))
;; 			   (STORE (AA (ROW II) JJ)
;; 				  (OR (AA (ROW I) JJ)
;; 				      (AA (ROW II) JJ))))
;; 		       (DO ((JJ 1. (1+ JJ)))
;; 			   ((> JJ M))
;; 			   (STORE (ARRAYCALL T X (ROW II) JJ)
;; 				  (OR (ARRAYCALL T X (ROW I) JJ)
;; 				      (ARRAYCALL T X (ROW II) JJ))))))))
;; 	(COND ((NULL FLAG-NONSINGULAR) (GO EXIT)))       ;GET OUT  BACKWARD SUBSTITUTION
;; 	(DO ((I (1- N) (1- I)))
;; 	    ((< I 1.))
;; 	    (DO ((L 1. (1+ L)))
;; 		((> L M))
;; 		(STORE (ARRAYCALL T X (ROW I) L)
;; 		       (OR (ARRAYCALL T X (ROW I) L)
;; 			   (DO ((J (1+ I) (1+ J)) (SUM))
;; 			       ((> J N) SUM)
;; 			       (SETQ SUM
;; 				     (OR SUM
;; 					 (AND (AA (ROW I) J)
;; 					      (ARRAYCALL T
;; 							 X
;; 							 (ROW J)
;; 							 L)))))))))
;; 	       ;RECOVER THE ORDER.
;; 	(TMPERMUTE 'X N M 0. 0. 'ROW N 'ROW)
;;    EXIT (*TMREARRAY 'ROW) (*TMREARRAY 'AA) (RETURN FLAG-NONSINGULAR)))

;TMPERMUTE PERMUTES THE ROWS OR COLUMNS
;OF THE N*M MATRIX AX ACCORDING TO THE
;SPECIFICATION OF INDEXLIST. THE FLAG
;MUST BE SET 'ROW IF ROW PERMUTATION IS
;DESIRED , OR 'COL OTHERWISE. THE RESULT
;IS IN AX. NM IS THE DIMENSION OF
;INDEXLIST.

(DEFUN TMPERMUTE (AX N M RBIAS CBIAS INDEXLIST NM FLAG) 
       (PROG (K L) 
	     (SETQ AX (GET AX 'ARRAY) 
		   INDEXLIST (GET INDEXLIST 'ARRAY))
	     (ARRAY INDX T (1+ NM))
	     (DO ((I 1. (1+ I)))
		 ((> I NM))
		 (STORE (INDX I) (ARRAYCALL T INDEXLIST I)))
	     (DO ((I 1. (1+ I)))
		 ((> I NM))
		 (COND ((NOT (= (INDX I) I))
			(PROG NIL 
			      (TMMOVE AX N M RBIAS CBIAS I 0. FLAG)
			      (SETQ L I)
			 LOOP (SETQ K (INDX L))
			      (STORE (INDX L) L)
			      (COND ((= K I)
				     (TMMOVE AX
					     N
					     M
					     RBIAS
					     CBIAS
					     0.
					     L
					     FLAG))
				    (T (TMMOVE AX
					       N
					       M
					       RBIAS
					       CBIAS
					       K
					       L
					       FLAG)
				       (SETQ L K)
				       (GO LOOP)))))))
	     (*TMREARRAY 'INDX))) 

(DEFUN TMMOVE (AX N M RBIAS CBIAS I J FLAG) 
       (PROG (LL) 
	     (SETQ LL (COND ((EQ FLAG 'ROW) (- M CBIAS))
			    (T (- N RBIAS))))
	     (DO ((K 1. (1+ K)))
		 ((> K LL))
		 (COND ((EQ FLAG 'ROW)
			(STORE (ARRAYCALL T
					  AX
					  (+ RBIAS J)
					  (+ CBIAS K))
			       (ARRAYCALL T
					  AX
					  (+ RBIAS I)
					  (+ CBIAS K))))
		       (T (STORE (ARRAYCALL T
					    AX
					    (+ RBIAS K)
					    (+ CBIAS J))
				 (ARRAYCALL T
					    AX
					    (+ RBIAS K)
					    (+ CBIAS I))))))))

;TMSYMETRICP CHECKS THE SYMETRY OF THE MATRIX.

(DEFUN TMSYMETRICP
       (A3 N)
       (SETQ A3 (GET A3 'ARRAY))
       (DO ((I 1. (1+ I)))
	   ((> I N) T)
	   (COND ((NULL (DO ((J (1+ I) (1+ J)))
			    ((> J N) T)
			    (COND ((NOT (EQUAL (ARRAYCALL T
							  A3
							  I
							  J)
					       (ARRAYCALL T
							  A3
							  J
							  I)))
				   (RETURN NIL)))))
		  (RETURN NIL)))))

;TMLATTICE CHECKS THE "LATTICE"
;STRUCTURE OF THE MATRIX A. IT RETURNS
;NIL IF THE MATRIX IS "OBVIOUSLY"
;SINGULAR. OTHERWISE IT RETURNS A LIST
;(L1 L2 ... LM) WHERE M IS THE NUMBER OF
;BLOCKS (STRONGLY CONNECTED SUBGRAPHS),
;AND L1 L2 ... ARE LIST OF ROW AND
;COLUMN NUBERS WHICH BELONG TO EACH
;BLOCKS. THE LIST LOOKS LIKE ((R1 C1)
;(R2 C2) ...) WHERE R R'S ARE ROWS AND
;C'S ARE COLUMMS.

(DEFUN TMLATTICE (A3 XROW XCOL N) 
       (PROG (RES) 
	     (SETQ A3 (GET A3 'ARRAY) 
		   XROW (GET XROW 'ARRAY) 
		   XCOL (GET XCOL 'ARRAY))
	     (ARRAY B T (1+ N) (1+ N))
	     (ARRAY ROW T (1+ N))
	     (ARRAY COL T (1+ N))
	     (DO ((I 1. (1+ I)))
		 ((> I N))
		 (DO ((J 1. (1+ J)))
		     ((> J N))
		     (STORE (B I J)
			    (NOT (EQUAL (ARRAYCALL T A3 I J)
					'(0. . 1.))))))
	     (DO ((I 0. (1+ I)))
		 ((> I N))
		 (STORE (ROW I) I)
		 (STORE (COL I) I))
	     (COND ((NULL (TMPIVOT-ISOLATE 1.))
		    (SETQ RES NIL)
		    (GO EXIT)))
	     (DO ((I 1. (1+ I)))
		 ((> I N))
		 (STORE (B (ROW I) (COL I)) I)
		 (STORE (B (ROW I) (COL 0.)) T))
	     (TMLATTICE1 1.)
	     (SETQ RES (TMSORT-LATTICE XROW XCOL))
	EXIT (*TMREARRAY 'B)
	     (*TMREARRAY 'ROW)
	     (*TMREARRAY 'COL)
	     (RETURN RES))) 

(DEFUN TMLATTICE1 (K) 
       (COND ((= K N) NIL)
	     (T (TMLATTICE1 (1+ K))
		(DO ((LOOPPATH))
		    (NIL)
		    (COND ((SETQ LOOPPATH (TMPATHP K K))
			   (TMUNIFY-LOOP K (CDR LOOPPATH)))
			  (T (RETURN NIL))))))) 

(DEFUN TMPATHP (J K) 
       (COND ((EQUAL (B (ROW J) (COL K)) T) (LIST J K))
	     (T (DO ((JJ K (1+ JJ)) (PATH))
		    ((> JJ N))
		    (COND ((AND (EQUAL (B (ROW J) (COL JJ)) T)
				(SETQ PATH (TMPATHP JJ K)))
			   (RETURN (CONS J PATH)))))))) 

(DEFUN TMUNIFY-LOOP (K CHAIN) 
       (PROG (L DUMMYK DUMMYL) 
	     (SETQ L (CAR CHAIN))
	     (COND ((= L K) (RETURN NIL)))
	     (SETQ DUMMYK (B (ROW K) (COL K)))
	     (SETQ DUMMYL (B (ROW L) (COL L)))
	     (STORE (B (ROW K) (COL K)) NIL)
	     (STORE (B (ROW L) (COL L)) NIL)
	     (DO ((I 1. (1+ I)))
		 ((> I N))
		 (STORE (B (ROW K) (COL I))
			(OR (B (ROW K) (COL I)) (B (ROW L) (COL I))))
		 (STORE (B (ROW I) (COL K))
			(OR (B (ROW I) (COL K)) (B (ROW I) (COL L))))
		 (STORE (B (ROW L) (COL I)) NIL)
		 (STORE (B (ROW I) (COL L)) NIL))
	     (STORE (B (ROW K) (COL K)) DUMMYL)
	     (STORE (B (ROW L) (COL L)) DUMMYK)
	     (STORE (B (ROW K) (COL 0.)) T)
	     (STORE (B (ROW L) (COL 0.)) NIL)
	     (TMUNIFY-LOOP K (CDR CHAIN)))) 

(DEFUN TMSORT-LATTICE (XROW XCOL) 
       (PROG (NODELIST RESULT) 
	     (SETQ NODELIST (TMSORT1))
	     (SETQ 
	      RESULT
	      (DO ((X NODELIST (CDR X)) (RESULT))
		  ((NULL X) RESULT)
		  (SETQ RESULT
			(CONS (DO ((NEXT (B (ROW (CAR X))
					    (COL (CAR X)))
					 (B (ROW NEXT) (COL NEXT)))
				   (RES))
				  ((= NEXT (CAR X))
				   (CONS (LIST (ROW NEXT) (COL NEXT))
					 RES))
				  (SETQ RES
					(CONS (LIST (ROW NEXT)
						    (COL NEXT))
					      RES)))
			      RESULT))))
	     (DO ((LIST1 RESULT (CDR LIST1)) (I 1.))
		 ((NULL LIST1))
		 (DO ((LIST2 (CAR LIST1) (CDR LIST2)))
		     ((NULL LIST2))
		     (STORE (ARRAYCALL T XROW I) (CAAR LIST2))
		     (STORE (ARRAYCALL T XCOL I) (CADAR LIST2))
		     (SETQ I (1+ I))))
	     (RETURN RESULT))) 

;; (DEFUN TMLESS (I J) (B (ROW I) (COL J))) 

(DEFUN TMSORT1 NIL 
       (DO ((I 1. (1+ I)) (RESULT))
	   ((> I N) RESULT)
	   (COND ((AND (B (ROW I) (COL 0.)) (TMMAXP I))
		  (DO ((J 1. (1+ J)))
		      ((> J N))
		      (COND ((NOT (= J I))
			     (STORE (B (ROW I) (COL J)) NIL))))
		  (STORE (B (ROW I) (COL 0.)) NIL)
		  (SETQ RESULT (CONS I RESULT))
		  (SETQ I 0.))))) 

(DEFUN TMMAXP (I) 
       (DO ((J 1. (1+ J)))
	   ((> J N) T)
	   (COND ((AND (NOT (= I J)) (B (ROW J) (COL I)))
		  (RETURN NIL)))))

;;UNPIVOT IS USED IN PAUL WANG'S PROGRAM
;;TO RECOVER THE PIVOTTING. TO GET THE
;;INVERSE OF A, PAUL'S PROGRAM COMPUTES
;;THE INVERSE OF U*A*V BECAUSE OF
;;BLOCKING. LET THE INVERSE Y. THEN
;;A^^-1=V*Y*U. WHERE U AND V ARE
;;FUNDAMENTAL TRANSFORMATION
;;(PERMUTATION). UNPIVOT DOES THIS,
;;NAMELY, GIVEN A MATRIX A3, INDEX ROW
;;AND COL ,WHICH CORRESPONDS TO THE Y , U
;; AND V, RESPECTIVELY, IT COMPUTES V*Y*U
;;AND RETURNS IT TO THE SAME ARGUMENT A.

(DEFUN TMUNPIVOT (A3 ROW COL N M) 
       (PROG NIL 
	     (SETQ ROW (GET ROW 'ARRAY) 
		   COL (GET COL 'ARRAY))
	     (ARRAY ROWINV T (1+ N))
	     (ARRAY COLINV T (1+ N))
	     (DO ((I 1. (1+ I)))
		 ((> I N))
		 (STORE (ROWINV (ARRAYCALL T ROW I)) I))
	     (DO ((I 1. (1+ I)))
		 ((> I N))
		 (STORE (COLINV (ARRAYCALL T COL I)) I))
	     (TMPERMUTE A3 N M 0. N 'COLINV N 'ROW)
	     (TMPERMUTE A3 N M 0. N 'ROWINV N 'COL)
	     (*TMREARRAY 'ROWINV)
	     (*TMREARRAY 'COLINV))) 

(DECLARE (UNSPECIAL N VLIST N NX IX))

