;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module ufact)

(DECLARE (SPECIAL MODULUS COEF-TYPE))

(load-macsyma-macros ratmac rzmac)

;; Dense Polynomial Representation

(DEFUN DPREP (P)
       (DO ((N (CAR P))
	    (E (CAR P) (1- E))
	    (L))
	   ((< E 0) (CONS N (NREVERSE L)))
	   (COND ((EQUAL E (CAR P))
		  (PUSH (CADR P) L)
		  (SETQ P (CDDR P)))
		 (T (PUSH 0 L)))))

(DEFUN DPDISREP (L)
       (COND ((ZEROP (CAR L)) (CADR L))
	     ((DO ((L (NREVERSE (CDR L)) (CDR L))
		   (N 0 (1+ N))
		   (LL))
		  ((NULL L) LL)
		  (OR (= (CAR L) 0)
		      (SETQ LL (CONS N (CONS (CAR L) LL))))))))

;; not currently called
;;(DEFUN PGCDU* (P Q)
;;       (COND ((OR (PCOEFP P) (PCOEFP Q))  1)
;;	     ((NULL MODULUS)
;;	      (merror  "ILLEGAL CALL TO PGCDU"))
;;	     ((> (CADR P) (CADR Q)) 
;;	      (PSIMP (CAR P) (DPDISREP (DPGCD (DPREP (CDR P)) (DPREP (CDR Q))))))
;;	     ((PSIMP (CAR P) (DPDISREP (DPGCD (DPREP (CDR Q)) (DPREP (CDR P))))))))
;;
;;(DEFUN PMODSQFRU (P)
;;       (DO ((DPL (DPSQFR (DPREP (CDR P))) (CDR DPL))
;;	    (PL NIL (CONS (PSIMP (CAR P) (DPDISREP (CDAR DPL))) (CONS (CAAR DPL) PL))))
;;	   ((NULL DPL) PL)))

(DEFUN DPGCD (P Q)
       (IF (< (CAR P) (CAR Q)) (EXCH P Q))
       (DO ((P (COPY-TOP-LEVEL P) Q)
	    (Q (COPY-TOP-LEVEL Q) (DPREMQUO P Q NIL)))
	   ((= (CAR Q) 0)
	    (IF (= (CADR Q) 0) P '(0 1)))))

(DEFUN DPDIF (P Q)
       (COND ((> (CAR P) (CAR Q))
	      (DO ((I (CAR P) (1- I))
		   (PL (CDR P) (CDR PL))
		   (L NIL (CONS (CAR PL) L)))
		  ((= I (CAR Q)) (DPDIF1 PL (CDR Q) L)) ))
	     ((< (CAR P) (CAR Q))
	      (DO ((I (CAR Q) (1- I))
		   (QL (CDR Q) (CDR QL))
		   (L NIL (CONS (CMINUS (CAR QL)) L)))
		  ((= I (CAR P)) (DPDIF1 (CDR P) QL L))))
	     (T (DPDIF1 (CDR P) (CDR Q) NIL))))

(DEFUN DPDIF1 (P1 Q1 L)
       (DO ((PL P1 (CDR PL))
	    (QL Q1 (CDR QL))
	    (LL L (CONS (CDIFFERENCE (CAR PL) (CAR QL)) LL)))
	   ((NULL PL) (DPSIMP (NREVERSE LL)))))

(DEFUN DPSIMP (PL) (SETQ PL (STRIP-ZEROES PL))
       (COND ((NULL PL) '(0 0))
	     (T (CONS (1- (LENGTH PL)) PL))))

(DEFUN DPDERIV (P)
       (COND ((= 0 (CAR P)) '(0 0))
	     (T (DO ((L (CDR P) (CDR L))
		     (I (CAR P) (1- I))
		     (DP NIL (CONS (CTIMES I (CAR L)) DP)))
		    ((= I 0) (CONS (1- (CAR P)) (NREVERSE DP)))))))

(DEFUN DPSQFR (Q)					;ASSUMES MOD > DEGREE
       (DO ((C Q (DPMODQUO C P))
	    (D (DPDERIV Q) (DPMODQUO D P))
	    (I 0 (1+ I))
	    (P)
	    (PL))
	   ((= 0 (CAR C)) PL)
	   (COND (P (SETQ D (DPDIF D (DPDERIV C))
			  P (DPGCD C D))
		    (AND (> (CAR P) 0)
			 (SETQ PL (CONS (CONS I P) PL))))
		 (T (SETQ P (DPGCD C D))
		    (COND ((= (CAR P) 0) (RETURN (NCONS (CONS 1 C)))))))))



(DEFUN DPMODREM (P Q)
       (COND ((< (CAR P) (CAR Q)) P)
	     ((= (CAR Q) 0) '(0 0))
	     ((DPREMQUO (COPY1* P) (COPY1* Q) NIL))))
  
(DEFUN DPMODQUO (P Q)
       (COND ((< (CAR P) (CAR Q)) '(0 0))
	     ((= (CAR Q) 0)
	      (COND ((EQUAL (CADR Q) 1) P)
		    (T (CONS (CAR P)
			     (MAPCAR #'(LAMBDA (C) (CQUOTIENT C (CADR Q))) (CDR P))
			     ))))
	     ((DPREMQUO (COPY1* P) (COPY1* Q) T))))
  
;; If FLAG is T, return quotient.  Otherwise return remainder.

(DEFUN DPREMQUO (P Q FLAG)
	 (PROG (LP LQ L ALPHA)
	       (COND ((= (CADR Q) 1)
		      (SETQ ALPHA 1))
		     (T (SETQ ALPHA (CRECIP (CADR Q)))
			(DO ((L (CDDR Q) (CDR L)))
			    ((NULL L)
			     (RPLACA (CDR Q) 1))
			    (RPLACA L (CTIMES (CAR L) ALPHA)))))
	  A    (AND FLAG (SETQ L (CONS (CTIMES (CADR P) ALPHA) L)))
	       (SETQ LP (CDDR P) LQ (CDDR Q))
	  B    (RPLACA LP (CDIFFERENCE (CAR LP) (CTIMES (CAR LQ) (CADR P))))
	       (COND ((NULL (SETQ LQ (CDR LQ)))
		      (DO ((E (1- (CAR P)) (1- E))
			   (PP (CDDR P) (CDR PP)))
			  ((NULL PP) (SETQ P '(0 0)))
			  (COND ((SIGNP E (CAR PP))
				 (AND FLAG (NOT (< E (CAR Q)))
				      (SETQ L (CONS 0 L))))
				((RETURN (SETQ P (CONS E PP))))))
		      (COND ((< (CAR P) (CAR Q))
			     (RETURN (COND (FLAG (DPSIMP (NREVERSE L)));GET EXP?
					   (P))))
			    ((GO A))))
		     (T (SETQ LP (CDR LP))
			(GO B)))))

(DEFUN STRIP-ZEROES (L)
       (DO ((L L (CDR L)))
	   ((NULL (CZEROP (CAR L))) L)))

(DEFUN CPRES1 (A B)
	(PROG (RES V A3) (DECLARE (FIXNUM V))
		(SETQ V 0 A (DPREP A) B (DPREP B))
		(SETQ RES 1)
	  AGAIN (SETQ A3 (DPMODREM A B))
		(SETQ V (BOOLE 6 V (BOOLE 1 1 (CAR A) (CAR B) )))
		(SETQ RES (CTIMES RES (CEXPT (CADR B)
					     (- (CAR A) (CAR A3)))))
		(COND ((= 0 (CAR A3))
		       (SETQ RES (CTIMES RES (CEXPT (CADR A3) (CAR B))))
		       (RETURN (COND ((ODDP V) (CMINUS RES))
				     (T RES))) ))
		(SETQ A B)
		(SETQ B A3)
		(GO AGAIN) ))

