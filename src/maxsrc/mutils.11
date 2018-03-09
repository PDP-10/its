;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module mutils)

;;; General purpose Macsyma utilities.  This file contains runtime functions 
;;; which perform operations on Macsyma functions or data, but which are
;;; too general for placement in a particular file.
;;;
;;; Every function in this file is known about externally.



;;; (ASSOL item A-list)
;;;
;;;  Like ASSOC, but uses ALIKE1 as the comparison predicate rather
;;;  than EQUAL.
;;;
;;;  Meta-Synonym:	(ASS #'ALIKE1 ITEM ALIST)

(DEFMFUN ASSOL (ITEM ALIST)
  (DOLIST (PAIR ALIST)
	  (IF (ALIKE1 ITEM (CAR PAIR)) (RETURN PAIR))))
;;; 

(DEFMFUN ASSOLIKE (ITEM ALIST) 
  (CDR (ASSOL ITEM ALIST)))

; Old ASSOLIKE definition:
;
; (defun assolike (e l) 
;	 (prog nil 
;	  loop (cond ((null l) (return nil))
;		     ((alike1 e (caar l)) (return (cdar l))))
;	       (setq l (cdr l))
;	       (go loop)))

;;; (MEM #'ALIKE1 X L)

(DEFMFUN MEMALIKE (X L)
  (DO L L (CDR L) (NULL L)
      (COND ((ALIKE1 X (CAR L)) (RETURN L)))))

;;;Do we want MACROS for these on MC and on Multics?? -Jim 1/29/81
#+Multics
(PROGN 'COMPILE
  (DEFMFUN MSTRINGP (X)
    (AND (SYMBOLP X)
	 (EQUAL (GETCHARN X 1) #/&)))

  (DEFMFUN MSTRING-TO-STRING (X)
    (SUBSTRING (STRING X) 1))

  (DEFMFUN STRING-TO-MSTRING (X)
    (MAKE-SYMBOL (STRING-APPEND "&" X)))
)
