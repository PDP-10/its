;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module buildq)

; Exported functions are $BUILDQ and MBUILDQ-SUBST
; TRANSLATION property for $BUILDQ in MAXSRC;TRANS5 >

;**************************************************************************
;******                                                              ******
;******      BUILDQ:  A backquote-like construct for Macsyma         ******
;******                                                              ******
;**************************************************************************



;DESCRIPTION:


; Syntax: 

; BUILDQ([<varlist>],<expression>);

; <expression> is any single macsyma expression
; <varlist> is a list of elements of the form <atom> or <atom>:<value>


; Semantics:

; the <value>s in the <varlist> are evaluated left to right (the syntax
; <atom> is equivalent to <atom>:<atom>).  then these values are substituted
; into <expression> in parallel.  If any <atom> appears as a single 
; argument to the special form SPLICE (i.e. SPLICE(<atom>) ) inside
; <expression>, then the value associated with that <atom> must be a macsyma
; list, and it is spliced into <expression> instead of substituted.





;SIMPLIFICATION:


; the arguments to $BUILDQ need to be protected from simplification until
; the substitutions have been carried out.  This code should affect that.

(DEFPROP $BUILDQ SIMPBUILDQ OPERATORS)
(DEFPROP %BUILDQ SIMPBUILDQ OPERATORS)

; This is modeled after SIMPMDEF, SIMPLAMBDA etc. in JM;SIMP >

(DEFUN SIMPBUILDQ (X *IGNORE* SIMP-FLAGS)
       *IGNORE*   ; no simplification takes place.
       SIMP-FLAGS ; ditto.
       (CONS '($BUILDQ SIMP) (CDR X)))

; Note that supression of simplification is very important to the semantics
; of BUILDQ.  Consider BUILDQ([A:'[B,C,D]],SPLICE(A)+SPLICE(A));

; If no simplification takes place, $BUILDQ returns B+C+D+B+C+D.
; If the expression is simplified into 2*SPLICE(A), then 2*B*C*D results.



;INTERPRETIVE CODE:


(DEFMSPEC $BUILDQ (FORM) (SETQ FORM (CDR FORM))
  (COND ((OR (NULL (CDR FORM))
	     (CDDR FORM))
	 (MERROR "BUILDQ takes 2 args:~%~M" `(($BUILDQ) ,@FORM)))
	(T (MBUILDQ (CAR FORM) (CADR FORM)))))

; this macro definition is NOT equivalent because of the way lisp macros
; are currently handled in the macsyma interpreter.  When the subr form
; is returned the arguments get MEVAL'd (and hence simplified) before
; we get ahold of them.

; Lisp MACROS, and Lisp FEXPR's are meaningless to the macsyma evaluator
; and should be ignored, the proper things to use are MFEXPR* and
; MMACRO properties.  -GJC

;(DEFMACRO ($BUILDQ DEFMACRO-FOR-COMPILING T)
;          (VARLIST . EXPRESSIONS)
;   (COND ((OR (NULL VARLIST)
;	       (NULL EXPRESSIONS)
;	       (CDR EXPRESSIONS))
;	   (DISPLA `(($BUILDQ) ,VARLIST ,@EXPRESSIONS))
;	   (MERROR "BUILDQ takes 2 args"))
;	  (T `(MBUILDQ ',VARLIST ',(CAR EXPRESSIONS)))))


(DEFUN MBUILDQ (VARLIST EXPRESSION)
 (COND ((NOT ($LISTP VARLIST))
	(MERROR "First arg to BUILDQ not a list: ~M" VARLIST)))
 (MBUILDQ-SUBST
  (MAPCAR #'(LAMBDA (FORM)             ; make a variable/value alist
	       (COND ((SYMBOLP FORM)
		      (CONS FORM (MEVAL FORM)))
		     ((AND (EQ (CAAR FORM) 'MSETQ)
			   (SYMBOLP (CADR FORM)))
		      (CONS (CADR FORM) (MEVAL (CADDR FORM))))
		     (T 
			(MERROR "Illegal form in variable list--BUILDQ: ~M"
				FORM
				))))
	  (CDR VARLIST))
  EXPRESSION))


; this performs the substitutions for the variables in the expressions.
; it tries to be smart and only copy what list structure it has to.
; the first arg is an alist of pairs:  (<variable> . <value>)
; the second arg is the macsyma expression to substitute into.

(DEFMFUN MBUILDQ-SUBST (ALIST EXPRESSION)
 (PROG (NEW-CAR)
       (COND ((ATOM EXPRESSION)
	      (RETURN (MBUILDQ-ASSOCIATE EXPRESSION ALIST)))
	     ((ATOM (CAR EXPRESSION))
	      (SETQ NEW-CAR (MBUILDQ-ASSOCIATE (CAR EXPRESSION) ALIST)))
	     ((MBUILDQ-SPLICE-ASSOCIATE EXPRESSION ALIST)
	      ; if the expression is a legal SPLICE, this clause is taken.
	      ; a SPLICE should never occur here.  It corresponds to `,@form
	      
	      (MERROR "SPLICE used in illegal context: ~M" EXPRESSION))
	     ((ATOM (CAAR EXPRESSION))
	      (SETQ NEW-CAR (MBUILDQ-ASSOCIATE (CAAR EXPRESSION) ALIST))
	      (COND ((EQ NEW-CAR (CAAR EXPRESSION))
		     (SETQ NEW-CAR (CAR EXPRESSION)))
		    ((ATOM NEW-CAR)
		     (SETQ NEW-CAR (CONS NEW-CAR (CDAR EXPRESSION))))
		    (T (RETURN
			`(,(CONS 'MQAPPLY (CDAR EXPRESSION))
			  ,NEW-CAR
			  ,@(MBUILDQ-SUBST ALIST (CDR EXPRESSION)))))))
	     ((SETQ NEW-CAR 
		    (MBUILDQ-SPLICE-ASSOCIATE (CAR EXPRESSION) ALIST))
	      (RETURN (APPEND (CDR NEW-CAR)
			      (MBUILDQ-SUBST ALIST (CDR EXPRESSION)))))
	     (T (SETQ NEW-CAR (MBUILDQ-SUBST ALIST (CAR EXPRESSION)))))
       (RETURN
	(LET ((NEW-CDR (MBUILDQ-SUBST ALIST (CDR EXPRESSION))))
	     (COND ((AND (EQ NEW-CAR (CAR EXPRESSION))
			 (EQ NEW-CDR (CDR EXPRESSION)))
		    EXPRESSION)
		   (T (CONS NEW-CAR NEW-CDR)))))))


; this function returns the appropriate thing to substitute for an atom
; appearing inside a backquote.  If it's not in the varlist, it's the
; atom itself.

(DEFUN MBUILDQ-ASSOCIATE (ATOM ALIST)
 (LET ((FORM))
      (COND ((NOT (SYMBOLP ATOM))
	     ATOM)
	    ((SETQ FORM (ASSQ ATOM ALIST))
	     (CDR FORM))
	    ((SETQ FORM (ASSQ ($VERBIFY ATOM) ALIST))
	      ;trying to match a nounified substitution variable
	     (COND ((ATOM (CDR FORM))
		    ($NOUNIFY (CDR FORM)))
		   ((MEMQ (CAAR (CDR FORM)) 
			  '(MQUOTE MLIST MPROG MPROGN LAMBDA))
		      ;list gotten from the parser.
		    `((MQUOTE) ,(CDR FORM)))
		   (T `( (,($NOUNIFY (CAAR (CDR FORM)))
			  ,@(CDAR (CDR FORM)))
			,@(CDR (CDR FORM))))))
	             ;; ((<verb> ...) ...)  ==>  ((<noun> ...) ...)
	    (T ATOM))))



; this function decides whether the SPLICE is one of ours or not.
; the basic philosophy is that the SPLICE is ours if it has exactly
; one symbolic argument and that arg appears in the current varlist.
; if it's one of ours, this function returns the list it's bound to.
; otherwise it returns nil.  Notice that the list returned is an 
; MLIST and hence the cdr of the return value is what gets spliced in.

(DEFUN MBUILDQ-SPLICE-ASSOCIATE (EXPRESSION VARLIST)
 (AND (EQ (CAAR EXPRESSION) '$SPLICE)
      (CDR EXPRESSION)
      (NULL (CDDR EXPRESSION))
      (LET ((MATCH (ASSQ (CADR EXPRESSION) VARLIST)))
	   (COND ((NULL MATCH) () )
		 ((NOT ($LISTP (CDR MATCH)))
		  (MERROR "~M returned ~M~%But SPLICE must return a list"
			  EXPRESSION (CDR MATCH)))
		 (T (CDR MATCH))))))


