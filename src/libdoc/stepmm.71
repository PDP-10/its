
;;;   STEPMM 						  -*-LISP-*-
;;;   **************************************************************
;;;   ** MACLISP ******* Single-STEPping debugger, by MORGENSTERN **
;;;   **************************************************************
;;;   ** (C) COPYRIGHT 1980 MASSACHUSETTS INSTITUTE OF TECHNOLOGY **
;;;   ****** THIS IS A READ-ONLY FILE! (ALL WRITES RESERVED) *******
;;;   **************************************************************

(eval-when (eval compile)
	   (cond ((status nofeature maclisp))
		 ((status macro /#))
		 ((getl '+INTERNAL-/#-MACRO '(SUBR AUTOLOAD))
		  (setsyntax '/# 'SPLICING '+INTERNAL-/#-MACRO))
		 ((fasload (LISP) SHARPM)))
)
 
(herald STEPMM /71)

(DECLARE (*EXPR %%PRED SPRINT HKSPRINT MEV %%MABBRCONS 
		%%MHOOKCOM %%MDISPLAY-STEPS %%PRIN11 SSTATUS-PAGEP-MMSTEP
		STATUS-PAGEP-MMSTEP) 
	 (*FEXPR HKSTART MATCHF)
	 (*LEXPR HKSHOW MSPRINT ENDPAGEFN)
	 (GENPREFIX MMSTEP-GENPREFIX)) 

(DECLARE (SPECIAL %%NOHOOKPRIN %%HOOKPRIN %%HOOKLEVEL-TOP 
		  %%HOOKLEVEL %%VALUE %%OLDFORM %%BREAKLIST %%AC-FLAG 
		  %%NOHOOKFLAG %%TEMP %%COND  HOOKLIST %%CONDNOTALLOW
		  %%RETCOND EVALHOOK %%HOOK %%TEMP2 %%HOOKCOM %%PRIN11) 
	 (SPECIAL MSPRINT %%TTYSIZE %%AC-SLEEP %%CURSOR-MMSTEP 
		  %%DISPLAYLEVEL %%LOWERDISPLAY %%LOWERDISPLAY-MIN 
		  %%FLATSIZE-MAX %%SPRINTABBR %%SHORTPRIN %%MDISTITLE 
		  %%EYESTRAIN1 %%RESULT-SPRINT %%MDISPLAY-MSG 
		  %%RETURNWAIT %%DONTERASE MMSTEP-BREAK-FCN  /# 
		  %%MMSTEP-NEWIO  MMSTEP-ENDPAGEFN %%FORM) 
	 (SPECIAL CHRCT LINEL)) 


(SETQ *RSET T 
      %%HOOK (FUNCTION %%MHOOK) 
      HOOKLIST () 
      %%NOHOOKFLAG () 
      %%NOHOOKPRIN () 
      %%AC-FLAG T 
      %%HOOKPRIN '(5 5) 
      %%HOOKLEVEL-TOP '(NIL LEVEL 0)
      %%HOOKLEVEL %%HOOKLEVEL-TOP
      %%HOOKCOM (LIST () ()) 
      %%COND () 
      %%RETCOND ()
      %%CONDNOTALLOW T
      %%BREAKLIST ()
      %%RETURNWAIT () 
      MSPRINT '(5 5) )
(OR (GETL 'SPRINT '(EXPR FEXPR SUBR LSUBR FSUBR)) 
   (PUTPROP 'SPRINT (GET 'GRINDEF 'AUTOLOAD) 'AUTOLOAD))  
(SETQ %%AC-SLEEP 0.7)  ;SLEEP SECONDS FOR A OR C MODE.


(SETQ %%CURSOR-MMSTEP ())  ;DISPLAY MODE IF NON-(), IF CAR IS 
            ;() THEN REDISPLAY. DESCIRBED MORE BELOW.
(SETQ %%DISPLAYLEVEL ())  ;DESCRIBED BELOW
(SETQ %%LOWERDISPLAY 5.)   ;(MAX.) NUMBER OF LEVELS BELOW THE 
               ;HEADER TO BE DISPLAYED IN "SHORTPRIN" FORM. 
(SETQ %%LOWERDISPLAY-MIN 2.) ;THE LARGER THE DIFFERENCE BETWEEN
               ;THIS AND %%LOWERDISPLAY THE FEWER REDISPLAYS 
               ;SHOULD BE NEEDED ON THE AVERAGE.
(SETQ %%FLATSIZE-MAX 450.)   ;HEADER IS ABBREVIATE-SPRINTED IF 
             ;NON-() AND FLATSIZE OF FORM EXCEEDS THIS NUMBER. 
             ;IF NEGATIVE, ABBR'D OUTPUT IS ALWAYS DONE 
             ;AND FLATSIZE IS NOT CALLED (THUS CIRCULAR 
             ;STRUCTURES CAN BE HANDLED - FOR SUN; AND "OWL").
(SETQ %%SPRINTABBR '(7. 8.)) ;PRINLEVEL, PRINLENGTH FOR 
               ;ABBREVIATED SPRINTING.
(SETQ %%SHORTPRIN '(3. 3.))  ;PRINLEVEL, PRINLENGTH FOR FORMS 
               ;DISPLAYED BELOW HEADER 
(SETQ %%MDISTITLE ()) 
(SETQ %%EYESTRAIN1 ())  ;SLEEP SECONDS AFTER PARTIAL CLEARING 
                         ;OF SCREEN. 
(SETQ %%RESULT-SPRINT T) ;IF () THEN ABBREVIATE-PRINTS RESULTS 
            ;IN DISPLAY MODE TOO (RATHER THAN SPRINTING). 
(SETQ %%DONTERASE ())  ;IF NON-() PREVENTS ERASING OF SCREEN,
            ;USED BY SN COMMAND. 
(COND ((AND (BOUNDP 'PRIN1) PRIN1 
                  (SETQ %%PRIN11 (GETL PRIN1 '(SUBR LSUBR FSUBR
                                       EXPR FEXPR MACRO))) ) 
       (PUTPROP '%%PRIN11 (CADR %%PRIN11) (CAR %%PRIN11)) ) 
   (T  (SETPLIST '%%PRIN11 (PLIST 'PRIN1)) ))
              ;FOR CIRCULAR LIST HACKERS EG "OWL" 
(SETQ %%TTYSIZE (COND ((STATUS STATUS TTYSIZE) (STATUS TTYSIZE))
		      ('(20. . 70. ))))




(DEFUN  MEV  (%%MEV-FORM) 
   (COND ((AND (BOUNDP 'PRIN1) PRIN1 
                  (SETQ %%PRIN11 (GETL PRIN1 '(SUBR LSUBR FSUBR
                                       EXPR FEXPR MACRO))) ) 
         (PUTPROP '%%PRIN11 (CADR %%PRIN11) (CAR %%PRIN11)) ) 
      (T  (SETPLIST '%%PRIN11 (PLIST 'PRIN1)) ));FOR OWL HACKERS
   (SETQ %%TTYSIZE (COND ((STATUS STATUS TTYSIZE) (STATUS TTYSIZE))
			 ('(20. . 70. ))))
   (SETQ LINEL (LINEL TYO))
   (SSTATUS EVALHOOK T)
   ((LAMBDA (%%HOOKLEVEL %%HOOKCOM %%AC-FLAG %%NOHOOKFLAG 
	       %%NOHOOKPRIN  %%DISPLAYLEVEL %%CURSOR-MMSTEP %%BREAKLIST 
	       %%DONTERASE LINEL CHRCT)
	    (APPLY %%HOOK (LIST %%MEV-FORM))) 
      (APPEND %%HOOKLEVEL-TOP ())  (LIST () ())  () () 
      () () ()  (AND (MEMQ T %%BREAKLIST) T)  
      ()  (LINEL TYO)  0 ) 
   (SSTATUS EVALHOOK () ))




(DEFUN  %%MHOOK  (%%FORM) 
   (COND (%%NOHOOKFLAG  (EVAL %%FORM)) 
      (T (%%MHOOK2 %%FORM) ))    ) 
 
 
 
(DEFUN  %%MHOOK2  (%%FORM) 
;GLOBAL  HOOKLIST %%NOHOOKFLAG %%NOHOOKPRIN %%HOOKLEVEL 
   (COND (%%COND     ;ALLOWS TESTING OF A FORM BEFORE EVALUATION
      (COND ((AND (SETQ %%TEMP (ERRSET 
               (COND ((NOT (CDDR %%COND)) (EVAL (CADR %%COND)) )
                  (T (%%PRED %%COND)))   ) )
               (CAR %%TEMP))
            (COND (%%CURSOR-MMSTEP (SETQ %%MDISPLAY-MSG 
               '(AND (PRINT '********) 
                   (PRINC '/ / / ABOVE/ SATISFIES/ CONDITION) 
                   (PRINC '/ / / )))  ) 
               (T  (PRINT '********) 
                   (PRINC '/ / / CONDITION/ SATISFIED/ :) )) 
            (SETQ %%NOHOOKFLAG ()  %%NOHOOKPRIN ()  ^W ()) 
            (SETQ %%AC-FLAG ()) 
            (RPLACA %%HOOKCOM ())  ) 
         ((NULL %%TEMP) (TERPRI) 
            (PRINC 'ERROR/ IN/ CONDITION:/ / ) (PRINC %%COND) 
            (TERPRI) (PRINC 'TRY/ AGAIN:/ / ) 
            ((LAMBDA (%%NOHOOKPRIN %%AC-FLAG) 
               (%%MHOOKCOM)) () ())   )) )) 
   (COND (%%NOHOOKPRIN) 
      (T  (%%MHOOKPRIN 'FORM  %%FORM T )    ;ORDER IS IMPORTANT
          (%%MHOOKCOM) )) 
   (SETQ %%OLDFORM %%FORM) 
   (PUTPROP %%HOOKLEVEL %%FORM 'OLDFORM) 
   (COND ((OR (ATOM %%FORM) (MEMBER (CAR %%HOOKCOM) '(M N U)) 
               (EQUAL (CAR %%AC-FLAG) 'C))  

      ;** EVALUATION **   WITHOUT "HOOKING" AT LOWER LEVELS 
          (SETQ %%VALUE (EVAL %%FORM)) )     

      (T  (SETQ %%TEMP (LIST (COND ((MEMBER (CAR %%HOOKCOM) 
               '(UU MM NN)) 
               (CAR %%HOOKCOM) )) )  ) 
         (SETQ %%TEMP (APPEND %%TEMP (CDR %%HOOKLEVEL) ())) 
         (PUTPROP %%TEMP (CONS 
               (CONS  (GET %%TEMP 'LEVEL) %%FORM) 
               (GET %%HOOKLEVEL 'STACK))
            'STACK) 
         (PUTPROP %%TEMP (1+ (GET %%TEMP 'LEVEL)) 'LEVEL) 
       
      ;** EVALUATION **   WITH "HOOKING" AT LOWER LEVELS 
        ((LAMBDA (%%HOOKLEVEL)         
           (SETQ %%VALUE (EVALHOOK %%FORM %%HOOK)) 
           ) %%TEMP )        
      
         (AND %%NOHOOKPRIN (< (GET %%HOOKLEVEL 'LEVEL)  
               %%NOHOOKPRIN) 
            (SETQ %%NOHOOKPRIN ()))    )) 
      ;END OF COND ON C M N U
   (OR %%NOHOOKPRIN (MEMBER (CAR %%HOOKCOM) '(M MM)) 
      (%%MHOOKPRIN 'RESULT  %%VALUE T ) )   
   (COND ((OR %%RETCOND %%BREAKLIST) 
      (SETQ %%TEMP2 ()) 
      (COND ((AND %%RETCOND (SETQ %%TEMP (ERRSET   ;ALLOWS 
               (COND ((NOT (CDDR %%RETCOND))   ;TESTING AFTER 
                     (EVAL (CADR %%RETCOND)) )  ;EVALUATION 
                  (T (%%PRED %%RETCOND)))   ) )
               (CAR %%TEMP)) 
            (SETQ %%TEMP2 'RETCOND) )  
         ((NULL %%TEMP) (TERPRI) 
            (PRINC 'ERROR/ IN/ CONDITION:/ / )(PRINC %%RETCOND) 
            (TERPRI) (PRINC 'TRY/ AGAIN:/ / ) 
            ((LAMBDA (%%NOHOOKPRIN) (%%MHOOKCOM)) ())   )) 

      (AND %%BREAKLIST    ;FOR UNCONDITIONAL BREAKING 
         (COND ((MEMBER (GET %%HOOKLEVEL 'LEVEL) %%BREAKLIST)  
             (SETQ %%BREAKLIST (DELETE (GET %%HOOKLEVEL 'LEVEL) 
                  %%BREAKLIST)) 
             (SETQ %%TEMP2 'BREAK) ) 
           ((EQ (CAR (LAST %%BREAKLIST)) T) 
              (SETQ %%TEMP2 'WAIT) )))
      (COND ((AND %%TEMP2 (OR %%RETURNWAIT (EQ %%TEMP2 'WAIT))) 
            (TERPRI) (SETQ ^W ()) (PRINC 'REQUESTED/ BREAK?/ ) 
            (DO KK (SETQ %%TEMP (READCH)) (READCH) 
                  (ZEROP(LISTEN)) )   ) 
         (%%TEMP2 (SETQ %%TEMP 'Y) ) 
         (T  (SETQ %%TEMP ())  )) 
              ;NOTE: TYPING JUST A SPACE WILL BYPASS THE BREAK
      (COND ((MEMBER %%TEMP '(Y B H))   (SETQ ^W ()) 
            (APPLY (FUNCTION (LAMBDA (PRINLEVEL PRINLENGTH) 
               (TERPRI) (PRINC '%%FORM/ / =/ / ) (PRINC %%FORM) 
               (TERPRI) (PRINC '%%VALUE/ =/ / ) (PRINC %%VALUE) 
               )) %%HOOKPRIN ) 
            (PRINC '/ / / /#) 
            ((LAMBDA (*NOPOINT) (PRINC (GET %%HOOKLEVEL 
               'LEVEL)))  T)  
            (BREAK CONDITIONAL/ RETURN/ BREAK 
                  (EQ %%TEMP2 'RETCOND)) 
            (BREAK RETURN/ BREAK 
                  (MEMQ %%TEMP2 '(BREAK WAIT)))  ))  )) 
   %%VALUE     ) 
 
    
 
(DEFUN  %%MHOOKPRIN   (%%TYPE %%ITEM %%PPR)
((LAMBDA  (%%TYPE-PLIST) 
   (SETQ %%TYPE-PLIST '(NIL FORM FORM/ / / :/  
      RESULT / RESULT:/   CURFORM CURFORM:/  )) 
   (COND (%%NOHOOKFLAG) 
      (%%NOHOOKPRIN) 
      (%%CURSOR-MMSTEP  (%%MDISPLAY-STEPS 
         %%ITEM (GET %%HOOKLEVEL 'LEVEL) %%TYPE )  ) 
      (T  (TERPRI)
         (PRINC (GET %%TYPE-PLIST %%TYPE)) 
         (DO ((I (GET %%HOOKLEVEL 'LEVEL) (1- I)))
          ((ZEROP I))
          (TYO 32.)  )  
         (APPLY (FUNCTION (LAMBDA (PRINLEVEL PRINLENGTH) 
               (%%PRIN11 %%ITEM) 
            )) (COND ((EQUAL %%PPR T) %%HOOKPRIN) 
               (T  %%PPR)) )   
         (PRINC '/ / /#) 
         ((LAMBDA (*NOPOINT) (PRINC (GET %%HOOKLEVEL 'LEVEL)) 
            ) T)    )) 
   )  () )     )  
  
 
 
(DEFUN  %%MHOOKCOM  () 
;HOOKLIST %%NOHOOKFLAG %%TEMP ARE GLOBAL 
   (SETQ %%TEMP2 T)   ;IF IT STAYS T MEANS CLEAR NEXT LINE 
   (COND (%%AC-FLAG  
        (COND ((< (GET %%HOOKLEVEL 'LEVEL) (CDR %%AC-FLAG)) 
              (SETQ %%AC-FLAG () ) (SETQ %%NOHOOKPRIN () )  ) 
           ((AND (EQUAL (CAR %%AC-FLAG) 'CC) 
                 (NULL %%NOHOOKPRIN) (EQUAL (CDR %%AC-FLAG) 
                    (GET %%HOOKLEVEL 'LEVEL)))
              (SETQ %%NOHOOKPRIN 
                    (1+ (GET %%HOOKLEVEL 'LEVEL))) )
           ((EQ (CAR %%AC-FLAG) 'CC) 
              (SETQ %%TEMP2 ()) ))  ))

   (COND ((AND (NULL %%CURSOR-MMSTEP)  %%TEMP2 
              (SETQ %%TEMP (CURSORPOS))
              ( < (CAR %%TEMP) (CAR %%TTYSIZE)) ) 
         (TERPRI)    ;CLEAR NEXT LINE: 
         (CURSORPOS (CAR %%TEMP) (CDR %%TEMP)) )) 

   (COND (%%AC-FLAG 
        (AND %%TEMP2 %%AC-SLEEP (SLEEP %%AC-SLEEP))  
        (COND ((NOT (ZEROP (LISTEN))) (SETQ %%AC-FLAG ()) 
              (SETQ %%NOHOOKPRIN ())  )) )) 

   (COND (HOOKLIST (SETQ %%TEMP (CAR HOOKLIST)) 
         (PRINC '////) (PRINC %%TEMP) 
         (SETQ HOOKLIST (CDR HOOKLIST)) ) 
      (%%NOHOOKPRIN   (SETQ %%TEMP ())) 
      (%%NOHOOKFLAG   (SETQ %%TEMP ())) 
      (%%AC-FLAG      (SETQ %%TEMP ())) 
      (T   (PRINC '////  ) 
         (COND ((ERRSET (SETQ %%TEMP (READ))))  
             (T (%%MHOOKCOM) ))  )) 
   (AND (CAR %%CURSOR-MMSTEP)  
      (GET %%CURSOR-MMSTEP 'RESULT-CURSOR)
      (NUMBERP (GET %%CURSOR-MMSTEP 'RESULT-LEVEL))
      (PUTPROP %%CURSOR-MMSTEP T 'RESULT-CURSOR)  ) 
 
;PROCESS NEW COMMAND: 
  (COND ((NULL %%TEMP)) 
     ((AND (OR %%COND %%RETCOND) %%CONDNOTALLOW
            (OR (MEMBER %%TEMP '(C M N U)) 
               (AND (CDR %%TEMP) (EQUAL (CAR %%TEMP) 'U))) ) 
         (TERPRI) 
         (PRINC 'CANNOT/ TEST/ FOR/ CONDITION/ IF/ COMMAND/ IS/ IN/ ) 
         (PRINC '(C M N U)) (TERPRI)(PRINC 'TRY/ ONE/ FROM/ / ) 
         (PRINC '(CC MM NN UU CTOG))
         (PRINC '/ / )   (%%MHOOKCOM) ) 
   ((ATOM %%TEMP) 
    (COND ((MEMBER %%TEMP '(D M N)) (RPLACA %%HOOKCOM %%TEMP)) 
      ((MEMBER %%TEMP '(U UU)) (RPLACA %%HOOKCOM %%TEMP) 
         (SETQ %%NOHOOKPRIN (GET %%HOOKLEVEL 'LEVEL))  ) 
      ((EQUAL %%TEMP 'H) 
         (FUNCALL MMSTEP-BREAK-FCN TYI 8)
         (%%MHOOKPRIN 'CURFORM %%FORM T)
         (%%MHOOKCOM)  ) 
      ((EQUAL %%TEMP 'O) (TERPRI) (PRINC 'PREVIOUS/ FORM:) 
         ((LAMBDA (%%MDISTITLE) 
               (ERRSET (MEV %%OLDFORM)) 
               ) '(PRINC 'PREVIOUS/ FORM:) ) 
            (PRINC '/ / / END/ PREVIOUS/ FORM) (TERPRI) 
         ((LAMBDA (%%CURSOR-MMSTEP) 
            (%%MHOOKPRIN 'CURFORM %%FORM T ) ) ()) 
         (%%MHOOKCOM) 
         (AND %%CURSOR-MMSTEP 
            (RPLACA %%CURSOR-MMSTEP ())) ) 
      ((EQUAL %%TEMP 'Q) (SETQ %%NOHOOKFLAG T) 
        (SETQ %%NOHOOKPRIN 0  %%BREAKLIST ())
        (AND %%COND (PUTPROP '%%COND %%COND 'OLD) 
           (SETQ %%COND ()))
        (AND %%RETCOND (PUTPROP '%%COND %%COND 'OLD) 
           (SETQ %%RETCOND ()))  ) 
      ((EQUAL  %%TEMP 'PP) ((LAMBDA (%%CURSOR-MMSTEP) 
         (%%MHOOKPRIN 'CURFORM  %%FORM '(NIL NIL)) ) ()) 
         (%%MHOOKCOM) ) 
      ((EQUAL %%TEMP 'S) (COND ((CURSORPOS) 
            (SETQ %%DISPLAYLEVEL (CONS 
               (GET %%HOOKLEVEL 'LEVEL) %%DISPLAYLEVEL)) 
            (OR %%CURSOR-MMSTEP (SETQ %%CURSOR-MMSTEP 
                  (LIST ()))) 
            (%%MHOOKPRIN 'CURFORM  %%FORM T ) (%%MHOOKCOM)  )  
         (T  (TERPRI) (TERPRI) 
            (PRINC 'SORRY/,/ YOUR/ TERMINAL/  ) 
            (PRINC 'DOES/ NOT/ HAVE/ APPROPRIATE/ )(TERPRI)
            (PRINC 'CURSOR/ CONTROL/ FOR/ DISPLAY/ ) 
            (PRINC 'MODE/./ / / )   
            (%%MHOOKCOM)  ))  ) 
      ((EQUAL %%TEMP 'SN) (SETQ %%DONTERASE (CURSORPOS)) 
            (PRINC '/ / ) (%%MHOOKCOM) 
            (AND %%DONTERASE (PUTPROP %%CURSOR-MMSTEP 
                  %%DONTERASE 'RESULT-CURSOR)  
               (PUTPROP %%CURSOR-MMSTEP (GET %%HOOKLEVEL 'LEVEL)
                     'RESULT-LEVEL) 
               (PUTPROP %%CURSOR-MMSTEP 
                  (GET %%CURSOR-MMSTEP 'TOPLEVEL)  
                  'RESULT-TOPLEVEL) )   ) 
      ((EQUAL %%TEMP 'PPP) 
         (TERPRI) 
	 (PRINC '/#) 
	 (PRINC (GET %%HOOKLEVEL 'LEVEL)) 
	 (PRINC '/ / CURFORM:/ ) 
         ((LAMBDA (PGPS) 
		  (SSTATUS-PAGEP-MMSTEP T) 
		  (ERRSET (SPRINT %%FORM (SETQ CHRCT (- LINEL (CHARPOS TYO))) 0))  
		  (SSTATUS-PAGEP-MMSTEP PGPS))
	    (STATUS-PAGEP-MMSTEP)) 
         (PRINC '/ / / / / )
	 (%%MHOOKCOM) ) 
      ((EQUAL %%TEMP 'LR) (TERPRI) (PRINC 'LAST/ RESULT:/ / / ) 
         (%%PRIN11 %%VALUE) 
         ((LAMBDA (%%CURSOR-MMSTEP) 
            (%%MHOOKPRIN 'CURFORM %%FORM T ) ) ()) 
         (%%MHOOKCOM)  ) 
      ((EQUAL %%TEMP 'LRS) (TERPRI) (PRINC 'LAST/ RESULT:/ )
         ((LAMBDA (PGPS) 
		  (SSTATUS-PAGEP-MMSTEP T) 
		  (ERRSET (SPRINT %%VALUE LINEL 0))  
		  (SSTATUS-PAGEP-MMSTEP PGPS))
	     (STATUS-PAGEP-MMSTEP)) 
         ((LAMBDA (%%CURSOR-MMSTEP) 
            (%%MHOOKPRIN 'CURFORM %%FORM T ) ) ()) 
         (%%MHOOKCOM)  ) 
      ((EQUAL %%TEMP 'OL) (TERPRI) (PRINC 'PREVIOUS/ FORM:) 
            ((LAMBDA (%%MDISTITLE) 
               (ERRSET (MEV (GET %%HOOKLEVEL 'OLDFORM))) 
               ) '(PRINC 'PREVIOUS/ FORM:) ) 
            (PRINC '/ / / END/ PREVIOUS/ FORM) (TERPRI) 
            ((LAMBDA (%%CURSOR-MMSTEP) 
               (%%MHOOKPRIN 'CURFORM %%FORM T ) ) ()) 
            (%%MHOOKCOM) 
            (AND %%CURSOR-MMSTEP 
               (RPLACA %%CURSOR-MMSTEP ())) )
      ((EQUAL %%TEMP 'P) (%%MHOOKPRIN 'CURFORM  %%FORM  T ) (%%MHOOKCOM) )
      ((EQUAL %%TEMP 'C) (RPLACA %%HOOKCOM 'C)
         (SETQ %%AC-FLAG (CONS %%TEMP (GET %%HOOKLEVEL 'LEVEL))) ) 
      ((EQUAL %%TEMP 'CC) (RPLACA %%HOOKCOM 'CC) 
         (SETQ %%AC-FLAG (CONS %%TEMP (GET %%HOOKLEVEL 'LEVEL)))
         (SETQ %%NOHOOKPRIN (1+ (GET %%HOOKLEVEL 'LEVEL))) ) 
      ((EQUAL %%TEMP 'A) (RPLACA %%HOOKCOM %%TEMP) 
         (SETQ %%AC-FLAG (CONS %%TEMP 0.)) )
      ((EQUAL %%TEMP 'AD) (RPLACA %%HOOKCOM 'A) 
         (SETQ %%AC-FLAG (CONS 'A (1+ (GET %%HOOKLEVEL 'LEVEL)))) ) 
      ((MEMBER %%TEMP '(MM NN)) (RPLACA %%HOOKCOM %%TEMP) 
         (SETQ %%NOHOOKPRIN  (1+ (GET %%HOOKLEVEL 'LEVEL)))  ) 
      ((EQUAL %%TEMP 'E) (TERPRI) (PRINC 'EVAL:/ / ) 
         (SETQ %%TEMP (ERRSET (EVAL (READ)))) 
         (COND (%%TEMP (PRINC '/ / =/ / ) 
               (AND (CURSORPOS) 
		    (SETQ CHRCT (- LINEL (CDR (CURSORPOS))))) 
               (ERRSET (%%PRIN11 (CAR %%TEMP))) )) 
         (PRINC '/ / / / /  ) (%%MHOOKCOM)  ) 
      ((EQUAL %%TEMP 'B) (SETQ %%BREAKLIST (CONS 
            (GET %%HOOKLEVEL 'LEVEL) %%BREAKLIST)) 
         (PRINC '/ / COMMAND:/ ) (%%MHOOKCOM) ) 
      ((EQUAL %%TEMP 'XX) (PRINC '/ ^X) (ERROR 'QUIT) ) 
      ((EQUAL %%TEMP 'CTOG) (SETQ %%CONDNOTALLOW 
            (NOT %%CONDNOTALLOW)) 
         (PRINC '/ / COMMAND:/ ) (%%MHOOKCOM) ) 
      ((EQ %%TEMP 'WTIF)  (PRINC '/ =/ )
            (PRINC (SETQ %%RETURNWAIT (NOT %%RETURNWAIT))) 
            (PRINC '/ / / ) (%%MHOOKCOM) ) 
      ((EQ %%TEMP 'WTALL) 
         (COND ((EQ (CAR (LAST %%BREAKLIST)) T) 
               (SETQ %%BREAKLIST (DELETE  T %%BREAKLIST)) 
               (PRINC '/ =/ ()) ) 
            (T (SETQ %%BREAKLIST (NCONC %%BREAKLIST (LIST T))) 
               (PRINC '/ =/ T) ))  
            (PRINC '/ / / ) (%%MHOOKCOM) ) 
      ((EQUAL %%TEMP 'K) (SETQ %%FORM ()) 
         (RPLACA %%HOOKCOM 'M)  ) 
      (T  (TERPRI) (ERRSET (%%PRIN11 (EVAL %%TEMP))) 
         (PRINC '/ / / / ) (%%MHOOKCOM)  ))    )  
    (T   (COND ((EQUAL (CAR %%TEMP) 'P) 
               (SETQ %%HOOKPRIN (CDR %%TEMP)) 
               (%%MHOOKPRIN 'CURFORM  %%FORM T ) (%%MHOOKCOM) ) 
            ((AND (EQUAL (CAR %%TEMP) '=) (NULL (CDDR %%TEMP))) 
               (SETQ %%FORM (CADR %%TEMP)) 
               (PRINC '/ / COMMAND:/ ) (%%MHOOKCOM) ) 
            ((MEMBER (CAR %%TEMP) '(U UU)) 
               (RPLACA %%HOOKCOM (CAR %%TEMP)) 
               (COND ((ERRSET (SETQ %%TEMP (FIX (EVAL 
                           (CADR %%TEMP)))))
                    (SETQ %%TEMP (COND ((MINUSP %%TEMP) 
                       (+ (GET %%HOOKLEVEL 'LEVEL) %%TEMP 1.) ) 
                      (T (1+ %%TEMP) ))) 
                    (SETQ %%NOHOOKPRIN %%TEMP)  ) 
                 (T (%%MHOOKCOM) ))  )  
            ((EQUAL (CAR %%TEMP) 'S) (COND ((CURSORPOS) 
               (SETQ %%TEMP (ERRSET (EVAL (CADR %%TEMP)))) 
               (COND ((NULL %%TEMP) (%%MHOOKCOM)) 
                  ((NULL (CAR %%TEMP)) 
                           (SETQ %%CURSOR-MMSTEP ()) 
                     (PRINC '/ / / / ) (%%MHOOKCOM) ) 
                  (T (SETQ %%TEMP (COND ((EQ (CAR %%TEMP) T)) 
                        ((MINUSP (CAR %%TEMP)) 
                              (+ (GET %%HOOKLEVEL 'LEVEL) 
                                    (CAR %%TEMP)) )  
                        (T (CAR %%TEMP) ))) 
                     (COND (%%CURSOR-MMSTEP 
                           (SETQ %%DISPLAYLEVEL (CONS %%TEMP 
                              %%DISPLAYLEVEL)) )
                        (T (SETQ %%CURSOR-MMSTEP (LIST ())) 
                           (OR (EQ %%TEMP T) 
                              (SETQ %%DISPLAYLEVEL (CONS %%TEMP 
                                 %%DISPLAYLEVEL)))  ))   
                     (%%MHOOKPRIN 'CURFORM  %%FORM T ) 
                     (%%MHOOKCOM)  ))   )  
               (T  (TERPRI) (TERPRI) 
                 (PRINC 'SORRY/,/ YOUR/ TERMINAL/  ) 
                 (PRINC 'DOES/ NOT/ HAVE/ APPROPRIATE/ )(TERPRI)
                 (PRINC 'CURSOR/ CONTROL/ FOR/ DISPLAY/ ) 
                 (PRINC 'MODE/./ / / )   
                 (%%MHOOKCOM)  ))  ) 
            ((EQUAL (CAR %%TEMP) 'A) (RPLACA %%HOOKCOM 'A-C) 
               (SETQ %%AC-FLAG (CONS 'A (FIX (CADR %%TEMP)))) ) 
            ((AND (EQUAL (CAR %%TEMP) 'MATCHF) 
                  (SETQ %%TEMP (LIST 'COND %%TEMP))  ())) 
            ((MEMBER (CAR %%TEMP) '(COND RETCOND)) 
                           ;DOES NOT EVALUATE ITS ARGUMENT HERE
               (COND ((EQUAL (CAR %%TEMP) 'COND) 
                     (SETQ %%TEMP (CONS '%%COND %%TEMP)) ) 
                  (T  (SETQ %%TEMP (CONS '%%RETCOND %%TEMP)) )) 
               (COND ((CDDR %%TEMP) 
                     (PUTPROP (CAR %%TEMP) (EVAL (CAR %%TEMP)) 'OLD)
                     (SET (CAR %%TEMP) (CDR %%TEMP)) 
                     (OR (CADDR %%TEMP) (SET (CAR %%TEMP) ())) ) 
                  (T ((LAMBDA (OC) (AND (EVAL (CAR %%TEMP)) 
                           (PUTPROP (CAR %%TEMP) 
                              (EVAL (CAR %%TEMP)) 'OLD)) 
                       (SET (CAR %%TEMP) OC) 
                       ) (GET (CAR %%TEMP) 'OLD)) ))
               (COND ((NULL (ERRSET (%%PRED (EVAL (CAR %%TEMP))) ) )  
               ;TEST OF THIS CONDITION 
                  (PRINC 'ERROR/ FOUND/ DURING/ INITIAL/ TEST/ )
                  (PRINC 'OF/ THIS/ CONDITION: )
                  (TERPRI) (PRINC '/ / / / ) 
                  (PRINC (EVAL (CAR %%TEMP))) 
                  (TERPRI) (PRINC 'TRY/ AGAIN:/ / ) (%%MHOOKCOM) )
                (T (PRINC '/ / COMMAND:/ ) (%%MHOOKCOM) )) ) 
              (T  (TERPRI) (ERRSET (%%PRIN11 (EVAL %%TEMP))) 
                 (PRINC '/ / / / ) (%%MHOOKCOM)  ))   )) 
   T   ) 
 




(DEFUN  %%PRED  (%%PREDL) 
   (DO (  (CD  (CDR %%PREDL)  (CDDR CD)) 
          (FLAG ())  (ITEM ())  ) 
       (  (OR (NULL CD) (NOT (ATOM (CAR CD)))) 
          (APPLY 'OR CD)  ) 
       
      (SETQ FLAG  (CAR CD) 
            ITEM  (COND ((MEMBER FLAG '(FORM BIND FCN VALUE AND) )
                        (EVAL (CADR CD)) ) 
                     (T  (CADR CD) ))  ) 
      (COND ( 
         (COND ((MEMBER FLAG '(FORM FORMQ)) (EQUAL %%FORM ITEM))
            ((MEMBER FLAG '(BIND BINDQ)) 
               (COND ((EQUAL (CAR %%FORM) 'PROG) 
                     (MEMBER ITEM (CADR %%FORM)) ) 
                  ((EQUAL (CAAR %%FORM) 'LAMBDA) 
                     (MEMBER ITEM (CADAR %%FORM)) ) 
                  ((EQUAL (CAR %%FORM) 'DO) 
                     (COND ((ATOM (CADR %%FORM)) 
                           (EQUAL ITEM (CADR %%FORM)) )
                        (T (ASSOC ITEM (CADR %%FORM))  )) ))  ) 
            ((EQUAL FLAG 'ATOMVALQ)
               (AND (ATOM %%FORM) (EQUAL %%FORM (CAR ITEM)) 
                  (EQUAL (EVAL %%FORM) (CADR ITEM)))  ) 
            ((EQUAL FLAG 'ATOMVAL) 
               (AND (ATOM %%FORM) 
                  (EQUAL %%FORM (EVAL (CAR ITEM))) 
                  (EQUAL (EVAL %%FORM) (CADR ITEM)))  ) 
            ((MEMBER FLAG '(FCN FCNQ))(EQUAL (CAR %%FORM) ITEM))
            ((MEMBER FLAG '(VALUE VALUEQ)) 
               (AND (EQUAL (CAR %%PREDL) 'RETCOND) 
                  (COND ((EQUAL %%VALUE ITEM) (NULL (CDDR CD)) )
                     (T  (RETURN ()) )) )  )   
            ((MEMBER FLAG '(AND ANDQ)) 
               (COND ((EVAL ITEM) (NULL (CDDR CD)) )
                     (T  (RETURN ()) ))  ) 
            (T  (RETURN (APPLY 'OR CD))  )) 
         (RETURN T)  ))    )      ) 



(DEFUN  MATCHF  FEXPR  (MATCHLIST) 
;PATTERN MATCHES AGAINST CURRENT FORM (IE. VALUE OF %%FORM).
;* MATCHES ANYTHING.  ATOMS AND LISTS SHOULD BE GIVEN AS IN 
;ORIGINAL CODE, EXCEPT THAT FULL S-EXPRESSION NEED NOT BE GIVEN:
;MATCHING SUCCEEDS WHEN ALL GIVEN COMPONENTS MATCH FROM LEFT TO 
;RIGHT.  FOR FANCIER TESTS, (# - - ...) EVALS THE CDR (NOT THE 
;CADR) OF THIS #-LIST AS A PREDICATE WITH  # BOUND TO CURRENT 
;ELEMENT.  (OVERALL PROCEDURE IS APPLIED RECURSIVELY IF AND 
;EMBEDDED LIST IS GIVEN.) 
;SIMPLE EXAMPLES ARE: (MATCHF ATOMX) 
;(MATCHF (SETQ ALPHA)) 
;(MATCHF (PUTPROP NAME * 'SOURCE))
;(MATCHF (SETQ (# MEMBER # '(ALPHA BETA S3)))) SUCCEEDS IF 
;EITHER ALPHA BETA OR S3 ARE SETQ'D. 
;(MATCHF (RPLACD * '(* 9))) ;EG MATCHES (RPLACD URLIST '(2 9 4))
  (OR (EQUAL (CAR MATCHLIST) %%FORM) 
    (DO ( (MATL (CAR MATCHLIST) (CDR MATL)) 
          (FORML %%FORM (CDR FORML)) ) 
        ( (OR (NULL MATL) (NULL FORML))  (NULL MATL) ) 
      (OR (EQ (CAR MATL) '*) 
         (EQUAL (CAR MATL) (CAR FORML)) 
         (AND (NOT (ATOM (CAR MATL))) 
            (COND ((EQ (CAAR MATL) '/#) 
		   (CAR ((LAMBDA (/#) 
				 (COND ((ERRSET (EVAL (CDAR MATL))) )
				       ((BREAK IN/ MATCHF:/ ERROR/ IN/ /#/ SPEC  T) ))) 
			(CAR FORML)) ) ) 
		  ((NOT (ATOM (CAR FORML))) 
		   ((LAMBDA (%%FORM) 
			    (APPLY 'MATCHF (LIST (CAR MATL)) ))
		    (CAR FORML) )  ))  ) 
         (RETURN ()))   ) )    )  



(DEFUN  HKSTART  FEXPR (PRINLIST) 
;IF 1ST ARGUMENT GIVEN, IT WILL BE EVALUATED; THUS TO PRINT
    ;A MESSAGE USE A PRINTING FUNCTION. 
   (SETQ  %%NOHOOKFLAG T   %%AC-FLAG ()  %%NOHOOKPRIN () ) 
   (AND PRINLIST ((LAMBDA (^W) (ERRSET (EVAL (CAR PRINLIST))) 
         )  () ))  
   (EVAL '(SETQ ^W ()  EVALHOOK (FUNCTION %%MHOOK)) 
      (DO  ( (I  5  (1- I)) ;THIS SPECIFIES THE NUMBER OF 
                 ;LEVELS TO GO UP THE STACK WITH RESPECT TO
                 ;THE INSIDE OF THIS DO; SHOULD BE AT LEAST 5 
                 ;UNLESS (EVAL ## (HKSTART ...) ##) IS FOUND 1ST
             (F  (EVALFRAME ())  (EVALFRAME (CADR F)))  ) 
           ((ZEROP I) (CADDDR F))   ;RETURN VALUE OF DO
         (AND (EQUAL (CAADDR F) 'HKSTART) 
              (SETQ I (MIN 1 I)))   )  )  
   (SSTATUS EVALHOOK T) 
   (SETQ %%NOHOOKFLAG ())     )   



(DEFUN  HKSTOP  () 
   (SETQ %%NOHOOKFLAG T  %%NOHOOKPRIN 0  %%BREAKLIST ())
   (SSTATUS EVALHOOK ())
   (AND %%COND (PUTPROP '%%COND %%COND 'OLD) 
      (SETQ %%COND ()))
   (AND %%RETCOND (PUTPROP '%%COND %%COND 'OLD) 
      (SETQ %%RETCOND ()))  ) 



(DEFUN  MBAK () 
   (MAPCAN '(LAMBDA (XB) 
      (COND ((MEMBER (CAR XB)  '(%%MHOOK %%MHOOK2 EVALHOOK MBAK 
               %%MHOOKCOM %%MHOOKPRIN %%MDISPLAY-STEPS 
               %%TRACE-MMSTEP %%MMSTEP-OVER TRACE-MONITOR)) 
             ()) 
         (T  (LIST XB) )) 
      ) (CDR (BAKLIST)) )      ) 

   


(DEFUN  HOOKLEVEL  () 
   (GET %%HOOKLEVEL 'LEVEL)  ) 



(DEFUN  HKSHOW  %%NUM 
   (DO  %%NN  (COND ((ZEROP %%NUM) 
                        ;FOLLOWING SETQ BECAUSE OF COMPILER BUG:
                (SETQ %%NUM (LENGTH (GET %%HOOKLEVEL 'STACK))) )
              (T  (MIN (1- (FIX (ARG 1.)))  
                    (LENGTH (GET %%HOOKLEVEL 'STACK))) ))
           (1- %%NN)  (< %%NN 1) 
      (DO  ( (L %%NN (1- L)) 
             (F (GET %%HOOKLEVEL 'STACK) (CDR F)) ) 
           ( (< L 2) 
             (TERPRI) (PRINC '/#) 
             ((LAMBDA (*NOPOINT) (PRINC (CAAR F)))  T) 
             (PRINC '/ / / ) 
             (APPLY (FUNCTION (LAMBDA (PRINLEVEL PRINLENGTH) 
                (%%PRIN11 (CDAR F)) )) %%HOOKPRIN)  )  ) )  
   (TERPRI) (PRINC '/#) 
   ((LAMBDA (*NOPOINT) (PRINC (GET %%HOOKLEVEL 'LEVEL)))  T)
   (PRINC '/ / / ) 
   (APPLY (FUNCTION (LAMBDA (PRINLEVEL PRINLENGTH) 
      (%%PRIN11 %%FORM) )) %%HOOKPRIN)
   (READLIST ())    )  
 


(DEFUN HKSPRINT (LEV) 
   (TERPRI)
   ((LAMBDA (PGPS) 
	    (SSTATUS-PAGEP-MMSTEP T) 
	    (ERRSET (SPRINT 
		     (COND ((CDR (ASSOC LEV (GET %%HOOKLEVEL 'STACK))))
			   ((EQUAL LEV (GET %%HOOKLEVEL 'LEVEL)) %%FORM)) 
		     LINEL 
		     0))  
	    (SSTATUS-PAGEP-MMSTEP PGPS))
       (STATUS-PAGEP-MMSTEP))  
   (READLIST ())  )  



(DEFUN  GETHKLEVEL  (LEV) 
   (COND ((CDR (ASSOC LEV (GET %%HOOKLEVEL 'STACK))))
      ((EQUAL LEV (GET %%HOOKLEVEL 'LEVEL)) %%FORM))   ) 



(DEFUN  MSPRINT  MSP 
   ((LAMBDA (LVL LENGTH) 
	    (COND ((OR (NULL LVL) (NULL LENGTH) (ATOM (ARG 1.))) 
		   (SPRINT (ARG 1) LINEL 0.) ) 
		  (T  (SETQ LVL (FIX LVL)  LENGTH (FIX LENGTH)) 
		      (SPRINT (%%MABBRCONS (ARG 1.) LVL LENGTH LENGTH) 
			      LINEL 
			      0.)))) 
     (COND ((> MSP 1.) (ARG 2.))  (T (CAR MSPRINT))) 
     (COND ((> MSP 2.) (ARG 3.))  (T (CADR MSPRINT))) ) T)
 

(DEFUN  %%MABBRCONS  (FORM LVL LNTH LENGTH) 
 (COND ((ATOM FORM) FORM)  (T 
   (DO  ( (FF FORM (CDR FF)) 
          (RES ()) ) 
        ((OR (ZEROP LNTH) (NULL FF))  
              (NREVERSE (COND (FF (CONS '::: RES)) (RES)) ) )  
       (SETQ LNTH (1- LNTH)) 
       (SETQ RES (CONS 
          (COND ((ATOM (CAR FF)) (CAR FF) ) 
             ((> LVL 1.) 
                (COND ((ATOM (CDAR FF)) 
                     (CONS (%%MABBRCONS (CAAR FF) (1- LVL) 
                           LENGTH LENGTH)
                        (%%MABBRCONS (CDAR FF) (1- LVL) 
                           LENGTH LENGTH)) )
                  (T (%%MABBRCONS (CAR FF) (1- LVL) 
                        LENGTH LENGTH) ))  )
             (T  '|###|))  RES) )   )   ))    ) 





(DEFUN  %%MDISPLAY-STEPS  (ITEM HKL TYPE-NAME)         
;%%DISPLAYLEVEL IS LIST OF "HEADER" LEVELS, DEEPEST FIRST, EACH 
;REPRESENTED AS (LEVEL# ORIGINALFORM  [SPECIAL-SPRINT-FORM]), 
;WHERE THE LAST MEMBER IS THE FORM FOR ABBREVIATED SPRINTING, 
;IF APPLICABLE (SEE %%FLATSIZE-MAX), ELSE IS ABSENT.  IF CAR OF
;LIST IS A NUMBER THEN THE FORM AT THAT LEVEL NUMBER IS USED AS 
;THE NEW HEADER AND THE LIST MODIFIED TO MAINTAIN THE DECREASING
;DEPTH CHARACTERISTIC.IF CAR IS T THEN %%DISPLAYLEVEL IS POPPED.
;     %%CURSOR-MMSTEP IS USED LIKE A STACK BUT IMPLEMENTED TO 
;AVOID CONS'ING: IT IS A LIST WHOSE CAR IS NUMBER OF EFFECTIVE  
;ENTRIES FROM 1 UP TO NUMBER (IF () CAUSES FULL REDISPLAY). REST 
;IS DISEMBODIED PROPERTY LIST WHERE THE PROPERTY 'LEVELS IS AN
;ASSOC-TYPE LIST EACH COMPONENT OF WHICH IS A LIST OF THE INDEX
;OF THE FORM, THE FORM, CURSORPOSITION AT END OF DISPLAY OF THAT
;FROM, AND HOOKLEVEL OF THAT FORM.  RPLACA IS USED TO UPDATE IT.
;ONE IS USED AS THE INDEX OF THE HEADER FORM, AND THE LARGEST
;NUMBER USED AS INDEX FOR CURRENT (DEEPEST) LEVEL. 
;NEWHDR = HOOKLEVEL OF NEW HEADER ELSE ().
;TOPLV = HOOKLEVEL OF TOP (LOWEST INDEX AND HENCE TOP ON SCREEN)
;        FORM SHOWN BELOW THE HEADER. 
;SAMDISLV = SMALLEST "INDEX" IN %%CURSOR-MMSTEP OF FORM NOT 
;   NEEDING REDISPLAY;  0 IF ALL INCL. HEADER TO BE REDISPLAYED,
;   1 IF ALL LEVELS BELOW HEADER TO BE REDISPLAYED. 
;TOPDISLV = HOOKLEVEL OF FIRST (SMALLEST HOOKLEVEL) FORM TO 
;   REDISPLAY OTHER THAN HEADER. 
;NOTE THAT SOME VARIABLES ARE SET AND RESET MORE THAN ONCE. 
   (PROG (FRM MTEMP NEWHDR TOPLV SAMDISLV TOPDISLV ERASEFROM 
         NEWSTACK) 
   (COND ((AND (EQ (CAR %%DISPLAYLEVEL) T) (CDR %%DISPLAYLEVEL))
         (SETQ %%DISPLAYLEVEL (CDDR %%DISPLAYLEVEL)) 
         (SETQ SAMDISLV 0.) ) 
      ((EQ (CAR %%DISPLAYLEVEL) T) (SETQ %%DISPLAYLEVEL ()) )
      ((NUMBERP (CAR %%DISPLAYLEVEL)) 
        (SETQ NEWHDR (MIN HKL (CAR %%DISPLAYLEVEL))) )) 
 
   (COND ((EQ (GET %%CURSOR-MMSTEP 'RESULT-CURSOR) T) 
         (SETQ %%DONTERASE ()) 
         (SETQ MTEMP (GET %%CURSOR-MMSTEP 'RESULT-LEVEL)) 
         (COND ((NULL (CAR %%CURSOR-MMSTEP)) ) 
            ((NOT ( > MTEMP (OR NEWHDR 
                  (CAAR %%DISPLAYLEVEL)))) 
               (SETQ SAMDISLV 0.) ) 
            ((NOT ( < (OR NEWHDR (CAAR %%DISPLAYLEVEL)) 
                  (GET %%CURSOR-MMSTEP 'RESULT-TOPLEVEL))) 
               (SETQ SAMDISLV 0.) ) 
            ((NOT ( > MTEMP (GET %%CURSOR-MMSTEP 'TOPLEVEL))) 
               (SETQ SAMDISLV 1.) ) 
            (( < (GET %%CURSOR-MMSTEP 'TOPLEVEL) 
                  (GET %%CURSOR-MMSTEP 'RESULT-TOPLEVEL)) 
               (SETQ SAMDISLV 1.) ) 
            (T (SETQ TOPDISLV MTEMP)
              (SETQ SAMDISLV (- (CAR %%CURSOR-MMSTEP) 
                (- (GET %%CURSOR-MMSTEP 'BOTLEVEL) MTEMP -1.))) 
              (SETQ ERASEFROM  (CADDR (ASSOC SAMDISLV  ;CURSOR
                    (GET %%CURSOR-MMSTEP 'LEVELS))))  ))

         (PUTPROP %%CURSOR-MMSTEP () 'RESULT-CURSOR)  ) 
      ((NULL (CAR %%CURSOR-MMSTEP)) ) 
      ((EQUAL TYPE-NAME 'RESULT)  (GO RESULTS)  ))  

   (AND NEWHDR 
      (DO  ( (DL (CDR  %%DISPLAYLEVEL) (CDR DL)) ) 
           ((NULL DL) (SETQ %%DISPLAYLEVEL ())) 
          (COND (( < (CAAR DL) NEWHDR) (SETQ %%DISPLAYLEVEL DL)
                   (RETURN T) ) 
             ((AND (= (CAAR DL) NEWHDR) 
                   (EQ (CADAR DL) (GETHKLEVEL NEWHDR))) 
                (SETQ %%DISPLAYLEVEL DL) 
                (RETURN T) )) )  )     

   (SETQ MTEMP (OR (NULL %%DISPLAYLEVEL) 
      (NOT (AND 
         (NOT ( < HKL (CAAR %%DISPLAYLEVEL))) 
         (EQ (CADAR %%DISPLAYLEVEL) 
            (GETHKLEVEL (CAAR %%DISPLAYLEVEL))) )))) 

   (COND (MTEMP  (SETQ MTEMP ()) 
     (DO  DL  %%DISPLAYLEVEL  (CDR DL)  () 
       (COND ((NULL DL) (OR NEWHDR 
             (COND ((AND MTEMP (NOT (< HKL MTEMP))) 
                   (SETQ NEWHDR MTEMP) ) 
                (T (SETQ NEWHDR  
                      (MAX (- HKL (1+ %%LOWERDISPLAY-MIN)) 
                           0.)) )) ) 
             (SETQ %%DISPLAYLEVEL ()) (RETURN T) ) 
          ((AND (NOT ( < HKL (CAAR DL))) 
                (EQ (CADAR DL) (GETHKLEVEL (CAAR DL)))) 
             (SETQ %%DISPLAYLEVEL DL) 
             (SETQ SAMDISLV 0.) 
             (OR NEWHDR ( < HKL MTEMP) 
                (SETQ NEWHDR MTEMP)) 
             (RETURN T) ))    
         (SETQ MTEMP (CAAR DL))  )  )) 

   (COND (NEWHDR 
            (SETQ FRM (GETHKLEVEL NEWHDR))
            (SETQ %%DISPLAYLEVEL (CONS 
              (COND ((OR (NULL %%FLATSIZE-MAX) 
                    (AND (NOT (MINUSP %%FLATSIZE-MAX)) 
                       ( < (FLATSIZE FRM) %%FLATSIZE-MAX)) ) 
                   (LIST NEWHDR FRM) ) 
                 (T (LIST NEWHDR FRM (%%MABBRCONS FRM 
                     (CAR %%SPRINTABBR)(CADR %%SPRINTABBR)
                     (CADR %%SPRINTABBR)))  )) 
              %%DISPLAYLEVEL ))  
           (SETQ SAMDISLV 0.)   )) 
   (OR (NUMBERP (CAR %%CURSOR-MMSTEP)) (SETQ SAMDISLV 0.)) 

;SAMDISLV IS USED BELOW AS THE INDEX IN %%CURSOR-MMSTEP OF THE 
;DEEPEST LEVEL THAT REMAINS UNCHANGED.
    (SETQ MTEMP  (1+ (MIN %%LOWERDISPLAY
         (- HKL (CAAR %%DISPLAYLEVEL)))))

    (OR SAMDISLV 
       (COND ((DO ( (BK (MIN MTEMP (CAR %%CURSOR-MMSTEP)) 
                  (1- BK)) )     (( < BK 2.)   ()) 
            (COND ((EQ  (CADR (ASSOC BK    ;FORM
                  (GET %%CURSOR-MMSTEP 'LEVELS)))
                 (GETHKLEVEL (CADDDR (ASSOC BK 
                    (GET %%CURSOR-MMSTEP 'LEVELS)))))
               (SETQ SAMDISLV BK) 
               (COND (TOPDISLV) 
                  ((NOT (ATOM (GET %%CURSOR-MMSTEP 
                              'RESULT-CURSOR))) 
                     (SETQ TOPDISLV (GET %%CURSOR-MMSTEP 
                                          'RESULT-LEVEL)) ) 
                  (T (SETQ TOPDISLV (1+ (CADDDR (ASSOC BK
                     (GET %%CURSOR-MMSTEP 'LEVELS))))) ));LEVEL#
               (RETURN T) ))   )  )   
        ((EQ  (CADR (ASSOC 1. (GET %%CURSOR-MMSTEP 'LEVELS)))  
           (CADAR %%DISPLAYLEVEL))  (SETQ SAMDISLV 1.) ) 
        (T  (SETQ SAMDISLV 0.)  ))   )   
            
   (SETQ NEWSTACK (1+ (MIN  
            (COND (( < SAMDISLV 2.) 
                  %%LOWERDISPLAY-MIN) 
               (T  %%LOWERDISPLAY)) 
            (- HKL (CAAR %%DISPLAYLEVEL))
            (- HKL (COND ((ZEROP SAMDISLV) 0.) 
                        ((= SAMDISLV 1.) (CAAR %%DISPLAYLEVEL)) 
                        (( > (CAR %%CURSOR-MMSTEP) 1.)  
                              (CADDDR (ASSOC 2.   ;HOOKLEVEL
                                (GET %%CURSOR-MMSTEP 'LEVELS))))
                        (T 0.))   -1.)   )))   ;THE GET 
                     ;YIELDS THE HOOKLEVEL OF THE CURRENT 
                     ;TOPLEVEL FORM UNDER THE HEADER

   (AND (CAR %%CURSOR-MMSTEP) 
      (COND ((OR ( < HKL (GET %%CURSOR-MMSTEP 'TOPLEVEL))
            (AND ( > SAMDISLV 1.) 
               ( > (- HKL (GET %%CURSOR-MMSTEP 'TOPLEVEL) -1.) 
                  %%LOWERDISPLAY))) 
           (SETQ SAMDISLV (MIN SAMDISLV 1.)) 
           (SETQ NEWSTACK (1+ %%LOWERDISPLAY-MIN))   ))  ) 
   (SETQ TOPLV (- HKL NEWSTACK -2.))
 
   (AND (CAR %%CURSOR-MMSTEP) (NULL ERASEFROM) ( > SAMDISLV 0.)
     (COND ((SETQ MTEMP (GET %%CURSOR-MMSTEP 'RESULT-CURSOR)) 
            (SETQ ERASEFROM MTEMP) ) 
        ((NOT (= TOPLV (GET %%CURSOR-MMSTEP 'TOPLEVEL)))
            (SETQ ERASEFROM (CADDR (ASSOC 1.(GET %%CURSOR-MMSTEP
                  'LEVELS))) ) )   
        (T (SETQ ERASEFROM (CADDR (ASSOC SAMDISLV 
              (GET %%CURSOR-MMSTEP 'LEVELS))) ) ))) 


   (COND ((OR (ZEROP SAMDISLV)  (NULL (CAR %%CURSOR-MMSTEP)) 
            ( < (CAR (CURSORPOS)) (CAR (CADDR (ASSOC SAMDISLV 
                  (GET %%CURSOR-MMSTEP 'LEVELS))) )  ) )   
      (COND ((GET %%CURSOR-MMSTEP 'RESULT-CURSOR) 
           (PUTPROP %%CURSOR-MMSTEP 
               (MIN (GET %%CURSOR-MMSTEP 'TOPLEVEL)
                  (GET %%CURSOR-MMSTEP 'RESULT-LEVEL)) 
               'RESULT-LEVEL)
           (PUTPROP %%CURSOR-MMSTEP (CAAR %%DISPLAYLEVEL) 
                 'RESULT-TOPLEVEL) 
           (AND (NULL %%DONTERASE) 
              (CURSORPOS (CAR (GET %%CURSOR-MMSTEP 
                      'RESULT-CURSOR))
                    (CDR (GET %%CURSOR-MMSTEP 'RESULT-CURSOR))) 
              (CURSORPOS 'E) )   
            (TERPRI) (TERPRI) (SETQ MTEMP ()) ) 
         (T  (OR %%DONTERASE (CURSORPOS 'C))  (SETQ MTEMP T) )) 
      (COND ((AND MTEMP 
		  ((LAMBDA (PGPS ERS) 
			   (SSTATUS-PAGEP-MMSTEP T) 
			   (COND ((AND (BOUNDP '%%MDISTITLE)
				       (NUMBERP %%MDISTITLE)) 
				  (DO TT (FIX %%MDISTITLE) (1- TT) 
				      ( < TT 1.)   (TERPRI) )  ) 
				 (%%MDISTITLE 
				  (ERRSET (EVAL %%MDISTITLE)) 
				  (TERPRI) ))
			   ((LAMBDA (*NOPOINT) 
				    (PRINC '/#) 
				    (PRINC (CAAR %%DISPLAYLEVEL)))
			        T ) 
			   (PRINC '/ /  ) 
			   (SETQ ERS (ERRSET 
			     (PROG2 (SPRINT (OR (CADDAR %%DISPLAYLEVEL)
						(CADAR %%DISPLAYLEVEL)) 
					    LINEL 
					    0.)
				    ((LAMBDA (*NOPOINT) 
					     (PRINC '/ / / / /#) 
					     (PRINC (CAAR %%DISPLAYLEVEL)))
				        T ) 
				    (LISTEN))  )) 
			   (SSTATUS-PAGEP-MMSTEP PGPS) 
			   (OR ERS %%DONTERASE (CURSORPOS 'C)) 
			   ERS) 
		   (STATUS-PAGEP-MMSTEP) () ))) 
         (T  (AND MTEMP (COND ((AND (BOUNDP '%%MDISTITLE)
                        (NUMBERP %%MDISTITLE)) 
                        (DO TT (FIX %%MDISTITLE) (1- TT) 
                              ( < TT 1.)   (TERPRI) )  ) 
                     (%%MDISTITLE 
                        (ERRSET (EVAL %%MDISTITLE)) 
                        (TERPRI) ) 
                     (T (TERPRI) )) ) 
             ((LAMBDA (*NOPOINT) (PRINC '/#) 
                 (PRINC (CAAR %%DISPLAYLEVEL)) ) T ) 
             (PRINC '/ / /  ) 
             (APPLY (FUNCTION (LAMBDA (PRINLEVEL PRINLENGTH) 
                (%%PRIN11  (CADAR %%DISPLAYLEVEL)) 
                )) %%HOOKPRIN)  )) 
      (TERPRI)
      (SETQ SAMDISLV 0.) 
      (COND ((SETQ MTEMP (ASSOC 1. (GET %%CURSOR-MMSTEP 
               'LEVELS))) 
            (RPLACA (CDR MTEMP) (CADAR %%DISPLAYLEVEL)) 
            (RPLACA (CDDR MTEMP) (CURSORPOS)) 
            (RPLACA (CDDDR MTEMP) (CAAR %%DISPLAYLEVEL))  )  
         (T  (SETQ MTEMP (LIST 1. (CADAR %%DISPLAYLEVEL) 
                (CURSORPOS) (CAAR %%DISPLAYLEVEL))) 
            (SETQ MTEMP (NCONC (LIST MTEMP)
               (GET %%CURSOR-MMSTEP 'LEVELS)))  
            (PUTPROP %%CURSOR-MMSTEP MTEMP 'LEVELS)  ))   ) 
   ((NULL %%DONTERASE)  ((LAMBDA (CURPOS CRSR)  (COND (CRSR 
          (CURSORPOS (CAR CRSR) (CDR CRSR)) 
          (CURSORPOS 'E) 
          (COND ((AND %%EYESTRAIN1 
                ( < (CAR CRSR) (1- (CAR CURPOS))))  
             (SLEEP (MIN %%EYESTRAIN1 (TIMES %%EYESTRAIN1 
                (QUOTIENT (- (CAR CURPOS) 
                            (CAR CRSR)) 8.0)))) ))  )) 
       ) (CURSORPOS)  ERASEFROM   )   )) 

   (AND (GET %%CURSOR-MMSTEP 'RESULT-CURSOR)  ( > SAMDISLV 0.)
       (TERPRI))

   (AND (ZEROP SAMDISLV) (SETQ SAMDISLV 1.))  
   (AND (= SAMDISLV 1.) (SETQ TOPDISLV TOPLV)) 
   (SETQ TOPDISLV (MAX TOPDISLV (1+ (CAAR %%DISPLAYLEVEL)))) 
   (PUTPROP %%CURSOR-MMSTEP  TOPLV 'TOPLEVEL) 
   (PUTPROP %%CURSOR-MMSTEP HKL 'BOTLEVEL) 


   (DO  ( (LV  TOPDISLV  (1+ LV)) 
          (NUM  (1+ SAMDISLV) (1+ NUM))  ) 
        (( > LV HKL)  (RPLACA %%CURSOR-MMSTEP (1- NUM)) ) 
       ((LAMBDA (*NOPOINT) (TERPRI) (PRINC '/#) 
                 (PRINC LV) ) T ) 
       (PRINC '/ / / ) 
       (SETQ FRM (GETHKLEVEL LV)) 
       (APPLY (FUNCTION (LAMBDA (PRINLEVEL PRINLENGTH) 
          (%%PRIN11 FRM) 
          )) %%SHORTPRIN) 
       (PRINC '/ / ) 
       (COND ((SETQ MTEMP (ASSOC NUM (GET %%CURSOR-MMSTEP 
               'LEVELS))) 
            (RPLACA (CDR MTEMP) FRM) 
            (RPLACA (CDDR MTEMP) (CURSORPOS)) 
            (RPLACA (CDDDR MTEMP) LV)  ) 
         (T  (SETQ MTEMP (LIST NUM FRM (CURSORPOS) LV)) 
             (SETQ MTEMP (NCONC (LIST MTEMP) 
                (GET %%CURSOR-MMSTEP 'LEVELS) )) 
             (PUTPROP %%CURSOR-MMSTEP MTEMP 'LEVELS)  )) 
   DOEND  ) 
   (AND (BOUNDP '%%MDISPLAY-MSG) %%MDISPLAY-MSG 
      (ERRSET (EVAL %%MDISPLAY-MSG)) 
      (SETQ %%MDISPLAY-MSG ()) )  

RESULTS 
   (COND ((EQUAL TYPE-NAME 'RESULT) 
      (SETQ ERASEFROM (OR (GET %%CURSOR-MMSTEP 'RESULT-CURSOR)  
          (CADDR (ASSOC (CAR %%CURSOR-MMSTEP)   
             (GET %%CURSOR-MMSTEP 'LEVELS))) )) 
      (COND ((NULL %%RESULT-SPRINT)   (SETQ FRM ITEM) ) 
         ((OR (NULL %%FLATSIZE-MAX) 
                    (AND (NOT (MINUSP %%FLATSIZE-MAX)) 
                       ( < (FLATSIZE FRM) %%FLATSIZE-MAX)) ) 
               (SETQ FRM ITEM) ) 
         (T  (SETQ FRM (%%MABBRCONS ITEM (CAR %%SPRINTABBR) 
                 (CADR %%SPRINTABBR) (CADR %%SPRINTABBR))) )) 
     (ERRSET (COND ( (AND %%RESULT-SPRINT 
          ((LAMBDA (PGPS ERS) 
		   (SSTATUS-PAGEP-MMSTEP T) 
		   (TERPRI)
		   ((LAMBDA (*NOPOINT) 
			    (PRINC '/#) 
			    (PRINC HKL))
		       T ) 
		   (PRINC '/ ==>/ / / / ) 
		   (SETQ ERS (ERRSET (PROG2 
			       (COND ((AND (NOT (MINUSP %%FLATSIZE-MAX)) 
					   (< (FLATSIZE FRM) (SETQ CHRCT (- LINEL (CHARPOS TYO)))))
				      (%%PRIN11 FRM) )
				     (T  (SPRINT FRM  CHRCT  0.) )) 
			       (LISTEN))  )) 
		   (SSTATUS-PAGEP-MMSTEP PGPS) 
		   ERS)
	   (STATUS-PAGEP-MMSTEP) () ))) 
       (T  (AND (NULL %%DONTERASE) 
		(CURSORPOS (CAR ERASEFROM) (CDR ERASEFROM)) 
		(CURSORPOS 'E) )   
	   (TERPRI) 
	   ((LAMBDA (*NOPOINT) (PRINC '/#) (PRINC HKL) ) T ) 
	   (PRINC '/ ==>/ / / / )
	   (APPLY (FUNCTION (LAMBDA (PRINLEVEL PRINLENGTH) 
				    (%%PRIN11 ITEM)))
		  %%HOOKPRIN)  ))  )     
     (PUTPROP %%CURSOR-MMSTEP (CURSORPOS) 'RESULT-CURSOR)  
     (PUTPROP %%CURSOR-MMSTEP HKL 'RESULT-LEVEL) 
     (PUTPROP %%CURSOR-MMSTEP 
	      (GET %%CURSOR-MMSTEP 'TOPLEVEL) 
	      'RESULT-TOPLEVEL)     ))   )) 
          


(DEFUN  SVIEWMSG  (NEW PRINLIST) 
;FIRST ARGUMENT SHOULD BE A NUMBER, WHICH WILL BE USED TO SELECT
;A LINE TO BEGIN THE MESSAGE: ZERO FOR TOP LINE, -1 FOR BOTTOM 
;LINE, ETC. SECOND ARGUMENT IS THEN EVAL'D (EG. YOU CAN DO 
;PRINTING) AND THE CURSOR IS RETURNED TO ITS ORIGINAL POSITION. 
   (ERRSET ((LAMBDA (CHRCT CURSOR) 
		    (COND ((NULL CURSOR) () )
			  ('T (COND ((MINUSP NEW) 
				     (CURSORPOS (+ (CAR %%TTYSIZE) 
						   NEW 1.)  0.) ) 
				    (T (CURSORPOS NEW  0.) ))  
			      (EVAL PRINLIST)    
			      (CURSORPOS ']) 
			      (CURSORPOS (CAR CURSOR) (CDR CURSOR))
			      'T)))
	    LINEL (CURSORPOS))))




(DECLARE (SPECIAL TRACE/'S-FIRST-STEP))  ;DO NOT REMOVE 
(SETQ TRACE/'S-FIRST-STEP  (FUNCTION %%TRACE-MMSTEP)) 


;====== ADDITIONS FOR NEWIO:  

(SETQ %%MMSTEP-NEWIO (STATUS FEATURE NEWIO))

(SETQ MMSTEP-BREAK-FCN 
      (COND (%%MMSTEP-NEWIO (STATUS TTYINT 2)) 
	    ('T (LIST 'LAMBDA (LIST (GENSYM) (GENSYM)) (LIST ^H)))))


     
(DEFUN STATUS-PAGEP-MMSTEP () 
       (COND (%%MMSTEP-NEWIO  (ENDPAGEFN TYO))
	     (T  (STATUS PAGEPAUSE) ))  )

(DEFUN SSTATUS-PAGEP-MMSTEP (FLAG) 
   (COND (%%MMSTEP-NEWIO  (ENDPAGEFN TYO MMSTEP-ENDPAGEFN))
	 (T  (SSTATUS PAGEPAUSE FLAG) ))  ) 


(DEFUN  MMSTEP-ENDPAGEFN  (TERMINAL)
   (PRINC '/ **MORE**/ TYPE/ /<CHAR/>/ /<SPACE/> TERMINAL) 
         ;<CHAR><CONTROL-S> WILL FLUSH 
   (READ T TERMINAL)      
      ;THE SPACE AFTER AN ATOM IS TYPED IN FOR ITS VALUE 
      ;DOES NOT GET SEEN BY LISTEN YET (TYI) AND (READCH) FIND
      ;IT, SO THE FIRST PAGE OF TYPEOUT GETS WRITTEN OVER 
      ;UNLESS READ IS USED.  PROBABLY A BUG IN NEWIO. 
   (COND ((CURSORPOS TERMINAL)
	  (CURSORPOS () 0 TERMINAL)
	  (CURSORPOS '/] TERMINAL)  ;ERASE THE **MORE** LINE 
	  (CURSORPOS 'TOP TERMINAL) 
	  (CURSORPOS '/] TERMINAL) ))   )  


(OR (BOUNDP 'MMSTEP-ENDPAGEFN) 
    (SETQ MMSTEP-ENDPAGEFN 'MMSTEP-ENDPAGEFN))
      ;YOU CAN EASILY PROVIDE YOUR OWN INSTEAD FOR NEWIO.
      ;JUST SETQ MMSTEP-ENDPAGEFN TO THE NAME OF YOUR *MORE*
      ;PROCESSING FUNCTION. 

