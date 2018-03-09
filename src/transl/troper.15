;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module troper)


(TRANSL-MODULE TROPER)

;;; The basic OPERATORS properties translators.


(DECLARE (MUZZLED T)) ; TURN OFF CLOSED COMPILATION MESSAGE

(DEF%TR MMINUS (FORM)
  (SETQ FORM (TRANSLATE (CADR FORM)))
  (COND ((NUMBERP (CDR FORM))
	 `(,(CAR FORM) . ,(MINUS (CDR FORM))))
	((EQ '$FIXNUM (CAR FORM)) `($FIXNUM - ,(CDR FORM)))
	((EQ '$FLOAT (CAR FORM)) `($FLOAT -$ ,(CDR FORM)))
	((EQ '$NUMBER (CAR FORM)) `($NUMBER MINUS ,(CDR FORM)))
	((EQ '$RATIONAL (CAR FORM))
	 (COND ((AND (NOT (ATOM (CADDR FORM))) (EQ 'RAT (CAAR (CADDR FORM))))
		(SETQ FORM (CDADDR FORM))
		`($RATIONAL QUOTE ((RAT) ,(- (CAR FORM)) ,(CADR FORM))))
	       (T `($RATIONAL RTIMES -1 ,(CDR FORM)))))
	(T `($ANY . (*MMINUS ,(CDR FORM))))))
(DECLARE (MUZZLED NIL))

(DEF%TR MPLUS (FORM)
  (LET   (ARGS MODE)
    (DO L (CDR FORM) (CDR L) (NULL L)
	(SETQ ARGS (CONS (TRANSLATE (CAR L)) ARGS)
	      MODE (*UNION-MODE (CAR (CAR ARGS)) MODE)))
    (SETQ ARGS (NREVERSE ARGS))
    (COND ((EQ '$FIXNUM MODE) `($FIXNUM + . ,(MAPCAR 'CDR ARGS)))
	  ((EQ '$FLOAT MODE) `($FLOAT +$ . ,(MAPCAR 'DCONV-$FLOAT ARGS)))
	  ((EQ '$RATIONAL MODE) `($RATIONAL RPLUS . ,(MAPCAR 'CDR ARGS)))
	  ((EQ '$NUMBER MODE) `($NUMBER PLUS . ,(MAPCAR 'CDR ARGS)))
	  (T `($ANY ADD* . ,(MAPCAR 'DCONVX ARGS))))))


(DEFUN NESTIFY (OP L)
  (DO ((L (CDR L) (CDR L)) (NL (CAR L))) ((NULL L) NL)
      (SETQ NL (LIST OP NL (CAR L)))))

(DEF%TR MTIMES (FORM)
  (LET   (ARGS MODE)
    (IF (EQUAL -1 (CADR FORM)) (TRANSLATE `((MMINUS) ((MTIMES) . ,(CDDR FORM))))
        (DO L (CDR FORM) (CDR L) (NULL L)
	    (SETQ ARGS (CONS (TRANSLATE (CAR L)) ARGS)
		  MODE (*UNION-MODE (CAR (CAR ARGS)) MODE)))
	(SETQ ARGS (NREVERSE ARGS))
	(COND ((EQ '$FIXNUM MODE) `($FIXNUM * . ,(MAPCAR 'CDR ARGS)))
	      ((EQ '$FLOAT MODE) `($FLOAT *$ . ,(MAPCAR 'DCONV-$FLOAT ARGS)))
	      ((EQ '$RATIONAL MODE) `($RATIONAL RTIMES . ,(MAPCAR 'CDR ARGS)))
	      ((EQ '$NUMBER MODE) `($NUMBER TIMES . ,(MAPCAR 'CDR ARGS)))
	      (T `($ANY MUL* . ,(MAPCAR 'DCONVX ARGS)))))))

(DEF%TR MQUOTIENT (FORM)
	(let (ARG1 ARG2 MODE)
	     (SETQ ARG1 (TRANSLATE (CADR FORM)) ARG2 (TRANSLATE (CADDR FORM))
		   MODE (*UNION-MODE (CAR ARG1) (CAR ARG2))
		   ARG1 (DCONV ARG1 MODE) ARG2 (DCONV ARG2 MODE))
	     (COND ((EQ '$FLOAT MODE)
		    (SETQ ARG1 (IF (MEMBER ARG1 '(1 1.0)) (LIST ARG2)
				   (LIST ARG1 ARG2)))
		    `($FLOAT //$ . ,ARG1))
		   ((AND (EQ MODE '$FIXNUM) $TR_NUMER)
		    `($FLOAT . (//$ (FLOAT ,ARG1) (FLOAT ,ARG2))))
		   ((MEMQ MODE '($FIXNUM $RATIONAL))
		    `($RATIONAL RREMAINDER ,ARG1 ,ARG2))
		   (T `($ANY DIV ,ARG1 ,ARG2)))))


(DEF%TR MEXPT (FORM)
  (IF (EQ '$%E (CADR FORM)) (TRANSLATE `(($EXP) ,(CADDR FORM)))
      (LET   (BAS EXP)
	(SETQ BAS (TRANSLATE (CADR FORM)) EXP (TRANSLATE (CADDR FORM)))
	(COND ((EQ '$FIXNUM (CAR EXP))
	       (SETQ EXP (CDR EXP))
	       (COND ((EQ '$FLOAT (CAR BAS))
		      (COND ((NOT (FIXP EXP)) `($FLOAT ^$ ,(CDR BAS) ,EXP))
			    (T `($FLOAT EXPT$ ,(CDR BAS) ,EXP))))
		     ((AND (EQ (CAR BAS) '$FIXNUM)
			   $TR_NUMER)
		      ;; when NUMER:TRUE we have 1/2 evaluating to 0.5
		      ;; therefore we have a TR_NUMER switch to control
		      ;; this form numerical hackers at translate time
		      ;; where it does the most good. -gjc
		      `($FLOAT . (^$ (FLOAT ,(CDR BAS)) ,EXP)))
		     ;; This next optimization was just plain wrong!
		     ;; -gjc
		     ;;((MEMQ (CAR BAS) '($FIXNUM $NUMBER))
		     ;;`($NUMBER EXPT ,(CDR BAS) ,EXP))
		     (T `($ANY POWER ,(CDR BAS) ,EXP))))
	      ((AND (EQ '$FLOAT (CAR BAS))
		    (EQ '$RATIONAL (CAR EXP))
		    (NOT (ATOM (CADDR EXP)))
		    (COND ((EQUAL 2 (CADDR (CADDR EXP)))
			   (SETQ EXP (CADR (CADDR EXP)))
			   (COND ((= 1 EXP) `($FLOAT SQRT ,(CDR BAS)))
				 ((= -1 EXP) `($FLOAT //$ (SQRT ,(CDR BAS))))
				 (T `($FLOAT EXPT$ (SQRT ,(CDR BAS)) ,EXP))))
			  ((EQ 'RAT (CAAR (CADDR EXP)))
			   `($FLOAT EXPT ,(CDR BAS) ,($FLOAT (CADDR EXP)))))))
	      ((AND (COVERS '$NUMBER (CAR BAS)) (COVERS '$NUMBER (CAR EXP)))
	       `(,(*UNION-MODE (CAR BAS) (CAR EXP)) EXPT ,(CDR BAS) ,(CDR EXP)))
	      (T `($ANY POWER ,(CDR BAS) ,(CDR EXP)))))))



(DEF%TR RAT (FORM) `($RATIONAL . ',FORM))

(DEF%TR BIGFLOAT (FORM) `($ANY . ',FORM))



(DEF%TR %SQRT (FORM)
  (SETQ FORM (TRANSLATE (CADR FORM)))
  (IF (EQ '$FLOAT (CAR FORM)) `($FLOAT SQRT ,(CDR FORM))
      `($ANY SIMPLIFY (LIST '(%SQRT) ,(CDR FORM)))))

(DEF%TR MABS (FORM) 
  (SETQ FORM (TRANSLATE (CADR FORM)))
  (IF (COVERS '$NUMBER (CAR FORM)) (LIST (CAR FORM) 'ABS (CDR FORM))
      `($ANY SIMPLIFY (LIST '(MABS) ,(DCONVX FORM)))))


(DEF%TR %SIGNUM (FORM)
	(LET (( (MODE . ARG) (TRANSLATE (CADR FORM))))
	     (COND ((MEMQ MODE '($FIXNUM $FLOAT))
		    (LET ((TEMP (TR-GENSYM)))
			 `($FIXNUM . ((LAMBDA (,TEMP)
					      (DECLARE (,(IF (EQ MODE '$FLOAT)	
							     'FLONUM
							     'FIXNUM)
							,TEMP))
					      (COND ((MINUSP ,TEMP) -1)
						    ((PLUSP ,TEMP) 1)
						    (T 0)))
				      ,ARG))))
		   (T
		    ;; even in this unknown case we can do a hell
		    ;; of a lot better than consing up a form to
		    ;; call the macsyma simplifier. I mean, shoot
		    ;; have a little SUBR called SIG-NUM or something.
		    `($ANY SIMPLIFY (LIST '(%SIGNUM) ,ARG))))))

;; The optimization of using -1.0, +1.0 and 0.0 cannot be made unless we
;; know the TARGET MODE. The action of the simplifier is that
;; SIGNUM(3.3) => 1 , SIGNUM(3.3) does not give 0.0
;; Maybe this is a bug in the simplifier, maybe not. -gjc

;; There are many possible non-trivial optimizations possible involving
;; SIGNUM. MODE TARGETTING must be built in to get these easily of course,
;; examples are: SIGNUM(X*Y); No need to multiple X and Y, just multiply
;; there SIGN's, which is a conditional and comparisons. However, these
;; are only optimizations if X and Y are numeric. What if
;; X:'a,Y:'B, ASSUME(A*B>0), SIGNUM(X*Y). Well, here
;; SIGNUM(X)*SIGNUM(Y) won't be the same as SIGNUM(X*Y). -gjc

;; just to show the kind of brain damage...
;;(DEF%TR %SIGNUM (FORM)
;;   (SETQ FORM (TRANSLATE (CADR FORM)))
;;   (COND ((MEMQ (CAR FORM) 
;;	  (LET   ((X (CDR FORM)) (MODE (CAR FORM))
;;		    (ONE 1) (MINUS1 -1) (ZERO 0) (VAR '%%N)
;;		    (DECLARE-TYPE 'FIXNUM) COND-CLAUSE)
;;	     (IF (EQ '$FLOAT MODE) (SETQ ONE 1.0 MINUS1 -1.0 ZERO 0.0 VAR '$$X
;;					 DECLARE-TYPE 'FLONUM))
;;	     (SETQ COND-CLAUSE `(COND ((MINUSP ,X) ,MINUS1)
;;				      ((PLUSP ,X)  ,ONE)
;;				      (T ,ZERO)))
;;	     (IF (ATOM (CDR FORM)) `(,MODE . ,COND-CLAUSE)
;;		 (ADDL `(,DECLARE-TYPE ,VAR) DECLARES)
;;		 `(,MODE (LAMBDA (,VAR) ,COND-CLAUSE) ,X))))
;;	 (T `($ANY SIMPLIFY (LIST '(%SIGNUM) ,(CDR FORM))))))


(DEF%TR $ENTIER (FORM) 
  (SETQ FORM (TRANSLATE (CADR FORM)))
  (COND ((EQ '$FIXNUM (CAR FORM)) FORM)
        ((MEMQ (CAR FORM) '($FLOAT $NUMBER))
	 (IF (EQ 'SQRT (CADR FORM)) `($FIXNUM $ISQRT ,(CADDR FORM))
	     `($FIXNUM FIX ,(CDR FORM))))
        (T `(,(IF (EQ (CAR FORM) '$RATIONAL) '$FIXNUM '$ANY)
	      $ENTIER ,(CDR FORM)))))

(DEF%TR $FLOAT (FORM)
  (SETQ FORM (TRANSLATE (CADR FORM)))
  (IF (COVERS '$FLOAT (CAR FORM)) (CONS '$FLOAT (DCONV-$FLOAT FORM))
      `($ANY $FLOAT ,(CDR FORM))))



(DEF%TR $EXP (FORM)
  (SETQ FORM (TRANSLATE (CADR FORM)))
  (IF (EQ '$FLOAT (CAR FORM)) `($FLOAT EXP ,(CDR FORM))
      `($ANY SIMPLIFY ($EXP ,(CDR FORM)))))

(DEF%TR $ATAN2 (FORM)
   (SETQ FORM (CDR FORM))
   (LET   ((X (TRANSLATE (CAR FORM))) (Y (TRANSLATE (CADR FORM))))
      (IF (EQ '$FLOAT (*UNION-MODE (CAR X) (CAR Y)))
	  `($FLOAT ATAN2 ,(CDR X) ,(CDR Y))
	`($ANY SIMPLIFY (LIST '($ATAN2) ,(CDR X) ,(CDR Y))))))

(DEF%TR %ATAN (FORM)
   (SETQ FORM (CDR FORM))
   (LET   ((X (TRANSLATE (CAR FORM))))
      (IF (EQ '$FLOAT (CAR X)) `($FLOAT ATAN1 ,(CDR X))
	  `($ANY SIMPLIFY (LIST '(%ATAN) ,(CDR X))))))
