(declare (genprefix show))

;;;  quickies 

(defun shstpo nil ;"sh-standard-printout"
(parsings))

(defun parsings nil
(printc '/ / ratio/ of/ winning/ parses/ to/ total/ )
(princ (get 'parsings 'wins))
(princ '//)
(princ parsings))

(defun parsetrace labels
(cond ((= (arg nil) 0)
       (setq parsetrace 'all))
      (t (setq parsetrace (listify labels))) ))

(defun parsebreak labels
(cond ((= (arg nil) 0)
       (setq parsebreak 'all))
      (t (setq parsebreak (listify labels))) ))

(defun fancytimer off?
(cond ((= (arg nil) 1)
       (setq sh-print-time nil))
      (t (setq sh-print-time 'fancy)) ))

(defun totaltime off?
(cond ((= (arg nil) 1) 
       (setq sh-print-time nil))
      (t (setq sh-print-time t)) ))

(defun smntrace off?
(cond ((= (arg nil) 1)
       (setq smntrace nil))
      (t (setq smntrace t)) ))

(defun smnbreak off?
(cond ((= (arg nil) 1)
       (setq smnbreak nil))
      (t (setq smnbreak t)) ))









(DEFUN LBK FEXPR (LABELS) (SETQ LABELBREAK LABELS))
(DEFUN LABELTRACE FEXPR (A) 
       (MAPC 
	'(LAMBDA (X) 
	  (PROG (BODY) 
		(PRINT X)
		(COND ((GET X 'LABELTRACED)
		       (PRINC 'ALLREADY-)
		       (GO TRACED))
		      ((GET X 'INTERPRET)
		       (SETQ BODY (CDR (GET X 'INTERPRET))))
		      ((GET X 'EXPR)
		       (SETQ BODY (CDDR (CADDR (GET X 'EXPR)))))
		      (T (PRINC 'CAN/'T/ BE-) (GO TRACED)))
		(MAP '(LAMBDA (Y) 
			      (AND (ATOM (CAR Y))
				   (RPLACD Y
					   (CONS (LIST 'PASSING
						       (LIST 'QUOTE
							     (CAR Y)))
						 (CDR Y)))))
		     BODY)
		(PUTPROP X T 'LABELTRACED)
	   TRACED
		(PRINC 'LABELTRACED)))
	A))


(DEFUN PASSING (A) 
       (SETQ LASTLABEL A)
       (AND (COND ((ATOM LABELTRACE)
		   (AND LABELTRACE (PRINT 'PASSING) (PRINC A)))
		  ((MEMQ A LABELTRACE)
		   (PRINT 'PASSING)
		   (PRINC A)))
	    (COND ((ATOM LABELBREAK)
		   (AND LABELBREAK (ERT LABELBREAK)))
		  ((MEMQ A LABELBREAK) (ERT LABELBREAK)))))


(SETQ LABELTRACE NIL)

(SETQ LABELBREAK NIL)

(DEFUN UNLABELTRACE FEXPR (A) 
       (MAPC 
	'(LAMBDA (X) 
		 (PROG (BODY) 
		       (PRINT X)
		       (COND ((NOT (GET X 'LABELTRACED))
			      (PRINC 'ISN/'T/ ALLREADY-)
			      (GO TRACED))
			     ((GET X 'INTERPRET)
			      (SETQ BODY (CDR (GET X
						   'INTERPRET))))
			     ((GET X 'EXPR)
			      (SETQ BODY (CDDR (CADDR (GET X
							   'EXPR)))))
			     (T (PRINC 'CAN/'T/ BE-)
				(GO TRACED)))
		       (MAP '(LAMBDA (Y) (AND (ATOM (CAR Y))
					      (RPLACD Y (CDDR Y))))
			    BODY)
		       (PUTPROP X NIL 'LABELTRACED)
		       (PRINC 'UN)
		  TRACED
		       (PRINC 'LABELTRACED)))
	A))


(DEFS TELLABLE
      TELL
      '(LAMBDA (X) (APPLY 'TELLABLE
			 (LIST (CHARG X
				      'CONCEPT:
				      '(ANY PLANNER
					    GOAL
					    PATTERN
					    BEGGININGWHITH
					    THIS
					    CONCEPT
					    NAME
					    CAN
					    BE
					    ACCEPTED
					    BY
					    THE
					    SYSTEM
					    ASNEW
					    INFORMATION
					    --
					    BEWARE
					    OF
					    INTERACTIONS
					    WITH
					    SPECIALHACKS
					    FOR
					    LOCATION/,
					    ETC/.))))))

(DEFUN PEV (EV COL TOP) 
       (TERPRI)
       (TAB COL)
       (PRINC EV)
       (PRINC '/ / )
       (PRINC (GET EV 'TYPE))
       (PRINC '/ / TIME:/ )
       (PRINC (GET EV 'START))
       (PRINC '/ TO/ )
       (PRINC (GET EV 'END))
       (AND TOP
	    (PRINC '/ REASON:/ )
	    (PRINC (GET EV 'WHY)))
       (MAPC '(LAMBDA (X) (AND (EQ EV (GET X 'WHY))
			       (PEV X (PLUS COL 8.) NIL)))
	     (REVERSE EVENTLIST)))

(DEFS EVENT
      SHOW
      (LAMBDA (X) 
	      (SETQ X (CHARG X
			     'EVENT:
			     '(EVENT TO
				     BE
				     DISPLAYED
				     --<LF>
				     FOR
				     ENTIRE
				     EVENT
				     LIST)))
	      (COND (X (PEV X 0. T))
		    (T (MAPC '(LAMBDA (Y) 
				      (AND (EQ 'COMMAND
					       (GET Y 'WHY))
					   (PEV Y 0. T)))
			     (REVERSE EVENTLIST))))))

(DEFUN ABBREVIATE FEXPR (A) 
       (MAPCAR '(LAMBDA (X) 
			(PUTPROP (READLIST (MAPCAR '(LAMBDA (X Y) X)
						   (EXPLODE X)
						   '(T T)))
				 X
				 'ABBREV))
	       A)
       'DONE)

(ABBREVIATE SHOW
	    TELL
	    LISP
	    PLANNER
	    PARSING
	    DEFINITIONS
	    SCENE
	    INPUT
	    RUN
	    SEMANTICS
	    PROPERTY
	    FUNCTION
	    VALUE
	    ASSERTIONS
	    THEOREM
	    SCENE
	    ACTION
	    NODE
	    TREE
	    LABEL
	    ATTEMPT
	    UNIT
	    WORD
	    MARKER
	    ALL
	    REST
	    CURRENT
	    STOP
	    DO)

(DEFUN SHOWSCENE (X) 
       (PROG (PLANNERSEE) 
	     (TERPRI)
	     (TAB 16.)
	     (PRINC 'CURRENT/ SCENE)
	     (TERPRI)
	     (TERPRI)
	     (MAPC 
	      '(LAMBDA (OBJ) 
		(PRINT OBJ)
		(PRINC '-->/ / )
		(EVLIS (CAR (NAMEOBJ OBJ 'DESCRIBE)))
		(PRINC '/ AT/ )
		(PRINC (CADR (ASSOC OBJ ATABLE)))
		(AND (SETQ OBJ
			   (THVAL '(THFIND ALL
					   $?X
					   (X)
					   (THGOAL (#SUPPORT $?OBJ
							     $?X)))
				  (LIST (LIST 'OBJ OBJ))))
		     (TAB 13.)
		     (PRINC 'SUPPORTS/ )
		     (PRINC OBJ)))
	      '(:B1 :B2 :B3 :B4 :B5 :B6 :B7 :B10 :BOX))
	     (TERPRI)
	     (SAY THE HAND IS GRASPING)
	     (PRINC '/ )
	     (PRINC (COND ((SETQ OBJ
				 (THVAL '(THGOAL (#GRASPING $_X))
					'((X THUNBOUND))))
			   (CADAR OBJ))
			  (T 'NOTHING)))))

(DEFUN TELLCHOICE (NODE) (SETQ NODE (CAR NODE)) (SHOWTELLCHOICE))

(DEFUN SHOWCHOICE (NODE) (SETQ NODE (CAR NODE)) (SHOWTELLCHOICE))

(DEFUN SHOWTELL (A NODE SYSTEMS INFO ACTION) 
       (COND ((NULL A) (SHOWTELLCHOICE))
	     ((GET (CAR A) ACTION)
	      (APPLY (GET (CAR A) ACTION) (LIST A)))
	     ((PRINTEXT '(I DON/'T KNOW HOW TO))
	      (PRINT2 ACTION)
	      (PRINT2 (CAR A))))
       '*)

(DEFUN SHOWTELLCHOICE NIL 
       (APPLY (GET (SETQ NODE (QUERY '(WHICH OPTION?)
				     (PRINT (GET NODE SYSTEMS))
				     (GET NODE INFO)))
		   ACTION)
	      (LIST (LIST NODE))))

(DEFUN SUBLEAF (KID DAD) 
       (CATCH (AND (MAPC 'SUBL2 (GET DAD SYSTEMS)) NIL)))

(DEFUN SUBL2 (X) 
       (COND ((EQ X KID) (THROW T))
	     (T (MAPC 'SUBL2 (GET X SYSTEMS)))))

(DEFUN QUERY (TEXT CHOICES HELP) 
       (PROG (EXPL CH2 EX2 CH3 EX3 CHAR NOTINIT) 
	     (SETQ EXPL (MAPCAR 'EXPLODE
				(CONS 'QUIT CHOICES)))
	TOP  (SETQ CH2 (CONS 'QUIT CHOICES) EX2 EXPL)
	     (PRINTEXT TEXT)
	READ (COND ((MEMBER (SETQ CHAR (READCH)) BREAKCHARS)
		    (COND ((NOT NOTINIT) (GO READ))
			  ((CDR CH2) (TYO 7.) (GO READ))
			  (T (MAPC 'PRINC (CAR EX2))
			     (AND (EQ (CAR CH2) 'QUIT)
				  (ERR NIL))
			     (RETURN (CAR CH2)))))
		   ((EQ CHAR (ASCII 10.)) (GO READ))
		   ((EQ CHAR '?) (PRINTEXT HELP) (GO CHOICES)))
	     (SETQ CH3 NIL EX3 NIL)
	     (MAPC '(LAMBDA (X Y) (AND (EQ CHAR (CAR X))
				       (SETQ CH3 (CONS Y CH3))
				       (SETQ EX3 (CONS (CDR X) EX3))))
		   EX2
		   CH2)
	     (AND CH3
		  (SETQ EX2 EX3 CH2 CH3)
		  (SETQ NOTINIT T)
		  (GO READ))
	GO   (OR (MEMBER (READCH) BREAKCHARS) (GO GO))
	CHOICES
	     (PRINTEXT '(THE CHOICES ARE:))
	     (PRINT CHOICES)
	     (GO TOP)))

(DEFUN REQUEST (TEXT HELP) 
       (PROG (X) 
	TOP  (PRINTEXT TEXT)
	READ (COND ((MEMBER (ASCII (TYIPEEK)) BREAKCHARS)
		    (READCH)
		    (GO READ))
		   ((EQUAL (TYIPEEK) 10.) (READCH) (RETURN NIL))
		   ((EQ (ASCII (TYIPEEK)) '?)
		    (READCH)
		    (PRINTEXT (OR HELP
				  '(NO INFORMATION AVAILABLE)))
		    (GO TOP))
		   ((EQ (SETQ X (READ)) 'QUIT) (ERR NIL))
		   (T (RETURN X)))))

(DEFUN SHOWPROP (X) 
       (COND ((NULL X)
	      (SHOWPROP (CONS (REQUEST 'ATOM:
				       '(THE NAME
					     OF
					     THE
					     ATOM
					     WHOSE
					     PROPERTY
					     (IES)
					     YOU
					     WANT
					     TO
					     EXAMINE))
			      (LISTIFY (REQUEST 'PROPERTY:
						'(THE PROPERTY
						      (IES)
						      YOU
						      WANT
						      TO
						      SEE/.
						      A
						      LINE
						      FEED
						      MEANS
						      ALL
						      PROPERTIES
						      OF
						      THE
						      ATOM))))))
	     ((CDR X) (APPLY 'DISP X))
	     (T (PROG (DPSTOP) (DP (CAR X))))))

(DEFUN TELL FEXPR (A) 
       (SHOWTELL A
		 'CANTELL
		 'TELLTREE
		 'TELLINFO
		 'TELL))

(DEFUN TREEPRINT (ROOT TR COL) 
       (TERPRI)
       (TAB COL)
       (PRINC ROOT)
       (MAPC '(LAMBDA (X) (TREEPRINT X TR (PLUS COL 8.)))
	     (GET ROOT TR))
       '*)

(DEFUN CHARG (X TEXT HELP) 
       (COND ((CDR X) (CADR X)) (T (REQUEST TEXT HELP))))

(DEFUN SHOW FEXPR (A) 
       (SHOWTELL A
		 'CANSHOW
		 'SHOWTREE
		 'SHOWINFO
		 'SHOW))

(DEFS CANSHOW
      SHOWTREE
      (SHOW TELL LISP PLANNER PARSING DEFINITIONS INPUT)
      SHOWINFO
      (THINGS WHICH CAN BE DISPLAYED)
      SHOW
      SHOWCHOICE)

(DEFS CANTELL
      TELLTREE
      (LISP PLANNER PARSING DEFINITIONS SEMANTICS)
      TELLINFO
      (THINGS WHICH CAN BE SET TO CONTROL HOW THE SYSTEM RUNS)
      TELL
      TELLCHOICE)

(DEFS SHOW
      SHOW
      (LAMBDA (X) (TREEPRINT 'CANSHOW 'SHOWTREE 0.)))

(DEFS TELL
      SHOW
      (LAMBDA (X) (TREEPRINT 'CANTELL 'TELLTREE 0.)))

(DEFS LISP
      SHOWTREE
      (PROPERTY FUNCTION VALUE)
      TELLTELLCHOICE
      TELLTREE
      (FUNCTION)
      SHOW
      SHOWCHOICE)

(DEFS DO
      TELL
      '(LAMBDA (X) (PRINTEXT '(NOT YET DEFINED))))

(DEFS STOP
      TELL
      (LAMBDA (X) (SETQ DPSTOP (ONOFF X
				      '(STOP AFTER
					     DISPLAYING
					     EACH
					     NODEAND
					     SEMANTIC
					     STRUCTURE?)))
		  (SETQ PLANNERSEE
			(AND PLANNERSEE
			     (COND ((ONOFF X
					   '(STOP AFTER
						  SHOWING
						  PLANNER
						  INPUT?))
				    T)
				   ('NOSTOP))))))

(DEFS PLANNER
      SHOWTREE
      (ASSERTIONS THEOREM SCENE EVENT)
      SHOW
      SHOWCHOICE
      TELLTREE
      (INPUT ACTION THEOREM ASSERTIONS TELLABLE )
      TELL
      (LAMBDA (X) 
	      (COND ((NULL (CDR X)) (TELLCHOICE X))
		    ((EQ (CADR X) 'ON)
		     (IOC W)
		     (THTRACE THEOREM THASSERT THERASE (THGOAL T T))
		     (SETQ PLANNERSEE T))
		    ((EQ (CADR X) 'OFF)
		     (IOC W)
		     (SETQ PLANNERSEE NIL)
		     (THUNTRACE))
		    (T (TELLCHOICE X)))
	      (IOC V)))

(DEFS PARSING
      SHOWTREE
      (NODE TREE)
      SHOW
      SHOWCHOICE
      TELLTREE
      (NODE LABEL ATTEMPT)
      TELL
      (LAMBDA (X) (COND ((NULL (CDR X)) (TELLCHOICE X))
			((EQ (CADR X) 'ON)
			 (IOC W)
			 (SETQ PARSENODE-SEE T LABELTRACE T)
			 (TRACE CALLSM PARSE))
			((EQ (CADR X) 'OFF)
			 (IOC W)
			 (SETQ PARSENODE-SEE NIL LABELTRACE NIL)
			 (UNTRACE CALLSM PARSE))
			(T (TELLCHOICE X)))
		  (IOC V)))

(DEFS DEFINITIONS
      SHOWTREE
      (UNIT WORD MARKER )
      SHOW
      SHOWCHOICE
      TELL
      TELLCHOICE
      TELLTREE
      (WORD  MARKER))

(DEFS INPUT
      TELL
      (LAMBDA (X) (SETQ PLANNERSEE
			(ONOFF X '(TO SEE INPUT TO PLANNER))))
      SHOW
      SHOWCHOICE
      SHOWTREE
      (ALL REST CURRENT))

(DEFS SEMANTICS
      TELL
      (LAMBDA (X) (SETQ SMN NIL BUILD-SEE T SMN-STOP T)
		  (COND ((EQ (QUERY '(DO SEMANTIC ANALYSIS?)
				    '(YES NO)
				    NIL)
			     'NO)
			 (SETQ SMN T))
			((EQ (QUERY '(SHOW BUILDING
					   OF
					   SEMANTIC
					   STRUCTURES?)
				    '(YES NO)
				    NIL)
			     'NO)
			 (SETQ BUILD-SEE NIL))
			((EQ (QUERY '(STOP AFTER
					   DISPLAYING
					   SEMANTIC
					   STRUCTURES?)
				    '(YES NO)
				    NIL)
			     'NO)
			 (SETQ SMN-STOP NIL)))))

(DEFS RUN
      TELLTREE
      (STOP DO)
      TELL
      TELLCHOICE
      TELLINFO
      '(PARAMETERS TO CONTROL WHAT SHRDLU DOES AS IT RUNS))

(DEFS PROPERTY SHOW (LAMBDA (X) (SHOWPROP (CDR X))))

(DEFS VALUE
      SHOW
      (LAMBDA (X) (DISP (EVAL (CHARG X
				     'EXPRESSION:
				     '(EXPRESSION TO
						  BE
						  EVALUATED
						  BY
						  THE
						  LISP
						  INTERPRETER))))))

(DEFS FUNCTION
      TELL
      (LAMBDA (X) (SETQ X (LIST (CHARG X
				       'FUNCTION:
				       '(LISP FUNCTION
					      WHOSE
					      ACTION
					      IS
					      TO
					      BE
					      TRACED))
				(COND ((AND (CDR X)
					    (CDDR X)
					    (MEMQ (CADDR X)
						  '(TRACE BREAK
						    UNTRACE
						    UNBREAK)))
				       (CADDR X))
				      (T (QUERY '(TRACE BREAK
							UNTRACE
							OR
							UNBREAK?)
						'(TRACE BREAK
							UNTRACE
							UNBREAK)
						'(TRACE CAUSES
							PRINTOUT
							ON
							ENTRYAND
							EXIT
							OF
							FUNCTION/.
							BREAK
							CAUSES
							LISP
							TO
							STOP
							ON
							ENTRY
							ANDEXIT/,
							ACCEPTING
							USER
							COMMANDS
							AND
							CONTINUING
							WHEN
							<CONTROL
							X>
							IS
							TYPED/.))))))
		  (APPLY (SUBST 'WBREAK 'BREAK (CADR X))
			 (LIST (CAR X))))
      SHOW
      (LAMBDA (X) (APPLY 'GB
			 (LIST (CHARG X
				      'FUNCTION:
				      '(LISP FUNCTION
					     WHOSE
					     LISP
					     DEFINITION
					     IS
					     TO
					     BE
					     SHOWN))))))

(DEFS ASSERTIONS
      TELL
      (LAMBDA (X) (THVAL (LIST 'THASSERT
			       (CHARG X
				      'ASSERTION:
				      '(PLANNER ASSERTION
						TO
						BE
						ADDED
						TO
						DATA
						BASE))
			       '(THTBF THTRUE))
			 NIL))
      SHOW
      (LAMBDA (X) (DA (CHARG X
			     'ATOM:
			     '(SHOW ALL
				    ASSERTIONS
				    WHICH
				    CONTAIN
				    THE
				    GIVEN
				    ATOM)))))

(DEFS THEOREM
      TELL
      DEFINETHEOREM
      SHOW
      (LAMBDA (X) (DISP (GET (CHARG X
				    'THEOREM-NAME:
				    '(PLANNER THEOREM
					      WHOSE
					      DEFINITION
					      IS
					      TO
					      BE
					      SHOWN))
			     'THEOREM))))

(DEFS NODE
      TELL
      (LAMBDA (X) (SETQ PARSENODE-SEE T NODE-STOP T)
		  (COND ((EQ (QUERY '(SEE SUCCESSFUL
					  PARSE
					  NODES
					  BEING
					  BUILT?)
				    '(YES NO)
				    NIL)
			     'NO)
			 (SETQ PARSENODE-SEE NIL))
			((EQ (QUERY '(STOP AFTER DISPLAY OF NODES?)
				    '(YES NO)
				    NIL)
			     'NO)
			 (SETQ NODE-STOP NIL))))
      SHOW
      (LAMBDA (X) 
	      (COND ((GET (CADR X) 'FEATURES) (DP (CADR X)))
		    ((SHOWMOVE (CDR X))
		     (PROG (DPSTOP) (DP (CAR PT)))
		     (RESTOREPT))
		    (T (SAY NO SUCH NODE)))))

(DEFS TREE
      SHOW
      (LAMBDA (X) (COND ((GET (CADR X) 'FEATURES)
			 (WALLP (LIST (CADR X))))
			((SHOWMOVE (CDR X)) (WALLP PT) (RESTOREPT))
			(T (SAY NO SUCH NODE)))))

(DEFS UNIT
      SHOW
      (LAMBDA (X) (APPLY 'DG
			 (OR (CDR X)
			     (LIST(REQUEST 'UNIT:
				      '(GRAMMAR UNIT
						WHOSE
						PROGRAM
						IS
						TO
						BE
						EXAMINED
						--
						E/.G/.
						CLAUSE
						NG
						PREPG
						VG
						ADJG)))))))

(DEFS WORD
      SHOW
      (LAMBDA (X) (DP (CHARG X
			     'WORD:
			     '(ENGLISH WORD IN THE VOCABULARY))))
      TELL
      (LAMBDA (X) (APPLY 'DEFINE
			 (LIST (CHARG X
				      'WORD:
				      '(ENGLISH WORD
						TO
						BE
						DEFINED
						--
						MUST
						BE
						NOUN
						OR
						VERB))))))

(DEFS ACTION
      TELL
      (LAMBDA (X) 
	      (COND ((CDR X)
		     (COND ((EQ (CADR X) 'ON) (SETQ X NIL))
			   ((EQ X 'OFF)
			    (SETQ X '(THUNTRACE)))))
		    ((ONOFF X
			    '(WATCH PLANNER PROGRAMS STEP BY STEP?))
		     (SETQ X NIL))
		    (T (SETQ X '(THUNTRACE))))
	       (COND (X (THUNTRACE))
                     (T (APPLY 'THTRACE '(THEOREM THGOAL THASSERT THERASE))))))

(DEFS LABEL
      TELL
      (LAMBDA (X) (OR (CDR X)
		      (SETQ X (LIST (REQUEST '(TYPE LIST
						    OF
						    LABELS/,
						    OR
						    ON
						    OR
						    OFF:)
					     '(WATCHES PARSER
						       GO
						       PAST
						       PROGRAM
						       LABELS
						       IN
						       THE
						       GRAMMAR)))))
		  (SETQ LABELTRACE (COND ((EQ (CAR X) 'OFF)
					  NIL)
					 (T (CAR X))))))

(DEFS ATTEMPT
      TELL
      (LAMBDA (X) (COND ((ONOFF X
				'(TO SEE
				     ALL
				     ATTEMPTS
				     TO
				     PARSE
				     SYNTACTIC
				     UNITS/,
				     INCLUDING
				     FAILURES))
			 (TRACE PARSE)
			 (TRACE CALLSM))
			(T (UNTRACE PARSE)))))

(DEFUN SHOWMOVE (X) 
       (SETQ SAVEPT PT)
       (APPLY 'MOVE-PT
	      (LISTIFY (OR X
			   (REQUEST 'NODE-SPECIFICATION:
				    '(C MEANS
					CURRENT
					NODE
					--
					H
					IS
					MOST
					RECENTLY
					PARSED
					FOR
					OTHER
					POSSIBILITIES/,
					SEE
					THESIS
					SECTION
					ON
					POINTER-MOVING
					COMMANDS))))))

(DEFUN ONOFF (ARG HELP) 
       (COND ((EQ (CADR ARG) 'ON) T)
	     ((EQ (CADR ARG) 'OFF) NIL)
	     ((EQ 'ON
		  (QUERY '(ON OR OFF?)
			 '(ON OFF)
			 HELP)))))

(DEFUN DEFINETHEOREM (X) 
       (PUTPROP (COND ((CDR X) (SETQ X (CADR X)))
		      (T (SETQ X (MAKESYM 'THEOREM))))
		(NCONC (LIST (QUERY '(WHICH THEOREM TYPE?)
				    '(THANTE THERASING THCONSE)
				    '(ANTECEDENT/, ERASING/,
						   OR
						   CONSEQUENT
						   THEOREM))
			     (LISTIFY (REQUEST 'VARIABLE-LIST:
					       NIL))
			     (REQUEST 'PATTERN:
				      '(A LIST
					  ENCLOSED
					  IN
					  PARENS/,
					  LIKE
					  (#IS $?X #ZOG)))
			     (REQUEST 'BODY:
				      '(LIST OF
					     MICROPLANNER
					     STAEMENTS))))
		'THEOREM)
       (THADD X NIL)
       (PRINT X))

(DEFS MARKER
      TELL
      (LAMBDA (X) 
	      (PROG (Y) 
		    (PUTPROP (SETQ X (CHARG X
					    'MARKER:
					    '(MARKER TO BE ADDED)))
			     (LIST (SETQ Y
					 (REQUEST 'PARENT:
						  '(NODE TO
							 WHICH
							 IT
							 ISATTACHED
							 IN
							 THE
							 TREE))))
			     'SYS)
		    (PUTPROP Y
			     (CONS X (GET Y 'SYSTEM))
			     'SYSTEM)))
      SHOW
      (LAMBDA (X) (TREEPRINT (OR (CHARG X
					'MARKER:
					'(SEMANTIC MARKER
						   WHOSE
						   SUBSETS
						   ARE
						   TO
						   BE
						   EXAMINED/.
						   TYPE
						   <LF>
						   FOR
						   ENTIRE
						   TREE/.))
				 '#SYSTEMS)
			     'SYSTEM
			     0.)))

(DEFS ALL SHOW (LAMBDA (X) (%)))

(DEFS CURRENT SHOW (LAMBDA (X) (PRINTEXT (FROM NB N))))

(DEFS REST SHOW (LAMBDA (X) (PRINTEXT N)))

(DEFS SCENE SHOW SHOWSCENE)

(DEFUN DEFINE FEXPR (A) 
       (PROG (FE TYPE MARK REST TR) 
	     (SETQ A  (COND  (A (CAR A))
                      (T  (REQUEST 'WORD: '( ENGLISH WORD TO
                                            BE DEFINED)))))
	     (SETQ TYPE
		   (QUERY '(NOUN OR VERB?)
			  '(NOUN VERB)
			  '(OTHER TYPES MUST BE DEFINED IN LISP)))
	MAR  (OR (SETQ MARK (REQUEST 'MARKERS:
				     '(LIST OF
					    SEMANTIC
					    MARKERS
					    FOR
					    WORD
					    BEING
					    DEFINED
					    -
					    TO
					    SEE
					    MARKER
					    TREE
					    TYPE
					    <LF>)))
		 (AND (SHOW MARKER #SYSTEMS) (GO MAR)))
	     (SETQ MARK (LISTIFY MARK))
	     (COND
	      ((EQ TYPE 'NOUN)
	       (PUTPROP A '(NOUN NS) 'FEATURES)
	       (PUTPROP
		A
		(LIST
		 (LIST
		  'NOUN
		  (LIST
		   'OBJECT
		   (LIST
		    'MARKERS:
		    MARK
		    'PROCEDURE:
		    (LIS2FY (REQUEST 'PROCEDURE:
				     '(EXPRESSION OR
						  LIST
						  OF
						  EXPRESSIONS
						  TO
						  BE
						  PUT
						  IN
						  PLANNER
						  GOALS
						  TO
						  DESCRIBE
						  OBJECT
						  -
						  USE
						  ***
						  TO
						  REPRESENT
						  OBJECT
						  BEING
						  DESCRIBED
						  BY
						  WORD
						  --
						  E/.G/.
						  (#IS *** #ZOG)
						  OR
						  ((#IS *** #ZOG)
						   (#LOVE :EVERYONE
							  ***)))))))))
		'SEMANTICS)
	       (RETURN T))
	      ((SETQ TR (EQ (QUERY '(TRANSITIVE OR INTRANSITIVE?)
				   '(TRANSITIVE INTRANSITIVE)
				   NIL)
			    'TRANSITIVE))
	       (PUTPROP A '(VB TRANS INF) 'FEATURES))
	      (T (PUTPROP A '(VB ITRNS INF) 'FEATURES)))
	     (SETQ 
	      REST
	      (LIST (LIST (LISTIFY (REQUEST '(RESTRICTIONS ON
							   SUBJECT:)
					    '(LIST OF
						   SEMANTIC
						   MARKERS))))))
	      (AND
	       TR
	       (SETQ 
		REST
		(NCONC REST
		       (LIST (LISTIFY (REQUEST '(RESTRICTIONS ON
							      OBJECT:)
					       '(LIST OF
						      SEMANTIC
						      MARKERS)))))))
	      (PUTPROP
	       A
	       (LIST
		(LIST
		 'VB
		 (LIST
		  'RELATION
		  (LIST 'MARKERS:
			MARK
			'RESTRICTIONS:
			REST
			'PROCEDURE:
			(LIS2FY (REQUEST 'PROCEDURE:
					 '(LIST OF
						EXPRESSIONS
						TO
						BE
						PUT
						INTO
						PLANNER
						GOALS
						TO
						DESCRIBE
						ACTION
						OR
						RELATION
						--
						USE
						#1
						FOR
						SUBJECT/,
						#2
						FOR
						OBJECT/.E/.G/.
						(#SUPPORT #1 #2)
						OR
						((#HAPPY #1)
						 (#SMILING #1)))))))))
	       'SEMANTICS)
	      (RETURN T))))

(DEFUN HELP NIL 
       (COND ((EQ 'S
		  (QUERY '(TYPE L
				FOR
				LONG
				FORM
				(85. LINES)
				S
				FOR
				SHORT
				(16. LINES))
			 '(S L)
			 NIL))
	      (UREAD MINIH DOC DSK LANG))
	     (T (UREAD HELP DOC DSK LANG)))
       (THRUTEXT)
       '*)

(DEFUN LIS2FY (X) 
       (COND ((ATOM X) (LIST (LIST X)))
	     ((ATOM (CAR X)) (LIST X))
	     (X)))
