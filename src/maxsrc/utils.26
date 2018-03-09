;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module utils)

;;; General purpose Lisp utilities.  This file contains runtime functions which
;;; are simple extensions to Lisp.  The functions here are not very general, 
;;; but generalized forms would be useful in future Lisp implementations.
;;;
;;; No knowledge of the Macsyma system is kept here.  
;;;
;;; Every function in this file is known about externally.



;;; N.B. this function is different than the lisp machine
;;; and maclisp standard one. (for now).

;;; temporary until the new lispm make-list is installed

(DEFMFUN *MAKE-LIST (SIZE &OPTIONAL (VAL NIL) )
	 (DO ((L NIL (CONS VAL L)))
	     ((< (SETQ SIZE (1- SIZE)) 0) L)))

;;; F is assumed to be a function of two arguments.  It is mapped down L
;;; and applied to consequtive pairs of elements of the list.
;;; Useful for iterating over property lists.

(DEFMFUN MAP2C (F L)
  (DO ((LLT L (CDDR LLT)) (LANS))
      ((NULL LLT) LANS)
      (SETQ LANS (CONS (FUNCALL F (CAR LLT) (CADR LLT)) LANS))))

;;; (ANDMAPC #'FIXP '(1 2 3)) --> T
;;; (ANDMAPC #'FIXP '(1 2 A)) --> NIL
;;; (ORMAPC  #'FIXP '(1 2 A)) --> T
;;; (ORMAPC  #'FIXP '(A B C)) --> NIL

;;; If you want the do loop generated inline rather than doing a function call,
;;; use the macros SOME and EVERY.  See LMLisp manual for more information.
;;; Note that the value returned by ORMAPC is slightly different from that
;;; returned by SOME.

(DEFMFUN ANDMAPC (F L)
  (DO ((L L (CDR L)))
      ((NULL L) T)
      (IF (NOT (FUNCALL F (CAR L))) (RETURN NIL))))

(DEFMFUN ORMAPC (F L &AUX ANSWER)
  (DO ((L L (CDR L)))
      ((NULL L) NIL)
      (SETQ ANSWER (FUNCALL F (CAR L)))
      (IF ANSWER (RETURN ANSWER))))

;;; Like MAPCAR, except if an application of F to any of the elements of L
;;; returns NIL, then the function returns NIL immediately.

(DEFMFUN ANDMAPCAR (F L &AUX D ANSWER)
  (DO ((L L (CDR L)))
      ((NULL L) (NREVERSE ANSWER))
      (SETQ D (FUNCALL F (CAR L)))
      (IF D (PUSH D ANSWER) (RETURN NIL))))

;;; Returns T if either A or B is NIL, but not both.

(DEFMFUN XOR (A B) (OR (AND (NOT A) B) (AND (NOT B) A)))
  
;;; A MEMQ which works at all levels of a piece of list structure.
;;;
;;; Note that (AMONG NIL '(A B C)) is T, however.  This could cause bugs.
;;; > This is false. (AMONG NIL anything) returns NIL always. -kmp

(DEFMFUN AMONG (X L) 
  (COND ((NULL L) NIL)
	((ATOM L) (EQ X L))
	(T (OR (AMONG X (CAR L)) (AMONG X (CDR L)))))) 

;;; Similar to AMONG, but takes a list of objects to look for.  If any
;;; are found in L, returns T.

(DEFMFUN AMONGL (X L) 
  (COND ((NULL L) NIL)
	((ATOM L) (MEMQ L X))
	(T (OR (AMONGL X (CAR L)) (AMONGL X (CDR L)))))) 

;;; (RECONC '(A B C) '(D E F)) --> (C B A D E F)
;;; Like NRECONC, but not destructive.
;;;
;;; Is this really faster than macroing into (NCONC (REVERSE L1) L2)?
;;; > Yes, it is. -kmp

(DEFMFUN RECONC (L1 L2)
  (DO () ((NULL L1) L2)
      (SETQ L2 (CONS (CAR L1) L2) L1 (CDR L1))))


;;; (FIRSTN 3 '(A B C D E)) --> (A B C)
;;;
;;; *NOTE* Given a negative first arg will work fine with this definition
;;;	   but on LispM where the operation is primitive and defined 
;;;	   differently, bad things will happen. Make SURE it gets a 
;;;	   non-negative arg! -kmp

#+(OR PDP10 Franz)
(DEFMFUN FIRSTN (N L)
  (LOOP FOR I FROM 1 TO N
	FOR X IN L
	COLLECT X))

;;; Reverse ASSQ -- like ASSQ but tries to find an element of the alist whose
;;; cdr (not car) is EQ to the object.  To be renamed to RASSQ in the near
;;; future.

(DEFMFUN ASSQR (OBJECT ALIST)
  (DOLIST (PAIR ALIST)
	  (IF (EQ OBJECT (CDR PAIR)) (RETURN PAIR))))

;;; Should be open-coded at some point.  (Moved here from RAT;FACTOR)
(DEFMFUN LOG2 (N) (1- (HAULONG N)))

;;; Tries to emulate Lispm/NIL FSET.  Won't work for LSUBRS, FEXPRS, or
;;; FSUBRS.

#+PDP10
(DEFMFUN FSET (SYMBOL DEFINITION)
  (COND ((SYMBOLP DEFINITION)
	 (PUTPROP SYMBOL DEFINITION 'EXPR))
	((EQ (TYPEP DEFINITION) 'RANDOM)
	 (PUTPROP SYMBOL DEFINITION 'SUBR))
	((LISTP DEFINITION)
	 (PUTPROP SYMBOL DEFINITION 'EXPR))
	(T (ERROR "Invalid symbol definition - FSET"
		  DEFINITION 'WRNG-TYPE-ARG))))

;;; Takes a list in "alist" form and converts it to one in
;;; "property list" form, i.e. ((A . B) (C . D)) --> (A B C D).
;;; All elements of the list better be conses.

(DEFMFUN DOT2L (L)
  (COND ((NULL L) NIL)
	(T (LIST* (CAAR L) (CDAR L) (DOT2L (CDR L))))))


;;; (A-ATOM sym selector value   )
;;; (C-PUT  sym value    selector)
;;;
;;;  They make a symbol's property list look like a structure.
;;;
;;;  If the value to be stored is NIL,
;;;     then flush the property.
;;;     else store the value under the appropriate property.
;;;
;;; >>> Note: Since they do essentially the same thing, one (A-ATOM)
;;; >>>       should eventually be flushed...

(DEFMFUN A-ATOM (BAS SEL VAL) (CPUT BAS VAL SEL))

(DEFMFUN CPUT (BAS VAL SEL)
  (COND ((NULL VAL) (REMPROP BAS SEL) NIL)
	(T (PUTPROP BAS VAL SEL))))

;;; This is like the function SYMBOLCONC except that it binds base and *nopoint

#-Franz
(DEFMFUN CONCAT N
 (LET ((BASE 10.) (*NOPOINT T)) (IMPLODE (MAPCAN 'EXPLODEN (LISTIFY N)))))


(DECLARE (SPECIAL ALPHABET)) ; This should be DEFVAR'd somewhere. Sigh. -kmp

(DEFMFUN ALPHABETP (N)
 (DECLARE (FIXNUM N))
 (OR (AND (>= N #/A) (<= N #/Z))  ; upper case
     (AND (>= N #/a) (<= N #/z))  ; lower case
     (MEMBER N ALPHABET)))	  ; test for %, _, or other declared
				  ;    alphabetic characters.

(DEFMFUN ASCII-NUMBERP (NUM)
  (DECLARE (FIXNUM NUM))
  (AND (<= NUM #/9) (>= NUM #/0)))

