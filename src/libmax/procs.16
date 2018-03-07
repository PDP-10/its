;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module procs macro)

;;; Fast dispatching off the property list with SUBRCALL.
;;; MARCH 1980. -GJC

;;; The advantages:
;;; [1] (SUBRCALL NIL (GET (CAR FORM) 'FOO) FORM) is fast! (PUSHJ P @ 0 P)
;;; [2] Creates no extra symbols of the kind |NAME FOO|.
;;; The problems with using SUBRCALL:
;;; [1] Only have subrs in compiled code.
;;; [2] System-dependant.
;;; [3] Fixed number of arguments.

;;; This macro package fixes problems [1] and [2]. 
;;; Number [3] isn't a problem for the parsers, translators and tree-walkers
;;; in macsyma.

(defun verify-as-subr-argument-list (property l n)
  (if (or (memq '&rest l)
	  (memq '&optional l))
      (error (list "bad argument list for a" property "property.") l)
      (let ((length (- (length l)
		       (length (memq '&aux l)))))
	(if (eq n '*)
	    (if (< length 6.)
		length
		(error (list "argument list too long for a" property "property.") l))
	    (if (= n length)
		length
		(error (list "argument list for a" property "property must be"
			     n "long.")
		       l))))))


(defun a-def-property (name argl body property n)
  (verify-as-subr-argument-list property argl n)
  (cond ((status feature pdp10)
	 (cond ((memq compiler-state '(maklap compile))
		`(defun (,name nil ,property) ,argl . ,body))
	       ('else
		(let ((f (symbolconc name '- property)))
		  `(progn (defprop ,name ,(make-jcall n f) ,property)
			  (defun ,f ,argl . ,body))))))
	('else
	 `(defun (,name ,property) ,argl . ,body))))
	 
(defmacro def-def-property (name sample-arglist)
  
  `(defmacro ,(symbolconc 'def- name '-property) (name argl . body)
     (a-def-property name argl body ',name 
		     ',(verify-as-subr-argument-list 'def-def-property
						       sample-arglist
						       '*))))

#+PDP10
(progn 'compile
(defun make-jcall (number-of-arguments name-to-call)
  (boole 7 13._27.
	 (lsh number-of-arguments 23.)
	 (maknum name-to-call)))
;; SUBRCALL does argument checking in the interpreter, so
;; the FIXNUM's won't pass as subr-pointers.
;; The following code must be compiled in order to run interpreted code
;; which uses SUBR-CALL and DEF-DEF-PROPERTY.
(defun subr-call-0 (f)          (subrcall nil f))
(defun subr-call-1 (f a)        (subrcall nil f a))
(defun subr-call-2 (f a b)      (subrcall nil f a b))
(defun subr-call-3 (f a b c)    (subrcall nil f a b c))
(defun subr-call-4 (f a b c d)  (subrcall nil f a b c d))
(defun subr-call-5 (f a b c d e)(subrcall nil f a b c d e))
(DEFMACRO SUBR-CALL (F &REST L)
  (IF (MEMQ COMPILER-STATE '(MAKLAP COMPILE))
      `(SUBRCALL NIL ,F ,@L)
      `(,(cdr (assoc (length l)
			       '((0 . subrcall-0)
				 (1 . subrcall-1)
				 (2 . subrcall-2)
				 (3 . subrcall-3)
				 (4 . subrcall-4)
				 (5 . subrcall-5))))
		  ,f ,@l)))
)

#-PDP10
(DEFMACRO SUBR-CALL (F &REST L) `(FUNCALL ,F ,@L))