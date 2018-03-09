;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module inmis)

(DEFMVAR $LISTCONSTVARS NIL
  "Causes LISTOFVARS to include %E, %PI, %I, and any variables declared
   constant in the list it returns if they appear in exp.  The default is
   to omit these." BOOLEAN SEE-ALSO $LISTOFVARS)

(DECLARE (SPECIAL LISTOFVARS))

(SETQ $COMBINEFLAG NIL $POLYFACTOR NIL)

(DEFMFUN $UNKNOWN (F) (*CATCH NIL (UNKNOWN (MRATCHECK F))))

(DEFUN UNKNOWN (F)
 (AND (NOT (MAPATOM F))
      (COND ((AND (EQ (CAAR F) 'MQAPPLY)
		  (NOT (GET (CAAADR F) 'SPECSIMP)))
	     (*THROW NIL T))
	    ((NOT (GET (CAAR F) 'OPERATORS)) (*THROW NIL T))
	    (T (MAPC 'UNKNOWN (CDR F)) NIL))))

(DEFMFUN $LISTOFVARS (E) 
       ((LAMBDA (LISTOFVARS) 
	 (COND (($RATP E)
		(AND (MEMQ 'TRUNC (CDDAR E))
		     (SETQ E ($TAYTORAT E)))
		(SETQ E
		      (CONS '(MLIST)
			    (SUBLIS (MAPCAR 'CONS
					    (CAR (CDDDAR E))
					    ;;GENSYMLIST
					    (CADDAR E))
				    ;;VARLIST
				    (UNION* (LISTOVARS (CADR E))
					    (LISTOVARS (CDDR E))))))))
	 (ATOMVARS E)
	 LISTOFVARS)
	(LIST '(MLIST)))) 

(DEFUN ATOMVARS (E) 
       (COND ((AND (EQ (TYPEP E) 'SYMBOL)
		   (OR $LISTCONSTVARS (NOT ($CONSTANTP E))))
	      (ADD2LNC E LISTOFVARS))
	     ((ATOM E))
	     ((EQ (CAAR E) 'MRAT) (ATOMVARS (RATDISREP E)))
	     ((MEMQ 'ARRAY (CAR E)) (MYADD2LNC E LISTOFVARS))
	     (T (MAPC 'ATOMVARS (CDR E))))) 

(DEFUN MYADD2LNC (ITEM LIST) 
       (AND (NOT (MEMALIKE ITEM LIST)) (NCONC LIST (NCONS ITEM)))) 

;; Reset the settings of all Macsyma user-level switches to their initial
;; values.

#+ITS
(DEFMFUN $RESET NIL 
       (load '((DSK MACSYM) RESET FASL))
       '$DONE)

#+Multics
(DEFMFUN $RESET ()
  (LOAD (EXECUTABLE-DIR "RESET"))
  '$DONE)

#+NIL
(DEFMFUN $REST ()
  (LOAD "[MACSYMA]RESET"))

;; Please do not use the following version on MC without consulting with me.
;; I already fixed several bugs in it, but the +ITS version works fine on MC 
;; and takes less address space. - JPG
(DECLARE (SPECIAL MODULUS $FPPREC))
#-(or ITS Multics NIL) ;This version should be eventually used on Multics.
(DEFMFUN $RESET ()
        (SETQ BASE 10. IBASE 10. *NOPOINT T MODULUS NIL ZUNDERFLOW T)
        ($DEBUGMODE NIL)
        (COND ((NOT (= $FPPREC 16.)) ($FPPREC 16.) (SETQ $FPPREC 16.))) 
   #+GC ($DSKGC NIL)
        (LOAD #+PDP10   '((ALJABR) INIT RESET)
	      #+Lispm   "MC:ALJABR;INIT RESET"
	      #+Multics (executable-dir "init_reset")
	      #+Unix	???)
	;; *** This can be flushed when all Macsyma user-switches are defined
	;; *** with DEFMVAR.  This is part of an older mechanism.
 #+PDP10 (LOAD '((MACSYM) RESET FASL))
        '$DONE)
