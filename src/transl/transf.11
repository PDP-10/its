;;; -*- Mode: Lisp; Package: Macsyma -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;       (c) Copyright 1980 Massachusetts Institute of Technology       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; TRANSLATION PROPERTIES FOR MACSYMA OPERATORS AND FUNCTIONS.

;;; This file is for list and array manipulation optimizations.

(macsyma-module transf)


(TRANSL-MODULE TRANSF)

;;; some floating point translations. with tricks.

(DEF%TR %LOG (FORM) 
  (LET   (ARG)
    (SETQ ARG (TRANSLATE (CADR FORM)))
    (COND ((AND (EQ (CAR ARG) '$FLOAT) (GET (CAAR FORM) 'LISP-FUNCTION-TO-USE))
	   `($FLOAT ,(GET (CAAR FORM) 'LISP-FUNCTION-TO-USE) ,(CDR ARG)))
	  (T `($ANY SIMPLIFY (LIST ',(LIST (CAAR FORM)) ,(CDR ARG)))))))

(DEF-SAME%TR %SIN %LOG)
(DEF-SAME%TR %COS %LOG)
(DEF-SAME%TR %TAN %LOG)
(DEF-SAME%TR %COT %LOG)
(DEF-SAME%TR %CSC %LOG)
(DEF-SAME%TR %SEC %LOG)
(DEF-SAME%TR %ACOT %LOG)
(DEF-SAME%TR %SINH %LOG)
(DEF-SAME%TR %COSH %LOG)
(DEF-SAME%TR %TANH %LOG)
(DEF-SAME%TR %COTH %LOG)
(DEF-SAME%TR %CSCH %LOG)
(DEF-SAME%TR %SECH %LOG)
(DEF-SAME%TR %ASINH %LOG)
(DEF-SAME%TR %ACSCH %LOG)
(DEF-SAME%TR %ERF %LOG)

(comment not used
; defsubr1 is also obsolete. see DEF-PROCEDURE-PROPERTY.
(DEFsubr1 TRANSLATE-$NUMBER (FORM) 
  (LET   (ARG)
    (SETQ ARG (TRANSLATE (CADR FORM)))
    (IF (AND (COVERS '$NUMBER (CAR ARG)) (GET (CAAR FORM) 'LISP-FUNCTION-TO-USE))
	(LIST (CAR ARG) (GET (CAAR FORM) 'LISP-FUNCTION-TO-USE) (CDR ARG))
	(CONS (CAR ARG) `(SIMPLIFY (LIST ',(LIST (CAAR FORM)) ,(CDR ARG))))))))


(DEFMVAR $TR_FLOAT_CAN_BRANCH_COMPLEX T
	 "States wether the arc functions might return complex
	 results. The arc functions are SQRT,LOG,ACOS, etc.
	 e.g. When it is TRUE then ACOS(X) will be of mode ANY even if X is
	 of mode FLOAT. When FALSE then ACOS(X) will be of mode FLOAT
	 if and only if X is of mode FLOAT.")

(def%TR %ACOS (form)
  (LET ((arg (translate (cadr form))))
    (cond ((and (eq (car arg) '$float)
		(get (caar form) 'lisp-function-to-use))
	   `(,(cond ($TR_FLOAT_CAN_BRANCH_COMPLEX
		     '$ANY)
		    (T '$FLOAT))
	     . (,(GET (CAAR FORM) 'LISP-FUNCTION-TO-USE)
		,(CDR ARG))))
	  (T
	   `($ANY . (SIMPLIFY (LIST '(,(CAAR FORM)) ,(CDR ARG))))))))

(DEF-SAME%TR %ASIN %ACOS)
(DEF-SAME%TR %ASEC %ACOS)
(DEF-SAME%TR %ASEC %ACOS)
(DEF-SAME%TR %ACSC %ACOS)
