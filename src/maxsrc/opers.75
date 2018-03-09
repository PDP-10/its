;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module opers)

;; This file is the run-time half of the OPERS package, an interface to the
;; Macsyma general representation simplifier.  When new expressions are being
;; created, the functions in this file or the macros in MOPERS should be called
;; rather than the entrypoints in SIMP such as SIMPLIFYA or SIMPLUS.  Many of
;; the functions in this file will do a pre-simplification to prevent
;; unnecessary consing. [Of course, this is really the "wrong" thing, since
;; knowledge about 0 being the additive identity of the reals is now
;; kept in two different places.]

;; The basic functions in the virtual interface are ADD, SUB, MUL, DIV, POWER,
;; NCMUL, NCPOWER, NEG, INV.  Each of these functions assume that their
;; arguments are simplified.  Some functions will have a "*" adjoined to the
;; end of the name (as in ADD*).  These do not assume that their arguments are
;; simplified.  In addition, there are a few entrypoints such as ADDN, MULN
;; which take a list of terms as a first argument, and a simplification flag as
;; the second argument.  The above functions are the only entrypoints to this
;; package.

;; The functions ADD2, ADD2*, MUL2, MUL2*, and MUL3 are for use internal to
;; this package and should not be called externally.  Note that MOPERS is
;; needed to compile this file.

;; Addition primitives.

(defmfun add2 (x y)
  (cond ((=0 x) y)
	((=0 y) x)
	(t (simplifya `((mplus) ,x ,y) t))))

(defmfun add2* (x y)
  (cond ((=0 x) (simplifya y nil))
	((=0 y) (simplifya x nil))
	(t (simplifya `((mplus) ,x ,y) nil))))

;; The first two cases in this cond shouldn't be needed, but exist
;; for compatibility with the old OPERS package.  The old ADDLIS
;; deleted zeros ahead of time.  Is this worth it?

(defmfun addn (terms simp-flag)
  (cond ((null terms) 0)
	(t (simplifya `((mplus) . ,terms) simp-flag))))

(declare (special $negdistrib) (muzzled t))

(defmfun neg (x)
  (cond ((numberp x) (minus x))
	(t (let (($negdistrib t))
		(simplifya `((mtimes) -1 ,x) t)))))

(declare (muzzled nil))

(defmfun sub (x y)
  (cond ((=0 y) x)
	((=0 x) (neg y))
	(t (add x (neg y)))))

(defmfun sub* (x y)
  (add (simplifya x nil) (mul -1 (simplifya y nil))))

;; Multiplication primitives -- is it worthwhile to handle the 3-arg
;; case specially?  Don't simplify x*0 --> 0 since x could be non-scalar.

(defmfun mul2 (x y)
  (cond ((=1 x) y)
	((=1 y) x)
	(t (simplifya `((mtimes) ,x ,y) t))))

(defmfun mul2* (x y)
  (cond ((=1 x) (simplifya y nil))
	((=1 y) (simplifya x nil))
	(t (simplifya `((mtimes) ,x ,y) nil))))

(defmfun mul3 (x y z)
  (cond ((=1 x) (mul2 y z))
	((=1 y) (mul2 x z))
	((=1 z) (mul2 x y))
	(t (simplifya `((mtimes) ,x ,y ,z) t))))

;; The first two cases in this cond shouldn't be needed, but exist
;; for compatibility with the old OPERS package.  The old MULSLIS
;; deleted ones ahead of time.  Is this worth it?

(defmfun muln (factors simp-flag)
  (cond ((null factors) 1)
	((atom factors) factors)
	(t (simplifya `((mtimes) . ,factors) simp-flag))))

(defmfun div (x y) (if (=1 x) (inv y) (mul x (inv y))))

(defmfun div* (x y) (if (=1 x) (inv* y) (mul (simplifya x nil) (inv* y))))

(defmfun ncmul2 (x y) (simplifya `((mnctimes) ,x ,y) t))
(defmfun ncmuln (factors flag) (simplifya `((mnctimes) . ,factors) flag))

;; Exponentiation

;; Don't use BASE as a parameter name since it is special in MacLisp.

(defmfun power (*base power)
  (cond ((=1 power) *base)
	(t (simplifya `((mexpt) ,*base ,power) t))))

(defmfun power* (*base power)
  (cond ((=1 power) (simplifya *base nil))
	(t (simplifya `((mexpt) ,*base ,power) nil))))

(defmfun ncpower (x y)
  (cond ((=0 y) 1)
	((=1 y) x)
	(t (simplifya `((mncexpt) ,x ,y) t))))

;; [Add something for constructing equations here at some point.]

;; (ROOT X N) takes the Nth root of X.
;; Warning! Simplifier may give a complex expression back, starting from a
;; positive (evidently) real expression, viz. sqrt[(sinh-sin) / (sin-sinh)] or
;; something.

(defmfun root (x n)
  (cond ((=0 x) 0)
	((=1 x) 1)
	(t (simplifya `((mexpt) ,x ((rat) 1 ,n)) t))))

;; (Porm flag expr) is +expr if flag is true, and -expr
;; otherwise.  Morp is the opposite.  Names stand for "plus or minus"
;; and vice versa.

(defmfun porm (s x) (if s x (neg x)))
(defmfun morp (s x) (if s (neg x) x))

;; On PDP-10s, this is a function so as to save address space.  A one argument
;; call is shorter than a two argument call, and this function is called
;; several places.  In Franz, Multics, and the LISPM, this macros out on the
;; assumption that calls are more expensive than the additional memory.

(defmfun simplify (x) (simplifya x nil))
