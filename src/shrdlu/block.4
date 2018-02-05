(declare (genprefix blockl))

;;;################################################################
;;;
;;;          BLOCKL - lisp code for the BLOCKS world
;;;
;;;################################################################



(DEFUN ABSVAL (X) (COND ((MINUSP X) (MINUS X)) (X)))

(DEFUN ATAB (X) (OR (ASSQ X ATABLE) (ERT ATABLE)))

(DEFUN CLEAR
       (LOC SIZE OBJ)
       (PROG (W X1 X2)
	     (SETQ OBJ (LISTIFY OBJ))
	     (AND (MEMQ NIL
			(MAPCAR (QUOTE (LAMBDA (X Y)
					       (AND (GREATERP X -1)
						    (GREATERP 1201 (PLUS X Y))
						    T)))
				LOC
				SIZE))
		  (RETURN NIL))
	     (SETQ W ATABLE)
	GO   (COND ((NULL W) (RETURN LOC))
		   ((MEMQ (CAAR W) OBJ))
		   ((AND (LESSP (CAR LOC) (PLUS (CAR (SETQ X1 (CADAR W)))
						(CAR (SETQ X2 (CADDAR W)))))
			 (LESSP (CAR X1) (PLUS (CAR LOC) (CAR SIZE)))
			 (LESSP (CADR LOC) (PLUS (CADR X1) (CADR X2)))
			 (LESSP (CADR X1) (PLUS (CADR LOC) (CADR SIZE)))
			 (LESSP (CADDR LOC) (PLUS (CADDR X1) (CADDR X2)))
			 (LESSP (CADDR X1) (PLUS (CADDR LOC) (CADDR SIZE))))
		    (RETURN NIL)))
	     (SETQ W (CDR W))
	     (GO GO)))

(DEFUN DIFF (X Y) (MAPCAR (FUNCTION DIFFERENCE) X Y))

(DEFUN DIV2 (X) (QUOTIENT X 2))

(DEFUN ENDTIME (LIST TIME) (PROG (Y)
				 (OR (SETQ Y (END? TIME)) (RETURN LIST))
			    UP	 (COND ((NULL LIST) (RETURN NIL))
				       ((NOT (GREATERP (CAAR LIST) Y))
					(RETURN LIST))
				       ((SETQ LIST (CDR LIST)) (GO UP)))))

(DEFUN EV NIL (OR NOMEM $?EV))
(DEFUN FINDSPACE
 (TYPE SURF SIZE OBJ)
 (PROG (XYMAX XYMIN N V X1 X2)
       (SETQ OBJ (LISTIFY OBJ))
       (AND (MEMQ SURF OBJ) (RETURN NIL))
       (COND ((EQ SURF (QUOTE :TABLE)) (SETQ XYMIN (QUOTE (0 0)))
				       (SETQ XYMAX (QUOTE (1200 1200)))
				       (SETQ LEVEL 0)
				       (GO ON))
	     ((SETQ X (ATAB SURF))))
       (COND
	((EQ TYPE (QUOTE CENTER))
	 (COND ((CLEAR (SETQ V
			     (LIST (MAX 0 (PLUS (CAADR X)
						(DIV2 (DIFFERENCE (CAADDR X)
								  (CAR SIZE)))))
				   (MAX 0
					(PLUS (CADADR X)
					      (DIV2 (DIFFERENCE (CADR (CADDR X))
								(CADR SIZE)))))
				   (PLUS (CADDR (CADR X)) (CADDR (CADDR X)))))
		       SIZE
		       OBJ)
		(RETURN V))
	       ((RETURN NIL))))
	((EQ (CAR X) (QUOTE :BOX))
	 (SETQ XYMIN (LIST (CAADR X) (CADADR X)))
	 (SETQ XYMAX (LIST (PLUS (CAADDR X) (CAADR X))
			   (PLUS (CADR (CADDR X)) (CADADR X))))
	 (SETQ LEVEL 1))
	((SETQ X1 (DIV2 (CAR SIZE)))
	 (SETQ Y1 (DIV2 (CADR SIZE)))
	 (SETQ XYMAX
	       (LIST (MIN 1200 (SUB1 (PLUS (CAADDR X) (CAADR X) X1)))
		     (MIN 1200 (SUB1 (PLUS (CADR (CADDR X)) (CADADR X) Y1)))))
	 (SETQ XYMIN (LIST (MAX 0 (DIFFERENCE (CAADR X) X1))
			   (MAX 0 (DIFFERENCE (CADADR X) Y1))))
	 (SETQ LEVEL (PLUS (CADDR (CADR X)) (CADDR (CADDR X))))))
  ON   (SETQ N 10)
       (SETQ X1 (DIFFERENCE (CAR XYMAX) (CAR XYMIN)))
       (SETQ Y1 (DIFFERENCE (CADR XYMAX) (CADR XYMIN)))
  GO   (COND ((ZEROP (SETQ N (SUB1 N))) (RETURN NIL))
	     ((OR (NOT (SETQ V
			     (GROW (LIST (PLUS (CAR XYMIN)
					       (REMAINDER (ABSVAL (RANDOM)) X1))
					 (PLUS (CADR XYMIN)
					       (REMAINDER (ABSVAL (RANDOM)) Y1))
					 LEVEL)
				   XYMIN
				   XYMAX
				   OBJ)))
		  (LESSP (DIFFERENCE (CAADR V) (CAAR V)) (CAR SIZE))
		  (LESSP (DIFFERENCE (CADADR V) (CADAR V)) (CADR SIZE)))
	      (GO GO))
	     ((RETURN (COND ((EQ TYPE (QUOTE RANDOM))
			     (LIST (DIV2 (DIFFERENCE (PLUS (CAAR V) (CAADR V))
						     (CAR SIZE)))
				   (DIV2 (DIFFERENCE (PLUS (CADAR V) (CADADR V))
						     (CADR SIZE)))
				   LEVEL))
			    ((EQ TYPE (QUOTE PACK))
			     (LIST (CAAR V) (CADAR V) LEVEL))
			    ((ERT FINDSPACE /-- TYPE))))))))

(DEFUN GOAL
       FEXPR
       (X)
       (SETQ PLAN NIL)
       (THVAL (LIST (QUOTE THGOAL) (CAR X) (QUOTE (THTBF THTRUE)))
	      (QUOTE ((EV COMMAND))))
       (EVLIS (REVERSE PLAN)))

(DEFUN GROW
 (LOC MIN MAX OBJ)
 (PROG (GROW XL XH XO YL YH YO)
       (SETQ OBJ (LISTIFY OBJ))
       (COND
	((OR
	  (MINUSP (CAAR (SETQ XL (LIST (LIST (DIFFERENCE (CAR LOC) (CAR MIN))
					     NIL)))))
	  (MINUSP (CAAR (SETQ XH (LIST (LIST (DIFFERENCE (CAR MAX) (CAR LOC))
					     NIL)))))
	  (MINUSP (CAAR (SETQ YL (LIST (LIST (DIFFERENCE (CADR LOC) (CADR MIN))
					     NIL)))))
	  (MINUSP (CAAR (SETQ YH (LIST (LIST (DIFFERENCE (CADR MAX) (CADR LOC))
					     NIL)))))
	  (NULL
	   (ERRSET
	    (MAPC
	     (FUNCTION
	      (LAMBDA (X)
	       (PROG (XX YY)
		     (COND ((OR (MEMQ (CAR X) OBJ)
				(NOT (LESSP (CAADR X) (CAR MAX)))
				(NOT (LESSP (CADADR X) (CADR MAX)))
				(NOT (GREATERP (SETQ XX (PLUS (CAADR X)
							      (CAADDR X)))
					       (CAR MIN)))
				(NOT (GREATERP (SETQ YY (PLUS (CADADR X)
							      (CADR (CADDR X))))
					       (CADR MIN)))
				(NOT (GREATERP (PLUS (CADDR (CADR X))
						     (CADDR (CADDR X)))
					       (CADDR LOC))))
			    (RETURN NIL))
			   ((GREATERP (CAADR X) (CAR LOC))
			    (SETQ XH
				  (ORDER (LIST (DIFFERENCE (CAADR X) (CAR LOC))
					       (CAR X))
					 XH)))
			   ((LESSP XX (CAR LOC))
			    (SETQ XL (ORDER (LIST (DIFFERENCE (CAR LOC) XX)
						  (CAR X))
					    XL)))
			   ((SETQ XO (CONS (CAR X) XO))))
		     (COND ((GREATERP (CADADR X) (CADR LOC))
			    (SETQ YH (ORDER (LIST (DIFFERENCE (CADADR X)
							      (CADR LOC))
						  (CAR X))
					    YH)))
			   ((LESSP YY (CADR LOC))
			    (SETQ YL (ORDER (LIST (DIFFERENCE (CADR LOC) YY)
						  (CAR X))
					    YL)))
			   ((MEMQ (CAR X) XO) (ERR NIL))
			   ((SETQ YO (CONS (CAR X) YO)))))))
	     ATABLE))))
	 (RETURN NIL)))
  GO   (COND ((= (SETQ GROW (MIN (CAAR XL) (CAAR XH) (CAAR YL) (CAAR YH)))
		  2000)
	      (RETURN (LIST (LIST (DIFFERENCE (CAR LOC) (CADAR XL))
				  (DIFFERENCE (CADR LOC) (CADAR YL)))
			    (LIST (PLUS (CAR LOC) (CADAR XH))
				  (PLUS (CADR LOC) (CADAR YH))))))
	     ((MAPC (FUNCTION (LAMBDA (Y Z W)
				      (PROG (X)
					    (SETQ X (EVAL W))
					    (COND ((GREATERP (CAAR X) GROW))
						  ((OR (NULL (CADAR X))
						       (MEMQ (CADAR X)
							     (EVAL Y)))
						   (RPLACA X (LIST 2000
								   (CAAR X))))
						  ((SET Z (CONS (CADAR X)
								(EVAL Z)))
						   (SET W (CDR X)))))))
		    (QUOTE (YO YO XO XO))
		    (QUOTE (XO XO YO YO))
		    (QUOTE (XL XH YL YH)))
	      (GO GO)))))

(DEFUN LISTIFY (X) (COND ((ATOM X) (LIST X)) (X)))

(declare (*expr fn))

(DEFUN LOCGREATER (X Y FN) ((LAMBDA (XX YY)
				    (NOT (LESSP (FN (CADR XX))
						(PLUS (FN (CADR YY))
						      (FN (CADDR YY))))))
			    (LOCG2 (QUOTE $?YY) X)
			    (LOCG2 (QUOTE $?ZZ) Y)))



(DEFUN LOCG2 (X Y) (COND ((EQ $?LOC (QUOTE #LOC)) (ATAB Y))
			 ((CONS NIL (CONS (EVAL X) (CDDR (ATAB Y)))))))

(DEFUN MEMOREND FEXPR (A) (OR NOMEM (AND (PUTPROP $?EV THTIME (QUOTE END))
					 (APPLY (QUOTE THASSERT)
						(LIST (THVARSUBST (CAR A) NIL )))
					 (PUTPROP $?EV (CAAR A) (QUOTE TYPE)))))

(DEFUN MEMORY NIL (OR NOMEM (THAND (THVSETQ $_EV (MAKESYM (QUOTE E)))
				   (THSETQ EVENTLIST (CONS $?EV EVENTLIST))
				   (PUTPROP $?EV THTIME (QUOTE START))
				   (PUTPROP $?EV $?WHY (QUOTE WHY)))))

(DEFUN OCCUPIER
       (X Y Z)
       (PROG (W X1 X2)
	     (COND ((MINUSP Z) (RETURN (QUOTE :TABLE))))
	     (SETQ W ATABLE)
	GO   (COND ((NULL W) (RETURN NIL))
		   ((AND (LESSP (SUB1 (CAR (SETQ X1 (CADAR W))))
				X
				(PLUS (CAR X1) (CAR (SETQ X2 (CADDAR W)))))
			 (LESSP (SUB1 (CADR X1)) Y (PLUS (CADR X1) (CADR X2)))
			 (LESSP (SUB1 (CADDR X1)) Z (PLUS (CADDR X1)
							  (CADDR X2))))
		    (RETURN (CAAR W))))
	     (SETQ W (CDR W))
	     (GO GO)))

(DEFUN ORDER (X Y) (COND ((NULL Y) (LIST X))
			 ((GREATERP (CAR X) (CAAR Y))
			  (CONS (CAR Y) (ORDER X (CDR Y))))
			 ((CONS X Y))))

(DEFUN PACKO
       (OBJ TYPE)
       (PROG (XX)
	     (MAPC (FUNCTION (LAMBDA (X)
				     (AND (THVAL (QUOTE (THGOAL (#IS $?X
								     $E
								     TYPE)))
						 (LIST (LIST (QUOTE X) X)))
					  (SETQ XX (PACKORD X (SIZE X) XX)))))
		   OBJ)
	     (RETURN (MAPCAR (QUOTE CADR) XX))))

(DEFUN PACKON
       (SURF LIST)
       (PROG (X)
	     (SETQ SURF (ATAB SURF))
	GO   (COND ((NULL LIST) (RETURN NIL))
		   ((OR (GREATERP (CAR (SETQ X (SIZE (CAR LIST))))
				  (CAADDR SURF))
			(GREATERP (CADR X) (CADR (CADDR SURF)))
			(GREATERP (PLUS (CADDR X)
					(CADDR (CADR SURF))
					(CADDR (CADDR SURF)))
				  501))
		    (SETQ LIST (CDR LIST))
		    (GO GO))
		   ((RETURN (CAR X))))))

(DEFUN PACKORD
       (X SIZE LIST)
       (COND ((NULL LIST) (LIST (LIST SIZE X)))
	     ((OR (GREATERP (CAAAR LIST) (CAR SIZE))
		  (AND (EQ (CAR SIZE) (CAAAR LIST))
		       (GREATERP (CADAAR LIST) (CADR SIZE))))
	      (CONS (CAR LIST) (PACKORD X SIZE (CDR LIST))))
	     ((CONS (LIST SIZE X) LIST))))
(DEFUN SIZE (X) (COND ((EQ X (QUOTE :BOX)) (QUOTE (400 400 300)))
		      ((EQ X (QUOTE :TABLE)) (QUOTE (1200 1200 1200)))
		      ((ATOM X) (CADDR (ATAB X)))
		      (X)))

(DEFUN STARTHISTORY
 NIL
 (SETQ THTIME 0)
 (SETQ GRASPLIST NIL)
 (DEFPROP EE COMMAND WHY)
 (DEFPROP EE 0 START)
 (DEFPROP EE 0 END)
 (DEFPROP EE #START TYPE)
 (SETQ EVENTLIST (QUOTE (EE)))
 (THADD (QUOTE (#START EE :DIALOG)) NIL)
 (ERRSET (CLEANOUT E) NIL)
 (MAPC
  (QUOTE
   (LAMBDA (X)
    (AND (GET (CAR X) (QUOTE THASSERTION))
	 (PUTPROP (CAR X)
		  (LIST (LIST 0
			      (CADR X)
			      (CADAR (THVAL (QUOTE (THGOAL (#SUPPORT $?X $?Y)))
					    (LIST (LIST (QUOTE X)
							(QUOTE THUNASSIGNED))
						  (LIST (QUOTE Y) (CAR X)))))))
		  (QUOTE HISTORY)))))
  ATABLE))

(DEFUN STARTIME (LIST TIME) (LESSP (CAAR LIST) (OR (START? TIME) -1)))

(DEFUN SUPPORT
       (LOC SIZE X)
       (COND ((EQ (CADDR LOC) 0) (QUOTE :TABLE))
	     ((SETQ LOC (OCCUPIER (PLUS (CAR LOC) (DIV2 (CAR SIZE)))
				  (PLUS (CADR LOC) (DIV2 (CADR SIZE)))
				  (SUB1 (CADDR LOC))))
	      (COND ((EQ LOC X) NIL) (LOC)))))

(DEFUN TCENT (X1 X2) (LIST (PLUS (CAR X1) (DIV2 (CAR X2)))
			   (PLUS (CADR X1) (DIV2 (CADR X2)))
			   (PLUS (CADDR X1) (CADDR X2))))

(DEFUN TFIND (X Y) (PROG (Z)
			 (OR (SETQ Z (GET X (QUOTE HISTORY))) (RETURN NIL))
		    UP	 (COND ((NOT (GREATERP (CAAR Z)
					       (OR (END? Y) 77777)))
				(RETURN Z))
			       ((SETQ Z (CDR Z)) (GO UP)))))

(DEFUN TIMECHK
       (EV TIME)
       (COND ((IMPERF? TIME)
	      (NOT (OR (LESSP (GET EV (QUOTE END)) (OR (START? TIME) -1))
		       (LESSP (OR (END? TIME) 777777)
			      (GET EV (QUOTE START))))))
	     ((NOT (OR (LESSP (GET EV (QUOTE START)) (OR (START? TIME) -1))
		       (LESSP (OR (END? TIME) 777777)
			      (GET EV (QUOTE END))))))))

