;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1982 Massachusetts Institute of Technology         ;;;
;;; Original code by CFFK.  Modified to interface correctly with TRANSL  ;;;
;;; and the rest of macsyma by GJC                                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module rombrg)
(load-macsyma-macros transm numerm)

(declare (special user-timesofar))

;;; the following code if for historical frame of reference.
;;;(defun fmeval3 (x1) 
;;;       (cond ((fixp (setq x1 (meval x1))) (float x1))
;;;	     ((floatp x1) x1)
;;;	     (t (displa x1) (error '|not floating point|))))
;;;
;;;(defun qeval3 (y1 x1 z)
;;;       (cond (x1 (fmeval3 (list '($ev) y1 (list '(mequal) x1 z) '$numer)))
;;;	     (t (funcall y1 z))))

(DEFMVAR  $ROMBERGIT 11. "the maximum number of iterations" FIXNUM)
(DEFMVAR  $ROMBERGMIN 0. "the minimum number of iterations" FIXNUM)
(DEFMVAR  $ROMBERGTOL 1.e-4 "the relative tolerance of error" FLONUM)	
(DEFMVAR  $ROMBERGABS 0.0 "the absolute tolerance of error"  FLONUM)
(DEFMVAR  $ROMBERGIT_USED 0 "the number of iterations actually used." FIXNUM)

(DEFVAR ROMB-PRINT NIL ); " For ^]"


(defun $ROMBERG_SUBR (FUNCTION LEFT RIGHT
			       &aux (st "&the first arg to ROMBERG"))
  (BIND-TRAMP1$
   F FUNCTION
   (LET ((A (FLOAT LEFT))
	 (B (FLOAT RIGHT))
	 (X 0.0)
	 (TT (*array nil 'flonum $rombergit))
	 (RR (*array nil 'flonum $rombergit))
	 (USER-TIMESOFAR (cons 'romb-timesofar user-timesofar))
	 (ROMB-PRINT NIL))
     (setq X (-$ B A))
     (SETF (AREF$ TT 0)
	   (*$ x (+$ (FCALL$ F b st) (FCALL$ F a st)) 0.5))
     (SETF	(AREF$ RR 0.)
		(*$ x (FCALL$ F (*$ (+$ b a) 0.5) st)))
     (do ((l 1. (1+ l)) (m 4. (* m 2.)) (y 0.0) (z 0.0) (cerr 0.0))
	 ((= l $rombergit)
	  (MERROR "ROMBERG failed to converge"))
       (DECLARE (FLONUM Y Z CERR)
		(FIXNUM L M))
       (setq y (float m) z (//$ x y))
       (SETF (AREF$ TT L) (*$ (+$ (AREF$ tt (1- l))
				  (AREF$ rr (1- l))) 0.5))
       (SETF (AREF$ RR L) 0.0)
       (do ((i 1. (+ i 2.)))
	   ((> i m))
	 (COND (ROMB-PRINT
		(SETQ ROMB-PRINT NIL)			;^] magic.
		(MTELL "Romberg: ~A iterations; last error =~A;~
			    calculating F(~A)."
		       I
		       CERR
		       (+$ (*$ z (float i)) a))))
	 (SETF (AREF$ RR L) (+$ (FCALL$ F (+$ (*$ z (float i)) a) st)
				(AREF$ rr l))))
       (SETF (AREF$ RR L) (*$ z (AREF$ rr l) 2.0))
       (setq y 0.0)
       (do ((k l (1- k))) ((= k 0.))
	 (DECLARE (FIXNUM K))
	 (setq y (+$ (*$ y 4.0) 3.0))
	 (SETF (AREF$  TT (1- K))
	       (+$ (//$ (-$ (AREF$ tt k)
			    (AREF$ tt (1- k))) y)
		   (AREF$ tt k)))
	 (SETF (AREF$ RR (1- K))
	       (+$ (//$ (-$ (AREF$ rr k)
			    (AREF$ rr (1- k))) y)
		   (AREF$ rr k))))
       (setq y (*$ (+$ (AREF$ tt 0.)
		       (AREF$ rr 0.)) 0.5))
       ;;; this is the WIN condition test.
       (cond ((and
	       (or (not
		    (< $rombergabs
		       (setq cerr
			     (abs (-$ (AREF$ tt 0.)
				      (AREF$ rr 0.))))))
		   (not (< $rombergtol
			   ;; cerr = "calculated error"; used for ^]
			   (setq cerr (//$ cerr
					   (cond ((= y 0.0) 1.0)
						 (t (abs y))))))))
	       (> l $rombergmin))
	      (SETQ $ROMBERGIT_USED L)
	      #+maclisp
	      (progn (*rearray tt) (*rearray rr))
	      (return y)))))))



(defun romb-timesofar () (setq romb-print t))  ;^] function.
;;; Making the ^] scheme work through this special variable makes
;;; it possible to avoid various timing screws and having to have
;;; special variables for communication between the interrupt and MP
;;; function.  On the other hand, it may make it more difficult to
;;; have multiple reports (double integrals etc.).


;;; TRANSL SUPPORT.

(DEFPROP $ROMBERG_SUBR $FLOAT FUNCTION-MODE)

(DEFUN ROMBERG-MACRO (FORM TRANSLATEP)
  (SETQ FORM (CDR FORM))
  (COND ((= (LENGTH FORM) 3)
	 (COND (TRANSLATEP
		`(($ROMBERG_SUBR) ,@FORM))
	       (T
		`((MPROG) ((MLIST) ((MSETQ) $NUMER T) ((MSETQ) $%ENUMER T))
			  (($ROMBERG_SUBR) ,@FORM)))))
	((= (LENGTH FORM) 4)
	 (LET (((EXP VAR . BNDS) FORM))
	   (COND (TRANSLATEP
		  `(($ROMBERG_SUBR)
		    ((LAMBDA-I) ((MLIST) ,VAR)
				(($MODEDECLARE) ,VAR $FLOAT)
				,EXP)
		    ,@BNDS))
		 (T
		  `((MPROG) ((MLIST) ((MSETQ) $NUMER T) ((MSETQ) $%ENUMER T))
			    (($ROMBERG_SUBR)
			     ((LAMBDA) ((MLIST) ,VAR) ,EXP)
			     ,@BNDS))))))
	(T
	 (WNA-ERR '$ROMBERG))))

(DEFMSPEC $ROMBERG (FORM)
  (MEVAL (ROMBERG-MACRO FORM NIL)))

(def-translate-property $ROMBERG (FORM)
  (LET (($TR_NUMER T))
    (TRANSLATE (ROMBERG-MACRO FORM T))))