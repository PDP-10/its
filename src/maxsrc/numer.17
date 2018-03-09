;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1982 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module numer)
(load-macsyma-macros numerm)

;;; Interface of lisp numerical routines to macsyma.
;;; 4:34pm  Thursday, 28 May 1981 - George Carrette.

(DEFMACRO COMPATIBLE-ARRAY-TYPE? (TYPE TYPE-LIST)
  #+MACLISP
  `(MEMQ ,TYPE ,TYPE-LIST)
  #+LISPM
  (PROGN TYPE-LIST
	 `(EQ ,TYPE 'ART-Q))
  )

(DEFMFUN GET-ARRAY (X &OPTIONAL (KINDS NIL) (/#-DIMS) &REST DIMENSIONS)
  "Get-Array is fairly general.
  Examples:
  (get-array ar '(flonum) 2 3 5) makes sure ar is a flonum array
  with 2 dimensions, of 3 and 5.
  (get-array ar '(fixnum) 1) gets a 1 dimensional fixnum array."
  (COND ((NULL KINDS)
	 (CASEQ (TYPEP X)
	   ((ARRAY) X)
	   ((SYMBOL)
	    (OR (GET X 'ARRAY)
		(AND (FBOUNDP X)
		     (EQ 'ARRAY (TYPEP (FSYMEVAL X)))
		     (FSYMEVAL X))
		(MERROR "Not a lisp array:~%~M" X)))
	   (T
	    (MERROR "Not a lisp array:~%~M" X))))
	((NULL /#-DIMS)
	 (LET ((A (GET-ARRAY X)))
	   (COND ((COMPATIBLE-ARRAY-TYPE? (ARRAY-TYPE A) KINDS) A)
		 (T
		  (MERROR "~:M is not an array of type: ~:M"
			  X
			  `((mlist) ,@kinds))))))
	((NULL DIMENSIONS)
	 (LET ((A (GET-ARRAY X KINDS)))
	   (COND ((= (ARRAY-/#-DIMS A) /#-DIMS) A)
		 (T
		  (MERROR "~:M does not have ~:M dimensions." X /#-DIMS)))))
	('ELSE
	 (LET ((A (GET-ARRAY X KINDS /#-DIMS)))
	   (DO ((J 1 (1+ J))
		(L DIMENSIONS (CDR L)))
	       ((NULL L)
		A)
	     (OR (OR (EQ (CAR L) '*)
		     (= (CAR L) (ARRAY-DIMENSION-N J A)))
		 (MERROR "~:M does not have dimension ~:M equal to ~:M"
			 X
			 J
			 (CAR L))))))))

(DECLARE (SPECIAL %E-VAL))

(DEFUN MTO-FLOAT (X)
  (FLOAT (IF (NUMBERP X)
	     X
	     (LET (($NUMER T) ($FLOAT T))
	       (RESIMPLIFY (SUBST %E-VAL '$%E X))))))

;;; Trampolines for calling with numerical efficiency.

(DEFVAR TRAMP$-ALIST ())

(DEFMACRO DEFTRAMP$ (NARGS)
  (LET ((TRAMP$ (SYMBOLCONC 'TRAMP NARGS '$))
	#+MACLISP
	(TRAMP$-S (SYMBOLCONC 'TRAMP NARGS '$-S))
	(TRAMP$-F (SYMBOLCONC 'TRAMP NARGS '$-F))
	(TRAMP$-M (SYMBOLCONC 'TRAMP NARGS '$-M))
	(L (MAKE-LIST NARGS)))
    (LET ((ARG-LIST (MAPCAR #'(LAMBDA (IGNORE)(GENSYM)) L))
	  #+MACLISP
	  (ARG-TYPE-LIST (MAPCAR #'(LAMBDA (IGNORE) 'FLONUM) L)))
    `(PROGN 'COMPILE
	    (PUSH '(,NARGS ,TRAMP$
		    #+MACLISP ,TRAMP$-S
		    ,TRAMP$-F ,TRAMP$-M)
		  TRAMP$-ALIST)
	    (DEFMVAR ,TRAMP$ "Contains the object to jump to if needed")
	    #+MACLISP
	    (DECLARE (FLONUM (,TRAMP$-S ,@ARG-TYPE-LIST)
			     (,TRAMP$-F ,@ARG-TYPE-LIST)
			     (,TRAMP$-M ,@ARG-TYPE-LIST)))
	    #+MACLISP
	    (DEFUN ,TRAMP$-S ,ARG-LIST
	      (FLOAT (SUBRCALL NIL ,TRAMP$ ,@ARG-LIST)))
	    (DEFUN ,TRAMP$-F ,ARG-LIST
	      (FLOAT (FUNCALL ,TRAMP$ ,@ARG-LIST)))
	    (DEFUN ,TRAMP$-M ,ARG-LIST
	      (FLOAT (MAPPLY ,TRAMP$ (LIST ,@ARG-LIST) ',TRAMP$)))))))

(DEFTRAMP$ 1)
(DEFTRAMP$ 2)
(DEFTRAMP$ 3)

(DEFMFUN MAKE-TRAMP$ (F N)
  (LET ((L (ASSOC N TRAMP$-ALIST)))
    (IF (NULL L)
	(MERROR "BUG: No trampoline of argument length ~M" N))
    (POP L)
    (LET ((TRAMP$ (POP L))
	  #+MACLISP
	  (TRAMP$-S (POP L))
	  (TRAMP$-F (POP L))
	  (TRAMP$-M (POP L)))
      (LET ((WHATNOT (FUNTYPEP F)))
	(CASEQ (CAR WHATNOT)
	  ((OPERATORS)
	   (SET TRAMP$ F)
	   (GETSUBR! TRAMP$-M))
   	  ((MEXPR)
	   (SET TRAMP$ (CADR WHATNOT))
	   (GETSUBR! TRAMP$-M))
	  #+MACLISP
	  ((SUBR)
	   (COND ((SHIT-EQ (CADR WHATNOT) (GETSUBR! TRAMP$-S))
		  ;; This depends on the fact that the lisp compiler
		  ;; always outputs the same first instruction for
		  ;; "flonum compiled" subrs.
		  (CADR WHATNOT))
		 ('ELSE
		  (SET TRAMP$ (CADR WHATNOT))
		  (GETSUBR! TRAMP$-S))))
	  ((EXPR LSUBR)
	   (SET TRAMP$ (CADR WHATNOT))
	   (GETSUBR! TRAMP$-F))
	  (T
	   (MERROR "Undefined or inscrutable function~%~M" F)))))))


(DEFUN GETSUBR! (X)
  (OR #+MACLISP(GET X 'SUBR)
      #+LISPM (AND (FBOUNDP X) (FSYMEVAL X))
      (GETSUBR! (ERROR "No subr property for it!" X 'WRNG-TYPE-ARG))))

(DEFUN FUNTYPEP (F)
  (COND ((SYMBOLP F)
	 (LET ((MPROPS (MGETL F '(MEXPR)))
	       (LPROPS #+MACLISP (GETL F '(SUBR LSUBR EXPR))
		       #+LISPM (AND (FBOUNDP F)
				    (LIST 'EXPR (FSYMEVAL F)))))
	   (OR (IF $TRANSRUN
		   (OR LPROPS MPROPS)
		   (OR MPROPS LPROPS))
	       (GETL F '(OPERATORS)))))
	((EQ (TYPEP F) 'LIST)
	 (LIST (IF (MEMQ (CAR F) '(FUNCTION LAMBDA NAMED-LAMBDA))
		   'EXPR
		   'MEXPR)
	       F))
	('ELSE
	 NIL)))

#+MACLISP
(DEFUN SHIT-EQ (X Y) (= (EXAMINE (MAKNUM X)) (EXAMINE (MAKNUM Y))))

;; For some purposes we need a more general trampoline mechanism,
;; not limited by the need to use a special variable and a
;; BIND-TRAMP$ mechanism.

;; For now, we just need the special cases F(X), and F(X,Y) for plotting,
;; and the hackish GAPPLY$-AR$ for systems of equations.

(DEFUN MAKE-GTRAMP$ (F NARGS)
  NARGS
  ;; for now, ignoring the number of arguments, but we really should
  ;; do this error checking.
  (LET ((K (FUNTYPEP F)))
    (CASEQ (CAR K)
      ((OPERATORS)
       (CONS 'OPERATORS F))
      #+MACLISP
      ((SUBR)
       (IF (SHIT-EQ (CADR K) (GETSUBR! 'TRAMP1$-S))
	   (CONS 'SUBR$ (CADR K))
	   (CONS 'SUBR (CADR K))))
      ((MEXPR EXPR LSUBR)
       (CONS (CAR K) (CADR K)))
      (T
       (MERROR "Undefined or inscrutable function~%~M" F)))))

(DEFUN GCALL1$ (F X)
  (CASEQ (CAR F)
    #+MACLISP
    ((SUBR$)
     (SUBRCALL FLONUM (CDR F) X))
    #+MACLISP
    ((SUBR)
     (FLOAT (SUBRCALL NIL (CDR F) X)))
    #+MACLISP
    ((LSUBR)
     (FLOAT (LSUBRCALL NIL (CDR F) X)))
    ((EXPR)
     (FLOAT (FUNCALL (CDR F) X)))
    ((MEXPR OPERATORS)
     (FLOAT (MAPPLY (CDR F) (LIST X) NIL)))
    (T
     (MERROR "BUG: GCALL1$"))))

(DEFUN GCALL2$ (F X Y)
  (CASEQ (CAR F)
    #+MACLISP
    ((SUBR$)
     (SUBRCALL FLONUM (CDR F) X Y))
    #+MACLISP
    ((SUBR)
     (FLOAT (SUBRCALL NIL (CDR F) X Y)))
    #+MACLISP
    ((LSUBR)
     (FLOAT (LSUBRCALL NIL (CDR F) X Y)))
    ((EXPR)
     (FLOAT (FUNCALL (CDR F) X Y)))
    ((MEXPR OPERATORS)
     (FLOAT (MAPPLY (CDR F) (LIST X Y) NIL)))
    (T
     (MERROR "BUG: GCALL2$"))))

(DEFUN AR$+AR$ (A$ B$ C$)
  (DO ((N (ARRAY-DIMENSION-N 1 A$))
       (J 0 (1+ J)))
      ((= J N))
    (DECLARE (FIXNUM N J))
    (SETF (AREF$ A$ J) (+$ (AREF$ B$ J) (AREF$ C$ J)))))

(DEFUN AR$*S (A$ B$ S)
  (DO ((N (ARRAY-DIMENSION-N 1 A$))
       (J 0 (1+ J)))
      ((= J N))
    (DECLARE (FIXNUM N J))
    (SETF (AREF$ A$ J) (*$ (AREF$ B$ J) S))))

(DEFUN AR$GCALL2$ (AR FL X Y)
  (DO ((J 0 (1+ J))
       (L FL (CDR L)))
      ((NULL L))
    (SETF (AREF$ AR J) (GCALL2$ (CAR L) X Y))))

(DEFUN MAKE-GTRAMP (F NARGS)
  NARGS
  ;; for now, ignoring the number of arguments, but we really should
  ;; do this error checking.
  (LET ((K (FUNTYPEP F)))
    (CASEQ (CAR K)
      ((OPERATORS)
       (CONS 'OPERATORS F))
      #+MACLISP
      ((SUBR)
       (CONS 'SUBR (CADR K)))
      ((MEXPR EXPR LSUBR)
       (CONS (CAR K) (CADR K)))
      (T
       (MERROR "Undefined or inscrutable function~%~M" F)))))

(DEFUN GCALL3 (F A1 A2 A3)
  (CASEQ (CAR F)
    #+MACLISP
    ((SUBR)
     (SUBRCALL T (CDR F) A1 A2 A3))
    #+MACLISP
    ((LSUBR)
     (LSUBRCALL T (CDR F) A1 A2 A3))
    ((EXPR)
     (FUNCALL (CDR F)  A1 A2 A3))
    ((MEXPR OPERATORS)
     (MAPPLY (CDR F) (LIST A1 A2 A3) 'GCALL3))
    (T
     (MERROR "BUG: GCALL3"))))
