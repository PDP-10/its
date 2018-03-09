;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1982 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module merror)

;;; Macsyma error signalling. 
;;; 2:08pm  Tuesday, 30 June 1981 George Carrette.

(DEFMVAR $ERROR '((MLIST SIMP) |&No error.|)
  "During an error break this is bound to a list
  of the arguments to the call to ERROR, with the message
  text in a compact format.")

(DEFMVAR $ERRORMSG 'T
  "If FALSE then NO error message is printed!")

(DEFMFUN $ERROR (&REST L)
  "Signals a Macsyma user error."
  (apply #'merror (fstringc L)))

(DEFMVAR $ERROR_SIZE 10.
  "Expressions greater in some size measure over this value
  are replaced by symbols {ERREXP1, ERREXP2,...} in the error
  display, the symbols being set to the expressions, so that one can
  look at them with expression editing tools. The default value of
  this variable may be determined by factors of terminal speed and type.")

(DECLARE (FIXNUM (ERROR-SIZE NIL)))

(DEFUN ERROR-SIZE (EXP)
  (IF (ATOM EXP) 0
      (DO ((L (CDR EXP) (CDR L))
	   (N 1 (1+ (+ N (ERROR-SIZE (CAR L))))))
	  ((OR (NULL L)
	       ;; no need to go any further, and this will save us
	       ;; from circular structures. (Which they display
	       ;; package would have a hell of a time with too.)
	       (> N $ERROR_SIZE))
	   N)
	(DECLARE (FIXNUM N)))))

;;; Problem: Most macsyma users do not take advantage of break-points
;;; for debugging. Therefore they need to have the error variables
;;; SET (as the old ERREXP was), and not PROGV bound. The problem with
;;; this is that recursive errors will bash the old value of the
;;; error variables. However, since we do bind the value of the
;;; variable $ERROR, calling the function $ERRORMSG will always
;;; set things back. It would be better to bind these variables,
;;; for, amoung other things, then the values could get garbage 
;;; collected.

(DEFMFUN MERROR (STRING &REST L)
  (SETQ STRING (CHECK-OUT-OF-CORE-STRING STRING))
  (LET (($ERROR `((MLIST) ,STRING ,@L)))
    (AND $ERRORMSG ($ERRORMSG))
    (ERROR #+(OR LISPM NIL) STRING)))

#+LISPM
;; This tells the error handler to report the context of
;; the error as the function that called MERROR, instead of
;; saying that the error was in MERROR.
(DEFPROP MERROR T :ERROR-REPORTER)

(DEFMVAR $ERROR_SYMS '((MLIST) $ERREXP1 $ERREXP2 $ERREXP3)
  "Symbols to bind the too-large error expresssions to")

(DEFUN ($ERROR_SYMS ASSIGN) (VAR VAL)
  (IF (NOT (AND ($LISTP VAL)
		(DO ((L (CDR VAL) (CDR L)))
		    ((NULL L) (RETURN T))
		  (IF (NOT (SYMBOLP (CAR L))) (RETURN NIL)))))
      (MERROR "The variable ~M being set to ~M which is not a list of symbols."
	      VAR VAL)))

(DEFUN PROCESS-ERROR-ARGL (L)
  ;; This returns things so that we could set or bind.
  (DO ((ERROR-SYMBOLS NIL)
       (ERROR-VALUES NIL)
       (NEW-ARGL NIL)
       (SYMBOL-NUMBER 0))
      ((NULL L)
       (LIST (NREVERSE ERROR-SYMBOLS)
	     (NREVERSE ERROR-VALUES)
	     (NREVERSE NEW-ARGL)))
    (LET ((FORM (POP L)))
      (COND ((> (ERROR-SIZE FORM) $ERROR_SIZE)
	     (SETQ SYMBOL-NUMBER (1+ SYMBOL-NUMBER))
	     (LET ((SYM (NTHCDR SYMBOL-NUMBER $ERROR_SYMS)))
	       (COND (SYM
		      (SETQ SYM (CAR SYM)))
		     ('ELSE
		      (SETQ SYM (CONCAT '$ERREXP SYMBOL-NUMBER))
		      (SETQ $ERROR_SYMS (APPEND $ERROR_SYMS (LIST SYM)))))
	       (PUSH SYM ERROR-SYMBOLS)
	       (PUSH FORM ERROR-VALUES)
	       (PUSH SYM NEW-ARGL)))
	    ('ELSE
	     (PUSH FORM NEW-ARGL))))))

(DEFMFUN $ERRORMSG ()
  "ERRORMSG() redisplays the error message while in an error break."
  ;; Don't optimize out call to PROCESS-ERROR-ARGL in case of
  ;; multiple calls to $ERRORMSG, because the user may have changed
  ;; the values of the special variables controling its behavior.
  ;; The real expense here is when MFORMAT calls the DISPLA package.
  (LET ((THE-JIG (PROCESS-ERROR-ARGL (CDDR $ERROR))))
    (MAPC #'SET (CAR THE-JIG) (CADR THE-JIG))
    (CURSORPOS 'A #-LISPM NIL)
    (LET ((ERRSET NIL))
      (IF (NULL (ERRSET
		 (LEXPR-FUNCALL #'MFORMAT NIL (CADR $ERROR) (CADDR THE-JIG))))
	  (MTELL "~%** Error while printing error message **~%~A~%"
		 (CADR $ERROR)
		 )))
    (IF (NOT (ZEROP (CHARPOS T))) (MTERPRI)))
  '$DONE)

(DEFMFUN READ-ONLY-ASSIGN (VAR VAL)
  (IF MUNBINDP
      'MUNBINDP
      (MERROR "Attempting to assign read-only variable ~:M the value:~%~M"
	      VAR VAL)))

(DEFPROP $ERROR READ-ONLY-ASSIGN ASSIGN)


;; THIS THROWS TO  (*CATCH 'RATERR ...), WHEN A PROGRAM ANTICIPATES
;; AN ERROR (E.G. ZERO-DIVIDE) BY SETTING UP A CATCH  AND SETTING
;; ERRRJFFLAG TO T.  Someday this will be replaced with SIGNAL.
;; Such skill with procedure names!  I'd love to see how he'd do with
;; city streets.

;;; N.B. I think the above comment is by CWH, this function used
;;; to be in RAT;RAT3A. Its not a bad try really, one of the better
;;; in macsyma. Once all functions of this type are rounded up
;;; I'll see about implementing signaling. -GJC

(DEFMFUN ERRRJF N
  (IF ERRRJFFLAG (*THROW 'RATERR NIL) (APPLY #'MERROR (LISTIFY N))))

;;; The user-error function is called on |&foo| "strings" and expressions.
;;; Cons up a format string so that $ERROR can be bound.
;;; This might also be done at code translation time.
;;; This is a bit crude.

(defmfun fstringc (L)
  (do ((sl nil) (s) (sb)
		(se nil))
      ((null l)
       (setq sl (maknam sl))
       #+PDP10
       (putprop sl t '+INTERNAL-STRING-MARKER)
       (cons sl (nreverse se)))
    (setq s (pop l))
    (cond ((and (symbolp s) (= (getcharn s 1) #/&))
	   (setq sb (cdr (exploden s))))
	  (t
	   (push s se)
	   (setq sb (list #/~ #/M))))
    (setq sl (nconc sl sb (if (null l) nil (list #\SP))))))



#+PDP10
(PROGN 'COMPILE
       ;; Fun and games with the pdp-10. The calling sequence for
       ;; subr, (arguments passed through registers), is much smaller
       ;; than that for lsubrs. If we really where going to do a lot
       ;; of this hackery then we would define some kind of macro
       ;; for it.
       (LET ((X (GETL 'MERROR '(EXPR LSUBR))))
	 (REMPROP '*MERROR (CAR X))
	 (PUTPROP '*MERROR (CADR X) (CAR X)))
       (DECLARE (*LEXPR *MERROR))
       (DEFMFUN *MERROR-1 (A)         (*MERROR A))
       (DEFMFUN *MERROR-2 (A B)       (*MERROR A B))
       (DEFMFUN *MERROR-3 (A B C)     (*MERROR A B C))
       (DEFMFUN *MERROR-4 (A B C D)   (*MERROR A B C D))
       (DEFMFUN *MERROR-5 (A B C D E) (*MERROR A B C D E))


       (LET ((X (GETL 'ERRRJF '(EXPR LSUBR))))
	 (REMPROP '*ERRRJF (CAR X))
	 (PUTPROP '*ERRRJF (CADR X) (CAR X)))
       (DECLARE (*LEXPR *ERRRJF))
       (DEFMFUN *ERRRJF-1 (A) (*ERRRJF A))

       )
#+Maclisp
(progn 'compile
(defun m-wna-eh (((f . actual-args) args-info))
  ;; generate a nice user-readable message about this lisp error.
  ;; F may be a symbol or a lambda expression.
  ;; args-info may be nil, an args-info form, or a formal argument list.
  (merror "~M ~A to function ~A"
	  `((mlist) ,@actual-args)
	  ;; get the error messages passed as first arg to lisp ERROR.
	  (caaddr (errframe ()))
	  (if (symbolp f)
	      (if (or (equal (args f) args-info)
		      (symbolp args-info))
		  f
		  `((,f),@args-info))
	      `((lambda)((mlist),@(cadr f))))))

(defun m-wta-eh ((object))
  (merror "~A: ~A" (caaddr (errframe ())) object))

(defun m-ubv-eh ((variable))
  (merror "Unbound variable: ~A" variable))

;; TRANSL generates regular LISP function calls for functions which
;; are lisp defined at translation time, and in compiled code.
;; MEXPRs can be handled by the UUF (Undefined User Function) handler.

(DEFVAR UUF-FEXPR-ALIST ())

(DEFUN UUF-HANDLER (X)
  (LET ((FUNP (OR (MGETL (CAR X) '(MEXPR MMACRO))
		  (GETL (CAR X) '(TRANSLATED-MMACRO MFEXPR* MFEXPR*S)))))
    (CASEQ (CAR FUNP)
      ((MEXPR)
       ;; The return value of the UUF-HANDLER is put back into
       ;; the "CAR EVALUATION LOOP" of the S-EXP. It is evaluated,
       ;; checked for "functionality" and applied if a function,
       ;; otherwise it is evaluated again, unless it's atomic,
       ;; in which case it will call the UNDF-FNCTN handler again,
       ;; unless (STATUS PUNT) is NIL in which case it is
       ;; evaluated (I think). One might honestly ask
       ;; why the maclisp evaluator behaves like this. -GJC
       `((QUOTE (LAMBDA *N*
		  (MAPPLY ',(CAR X) (LISTIFY *N*) ',(CAR X))))))
      ((MMACRO TRANSLATED-MMACRO)
       (MERROR
	"Call to a macro '~:@M' which was undefined during translation."
	(CAR X)))
      ((MFEXPR* MFEXPR*S)
       ;; An call in old translated code to what was a FEXPR.
       (LET ((CELL (ASSQ (CAR X) UUF-FEXPR-ALIST)))
	 (OR CELL
	     (LET ((NAME (GENSYM)))
	       (PUTPROP NAME
			`(LAMBDA (,NAME) (MEVAL (CONS '(,(CAR X)) ,NAME)))
			'FEXPR)
	       (SETQ CELL (LIST (CAR X) NAME))
	       (PUSH CELL UUF-FEXPR-ALIST)))
	 (CDR CELL)))
      (T
       (MERROR "Call to an undefined function '~A' at Lisp level."
	       (CAR X))))))
)