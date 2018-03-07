;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module strmac macro)

;; Data Representation macros.

;; Hand coded macros for manipulating data structures in a simple
;; way, yet still preserving some abstraction.  Replacement for the mode
;; package.  We no longer know the type of things at run-time, so the names
;; of each macro must reflect the type of its operand, e.g.
;; RAT-NUMER versus MRAT-NUMER.

(DEFMACRO MAKE-G-REP (OPERATOR . OPERANDS)
  `(LIST (LIST ,OPERATOR) . ,OPERANDS))
(DEFMACRO MAKE-G-REP-SIMP (OPERATOR . OPERANDS)
  `(LIST (LIST ,OPERATOR) . ,OPERANDS))

(DEFMACRO G-REP-OPERATOR (EXP) `(CAAR ,EXP))
(DEFMACRO G-REP-OPERANDS (EXP) `(CDR ,EXP))
(DEFMACRO G-REP-FIRST-OPERAND (EXP)
   `(CADR ,EXP))

(DEFMACRO MAKE-MPLUS ARGS `(LIST '(MPLUS) . ,ARGS))
(DEFMACRO MAKE-MPLUS-L (LIST) `(CONS '(MPLUS) ,LIST))
(DEFMACRO MAKE-MPLUS-SIMP ARGS `(LIST '(MPLUS SIMP) . ,ARGS))
(DEFMACRO MAKE-MPLUS-SIMP-L (LIST) `(CONS '(MPLUS SIMP) ,LIST))

(DEFMACRO MAKE-MTIMES ARGS `(LIST '(MTIMES) . ,ARGS))
(DEFMACRO MAKE-MTIMES-L (LIST) `(CONS '(MTIMES) ,LIST))
(DEFMACRO MAKE-MTIMES-SIMP ARGS `(LIST '(MTIMES SIMP) . ,ARGS))
(DEFMACRO MAKE-MTIMES-SIMP-L (LIST) `(CONS '(MTIMES SIMP) ,LIST))

; losing MACLISP doesn't like BASE as a variable name !!
(DEFMACRO MAKE-MEXPT (thing-being-raised-to-power EXPT)
   `(LIST '(MEXPT) ,thing-being-raised-to-power ,EXPT))
(DEFMACRO MAKE-MEXPT-L (LIST) `(CONS '(MEXPT) ,LIST))
(DEFMACRO MAKE-MEXPT-SIMP (thing-being-raised-to-power EXPT)
   `(LIST '(MEXPT SIMP) ,thing-being-raised-to-power ,EXPT))
(DEFMACRO MAKE-MEXPT-SIMP-L (LIST) `(CONS '(MEXPT SIMP) ,LIST))

(DEFMACRO MEXPT-BASE (MEXPT) `(CADR ,MEXPT))
(DEFMACRO MEXPT-EXPT (MEXPT) `(CADDR ,MEXPT))

(DEFMACRO MAKE-MEQUAL (LHS RHS) `(LIST '(MEQUAL) ,LHS ,RHS))
(DEFMACRO MAKE-MEQUAL-L (LIST) `(CONS '(MEQUAL) ,LIST))
(DEFMACRO MAKE-MEQUAL-SIMP (LHS RHS) `(LIST '(MEQUAL SIMP) ,LHS ,RHS))
(DEFMACRO MAKE-MEQUAL-SIMP-L (LIST) `(CONS '(MEQUAL SIMP) ,LIST))

(DEFMACRO MEQUAL-LHS (MEQUAL) `(CADR ,MEQUAL))
(DEFMACRO MEQUAL-RHS (MEQUAL) `(CADDR ,MEQUAL))

(DEFMACRO MAKE-MLIST ARGS `(LIST '(MLIST) . ,ARGS))
(DEFMACRO MAKE-MLIST-L (LIST) `(CONS '(MLIST) ,LIST))
(DEFMACRO MAKE-MLIST-SIMP ARGS `(LIST '(MLIST SIMP) . ,ARGS))
(DEFMACRO MAKE-MLIST-SIMP-L (LIST) `(CONS '(MLIST SIMP) ,LIST))

(DEFMACRO MAKE-MTEXT ARGS `(LIST '(MTEXT) . ,ARGS))

(DEFMACRO MAKE-RAT ARGS `(LIST '(RAT) . ,ARGS))
(DEFMACRO MAKE-RAT-SIMP ARGS `(LIST '(RAT SIMP) . ,ARGS))
(DEFMACRO MAKE-RAT-BODY (NUMER DENOM) `(CONS ,NUMER ,DENOM))
(DEFMACRO RAT-NUMER (RAT) `(CADR ,RAT))
(DEFMACRO RAT-DENOM (RAT) `(CADDR ,RAT))

;; Schematic of MRAT form:
;;  ((MRAT SIMP <varlist> <genvars>) <numer> . <denom>)

;; Schematic of <numer> and <denom>:
;;  (<genvar> <exponent 1> <coefficient 1> ...)

;; Representation for X^2+1:
;;  ((MRAT SIMP ($X) (G0001)) (G0001 2 1 0 1) . 1)

;; Representation for X+Y:
;;  ((MRAT SIMP ($X $Y) (G0001 G0002)) (G0001 1 1 0 (G0002 1 1)) . 1)

(DEFMACRO MRAT-BODY  (MRAT) `(CDR ,MRAT))
(DEFMACRO MRAT-NUMER (MRAT) `(CADR ,MRAT))
(DEFMACRO MRAT-DENOM (MRAT) `(CDDR ,MRAT))

(DEFMACRO MAKE-MRAT (VARLIST GENVARS NUMER DENOM)
  `((MRAT ,VARLIST ,GENVARS) ,NUMER . ,DENOM))

(DEFMACRO MAKE-MRAT-BODY (NUMER DENOM) `(CONS ,NUMER ,DENOM))

;; Data structures used only in this file.

(DEFMACRO TRIG-CANNON (OPERATOR) `(GET ,OPERATOR 'TRIG-CANNON))

;; Linear equation -- cons of linear term and constant term.

(DEFMACRO MAKE-LINEQ (LINEAR CONSTANT) `(CONS ,LINEAR ,CONSTANT))
(DEFMACRO LINEQ-LINEAR   (LINEQ) `(CAR ,LINEQ))
(DEFMACRO LINEQ-CONSTANT (LINEQ) `(CDR ,LINEQ))

;; Solutions -- a pair of polynomial/multiplicity lists

(DEFMACRO MAKE-SOLUTION (WINS LOSSES) `(CONS ,WINS ,LOSSES))
(DEFMACRO SOLUTION-WINS   (SOLUTION) `(CAR ,SOLUTION))
(DEFMACRO SOLUTION-LOSSES (SOLUTION) `(CDR ,SOLUTION))

;; Polynomials -- these appear in the numerator or denominator
;; of MRAT forms.  This doesn't handle the case of a coefficient
;; polynomial.

(DEFMACRO MAKE-MRAT-POLY (VAR TERMS) `(CONS ,VAR ,TERMS))
(DEFMACRO POLY-VAR   (POLY) `(CAR ,POLY))
(DEFMACRO POLY-TERMS (POLY) `(CDR ,POLY))


