;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module mopers macro)
(load-macsyma-macros defopt)
(load-macsyma-macros-at-runtime 'defopt)

;; This file is the compile-time half of the OPERS package, an interface to the
;; Macsyma general representaton simplifier.  When new expressions are being
;; created, the macros in this file or the functions in NOPERS should be called
;; rather than the entrypoints in SIMP such as SIMPLIFYA or SIMPLUS.

;; The basic functions are ADD, SUB, MUL, DIV, POWER, NCMUL, NCPOWER, INV.
;; Each of these functions assume that their arguments are simplified.  Some
;; functions will have a "*" adjoined to the end of the name (as in ADD*).
;; These do not assume that their arguments are simplified.  The above
;; functions are the only entrypoints to this package.

;; The functions ADD2, MUL2, and MUL3 are for use internal to this package
;; and should not be called externally.

;; I have added the macro DEFGRAD as an interface to the $DERIVATIVE function
;; for use by macsyma programers who want to do a bit of lisp programming. -GJC

(defmacro =0 (x) `(equal ,x 0))
(defmacro =1 (x) `(equal ,x 1))

;; Addition -- call ADD with simplified operands; ADD* with unsimplified
;; operands.

(defopt add (&rest terms)
  (cond ((= (length terms) 2) `(add2 . ,terms))
	(t `(addn (list . ,terms) t))))

(defopt add* (&rest terms)
  (cond ((= (length terms) 2) `(add2* . ,terms))
	(t `(addn (list . ,terms) nil))))

;; Multiplication -- call MUL or NCMUL with simplified operands; MUL* or NCMUL*
;; with unsimplified operands.

(defopt mul (&rest factors)
  (cond ((= (length factors) 2) `(mul2 . ,factors))
	((= (length factors) 3) `(mul3 . ,factors))
	(t `(muln (list . ,factors) t))))

(defopt mul* (&rest factors)
  (cond ((= (length factors) 2) `(mul2* . ,factors))
	(t `(muln (list . ,factors) nil))))

;; the rest here can't be DEFOPT's because there aren't interpreted versions yet.

(defmacro inv (x) `(power ,x -1))
(defmacro inv* (x) `(power* ,x -1))

(defmacro ncmul (&rest factors)
	  (cond ((= (length factors) 2) `(ncmul2 . ,factors))
		(t `(ncmuln (list . ,factors) t))))

;; (TAKE '(%TAN) X) = tan(x)
;; This syntax really loses.  Not only does this syntax lose, but this macro
;; has to look like a subr.  Otherwise, the definition would look like
;; (DEFMACRO TAKE ((NIL (OPERATOR)) . ARGS) ...)

;; (TAKE A B) --> (SIMPLIFYA (LIST A B) T)
;; (TAKE '(%SIN) A) --> (SIMP-%SIN (LIST '(%SIN) A) 1 T)

(defmacro take (operator &rest args &aux simplifier)
	  (setq simplifier
		(and (not (atom operator))
		     (eq (car operator) 'quote)
		     (cdr (assq (caadr operator) '((%atan  . simp-%atan)
						   (%tan   . simp-%tan)
						   (%log   . simpln)
						   (mabs   . simpabs)
						   (%sin   . simp-%sin)
						   (%cos   . simp-%cos)
						   ($atan2 . simpatan2)
						   )))))
	  (cond (simplifier `(,simplifier (list ,operator . ,args) 1 t))
		(t `(simplifya (list ,operator . ,args) t))))

(defmacro min%i () ''((MTIMES SIMP) -1 $%I))			;-%I
(defmacro 1//2 () ''((RAT SIMP) 1 2))				;1/2
(defmacro half () ''((RAT SIMP) 1 2))			        ;1/2
(defmacro I//2 () ''((MTIMES SIMP) ((RAT SIMP) 1 2) $%I))	;%I/2

;; On PDP-10s, this is a function so as to save address space.  A one argument
;; call is shorter than a two argument call, and this function is called
;; several places.  In Franz, Multics, and the LISPM, this macros out on the
;; assumption that calls are more expensive than the additional memory.

#+(or Lispm Multics Franz)
(defopt simplify (x) `(simplifya ,x nil))


;; Multics Lisp is broken in that it doesn't grab the subr definition
;; when applying.  If the macro definition is there first, it tries that and
;; loses.
#+Multics (if (get 'simplify 'subr) (remprop 'simplify 'macro))

;; A hand-made DEFSTRUCT for dealing with the Macsyma MDO structure.
;; Used in GRAM, etc. for storing/retrieving from DO structures.

(DEFMACRO MAKE-MDO () '(LIST (LIST 'MDO) NIL NIL NIL NIL NIL NIL NIL))

(DEFMACRO MDO-OP (X)     `(CAR (CAR ,X)))

(DEFMACRO MDO-FOR (X)    `(CAR (CDR ,X)))
(DEFMACRO MDO-FROM (X)   `(CAR (CDDR ,X)))
(DEFMACRO MDO-STEP (X)   `(CAR (CDDDR ,X)))
(DEFMACRO MDO-NEXT (X)   `(CAR (CDDDDR ,X)))
(DEFMACRO MDO-THRU (X)   `(CAR (CDR (CDDDDR ,X))))
(DEFMACRO MDO-UNLESS (X) `(CAR (CDDR (CDDDDR ,X))))
(DEFMACRO MDO-BODY (X)	 `(CAR (CDDDR (CDDDDR ,X))))

(DEFMACRO DEFGRAD (NAME ARGUMENTS . BODY)
  `(DEFPROP ,NAME (,ARGUMENTS . ,BODY) GRAD))
