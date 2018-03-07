;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module defopt macro)

;; For defining optimizers which run on various systems.
;; Q: What is an optimizer?
;; A: A transformation which takes place in the compiler.

;; ***==> Right now, DEFOPT is used just like you would a DEFMACRO <==***
;; (defopt <name> <arlist> <body-boo>)

;; PDP-10 Maclisp:
;; SOURCE-TRANS property is a list of functions (F[1] F[2] ... F[n]).
;; F[k] is funcalled on the <FORM>, it returns (VALUES <NEW-FORM> <FLAG>).
;; If <FLAG> = NIL then compiler procedes to F[k+1]
;; If <FLAG> = T then compiler calls starts again with F[1].

;; LispMachine Lisp:
;; COMPILER:OPTIMIZERS property is a list of functions as in PDP-10 Maclisp.
;; F[k] returns <NEW-FORM>. Stop condition is (EQ <FORM> <NEW-FORM>).

;; VAX NIL (with compiler "H"):
;; SOURCE-CODE-REWRITE property is a function, returns NIL if no rewrite,
;; else returns NCONS of result to recursively call compiler on.

;; Multics Maclisp:
;; ???
;; Franz Lisp:
;; ???

;; General note:
;; Having a list of optimizers with stop condition doesn't provide
;; any increase in power over having a single property. For example,
;; only two functions in LISPM lisp have more than one optimizer, and
;; no maclisp functions do. It just isn't very usefull or efficient
;; to use such a crude mechanism. What one really wants is to be able
;; to define a set of production rules in a simple pattern match
;; language. The optimizer for NTH is a case in point:
;; (NTH 0 X) => (CAR X)
;; (NTH 1 X) => (CADR X)
;; ...
;; This is defined on the LISPM as a single compiler:optimizers with
;; a hand-compiled pattern matcher.

#+LISPM
(progn 'compile
(defmacro defopt-internal (name . other)
  `(defun (,name opt) . ,other))
(defun opt-driver (form)
  (funcall (get (car form) 'opt) form))
(defmacro defopt (name . other)
  `(progn 'compile
	  ,(si:defmacro1 (cons name other) 'defopt-internal)
	  (defprop ,name (opt-driver) compiler:optimizers))))
#+PDP10
(progn 'compile
(defun opt-driver (form)
  (values (apply (get (car form) 'opt)
		 (cdr form))
	  t))
;; pdp10 maclisp has argument destructuring available in
;; vanilla defun.
(defmacro defopt (name . other)
  `(progn 'compile
	  (defun (,name opt) . ,other)
	  (defprop ,name (opt-driver) source-trans)))
)
#+NIL
(progn 'compile
(defun opt-driver (form)
  (ncons (apply (get (car form) 'opt) (cdr form))))
(defmacro defopt (name argl . other)
  `(progn 'compile
	  (defun (,name opt) ,argl . ,other)
	  (defprop ,name opt-driver source-code-rewrite)))
)
#+(or Multics Franz)
(defmacro defopt (name argl . other)
  `(defmacro ,name ,argl . ,other))

