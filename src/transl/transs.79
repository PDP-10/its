;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module transs)

(TRANSL-MODULE TRANSS)


(DEFMVAR *TRANSL-FILE-DEBUG* NIL
	"set this to T if you don't want to have the temporary files
	used automaticaly deleted in case of errors.")

;;; User-hacking code, file-io, translator toplevel.
;;; There are various macros to cons-up filename TEMPLATES
;;; which to mergef into. The filenames are should be the only
;;; system dependant part of the code, although certain behavior
;;; of RENAMEF/MERGEF/DELETEF is assumed.

(defmvar $TR_OUTPUT_FILE_DEFAULT '$TRLISP
	 "This is the second file name to be used for translated lisp
	 output.")

(DEFMVAR $TR_FILE_TTY_MESSAGESP NIL
	 "It TRUE messages about translation of the file are sent
	 to the TTY also.")

(DEFMVAR $TR_WINDY T
	 "Generate /"helpfull/" comments and programming hints.")

(DEFTRVAR *TRANSLATION-MSGS-FILES* NIL
	"Where the warning and other comments goes.")

(DEFTRVAR $TR_VERSION (GET 'TRANSL-AUTOLOAD 'VERSION))

(DEFMVAR TRANSL-FILE NIL "output stream of $COMPFILE and $TRANSLATE_FILE")

(DEFMVAR $COMPGRIND NIL "If TRUE lisp output will be pretty-printed.")

(DEFMVAR $TR_TRUE_NAME_OF_FILE_BEING_TRANSLATED nil
	 "This is set by TRANSLATE_FILE for use by user macros
	 which want to know the name of the source file.")

(DEFMVAR $TR_STATE_VARS
  '((MLIST) $TRANSCOMPILE $TR_SEMICOMPILE 
	    $TR_WARN_UNDECLARED
	    $TR_WARN_MEVAL
	    $TR_WARN_FEXPR
	    $TR_WARN_MODE
	    $TR_WARN_UNDEFINED_VARIABLE
	    $TR_FUNCTION_CALL_DEFAULT 
	    $TR_ARRAY_AS_REF
	    $TR_NUMER))

(defmacro compfile-outputname-temp () ''|_CMF_ OUTPUT|)
(defmacro compfile-outputname ()
  '`((DSK ,(STATUS UDIR))
     ,(STATUS USERID)
     ,(stripdollar
       $TR_OUTPUT_FILE_DEFAULT)))

(defmacro trlisp-inputname-d1 ()
  ;; so hacks on DEFAULTF will not stray the target.
  '`((dsk ,(status udir)) * >))

(defmacro trlisp-outputname-d1 ()
  '`((* *)  * ,(stripdollar $TR_OUTPUT_FILE_DEFAULT)))


(defmacro trlisp-outputname () ''|* TRLISP|)
(defmacro trlisp-outputname-temp () ''|* _TRLI_|)
(defmacro trtags-outputname () ''|* TAGS|)
(defmacro trtags-outputname-temp () ''|* _TAGS_|)
(defmacro trcomments-outputname () ''|* UNLISP|)
(defmacro trcomments-outputname-temp () ''|* _UNLI_|)

(DEFTRVAR DECLARES NIL)

(DEFMSPEC $COMPFILE (FORMS) (setq forms (cdr forms))
  (bind-transl-state
   (SETQ $TRANSCOMPILE T
	 *IN-COMPFILE* T)
   (let ((OUT-FILE-NAME (COND ((MFILENAME-ONLYP (CAR FORMS))
			       ($FILENAME_MERGE (POP FORMS)))
			      (T "")))
	 (t-error nil)
	 (*TRANSLATION-MSGS-FILES* NIL))
     (SETQ OUT-FILE-NAME
	   (MERGEF OUT-FILE-NAME (COMPFILE-OUTPUTNAME)))
     (UNWIND-PROTECT
      (PROGN
       (SETQ TRANSL-FILE (OPEN-out-dsk (MERGEF (COMPFILE-OUTPUTNAME-TEMP)
					       OUT-FILE-NAME)))

       (COND ((OR (MEMQ '$ALL FORMS) (MEMQ '$FUNCTIONS FORMS))
	      (SETQ FORMS (MAPCAR #'CAAR (CDR $FUNCTIONS)))))
       (DO ((L FORMS (CDR L)) 
	    (DECLARES NIL NIL)
	    (TR-ABORT NIL NIL)
	    (ITEM) (LEXPRS NIL NIL) (FEXPRS NIL NIL)
	    (T-ITEM))
	   ((NULL L))
	 (SETQ ITEM (CAR L))
	 (COND ((NOT (ATOM ITEM))
		(PRINT* (DCONVX (TRANSLATE ITEM))))
	       (T
		(SETQ T-ITEM
		      (COMPILE-FUNCTION
		       (SETQ ITEM ($VERBIFY ITEM))))
		(COND (TR-ABORT
		       (SETQ T-ERROR
			     (PRINT-ABORT-MSG ITEM
					      'COMPFILE)))
		      (T
		       (COND ($COMPGRIND
			      (MFORMAT TRANSL-FILE
				       "~2%;; Function ~:@M~%" ITEM)))
		       (PRINT* T-ITEM))))))
       (RENAME-TF OUT-FILE-NAME NIL)
       (TO-MACSYMA-NAMESTRING OUT-FILE-NAME))
      ;; unwind-protected
      (IF TRANSL-FILE (CLOSE TRANSL-FILE))
      (IF T-ERROR (DELETEF TRANSL-FILE))))))


(DEFUN COMPILE-FUNCTION (F)
       (MFORMAT  *TRANSLATION-MSGS-FILES*
		 "~%Translating ~:@M" F)
       (LET ((FUN (TR-MFUN F)))
	    (COND (TR-ABORT  NIL)
		  (T FUN))))

(DEFVAR TR-DEFAULTF NIL
	"A default only for the case of NO arguments to $TRANSLATE_FILE")
							
(DEFMFUN $TRANSLATE_FILE (&OPTIONAL (INPUT-FILE-NAME NIL I-P)
				    (OUTPUT-FILE-NAME NIL O-P))
	 (OR I-P TR-DEFAULTF
	     (MERROR "Arguments are input file and optional output file~
		     ~%which defaults to second name LISP, msgs are put~
		     ~%in file with second file name UNLISP"))
	 (COND (I-P
		(SETQ INPUT-FILE-NAME (MERGEF ($FILENAME_MERGE INPUT-FILE-NAME)
					      (trlisp-inputname-d1)))
		(SETQ TR-DEFAULTF INPUT-FILE-NAME))
	       (T
		(SETQ TR-DEFAULTF INPUT-FILE-NAME)))
	 (SETQ OUTPUT-FILE-NAME
	       (IF O-P
		   (MERGEF ($FILENAME_MERGE OUTPUT-FILE-NAME) INPUT-FILE-NAME)
		   (MERGEF (TRLISP-OUTPUTNAME-D1) INPUT-FILE-NAME)))
	 (TRANSLATE-FILE  INPUT-FILE-NAME
			  OUTPUT-FILE-NAME
			  $TR_FILE_TTY_MESSAGESP))


(DEFMVAR $TR_GEN_TAGS NIL
	 "If TRUE, TRANSLATE_FILE generates a TAGS file for
	 use by the text editor")

(DEFVAR TRF-START-HOOK NIL)

(DEFUN DELETE-OLD-AND-OPEN (X)
       (IF (LET ((F (PROBEF X)))
		(AND F (NOT (MEMQ (CADDR (NAMELIST F)) '(< >)))))
	   (DELETEF X))
       (OPEN-OUT-DSK X))

(DEFUN TRANSLATE-FILE (IN-FILE-NAME OUT-FILE-NAME TTYMSGSP)
  (BIND-TRANSL-STATE
   (SETQ *IN-TRANSLATE-FILE* T)
   (LET ((IN-FILE)
	 (*TRANSLATION-MSGS-FILES*)
	 (DSK-MSGS-FILE)
	 (TAGS-OUTPUT-STREAM)
	 (TAGS-OUTPUT-STREAM-STATE)
	 (WINP NIL)
	 (TRUE-IN-FILE-NAME))
     (UNWIND-PROTECT
      (PROGN
       (SETQ IN-FILE  (OPEN-in-dsk IN-FILE-NAME)
	     TRUE-IN-FILE-NAME (TO-MACSYMA-NAMESTRING (TRUENAME IN-FILE))
	     $TR_TRUE_NAME_OF_FILE_BEING_TRANSLATED TRUE-IN-FILE-NAME
	     TRANSL-FILE (DELETE-OLD-AND-OPEN
			  (MERGEF (trlisp-outputname-temp)
				  OUT-FILE-NAME))
	     DSK-MSGS-FILE (DELETE-OLD-AND-OPEN
			    (MERGEF (trcomments-outputname-temp)
				    OUT-FILE-NAME))
	     *TRANSLATION-MSGS-FILES* (LIST DSK-MSGS-FILE))
       (IF $TR_GEN_TAGS
	   (SETQ TAGS-OUTPUT-STREAM
		 (OPEN-out-dsk (MERGEF (trtags-outputname-temp)
				       IN-FILE-NAME))))
       (IF TTYMSGSP
	   (SETQ *TRANSLATION-MSGS-FILES*
		 (CONS TYO *TRANSLATION-MSGS-FILES*)))
       (PROGN (CLOSE IN-FILE)
	      ;; IN-FILE stream of no use with old-io BATCH1.
	      (SETQ IN-FILE NIL))
       (MFORMAT DSK-MSGS-FILE "~%This is the UNLISP file for ~A.~%"
		TRUE-IN-FILE-NAME)
       (MFORMAT TERMINAL-IO "~%Translation begun on ~A.~%"
		TRUE-IN-FILE-NAME)
       (IF TRF-START-HOOK (FUNCALL TRF-START-HOOK TRUE-IN-FILE-NAME))
       (IF TAGS-OUTPUT-STREAM (TAGS-START//END IN-FILE-NAME))
       (CALL-BATCH1 TRUE-IN-FILE-NAME (NOT *TRANSL-FILE-DEBUG*))
       ;; BATCH1 calls TRANSLATE-MACEXPR on each expression read.
       (MFORMAT DSK-MSGS-FILE
		"~%//* Variable settings were *//~%~%")
       (DO ((L (CDR $TR_STATE_VARS) (CDR L)))
	   ((NULL L))
	 (MFORMAT-OPEN DSK-MSGS-FILE
		       "~:M:~:M;~%"
		       (CAR L) (SYMEVAL (CAR L))))
       (RENAME-TF OUT-FILE-NAME TRUE-IN-FILE-NAME)
       (WHEN TAGS-OUTPUT-STREAM
	     (TAGS-START//END)
	     ;;(CLOSE TAGS-OUTPUT-STREAM) 
	     (RENAMEF TAGS-OUTPUT-STREAM (trtags-outputname)))
       ;;(CLOSE DSK-MSGS-FILE)
       ;; The CLOSE before RENAMEF clobbers the old temp file.
       ;; nope. you get a FILE-ALREADY-EXISTS error. darn.
       (RENAMEF DSK-MSGS-FILE
		(MERGEF (trcomments-outputname)
			OUT-FILE-NAME))
       (SETQ WINP T)
       `((MLIST) ,(TO-MACSYMA-NAMESTRING TRUE-IN-FILE-NAME)
		 ,(TO-MACSYMA-NAMESTRING OUT-FILE-NAME)
		 ,(TO-MACSYMA-NAMESTRING (TRUENAME DSK-MSGS-FILE))
		 ,@(IF TAGS-OUTPUT-STREAM
		       (LIST (TO-MACSYMA-NAMESTRING
			      (TRUENAME TAGS-OUTPUT-STREAM)))
		       NIL)))
      ;; Unwind protected. 
      (IF DSK-MSGS-FILE (CLOSE DSK-MSGS-FILE))
      (IF TRANSL-FILE   (CLOSE TRANSL-FILE))
      (IF TAGS-OUTPUT-STREAM (CLOSE TAGS-OUTPUT-STREAM))
      (WHEN (AND (NOT WINP) (NOT *TRANSL-FILE-DEBUG*))
	    (IF TAGS-OUTPUT-STREAM (DELETEF TAGS-OUTPUT-STREAM))
	    (IF TRANSL-FILE (DELETEF TRANSL-FILE)))))))



;; Should be rewritten to use streams.  Barf -- perhaps SPRINTER doesn't take
;; a stream argument? Yes Carl SPRINTER is old i/o, but KMP is writing
;; a new one for NIL.  -GJC

(DEFUN PRINT* (P)
  (LET ((^W T)
	(OUTFILES (LIST TRANSL-FILE))
	(^R T)
	(*NOPOINT NIL)
	($LOADPRINT NIL)) ;;; lusing old I/O !!!!!
    (SUB-PRINT* P)))

;;; i might as well be real pretty and flatten out PROGN's.

(DEFUN SUB-PRINT* (P &AUX (FLAG NIL))
  (COND ((ATOM P))
	((AND (EQ (CAR P) 'PROGN) (CDR P) (EQUAL (CADR P) ''COMPILE))
	 (MAPC #'SUB-PRINT* (CDDR P)))
	(T
	 (SETQ FLAG (AND $TR_SEMICOMPILE
			 (NOT (MEMQ (CAR P) '(EVAL-WHEN INCLUDEF)))))
	 (WHEN FLAG (PRINC* '|(PROGN|) (TERPRI*))
	 (COND ($COMPGRIND
		(SPRIN1 P))
	       (T
		(PRIN1 P TRANSL-FILE)))
	 (WHEN FLAG (PRINC* '|)|))
	 (TERPRI TRANSL-FILE))))

(DEFUN PRINC* (FORM) (PRINC FORM TRANSL-FILE))

(DEFUN NPRINC* (&REST FORM)
  (MAPC #'(LAMBDA (X) (PRINC X TRANSL-FILE)) FORM))

(DEFUN TERPRI* () (TERPRI TRANSL-FILE))

(DEFUN PRINT-MODULE (M)
  (NPRINC* " " M " version " (GET M 'VERSION)))

(DEFUN NEW-COMMENT-LINE ()
  (TERPRI*)
  (PRINC* ";;;"))

(defun print-TRANSL-MODULEs ()
  (NEW-COMMENT-LINE)
  (PRINT-MODULE 'TRANSL-AUTOLOAD)
  (DO ((J 0 (1+ J))
       (S (DELETE 'TRANSL-AUTOLOAD (APPEND TRANSL-MODULES NIL))
	  (CDR S)))
      ((NULL S))
    (IF (= 0 (\ J 3)) (NEW-COMMENT-LINE))
    (PRINT-MODULE (CAR S))))


(DEFUN PRINT-TRANSL-HEADER (SOURCE)
  (MFORMAT TRANSL-FILE
	   ";;; -*- Mode: Lisp; Package: Macsyma -*-~%")
  (IF SOURCE
      (MFORMAT TRANSL-FILE ";;; Translated code for ~A" SOURCE)
      (MFORMAT TRANSL-FILE 
	       ";;; Translated MACSYMA functions generated by COMPFILE."))
  (MFORMAT TRANSL-FILE
	   "~%;;; Written on ~:M, from MACSYMA ~A~
	    ~%;;; Translated for ~A~%" 
	   ($TIMEDATE) $VERSION (STATUS USERID))
  (print-TRANSL-MODULEs)
  (MFORMAT TRANSL-FILE
	   ;; The INCLUDEF must be in lower case for transportation
	   ;; of translated code to Multics.
	   "~%~
	   ~%(includef (cond ((status feature ITS) '|DSK:LIBMAX;TPRELU >|)~
	   ~%                ((status feature Multics) '|translate|)~
	   ~%                ((status feature Unix) '|libmax//tprelu.l|)~
	   ~%                (t (error '|Unknown system, see GJC@MIT-MC|))))~
           ~%~
           ~%(eval-when (compile eval)~
           ~%  (or (status feature lispm)~
	   ~%      (setq *infile-name-key*~
	   ~%               ((lambda (file-name)~
	   ~%                           ;; temp crock for multics.~
	   ~%                          (cond ((eq (typep file-name) 'list)~
	   ~%                                 (namestring file-name))~
	   ~%                                (t file-name)))~
	   ~%                  (truename infile)))))~
           ~%~
           ~%(eval-when (compile)~
           ~%   (setq $tr_semicompile '~S)~
           ~%   (setq forms-to-compile-queue ()))~
           ~%~%(comment ~S)~%~%"
            $tr_semicompile source)
(COND ($TRANSCOMPILE
       (UPDATE-GLOBAL-DECLARES)
       (IF $COMPGRIND
	   (MFORMAT
	    TRANSL-FILE
	    ";;; General declarations required for translated MACSYMA code.~%"))
       (PRINT* `(DECLARE . ,DECLARES))))

)

(DEFUN PRINT-ABORT-MSG (FUN FROM)
  (MFORMAT *TRANSLATION-MSGS-FILES*
	   "~:@M failed to Translate.~
            ~%~A will continue, but file output will be aborted."
	   FUN FROM))

(defmacro extension-filename (x) `(caddr (namelist ,x)))

(DEFUN RENAME-TF (NEW-NAME TRUE-IN-FILE-NAME)
  ;; copy the TRANSL-FILE to the file of the new name.
  (let ((IN-FILE))
    (UNWIND-PROTECT
     (PROGN
      (SETQ IN-FILE (OPEN-in-dsk TRANSL-FILE))
      (SETQ TRANSL-FILE
	    (OPEN-out-dsk (TRUENAME TRANSL-FILE)))

      (PRINT-TRANSL-HEADER TRUE-IN-FILE-NAME)
      (MAPC #'PRINT* (NREVERSE *PRE-TRANSL-FORMS*))	; clever eh?
      (terpri*)
      (PUMP-STREAM IN-FILE TRANSL-FILE)
      (MFORMAT TRANSL-FILE "~%(compile-forms-to-compile-queue)~%~%")
      ;; IN-FILE and TRANSL-FILE both have the same name,
      ;; ITS file locks keep thing straight.
      (RENAMEF TRANSL-FILE NEW-NAME)
      (DELETEF IN-FILE))
     ;; if something lost...
     (IF IN-FILE (CLOSE IN-FILE))
     (IF TRANSL-FILE (CLOSE TRANSL-FILE)))))


(DEFUN PUMP-STREAM (IN OUT &optional (n #.(lsh -1 -1)))
  (declare (fixnum n))
  (DO ((C))
      ((ZEROP N))
    (DECLARE (FIXNUM C))
    (SETQ C (+TYI IN))
    (IF (= C -1) (RETURN NIL))
    (+TYO C OUT)
    (SETQ N (1- N))))
	     


(DEFMSPEC $TRANSLATE (FUNCTS) (SETQ FUNCTS (CDR FUNCTS))
  (COND ((AND FUNCTS ($LISTP (CAR FUNCTS)))
	 (MERROR "Use the function TRANSLATE_FILE"))
	(T
	 (COND ((OR (MEMQ '$FUNCTIONS FUNCTS)
		    (MEMQ '$ALL FUNCTS))
		(SETQ FUNCTS (MAPCAR 'CAAR (CDR $FUNCTIONS)))))
	 (DO ((L FUNCTS (CDR L))
	      (V NIL))
	     ((NULL L) `((MLIST) ,@(NREVERSE V)))
	   (COND ((ATOM (CAR L))
		  (LET ((IT (TRANSLATE-FUNCTION ($VERBIFY (CAR L)))))
		    (IF IT (PUSH IT V))))
		 (T
		  (TR-TELL
		   (CAR L)
		   " is an illegal argument to TRANSLATE.")))))))

#+LISPM
(PROGN 'COMPILE
(DECLARE (SPECIAL forms-to-compile-queue))
(DEFMSPEC $COMPILE (FORM)
  (LET ((L (MEVAL `(($TRANSLATE),@(CDR FORM)))))
    (LET ((forms-to-compile-queue ()))
      (MAPC #'(LAMBDA (X) (IF (FBOUNDP X) (COMPILE X))) (CDR L))
      (DO ()
	  ((NULL FORMS-TO-COMPILE-QUEUE) L)
	(MAPC #'(LAMBDA (FORM)
		  (EVAL FORM)
		  (AND (LISTP FORM)
		       (EQ (CAR FORM) 'DEFUN)
		       (SYMBOLP (CADR FORM))
		       (COMPILE (CADR FORM))))
	      (PROG1 FORMS-TO-COMPILE-QUEUE
		     (SETQ FORMS-TO-COMPILE-QUEUE NIL)))))))
)