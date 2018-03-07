;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module rzmac macro)

;;;   *****************************************************************
;;;   ***** MACROS ******* ASSORTED MACROS FOR GENERAL REPRESENTATION *
;;;   *****************************************************************

(defmacro repeat (index limit . body)
	  `(do ((,index 0 (1+ ,index)))
	      ((not (< ,index ,limit))) . ,body))

(defmacro logor frobs `(boole 7 . ,frobs))

(defmacro add-to-set (set frob)
	 `((lambda (temp)
		   (or (memq temp ,set)
		       (setq ,set (cons temp ,set))))
	   ,frob))

#+ITS
(defmacro compiling ()
	  `(and (boundp 'compiler-state)
		(not (eq compiler-state 'toplevel))))
#-ITS
(defmacro compiling nil t)

(defun *bind* macro (l)
       ((lambda (bindings body)
		(nconc (list 'do (mapcar (fn (q)
					     (cond ((atom q)
						    (list q))
						   ((eq (cadr q) '|<-|)
						    (list (car q) (caddr q)))
						   (t q)))
					 bindings)
			     nil)
		       (maplist (fn (x) (cond ((null (cdr x))
					       (cons 'return x))
					      ((car x))))
				body)))
	(cadr l) (cddr l)))

(defmacro displace2 (form new-car new-cdr)
	  `(rplaca (rplacd ,form ,new-cdr) ,new-car))

;; Returns the negation of VALUE if PREDICATE is true.  Otherwise, just
;; returns VALUE.

(defmacro negate-if (predicate value &aux (temp (gensym)))
	  `(let ((,temp ,predicate))
		(cond (,temp (neg ,value))
		      (t ,value))))

(defmacro either (which first second)
	  `(cond (,which ,first) (,second)))

;; Setq's the first variable to VALUE if SWITCH is true, and sets the second
;; variable otherwise.

(defmacro set-either (first-var second-var switch value &aux (temp (gensym)))
	  `(let ((,temp ,value))
		(cond (,switch (setq ,first-var ,temp))
		      (t (setq ,second-var ,temp)))))

(defmacro \* (&rest l) `(remainder . ,l))


(comment Symbolic Arithmetic Macros)

(defmacro m+ body `(add* . ,body))

(defmacro m* body `(mul* . ,body))

(defmacro m1+ (x) `(add* 1 ,x))

(defmacro m1- (x) `(add* -1 ,x))

(defmacro m// (a1 &optional (a2 nil 2args))
	  (cond (2args `(div* ,a1 ,a2))
		(t `(inv* ,a1))))

(defmacro m- (a1 &optional (a2 nil 2args))
	  (cond (2args `(sub* ,a1 ,a2))
		(t `(mul* -1 ,a1))))

(defmacro m^ (b e) `(power* ,b ,e))

(defmacro m+l (l) `(addn ,l nil))

(defmacro m*l (l) `(muln ,l nil))

;With 
(defmacro m+t body `(add . ,body))

(defmacro m*t body `(mul . ,body))

(defmacro m1+t (x) `(add 1 ,x))

(defmacro m1-t (x) `(add -1 ,x))

(defmacro m//t (a1 &optional (a2 nil 2args))
	  (cond (2args `(div ,a1 ,a2))
		(t `(inv ,a1))))

(defmacro m-t (a1 &optional (a2 nil 2args))
	  (cond (2args `(sub ,a1 ,a2))
		(t `(neg ,a1))))

(defmacro m^t (b e) `(power ,b ,e))

(defmacro m+lt (l) `(addn ,l ,t))

(defmacro m*lt (l) `(muln ,l ,t))
