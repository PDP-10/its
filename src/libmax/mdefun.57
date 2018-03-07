;;; -*- Mode: Lisp; Package: Macsyma -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;          Compilation environment for TRANSLATED MACSYMA code.        ;;;
;;;       (c) Copyright 1980 Massachusetts Institute of Technology       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module mdefun macro)

;(TRANSL-MODULE MDEFUN) IS CORRECT. But doesn't work in the MPRELU
;; environment.

(load-macsyma-macros transm)

;;; $FIX_NUM_ARGS_FUNCTION $VARIABLE_NUM_ARGS_FUNCTION.

(DEFVAR *KNOWN-FUNCTIONS-INFO-STACK* NIL
  "When MDEFUN-TR expands it puts stuff here for MFUNCTION-CALL
  to use.")

(DEFVAR *UNKNOWN-FUNCTIONS-INFO-STACK* NIL
  "When MFUNCTION-CALL expands without info from
  *KNOWN-FUNCTIONS-INFO-STACK* it puts stuff here to be barfed
  at the end of compilation.")

(DEFUN (MDEFUN-TR MACRO) (FORM)
  (error "obsolete macro form, please retranslate source code"
	 form 'fail-act))

(DEFUN (MDEFUN MACRO)(FORM)
  (error "obsolete macro form, please retranslate source code"
	 form 'fail-act))

;;; DEFMTRFUN will be the new standard.
;;; It will punt macsyma fexprs since the macro scheme is now
;;; available. I have tried to generalize this enough to do
;;; macsyma macros also.

;;; (DEFMTRFUN-EXTERNAL ($FOO <mode> <property> <&restp>))


#+PDP10
(DEFUN COMPILER-STATE () COMPILER-STATE)
#+LISPM
(DEFUN COMPILER-STATE () (Y-OR-N-P "Is COMPILER-STATE true?"))
#-(OR LISPM PDP10) 
(DEFUN COMPILER-STATE () T)


(defun (defmtrfun-external  macro) (form)
  (let (((name mode prop restp) (cadr form)))
    #+pdp10
    (and (eq prop 'mdefine) (COMPILER-STATE)
	 (PUSH-INFO NAME (COND (RESTP 'LEXPR)
			       (T 'EXPR))
		    *KNOWN-FUNCTIONS-INFO-STACK*))
    `(declare (,(cond (restp '*lexpr) (t '*expr))
	       ,name)
	      ;; FLONUM declaration is most important
	      ;; for numerical work on the pdp-10.
	      ,@(IF (AND (EQ PROP 'MDEFINE) (EQ MODE '$FLOAT))
		    `((FLONUM (,NAME))))
	      )
    ))

;;; (DEFMTRFUN ($FOO <mode> <property> <&restp>) <ARGL> . BODY)
;;; If the MODE is numeric it should do something about the
;;; numebr declarations for compiling. Also, the information about the
;;; modes of the arguments should not be thrown away.

;;; For the LISPM this sucks, since &REST is built-in.

(DEFUN (DEFMTRFUN MACRO) (FORM)
  (LET (( ((NAME MODE PROP RESTP . ARRAY-FLAG) ARGL . BODY) (CDR FORM))
	(DEF-HEADER))
    
    (AND ARRAY-FLAG
	 ;; old DEFMTRFUN's might have this extra bit NIL
	 ;; new ones will have (NIL) or (T)
	 (SETQ ARRAY-FLAG (CAR ARRAY-FLAG)))

    (SETQ DEF-HEADER
	  (COND ((EQ PROP 'MDEFINE)
		 (COND (ARRAY-FLAG #-LISPM `(,NAME A-EXPR A-SUBR)
				   #+LISPM `(:PROPERTY ,NAME A-SUBR))
		       (T NAME)))
		(T `(,NAME TRANSLATED-MMACRO))))
    #+PDP10
    (AND (EQ PROP 'MDEFINE) (COMPILER-STATE) (NOT ARRAY-FLAG)
	 (PUSH-INFO NAME (COND (RESTP 'LEXPR)
			       (T 'EXPR))
		    *KNOWN-FUNCTIONS-INFO-STACK*))
    
    `(PROGN 'COMPILE
	    ,@(AND (NOT ARRAY-FLAG) `((REMPROP ',NAME 'TRANSLATE)))
	    ,@(AND MODE `((DEFPROP ,NAME ,MODE
			    ,(COND (ARRAY-FLAG 'ARRAYFUN-MODE)
				   (T 'FUNCTION-MODE)))))
	    ,@(COND (ARRAY-FLAG
		     ;; when loading in hashed array properties
		     ;; most exist or be created. Other
		     ;; array properties must be consistent if
		     ;; they exist.
		     `((INSURE-ARRAY-PROPS ',NAME ',MODE
					   ',(LENGTH ARGL)))))
	    ,@(COND ((AND (EQ PROP 'MDEFINE) (NOT ARRAY-FLAG))
		     `((COND ((STATUS FEATURE MACSYMA)
			      (mputprop ',name t
					,(COND
					  ((NOT RESTP)
					   ''$fixed_num_args_function)
					  (T
					   ''$variable_num_args_function)))))
		       ,(COND ((NOT RESTP)
			       `(ARGS ',NAME '(NIL . ,(LENGTH ARGL))))))))
	    (DEFUN ,DEF-HEADER ,(COND ((NOT RESTP) ARGL)
				      (T '|mlexpr NARGS|))
	      ,@(COND ((NOT RESTP)
		       BODY)
		      (t
		       (LET ((NL (1- (LENGTH ARGL))))
			 `((COND ((< |mlexpr NARGS| ,NL)
				  ($ERROR
				   'ERROR ',NAME
				   '| takes no less than |
				   ,NL
				   ',(COND ((= NL 1)
					    '| argument.|)
					   (T
					    '| arguments.|))))
				 (T
				  ((LAMBDA ,ARGL
				     ,@BODY)
				   ;; this conses up the
				   ;; calls to ARGS and LISTIFY.
				   ,@(DO ((J 1 (1+ J))
					  (P-ARGL NIL))
					 ((> J NL)
					  (PUSH
					   `(CONS
					     '(MLIST)
					     (LISTIFY
					      (- ,NL
						 |mlexpr NARGS|)))
					   P-ARGL)
					  (NREVERSE P-ARGL))
				       (PUSH `(ARG ,J)
					     P-ARGL)))))))))))))



