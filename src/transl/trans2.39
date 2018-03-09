;;; -*- Mode: Lisp; Package: Macsyma -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;            Please do not modify this file.         See GJC           ;;;
;;;       (c) Copyright 1980 Massachusetts Institute of Technology       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; TRANSLATION PROPERTIES FOR MACSYMA OPERATORS AND FUNCTIONS.

;;; This file is for list and array manipulation optimizations.

(macsyma-module trans2)


(TRANSL-MODULE TRANS2)

(DEF%TR $RANDOM (FORM) `($FIXNUM . (RANDOM ,@(TR-ARGS (CDR FORM)))))

(DEF%TR MEQUAL (FORM)
	`($ANY . (SIMPLIFY (LIST '(MEQUAL) ,@(TR-ARGS (CDR FORM))))))

(DEF%TR MCALL (FORM)
	(SETQ FORM (CDR FORM))
	(LET ((MODE (COND ((ATOM (CAR FORM))
			   (FUNCTION-MODE (CAR FORM)))
			  (T '$ANY))))
	     (SETQ FORM (TR-ARGS FORM))
	     (LET ((OP (CAR FORM)))
		  (CALL-AND-SIMP MODE 'MCALL `(,OP . ,(CDR FORM))))))

;;; Meaning of the mode properties: most names are historical.
;;; (GETL X '(ARRAY-MODE)) means it is an array callable by the
;;; old maclisp style. This is unfortunately still useful to
;;; avoid indirection through the property list to get to the
;;; array.

(DEFTRFUN TR-ARRAYCALL (FORM)
       (COND ((GET (CAAR FORM) 'ARRAY-MODE)
	      (ADDL (CAAR FORM) ARRAYS)
	      `(,(ARRAY-MODE (CAAR FORM))
		. (,(CAAR FORM) ,@(TR-ARGS (CDR FORM)))))
	     ;;((MEMQ (MGET (CAAR FORM) 'ARRAYFUN-MODE) '($FLOAT $FIXNUM))
	     ;;`(,(MGET (CAAR FORM) 'ARRAYFUN-MODE)
	     ;;MAFCALL ,(CAAR FORM) . ,(MAPCAR 'DTRANSLATE (CDR FORM))))
	     (T
	      (TRANSLATE `((MARRAYREF)
			   ,(IF $TR_ARRAY_AS_REF (CAAR FORM)
					   `((MQUOTE) ,(CAAR FORM)))
			   ,@(CDR FORM))))))


(DEFTRFUN TR-ARRAYSETQ (array-ref value)
       ;; actually an array SETF, but it comes from A[X]:FOO
       ;; which is ((MSETQ) ... ...)
       (COND ((GETL (CAAR array-ref) '(ARRAY-MODE))
	      (LET ((T-REF (TRANSLATE ARRAY-REF))
		    (T-VALUE (TRANSLATE VALUE))
		    (MODE))
		   (WARN-MODE ARRAY-REF (CAR T-REF) (CAR T-VALUE))
		   (SETQ MODE (CAR T-REF)) ; ooh, could be bad.
		   `(,MODE
		     . (STORE ,(CDR T-REF) ,(CDR T-VALUE)))))
	     (T
	      ;; oops. Hey, I switch around order of evaluation
	      ;; here. no need to either man. gee.
	      (TRANSLATE `((MARRAYSET) ,Value
				       ,(IF $TR_ARRAY_AS_REF (CAAR ARRAY-REF)
					   `((MQUOTE) ,(CAAR ARRAY-REF)))
				       ,@(CDR ARRAY-REF))))))

(DEF%TR MARRAYREF (FORM)
  (SETQ FORM (CDR FORM))
  (LET ((MODE (COND ((ATOM (CAR FORM))
		     (MGET (CAR FORM) 'ARRAY-MODE)))))
    (COND ((NULL MODE) (SETQ MODE '$ANY)))
    (SETQ FORM (TR-ARGS FORM))
    (LET ((OP (CAR FORM)))
      `(,MODE . (,(IF (AND (= (LENGTH FORM) 2)
			   (EQ MODE '$FLOAT))
		      (PROGN (PUSH-AUTOLOAD-DEF 'MARRAYREF '(MARRAYREF1$))
			     'MARRAYREF1$)
		      'MARRAYREF)
		 ,OP . ,(CDR FORM))))))

(DEF%TR MARRAYSET (FORM)
  (SETQ FORM (CDR FORM))
  (LET ((MODE (COND ((ATOM (CADR FORM))
		     (MGET (CADR FORM) 'ARRAY-MODE)))))
    (COND ((NULL MODE) (SETQ MODE '$ANY)))
    (SETQ FORM (TR-ARGS FORM))
    (LET (((VAL ARRAY . INDS) FORM))
      `(,MODE . (,(IF (AND (= (LENGTH INDS) 1)
			   (EQ MODE '$FLOAT))
		      (PROGN (PUSH-AUTOLOAD-DEF 'MARRAYSET '(MARRAYSET1$))
			     'MARRAYSET1$)
		      'MARRAYSET)
		 ,VAL ,ARRAY . ,INDS)))))

(DEF%TR MLIST (FORM)
	(COND ((NULL (CDR FORM)) ;;; []
	       '($ANY . '((MLIST))))
	      (T
	       `($ANY . (LIST '(MLIST) . ,(TR-ARGS (CDR FORM)))))))

(DEF%TR $FIRST (FORM)
  (SETQ FORM (TRANSLATE (CADR FORM)))
  (call-and-simp '$ANY
		 (COND ((EQ '$LIST (CAR FORM))
			'CADR)
		       (T
			'$FIRST))
		 (list (CDR FORM))))



;; Local Modes:
;; Mode: LISP
;; Comment Col: 40
;; END:
