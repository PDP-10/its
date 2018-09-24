;;;     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                   LOGO UNPARSER			    ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;

(DECLARE (OR (STATUS FEATURE DEFINE)
	     (COND ((STATUS FEATURE ITS)
		    ;;MULTICS?
		    (FASLOAD DEFINE FASL AI LLOGO))))) 

(SAVE-VERSION-NUMBER UNEDIT) 

(DECLARE (GENPREFIX UNEDIT)) 

;; ATOM-GOBBLER IS A FUNCTIONAL ARGUMENT TO THE UNPARSER WHICH GETS HANDED
;;SUCCESSIVE ATOMIC TOKENS OF THE UNPARSED LINE.  THE PRINTER USES AN ATOM-GOBBLER
;;WHICH PRINTS OUT EACH TOKEN.  FOR EDITING LINES, A LIST OF THE UNPARSED TOKENS IS
;;CONSTRUCTED. 

(DEFUN UNPARSE-LIST-OF-FORMS (ATOM-GOBBLER FORM-LIST) 
       (MAP '(LAMBDA (FORMS) (UNPARSE-FORM ATOM-GOBBLER (CAR FORMS))
			     ;;SPACES IN BETWEEN SUCCESSIVE FORMS.
			     (AND (CDR FORMS) (EXPR-CALL ATOM-GOBBLER '/ )))
	    FORM-LIST)) 

;;PRINTS OUT A LINE OF LOGO SOUCE CODE.

(DEFUN LOGOPRINC (TO-BE-PRINTED) 
       (UNPARSE-LIST-OF-FORMS (EXPR-FUNCTION DPRINC) TO-BE-PRINTED)) 

;;CALLED BY EDITOR TO RECONSTRUCT SOURCE CODE.

(DEFUN UNPARSE-LOGO-LINE (PARSED-LINE) 
       (LET ((UNPARSED-LINE))
	    (UNPARSE-LIST-OF-FORMS (EXPR-FUNCTION (LAMBDA (TOKEN) 
							  (PUSH TOKEN
								UNPARSED-LINE)))
				   PARSED-LINE)
	    (NREVERSE UNPARSED-LINE))) 

(DEFUN UNPARSE-PRINT-FORM (FORM) (UNPARSE-FORM (EXPR-FUNCTION DPRINC) FORM)) 

(DEFUN UNPARSE-EXPR-FORM NIL (UNPARSE-LIST-OF-FORMS ATOM-GOBBLER PARSED-FORM)) 


(DEFUN UNPARSE-ATOM (ATOM) 
       (COND ((= (FLATC ATOM) (FLATSIZE ATOM)) (EXPR-CALL ATOM-GOBBLER ATOM))
	     ((EXPR-CALL ATOM-GOBBLER '$)
	      (DO ((CHARNUM 1. (1+ CHARNUM)) (CHAR))
		  ((> CHARNUM (FLATC ATOM)))
		  (SETQ CHAR (GETCHAR ATOM CHARNUM))
		  (COND ((EQ CHAR '$)
			 (EXPR-CALL ATOM-GOBBLER '$)
			 (EXPR-CALL ATOM-GOBBLER '$))
			((EXPR-CALL ATOM-GOBBLER CHAR))))
	      (EXPR-CALL ATOM-GOBBLER '$)))) 

;;*PAGE

;;FIGURE OUT HOW TO UNPARSE BY FIGURING OUT HOW THE PARSER HANDLED IT.

(DEFUN UNPARSE-FORM (ATOM-GOBBLER PARSED-FORM) 
       (COND ((ATOM PARSED-FORM) (UNPARSE-ATOM PARSED-FORM))
	     ((LET ((CAR-FORM (CAR PARSED-FORM))
		    (CDR-FORM (CDR PARSED-FORM))
		    (UNPARSE-PROP))
		   (COND ((NOT (ATOM CAR-FORM))
			  (UNPARSE-LIST-OF-CONSTANTS ATOM-GOBBLER PARSED-FORM))
			 ((SETQ UNPARSE-PROP (GET CAR-FORM 'UNPARSE))
			  (EVAL UNPARSE-PROP))
			 ((SETQ UNPARSE-PROP (GET CAR-FORM 'UNPARSE-INFIX))
			  (UNPARSE-INFIX UNPARSE-PROP CDR-FORM))
			 ((AND (SETQ UNPARSE-PROP (GET CAR-FORM 'PARSE))
			       (COND ((CDR UNPARSE-PROP)
				      (UNPARSE-PARSE-PROP (CADR UNPARSE-PROP)))
				     ((UNPARSE-PARSE-PROP (CAR UNPARSE-PROP))))))
			 ((SETQ UNPARSE-PROP (HOW-TO-PARSE-INPUTS CAR-FORM))
			  (UNPARSE-PARSE-PROP UNPARSE-PROP))
			 ((UNPARSE-LIST-OF-CONSTANTS ATOM-GOBBLER PARSED-FORM))))))) 

;;WHAT CAN BE DONE ABOUT FUNCTIONS OF WHICH NOTHING IS KNOWN AT UNPARSE TIME? FOR
;;INSTANCE, THE FUNCTION MAY HAVE BEEN KNOWN AT PARSE TIME, BUT USER HAS SINCE
;;ERASED IT, READ A FILE CONTAINING CALL BUT NOT DEFINITION, ETC.  HE MAY THEN ASK
;;TO PRINT OUT OR EDIT IT, REQUIRING A DECISION ON UNPARSING.  PROBABLY THE BEST
;;THAT CAN BE DONE IS TO TREAT AS FEXPR- NOT DO FULL UNPARSING OF INPUTS.  USER MAY
;;GET FREAKED OUT, BUT UNPARSED REPRESENTATION WILL BE RE-PARSABLE.

(DEFUN UNPARSE-PARSE-PROP (PARSE-PROP) 
       (COND ((OR (NUMBERP PARSE-PROP) (EQ PARSE-PROP 'L))
	      (UNPARSE-EXPR-FORM))
	     ((EQ PARSE-PROP 'F)
	      (UNPARSE-LIST-OF-CONSTANTS ATOM-GOBBLER PARSED-FORM))
	     ((ATOM PARSE-PROP)
	      (ERRBREAK 'UNPARSE-PARSE-PROP
			(LIST '"SYSTEM BUG: "
			      CAR-FORM
			      '" HAS PARSE PROP "
			      PARSE-PROP
			      '" NEEDS UNPARSE PROP")))
	     ((AND (CDR PARSE-PROP) (ATOM (CDR PARSE-PROP))) (UNPARSE-EXPR-FORM))
	     [CLOGO ((EQ (CAR PARSE-PROP) 'PARSE-CLOGO-HOMONYM)
		     (UNPARSE-PARSE-PROP (CADDR PARSE-PROP)))]
	     ((EQ (CAR PARSE-PROP) 'PARSE-SUBSTITUTE) NIL)
	     ((ERRBREAK 'UNPARSE-PARSE-PROP
			(LIST '"SYSTEM BUG: "
			      CAR-FORM
			      '" HAS PARSE PROP "
			      PARSE-PROP
			      '" NEEDS UNPARSE PROP"))))) 

(DEFUN UNPARSE-SUBSTITUTE (FAKE-OUT) 
       (UNPARSE-FORM ATOM-GOBBLER (CONS FAKE-OUT CDR-FORM))) 

;;*PAGE

;;UNPARSING OF "CONSTANTS" [QUOTED THINGS, INPUTS TO FEXPRS] CONSISTS OF DOING:
;;; (QUOTE <SEXP>) --> '<SEXP>
;;; (SQUARE-BRACKETS (<S1> ... <SN>)) --> [<S1> ... <SN>]
;;; (DOUBLE-QUOTE <SEXP>) --> "<SEXP>"
;;; (DOUBLE-QUOTE (<S1>...<SN>)) --> "<S1> ... <SN>"
;;;AND PRINTING PARENS AROUND LISTS.

(DEFUN UNPARSE-LIST-OF-CONSTANTS (ATOM-GOBBLER PARSED-FORM) 
       (MAP '(LAMBDA (CONSTANTS) 
		     (UNPARSE-CONSTANT ATOM-GOBBLER (CAR CONSTANTS))
		     (AND (CDR CONSTANTS) (EXPR-CALL ATOM-GOBBLER '/ )))
	    PARSED-FORM)) 

(DEFUN UNPARSE-CONSTANT (ATOM-GOBBLER CONSTANT) 
       (COND ((ATOM CONSTANT) (UNPARSE-ATOM CONSTANT))
	     ((EQ (CAR CONSTANT) 'QUOTE)
	      (EXPR-CALL ATOM-GOBBLER '/')
	      (UNPARSE-CONSTANT ATOM-GOBBLER (CADR CONSTANT)))
	     ((EQ (CAR CONSTANT) 'DOUBLE-QUOTE)
	      (EXPR-CALL ATOM-GOBBLER '/")
	      (LET ((QUOTED (CADR CONSTANT)))
		   (COND ((ATOM QUOTED) (UNPARSE-ATOM QUOTED))
			 ((CDR QUOTED)
			  (UNPARSE-LIST-OF-CONSTANTS ATOM-GOBBLER QUOTED))
			 ((UNPARSE-CONSTANT ATOM-GOBBLER QUOTED))))
	      (EXPR-CALL ATOM-GOBBLER '/"))
	     ((EQ (CAR CONSTANT) 'SQUARE-BRACKETS)
	      (EXPR-CALL ATOM-GOBBLER '/[)
	      (UNPARSE-LIST-OF-CONSTANTS ATOM-GOBBLER (CADR CONSTANT))
	      (EXPR-CALL ATOM-GOBBLER '/]))
	     ((EXPR-CALL ATOM-GOBBLER '/()
	      (UNPARSE-LIST-OF-CONSTANTS ATOM-GOBBLER CONSTANT)
	      (EXPR-CALL ATOM-GOBBLER '/))))) 

(MAPC '(LAMBDA (QUOTER) (PUTPROP QUOTER '(UNPARSE-QUOTER) 'UNPARSE))
      '(QUOTE DOUBLE-QUOTE SQUARE-BRACKETS)) 

(DEFUN UNPARSE-QUOTER NIL (UNPARSE-CONSTANT ATOM-GOBBLER PARSED-FORM)) 

(DEFPROP LOGO-COMMENT (UNPARSE-COMMENT) UNPARSE) 

(DEFUN UNPARSE-COMMENT NIL 
       (DO NIL
	   ((NULL CDR-FORM))
	   (EXPR-CALL ATOM-GOBBLER (CAR CDR-FORM))
	   (POP CDR-FORM))) 

(DEFPROP USER-PAREN (UNPARSE-PAREN) UNPARSE) 

(DEFUN UNPARSE-PAREN NIL 
       (PROGN (EXPR-CALL ATOM-GOBBLER '/()
	      (UNPARSE-FORM ATOM-GOBBLER (CAR CDR-FORM))
	      (EXPR-CALL ATOM-GOBBLER '/)))) 

;;*PAGE

;;FOR ERROR MESSAGE PRINTOUTS, ETC.  CHANGE INTERNAL FUNCTION NAMES TO EXTERNAL
;;FORM.  HOMONYMS, INFIX.

(DEFUN UNPARSE-FUNCTION-NAME (PARSED-FUNCTION-NAME) 
       (COND ((GET PARSED-FUNCTION-NAME 'UNPARSE-INFIX))
	     ((LET ((UNPARSE-PROP (GET PARSED-FUNCTION-NAME 'UNPARSE)))
		   (COND ((EQ (CAR UNPARSE-PROP) 'UNPARSE-SUBSTITUTE)
			  (CADADR UNPARSE-PROP)))))
	     (PARSED-FUNCTION-NAME))) 

(DEFUN UNPARSE-INFIX (INFIX-OP ARGLIST) 
       (UNPARSE-FORM ATOM-GOBBLER (CAR ARGLIST))
       (COND ((CDR ARGLIST)
	      (EXPR-CALL ATOM-GOBBLER '/ )
	      (EXPR-CALL ATOM-GOBBLER INFIX-OP)
	      (EXPR-CALL ATOM-GOBBLER '/ )
	      (UNPARSE-INFIX INFIX-OP (CDR ARGLIST))))) 

(DEFPROP PARSEMACRO (UNPARSE-PARSEMACRO CDR-FORM) UNPARSE) 

(DEFUN UNPARSE-PARSEMACRO (OLD-LINE) 
       ;;POP OFF OLD-LINE UNTIL YOU HIT LINE NUMBER.
       (DO NIL
	   ((NUMBERP (CAR OLD-LINE))
	    (POP OLD-LINE)
	    (AND (EQ (CAR OLD-LINE) '/ ) (POP OLD-LINE))
	    (DO NIL
		((NULL OLD-LINE))
		(EXPR-CALL ATOM-GOBBLER (CAR OLD-LINE))
		(POP OLD-LINE)))
	   (POP OLD-LINE))) 

(DEFPROP COND (UNPARSE-COND CDR-FORM) UNPARSE) 

(DEFUN UNPARSE-COND (CLAUSES) 
       (EXPR-CALL ATOM-GOBBLER 'IF)
       (EXPR-CALL ATOM-GOBBLER '/ )
       (UNPARSE-FORM ATOM-GOBBLER (CAAR CLAUSES))
       (COND ((CDAR CLAUSES)
	      (EXPR-CALL ATOM-GOBBLER '/ )
	      (EXPR-CALL ATOM-GOBBLER 'THEN)
	      (EXPR-CALL ATOM-GOBBLER '/ )
	      (UNPARSE-LIST-OF-FORMS ATOM-GOBBLER (CDAR CLAUSES))))
       (COND ((CDR CLAUSES)
	      (EXPR-CALL ATOM-GOBBLER '/ )
	      (EXPR-CALL ATOM-GOBBLER 'ELSE)
	      (EXPR-CALL ATOM-GOBBLER '/ )
	      (UNPARSE-LIST-OF-FORMS ATOM-GOBBLER (CDADR CLAUSES))))) 

(DEFUN UNPARSE-DO NIL 
       (COND ((ATOM (CAR CDR-FORM)) (UNPARSE-EXPR-FORM))
	     ((MAPC '(LAMBDA (ATOM) (EXPR-CALL ATOM-GOBBLER ATOM))
		    '(DO /  /())
	      (MAP '(LAMBDA (VAR-SPEC) 
			    (EXPR-CALL ATOM-GOBBLER '/()
			    (UNPARSE-LIST-OF-FORMS ATOM-GOBBLER (CAR VAR-SPEC))
			    (EXPR-CALL ATOM-GOBBLER '/))
			    (AND (CDR VAR-SPEC) (EXPR-CALL ATOM-GOBBLER '/ )))
		   (CAR CDR-FORM))
	      (MAPC '(LAMBDA (ATOM) (EXPR-CALL ATOM-GOBBLER ATOM))
		    '(/) /  /())
	      (UNPARSE-LIST-OF-FORMS ATOM-GOBBLER (CADR CDR-FORM))
	      (EXPR-CALL ATOM-GOBBLER '/))
	      (EXPR-CALL ATOM-GOBBLER '/ )
	      (UNPARSE-LIST-OF-FORMS ATOM-GOBBLER (CDDR CDR-FORM))))) 

;; THESE ARE ONLY NECESSARY SINCE FUNCTIONS HAVE SPECIAL PARSE PROPS.

(MAPC '(LAMBDA (F) (PUTPROP F '(UNPARSE-EXPR-FORM) 'UNPARSE))
      '(INSERTLINE INSERT-LINE SETQ MAKEQ GO STORE)) 

;;*PAGE

;;			DEFINING LOGO PROCEDURES. 

(SETQ :REDEFINE NIL) 

;;INITIALLY, USER IS ASKED ABOUT ANY REDEFINITION.

(DEFINE TO FEXPR (X) 
 (AND (NOT EDT)
      :EDITMODE
      (EQ PROMPTER '>)
      (ERRBREAK 'TO
		(LIST '"YOU ARE ALREADY EDITING " FN)))
 (PROG (INPUTS COM NEW-FN) 
       (OR X
	   (AND (DEFAULT-FUNCTION 'TO NIL)
		(SETQ COM (AND (CDR TITLE) (CADR TITLE)) X (CDAR TITLE))
		(TYPE '";DEFINING " FN EOL)))
       ;;TYPE CHECK TO'S INPUTS.
       (LET ((:CONTENTS (CONS (CAR X) :CONTENTS)))
	    (SETQ NEW-FN (PROCEDUREP 'TO (CAR X)) 
		  ;;PROCEDUREP EXPECTS NEW-FN ON :CONTENTS.
		  INPUTS (CDR X)))
       ;;TO ALSO GETS CALLED WHILE EDITING TITLES.  EDT IS SET TO OLD PROCEDURE
       ;;NAME, GIVEN AS INPUT TO EDTITITLE.  CHECKED TO SEE WHAT'S APPROPRIATE FOR
       ;;EDITING TITLES.
       (AND
	(NOT :REDEFINE)
	;;:REDEFINE=T MEANS REDEFINITION WILL BE ALLOWED WITHOUT ASKING USER.
	(NOT (EQ EDT NEW-FN))
	(OR (MEMQ NEW-FN :CONTENTS) (MEMQ NEW-FN :COMPILED))
	(IOG
	 NIL
	 (TYPE
	  EOL
	  '/;
	  NEW-FN
	  '" IS ALREADY DEFINED. WOULD YOU LIKE TO REDEFINE IT?"))
	(COND ((ASK))
	      ;;ASK IF USER WANTS TO REDEFINE THE FUNCTION.  IF NOT, FROM CONSOLE,
	      ;;MERELY RETURN FROM TO.  FROM FILE, CHANGE TO DUMMY FUNCTION NAME TO
	      ;;SLURP UP LINES OF DEFINITION REMAINING.  A KLUDGE, ADMITTEDLY.
	      (^Q (LET ((DUMMY-HACK (ATOMIZE NEW-FN
					     '" NOT RE")))
		       (APPLY 'TO (LIST DUMMY-HACK))
		       (SETQ :CONTENTS (DELQ DUMMY-HACK :CONTENTS))
		       (RETURN NO-VALUE)))
	      ((RETURN (LIST '/; NEW-FN 'NOT 'REDEFINED))))
	(TYPE '";REDEFINING " NEW-FN EOL))
       (AND (CDR LOGOREAD)
	    ;;TITLE LINE COMMENT PROCESSED.
	    (EQ (CAADR LOGOREAD) 'LOGO-COMMENT)
	    (SETQ COM (CADR LOGOREAD))
	    (POP LOGOREAD))
       (COND
	((PRIMITIVEP NEW-FN)
	 (COND
	  (:REDEFINE (ERASEPRIM NEW-FN))
	  (T
	   (IOG
	    NIL
	    (TYPE
	     '/;
	     NEW-FN
	     '" IS USED BY LOGO. WOULD YOU LIKE TO REDEFINE IT?"))
	   (COND ((ASK))
		 ;;ASK IF USER WANTS TO REDEFINE THE FUNCTION.  IF NOT, FROM
		 ;;CONSOLE, MERELY RETURN FROM TO.  FROM FILE, CHANGE TO DUMMY
		 ;;FUNCTION NAME TO SLURP UP LINES OF DEFINITION REMAINING.  A
		 ;;KLUDGE, ADMITTEDLY.
		 (^Q (LET ((DUMMY-HACK (ATOMIZE NEW-FN
						'" NOT RE")))
			  (APPLY 'TO (LIST DUMMY-HACK))
			  (SETQ :CONTENTS (DELQ DUMMY-HACK :CONTENTS))
			  (RETURN NO-VALUE)))
		 ((RETURN (LIST '/; NEW-FN 'NOT 'REDEFINED))))
	   (TYPE '";REDEFINING " NEW-FN EOL)
	   (ERASEPRIM NEW-FN)))))
       ;;ARE ALL THE INPUTS TO FUNCTION BEING DEFINED KOSHER?
       (MAP '(LAMBDA (VARL) (RPLACA VARL (VARIABLEP 'TO (CAR VARL))))
	    INPUTS)
       (UNTRACE1 FN)
       (SETQ FN NEW-FN 
	     PROG (COND (EDT (EDITINIT EDT)) ((LIST 'PROG NIL '(END)))) 
	     TITLE (CONS (CCONS 'TO FN INPUTS) (AND COM (NCONS COM))) 
	     :BURIED (DELETE FN :BURIED))
       (UNITE FN ':CONTENTS)
       ;;FN ADDED TO :CONTENTS.
       (PUTPROP FN
		(COND (COM (LIST 'LAMBDA INPUTS COM PROG))
		      ((LIST 'LAMBDA INPUTS PROG)))
		'EXPR)
       (OR EDT (NOT :EDITMODE) (SETQ PROMPTER '>))
       (RETURN NO-VALUE))) 

;;; END DOES NOT HAVE TO BE TYPED TO TERMINATE EDITING OF A PROCEDURE.
;;; IF USER TYPES IT, IT JUST TYPES BACK COMFORTING MESSAGE AND CHANGES PROMPTER TO
;;? SO AS
;;; NOT TO FREAK OUT 11 LOGO & CLOGO USERS. INSIDE A PROCEDURE, RETURNS ?.

(DEFINE END (PARSE (PARSE-END)) NIL (OUTPUT NO-VALUE)) 

(DEFUN PARSE-END NIL 
       (SETQ PROMPTER NO-VALUE)
       (TYPE '/; FN '" DEFINED" EOL)) 

(DEFINE LOCAL (SYN COMMENT)) 

;;*PAGE

;;			LOGO EDITOR

(SETQ LAST-LINE NIL NEXT-TAG NIL THIS-LINE NIL FN NIL PROG NIL TITLE NIL) 

;;; FIRST INPUT TO DEFAULT-FUNCTION IS NAME OF CALLER TO BE USED IN ERROR MESSAGES
;;; IF NECESSARY. 
;;;	2ND ARG = NIL -> CHECK IF DEFAULT FUNCTION EXITS.
;;;	2ND ARG = FUNCTION NAME ->  RESET DEFAULT FUNCTION TO 
;;;		2ND ARG, IF IT IS NOT ALREADY.
;;; SETS GLOBAL VARIABLES:
;;;	FN <- CURRENT DEFAULT FUNCTION.
;;;	PROG <- POINTER TO FN'S PROG.
;;;	TITLE <- POINTER TO FN'S TITLE [AND TITLE LINE COMMENTS]

(DEFUN DEFAULT-FUNCTION (CALLER FUNCTION) 
       (COND
	(FUNCTION (OR (EQ FN FUNCTION)
		      (SETQ FN (PROCEDUREP CALLER FUNCTION) 
			    PROG (EDITINIT1 FN) 
			    TITLE (CAR PROG) 
			    PROG (CADR PROG)))
		  FN)
	(FN)
	((DEFAULT-FUNCTION
	  CALLER
	  (ERRBREAK
	   CALLER
	   '"YOU HAVEN'T SPECIFIED A PROCEDURE NAME"))))) 

;;; NOTE THAT LOGO-EDIT DOES NOTHING EXCEPT CHANGE DEFAULT FUNCTION IF
;;; GIVEN INPUT. PROMPTER CHANGED AS CONCESSION TO CLOGO & 11 LOGO USERS.

(DEFINE EDIT (PARSE (PARSE-SUBSTITUTE 'LOGO-EDIT))) 

;;EDIT OF NO ARGS USES THE DEFAULT FN.

(DEFINE LOGO-EDIT (ABB ED) (UNPARSE (UNPARSE-SUBSTITUTE 'EDIT)) FEXPR (WHAT-FUNCTION) 
	(AND :EDITMODE
	     (EQ PROMPTER '>)
	     (ERRBREAK 'LOGO-EDIT
		       (LIST '"YOU ARE ALREADY EDITING"
			     FN)))
	(DEFAULT-FUNCTION 'LOGO-EDIT (AND WHAT-FUNCTION (CAR WHAT-FUNCTION)))
	(AND :EDITMODE (SETQ PROMPTER '>))
	(LIST '/; 'EDITING FN)) 

;;RETURNS FIRST PROG OF FN

(DEFUN EDITINIT (FN) (CADR (EDITINIT1 FN))) 

(DEFUN EDITINIT1 (FN) 
       ;;CAR OF OUTPUT IS TITLE LINE + COMMENTS.  CADR OF OUTPUT IS PROG.
       (OR (MEMQ FN :CONTENTS)
	   (SETQ FN (ERRBREAK 'EDITINIT1
			      (LIST FN
				    '"NOT IN WORKSPACE"))))
       (PROG (DEF INPUTS TITLE) 
	     (SETQ DEF (TRACED? FN))
	     (SETQ INPUTS (CADR DEF) DEF (CDDR DEF))
	     (SETQ TITLE (LIST (APPEND (LIST 'TO FN) INPUTS)))
	COM  (COND ((EQ 'PROG (CAAR DEF))
		    (RETURN (CONS (NREVERSE TITLE) DEF)))
		   ((PUSH (CAR DEF) TITLE) (SETQ DEF (CDR DEF)) (GO COM))))) 

(DEFINE ERASELINE (ABB ERL) (ERASE-LINE-NUMBER) 
 (DEFAULT-FUNCTION 'ERASELINE NIL)
 (TYPE '";ERASING LINE "
       ERASE-LINE-NUMBER
       '" OF "
       FN
       EOL)
 (LET
  ((THIS-LINE) (NEXT-TAG) (LAST-LINE))
  (GETLINE PROG
	   (SETQ ERASE-LINE-NUMBER (NUMBER? 'ERASELINE ERASE-LINE-NUMBER)))
  (ERASE-LOCALS PROG THIS-LINE)
  (COND
   (THIS-LINE (RPLACD LAST-LINE NEXT-TAG) NO-VALUE)
   ((SETQ ERASE-LINE-NUMBER
	  (ERRBREAK 'ERASELINE
		    (LIST '"NO LINE NUMBERED"
			  ERASE-LINE-NUMBER
			  '" IN "
			  FN)))
    (ERASELINE ERASE-LINE-NUMBER))))) 

;;FLAG USED BY "TO".

(SETQ EDT NIL INPUT-LIST GENSYM) 

(DEFINE EDITTITLE (ABB EDT) FEXPR (OPTIONAL-FUNCTION) 
	(DEFAULT-FUNCTION 'EDITTITLE
			  (AND OPTIONAL-FUNCTION (CAR OPTIONAL-FUNCTION)))
	(EDT1 (REPAIR-LINE (UNPARSE-LOGO-LINE TITLE)))) 

(DEFINE TITLE (PARSE L) FEXPR (X) (EDT1 X)) 

(DEFUN EDT1 (LOGOREAD) 
       (LET
	((EDT FN) (INPUT-LIST (CDDAR TITLE)))
	(OR
	 (EQ (CAAR LOGOREAD) 'TO)
	 (SETQ 
	  LOGOREAD
	  (ERRBREAK
	   'EDITTITLE
	   '"EDIT TITLE - TITLE LINE MUST BEGIN WITH TO")))
	(EVAL (CAR LOGOREAD))
	(COND ((NOT (EQ EDT FN))
	       (REMPROP EDT 'EXPR)
	       (SETQ :CONTENTS (DELETE EDT :CONTENTS) :BURIED (DELETE EDT :BURIED))
	       ;;CHANGE FUNCTION NAMES IN PARSEMACROS INSIDE DEFINITION.
	       (MAPC '(LAMBDA (FORM) (COND ((ATOM FORM))
					   ((EQ (CAR FORM) 'PARSEMACRO)
					    (RPLACA (CADDR FORM) FN))))
		     PROG)
	       (TYPE '";PROCEDURE NAME CHANGED FROM "
		     EDT
		     '" TO "
		     FN
		     EOL))
	      ((NOT (EQUAL INPUT-LIST (CADR (GET FN 'EXPR))))
	       (TYPE '";INPUTS CHANGED TO "
		     (CADR (GET FN 'EXPR))
		     EOL))
	      ((TYPE '";TITLE NOT CHANGED" EOL))))) 

;;; SYNTAX: INSERTLINE <NUMBER> <FORM> <FORM> ....<FORM> <RETURN>
;;; INSERTS IN DEFAULT FUNCTION. MUST BE ONLY FORM ON LINE.
;;; NO REASON TO BE CALLED BY USER, SINCE LINE BEGINNING WITH NUMBER
;;; GETS PARSED AS INSERTLINE.
;;THE ONLY DIFFERENCE BETWEEN THESE TWO LINE INSERTING FUNCTIONS IS THAT FOR USE IN
;;USER PROCEDURES, THE LINE MUST BE COPIED.  THIS IS NOT NECESSARY FOR AUTOMATICALLY
;;INSERTED LINES.

(DEFINE INSERTLINE (ABB INL) (PARSE (PARSE-INSERTLINE)) FEXPR (NEW-LINE) 
	(APPLY 'INSERT-LINE (SUBST NIL NIL NEW-LINE))
	(LIST '";INSERTING LINE"
	      (CAR NEW-LINE)
	      'INTO
	      FN)) 

(DEFINE INSERT-LINE (PARSE (PARSE-INSERT-LINE)) FEXPR (NEW-LINE) 
	(DEFAULT-FUNCTION 'INSERT-LINE NIL)
	(LET ((THIS-LINE) (NEXT-TAG) (LAST-LINE))
	     (GETLINE PROG (CAR NEW-LINE))
	     (ADDLINE PROG NEW-LINE))
	NO-VALUE) 

;;; GETLINE SETS THINGS UP TO MODIFY PROCEDURE LINES.
;;; LAST-LINE <- PIECE OF PROG WHOSE CADR IS <TAG>, WHOSE
;;;              CAR IS LAST FORM BEFORE <TAG>.
;;; THIS-LINE <- LIST OF FORMS ON LINE NUMBER <TAG>.
;;; NEXT-TAG <- REMAINDER OF PROG STARTING WITH LINE FOLLOWING
;;;             LINE NUMBER <TAG>.
;;;
;;; EXAMPLE: IF (GET '#FOO 'EXPR) IS
;;;       (LAMBDA (:N) (PROG NIL 10 (TYPE 'F) 20 (TYPE'O)  30
;;;            (TYPE 'OBAR) (END)))
;;; THEN (GETLINE (EDITINIT '#FOO) 20)  MAKES
;;; THIS-LINE <- ((TYPE 'O))
;;;  NEXT-TAG <- (30 (TYPE 'OBAR) (END))
;;; LAST-LINE <- ((TYPE 'F) 20 (TYPE 'O) 30 (TYPE 'OBAR) (END))
;;IF NO PROG DEFINITION, NEXT-TAG <- PROG <- THIS-LINE <- NIL.  IF LINE NUMBER >
;;THAN <TAG> IS FOUND, THIS-LINE <- NIL, NEXT-TAG <- REMAINDER OF PROG STARTING WITH
;;FIRST HIGHER LINE NUMBER.  LAST-LINE IS REMAINDER OF PROG WHOSE CAR IS FORM BEFORE
;;(CAR NEXT-TAG).

(DEFUN GETLINE (PROG TAG) 
       (PROG (LINE-NO) 
	LOOP (SETQ PROG (CDR PROG) LAST-LINE PROG THIS-LINE NIL LINE-NO (CADR PROG))
	     (COND ((EQUAL LINE-NO '(END)) (POP PROG) (GO NO-LINE))
		   ((NOT (NUMBERP LINE-NO)) (GO LOOP)))
	     (POP PROG)
	     (COND ((EQUAL LINE-NO TAG)
		    (RETURN (SETQ PROG
				  (CDR PROG)
				  THIS-LINE
				  (CONS (CAR PROG) THIS-LINE)
				  PROG
				  (CDR PROG)
				  NEXT-TAG
				  (DO NIL
				      ((OR (NUMBERP (CAR PROG))
					   (EQUAL (CAR PROG) '(END)))
				       PROG)
				      (SETQ THIS-LINE (CONS (CAR PROG) THIS-LINE) 
					    PROG (CDR PROG)))
				  THIS-LINE
				  (NREVERSE THIS-LINE))))
		   ((LESSP LINE-NO TAG) (GO LOOP)))
	NO-LINE
	     (RETURN (SETQ NEXT-TAG PROG THIS-LINE NIL)))) 

;;ADDLINE REQUIRES THE GLOBAL VARIABLES THIS-LINE, NEXT-TAG, AND LAST-LINE, AS SET
;;BY GETLINE.

(DEFUN ADDLINE (PROG EDITED) 
       ;;EDITED = (NUMBER (CALL) (CALL) ...).
       (COND ((CDR EDITED)
	      (ERASE-LOCALS PROG THIS-LINE)
	      ;;IF THE LINE CONTAINED LOCAL VARIABLE DECLARATIONS, THE PROG MUST BE
	      ;;MODIFIED.
	      (MAPC 
	       '(LAMBDA (FORM) 
			(COND ((EQ (CAR FORM) 'LOCAL)
			       (MAPC 'EDIT-LOCAL (CDR FORM)))
			      ;;MAKE TESTFLAG LOCAL TO ANY PROCEDURE HARBORING A
			      ;;TEST.
			      ((EQ (CAR FORM) 'TEST)
			       (OR (MEMQ 'TESTFLAG (CADR PROG))
				   (RPLACA (CDR PROG)
					   (CONS 'TESTFLAG (CADR PROG)))))))
	       (CDR EDITED))
	      (RPLACD LAST-LINE EDITED)
	      (NCONC EDITED NEXT-TAG)))) 

(DEFUN MAKLOGONAM (VAR) 
       ;;MAKES A LOGO VARIABLE NAME OUT OF VAR.
       (LET
	((OBARRAY LOGO-OBARRAY))
	(COND
	 ((SYMBOLP VAR)
	  (COND ((EQ (GETCHAR VAR 1.) ':) VAR)
		((IMPLODE (CONS ': (EXPLODEC VAR))))))
	 ((MEMQ (CAR VAR) '(DOUBLE-QUOTE QUOTE))
	  (IMPLODE (CONS ': (EXPLODEC (CADR VAR)))))
	 ((ERRBREAK
	   'MAKLOGONAM
	   (LIST VAR
		 '" IS NOT A VALID VARIABLE NAME")))))) 

;;THE VAR IS ADDED TO THE LOCAL VARS OF PROG.  IF ALREADY PRESENT, A WARNING IS
;;ISSUED.

(DEFUN EDIT-LOCAL (VAR) 
       (SETQ VAR (MAKLOGONAM VAR))
       (COND
	((MEMQ VAR (CADR PROG))
	 (TYPE '";WARNING- "
	       VAR
	       '" IS ALREADY A LOCAL VARIABLE"
	       EOL))
	((EQ (GET VAR 'SYSTEM-VARIABLE) 'READ-ONLY)
	 (ERRBREAK
	  'LOCAL
	  (LIST
	   VAR
	   '"CAN'T BE LOCAL BECAUSE IT'S USED BY LOGO")))
	((RPLACA (CDR PROG) (CONS VAR (CADR PROG)))))) 

;;THE LOCAL VARS IF ANY OF THE OLD LINE ARE DELETED FROM THE PROG.

(DEFUN ERASE-LOCALS (PROG LINES) 
       (MAPC '(LAMBDA (X) (AND (EQ (CAR X) 'LOCAL)
			       (RPLACA (CDR PROG)
				       (SET- (CADR PROG)
					     (MAPCAR 'MAKLOGONAM (CDR X))))))
	     LINES)) 

;;*PAGE

;;BURYING A PROCEDURE MAKES IT INVISIBLE TO PRINTOUT PROCEDURES, PRINTOUT ALL, ERASE
;;PROCEDURES, ERASE ALL, PRINTOUT TITLES, COMPILE, SAVE, AND WRITE.  INTENDED FOR A
;;PACKAGE OF FUNCTIONS WHICH YOU WANT TO BE "THERE" BUT NOT CONSIDERED AS PART OF
;;YOUR WORKSPACE WHEN USING THE ABOVE FUNCTIONS.  ERASE BURY UNDOES THE EFFECT OF
;;BURY.  A LIST OF BURIED PROCEDURES IS KEPT AS :BURIED.

(DEFINE BURY FEXPR (TO-BE-BURIED) 
	(OR TO-BE-BURIED
	    (SETQ TO-BE-BURIED
		  (LIST (ERRBREAK 'BURY
				  '"BURY WHAT??"))))
	(AND (EQ (CAR TO-BE-BURIED) 'ALL) (SETQ TO-BE-BURIED :CONTENTS))
	(MAPC 'INTERNAL-BURY TO-BE-BURIED)
	(CONS '/; (APPEND TO-BE-BURIED '(BURIED)))) 

(DEFUN INTERNAL-BURY (BURY-IT) 
       (COND ((MEMQ BURY-IT :BURIED))
	     ((MEMQ BURY-IT :CONTENTS) (PUSH BURY-IT :BURIED))
	     (T (SETQ BURY-IT
		      (ERRBREAK 'BURY
				(LIST BURY-IT
				      '"NOT FOUND")))
		(INTERNAL-BURY BURY-IT)))) 

(DEFINE ERASEBURY (ABB ERB) FEXPR (UNCOVER) 
	(OR UNCOVER
	    (SETQ UNCOVER
		  (LIST (ERRBREAK 'ERASEBURY
				  '"ERASE BURY WHAT??? "))))
	(AND (EQUAL UNCOVER '(ALL)) (SETQ UNCOVER :BURIED))
	(MAPC 'INTERNAL-ERASE-BURY UNCOVER)
	(CONS '/; (APPEND UNCOVER '(NO LONGER BURIED)))) 

(DEFUN INTERNAL-ERASE-BURY (UNBURY) 
       (OR (MEMQ UNBURY :BURIED)
	   (SETQ UNBURY (ERRBREAK 'ERASEBURY
				  (LIST UNBURY
					'"NOT BURIED"))))
       (SETQ :BURIED (DELETE UNBURY :BURIED))) 

;;*PAGE

;;THE ONLY DIFFERENCE BETWEEN THESE TWO VERSIONS OF EDITLINE IS THAT FOR INTERNAL
;;USE, EDIT-LINE RETURNS PARSED LINE, FOR LOGO USER, EDITLINE DOES NOT.

(DEFINE EDITLINE (ABB EDL) (NUMBER) (EDIT-LINE NUMBER) NO-VALUE) 

;; THIS VERSION OF EDIT-LINE PROVIDES TYPE CHECKING, PRINT OUT OF OLD LINE, ETC. 
;;NOTE THAT FOR EDITING LINES, ALL THAT IS NECESSARY IS (SETQ OLD-LINE <UNPARSED
;;VERSION OF OLD LINE NUMBER>)

(DEFUN EDIT-LINE (NUMBER) 
       (DEFAULT-FUNCTION 'EDIT-LINE NIL)
       (LET
	((NUMBER (NUMBER? 'EDIT-LINE NUMBER))
	 (LAST-LINE)
	 (THIS-LINE)
	 (NEXT-TAG)
	 (PROMPTER '>))
	(GETLINE PROG NUMBER)
	(OR
	 THIS-LINE
	 (GETLINE
	  PROG
	  (SETQ NUMBER
		(ERRBREAK 'EDIT-LINE
			  (LIST '"NO LINE NUMBERED "
				NUMBER
				'" IN "
				FN)))))
	(TYPE '";EDITING LINE "
	      NUMBER
	      '" OF "
	      FN)
	(LET ((^W)
	      (^R)
	      (NEW-PARSE (REPAIR-LINE (UNPARSE-LOGO-LINE (CONS NUMBER THIS-LINE))))
	      (COPY))
	     (COND ((EQ (CAAR NEW-PARSE) 'INSERT-LINE)
		    (SETQ COPY (APPEND (CDDAR NEW-PARSE) NIL))
		    (EVALS NEW-PARSE)
		    COPY)
		   ((TYPE '";LINE MUST BEGIN WITH A NUMBER"
			  EOL)
		    (EDIT-LINE NUMBER)))))) 

;;WHAT IS THE USER'S INTENTION IN TYPING A LINE STARTING WITH A NUMBER OTHER THAN HE
;;HANDED TO EDITLINE? DOES HE EXPECT OLD LINE NUMBER TO REMAIN? CLOGO & 11LOGO
;;RETAIN OLD NUMBERED LINE.
;;;
;;;
;;REPAIR-LINE TAKES AS INPUT A LINE OF TOKENS, FOR INSTANCE, AS WOULD BE SAVED IN
;;OLD-LINE.  IT RETURNS A CORRECTLY PARSED LINE.

(DEFUN REPAIR-LINE (OLD-LINE) 
       (LET ((PROMPTER '>))
	    (DTERPRI)
	    (MAPC 'DPRINC OLD-LINE)
	    (DTERPRI)
	    (DPRINC PROMPTER)
	    (LOGOREAD))) 

;;*PAGE

;;;      LOGO EDITING CHARACTERS.
;;MAYBE A BETTER IMPLEMENTATION WOULD BE FOR THESE CHARS TO BE LINE-READMACROS WHICH
;;HAPPEN INSIDE THE LINE FUNCTION.  THIS WILL ALLOW PROPER HANDLING OF INFIX MINUS
;;AS WELL AS RUBOUT.  THE IMPLEMENTATION COULD BE THAT LINE CHECKS FOR A "LINEMACRO"
;;PROPERTY.  IF IT FINDS ONE, THEN THE APPROPRIATE ACTION HAPPENS.

[ITS (DEFUN COVER-UP NIL 
	    ;;ON DISPLAY TERMINALS, MAKE CONTROL CHARACTERS DISAPPEAR.
            (COND ((ZEROP TTY))
                  ;;PRINTING TERMINALS OR ARDS'S LOSE.
                  ((= TTY 4.))
                  (T (CURSORPOS 'X) (COND (SAIL) ((CURSORPOS 'X))))))] 

[(OR ITS DEC10) (DEFUN CONTROL-P NIL 
		       ;;CONTROL-P DELETES LAST WORD -- POPS END OF NEW LINE.
		       [ITS (COVER-UP)]
		       (AND
			LINE
			(PROG (^W) 
			 A    (COND
			       ((EQ (CAR LINE) '/ )
				(COND [ITS ((MEMBER TTY '(1. 2. 3. 5.))
					    (CURSORPOS 'X))]
				      ((DPRINC '/ )))
				(POP LINE)
				(GO A))
			       (T
				(MAPC 
				 (COND
				  [ITS ((MEMBER TTY '(1. 2. 3. 5.))
					'(LAMBDA (X) (CURSORPOS 'X)))]
				  ('DPRINC))
				 (NREVERSE (EXPLODEC (CAR LINE))))
				(POP LINE)))))) 
		(DEFUN CONTROL-N NIL 
		       ;; MOVE NEXT WORD FROM THE FRONT OF THE OLD LINE TO THE END
		       ;;OF THE NEW LINE.
		       [ITS (COVER-UP)]
		       (DO NIL
			   ((NOT (EQ (CAR OLD-LINE) '/ )) NIL)
			   (DPRINC '/ )
			   (PUSH '/  LINE)
			   (POP OLD-LINE))
		       (COND (OLD-LINE (DPRINC (CAR OLD-LINE))
				       (PUSH (CAR OLD-LINE) LINE)
				       (POP OLD-LINE)
				       (COND ((NULL OLD-LINE)
					      (DPRINC '/ )
					      (PUSH '/  LINE))
					     ((EQ (CAR OLD-LINE) '/ )
					      (POP OLD-LINE)
					      (DPRINC '/ )
					      (PUSH '/  LINE)))))) 
		(DEFUN CONTROL-R NIL 
		       ;;MOVE THE REST OF THE OLD LINE ON TO THE END OF THE NEW
		       ;;LINE.
		       (IOC T)
		       [ITS (COVER-UP)]
		       (DO NIL
			   ((NULL OLD-LINE)
			    (COND ((EQ (CAR LINE) '/ ))
				  ((DPRINC '/ ) (PUSH '/  LINE)))
			    NIL)
			   (DPRINC (CAR OLD-LINE))
			   (PUSH (CAR OLD-LINE) LINE)
			   (POP OLD-LINE))) 
		(DEFUN CONTROL-S NIL 
		       ;;POP FRONT OF THE OLD LINE.
		       [ITS (COVER-UP)]
		       (DO NIL
			   ((NOT (EQ (CAR OLD-LINE) '/ ))
			    (AND OLD-LINE (POP OLD-LINE))
			    NIL)
			   (POP OLD-LINE)))] 

;;*PAGE

