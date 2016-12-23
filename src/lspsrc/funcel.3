;;;   FUNCEL			-*-Mode:Lisp;Package:SI;Lowercase:T-*-
;;;   ****************************************************************
;;;   *** MacLISP ******** Function-Cell Hacking *********************
;;;   ****************************************************************
;;;   ** (c) Copyright 1981 Massachusetts Institute of Technology ****
;;;   ****************************************************************

(herald FUNCEL /2)

(eval-when (eval compile) 
   (load '((lisp) subload)))

(eval-when (eval load compile)
    (subload EXTEND))

;;;; FMAKUNBOUND, FSYMEVAL, and FSET, for maclisp
	       

(defclass* SUBR SUBR-CLASS MACLISP-PRIMITIVE-CLASS)
(defclass* LSUBR LSUBR-CLASS MACLISP-PRIMITIVE-CLASS)

(defmethod* (:PRINT-SELF SUBR-CLASS) (obj stream () () )
  (si:print-extend obj (si:xref obj 0) stream))

(defmethod* (:PRINT-SELF LSUBR-CLASS) (obj stream () () )
  (si:print-extend obj (si:xref obj 0) stream))

(defun FMAKUNBOUND (sym)
  (if *RSET (or (and sym (symbolp sym))
		(check-type sym #'SYMBOLP 'FMAKUNBOUND)))
  (prog (prop)
     A  (if (null (setq prop (getl sym '(SUBR LSUBR EXPR MACRO))))
	    (return () ))
	(remprop sym (car prop))
	(go A))   ;Avoid lossage when symbol has both MACRO and SUBR
  sym)

(defun FSYMEVAL (a &aux pl fun) 
   (do () 
       ((and (symbolp a)
	     (setq pl (getl a '(SUBR LSUBR MACRO EXPR))))
	() ) 
     (setq a (error "Not a function name -- FSYMEVAL" a 'WRNG-TYPE-ARG)))
   (setq fun (cadr pl))
   (caseq (car pl)
	  ((SUBR LSUBR) 
	    (si:extend (if (eq (car pl) 'SUBR) SUBR-CLASS LSUBR-CLASS) 
		       fun 
		       (args a)))
	  (EXPR fun)
	  (MACRO `(MACRO . ,fun))))


(defun FSET (sym val &aux (type (typep val)))
  (fmakunbound sym)
  (cond ((and (eq type 'LIST) (memq (car val) '(MACRO LAMBDA)))
	 (cond ((eq (car val) 'MACRO) (putprop sym (cdr val) 'MACRO))
	       ((eq (car val) 'LAMBDA) (putprop sym val 'EXPR))))
	((eq type 'SYMBOL) (putprop sym val 'EXPR))
	((memq (setq type (type-of val)) '(SUBR LSUBR))
	  (putprop sym (si:xref val 0) type)
	  (args sym (si:xref val 1)))
	('T (error "Not a function? - FSET" val)))
  val)

