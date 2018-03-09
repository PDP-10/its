;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module trans5)


(TRANSL-MODULE TRANS5)

;;; these are TRANSLATE properies for the FSUBRS in JPG;COMM >

;;; LDISPLAY is one of the most beastly of all macsyma idiot
;;; constructs. First of all it makes a variable name and sets it,
;;; but it evaluates its argument such that
;;; x:10, LDISPLAY(F(X)) gives  (E1)   F(10)= ...
;;; LDISPLAY(X) gives X=10 of course. Sometimes it evaluates to get
;;; the left hand side, and sometimes it doesn't. It has its own
;;; private fucking version of the macsyma evaluator.
;;; To see multiple evaluation lossage in the interperter, try
;;; these: LDISPLAY(F(PRINT("FOOBAR")))$

;;;Totally and absolutely FUCKED
;;;(DEFUN $LDISPLAY FEXPR (LL) (DISP1 LL T T))
;;;
;;;(DEFUN $LDISP FEXPR (LL) (DISP1 LL T NIL))
;;;
;;;(DEFUN $DISPLAY FEXPR (LL) (DISP1 LL NIL T))
;;;
;;;(DEFUN $DISP FEXPR (LL) (DISP1 LL NIL NIL))
;;;
;;;(DEFUN DISP1 (LL LABLIST EQNSP)
;;; (COND (LABLIST (SETQ LABLIST (NCONS '(MLIST SIMP)))))
;;; (DO ((LL LL (CDR LL)) (L) (ANS) ($DISPFLAG T) (TIM 0))
;;;     ((NULL LL) (OR LABLIST '$DONE))
;;;     (SETQ L (CAR LL) ANS (MEVAL L))
;;;     (COND ((AND EQNSP (OR (ATOM ANS) (NOT (EQ (CAAR ANS) 'MEQUAL))))
;;;	    (SETQ ANS (LIST '(MEQUAL) (DISP2 L) ANS))))
;;;     (COND (LABLIST (COND ((NOT (CHECKLABEL $LINECHAR)) (SETQ $LINENUM (1+ $LINENUM))))
;;;		    (MAKELABEL $LINECHAR) (NCONC LABLIST (NCONS LINELABLE))
;;;		    (COND ((NOT $NOLABELS) (SET LINELABLE ANS)))))
;;;     (SETQ TIM (RUNTIME))
;;;     (DISPLA (LIST '(MLABLE) (COND (LABLIST LINELABLE)) ANS))
;;;     (MTERPRI)
;;;     (TIMEORG TIM)))
;;;
;;;(DEFUN DISP2 (X)
;;; (COND ((ATOM X) X)
;;;       ((EQ (CAAR X) 'MQAPPLY)
;;;	(CONS '(MQAPPLY) (CONS (CONS (CAADR X) (MAPCAR 'MEVAL (CDADR X)))
;;;			       (MAPCAR 'MEVAL (CDDR X)))))
;;;       ((EQ (CAAR X) 'MSETQ) (DISP2 (CADR X)))
;;;       ((EQ (CAAR X) 'MSET) (DISP2 (MEVAL (CADR X))))
;;;       ((EQ (CAAR X) 'MLIST) (CONS (CAR X) (MAPCAR 'DISP2 (CDR X))))
;;;       ((GETL (CAAR X) '(FSUBR FEXPR)) X)
;;;       (T (CONS (CAR X) (MAPCAR 'MEVAL (CDR X))))))
;;;


(DEF%TR $DISP (FORM) 
	`($ANY . (DISPLAY-FOR-TR ,(eq (caar form) '$ldisp)
				 NIL ; equationsp
				 ,@(TR-ARGS (CDR FORM)))))
(DEF-SAME%TR $LDISP $DISP)

(DEF%TR $DISPLAY (FORM) 
	`($ANY . (DISPLAY-FOR-TR ,(EQ (CAAR FORM) '$LDISPLAY)
				 T
				 ,@(MAPCAR #'TR-EXP-TO-DISPLAY (CDR FORM)))))

(DEF-SAME%TR $LDISPLAY $DISPLAY)

;;; DISPLAY(F(X,Y,FOO()))
;;; (F X Y (FOO)) => (LET ((&G1 (FOO))) (list '(mequal) (LIST '(F) X Y &G1)
;;;   					   	              (F X Y &G1)))
;;; DISPLAY(X) => (LIST '(MEQUAL) '$X $X)
;;; DISPLAY(Q[I]) => (LIST '(MEQUAL) (LIST '(Q ARRAY) $I) ...)

;;; Ask me why I did this at lisp level, this should be able
;;; to be hacked as a macsyma macro. the brain damage I get
;;; into sometimes...

;;; This walks the translated code attempting to come up
;;; with a reasonable object for display, expressions which
;;; might have to get evaluated twice are pushed on the
;;; VALUE-ALIST (<expression> . <gensym>)
;;; This is incompatible with the interpreter which evaluates
;;; arguments to functions twice. Here I only evaluate non-atomic
;;; things once, and make sure that the order of evaluation is
;;; pretty much correct. I say "pretty much" because MAKE-VALUES
;;; does the optmization of not generating a temporary for a variable.
;;; DISPLAY(FOO(Z,Z:35)) will loose because the second argument will
;;; be evaluated first. I don't seriously expect anyone to find this
;;; bug.

(DEFVAR VALUE-ALIST NIL)
(DEFUN MAKE-VALUES (EXPR-ARGS)
       (MAPCAR #'(LAMBDA (ARG)
			 (COND ((OR (ATOM ARG)
				    (MEMQ (CAR ARG) '(TRD-MSYMEVAL QUOTE)))
				ARG)
			       (T
				(LET ((SYM (GENSYM)))
				     (PUSH (CONS ARG SYM) VALUE-ALIST)
				     SYM))))
	       EXPR-ARGS))


(EVAL-WHEN (COMPILE EVAL #-PDP10 LOAD)
(DEFSTRUCT (DISP-HACK-OB #+Maclisp TREE #-Maclisp :TREE)
  LEFT-OB RIGHT-OB)
)

(DEFUN OBJECT-FOR-DISPLAY-HACK (EXP)
       (IF (ATOM EXP)
	   (MAKE-DISP-HACK-OB LEFT-OB `',EXP RIGHT-OB EXP)
	   (CASEQ (CAR EXP)
		  (SIMPLIFY
		   (LET ((V (OBJECT-FOR-DISPLAY-HACK (CADR EXP))))
			(MAKE-DISP-HACK-OB
			 LEFT-OB (LEFT-OB V)
			 RIGHT-OB `(SIMPLIFY ,(RIGHT-OB V)))))
		  (MARRAYREF
		   (LET ((VALS (MAKE-VALUES (CDR EXP))))
			(MAKE-DISP-HACK-OB
			 LEFT-OB `(LIST (LIST* ,(CAR VALS) '(ARRAY))
					,@(CDR VALS))
			 RIGHT-OB `(MARRAYREF ,@VALS))))
		  (MFUNCTION-CALL
		   ; assume evaluation of arguments.
		   (LET ((VALS (MAKE-VALUES (CDDR EXP))))
			(MAKE-DISP-HACK-OB
			 LEFT-OB `(LIST '(,(CADR EXP)) ,@VALS)
			 RIGHT-OB `(MFUNCTION-CALL ,(CADR EXP) ,@VALS))))
		  (LIST
		   (LET ((OBS (MAPCAR #'OBJECT-FOR-DISPLAY-HACK (CDR EXP))))
			(MAKE-DISP-HACK-OB
			 LEFT-OB `(LIST ,@(MAPCAR #'(LAMBDA (U) (LEFT-OB U))
						  OBS))
			 RIGHT-OB `(LIST ,@(MAPCAR #'(LAMBDA (U) (RIGHT-OB U))
						   OBS)))))
		  (QUOTE (MAKE-DISP-HACK-OB LEFT-OB EXP RIGHT-OB EXP))
		  (TRD-MSYMEVAL
		   (MAKE-DISP-HACK-OB LEFT-OB `',(CADR EXP)
				      RIGHT-OB EXP))
		  (T
		   (COND ((OR (NOT (ATOM (CAR EXP)))
			      (GETL (CAR EXP) '(FSUBR FEXPR MACRO)))
			  (MAKE-DISP-HACK-OB  LEFT-OB `',EXP RIGHT-OB EXP))
			 (T
			  (LET ((VALS (MAKE-VALUES (CDR EXP))))
			       (MAKE-DISP-HACK-OB
				LEFT-OB `(LIST '(,(UNTRANS-OP (CAR EXP)))
					       ,@VALS)
				RIGHT-OB `(,(CAR EXP) ,@VALS)))))))))

(DEFUN TR-EXP-TO-DISPLAY (EXP)
       (LET* ((LISP-EXP (DTRANSLATE EXP))
	      (VALUE-ALIST NIL)
	      (OB (OBJECT-FOR-DISPLAY-HACK LISP-EXP))
	      (DISP `(LIST '(MEQUAL) ,(LEFT-OB OB) ,(RIGHT-OB OB))))
	     (SETQ VALUE-ALIST (NREVERSE VALUE-ALIST))
	     (IF VALUE-ALIST
		 `((LAMBDA ,(MAPCAR #'CDR VALUE-ALIST) ,DISP)
		   ,@(MAPCAR #'CAR VALUE-ALIST))
		 DISP)))

(DEFUN UNTRANS-OP (OP)
       (OR (CDR (ASSQ OP '((ADD* . MPLUS)
			   (SUB* . MMINUS)
			   (MUL* . MTIMES)
			   (DIV* . MQUOTIENT)
			   (POWER* . MEXPT))))
	   OP))


;;; From RZ;COMBIN >
;;;
;;;#+MacLisp
;;;(defun $cf fexpr (a)
;;;       (fexprchk a 'cf)
;;;       (let ((divov (status divov))
;;;	     ($listarith nil))
;;;	    (prog2 (sstatus divov t)
;;;		   (cfeval (meval (car a)))
;;;		   (sstatus divov divov))))
;;;
;;;#+Lispm
;;;(defun $cf fexpr (a)
;;;       (fexprchk a 'cf)
;;;       (let (($listarith nil))
;;;	    (cfeval (meval (car a)))))

(DEF%TR $CF (FORM)
	(SETQ FORM (CAR (TR-ARGS (CDR FORM))))
	(PUSH-AUTOLOAD-DEF '$CF '(CFEVAL))
	`($ANY . ((LAMBDA (DIVOV $LISTARITH)
			  (SSTATUS DIVOV T)
			  (UNWIND-PROTECT (CFEVAL ,FORM)
					  (SSTATUS DIVOV DIVOV)))
		  (STATUS DIVOV)
		  NIL)))

;;; from RZ;TRGRED >
;;;
;;;(DEFUN $TRIGREDUCE FEXPR (L)
;;;    ((LAMBDA (*TRIGRED VAR *NOEXPAND $TRIGEXPAND $VERBOSE $RATPRINT)
;;;	(GCDRED (SP1 (MEVAL (CAR L)))))
;;;     T (COND ((CDR L) (MEVAL (CADR L)))
;;;	     ( '*NOVAR ))
;;;     T NIL NIL NIL))

; JPG made this an LSUBR now! win win win good old Jeff.
;(DEF%TR $TRIGREDUCE (FORM)
;	(LET ((ARG1 (DTRANSLATE (CADR FORM)))
;	      (ARG2 (COND ((CDDR FORM) (DTRANSLATE (CADDR FORM)))
;			  (T ''*NOVAR))))
;	     `($ANY . #%(LET ((*TRIGRED T)
;			      (VAR ,ARG2)
;			      (*NOEXPAND T)
;			      ($TRIGEXPAND NIL)
;			      ($VERBOSE NIL)
;			      ($RATPRINT NIL))
;			     ; gross hack, please fix me quick gjc!!!!
;			     (OR (PLIST 'GCDRED) (LOAD (GET '$TRIGREDUCE 'AUTOLOAD)))
;			     (GCDRED (SP1 ,ARG1))))))

;;; From MATRUN
;;; (DEFUN $APPLY1 FEXPR (L)
;;;       (PROG (*EXPR)
;;;	     (SETQ *EXPR (MEVAL (CAR L)))
;;;	     (MAPC (FUNCTION (LAMBDA (Z)
;;;				     (SETQ *EXPR (APPLY1 *EXPR Z 0))))
;;;		   (CDR L))
;;;	     (RETURN *EXPR)))

(DEF%TR $APPLY1 (FORM &AUX
		      (EXPR (TR-GENSYM))
		      (RULES (TR-GENSYM)))
	(PUSH-AUTOLOAD-DEF '$APPLY1 '(APPLY1))
		      
	`($ANY  . (DO ((,EXPR ,(DTRANSLATE (CADR FORM))
			       (APPLY1 ,EXPR (CAR ,RULES) 0))
		       (,RULES ',(CDDR FORM) (CDR ,RULES)))
		      ((NULL ,RULES) ,EXPR))))

;;; This code was written before they had formatting of lisp code invented.
;;;(DEFUN $APPLY2 FEXPR (L)(PROG (*RULELIST)
;;;(SETQ *RULELIST (CDR L))
;;;(RETURN (APPLY2 (MEVAL (CAR L)) 0))))

(DEF%TR $APPLY2 (FORM)
	`($ANY . ((LAMBDA (*RULELIST)
			  (DECLARE (SPECIAL *RULELIST))
			  (APPLY2 ,(DTRANSLATE (CADR FORM)) 0))
		  ',(CDDR FORM))))

;;;(DEFUN $APPLYB1 FEXPR (L) 
;;;	 (PROG (*EXPR) 
;;;	       (SETQ *EXPR (MEVAL (CAR L)))
;;;	       (MAPC (FUNCTION (LAMBDA (Z) 
;;;				       (SETQ *EXPR(CAR
;;;					     (APPLY1HACK *EXPR
;;;							 Z)))))
;;;		     (CDR L))
;;;	       (RETURN *EXPR )))

(DEF%TR $APPLYB1 (FORM &AUX (EXPR (TR-GENSYM)) (RULES (TR-GENSYM)))
	(PUSH-AUTOLOAD-DEF '$APPLYB1 '(APPLY1HACK))
	`($ANY . (DO ((,EXPR ,(DTRANSLATE (CADR FORM))
			     (CAR (APPLY1HACK ,EXPR (CAR ,RULES))))
		      (,RULES ',(CDDR FORM) (CDR ,RULES)))
		     ((NULL ,RULES) ,EXPR))))

;;;(DEFUN $APPLYB2 FEXPR (L)(PROG (*RULELIST)
;;;(SETQ *RULELIST (CDR L))
;;;(RETURN(CAR (APPLY2HACK (MEVAL (CAR L)))))))

(DEF%TR $APPLYB2 (FORM)
	(PUSH-AUTOLOAD-DEF '$APPLYB2 '(APPLY2HACK))
	`($ANY . ((LAMBDA (*RULELIST)
			  (DECLARE (SPECIAL *RULELIST))
			  (APPLY2HACK ,(DTRANSLATE (CADR FORM))))
		  ',(CDDR FORM))))



;;; this nice translation property written by REH.
;;; He is the first macsyma system program to ever
;;; write the translation property for his own special form!


(DEF%TR $BUILDQ (FORM)

 (LET ((ALIST                               ;would be nice to output
        (MAPCAR         		    ;backquote instead of list/cons
	  #'(LAMBDA (VAR)		    ;but I'm not sure if things get
             (COND ((ATOM VAR)              ;macroexpanded.  -REH
                                            ; Well, any macros are o.k. They
		                            ; get expanded "at the right time". -gjc
		    
                    `(CONS ',VAR ,(DTRANSLATE VAR)))
                   ((EQ (CAAR VAR) 'MSETQ)
                    `(CONS ',(CADR VAR) ,(DTRANSLATE (CADDR VAR))))
                   (T (SETQ TR-ABORT T)
                      (TR-TELL VAR
			    "Illegal BUILDQ form encountered during translation"))))
                       ;right thing to do here??
                       ;how much error checking does transl do now?
                       ; Yes. Not as much as it should! -GJC
	  
         (CDR (CADR FORM)))))
      (COND ((NULL ALIST) 
               `($ANY QUOTE ,(CADDR FORM)))
            (T `($ANY MBUILDQ-SUBST (LIST ,@ALIST) ',(CADDR FORM))))))


;;; Presently STATUS and SSTATUS are FEXPR which don't evaluate 
;;; their arguments. 

(def%tr $sstatus (form)
	`($any . ($sstatus . ,(cdr form))))

(def%tr $status (form)
	(setq form (cdr form))
	(cond ((null form) ; %%%PLEASE FIX ME%%% with WNA-CHECKING %%%%%%
	       nil)
	      (t
	       (caseq (car form)
		      ($FEATURE
		       (cond ((null (cdr form))
			      `($any . ($status $feature)))
			     ; this BOOLEAN check is important, since
			     ; STATUS(FEATURE,FOO) will always be used in a
			     ; BOOLEAN context.
			     (t `($BOOLEAN . ($STATUS $FEATURE ,(CADR FORM))))))
		      (T `($ANY . ($STATUS . ,FORM)))))))

