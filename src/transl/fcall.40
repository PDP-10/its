;;; -*- Mode: Lisp; Package: Macsyma -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;       (c) Copyright 1980 Massachusetts Institute of Technology       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module fcall)

(TRANSL-MODULE FCALL)

;;; Bug-Fixes:
;;;
;;; 11/15/80	KMP	Remove *TRIED-TO-AUTOLOAD* as a global and replaced
;;;			MFUNCTION-CALL with a trampoline function that calls
;;;			MFUNCTION-CALL-AUX with this info since MFUNCTION-CALL
;;;			was being screwed by the non-local nature of this var
;;;			when calls to itself got nested.
;;;

;;; This file is for macros, fsubrs, and subrs which are run time 
;;; support for interpreted translated macsyma code.

;;; MFUNCTION-CALL is a macro in LIBMAX;TRANSQ
;;; This is an FSUBR for use in interpreted code.
;;; It should do quit a bit of checking for STATUS PUNT NIL lossage, etc.
;;; The macro will expand into code which will assume normal
;;; functional argument evaluation.

(DEFMVAR $TR_WARN_BAD_FUNCTION_CALLS T
	 "Warn when strange kinds of function calls are going on in
	 translated code.")

(DEFVAR *TR-RUNTIME-WARNED* NIL
	"This is an alist of warnings which have been given")

(DEFMFUN $TR_WARNINGS_GET ()
       `((MLIST) ,@(MAPCAR #'(LAMBDA (U)
				     `((MLIST) ,(CAR U) ,(CDR U)))
			   *TR-RUNTIME-WARNED*)))


(DEFUN MFUNCTION-CALL-WARN (F TYPE)
       (COND ((ASSQ F *TR-RUNTIME-WARNED*))
	     (T
	      (PUSH (CONS F TYPE) *TR-RUNTIME-WARNED*)
	      (COND ($TR_WARN_BAD_FUNCTION_CALLS
		     (LET ((TABL (CDR (ASSQ TYPE '((FEXPR . (FEXPR-WARNEDP 
"This may be due to lack of enough translation data base info."))
						   (MACRO . (MACRO-WARNEDP 
"Macros should to be loaded when you are translating."))
						   (UNDEFINED . (UNDEFINED-WARNP
"The function was totaly undefined. Maybe you want to quote it."))
						   (PUNT-NIL . (PUNT-NIL-WARNP
"If you want the value of the function name, use APPLY"))
						   (MFEXPR . (MFEXPR-WARNEDP
"MFEXPRS should be loaded at translating time. Use of them in
translated code (nay, any code!), is NOT recommened however.")))))))
			  (COND ((NULL TABL))
				((GET F (CAR TABL)))
				(T
				 (PUTPROP F T (CAR TABL))
				 (TERPRI)
				 (PRINC "Warning: ")
				 (MGRIND F NIL)
				 (PRINC
 " has a function or macro call which has not been
translated properly.")
				 (COND ((CDR TABL)
					(TERPRI)
					(PRINC (CADR TABL))))))))))))
	     
(DEFUN MAPCAR-EVAL (X) (MAPCAR #'EVAL X))

(DEFUN MFUNCTION-CALL FEXPR (F+ARGL)
       (MFUNCTION-CALL-AUX (CAR F+ARGL) (CDR F+ARGL) NIL))

(DEFUN MFUNCTION-CALL-AUX (F ARGL AUTOLOADED-ALREADY?)
       (LET ((F-PROP))
	    (COND ((SETQ F-PROP (GETL F '(EXPR LEXPR)))
		   (APPLY  (CADR F-PROP) (MAPCAR-EVAL ARGL)))
		  ((GETL F '(SUBR LSUBR))
		   (APPLY F (MAPCAR-EVAL ARGL)))
		  ((GETL F '(FEXPR FSUBR))
		   (MFUNCTION-CALL-WARN F 'FEXPR)
		   (APPLY  F ARGL))
		  ((SETQ F-PROP (GET F 'MACRO))
		   (MFUNCTION-CALL-WARN F 'MACRO)
		   (EVAL (FUNCALL F-PROP (CONS F ARGL))))
		  ((SETQ F-PROP (MGET F 'MEXPR))
		   (COND ((MGET F 'MFEXPRP)
			  (MFUNCTION-CALL-WARN F 'MFEXPR)
			  (MEVAL (CONS (LIST F) ARGL)))
			 (T
			  (MAPPLY F-PROP (MAPCAR-EVAL ARGL) '|a translated fcall.|))))
		  ((SETQ F-PROP (GET F 'AUTOLOAD))
		   (COND (AUTOLOADED-ALREADY?
			  (MERROR "~:@M, Function undefined after loading file:~A "
				  F
				  (NAMESTRING (GET F 'AUTOLOAD))))
				  
			 (T
			  (funcall autoload (cons f F-PROP))
			  (MFUNCTION-CALL-AUX F ARGL T))))
		  ((BOUNDP F)
		   (MFUNCTION-CALL-WARN F 'PUNT-NIL)
		   (MAPPLY (EVAL F) (MAPCAR-EVAL ARGL) F))
		  (T
		   (MFUNCTION-CALL-WARN F 'UNDEFINED)
		   `((,F) ,@(MAPCAR-EVAL ARGL))))))

;;; I think that that just about covers it.

;;; This FEXPR may not work if it is not compiled.

(DEFUN TRD-MSYMEVAL FEXPR (L)
       (LET ((A-VAR? (CAR L)))
	    (COND ((BOUNDP A-VAR?)
		   (EVAL A-VAR?))   ;;; ouch!
		  (t
		   ;; double ouch!
		   (set A-VAR? (cond ((cdr l) (eval (cadr l)))
				     (t a-var?)))))))

(DEFUN EXPT$ (A B)
       (EXPT A B))

;;; These are the LAMBDA forms. They have macro properties that set
;;; up very different things in compiled code.

;;; (M-TLAMBDA ,@(CDR T-FORM))))
;;; (M-TLAMBDA& ,@(CDR T-FORM))))))


(DEFUN MAKE-M-LAMBDA& (ARGL BODY)
       (DO ((L NIL)
	    (LARGS ARGL (CDR LARGS))
	    (J 1 (1+ J)))
	   ((NULL (CDR LARGS))
	    `(LAMBDA *N*
		     ((LAMBDA ,ARGL ,@BODY)
		      ,@(NREVERSE L)
		      (CONS '(MLIST) (LISTIFY (- ,(1- J) *N*))))))
	   (PUSH `(ARG ,J) L)))


(DEFUN M-TLAMBDA FEXPR (ARGS)
       (CONS 'LAMBDA ARGS))

(DEFVAR *FCALL-MEMORY* NIL
	"This ALIST will never be very long. Considerably less hairy then
	a hashing scheme, perhaps faster in normal use. In either case
	there is the problem of garbage from red-defined functions.")

(DEFUN M-TLAMBDA& FEXPR (ARGS)
       (LET ((FORM (ASSQ ARGS *FCALL-MEMORY*)))
	    (COND (FORM (CDR FORM))
		  (T
		   (SETQ FORM (MAKE-M-LAMBDA& (CAR ARGS) (CDR ARGS)))
		   (PUSH (CONS ARGS FORM) *FCALL-MEMORY*)
		   FORM))))

(DEFUN EVALQUOTE (EXP)
       (SETQ EXP (EVAL EXP))
       (COND ((NUMBERP EXP) EXP)
	     (T `(QUOTE ,EXP))))

(DEFUN M-TLAMBDA&ENV FEXPR (ARGS)
       (LET (( ((REG-ARGL ENV-ARGL) . BODY)  ARGS))
	    `(LAMBDA ,REG-ARGL ((LAMBDA ,ENV-ARGL ,@BODY) ,@(MAPCAR 'EVALQUOTE
								    ENV-ARGL)))))

(DEFUN M-TLAMBDA&ENV& FEXPR (ARGS)
       (LET (( ((REG-ARGL ENV-ARGL) . BODY)  ARGS))
	    (make-M-LAMBDA& REG-ARGL `(((LAMBDA ,ENV-ARGL ,@BODY)
					,@(MAPCAR 'EVALQUOTE ENV-ARGL))))))

;;; (FUNGEN&ENV-for-meval <eval vars list> <late eval vars list>  <EXP>)

(DEFUN FUNGEN&ENV-FOR-MEVAL FEXPR (ARGS)
       (LET (((EVL LEVL . BODY) ARGS))
	    ;;; all we want to do here is make sure that the EVL gets
	    ;;; evaluated now so that we have some kind of compatibility
	    ;;; with compiled code. we could just punt and pass the body.
	    `(($APPLY) ((MQUOTE) ((LAMBDA) ((MLIST) ,@EVL) ,@BODY))
		       ((MQUOTE SIMP) ((MLIST) ,@(MAPCAR-EVAL EVL))))))

;;; (FUNGEN&ENV-FOR-MEVALSUMARG EVL VAR <translate-exp> <untranslated-exp>)

;;; The following code depends on the fact that the argument to an
;;; FEXPR is always EQ, for a given instance of FEXPR call. Lets say
;;; that the efficiency of the code depends on that fact. We cannot use
;;; displacing macros because of the $SAVE problem which I really don't
;;; feel like fooling around with since it is an IN-CORE function, and
;;; totaly cryptic code.

(DEFUN FUNGEN&ENV-FOR-MEVALSUMARG FEXPR (ARGS)
       (LET ((RES (ASSQ ARGS *FCALL-MEMORY*)))
	    (COND ((NULL RES)
		   (LET (((EVL LEVL T-BODY M-BODY) ARGS))
			(SETQ RES (GENSYM))
			(PUTPROP RES
				 `(LAMBDA (*IGNORED*)
					  (PROG2 (MBIND ',EVL
							(GET ',RES 'SUMARG-ENV) NIL)
						 (MEVALATOMS ',M-BODY)
						 (MUNBIND ',EVL)))
				 'MEVALSUMARG-MACRO)
			(PUTPROP RES
				 `(LAMBDA ()
					  (APPLY '(LAMBDA ,EVL ,T-BODY)
						 (GET ',RES 'SUMARG-ENV)))
				 'EXPR)
			(SETQ RES `(,ARGS ,RES ((,RES))))
			(PUSH RES *FCALL-MEMORY*))))
	    (PUTPROP (CADR RES) (MAPCAR #'EVAL (CAR ARGS)) 'SUMARG-ENV)
	    (CADDR RES)))


(DEFUN M-TLAMBDA-I FEXPR (ARGS)
       `(LAMBDA ,@(CDDR ARGS)))

#+MACLISP
(DEFUN COMPILE-FORMS-TO-COMPILE-QUEUE FEXPR (FORM) FORM)
