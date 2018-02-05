
################################################################

		.MACR 21

   a precompiler for programmer code
################################################################


(DEFUN LIST-NO-NILS FEXPR (ELEMENTS) 
       (DO ((TAKEUP-REEL)
	    (TEMP NIL (EVAL (CAR ELEMENTS)))
	    (ELEMENTS ELEMENTS (CDR ELEMENTS)))
	   ((NULL ELEMENTS) (REVERSE TAKEUP-REEL))
	   (AND TEMP (SETQ TAKEUP-REEL (CONS TEMP TAKEUP-REEL))))) 

(DEFUN TOPLEVEL-LIST FEXPR (ELEMENTS) 
       ;;ACTS LIKE LIST EXCEPT THAT IF ANY ELEMEMNT EVALUATES IN TO
       ;;MORE THAN A SINGLE ELEMENT ( - RETURNS A LIST WHOSE CAR IS
       ;;ALSO A LIST - ) THEN THE ELEMENTS OF THAT ELEMENT ARE ADDED
       ;;TO THE SAME LEVEL AS THE SEPARATE ELEMENTS IN THE CALL
       (MAPCAN '(LAMBDA (ELEMENT) (SETQ ELEMENT (EVAL ELEMENT))
				  (COND ((ATOM (CAR ELEMENT))
					 (LIST ELEMENT))
					(T ELEMENT)))
	       ELEMENTS)) 

(DEFUN GRAM-COMP (FILE) 
       (PROG (^Q UNIQUE ^R ^D) 
	     (OR (APPLY 'UREAD FILE)
		 (RETURN 'BAD-FILE-SPECS))
	     (IOC Q)
	     (SETQ UNIQUE (GENSYM))
	     (APPLY 'UWRITE (STATUS CRUNIT))
	     (DO ((R (READ UNIQUE) (READ UNIQUE)))
		 ((EQ R UNIQUE))
		 (COND ((MEMQ (CAR R) '(DEFUN SETQ DEFPROP)))
		       (T (SETQ R (EVAL R))))
		 ((LAMBDA (^R) (SPRINTER R)) T)))
       'REMEMBER/ TO/ UFILE) 

(DEFUN PDEFINE FEXPR (MOBY) 
       (LIST 'DEFUN
	     (CAR MOBY)
	     'NIL
	     (APPEND (LIST 'PROG
			   (APPEND '(FE H
					ME
					NB
					C
					SM
					CUT
					NN
					T1
					T2
					T3
					:RESULT)
				   (CADR MOBY))
			   '(SETQ NN T)
			   '(SETQ CUT END)
			   '(SETQ C
				  (BUILDNODE (SETQ FE (REVERSE REST))
					     (SETQ NB (OR (NB RE) N))
					     N
					     (SETQ H RE)
					     NIL))
			   '(SETR 'PARENT PARENT C))
		     (APPLY ':-SPREAD (CDDR MOBY))
		     (LIST 'FAIL
			   '(SETQ MES ME)
			   '(SETQ N (OR (N RE) NB))
			   '(RETURN NIL)
			   'RETURN
			   '(SETQ MES ME)
			   '(RETURN (REBUILD (REVERSE FE)
					     NB
					     N
					     H
					     SM
					     C)))))) 

(DEFUN :-SPREAD FEXPR (LIST) 
       (MAPCAN 
	'(LAMBDA (EXP) 
	  (PROG (PREDICATE T1 T2 T3) 
		(COND
		 ((ATOM EXP)
		  (RETURN (LIST EXP
				(LIST 'AND
				      'LABELTRACE
				      (LIST 'PASSING (list 'quote exp))))))
		 ((EQ (CAR EXP) 'GOCOND)
		  (RETURN (LIST (LIST 'COND
				      (LIST 'NN
					    (LIST 'GO
						  (CADR EXP)))
				      (LIST 'T
					    (LIST 'GO
						  (CADDR EXP)))))))
		 ((EQ (CAR EXP) ':)
		  (SETQ PREDICATE
			(CADR EXP)
			T1
			(CADDR EXP)
			T2
			(CADDDR EXP))
		  (AND (CDDDDR EXP) (SETQ T3 (CAR (CDDDDR EXP))))
		  (RETURN
		   (LIST
		    (LIST 'SETQ ':RESULT PREDICATE)
		    (COND
		     ((AND T1 (NULL T2))
		      ;;T3 CAN BE EITHER THERE OR NOT
		      (LIST
		       'COND
		       (TOPLEVEL-LIST
			':RESULT
			(COND
			 (T3 (LIST 'COND
				   (TOPLEVEL-LIST (LIST 'NULL
							'NN)
						  (TAG-CHECK T3))
				   (TOPLEVEL-LIST 'T
						  (TAG-CHECK T1))))
			 (T (TAG-CHECK T1))))))
		     ((AND (NULL T1) T2 (NULL T3))
		      (LIST 'COND
			    (TOPLEVEL-LIST (LIST 'NULL
						 ':RESULT)
					   (TAG-CHECK T2))))
		     ((AND (NULL T1) T2 T3)
		      (LIST
		       'COND
		       (LIST (LIST 'NULL ':RESULT)
			     (LIST 'COND
				   (TOPLEVEL-LIST (LIST 'NULL
							'NN)
						  (TAG-CHECK T3))
				   (TOPLEVEL-LIST 'T
						  (TAG-CHECK T2))))))
		     ((AND T1 T2 (NULL T3))
		      (LIST 'COND
			    (TOPLEVEL-LIST ':RESULT
					   (TAG-CHECK T1))
			    (TOPLEVEL-LIST 'T (TAG-CHECK T2))))
		     ((AND T1 T2 T3)
		      (LIST
		       'COND
		       (LIST ':RESULT
			     (LIST 'COND
				   (TOPLEVEL-LIST (LIST 'NULL
							'NN)
						  (TAG-CHECK T3))
				   (TOPLEVEL-LIST 'T
						  (TAG-CHECK T1))))
		       (TOPLEVEL-LIST 'T (TAG-CHECK T2))))
		     ((AND (NULL T1) (NULL T2) T3)
		      (LIST 'COND
			    (TOPLEVEL-LIST (LIST 'AND
						 (LIST 'NULL
						       'NN)
						 ':RESULT)
					   (TAG-CHECK T3))))
		     ((AND (NULL T1) (NULL T2) (NULL T3))
		      (LIST 'I-AM-A-TAG))))))
		 (T (RETURN (LIST EXP))))))
	LIST)) 

(DEFUN TAG-CHECK (TAG-EXP) 
       (COND ((ATOM TAG-EXP) (LIST (LIST 'GO TAG-EXP)))
	     (T (LIST (LIST 'M (CAR TAG-EXP))
		      (LIST 'GO 'FAIL))))) 
