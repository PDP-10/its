;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module mformt)
(load-macsyma-macros mforma)

(EVAL-WHEN (EVAL)
	   (SETQ MACRO-EXPANSION-USE 'DISPLACE))

(DEF-MFORMAT)

(DEF-MFORMAT-VAR /:-FLAG     NIL T)
(DEF-MFORMAT-VAR /@-FLAG     NIL T)
(DEF-MFORMAT-VAR PARAMETER   0  T) ; Who can read "~33,34,87A" ?
(DEF-MFORMAT-VAR PARAMETER-P NIL T)
(DEF-MFORMAT-VAR TEXT       NIL NIL)
(DEF-MFORMAT-VAR TEXT-TEMP NIL NIL)
(DEF-MFORMAT-VAR DISPLA-P NIL NIL)
(DEF-MFORMAT-VAR PRE-%-P NIL NIL)
(DEF-MFORMAT-VAR POST-%-P NIL NIL)

#-PDP10
(DEFMFUN CHECK-OUT-OF-CORE-STRING (string) string)

(DEFMACRO PUSH-TEXT-TEMP ()
	  '(IF TEXT-TEMP (SETQ TEXT (CONS (CONS '(TEXT-STRING) (NREVERSE TEXT-TEMP))
					  TEXT)
			       TEXT-TEMP NIL)))

(DEFMACRO OUTPUT-TEXT ()
	  '(PROGN (PUSH-TEXT-TEMP)
		  (OUTPUT-TEXT* STREAM TEXT DISPLA-P PRE-%-P POST-%-P)
		  (SETQ TEXT NIL DISPLA-P NIL PRE-%-P NIL POST-%-P NIL)))

(DEF-MFORMAT-OP (#/% #/&)
		(COND ((OR TEXT TEXT-TEMP)
		       (SETQ POST-%-P T)
		       ;; there is text to output.
		       (OUTPUT-TEXT))
		      (T
		       (SETQ PRE-%-P T))))

(DEF-MFORMAT-OP #/M
		(PUSH-TEXT-TEMP)
		(LET ((ARG (POP-MFORMAT-ARG)))
		     (AND @-FLAG (ATOM ARG) 
			  (SETQ ARG (OR (GET ARG 'OP) ARG)))
		     (COND (/:-FLAG
			    (PUSH (CONS '(TEXT-STRING) (MSTRING ARG)) TEXT))
			   (T
			    (SETQ DISPLA-P T)
			    (PUSH ARG TEXT)))))

(DEF-MFORMAT-OP #/A
		(PUSH-TEXT-TEMP)
		(PUSH (CONS '(TEXT-STRING) (EXPLODEN (POP-MFORMAT-ARG))) TEXT))

(DEF-MFORMAT-OP #/S
		(PUSH-TEXT-TEMP)
		(PUSH (CONS '(TEXT-STRING)
			    (MAP #'(LAMBDA (C)
					   (RPLACA C (GETCHARN (CAR C) 1)))
				 (EXPLODE (POP-MFORMAT-ARG))))
		      TEXT))

(DEFMFUN MFORMAT N
  (OR (> N 1)
      ;; make error message without new symbols.
      ;; This error should not happen in compiled code because
      ;; this check is done at compile time too.
      (ERROR 'WRNG-NO-ARGS 'MFORMAT))
  (LET ((STREAM (ARG 1))
	(STRING (exploden (check-out-of-core-string (ARG 2))))
	(arg-index 2))
    #+NIL
    (AND (OR (NULL STREAM)
	     (EQ T STREAM))
	 (SETQ STREAM STANDARD-OUTPUT))
    ;; This is all done via macros to save space,
    ;; (No functions, no special variable symbols.)
    ;; If the lack of flexibilty becomes an issue then
    ;; it can be changed easily.
    (MFORMAT-LOOP (OUTPUT-TEXT))
    ;; On Multics keep from getting bitten by line buffering.
    #+Multics
    (FORCE-OUTPUT STREAM)
    ))

(DEFUN OUTPUT-TEXT* (STREAM TEXT DISPLA-P PRE-%-P POST-%-P)
  (SETQ TEXT (NREVERSE TEXT))
  ;; outputs a META-LINE of text.
  (COND (DISPLA-P (DISPLAF (CONS '(MTEXT) TEXT) STREAM))
	(T
	 (IF PRE-%-P (TERPRI STREAM))
	 (DO ()
	     ((NULL TEXT))
	   (DO ((L (CDR (POP TEXT)) (CDR L)))
	       ((NULL L))
	     (TYO (CAR L) STREAM)))
	 (IF POST-%-P (TERPRI STREAM)))))

(DEFUN (TEXT-STRING DIMENSION) (FORM RESULT)
  ;; come up with something more efficient later.
  (DIMENSION-ATOM (MAKNAM (CDR FORM)) RESULT))

(DEFMFUN DISPLAF (OBJECT STREAM)
  ;; for DISPLA to a file. actually this works for SFA's and
  ;; other streams in maclisp.
  (IF (EQ STREAM NIL)
      (DISPLA OBJECT)
      (LET ((/^R T)
	    (/^W T)
	    (OUTFILES (NCONS STREAM)))
	(DISPLA OBJECT))))


(DEFMFUN MTELL (&REST L)
  (LEXPR-FUNCALL #'MFORMAT NIL L))


;; Calling-sequence optimizations.
#+PDP10
(PROGN 'COMPILE
       (LET ((X (GETL 'MFORMAT '(EXPR LSUBR))))
	 (REMPROP '*MFORMAT (CAR X))
	 (PUTPROP '*MFORMAT (CADR X) (CAR X)))
       (DECLARE (*LEXPR *MFORMAT))
       (DEFMFUN *MFORMAT-2 (A B) (*MFORMAT A B))
       (DEFMFUN *MFORMAT-3 (A B C) (*MFORMAT A B C))
       (DEFMFUN *MFORMAT-4 (A B C D) (*MFORMAT A B C D))
       (DEFMFUN *MFORMAT-5 (A B C D E) (*MFORMAT A B C D E))

       (LET ((X (GETL 'MTELL '(EXPR LSUBR))))
	 (REMPROP '*MTELL (CAR X))
	 (PUTPROP '*MTELL (CADR X) (CAR X)))
       (DECLARE (*LEXPR *MTELL))
       (DEFMFUN MTELL1 (A)         (*MTELL A))
       (DEFMFUN MTELL2 (A B)       (*MTELL A B))
       (DEFMFUN MTELL3 (A B C)     (*MTELL A B C))
       (DEFMFUN MTELL4 (A B C D)   (*MTELL A B C D))
       (DEFMFUN MTELL5 (A B C D E) (*MTELL A B C D E))
       )


