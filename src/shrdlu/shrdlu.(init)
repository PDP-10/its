;;;   THIS IS A PACKAGE FOR LOADING SHRDLU'S INTO CORE FROM THE DISK FILES.
;;;    THE PROCEDURE IS TO FIRST LOAD A BLISP (IGNORE ALLOCATIONS, THE 
;;;    PROGRAMS DO THEIR OWN). AND UREAD THIS FILE. EXECUTING "LOADSHRDLU"
;;;    WILL GENERATE (AFTER SOME TIME) A FULLY INTERPRETED VERSION. 
;;;    PARTIALLY COMPILED MIXES ARE AVAILLABLE, AS SEEN BELOW.
;;;    THE VARIABLE "VERSION-FILES" KEEPS A RUNNING TAB OF THE FILES
;;;    LOADER VIA "LOADER". IF ANY ERRORS OCCUR DURING READIN THEY
;;;    ARE PROTECTED BY AN "ERRSET" AND LOADING CONTINUES. (NOTE !! IF AN
;;;    UNBOUND PAREN CAUSES THE FILE TO BE TERMINATED TOO SOON, YOU'LL
;;;    NEVER NOTICE)
;;;

(comment symbol 5000)   ;this file can now be used as a lisp init file via. the jcl line

(SETQ *RSET T) 

(DEFUN LOADER (*!?KEY) 
       (OR (ERRSET (EVAL (LIST 'UREAD
			       *!?KEY
			       '>
			       'DSK
			       'SHRDLU))
		   NIL)
	   (AND (PRINT *!?KEY)
		(PRINC 'NOT-FOUND)
		(RETURN NIL)))
       (LOADX)) 

(DEFUN LOADX NIL 
       (PROG (*!?H *!?F *!?EOF) 
	     (SETQ *!?EOF (GENSYM))
	     (PRINT 'READING)
	     (PRINC *!?KEY)
	     (SETQ VERSION-FILES (CONS (STATUS UREAD) VERSION-FILES))
	LOOP ((LAMBDA (^Q) (SETQ *!?H (READ *!?EOF))) T)
	     (AND (EQ *!?H *!?EOF) (RETURN T))
	     (OR (ERRSET ((LAMBDA (^W ^Q) (EVAL *!?H)) T T))
		 (PROG2 (PRINT 'ERROR-IN-FILE) (PRINT *!?H)))
	     (GO LOOP)))


(SETQ VERSION-FILES NIL) 

(DEFUN LOADSHRDLU NIL 
       (ALLOC '(LIST 60000
		     FIXNUM
		     15000
		     SYMBOL
		      15000
                     array 500 ))
       (SETQ PURE NIL)
;       (MAPC 'LOADER '(PLNR THTRAC))
;       (THINIT)
;       (SETQ THINF NIL THTREE NIL THLEVEL NIL)
;       (setq errlist nil)   ;removes micro-planner's fangs
       (MAPC 'LOADER '(SYSCOM MORPHO SHOW))
       (MAPC 'LOADER '(PROGMR GINTER GRAMAR DICTIO))
       (MAPC 'LOADER '(SMSPEC SMASS SMUTIL))
;       (LOADER 'NEWANS)
;       (MAPC 'LOADER '(BLOCKS DATA))
       (FASLOAD TRACE FASL COM COM)
;       (FASLOAD GRAPHF FASL DSK SHRDL1)
       (LOADER 'SETUP)
;       (fasload grindef fasl com com)
       'CONSTRUCTION/ COMPLETED) 


;this now loads all of SHRDLU except the blocks world code, microplanner, and the 
;answering capability.    - the shift to bibop lisp seems to have crippled microplanner
;in a non-obvious way, and the answering code is useless without the blocks world.
(loadshrdlu)