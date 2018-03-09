;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module runtim)

;; This file contains functions which are also defined as macros in the
;; standard Macsyma environment.  They are defined here for the benefit
;; interpreted code in the fix file.  This file is used only in the ITS
;; implementation, as the Macsyma macros are present at runtime in large
;; address space systems.

;; The above comment is idiotic. These functions are open-codeable,
;; and defined as macros only for efficiency. However, the correct
;; way to hack efficiency is through compiler:optimizers, which is
;; what we use now. This file is no longer its-only.

;; Defined in LIBMAX;MAXMAC.

;(DEFUN COPY (L) (SUBST NIL NIL L))  
;(DEFUN COPY1 (X) (APPEND X NIL))

;; Defined in RAT;RATMAC.

;(DEFUN EQN (X Y) (EQUAL X Y))
;(DEFUN PCOEFP (X) (ATOM X))
;(DEFUN PZEROP (L) (SIGNP E L))
;(DEFUN RCINV (X) (RATINVERT X))

;; Defined in RAT;LESFAC.

;(DEFUN GETDIS (X) (GET X 'DISREP))
;(DEFUN CONS1 (X) (CONS X 1))

;; Defined in LIBMAX;MAXMAC.

;(DEFPROP ERLIST ERLIST1 EXPR)

;; Subr definitions of ADD* and MUL* needed at runtime for functions generated
;; by TRANSL.  If a function is defined as both a macro and a function, the
;; compiler expands the macro, but still puts the function definitions in the
;; fasl.  We don't need these on the Lisp Machine or Multics since macros are
;; around at run time. 

;; ADD and MUL to be flushed shortly.  Around for compatibility only.
;; (another CWH comment????) -gjc

#+PDP10
(PROGN 'COMPILE
       (DEFUN ADD (&REST L) (SIMPLIFYA (CONS '(MPLUS) L) t))
       (DEFUN MUL (&REST L) (SIMPLIFYA (CONS '(MTIMES) L) t))
       (DEFUN ADD* (&REST L) (SIMPLIFYA (CONS '(MPLUS) L) nil))
       (DEFUN MUL* (&REST L) (SIMPLIFYA (CONS '(MTIMES) L) nil)))

#+NIL
(PROGN 'COMPILE
       (DEFUN ADD (&RESTL L) (SIMPLIFYA (CONS '(MPLUS) L) t))
       (DEFUN MUL (&RESTL L) (SIMPLIFYA (CONS '(MTIMES) L) t))
       (DEFUN ADD* (&RESTL L) (SIMPLIFYA (CONS '(MPLUS) L) nil))
       (DEFUN MUL* (&RESTL L) (SIMPLIFYA (CONS '(MTIMES) L) nil))

(DEFUN SETF-MGET (A B VALUE) (MPUTPROP A VALUE B))

(DEFUN SETF-$GET (A B VALUE) ($PUT A VALUE B))
)

#+LISPM
(PROGN 'COMPILE

;; on the LISPM the &REST list is a stack-allocated cdr-coded list.
;; We have to copy it, so might as well try out some optimizations.

(DEFUN ADD (&REST V)
  (DO ((L NIL)(R)
	      (ACC 0))
      ((NULL V)
       (IF (NULL L)
	   ACC
	   (IF (ZEROP ACC)
	       (SIMPLIFYA (CONS '(MPLUS) L) T)
	       (SIMPLIFYA (LIST* '(MPLUS) ACC L) T))))
    (SETQ R (POP V))
    (IF (NUMBERP R)
	(SETQ ACC (PLUS R ACC))
	(PUSH R L))))

(DEFUN MUL (&REST V)
  (DO ((L NIL)(R)
	      (ACC 1))
      ((NULL V)
       (IF (NULL L)
	   ACC
	   (IF (EQUAL ACC 1)
	       (SIMPLIFYA (CONS '(MTIMES) L) T)
	       (SIMPLIFYA (LIST* '(MTIMES) ACC L) T))))
    (SETQ R (POP V))
    (IF (NUMBERP R)
	(SETQ ACC (TIMES R ACC))
	(PUSH R L))))

(DEFUN ADD* (&REST L) (SIMPLIFYA (CONS '(MPLUS) (copylist L)) nil))
(DEFUN MUL* (&REST L) (SIMPLIFYA (CONS '(MTIMES)(copylist L)) nil))

)