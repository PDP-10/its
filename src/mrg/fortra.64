;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module fortra)

(DECLARE (SPECIAL LB RB	        ;Used for communication with MSTRING.
		  $LOADPRINT	;If NIL, no load message gets printed.
		  1//2 -1//2)
	 (*LEXPR FORTRAN-PRINT $FORTMX))

(DEFMVAR $FORTSPACES NIL
   "If T, Fortran card images are filled out to 80 columns using spaces."
   BOOLEAN
   MODIFIED-COMMANDS '$FORTRAN)

(DEFMVAR $FORTINDENT 0
   "The number of spaces (beyond 6) to indent Fortran statements as they
   are printed."
   FIXNUM
   MODIFIED-COMMANDS '$FORTRAN)

(DEFMVAR $FORTFLOAT NIL "Something JPG is working on.")

;; This function is called from Macsyma toplevel.  If the argument is a
;; symbol, and the symbol is bound to a matrix, then the matrix is printed
;; using an array assignment notation.

(DEFMSPEC $FORTRAN (L)
 (SETQ L (FEXPRCHECK L))
 (LET ((VALUE (STRMEVAL L)))
      (COND ((MSETQP L) (SETQ VALUE `((MEQUAL) ,(CADR L) ,(MEVAL L)))))
      (COND ((AND (SYMBOLP L) ($MATRIXP VALUE))
	     ($FORTMX L VALUE))
	    ((AND (NOT (ATOM VALUE)) (EQ (CAAR VALUE) 'MEQUAL)
		  (SYMBOLP (CADR VALUE)) ($MATRIXP (CADDR VALUE)))
	     ($FORTMX (CADR VALUE) (CADDR VALUE)))
	    (T (FORTRAN-PRINT VALUE)))))

;; This function is called from Lisp programs.  It takes an expression and
;; a stream argument.  Default stream is NIL in MacLisp and STANDARD-OUTPUT
;; in LMLisp.  This should be canonicalized in Macsyma at some point.

;; TERPRI is a PDP10 MacLisp flag which, if set to T, will keep symbols and
;; bignums from being broken across page boundaries when printed.  $LOADPRINT
;; is NIL to keep a message from being printed when the file containing MSTRING
;; is loaded.  (MRG;GRIND)

(DEFPROP MEXPT (#/* #/*) DISSYM)

(DEFUN FORTRAN-PRINT (X &OPTIONAL (STREAM #-LISPM NIL #+LISPM STANDARD-OUTPUT)
			&AUX #+PDP10 (TERPRI T) #+PDP10 ($LOADPRINT NIL)
		        ;; This is a poor way of saying that array references
  		        ;; are to be printed with parens instead of brackets.
			(LB #/( ) (RB #/) ))
  ;; Restructure the expression for displaying.
  (SETQ X (FORTSCAN X))
  ;; Linearize the expression using MSTRING.  Some global state must be
  ;; modified for MSTRING to generate using Fortran syntax.  This must be
  ;; undone so as not to modifiy the toplevel behavior of MSTRING.
  (UNWIND-PROTECT
   (PROGN
    (DEFPROP MEXPT MSIZE-INFIX GRIND)
    (DEFPROP MMINUS 100. LBP)
    (DEFPROP MSETQ (#/=) STRSYM)
    (SETQ X (MSTRING X)))
   ;; Make sure this gets done before exiting this frame.
   (DEFPROP MEXPT MSZ-MEXPT GRIND)
   (REMPROP 'MMINUS 'LBP)
   (DEFPROP MSETQ (#/:) STRSYM))
  ;; MSTRING returns a list of characters.   Now print them.
  (DO ((C #/0 (+ 1 (\ (- c #/0) 16) #/0))
       (COLUMN (+ 6 $FORTINDENT) (+ 9 $FORTINDENT)))
      ((NULL X))
      ;; Print five spaces, a continuation character if needed, and then
      ;; more spaces.  COLUMN points to the last column printed in.  When
      ;; it equals 80, we should quit.
      (COND ((= C #/0)
	     (PRINT-SPACES COLUMN STREAM))
	    (T (PRINT-SPACES 5 STREAM)
	       (TYO C STREAM)
	       (PRINT-SPACES (- COLUMN 6) STREAM)))
      ;; Print the expression.  Remember, Fortran ignores blanks and line
      ;; terminators, so we don't care where the expression is broken.
      (DO ()
	  ((= COLUMN 72.))
	  (IF (NULL X)
	      (IF $FORTSPACES (TYO #\SP STREAM) (RETURN NIL))
	      (progn (and (equal (car x) #/\) (setq x (cdr x)))
		     (TYO (POP X) STREAM)))
	  (INCREMENT COLUMN))
      ;; Columns 73 to 80 contain spaces
      (IF $FORTSPACES (PRINT-SPACES 8 STREAM))
      (TERPRI STREAM))
  '$DONE)

(DEFUN PRINT-SPACES (N STREAM)
       (DOTIMES (I N) (TYO #\SP STREAM)))

;; This function is similar to NFORMAT.  Prepare an expression
;; for printing by converting x^(1/2) to sqrt(x), etc.  A better
;; way of doing this would be to have a programmable printer and
;; not cons any new expressions at all.  Some of this formatting, such
;; as E^X --> EXP(X) is specific to Fortran, but why isn't the standard
;; function used for the rest?

(DEFUN FORTSCAN (E)
 (COND ((ATOM E) (cond ((eq e '$%i) '((mprogn) 0.0 1.0))
		       (t E))) ;%I is (0,1)
       ((AND (EQ (CAAR E) 'MEXPT) (EQ (CADR E) '$%E))
	(LIST '($EXP SIMP) (FORTSCAN (CADDR E))))
       ((AND (EQ (CAAR E) 'MEXPT) (ALIKE1 (CADDR E) 1//2))
	(LIST '(%SQRT SIMP) (FORTSCAN (CADR E))))
       ((AND (EQ (CAAR E) 'MEXPT) (ALIKE1 (CADDR E) -1//2))
	(LIST '(MQUOTIENT SIMP) 1 (LIST '(%SQRT SIMP) (FORTSCAN (CADR E)))))
       ((AND (EQ (CAAR E) 'MTIMES) (RATNUMP (CADR E))
	     (MEMBER (CADADR E) '(1 -1)))
	(COND ((EQUAL (CADADR E) 1) (FORTSCAN-MTIMES E))
	      (T (LIST '(MMINUS SIMP) (FORTSCAN-MTIMES E)))))
       ((EQ (CAAR E) 'RAT)
	(LIST '(MQUOTIENT SIMP) (FLOAT (CADR E)) (FLOAT (CADDR E))))
       ((EQ (CAAR E) 'MRAT) (FORTSCAN (RATDISREP E)))
       ;;  complex numbers to f77 syntax a+b%i ==> (a,b)
       ((and (memq (caar e) '(mtimes mplus))
	     ((lambda (a) 
		      (and (numberp (cadr a))
			   (numberp (caddr a))
			   (not (zerop1 (cadr a)))
			   (list '(mprogn) (caddr a) (cadr a))))
	      (simplify ($bothcoef e '$%i)))))
       (T (CONS (CAR E) (MAPCAR 'FORTSCAN (CDR E))))))

(DEFUN FORTSCAN-MTIMES (E)
       (LIST '(MQUOTIENT SIMP)
	     (COND ((NULL (CDDDR E)) (FORTSCAN (CADDR E)))
		   (T (CONS (CAR E) (MAPCAR 'FORTSCAN (CDDR E)))))
	     (FLOAT (CADDR (CADR E)))))

;; Takes a name and a matrix and prints a sequence of Fortran assignment
;; statements of the form
;;  NAME(I,J) = <corresponding matrix element>

(DEFMFUN $FORTMX (NAME MAT &OPTIONAL (STREAM #-LISPM NIL #+LISPM STANDARD-OUTPUT)
			 &AUX ($LOADPRINT NIL))
  (DECLARE (FIXNUM I J))
  (COND ((NOT (EQ (TYPEP NAME) 'SYMBOL))
	 (MERROR "~%First argument to FORTMX must be a symbol."))
	((NOT ($MATRIXP MAT))
	 (MERROR "Second argument to FORTMX not a matrix: ~M" MAT)))
  (DO ((MAT (CDR MAT) (CDR MAT)) (I 1 (1+ I))) ((NULL MAT))
      (DO ((M (CDAR MAT) (CDR M)) (J 1 (1+ J))) ((NULL M))
	  (FORTRAN-PRINT `((MEQUAL) ((,NAME) ,I ,J) ,(CAR M)) STREAM)))
  '$DONE)


;; Local Modes:
;; Comment Column:26
;; End:
