;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module trpred)
(transl-module trpred)

(DEFVAR WRAP-AN-IS 'IS-BOOLE-CHECK "How to verify booleans")

(DEF%TR $IS (FORM)
  (LET ((WRAP-AN-IS 'IS-BOOLE-CHECK))
    (CONS '$BOOLEAN (TRANSLATE-PREDICATE (CADR FORM)))))

(DEF%TR $MAYBE (FORM)
  (LET ((WRAP-AN-IS 'MAYBE-BOOLE-CHECK))
    (CONS '$ANY (TRANSLATE-PREDICATE (CADR FORM)))))

(DEF%TR MNOT (FORM) (CONS '$BOOLEAN (TRANSLATE-PREDICATE FORM)))
(DEF-SAME%TR MAND MNOT)
(DEF-SAME%TR MOR MNOT)

;;; these don't have an imperitive predicate semantics outside of
;;; being used in MNOT, MAND, MOR, MCOND, $IS.

(DEF%TR MNOTEQUAL (FORM)
       `($ANY . (SIMPLIFY (LIST '(,(CAAR FORM)) ,@(TR-ARGS (CDR FORM))))))

(DEF-SAME%TR MEQUAL    MNOTEQUAL)
(DEF-SAME%TR $EQUAL    MNOTEQUAL)
(DEF-SAME%TR MGREATERP MNOTEQUAL)
(DEF-SAME%TR MGEQP     MNOTEQUAL)
(DEF-SAME%TR MLESSP    MNOTEQUAL)
(DEF-SAME%TR MLEQP     MNOTEQUAL)


;;; It looks like it was copied from MRG;COMPAR > with 
;;; TRP- substituted for MEVALP. What a crockish way to dispatch,
;;; and in a system with a limited address space too!
;;; NOTE: See code for IS-BOOLE-CHECK, also duplication of MRG;COMPAR.

;;; Note: This TRANSLATE-PREDICATE and TRANSLATE should be combinded
;;; to a single function which takes a second argument of the
;;; TARGET (mode). Targeting is a pretty basic concept in compilation
;;; so its suprising this was done. In order to make this change all
;;; special-forms need to do targetting.

(DEFTRFUN TRANSLATE-PREDICATE (FORM)
  ;; N.B. This returns s-exp, not (<mode> . <s-exp>)
  (COND ((ATOM FORM)
	 (let ((tform (TRANSLATE FORM)))
	   (COND ((EQ '$BOOLEAN (CAR tFORM)) (CDR tFORM))
		 (T
		  (WRAP-AN-IS (CDR TFORM) FORM)))))
	((EQ 'MNOT (CAAR FORM)) (TRP-MNOT FORM))
	((EQ 'MAND (CAAR FORM)) (TRP-MAND FORM))
	((EQ 'MOR (CAAR FORM)) (TRP-MOR FORM))
	((EQ 'MNOTEQUAL (CAAR FORM)) (TRP-MNOTEQUAL FORM))
	((EQ 'MEQUAL (CAAR FORM)) (TRP-MEQUAL FORM))
	((EQ '$EQUAL (CAAR FORM)) (TRP-$EQUAL FORM))
	((EQ 'MGREATERP (CAAR FORM)) (TRP-MGREATERP FORM))
	((EQ 'MGEQP (CAAR FORM)) (TRP-MGEQP FORM))
	((EQ 'MLESSP (CAAR FORM)) (TRP-MLESSP FORM))
	((EQ 'MLEQP (CAAR FORM)) (TRP-MLEQP FORM))
	((EQ 'MPROGN (CAAR FORM))
	 ;; it was a pain not to have this case working, so I just
	 ;; patched it in. Lets try not to lazily patch in every
	 ;; special form in macsyma!
	 `(PROGN ,@(TR-ARGS (NREVERSE (CDR (REVERSE (CDR FORM)))))
		 ,(TRANSLATE-PREDICATE (CAR (LAST (CDR FORM))))))
	(T
	 (LET (((MODE . TFORM) (TRANSLATE FORM)))
	   (BOOLEAN-CONVERT MODE TFORM FORM)))))


(DEFUN BOOLEAN-CONVERT (MODE EXP FORM)
  (IF (EQ MODE '$BOOLEAN)
      EXP
      (WRAP-AN-IS EXP FORM)))

(DEFUN TRP-MNOT (FORM) 
       (SETQ FORM (TRANSLATE-PREDICATE (CADR FORM)))
       (COND ((NOT FORM) T)
	     ((EQ T FORM) NIL)
	     ((AND (NOT (ATOM FORM)) (EQ (CAR FORM) 'NOT)) (CADR FORM))
	     (T (LIST 'NOT FORM))))

(DEFUN TRP-MAND (FORM) 
       (SETQ FORM (MAPCAR 'TRANSLATE-PREDICATE (CDR FORM)))
       (DO ((L FORM (CDR L)) (NL))
	   ((NULL L) (CONS 'AND (NREVERSE NL)))
	   (COND ((CAR L) (SETQ NL (CONS (CAR L) NL)))
		 (T (RETURN (CONS 'AND (NREVERSE (CONS NIL NL))))))))

(DEFUN TRP-MOR (FORM) 
       (SETQ FORM (MAPCAR 'TRANSLATE-PREDICATE (CDR FORM)))
       (DO ((L FORM (CDR L)) (NL))
	   ((NULL L) (COND (NL (COND ((NULL (CDR NL))(CAR NL))
				     (T (CONS 'OR (NREVERSE NL)))))))
	   (COND ((CAR L) (SETQ NL (CONS (CAR L) NL))))))


(DEFUN WRAP-AN-IS (EXP IGNORE-FORM)
  (LIST WRAP-AN-IS EXP))

(DEFUN TRP-MGREATERP (FORM) 
  (LET (MODE ARG1 ARG2)
    (SETQ ARG1 (TRANSLATE (CADR FORM)) ARG2 (TRANSLATE (CADDR FORM))
	  MODE (*UNION-MODE (CAR ARG1) (CAR ARG2)))
    (COND ((OR (EQ '$FIXNUM MODE) (EQ '$FLOAT MODE))
	   `(> ,(DCONV ARG1 MODE) ,(DCONV ARG2 MODE)))
	  ((EQ '$NUMBER MODE) `(GREATERP ,(CDR ARG1) ,(CDR ARG2)))
	  ('ELSE
	   (WRAP-AN-IS `(MGRP ,(DCONVX ARG1) ,(DCONVX ARG2))
		       FORM)))))

(DEFUN TRP-MLESSP (FORM) 
  (LET (MODE ARG1 ARG2)
    (SETQ ARG1 (TRANSLATE (CADR FORM)) ARG2 (TRANSLATE (CADDR FORM))
	  MODE (*UNION-MODE (CAR ARG1) (CAR ARG2)))
    (COND ((OR (EQ '$FIXNUM MODE) (EQ '$FLOAT MODE))
	   `(< ,(DCONV ARG1 MODE) ,(DCONV ARG2 MODE)))
	  ((EQ '$NUMBER MODE) `(LESSP ,(CDR ARG1) ,(CDR ARG2)))
	  ('ELSE
	   (WRAP-AN-IS `(MLSP ,(DCONVX ARG1) ,(DCONVX ARG2))
		       FORM)))))

(DEFUN TRP-MEQUAL (FORM) 
  (LET (MODE ARG1 ARG2)
    (SETQ ARG1 (TRANSLATE (CADR FORM)) ARG2 (TRANSLATE (CADDR FORM))
	  MODE (*UNION-MODE (CAR ARG1) (CAR ARG2)))
    (COND ((OR (EQ '$FIXNUM MODE) (EQ '$FLOAT MODE))
	   `(= ,(DCONV ARG1 MODE) ,(DCONV ARG2 MODE)))
	  ((EQ '$NUMBER MODE) `(EQUAL ,(CDR ARG1) ,(CDR ARG2)))
	  (T `(LIKE ,(DCONV ARG1 MODE) ,(DCONV ARG2 MODE))))))

(DEFUN TRP-$EQUAL (FORM) 
  (LET (MODE ARG1 ARG2) 
    (SETQ ARG1 (TRANSLATE (CADR FORM)) ARG2 (TRANSLATE (CADDR FORM))
	  MODE (*UNION-MODE (CAR ARG1) (CAR ARG2)))
    (COND ((OR (EQ '$FIXNUM MODE) (EQ '$FLOAT MODE))
	   `(= ,(DCONV ARG1 MODE) ,(DCONV ARG2 MODE)))
	  ((EQ '$NUMBER MODE) `(MEQP ,(CDR ARG1) ,(CDR ARG2)))
	  ('ELSE
	   (WRAP-AN-IS `(MEQP ,(DCONVX ARG1) ,(DCONVX ARG2))
		       FORM)))))

(DEFUN TRP-MNOTEQUAL (FORM) (LIST 'NOT (TRP-MEQUAL FORM)))

(DEFUN TRP-MGEQP (FORM) (LIST 'NOT (TRP-MLESSP FORM)))

(DEFUN TRP-MLEQP (FORM) (LIST 'NOT (TRP-MGREATERP FORM)))


;;; sigh, i have to copy a lot of the $assume function too.

(def%tr $assume (form)
  (let ((x (cdr form)))
    (do ((nl))
	((null x)
	 `($any . (simplify (list '(mlist) ,@(nreverse nl)))))
      (cond ((eq 'mand (caaar x))
	     (mapc #'(lambda (l) (setq nl (cons `(assume ,(dtranslate l)) nl)))
		   (cdar x)))
	    ((eq 'mnot (caaar x))
	     (setq nl (cons `(assume ,(dtranslate (pred-reverse (cadar x)))) nl)))
	    ((eq 'mor (caaar x))
	     (merror "ASSUME: Macsyma is unable to handle assertions involving 'OR'."))
	    ((eq (caaar x) 'mequal)
	     (merror "ASSUME: = means syntactic equality in Macsyma. ~
		     Maybe you want to use EQUAL."))
	    ((eq (caaar x) 'mnotequal)
	     (merror "ASSUME: # means syntactic unequality in Macsyma. ~
		     Maybe you want to use NOT EQUAL."))
	    ('else
	     (setq nl (cons `(assume ,(dtranslate (car x))) nl))))
      (setq x (cdr x)))))