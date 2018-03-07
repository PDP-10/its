;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module mrgmac macro)

#-LISPM
(DEFMACRO FIX-LM BODY
  `(PROGN . ,BODY))

#+LISPM
(DEFMACRO FIX-LM (&BODY BODY)
  `(LET ((DEFAULT-CONS-AREA WORKING-STORAGE-AREA))
     . ,BODY))

;; The GRAM and DISPLA packages manipulate lists of fixnums, representing
;; lists of characters.  This syntax facilitates typing them in.
;; {abc} reads as (#/a #/b #/c), unquoted.

(DEFUN CHAR-LIST-SYNTAX-ON ()
  (FIX-LM
    (SETSYNTAX '/{ 'MACRO
	       #'(LAMBDA () (DO ((C (TYI) (TYI)) (NL))
				((= #/} C) (NREVERSE NL))
			      (SETQ NL (CONS C NL)))))
    T))

(DEFUN CHAR-LIST-SYNTAX-OFF ()
  (FIX-LM
    #+(OR MACLISP NIL) (SETSYNTAX '/{ 'MACRO NIL)
    #+Franz   (setsyntax '/{ 2)
    #+LISPM   (SET-SYNTAX-FROM-DESCRIPTION #/{ 'SI:ALPHABETIC)))

;; This sets up the syntax for a simple mode system defined later on
;; in this file.  As usual, it is poorly documented.

(DEFUN MODE-SYNTAX-ON ()
  ;; :A:B:C --> (SEL A B C)
  ;; A component selection facility.  :A:B:C is like (C (B A)) in the
  ;; DEFSATRUCT world.
  (FIX-LM
    (SETSYNTAX '/: 'MACRO
	       #'(LAMBDA () (DO ((L (LIST (READ)) (CONS (READ) L)))
				((NOT (= #/: (TYIPEEK))) (CONS 'SEL (NREVERSE L)))
			      (TYI))))
    
    ;; <A B C> --> (SELECTOR A B C)  Used when defining a mode.
    (SETSYNTAX '/< 'MACRO
	       #'(LAMBDA ()
		   (COND ((= #\SPACE (TYIPEEK)) '|<|)
			 ((= #/= (TYIPEEK)) (TYI) '|<=|)
			 (T (DO ((S (READ) (READ)) (NL))
				((EQ '/> S) (CONS 'SELECTOR (NREVERSE NL)))
			      (SETQ NL (CONS S NL)))))))
    
    ;; Needed as a single character object.  Used when defining a mode.
    (SETSYNTAX '/> 'MACRO
	       #'(LAMBDA ()
		   (COND ((NOT (= #/= (TYIPEEK))) '/>)
			 (T (TYI) '|>=|))))
    T))

(DEFUN MODE-SYNTAX-OFF ()
  (FIX-LM
    #+(OR MACLISP NIL) (PROGN (SETSYNTAX '/: 'MACRO NIL)
			      (SETSYNTAX '/< 'MACRO NIL)
			      (SETSYNTAX '/> 'MACRO NIL))
    #+LISPM (PROGN (SI:SET-SYNTAX-BITS #/: '(0 . 23))
		   (SET-SYNTAX-FROM-DESCRIPTION #/> 'SI:ALPHABETIC)
		   (SET-SYNTAX-FROM-DESCRIPTION #/< 'SI:ALPHABETIC))
    #+Franz (progn (setsyntax '/: 2)
		   (setsyntax '/< 2)
		   (setsyntax '/> 2))))

;; Loading this file used to turn on the mode syntax.  Its been turned off
;; now and hopefully no files left rely on it.  Files which want to 
;; use that syntax should call (MODE-SYNTAX-ON) during read time.

#+MACLISP
(DEFUN DEFINE-MACRO (NAME LAMBDA-EXP)
    (PUTPROP NAME LAMBDA-EXP 'MACRO))

#+LISPM
(DEFUN DEFINE-MACRO (NAME LAMBDA-EXP)
  (FIX-LM
    (COND ((ATOM LAMBDA-EXP) (SETQ LAMBDA-EXP (FSYMEVAL LAMBDA-EXP))))
    (FSET NAME (CONS 'MACRO LAMBDA-EXP))))

#+Franz
(defun define-macro (name lambda-exp)
  (putd name `(macro (dummy-arg) (,lambda-exp dummy-arg))))

#+NIL
(DEFUN DEFINE-MACRO (NAME LAMBDA-EXP)
  (ADD-MACRO-DEFINITION NAME LAMBDA-EXP))

;; LAMBIND* and PROGB* are identical, similar to LET, but contain an implicit
;; PROG.  On the Lisp Machine, PROG is extended to provide this capability.

(DEFMACRO LAMBIND* (VAR-LIST . BODY) `(LET ,VAR-LIST (PROG NIL . ,BODY)))
(DEFMACRO PROGB* (VAR-LIST . BODY) `(LET ,VAR-LIST (PROG NIL . ,BODY)))

(DEFUN MAPAND MACRO (X)
  `(DO ((L ,(CADDR X) (CDR L))) ((NULL L) T)
       (IFN (,(CADR X) (CAR L)) (RETURN NIL))))

(DEFUN MAPOR MACRO (X)
  `(DO L ,(CADDR X) (CDR L) (NULL L)
       (IF (FUNCALL ,(CADR X) (CAR L)) (RETURN T))))

;; (MAPLAC #'1+ '(1 2 3)) --> '(2 3 4), but the original list is rplaca'd
;; rather than a new list being consed up.

(DEFMACRO MAPLAC (FUNCTION LIST)
  `(DO L ,LIST (CDR L) (NULL L) (RPLACA L (FUNCALL ,FUNCTION (CAR L)))))

(DEFUN PUT MACRO (X) `(PUTPROP . ,(CDR X)))
(DEFUN REM MACRO (X) `(REMPROP . ,(CDR X)))

(DEFMACRO COPYP (L) `(CONS (CAR ,L) (CDR ,L)))
(DEFMACRO COPYL (L) `(APPEND ,L NIL))

(DEFMACRO ECONS (X Y) `(APPEND ,X (LIST ,Y)))

#-Franz 
(progn 'compile
  (DEFMACRO CAAADAR (X) `(CAAADR (CAR ,X)))
  (DEFMACRO CAAADDR (X) `(CAAADR (CDR ,X)))
  (DEFMACRO CAADAAR (X) `(CAADAR (CAR ,X)))
  (DEFMACRO CAADADR (X) `(CAADAR (CDR ,X)))
  (DEFMACRO CADAAAR (X) `(CADAAR (CAR ,X)))
  (DEFMACRO CADADDR (X) `(CADADR (CDR ,X)))
  (DEFMACRO CADDAAR (X) `(CADDAR (CAR ,X)))
  (DEFMACRO CADDDAR (X) `(CADDDR (CAR ,X)))
  (DEFMACRO CDADADR (X) `(CDADAR (CDR ,X)))
  (DEFMACRO CDADDDR (X) `(CDADDR (CDR ,X)))
  (DEFMACRO CDDDDDR (X) `(CDDDDR (CDR ,X))))

(DEFMACRO TELL (&REST ARGS) `(DISPLA (LIST '(MTEXT) . ,ARGS)))



(DECLARE (SPECIAL NAME BAS MOBJECTS SELECTOR) (*EXPR MODE))

(SETQ MOBJECTS NIL)

(DEFPROP MODE (C-MODE S-MODE A-MODE) MODE)

(DEFUN C-MODE MACRO (X) `(LIST . ,(CDR X)))

(DEFUN S-MODE MACRO (X)
  (COND ((EQ 'C (CADDR X)) `(CAR ,(CADR X)))
	((EQ 'SEL (CADDR X)) `(CADR ,(CADR X)))
	((EQ '_ (CADDR X)) `(CADDR ,(CADR X)))))

(DEFUN A-MODE MACRO (X)
  (COND ((EQ 'C (CADDR X)) `(RPLACA (CADR X) ,(CADDDR X)))
	((EQ 'SEL (CADDR X)) `(RPLACA (CDR ,(CADR X)) ,(CADDDR X)))
	((EQ '_ (CADDR X)) `(RPLACA (CDDR ,(CADR X)) ,(CADDDR X)))))

(DEFUN DEFMODE MACRO (X)
  (LET ((SELECTOR (MEMQ 'SELECTOR (CDDDDR X))))
    (DEFINE-MODE (CADR X) (CADDDR X))
    (MAPC 'EVAL (CDDDDR X))
    `',(CADR X)))

(DEFUN DEFINE-MODE (NAME DESC)
  (PROG (C S A DUMMY)
    (SETQ DUMMY (EXPLODEC NAME)
	  C (IMPLODE (APPEND '(C -) DUMMY))
	  S (IMPLODE (APPEND '(S -) DUMMY))
	  A (IMPLODE (APPEND '(A -) DUMMY)))
    (DEFINE-MACRO C (DEFC DESC))
    (DEFINE-MACRO S (DEFS DESC))
    (DEFINE-MACRO A (DEFA DESC))
    (PUT NAME (C-MODE C S A) 'MODE)
    (RETURN NAME)))


(DEFUN DEFC (DESC) (LET ((BAS 'X)) `(LAMBDA (X) ,(DEFC1 DESC))))

(DEFUN DEFC1 (DESC)
  (COND ((ATOM DESC) (LIST 'QUOTE DESC))
	((EQ 'SELECTOR (CAR DESC))
	 (COND ((NOT (NULL (CDDDR DESC))) (LIST 'QUOTE (CADDDR DESC)))
	       (T (SETQ BAS (LIST 'CDR BAS))
		  (LIST 'CAR BAS))))
	((EQ 'ATOM (CAR DESC))
	 `(LIST 'C-ATOM '',(MAPCAR 'CADR (CDR DESC)) (CONS 'LIST (CDR X))))
	((EQ 'CONS (CAR DESC)) `(LIST 'CONS ,(DEFC1 (CADR DESC)) ,(DEFC1 (CADDR DESC))))
	((EQ 'LIST (CAR DESC))
	 (DO ((L (CDR DESC) (CDR L)) (NL))
	     ((NULL L) `(LIST 'LIST . ,(NREVERSE NL)))
	     (SETQ NL (CONS (DEFC1 (CAR L)) NL))))
	((EQ 'STRUCT (CAR DESC)) (DEFC1 (CONS 'LIST (CDR DESC))))
	(T (LIST 'QUOTE DESC))))


(DEFUN DEFS (DESC)
  `(LAMBDA (X) (COND . ,(NREVERSE (DEFS1 DESC '(CADR X) NIL)))))

(DEFUN DEFS1 (DESC BAS RESULT)
  (COND ((ATOM DESC) RESULT)
	((EQ 'SELECTOR (CAR DESC))
	 (PUT (CADR DESC) (CONS (CONS NAME (CADDR DESC)) (GET (CADR DESC) 'MODES)) 'MODES)
	 (PUT NAME (CONS (CONS (CADR DESC) (CADDR DESC)) (GET NAME 'SELS)) 'SELS)
	 (IF SELECTOR (DEFINE-MACRO (CADR DESC) 'SELECTOR))
	 (CONS `((EQ ',(CADR DESC) (CADDR X)) ,BAS) RESULT))
	((EQ 'ATOM (CAR DESC))
	 (DO L (CDR DESC) (CDR L) (NULL L)
	     (PUT (CADAR L) (CONS (CONS NAME (CADDAR L)) (GET (CADAR L) 'MODES)) 'MODES)
	     (PUT NAME (CONS (CONS (CADAR L) (CADDAR L)) (GET NAME 'SELS)) 'SELS)
	     (IF SELECTOR (DEFINE-MACRO (CADAR L) 'SELECTOR)))
	 (CONS `((MEMQ (CADDR X) ',(MAPCAR 'CADR (CDR DESC))) (LIST 'GET ,BAS (LIST 'QUOTE (CADDR X))))
	       RESULT))
	((EQ 'CONS (CAR DESC))
	 (SETQ RESULT (DEFS1 (CADR DESC) `(LIST 'CAR ,BAS) RESULT))
	 (DEFS1 (CADDR DESC) `(LIST 'CDR ,BAS) RESULT))
	((EQ 'LIST (CAR DESC))
	 (DO L (CDR DESC) (CDR L) (NULL L)
	     (SETQ RESULT (DEFS1 (CAR L) `(LIST 'CAR ,BAS) RESULT)
		   BAS `(LIST 'CDR ,BAS)))
	 RESULT)
	((EQ 'STRUCT (CAR DESC)) (DEFS1 (CONS 'LIST (CDR DESC)) BAS RESULT))
	(T RESULT)))

(DEFUN DEFA (DESC)
  `(LAMBDA (X) (COND . ,(NREVERSE (DEFA1 DESC '(CADR X) NIL NIL)))))

(DEFUN DEFA1 (DESC BAS CDR RESULT)
  (COND ((ATOM DESC) RESULT)
	((EQ 'SELECTOR (CAR DESC))
	 (SETQ BAS (COND ((NOT CDR) `(LIST 'CAR (LIST 'RPLACA ,(CADDR BAS) (CADDDR X))))
			 (T `(LIST 'CDR (LIST 'RPLACD ,(CADDR BAS) (CADDDR X))))))
	 (CONS `((EQ ',(CADR DESC) (CADDR X)) ,BAS) RESULT))
	((EQ 'ATOM (CAR DESC))
	 (LIST `(T (LIST 'A-ATOM (CADR X) (LIST 'QUOTE (CADDR X)) (CADDDR X)))))
	((EQ 'CONS (CAR DESC))
	 (SETQ RESULT (DEFA1 (CADR DESC) `(LIST 'CAR ,BAS) NIL RESULT))
	 (DEFA1 (CADDR DESC) `(LIST 'CDR ,BAS) T RESULT))
	((EQ 'LIST (CAR DESC))
	 (DO L (CDR DESC) (CDR L) (NULL L)
	     (SETQ RESULT (DEFA1 (CAR L) `(LIST 'CAR ,BAS) NIL RESULT)
		   BAS `(LIST 'CDR ,BAS)))
	 RESULT)
	((EQ 'STRUCT (CAR DESC)) (DEFA1 (CONS 'LIST (CDR DESC)) BAS CDR RESULT))
	(T RESULT)))


(DEFUN MODE (X) (CDR (ASSOC X MOBJECTS)))

#-NIL
(DEFUN MODEDECLARE FEXPR (X)
  (MAPC '(LAMBDA (L) (MAPC '(LAMBDA (V) (PUSH (CONS V (CAR L)) MOBJECTS))
			   (CDR L)))
	X))
#+NIL
(DEFMACRO MODEDECLARE (&REST X)
  ;; I BET THIS FUNCTION IS NEVER EVEN CALLED ANYPLACE.
  (MAPC (LAMBDA (L)
	  (DECLARE (SPECIAL L))
	  (MAPC (LAMBDA (V) (PUSH (CONS V (CAR L)) MOBJECTS))
		(CDR L)))
	X)
  `',X)

(DEFUN NDM-ERR (X)
  (TERPRI)
  (PRINC '|Cannot determine the mode of |) (PRINC X)
  (ERROR 'NDM-ERR))

(DEFUN NSM-ERR (X)
  (TERPRI)
  (PRINC '|No such mode as |) (PRINC X)
  (ERROR 'NSM-ERR))

(DEFUN SEL-ERR (B S)
  (TERPRI)
  (PRINC '/:) (PRINC B)
  (DO () ((NULL S)) (PRINC '/:) (PRINC (CAR S)) (SETQ S (CDR S)))
  (PRINC '|is an impossible selection|)
  (ERROR 'SEL-ERR))

(DEFUN IA-ERR (X)
  (TERPRI)
  (PRINC '|Cannot assign |) (PRINC X)
  (ERROR 'IA-ERR))

(DEFUN SEL MACRO (X)
  (LET ((S (FSEL (MODE (CADR X)) (CDDR X))))
    (COND ((NULL S) (SEL-ERR (CADR X) (CDDR X)))
	  (T (SETQ X (CADR X))
	     (DO () ((NULL (CDR S)) X)
		 (SETQ X (CONS (CADR (GET (CAR S) 'MODE)) (RPLACA S X)) S (CDDR S))
		 (RPLACD (CDDR X) NIL))))))

(DEFUN FSEL (M SELS)		; This has a bug in it.
  (COND ((NULL SELS) (LIST M))
	((NULL M)
	 (DO L (GET (CAR SELS) 'MODES) (CDR L) (NULL L)
	     (IF (SETQ M (FSEL (CDAR L) (CDR SELS)))
		 (RETURN (CONS (CAAR L) (CONS (CAR SELS) M))))))
	((LET (DUM)
	   (IF (SETQ DUM (ASSQ (CAR SELS) (GET M 'SELS)))
	       (CONS M (CONS (CAR SELS) (FSEL (CDR DUM) (CDR SELS)))))))
	(T (DO ((L (GET M 'SELS) (CDR L)) (DUM)) ((NULL L))
	       (IF (SETQ DUM (FSEL (CDAR L) SELS))
		   (RETURN (CONS M (CONS (CAAR L) DUM))))))))

(DEFUN SELECTOR (X)
  (IF (NULL (CDDR X)) `(SEL ,(CADR X) ,(CAR X))
      `(_ (SEL ,(CADR X) ,(CAR X)) ,(CADDR X))))


(DEFUN _ MACRO (X) `(STO . ,(CDR X)))

(DEFUN STO MACRO (X)
  (DO ((L (CDR X) (CDDR L)) (S) (NL))
      ((NULL L) `(PROGN . ,(NREVERSE NL)))
      (COND ((ATOM (CAR L)) (SETQ NL (CONS `(SETQ ,(CAR L) ,(CADR L)) NL)))
	    ((AND (EQ 'SEL (CAAR L)) (SETQ S (FSEL (MODE (CADAR L)) (CDDAR L))))
	     (SETQ X (CADAR L))
	     (DO L (CDDR S) (CDDR L) (NULL (CDR L))
		 (SETQ X (CONS (CADR (GET (CAR L) 'MODE)) (RPLACA L X)))
		 (RPLACD (CDDR X) NIL))
	     (SETQ NL (CONS (LIST (CADDR (GET (CAR S) 'MODE)) X (CADR S) (CADR L)) NL)))
	    (T (IA-ERR (CAR L))))))


;; (C-ATOM '(AGE WEIGHT MARRIED) '(21 130 NIL)) creates a plist-structure
;; with slot names as properties.  This should use SETPLIST instead
;; of RPLACD.
;; None of these functions are needed at compile time.

;; (DEFUN C-ATOM (SELS ARGS)
;;   (DO ((NL)) ((NULL SELS) (RPLACD (INTERN (GENSYM)) (NREVERSE NL)))
;;       (IF (CAR ARGS) (SETQ NL (CONS (CAR ARGS) (CONS (CAR SELS) NL))))
;;       (SETQ SELS (CDR SELS) ARGS (CDR ARGS))))

;; (DEFUN A-ATOM (BAS SEL VAL)
;;   (COND ((NULL VAL) (REMPROP BAS SEL) NIL)
;; 	(T (PUTPROP BAS VAL SEL))))

;; (DEFUN DSSQ (X L)
;;   (DO () ((NULL L))
;;       (COND ((EQ X (CDAR L)) (RETURN (CAR L)))
;; 	    (T (SETQ L (CDR L))))))


(DEFMACRO CONS-EXP (OP . ARGS) `(SIMPLIFY (LIST (LIST ,OP) . ,ARGS)))



;; Local Modes:
;; Mode: LISP
;; Comment Col: 40
;; End:
