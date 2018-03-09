;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;                 GJC 9:29am  Saturday, 5 April 1980		 	 ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module transl)
(transl-module transl)

;;; File directory.

;;; MC:MAXSRC;TRANSL   Driver. Basic translation properties.
;;; MC:MAXSRC;TRANSS   User-interaction, FILE-I/O etc.
;;; MC:MAXSRC;TRANS1   Translation of JPG;MLISP and other FSUBRS.
;;;                    which take call-by-name parameters.
;;; MC:MAXSRC;TRANS2   LISTS, ARRAYs, other random operators.
;;; MC:MAXSRC;TRANS3   LAMBDA. CLOSURES. also used by fsubr call-by-name
;;;                    compatibility package.              
;;; MC:MAXSRC;TRANS4   operators, ".", "^^" some functions such as GAMMA.
;;; MC:MAXSRC;TRANS5   FSUBRS from COMM, and others, these are mere MACRO
;;;                    FSUBRS.
;;; MC:MAXSRC;TRANSF   floating point intensive properties. BIGFLOAT stuff.
;;; MC:MAXSRC;TROPER   Basic OPERATORS.
;;; MC:MAXSRC;TRUTIL   transl utilities.
;;; MC:MAXSRC;TRMODE   definition of MODEDECLARE. run time error checking code.
;;; MC:MAXSRC;TRDATA   this is the MODE data for the "built-in" functions.
;;; MC:LIBMAX;TRANSM   This defines the macro DEF%TR. When compiled on MC
;;;                     DEF%TR produces autoload definitions for TRANS1 thru L.
;;; MC:LIBMAX;PROCS   macro's needed.
;;; MC:LIBMAX;TPRELU   this file is INCLUDEF'ed by translated macsyma code.
;;; MC:LIBMAX;TRANSQ   these are macros for translated code. Loaded by TPRELU
;;;                    this is compile-time only.
;;; MC:LIBMAX;MDEFUN   contains the macro which defines macsyma functions.
;;;                    runtime and compile-time.
;;; MC:MAXSRC;ACALL is some run time support for translated code, array calls.
;;; MC:MAXSRC;FCALL  run-time translated function call support for uncompiled
;;;                  code. Many FSUBRS which are macros in TRANSQ.
;;; MC:MAXSRC;EVALW  EVAL-WHEN definition for interpreter.
;;; MC:MAXSRC;MLOAD  This has a hack hook into BATCH, which is needed to do
;;;                  TRANSLATE_FILE I/O. when using old-i/o SUPRV.


;;; Functions and literals have various MODE properties;;; >
;;; (at user level set up by $MODEDECLARE), such as "$FLOAT" and "$ANY".
;;; The main problem solved by this translater (and the reason that
;;; it works on forms from the "inside out" as an evaluator would do
;;; (expect for macro forms)), is the problem of type (MODE) dependant
;;; function calling and mode conversion. The function TRANSLATE
;;; returns a list  where the CAR of the list is the MODE of the
;;; expression and the CDR is the expression to be evaluated by
;;; the lisp evaluator to give the equivalent result of evaluating
;;; the given macsyma expression with the macsyma evaluator.
;;; One doesn't know the MODE of an expression until seeing the modes
;;; of all its parts. See "*UNION-MODE"

;;; weak points in the code
;;; [1] duplication of functionality in the translaters for
;;; MPLUS MTIMES etc. 
;;; [3] primitive mode scheme. lack of even the most primitive general
;;; type coercion code. Most FORTRAN compilers are better than this.
;;; [4] for a compiler, this code SUCKS when it comes to error checking
;;; of the code it is munging. It doesn't even do a WNA check of system
;;; functions!
;;; [5]
;;; The duplication of the code which handles lambda binding, in MDO, MDOIN
;;; TR-LAMBDA, and MPROG, is very stupid. For macsyma this is one of
;;; the hairier things. Declarations must be handled, ASSIGN properties...
;;; -> Binding of ASSIGN properties should be handled with he "new"
;;; UNWIND-PROTECT instead of at each RETURN, and at "hope" points such as
;;; the ERRLIST. {Why wasn't this obvious need for UNWIND-PROTECT made
;;; known to the lisp implementers by the macsyma implementers? Why did it
;;; have to wait for the lisp machine group? Isn't this just a generalization
;;; of special binding?}
;;; [6] the DCONVX idea here is obscurely coded, incomplete, and totally
;;; undocumented. It was probably an attempt to hack efficient
;;; internal representations (internal to a given function), for some macsyma
;;; data constructs, and yet still be sure that fully general legal data
;;; frobs are seen outside of the functions. Note: this can be done
;;; simply by type coercion and operator folding.

;;; General comments on the stucture of the code.
;;; A function named TR-<something> means that it translates
;;; something having to do with that something.
;;; N.B. It does not mean that that is the translate property for <something>.


(DEFMVAR $TRANSBIND NIL
	 "This variable is now obsolete."
	 )

(DEFUN OBSOLETE-VARIABLE (VAR IGNORE-VAL)
       (COND ((EQ (SYMEVAL VAR) '$OBSOLETE))
	     (T
	      (SET VAR '$OBSOLETE)
	      (MTELL "~%Warning, setting obsolete variable: ~:M~%" VAR))))

(PUTPROP '$TRANSBIND #'OBSOLETE-VARIABLE 'ASSIGN)


(DEFMVAR $TR_SEMICOMPILE NIL
	 "If TRUE TRANSLATE_FILE and COMPFILE output forms which will~
	 be macroexpanded but not compiled into machine code by the~
	 lisp compiler.")
(DEFMVAR  $TRANSCOMPILE  NIL
	  "If TRUE TRANSLATE_FILE outputs declarations for the COMPLR.
	  The only use of the switch is to save the space declarations take
	  up in interpreted code.")

(DEFMVAR $SPECIAL NIL "This is an obsolete variable -GJC")

(PUTPROP '$SPECIAL #'OBSOLETE-VARIABLE 'ASSIGN)

(DEFMVAR TSTACK NIL " stack of local variable modes ")

(DEFMVAR LOCAL NIL "T if a $LOCAL statement is in the body.")
(DEFMVAR ARRAYS NIL "arrays to declare to COMPLR")
(DEFMVAR LEXPRS NIL "Lexprs to declare.")
(DEFMVAR EXPRS NIL "what else?")
(DEFMVAR FEXPRS NIL "Fexprs to declare.")
(DEFMVAR TR-PROGRET T)
(DEFMVAR INSIDE-MPROG NIL)
(DEFMVAR RETURNS NIL "list of TRANSLATEd return forms in the block.")
(DEFMVAR RETURN-MODE NIL "the highest(?) mode of all the returns.")
(DEFMVAR NEED-PROG? NIL)
(DEFMVAR ASSIGNS NIL "These are very-special variables which have a macsyma
	assign property which must be called to bind and unbind the variable
	whenever it is /"lambda/" bound.")
(DEFMVAR SPECIALS NIL "variables to declare special to the complr.")
(DEFMVAR TRANSLATE-TIME-EVALABLES
	'($MODEDECLARE $ALIAS $DECLARE $INFIX $NOFIX
		       $MATCHFIX $PREFIX $POSTFIX $COMPFILE))

(DEFMVAR *TRANSL-BACKTRACE* NIL
	" What do you think? ")
(DEFMVAR *TRANSL-DEBUG* NIL "if T it pushes BACKTRACE and TRACE ")

(DEFMVAR TR-ABORT NIL "set to T if abortion is requested by any of the
	sub-parts of the translation. A *THROW would be better, although it
	wouldn't cause the rest of the translation to continue, which may
	be useful in translation for error checking.")

(DEFMVAR TR-UNIQUE (GENSYM)
	"this is just a unque object used for random purposes,
	such as the second (file end) argument of READ.")


(DEFMVAR $TR_WARN_UNDECLARED
	 '$COMPILE
	 "When to send warnings about undeclared variables to the TTY")

(DEFMVAR $TR_WARN_MEVAL
	 '$COMPFILE
	 "If MEVAL is called that indicates problems in the translation")

(DEFMVAR $TR_WARN_FEXPR
	 '$COMPFILE
         "FEXPRS should not normally be output in translated code, all legitimate
special program forms are translated.")

(DEFMVAR $TR_WARN_MODE
	 '$ALL
	 "Warn when variables are assigned values out of their mode.")

(DEFMVAR $TR_WARN_UNDEFINED_VARIABLE
	 '$ALL
	 "Warn when undefined global variables are seen.")

(DEFMVAR *WARNED-UN-DECLARED-VARS* NIL "Warning State variable")
(DEFMVAR *WARNED-FEXPRS* NIL "Warning State variable")
(DEFMVAR *WARNED-MODE-VARS* NIL "Warning State variable")

(DEFMVAR $TR_FUNCTION_CALL_DEFAULT '$GENERAL
	 "
FALSE means punt to MEVAL, EXPR means assume lisp fixed arg function.
GENERAL, the default gives code good for mexprs and mlexprs but not macros.
GENERAL assures variable bindings are correct in compiled code.
In GENERAL mode, when translating F(X), if F is a bound variable, then
it assumes that APPLY(F,[X]) is meant, and translates a such, with 
apropriate warning. There is no need to turn this off.
APPLY means like APPLY.")

(DEFMVAR $TR_ARRAY_AS_REF T
	 "If true runtime code uses value of the variable as the array.")

(DEFMVAR $TR_NUMER NIL
	 "If TRUE numer properties are used for atoms which have them, e.g. %PI")

(DEFMVAR $TR_PREDICATE_BRAIN_DAMAGE NIL
  "If TRUE, output possible multiple evaluations in an attempt
  to interface to the COMPARE package.")

(DEFVAR BOOLEAN-OBJECT-TABLE
  '(($TRUE . ($BOOLEAN . T))
    ($FALSE . ($BOOLEAN . NIL))
    (T . ($BOOLEAN . T))
    (NIL . ($BOOLEAN . NIL))))

(DEFVAR MODE-INIT-VALUE-TABLE
  '(($FLOAT . 0.0)
    ($FIXNUM . 0)
    ($NUMBER  . 0)
    ($LIST . '((MLIST)))
    ($BOOLEAN  . NIL)))

(DEFVAR TR-LAMBDA-PUNT-ASSIGNS NIL
  "Kludge argument to TR-LAMBDA due to lack of keyword argument passing")

(OR (BOUNDP '*IN-COMPILE*) (SETQ *IN-COMPILE* NIL))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(DEFTRFUN TR-TELL (&REST X &AUX (TP T))
	  (DO ((X X (CDR X)))
	      ((NULL X))
	      (COND ((ATOM (CAR X)) ;;; simple heuristic that seems to work.
		     (COND ((OR TP (> (FLATC (CAR X)) 10.))
			    (TERPRI *TRANSLATION-MSGS-FILES*)
			    (SETQ TP NIL)))
		     (PRINC (STRIPDOLLAR (CAR X)) *TRANSLATION-MSGS-FILES*))
		    (T
		     (MGRIND (CAR X) *TRANSLATION-MSGS-FILES*)))))

(DEFTRFUN BARFO (&REST L)
	  (APPLY #'TR-TELL
		 (nconc l
			'("***BARFO*** gasp. Internal TRANSLATE error. i.e. *BUG*")))
	  (cond (*transl-debug*
		 (*break t '|Transl Barfo|))
		(t
		 (setq tr-abort t)
		 nil)))

(DEFUN SPECIALP (VAR)
  (COND ((OR (OPTIONP VAR)
	     (GET VAR 'SPECIAL))
	 (IF $TRANSCOMPILE (ADDL VAR SPECIALS))
	 T)))


;;; The error message system. Crude as it is.
;;; I tell you how this aught to work:
;;; (1) All state should be in one structure, one state variable.
;;; (2) Should print out short message on-the-fly so that it
;;;     gives something to watch, and also so that it says something
;;;     if things crash.
;;; (3) Summaries on a cross-referenced per-function and per-item
;;;     should be printed at the end, as a table.
;;;     e.g.
;;;     Undefined Functions     used in
;;;     FOO                     BAR, BAZ,BOMB
;;;     FOOA                    P,Q
;;;     Undefined Variables ... same thing
;;;     Incomprehensible special forms
;;;     EV                      ....
;;;     Predicate Mode Targetting failures.
;;;     .....  -gjc

;;; The way it works now is to print too little or too much.
;;; Many items are only warned about the first time seen.
;;; However, this isn't too much of a problem when using Emacs
;;; to edit code, because searching for warned-about tokens
;;; is quick and easy.

(DEFMVAR *TR-WARN-BREAK* T
	" if in debug mode WARNINGs signaled go to lisp break loops ")

(defmacro tr-warnbreak () `(and *transl-debug* *tr-warn-break* (*break t 'transl)))


(DEFUN TR-WARNP (VAL)
       (AND VAL
	    (COND (*IN-COMPILE*
		   (MEMQ VAL '($ALL $COMPILE $COMPFILE $TRANSLATE)))
		  ((OR *IN-COMPFILE* *IN-TRANSLATE-FILE*)
		   (MEMQ VAL '($ALL $COMPFILE $TRANSLATE)))
		  (*IN-TRANSLATE*
		   (MEMQ VAL '($ALL $TRANSLATE))))))

(DEFVAR WARNED-UNDEFINED-VARIABLES NIL)

(DEFTRFUN WARN-UNDEFINED-VARIABLE (FORM)
	  (AND (TR-WARNP $TR_WARN_UNDEFINED_VARIABLE)
	       (COND ((MEMQ FORM WARNED-UNDEFINED-VARIABLES))
		     ('ELSE
		      (PUSH FORM WARNED-UNDEFINED-VARIABLES)
		      (TR-FORMAT "~%Warning-> ~:M is an undefined global variable."
				 FORM)
		      (TR-WARNBREAK)))))

(DEFTRFUN WARN-UNDECLARED (FORM &optional comment)
	  (AND (TR-WARNP $TR_WARN_UNDECLARED)
	       (COND ((MEMBER FORM *WARNED-UN-DECLARED-VARS*) T)
		     (T
		      (PUSH FORM *WARNED-UN-DECLARED-VARS*)
		      (TR-FORMAT
		       "~%WARNING-> ~:M has not been MODEDECLAREd, ~
		       taken as mode ANY."
		       FORM)
		      (cond (comment (terpri *TRANSLATION-MSGS-FILES*)
				     (princ comment *TRANSLATION-MSGS-FILES*)))
		      (tr-warnbreak)
		      NIL))))

(DEFTRFUN WARN-MEVAL (FORM &optional comment)
	  (COND ((TR-WARNP $TR_WARN_MEVAL)
		 (TR-FORMAT
		  "~%WARNING-> ~:M~
		       ~%has caused a call to the evaluator to be output,~
		       ~%due to lack of information. Code will not work compiled."
		  FORM)
		 (cond (comment (terpri *TRANSLATION-MSGS-FILES*)
				(princ comment *TRANSLATION-MSGS-FILES*)))
		 (tr-warnbreak)
		 'WARNED)))


(DEFTRFUN WARN-MODE (VAR MODE NEWMODE &optional comment)
  (COND ((EQ MODE NEWMODE))
	(T
	 (COND ((AND (TR-WARNP $TR_WARN_MODE)
		     (NOT (COVERS MODE NEWMODE))
		     (NOT (MEMBER (LIST VAR MODE NEWMODE)
				  *WARNED-MODE-VARS*)))
		(PUSH (LIST VAR MODE NEWMODE) *WARNED-MODE-VARS*)
		(TR-FORMAT
		 "~%WARNING-> Assigning variable ~:M, whose mode is ~:M,~
		 a value of mode ~:M."
		 VAR MODE NEWMODE)
		(cond (comment (terpri *TRANSLATION-MSGS-FILES*)
			       (princ comment *TRANSLATION-MSGS-FILES*)
			       ))
		(tr-warnbreak))))))

(DEFTRFUN WARN-FEXPR (FORM &optional comment)
  (COND ((AND (TR-WARNP $TR_WARN_FEXPR)
	      (NOT (MEMBER FORM *WARNED-FEXPRS*)))
	 (PUSH  FORM *WARNED-FEXPRS*)
	 (TR-FORMAT
	  "~%WARNING->~%~:M~
		       ~%is a special function without a full LISP translation~
		       ~%scheme. Use in compiled code may not work."
	  FORM
	  )
	 (cond (comment (terpri *TRANSLATION-MSGS-FILES*)
			(princ comment *TRANSLATION-MSGS-FILES*)))
	 (tr-warnbreak))))

(DEFUN MACSYMA-SPECIAL-OP-P (F)
        (GETL F '(FSUBR FEXPR MFEXPR* MFEXPR*S *FEXPR)))

(DEFUN POSSIBLE-PREDICATE-OP-P (F)
       (MEMQ F '(MNOTEQUAL MEQUAL $EQUAL
			   MGREATERP MGEQP MLESSP MLEQP)))

(DEFUN WARN-PREDICATE (FORM)
       (WARN-MEVAL
	FORM
	(COND ((ATOM FORM)
	       "This variable should be declared BOOLEAN perhaps.")
	      ((MACSYMA-SPECIAL-OP-P (CAAR FORM))
	       "Special form not handled in targeting: Transl BUG.")
	      ((POSSIBLE-PREDICATE-OP-P (CAAR FORM))
	       "Unable to assert modes of subexpressions, a call to the macsyma data base has been generated.")
	      (T
	       "TRANSLATE doesn't know predicate properties for this, a call to the macsyma data base has been generated."))))

;;;***************************************************************;;;

;;; This function is the way to call the TRANSLATOR on an expression with
;;; locally bound internal mode declarations. Result of TR-LAMBDA will be
;;; (MODE . (LAMBDA (...) (DECLARE ...) TRANSLATED-EXP))

(DEFUN TR-LOCAL-EXP (EXP &REST VARS-MODES)
  (LET ((LOC (LET ((TR-LAMBDA-PUNT-ASSIGNS T))
	       (TR-LAMBDA `((LAMBDA) ((MLIST)  ,@(DO ((L VARS-MODES (CDDR L))
						      (LL NIL (CONS (CAR L) LL)))
						     ((NULL L) LL)
						   (OR (VARIABLE-P (CAR L))
						       (BAD-VAR-WARN (CAR L)))
						   ))
				     (($MODEDECLARE)  ,@VARS-MODES)
				     ,EXP)))))
    (LET ((MODE (CAR LOC))
	  (EXP (CAR (LAST LOC)))) ;;; length varies with TRANSCOMPILE.
      (CONS MODE EXP))))

(DEFUN TR-ARGS (FORM)
       (MAPCAR #'(LAMBDA (X) (DCONVX (TRANSLATE X))) FORM))

(DEFUN DTRANSLATE (FORM) (CDR (TRANSLATE FORM)))

(DEFUN DCONV (X MODE) 
  (COND ((EQ '$FLOAT MODE) (DCONV-$FLOAT X))
	((EQ '$CRE MODE) (DCONV-$CRE X))
	(T (CDR X))))

(DEFUN DCONVX (X) 
  (IF (MEMQ (CAR X) '(RATEXPR PEXPR)) (DCONV-$CRE X) (CDR X)))

(DEFUN DCONV-$FLOAT (X)
  (COND ((MEMQ (CAR X) '($FIXNUM $NUMBER))
	 (IF (FIXP (CDR X)) (FLOAT (CDR X)) (LIST 'FLOAT (CDR X))))
	((EQ '$RATIONAL (CAR X))
	 (IFN (EQ 'QUOTE (CADR X)) `($FLOAT ,(CDR X))
	     (//$ (FLOAT (CADADR (CDR X))) (FLOAT (CADDR (CADDR X))))))
	(T (CDR X))))

(DEFUN DCONV-$CRE (X) (IF (EQ '$CRE (CAR X)) (CDR X) `(RATF ,(CDR X))))

(DEFMVAR *$ANY-MODES* '($ANY $LIST))

(DEFUN COVERS (MODE1 MODE2)
  (COND ((EQ MODE1 MODE2) T)
	((EQ '$FLOAT MODE1) (MEMQ MODE2 '($FLOAT $FIXNUM $RATIONAL)))
	((EQ '$NUMBER MODE1) (MEMQ MODE2 '($FIXNUM $FLOAT)))
	((MEMQ MODE1 *$ANY-MODES*) T)))


;;; takes a function name as input.

(DEFTRFUN TR-MFUN (NAME &AUX (*TRANSL-BACKTRACE* NIL))
	  (LET   ((DEF-FORM (CONSFUNDEF NAME NIL NIL)))
		 (COND ((NULL DEF-FORM)
			(SETQ TR-ABORT T))
		       (T
			(TR-MDEFINE-TOPLEVEL DEF-FORM)))))

;;; DEFUN
;;; All the hair here to deal with macsyma fexprs has been flushed.
;;; Right now this handles MDEFMACRO and MDEFINE. The decisions
;;; of where to put the actual properties and what kind of
;;; defuns to make (LEXPR EXPR for maclisp) are punted to the
;;; macro package.

(DEFUN TR-MDEFINE-TOPLEVEL (FORM &AUX (AND-RESTP NIL))
  (LET (( (((NAME . FLAGS) . ARGS) BODY) (CDR FORM))
	(A-ARGS) KIND OUT-FORMS)

    (DO ((ARGS ARGS (CDR ARGS))
	 ;; array functions cannot be LEXPR-like. gee.
	 ;; there is no good reason for that, except for efficiency,
	 ;; and I know that efficiency was not a consideration.
	 (FULL-RESTRICTED-FLAG (OR (EQ NAME 'MQAPPLY)
				   (MEMQ 'ARRAY FLAGS))))
	((NULL ARGS) (SETQ A-ARGS (NREVERSE A-ARGS)))
      (LET ((U (CAR ARGS)))
	(COND ((ATOM U)
	       (PUSH U A-ARGS))
	      ((AND (NOT FULL-RESTRICTED-FLAG)
		    (NOT AND-RESTP)
		    (EQ (CAAR U) 'MLIST)
		    (CDR U) (ATOM (CADR U)))
	       (PUSH (CADR U) A-ARGS)
	       (SETQ AND-RESTP T))
	      (T
	       (PUSH TR-UNIQUE A-ARGS)))))

    
    (COND ((EQ NAME 'MQAPPLY)
	   ;; don't you love syntax!
	   ;; do a switch-a-roo here. Calling ourselves recursively
	   ;; like this allows all legal forms and also catches
	   ;; errors. However, certain generalizations are also
	   ;; allowed. They won't get passed the interpreter, but
	   ;; interesting things may happen here. Thats what you
	   ;; get from too much syntax, so don't sweat it.
	   (TR-MDEFINE-TOPLEVEL
	    `(,(CAR FORM) ,(CAR ARGS)
			  ((LAMBDA) ((MLIST) ,@(CDR ARGS)) ,BODY))))
	  ((MEMQ TR-UNIQUE A-ARGS)
	   (TR-TELL "Bad argument list for a function to translate->"
		    `((MLIST),@ARGS))
	   (SETQ TR-ABORT T)
	   NIL)
	  ((MEMQ (CAAR FORM) '(MDEFINE MDEFMACRO))
	   (SETQ KIND (COND ((EQ (CAAR FORM) 'MDEFMACRO) 'MACRO)
			    ((MEMQ 'ARRAY FLAGS) 'ARRAY)
			    (T 'FUNC)))
	   (LET* ((T-FORM
		   (TR-LAMBDA `((LAMBDA)
				((MLIST) ,@A-ARGS) ,BODY)))
		  (DESC-HEADER
		   `(,NAME ,(CAR T-FORM) ,(CAAR FORM)
			   ,AND-RESTP ,(EQ KIND 'ARRAY))))
	     (COND ((EQ KIND 'FUNC)
		    (PUSH-PRE-TRANSL-FORM
		     `(DEFMTRFUN-EXTERNAL ,DESC-HEADER))
		    (AND (NOT (MEMQ (CAR T-FORM) '($ANY NIL)))
			 (PUTPROP NAME (CAR T-FORM) 'FUNCTION-MODE)))
		   ((EQ KIND 'ARRAY)
		    (AND (NOT (MEMQ (CAR T-FORM) '($ANY NIL)))
			 (DECMODE-ARRAYFUN NAME (CAR T-FORM)))))

	     (COND ((OR *IN-TRANSLATE* (NOT $PACKAGEFILE))
				; These are all properties which tell the
				; user that functions are in the environment,
				; and that also allow him to SAVE the functions.
		    (PUSH `(DEFPROP ,NAME T TRANSLATED) OUT-FORMS)
		    (PUSH `(ADD2LNC ',NAME $PROPS) OUT-FORMS)
		    (COND ((EQ '$ALL $SAVEDEF)
			   (PUSH
			    `(ADD2LNC
			      '((,NAME ,@FLAGS) ,@ARGS)
			      ,(CASEQ KIND
				 (ARRAY '$ARRAYS)
				 (FUNC '$FUNCTIONS)
				 (MACRO '$MACROS))) OUT-FORMS)))))
	     (COND ((EQ '$ALL $SAVEDEF)
		    ;; For some reason one may want to save the
		    ;; interpreted definition even if in a PACKAGEFILE.
		    ;; not a good idea to use SAVEDEF anyway though.
		    (PUSH `(MDEFPROP ,NAME
				     ((LAMBDA) ((MLIST) ,@ARGS) ,BODY)
				     ,(CASEQ KIND
					(ARRAY 'AEXPR)
					(MACRO 'MMACRO)
					(FUNC 'MEXPR)))
			  OUT-FORMS)))
	     `(PROGN 'COMPILE
		     ,@(NREVERSE OUT-FORMS)
		     (DEFMTRFUN ,DESC-HEADER ,@(CDR (cdr t-FORM))))))
	  (T
	   (BARFO '?)))))


(DEFUN LISP-FCN-TYPEP (FCN TYPE)
  #-LISPM (GET FCN TYPE)
  #+LISPM (EQ TYPE (GETL-LM-FCN-PROP
		    FCN '(SUBR LSUBR FSUBR EXPR LEXPR FEXPR MACRO))))

(DEFTRFUN TRANSLATE-FUNCTION (NAME)
       (BIND-TRANSL-STATE
	(SETQ *IN-TRANSLATE* T)
       (LET ((LISP-DEF-FORM (TR-MFUN NAME))
	     (DELETE-SUBR? (AND (GET NAME 'TRANSLATED)
				(NOT (lisp-fcn-typep NAME 'EXPR)))))
	    (COND (TR-ABORT
		   (TRFAIL NAME))
		  (T
		   (IF DELETE-SUBR? (REMPROP NAME 'SUBR))
		   (IF (MGET NAME 'TRACE) (macsyma-untrace NAME))
		   (IF (NOT $SAVEDEF) (MEVAL `(($REMFUNCTION) ,NAME)))
		   (LET ((LISP-ACTION
			  ; apply EVAL so it is easy to TRACE.
			  ; ERRSET is crude, but...
			  (ERRSET (APPLY 'EVAL (LIST LISP-DEF-FORM)))))
			(COND ((NOT LISP-ACTION)
			       (TRFAIL NAME))
			      (T NAME))))))))

(DEFUN TRFAIL (X) (TR-TELL X " failed to translate.") NIL)


;;; should macsyma batch files support INCLUDEF? No, not needed
;;; and not as efficient for loading declarations, and macros 
;;; as simple LOADING is. Thats why there is EVAL_WHEN.

(DEFTRFUN TRANSLATE-MACEXPR-ACTUAL (FORM FILEPOS)
       ;; Called as the EVAL-PRINT part of the READ-EVAL-PRINT
       (IF (AND (NOT (ATOM FORM)) (SYMBOLP (CAAR FORM)))
	   (LET ((P (GET (CAAR FORM) 'TAGS)))
		;; So we can generate a tags file as we translate,
		;; this is an incredibly efficient way to do it
		;; since the incremental cost is almost nothing.
		(IF P (FUNCALL P FORM FILEPOS))))
       (PRINT* (TRANSLATE-MACEXPR-TOPLEVEL FORM))
       (TERPRI*))

(DEFMFUN TRANSLATE-AND-EVAL-MACSYMA-EXPRESSION (FORM)
	 ;; this is the hyper-random entry to the transl package!
	 ;; it is used by MLISP for TRANSLATE:TRUE ":=".
	 (bind-transl-state
	  (setq *in-translate* t)
	  ;; Use FUNCALL so that we can be sure we can TRACE this even when
	  ;; JPG sets PURE to NIL. Also, use a function named TRANSLATOR-EVAL
	  ;; so we don't have to lose badly by tracing EVAL!
	  (FUNCALL (PROGN 'TRANSLATOR-EVAL)
		   (FUNCALL (PROGN 'TRANSLATE-MACEXPR-TOPLEVEL) FORM))))

(DEFUN TRANSLATOR-EVAL (X) (EVAL X))

(DEFUN APPLY-IN$BIND_DURING_TRANSLATION (F FORM &REST L)
  (COND ((NOT ($LISTP (CADR FORM)))
	 (TR-FORMAT "Badly formed BIND_DURING_TRANSLATION variable list.~%~:M"
		    (CADR FORM))
	 (LEXPR-FUNCALL F FORM L))
	('ELSE
	 (DO ((L (CDR (CADR FORM)) (CDR L))
	      (VARS NIL)
	      (VALS NIL))
	     ((NULL L)
	      (MBINDING (VARS VALS '$BIND_DURING_TRANSLATION)
			(LEXPR-FUNCALL F FORM L)))
	   (LET ((P (CAR L)))
	     (COND ((ATOM P) (PUSH P VARS) (PUSH (MEVAL P) VALS))
		   ((EQ (CAAR P) 'MSETQ)
		    (PUSH (CADR P) VARS) (PUSH (MEVAL (CADDR P)) VALS))
		   ('ELSE
		    (tr-FORMAT
		     "Badly formed BIND_DURING_TRANSLATION binding~%~:M"
		     P))))))))

(DEFMFUN TRANSLATE-MACEXPR-TOPLEVEL (FORM &AUX (*TRANSL-BACKTRACE* NIL)
					  TR-ABORT)
	 ;; there are very few top-level special cases, I don't
	 ;; think it would help the code any to generalize TRANSLATE
	 ;; to target levels.
	 (SETQ FORM (TOPLEVEL-OPTIMIZE FORM))
	 (COND ((ATOM FORM) NIL)
	       ((EQ (CAAR FORM) '$BIND_DURING_TRANSLATION)
		(APPLY-IN$BIND_DURING_TRANSLATION
		 #'(LAMBDA (FORM) 
		     `(PROGN
		       'COMPILE
		       ,@(MAPCAR 'TRANSLATE-MACEXPR-TOPLEVEL (CDDR FORM))))
		 FORM))
	       ((EQ (CAAR FORM) '$EVAL_WHEN)
		(LET ((WHENS (CADR FORM))
		      (BODY (CDDR FORM)))
		     (SETQ WHENS (COND (($LISTP WHENS) (CDR WHENS))
				       ((ATOM WHENS) (LIST WHENS))
				       (T
					(TR-TELL "Bad EVAL-WHEN times"
					      (CADR FORM))
					NIL)))
		     (COND ((MEMQ '$TRANSLATE WHENS)
			    (MAPC 'MEVAL BODY)))
		     (COND ((MEMQ '$LOADFILE WHENS)
			    `(PROGN 'COMPILE
				    ,@(MAPCAR 'TRANSLATE-MACEXPR-TOPLEVEL BODY)))
			   ((MEMQ '$COMPILE WHENS)
			    ;; strictly for the knowledgeable user.
			    ;; I.E. so I can use EVAL_WHEN(COMPILE,?SPECIALS:TRUE)
			    `(EVAL-WHEN
			      (COMPILE)
			      ,@(MAPCAR 'TRANSLATE-MACEXPR-TOPLEVEL BODY))))))
	       ((MEMQ (CAAR FORM) TRANSLATE-TIME-EVALABLES)
		(MEVAL1 FORM)
		`(MEVAL* ',FORM))
	       ((MEMQ  (CAAR FORM) '(MDEFINE MDEFMACRO))
		(LET ((NAME (CAAADR FORM))
		      (TRL))
		     (TR-FORMAT
			      "~%Translating: ~:@M"
			      NAME)
		     (SETQ TRL (TR-MDEFINE-TOPLEVEL FORM))
		     (COND (TR-ABORT
			    (TR-FORMAT
				     "~%~:@M failed to Translate.  Continuing..."
				     NAME)
			    `(MEVAL* ',FORM))
			   (T TRL))))
	       ((EQ 'MPROGN (CAAR FORM))
		;; flatten out all PROGN's of course COMPLR needs PROGN 'COMPILE to
		;; tell it to flatten. I don't really see the use of that since one
		;; almost allways wants to. flatten.
		;; note that this ignores the $%% crock.
		`(PROGN 'COMPILE
			,@(MAPCAR #'TRANSLATE-MACEXPR-TOPLEVEL (CDR FORM))))
	       (T
		(LET  ((T-FORM (DTRANSLATE FORM)))
		      (COND (TR-ABORT
			     `(MEVAL* ',FORM))
			    (T
			     T-FORM))))))



(DEFMVAR $TR_OPTIMIZE_MAX_LOOP 100.
	 "The maximum number of times the macro-expansion and optimization
	 pass of the translator will loop in considering a form.
	 This is to catch macro expansion errors, and non-terminating
	 optimization properties.")

(DEFUN TOPLEVEL-OPTIMIZE (FORM)
       ;; it is vital that optimizations be done within the
       ;; context of variable meta bindings, declarations, etc.
       ;; Also: think about calling the simplifier here.
       (COND ((ATOM FORM)
	      (COND ((SYMBOLP FORM)
		     (LET ((V (GETL (MGET FORM '$PROPS) '($CONSTANT))))
			  (IF V (CADR V) FORM)))
		    (T FORM)))
	     ('ELSE
	      (DO ((NEW-FORM)
		   (KOUNT 0 (1+ KOUNT)))
		  ;; tailrecursion should always arrange for a counter
		  ;; to check for mobylossage.
		  ((> KOUNT $TR_OPTIMIZE_MAX_LOOP)
		   (TR-FORMAT
		    "~%Looping over ~A times in optimization of call to ~:@M~
		    ~%macro expand error likely so punting at this level."
		    $TR_OPTIMIZE_MAX_LOOP (CAAR FORM))
		   FORM)
		  (SETQ NEW-FORM (TOPLEVEL-OPTIMIZE-1 FORM))
		  (COND ((ATOM NEW-FORM)
			 (RETURN (TOPLEVEL-OPTIMIZE NEW-FORM)))
			((EQ NEW-FORM FORM)
			 (RETURN FORM))
			(T
			 (SETQ FORM NEW-FORM)))))))

(DEFUN TOPLEVEL-OPTIMIZE-1 (FORM &AUX (OP (CAR FORM)) PROP)
       (COND ((MEMQ 'ARRAY OP) FORM)
	     ((PROGN (SETQ OP (CAR OP))
		     (SETQ PROP
			   (IF $TRANSRUN		; crock a minute.
			       (OR (GET OP 'TRANSLATED-MMACRO)
				   (MGET OP 'MMACRO))
			       (OR (MGET OP 'MMACRO)
				   (GET OP 'TRANSLATED-MMACRO)))))
	      (MMACRO-APPLY PROP FORM))
	     ((SETQ PROP ($GET OP '$OPTIMIZE))
	      ;; interesting, the MAPPLY here causes the simplification
	      ;; of the form and the result.
	      ;; The optimize property can be used to implement
	      ;; such niceties as the $%% crock.
	      (MAPPLY PROP (LIST FORM) "an optimizer property"))
	     ((AND ($GET OP '$TRANSLOAD)
		   (GET OP 'AUTOLOAD)
		   ;; check for all reasonable definitions,
		   ;; $OPTIMIZE and MACRO already checked.
		   (NOT (OR (GET-LISP-FUN-TYPE OP)
			    (GETL OP '(TRANSLATE MFEXPR* MFEXPR*S
						 FSUBR FEXPR *FEXPR
						 MACRO
						 ;; foobar?
						 ))
			    (MGETL OP '(MEXPR)))))
	      (LOAD-FUNCTION OP T)
	      ;; to loop.
	      (CONS (CAR FORM) (CDR FORM)))
	     (T FORM)))

(DEFTRFUN TRANSLATE (FORM)
	  (AND *TRANSL-DEBUG* (PUSH FORM *TRANSL-BACKTRACE*))
	  (SETQ FORM (TOPLEVEL-OPTIMIZE FORM))
	  (AND *TRANSL-DEBUG* (POP *TRANSL-BACKTRACE*))
	  (PROG2
	   (AND *TRANSL-DEBUG* (PUSH FORM *TRANSL-BACKTRACE*))
	   (COND ((ATOM FORM)
		  (TRANSLATE-ATOM FORM))
		 ((EQ (TYPEP FORM) 'LIST)
		  (TRANSLATE-FORM FORM))
		 (T
		  (BARFO "help")))
	   ;; hey boy, reclaim that cons, just don't pop it!
	   (AND *TRANSL-DEBUG* (POP *TRANSL-BACKTRACE*))))

(DEFUN TRANSLATE-ATOM (FORM &AUX TEMP)
       (COND ((NUMBERP FORM) (CONS (TR-CLASS FORM) FORM))
	     ((SETQ TEMP (ASSQ FORM BOOLEAN-OBJECT-TABLE))
	      (CDR TEMP))
	     ((AND (SETQ TEMP (MGET FORM '$NUMER)) $TR_NUMER)
	      `($FLOAT . ,TEMP))
	     ((SETQ TEMP (IMPLIED-QUOTEP FORM))
	      `($ANY . ',TEMP))
	     ((TBOUNDP FORM)
	      (SPECIALP FORM) ;; notes its usage if special.
	      (SETQ FORM (TEVAL FORM))
	      `(,(VALUE-MODE FORM) . ,FORM))
	     (T
	      (COND ((NOT (SPECIALP FORM))
		     (WARN-UNDEFINED-VARIABLE FORM)
		     (IF $TRANSCOMPILE (ADDL FORM SPECIALS))))
	      ;; note that the lisp analysis code must know that
	      ;; the TRD-MSYMEVAL form is a semantic variable.
	      (LET* ((MODE (VALUE-MODE FORM))		
		     (INIT-VAL (ASSQ MODE MODE-INIT-VALUE-TABLE)))
		    (SETQ INIT-VAL (COND (INIT-VAL (CDR INIT-VAL))
					 (T `',FORM)))
		    ;; in the compiler TRD-MSYMEVAL doesn't do a darn
		    ;; thing, but it provides dynamic initialization of
		    ;; variables in interpreted code which is translated
		    ;; in-core. In FILE loaded code the DEFVAR will take
		    ;; care of this.
		    (PUSH-DEFVAR FORM INIT-VAL)
		    `(,MODE . (TRD-MSYMEVAL ,FORM ,INIT-VAL))))))

(DEFUN TRANSLATE-FORM (FORM &AUX TEMP)
       (COND ((NOT (ATOM (CAAR FORM)))
	      ;; this is a check like that in the simplifier. form could
	      ;; result from substitution macros.
	      (TRANSLATE `((MQAPPLY) ,(CAAR FORM) . ,(CDR FORM))))
	     ((MEMQ 'ARRAY (CDAR FORM))
	      ;; dispatch this bad-boy to another module quick.
	      (TR-ARRAYCALL FORM))
	     ;; TRANSLATE properties have priority.
	     ((SETQ TEMP (GET (CAAR FORM) 'TRANSLATE))
	      ;; TPROP-CALL is a macro, think of it as FUNCALL.
	      ;; see the macro file if you are curious.
	      (TPROP-CALL TEMP FORM))

	     ((SETQ TEMP (GET-LISP-FUN-TYPE (CAAR FORM)))
	      (TR-LISP-FUNCTION-CALL FORM TEMP))
	     
	     ((SETQ TEMP (MACSYMA-SPECIAL-OP-P (CAAR FORM)))
	      ;; a special form not handled yet! foobar!
	      (attempt-translate-random-special-op form temp))

	     ((getl (caar form) '(noun operators))
	      ;; puntastical case. the weird ones are presumably taken care
	      ;; of by TRANSLATE properties by now.
	      (TR-INFAMOUS-NOUN-FORM FORM))
	
	     ;; "What does a macsyma function call mean?".
	     ;; By the way, (A:'B,B:'C,C:'D)$ A(3) => D(3)
	     ;; is not supported.
	     (t
	      (tr-macsyma-user-function-call (caar form) (cdr form) form))))



(DEFMVAR $TR_BOUND_FUNCTION_APPLYP T)

(defun tr-macsyma-user-function-call (function args form)
       ;; this needs some work, output load-time code to
       ;; check for MMACRO properties, etc, to be really
       ;; foolproof.
       (cond ((EQ $TR_FUNCTION_CALL_DEFAULT '$APPLY)
	      (TRANSLATE `(($APPLY)  ,(CAAR FORM) ((MLIST) ,@(CDR FORM)))))
	     ((EQ $TR_FUNCTION_CALL_DEFAULT '$EXPR)
	      (TR-LISP-FUNCTION-CALL FORM 'SUBR))
	     
	     ((EQ $TR_FUNCTION_CALL_DEFAULT '$GENERAL)
	      (cond 
	     ;;; G(F,X):=F(X+1); case.
	     
	       ((AND $TR_BOUND_FUNCTION_APPLYP (tboundp function))
		(let ((new-form `(($apply) ,function ((mlist) ,@args))))
		     (TR-TELL function
			   "in the form "
			   form
			   "has been used as a function, yet is a bound variable"
			   "in this context. This code being translated as :"
			   new-form)
		     (translate new-form)))
	       ;; MFUNCTION-CALL cleverely punts this question to a FSUBR in the
	       ;; interpreter, and a macro in the compiler. This is good style,
	       ;; if a user is compiling then assume he is less lossage prone.
	       (t
		(CALL-AND-SIMP
		 (FUNCTION-MODE (CAAR FORM))
		 'MFUNCTION-CALL `(,(CAAR FORM) ,@(TR-ARGS args))))))
	     (T
	      ;; This case used to be the most common, a real loser.
	      (WARN-MEVAL FORM)
	      `(,(FUNCTION-MODE (CAAR FORM)) . (MEVAL ',FORM)))))

(DEFUN ATTEMPT-TRANSLATE-RANDOM-SPECIAL-OP (FORM TYPEL)
  ;; da,da,da,da.
  (WARN-FEXPR FORM)
  `($ANY . (MEVAL ',(TRANSLATE-ATOMS FORM))))




(DEFUN TR-LISP-FUNCTION-CALL (FORM TYPE)
       (LET ((OP (CAAR FORM)) (MODE) (ARGS))
	    (SETQ ARGS (COND ((MEMQ TYPE '(SUBR LSUBR EXPR))
			      (IF $TRANSCOMPILE
				  (CASEQ TYPE
				    ((SUBR) (ADDL OP EXPRS))
				    ((LSUBR) (ADDL OP LEXPRS))
				    (T NIL)))
			      (MAPCAR '(LAMBDA (L) (DCONVX (TRANSLATE L)))
				      (CDR FORM)))
			     (T
			      (IF $TRANSCOMPILE (ADDL OP FEXPRS))
			      (MAPCAR 'DTRANSLATE (CDR FORM))))
		  MODE (FUNCTION-MODE OP))
	    (CALL-AND-SIMP MODE OP ARGS)))


(DEFUN GET-LISP-FUN-TYPE (FUN &AUX TEMP)
       ;; N.B. this is Functional types. NOT special-forms,
       ;; lisp special forms are meaningless to macsyma.
       (COND ((GET FUN '*LEXPR) 'LSUBR)
	     ((GET FUN '*EXPR) 'SUBR)
	     ;; *LEXPR & *EXPR gotten from DEFMFUN declarations
	     ;; which is loaded by TrData.
	     ((MGET FUN '$FIXED_NUM_ARGS_FUNCTION)
	      'SUBR)
	     ((MGET FUN '$VARIABLE_NUM_ARGS_FUNCTION)
	      'LSUBR)
	     ((SETQ TEMP #+LISPM (GETL-LM-FCN-PROP FUN '(EXPR SUBR LSUBR))
		         #-LISPM (GETL FUN '(EXPR SUBR LSUBR)))
	      (CAR TEMP))
	     (T NIL)))

(DEFUN TR-INFAMOUS-NOUN-FORM (FORM)
       ;; 'F(X,Y) means noun-form. The arguments are evaluated.
       ;;  but the function is cons on, not applied.
       ;;  N.B. for special forms and macros this is totally wrong.
       ;;  But, those cases are filtered out already, presumably.
       
       (LET ((OP (COND ((MEMQ 'ARRAY (CAAR FORM))
			`(,(CAAR FORM) ARRAY))
		       (T `(,(CAAR FORM)))))
	     (ARGS (TR-ARGS (CDR FORM))))
	    `($ANY . (SIMPLIFY `(,',OP ,,@ARGS)))))



;;; Some atoms, soley by usage, are self evaluating. 

(DEFUN IMPLIED-QUOTEP (ATOM)
       (COND ((GET ATOM 'IMPLIED-QUOTEP)
	      ATOM)
	     ((= (GETCHARN ATOM 1)  #/&)    ;;; mstring hack
	      (COND ((EQ ATOM '|&**|)  ;;; foolishness. The PARSER should do this.
		     ;; Losing Fortran hackers.
		     (TR-FORMAT
			      "~%/"**/" is obsolete, use /"^/" !!!")
		     '|&^|)
		    (T ATOM)))
	     (T NIL)))

(DEFUN TRANSLATE-ATOMS (FORM)
       ;; This is an oldy moldy which tries to declare everthing
       ;; special so that calling fexpr's will work in compiled
       ;; code. What a joke.
  (COND ((ATOM FORM)
	 (COND ((OR (NUMBERP FORM) (MEMQ FORM '(T NIL))) FORM)
	       ((TBOUNDP FORM)
		(IF $TRANSCOMPILE
		    (or (specialp form)
			(addl form specials)))
		FORM)
	       (T
		(IF $TRANSCOMPILE (ADDL FORM SPECIALS))
		FORM)))
	((EQ 'MQUOTE (CAAR FORM)) FORM)
	(T (CONS (CAR FORM) (MAPCAR 'TRANSLATE-ATOMS (CDR FORM))))))


;;; the Translation Properties. the heart of TRANSL.

;;; This conses up the call to the function, adding in the
;;; SIMPLIFY i the mode is $ANY. This should be called everywhere.
;;; instead of duplicating the COND everywhere, as is done now in TRANSL.

(DEFUN TR-NOSIMPP (OP)
       (COND ((ATOM OP)
	      (GET OP 'TR-NOSIMP))
	     (T NIL)))

(DEFUN CALL-AND-SIMP (MODE FUN ARGS)
       (COND ((OR (NOT (EQ MODE '$ANY))
		  (TR-NOSIMPP FUN))
	      `(,MODE ,FUN . ,ARGS))
	     (T
	      `(,MODE SIMPLIFY (,FUN . ,ARGS)))))


(DEF%TR $BIND_DURING_TRANSLATION (FORM)
  (APPLY-IN$BIND_DURING_TRANSLATION
   #'(LAMBDA (FORM)
       (TRANSLATE `((MPROGN) ,@(CDDR FORM))))
   FORM))

(DEF%TR $DECLARE (FORM)
  (DO ((L (CDR FORM) (CDDR L)) (NL))
      ((NULL L) (IF NL `($ANY $DECLARE . ,(NREVERSE NL))))
      (COND ((NOT (EQ '$SPECIAL (CADR L)))
	     (SETQ NL (CONS (CADR L) (CONS (CAR L) NL))))
	    ((ATOM (CAR L)) (SPEC (CAR L)))
	    (T (MAPCAR 'SPEC (CDAR L))))))

(DEFUN SPEC (VAR)
  (ADDL VAR SPECIALS)
  (PUTPROP VAR T 'SPECIAL)
  (PUTPROP VAR VAR 'TBIND))


(DEF%TR $EVAL_WHEN (FORM)
	(TR-TELL
	 "EVAL_WHEN can only be used at top level in a file"
	 FORM
	 "it cannot be used inside an expression or function.")
	(SETQ TR-ABORT T)
	'($ANY . NIL))

(DEF%TR MDEFINE (FORM) ;; ((MDEFINE) ((F) ...) ...)
  (TR-FORMAT
   "A definition of the function ~:@M is given inside a program.~
   ~%This doesn't work well, try using LAMBDA expressions instead.~%"
   (CAAR (CADR FORM)))
  `($ANY . (MEVAL ',FORM)))

(DEF%TR MDEFMACRO (FORM)
  (TR-FORMAT "A definiton of a macro ~:@M is being given inside the~
	     ~%body of a function or expression. This probably isn't going~
	     ~%to work, local macro definitions are not supported.~%"
	     (CAAR (CADR FORM)))
  (MEVAL FORM)
  `($ANY . (MEVAL ',FORM)))

(DEF%TR $LOCAL (FORM)
  (COND (LOCAL (TR-FORMAT
			"Too many LOCAL statements in one block")
	       (SETQ TR-ABORT T))
	(T (SETQ LOCAL T)))
  (CONS NIL (CONS 'MLOCAL (CDR FORM))))

(DEF%TR MQUOTE (FORM) (LIST (TR-CLASS (CADR FORM)) 'QUOTE (CADR FORM)))



(DEFUN TR-LAMBDA (FORM &OPTIONAL (TR-BODY #'TR-SEQ) &REST TR-BODY-ARGL
		       &AUX
		       (ARGLIST (MPARAMS (CADR FORM)))
		       (EASY-ASSIGNS NIL))
  ;; This function is defined to take a simple macsyma lambda expression and
  ;; return a simple lisp lambda expression. The optional TR-BODY hook
  ;; can be used for translating other special forms that do lambda binding.
  
  ;; Local SPECIAL declarations are not used because
  ;; the multics lisp compiler does not support them. They are of course
  ;; a purely syntactic construct that doesn't buy much. I have been
  ;; advocating the use of DEFINE_VARIABLE in macsyma user programs so
  ;; that the use of DECLARE(FOO,SPECIAL) will be phased out at that level.

  (MAPC #'TBIND ARGLIST)
  (LET (((mode . nbody) (LEXPR-FUNCALL TR-BODY (cddr form) TR-BODY-ARGL))
	(LOCAL-DECLARES (MAKE-DECLARES ARGLIST T)))
    ;; -> BINDING of variables with ASSIGN properties may be difficult to
    ;; do correctly and efficiently if arbitrary code is to be run.
    (IF (OR TR-LAMBDA-PUNT-ASSIGNS
	    (DO ((L ARGLIST (CDR L)))
		((NULL L) T)
	      (LET* ((VAR (CAR L))
		     (ASSIGN (GET VAR 'ASSIGN)))
		(IF ASSIGN
		    (COND ((MEMQ ASSIGN '(ASSIGN-MODE-CHECK))
			   (PUSH `(,ASSIGN ',VAR ,(TEVAL VAR)) EASY-ASSIGNS))
			  (T
			   (RETURN NIL)))))))
	;; Case with EASY or no ASSIGN's
	`(,MODE . (LAMBDA ,(TUNBINDS ARGLIST)
		    ,LOCAL-DECLARES
		    ,@EASY-ASSIGNS
		    ,@NBODY))
	;; Case with arbitrary ASSIGN's.
	(LET ((TEMPS (MAPCAR #'(LAMBDA (IGNORE) (TR-GENSYM)) ARGLIST)))
	  `(,MODE . (LAMBDA ,TEMPS
		      (UNWIND-PROTECT
			(PROGN
			  ;; [1] Check before binding.
			  ,@(MAPCAN #'(LAMBDA (VAR VAL)
					(LET ((ASSIGN (GET VAR 'ASSIGN)))
					  (IF ASSIGN
					      (LIST `(,ASSIGN ',VAR ,VAL)))))
				    ARGLIST TEMPS)
			  ;; [2] do the binding.
			  ((LAMBDA ,(TUNBINDS ARGLIST)
			     ,LOCAL-DECLARES
			     ,@NBODY)
			   ,@TEMPS))
			;; [2] check when unbinding too.
			,@(MAPCAN #'(LAMBDA (VAR)
				      (LET ((ASSIGN (GET VAR 'ASSIGN)))
					(IF ASSIGN
					    (LIST `(,ASSIGN ',VAR
							    ;; use DTRANSLATE to
							    ;; catch global
							    ;; scoping if any.
							    ,(DTRANSLATE VAR))))))
				  ARGLIST))))))))

(DEFUN UPDATE-GLOBAL-DECLARES ()
   (DO ((L ARRAYS (CDR L)) (MODE))
       ((NULL L))
       (SETQ MODE (Array-MODE (CAR L)))
       (COND ((EQ '$FIXNUM MODE)
	      (ADDL `(ARRAY* (FIXNUM (,(CAR L) 1))) DECLARES))
	     ((EQ '$FLOAT MODE)
	      (ADDL `(ARRAY* (FLONUM (,(CAR L) 1))) DECLARES))))
   (IF SPECIALS (ADDL `(SPECIAL ,@SPECIALS) DECLARES))
   (IF SPECIALS
       (SETQ DECLARES (NCONC (CDR (MAKE-DECLARES SPECIALS NIL)) DECLARES)))
   (IF LEXPRS (ADDL `(*LEXPR . ,(REVERSE LEXPRS)) DECLARES))
   (IF FEXPRS (ADDL `(*FEXPR . ,(REVERSE FEXPRS)) DECLARES)))

(DEFUN MAKE-DECLARES (VARLIST LOCALP &AUX (DL) (FX) (FL))
  (WHEN $TRANSCOMPILE
	(DO ((L VARLIST (CDR L))
	     (MODE) (VAR))
	    ((NULL L))
	  (when (OR (NOT LOCALP)
		    (NOT (GET (CAR L) 'SPECIAL)))
		;; don't output local declarations on special variables.
		(SETQ VAR (TEVAL (CAR L)) MODE (VALUE-MODE VAR))
		(COND ((EQ '$FIXNUM MODE) (ADDL VAR FX))
		      ((EQ '$FLOAT MODE)  (ADDL VAR FL)))))
	(IF FX (ADDL `(FIXNUM  . ,FX) DL))
	(IF FL (ADDL `(FLONUM  . ,FL) DL))
	(IF DL `(DECLARE . ,DL))))

(DEF%TR DOLIST (FORM) (TRANSLATE `((MPROGN) . ,(CDR FORM))))

(defun tr-seq (l)
  (do ((mode nil)
       (body nil))
      ((null l)
       (cons mode (nreverse body)))
    (let ((exp (translate (pop l))))
      (setq mode (car exp))
      (push (cdr exp) body))))

(def%tr mprogn (form)
  (setq form (tr-seq (cdr form)))
  (cons (car form) `(progn ,@(cdr form))))
	


(DEF%tr MPROG (FORM)
  (LET (ARGLIST BODY VAL-LIST)
    ;; [1] normalize the MPROG syntax.
    (COND (($LISTP (CADR FORM))
	   (SETQ ARGLIST (CDADR FORM)
		 BODY (CDDR FORM)))
	  (T
	   (SETQ ARGLIST NIL
		 BODY (CDR FORM))))
    (COND ((NULL BODY)
	   (TR-FORMAT "A BLOCK with no body: ~:M" FORM)
	   (SETQ BODY '(((MQUOTE) $DONE)))))
    (SETQ VAL-LIST (MAPCAR #'(LAMBDA (U)
			       (IF (ATOM U) U
				   (TRANSLATE (CADDR U))))
			   ARGLIST)
	  ARGLIST (MAPCAR #'(LAMBDA (U)
			      ;;  X or ((MSETQ) X Y)
			      (IF (ATOM U) U (CADR U)))
			  ARGLIST))
    (SETQ FORM
	  (TR-LAMBDA
	   ;; [2] call the lambda translator.
	   `((LAMBDA) ((MLIST) ,@ARGLIST) ,@BODY)
	   ;; [3] supply our own body translator.
	   #'TR-MPROG-BODY
	   VAL-LIST
	   ARGLIST))
    (CONS (CAR FORM) `(,(CDR FORM) ,@VAL-LIST))))

(DEFUN TR-MPROG-BODY (BODY VAL-LIST ARGLIST
			   &AUX 
			   (INSIDE-MPROG T)
			   (RETURN-MODE NIL)
			   (NEED-PROG? NIL)
			   (RETURNS NIL) ;; not used but must be bound.
			   (LOCAL NIL)
			   )
  (DO ((L NIL))
      ((NULL BODY)
       ;; [5] hack the val-list for the mode context.
       ;; Perhaps the only use of the function MAP in all of macsyma.
       (MAP #'(LAMBDA (VAL-LIST ARGLIST)
		(COND ((ATOM (CAR VAL-LIST))
		       (RPLACA VAL-LIST
			       (OR (CDR (ASSQ (VALUE-MODE
					       (CAR ARGLIST))
					      MODE-INIT-VALUE-TABLE))
				   `',(CAR ARGLIST))))
		      (T
		       (WARN-MODE (CAR ARGLIST)
				  (VALUE-MODE (CAR ARGLIST))
				  (CAR (CAR VAL-LIST))
				  "IN a BLOCK statement")
		       (RPLACA VAL-LIST (CDR (CAR VAL-LIST))))))
	    VAL-LIST ARGLIST)
       (SETQ L (NREVERSE L))
       (CONS RETURN-MODE
	     (IF NEED-PROG?
		 `((PROG () ,@(DELETE NIL L)))
		 L)))
    ;; [4] translate a form in the body
    (LET ((FORM (POP BODY)))
      (COND ((NULL BODY)
	     ;; this is a really bad case.
	     ;; we don't really know if the return mode
	     ;; of the expression is for the value of the block.
	     ;; Some people write RETURN at the end of a block
	     ;; and some don't. In any case, the people not
	     ;; use the PROG programming style won't be screwed
	     ;; by this.
	     (SETQ FORM (TRANSLATE FORM))
	     (SETQ RETURN-MODE (*UNION-MODE (CAR FORM) RETURN-MODE))
	     (SETQ FORM (CDR FORM))
	     (IF (AND NEED-PROG?
		      (OR (ATOM FORM)
			  (NOT (EQ (CAR FORM) 'RETURN))))
		 ;; put a RETURN on just in case.
		 (SETQ FORM `(RETURN ,FORM))))
	    ((SYMBOLP FORM))
	    (T
	     (SETQ FORM (DTRANSLATE FORM))))
      (PUSH FORM L))))

(DEF%TR MRETURN (FORM)
  (IF (NULL INSIDE-MPROG)
      (TR-FORMAT "RETURN found not inside a BLOCK DO: ~%~:M" FORM))
  (SETQ NEED-PROG? T)
  (SETQ FORM (TRANSLATE (CADR FORM)))
  (SETQ RETURN-MODE (IF RETURN-MODE (*UNION-MODE (CAR FORM) RETURN-MODE)
			(CAR FORM)))
  (SETQ FORM `(RETURN ,(CDR FORM)))
  (PUSH FORM RETURNS) ;; USED by lusing MDO etc not yet re-written.
  ;; MODE here should be $PHANTOM or something.
  `($ANY . ,FORM))

(DEF%TR MGO (FORM)
  (IF (NULL INSIDE-MPROG)
      (TR-FORMAT "~%GO found not inside a BLOCK or DO. ~%~:M" FORM))
  (IF (NOT (SYMBOLP (CADR FORM)))
      (TR-FORMAT "~%GO TAG in form not symbolic.~%~:M" FORM))
  (SETQ NEED-PROG? T)
  `($ANY . (GO ,(CADR FORM))))

(DEF%TR MQAPPLY (FORM)
 (LET     ((FN (CADR FORM)) (ARGS (CDDR FORM)) 
	   (ARYP (MEMQ 'ARRAY (CDAR FORM))))
   (COND ((ATOM FN) 
	  (MFORMAT  *TRANSLATION-MSGS-FILES*
		    "~%Illegal mqapply form:~%~:M" FORM)
	  NIL)
	 ((EQ (CAAR FN) 'MQUOTE) 
	  `($ANY LIST ',(CONS (CADR FN) ARYP) ,@(TR-ARGS ARGS)))
	 ((EQ (CAAR FN) 'LAMBDA)
;; LAMBDA([X,'Y,[L]],...)(A,B,C) is a bogus form. Don't bother with it.
;; ((LAMBDA) ((MLIST) ....) ....)
	  (COND ((MEMQ 'BOGUS (MAPCAR #'(LAMBDA (ARG)
					  (COND ((OR (MQUOTEP ARG)
						     ($LISTP ARG))
						 'BOGUS)))
				      (CDR (CADR FN))))
		 (TR-FORMAT
		  "~%QUOTE or [] args are not allowed in mqapply forms.~%~
		  ~:M"
		  FORM)
		 (SETQ TR-ABORT T)
		 NIL)
		(T
		 (SETQ 	FN (TR-LAMBDA FN)
			ARGS (TR-ARGS ARGS))
		 `(,(CAR FN) ,(CDR FN) ,@ARGS))))
	 ((NOT ARYP)
	  `($ANY SIMPLIFY (MAPPLY ,(DCONVX (TRANSLATE FN))
				   (LIST ,@(TR-ARGS ARGS))
				   ',FN)))
	 (T
	  (WARN-MEVAL FORM)
	  `($ANY MEVAL ',FORM)))))



(DEF%TR MCOND (FORM) 
  (PROG (DUMMY MODE NL) 
	(SETQ DUMMY (TRANSLATE (CADDR FORM)) 
	      MODE (CAR DUMMY) 
	      NL (LIST DUMMY (TRANSLATE-PREDICATE (CADR FORM))))
	(DO L (CDDDR FORM) (CDDR L) (NULL L)
	    (COND ((AND (NOT (ATOM (CADR L))) (EQ 'MCOND (CAAADR L)))
		   (SETQ L (CDADR L))))
	    (SETQ DUMMY (TRANSLATE (CADR L)) 
		  MODE (*UNION-MODE MODE (CAR DUMMY)) 
		  NL (CONS DUMMY
			   (CONS (TRANSLATE-PREDICATE (CAR L))
				 NL))))
	(SETQ FORM NIL)
	(DO ((L NL (CDDR L))) ((NULL L))
	    (COND ((AND (EQ T (CADR L)) (NULL (CDAR L))))
		  (T (SETQ FORM
			   (CONS (CONS (CADR L)
				       (COND ((AND (NOT (ATOM (CDAR l)))
						   (CDDAR L)
						   (EQ (CADAR L) 'PROGN))
					      (NREVERSE 
					       (CONS (DCONV (CONS (CAAR L)
								  (CAR (REVERSE (CDDAR L))))
							    MODE)
						     (CDR (REVERSE (CDDAR L))))))
					     ((AND (EQUAL (CDAR L) (CADR L))
						   (ATOM (CDAR L))) NIL)
					     (T (LIST (CDR (CAR L))))))
				 FORM)))))
	(RETURN (CONS MODE (CONS 'COND FORM)))))



;; The MDO and MDOIN translators should be changed to use the TR-LAMBDA.
;; Perhaps a mere expansion into an MPROG would be best.

(DEF%TR MDO (FORM)
  (LET     (RETURNS ASSIGNS RETURN-MODE LOCAL (INSIDE-MPROG T)
		    NEED-PROG?)
    (LET   (MODE VAR INIT NEXT TEST ACTION VARMODE)
	  (SETQ VAR (COND ((CADR FORM)) (T 'MDO)))
	  (SPECIALP VAR)
	  (TBIND VAR)
	  (SETQ INIT (IF (CADDR FORM) (TRANSLATE (CADDR FORM)) '($FIXNUM . 1)))
	  (IFN (SETQ VARMODE (GET VAR 'MODE)) (DECLVALUE VAR (CAR INIT) T))
	  (SETQ NEXT (TRANSLATE (COND ((CADDDR FORM) (LIST '(MPLUS) (CADDDR FORM) VAR))
				      ((CAR (CDDDDR FORM)))
				      (T (LIST '(MPLUS) 1 VAR)))))
	  (IFN VARMODE (DECLVALUE VAR (*UNION-MODE (CAR INIT) (CAR NEXT)) T)
	       (WARN-MODE VAR VARMODE (*UNION-MODE (CAR INIT) (CAR NEXT))))
	  (SETQ TEST (TRANSLATE-PREDICATE
		      (LIST '(MOR)
			    (COND ((NULL (CADR (CDDDDR FORM))) NIL)
				  ((AND (CADDDR FORM)
					(MNEGP ($NUMFACTOR (SIMPLIFY (CADDDR FORM)))))
				   (LIST '(MLESSP) VAR (CADR (CDDDDR FORM))))
				  (T (LIST '(MGREATERP) VAR (CADR (CDDDDR FORM)))))
			    (CADDR (CDDDDR FORM)))))
	  (SETQ ACTION (TRANSLATE (CADDDR (CDDDDR FORM)))
		MODE (COND ((NULL RETURNS) '$ANY)
			   (T
			    (IF SHIT
				(DO L RETURNS (CDR L) (NULL L)
				    (RPLACA (CDAR L) (DCONV (CADAR L) RETURN-MODE))))
			      RETURN-MODE)))
	  (SETQ VAR (TUNBIND (COND ((CADR FORM)) (T 'MDO))))
	  `(,MODE DO ((,VAR ,(CDR INIT) ,(CDR NEXT)))
		  (,TEST '$DONE) . 
		  ,(COND ((ATOM (CDR ACTION)) NIL)
			 ((EQ 'PROGN (CADR ACTION)) (CDDR ACTION))
			 (T (LIST (CDR ACTION))))))))

(SETQ SHIT NIL)


(DEF%TR MDOIN (FORM)
  (LET     (RETURNS ASSIGNS RETURN-MODE LOCAL (INSIDE-MPROG T)
		    NEED-PROG?)
    (PROG (MODE VAR INIT ACTION)
	  (SETQ VAR (TBIND (CADR FORM))) (TBIND 'MDO)
	  (SPECIALP VAR)
	  (SETQ INIT (DTRANSLATE (CADDR FORM)))
	  (COND ((OR (CADR (CDDDDR FORM)) (CADDR (CDDDDR FORM)))
		 (TUNBIND 'MDO) (TUNBIND (CADR FORM))
		 (RETURN `($ANY SIMPLIFY (MDOIN . ,(CDR FORM))))))
	  (SETQ ACTION (TRANSLATE (CADDDR (CDDDDR FORM)))
		MODE (COND ((NULL RETURNS) '$ANY)
			   (T
			    (IF SHIT
				(DO L RETURNS (CDR L) (NULL L)
				    (RPLACA (CDAR L) (DCONV (CADAR L) RETURN-MODE))))
			      RETURN-MODE)))
	  (TUNBIND 'MDO) (TUNBIND (CADR FORM))
	  (RETURN
	   `(,MODE DO ((,VAR) (MDO (CDR ,INIT) (CDR MDO)))
		   ((NULL MDO) '$DONE)
		   (SETQ ,VAR (CAR MDO)) . 
		   ,(COND ((ATOM (CDR ACTION)) NIL)
			  ((EQ 'PROGN (CADR ACTION)) (CDDR ACTION))
			  (T (LIST (CDR ACTION)))))))))


(DEFUN LAMBDA-WRAP1 (TN VAL FORM)
  (IF (OR (ATOM VAL)
	  (EQ (CAR VAL) 'QUOTE))
      (SUBST VAL TN FORM)
      `((LAMBDA (,TN) ,FORM) ,VAL)))
	  
(DEF%TR MSETQ (FORM)
  (LET ((VAR (CADR FORM))
	(VAL (CADDR FORM))
	ASSIGN
	MODE)
    (COND ((ATOM VAR)
	   (SETQ MODE (VALUE-MODE VAR) VAL (TRANSLATE VAL))
	   (IFN (TBOUNDP VAR) (ADDL VAR SPECIALS))
	   (WARN-MODE VAR MODE (CAR VAL))
	   (IF (EQ '$ANY MODE)
	       (SETQ MODE (CAR VAL) VAL (CDR VAL))
	       (SETQ VAL (DCONV VAL MODE)))
	   (CONS MODE
		 (IF (SETQ ASSIGN (GET VAR 'ASSIGN))
		     (LET ((TN (TR-GENSYM)))
		       (LAMBDA-WRAP1 TN VAL `(PROGN (,ASSIGN ',VAR ,TN)
						    (SETQ ,(TEVAL VAR) ,TN))))
		     `(SETQ ,(TEVAL VAR) ,VAL))))
	  ((MEMQ 'ARRAY (CAR VAR))
	   (TR-ARRAYSETQ VAR VAL))
	  (T
	   (TR-FORMAT "~%Dubious first LHS argument to ~:@M~%~:M"
		      (CAAR FORM) VAR)
	   (SETQ VAL (TRANSLATE VAL))
	   `(,(CAR VAL) MSET ',(TRANSLATE-ATOMS VAR) ,(CDR VAL))))))



(DEF%TR $RAT (FORM)
  (COND ((NULL (CDDR FORM)) (CONS '$CRE (DCONV-$CRE (TRANSLATE (CADR FORM)))))
	(T (SETQ TR-ABORT T) (CONS '$ANY FORM))))


(DEF%TR $MAX (X) (TRANSLATE-$MAX-$MIN X))
(DEF%TR $MIN (X) (TRANSLATE-$MAX-$MIN X))
(DEF%TR %MAX (X) (TRANSLATE-$MAX-$MIN X))
(DEF%TR %MIN (X) (TRANSLATE-$MAX-$MIN X))

(DEFUN TRANSLATE-$MAX-$MIN (FORM)
  (LET   ((MODE) (ARGLIST) (OP (STRIPDOLLAR (CAAR FORM))))
	(SETQ ARGLIST 
	      (MAPCAR '(LAMBDA (L) (SETQ L (TRANSLATE L)
					 MODE (*UNION-MODE (CAR L) MODE))
			           L)
		      (CDR FORM)))
	(IF (MEMQ MODE '($FIXNUM $FLOAT $NUMBER))
	    `(,MODE  ,(IF (EQ 'MIN OP) 'MIN 'MAX) . ,(MAPCAR 'CDR ARGLIST))
	    `($ANY ,(IF (EQ 'MIN OP) 'MINIMUM 'MAXIMUM)
		    (LIST . ,(MAPCAR 'DCONVX ARGLIST))))))


;;; mode acessing, binding, handling. Super over-simplified.

(DEFUN TR-CLASS (X)
  (COND ((FIXP X) '$FIXNUM)
	((FLOATP X) '$FLOAT)
	((MEMQ X '(T NIL)) '$BOOLEAN)
	((ATOM X) '$ANY)
	((EQ 'RAT (CAAR X)) '$RATIONAL)
	(T '$ANY)))

(DEFUN *UNION-MODE (MODE1 MODE2) 
  (COND ((EQ MODE1 MODE2) MODE1)
	((NULL MODE1) MODE2)
	((NULL MODE2) MODE1)
	((MEMQ MODE2 *$ANY-MODES*) '$ANY)
	((MEMQ MODE1 *$ANY-MODES*) '$ANY)
	((EQ '$FIXNUM MODE1) MODE2)
	((EQ '$FLOAT MODE1)
	 (IF (EQ '$NUMBER MODE2) '$NUMBER '$FLOAT))
	((EQ '$RATIONAL MODE1)
	 (IF (EQ '$FLOAT MODE2) '$FLOAT '$ANY))
	((EQ '$NUMBER MODE1)
	 (IF (EQ '$RATIONAL MODE2) '$ANY '$NUMBER))
	(T '$ANY)))



(DEFUN VALUE-MODE (VAR) (COND ((GET VAR 'MODE))
			      (T
			       (WARN-UNDECLARED VAR)
			       '$ANY)))

(DEFUN DECMODE-ARRAYFUN (F M) (PUTPROP F M 'ARRAYFUN-MODE))

(DEFUN Array-MODE (AR) (COND ((GET AR 'Array-MODE)) (T '$ANY)))
(DEFUN ARRAYFUN-MODE (AR) (COND ((GET AR 'ARRAYFUN-MODE)) (T '$ANY)))
(DEFUN FUNCTION-MODE (F) (COND ((GET F 'FUNCTION-MODE)) (T '$ANY)))
(DEFUN FUNCTION-MODE-@ (F)
       (ASS-EQ-REF (GET F 'VAL-MODES) 'FUNCTION-MODE '$ANY))
(DEFUN ARRAY-MODE-@ (F)
       (ASS-EQ-REF (GET F 'VAL-MODES) 'ARRAY-MODE '$ANY))

(EVAL-WHEN (EVAL COMPILE #-PDP10 LOAD)
(DEFSTRUCT (TSTACK-SLOT #+Maclisp CONC-NAME
			#-Maclisp :CONC-NAME
			#+Maclisp TREE
			#-Maclisp :NAMED)
  MODE 
  TBIND
  VAL-MODES
  ;; an alist telling second order info
  ;; about APPLY(VAR,[X]), ARRAYAPPLY(F,[X]) etc.
  SPECIAL))

;;; should be a macro (TBINDV <var-list> ... forms)
;;; so that TUNBIND is assured, and also so that the stupid ASSQ doesn't
;;; have to be done on the darn TSTACK. This will have to wait till
;;; the basic special form translation properties are rewritten.

(DEFUN VARIABLE-P (VAR)
  (AND VAR (SYMBOLP VAR) (NOT (EQ VAR T))))

(DEFUN BAD-VAR-WARN (VAR)
  (TR-FORMAT "~%BAD object to use as a variable:~%~:M~%" VAR))

(DEFVAR $TR_BIND_MODE_HOOK NIL
  "A hack to allow users to key the modes of variables
  off of variable spelling, and other things like that.")

(DEFUN TBIND (VAR &AUX OLD)
  (COND ((VARIABLE-P VAR)
	 (SETQ OLD (MAKE-TSTACK-SLOT MODE (GET VAR 'MODE)
				     TBIND (GET VAR 'TBIND)
				     VAL-MODES (GET VAR 'VAL-MODES)
				     SPECIAL (GET VAR 'SPECIAL)))
	 (PUSH (CONS VAR OLD) TSTACK)
	 (COND ((NOT (SPECIALP VAR))
		;; It is the lisp convention in use to inherit
		;; specialness from higher context.
		;; Spurious MODEDECLARATIONS get put in the environment
		;; when code is MEVAL'd since there is no way to stack
		;; the mode properties. Certainly nobody is willing
		;; to hack MEVAL in JPG;MLISP
		(REMPROP VAR 'VAL-MODES)
		(REMPROP VAR 'MODE)
		(REMPROP VAR 'SPECIAL)))
	 (PUTPROP VAR VAR 'TBIND)
	 (IF $TR_BIND_MODE_HOOK
	     (LET ((MODE? (MAPPLY $TR_BIND_MODE_HOOK
				  (LIST VAR)
				  '$TR_BIND_MODE_HOOK)))
	       (IF MODE? (TR-DECLARE-VARMODE VAR MODE?))))
	 VAR)
	('ELSE
	 (BAD-VAR-WARN VAR))))



(DEFUN TUNBIND (VAR
		&AUX
		(OLD (ASSQ VAR TSTACK)))
  (WHEN (VARIABLE-P VAR)
	(PROG1
	 (TEVAL VAR)
	 (COND (OLD
		(SETQ TSTACK (DELQ OLD TSTACK)) ; POP should be all we need.
		(SETQ OLD (CDR OLD))
		(PUTPROP1 VAR (TSTACK-SLOT-MODE OLD) 'MODE)
		(PUTPROP1 VAR (TSTACK-SLOT-TBIND OLD) 'TBIND)
		(PUTPROP1 VAR (TSTACK-SLOT-VAL-MODES OLD) 'VAL-MODES)
		(PUTPROP1 VAR (TSTACK-SLOT-SPECIAL OLD) 'SPECIAL))))))

(DEFUN PUTPROP1 (NAME VALUE KEY)
       ;; leaves property list clean after unwinding, this
       ;; is an efficiency/storage issue only.
       (IF VALUE (PUTPROP NAME VALUE KEY) (PROGN (REMPROP NAME KEY) NIL)))

(DEFUN TUNBINDS (L)
  (DO ((NL)) ((NULL L) NL)
      (SETQ NL (CONS (TUNBIND (CAAR TSTACK)) NL) L (CDR L))))

(DEFUN TBOUNDP (VAR)
       ;; really LEXICAL-VARP.
       (AND (GET VAR 'TBIND) (NOT (GET VAR 'SPECIAL))))

(DEFUN TEVAL (VAR) (OR (GET VAR 'TBIND) VAR))



;; Local Modes:
;; Mode: LISP
;; Comment Col: 40
;; END:
