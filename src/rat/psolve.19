;; -*- Mode: Lisp; Package: Macsyma -*-
;; ** (c) Copyright 1980 Massachusetts Institute of Technology **

(macsyma-module psolve)

(DECLARE (GENPREFIX PSO)
	 (SPECIAL MULT *ROOTS *FAILURES $SOLVEFACTORS))

(DECLARE (SPLITFILE SCUBIC))

(DEFMVAR FLAG4 NIL)

(DEFMFUN SOLVECUBIC (X) 
       (PROG (S1 A0 A1 A2 DISCR LCOEF ADIV3 OMEGA^2 PDIV3 QDIV-2
	      OMEGA Y1 U y2) 
	     (SETQ X (CDR X))
	     (SETQ LCOEF (CADR X))
	     (SETQ ADIV3
		   (LIST '(MTIMES)
			 '((RAT) -1. 3.)
			 (RDIS (SETQ A2 (RATREDUCE (PTERM X 2.)
						   LCOEF)))))
	     (SETQ A1 (RATREDUCE (PTERM X 1.) LCOEF))
	     (SETQ A0 (RATREDUCE (PTERM X 0.) LCOEF))
	     (SETQ S1 '((MTIMES)
			((RAT) 1. 2.)
			$%I
			((MEXPT) 3. ((RAT) 1. 2.))))
	     (SETQ OMEGA (LIST '(MPLUS)
			       '((RAT) -1. 2.)
			       S1) 
		   OMEGA^2 (LIST '(MPLUS)
				 '((RAT) -1. 2.)
				 (LIST '(MTIMES) -1. S1)))
	     (SETQ PDIV3
		   (RDIS (RATPLUS (RATTIMES A1 '(1. . 3.) T)
				  (RATTIMES (RATEXPT A2 2.)
					    '(-1. . 9.)
					    T))))
	     (AND (NOT (EQUAL PDIV3 0.)) (GO HARDER))
	     (SETQ 
	      Y1
	      (SIMPTIMES
	       (LIST
		'(MTIMES)
		'((RAT) 1. 3.)
		(LIST '(MPLUS)
		       (SIMPNRT (RDIS (setq y2 (RATPLUS (RATEXPT A2 3.)
						       (RATTIMES '(-27. . 1.)
								 A0
								 T))))
				3)
		      (LIST '(MTIMES) -1. (RDIS A2))))
	       1.
	       NIL))
	     (AND FLAG4 (RETURN (SOLVE3 Y1 MULT)))
	     (setq y2 (simpnrt (rdis (rattimes  y2 '(1. . 27.) t))
			       3))
	     (RETURN (MAPC #'(LAMBDA (J) (SOLVE3 J MULT))
			   (LIST Y1
				 (LIST '(MPLUS)
				       (LIST '(MTIMES)
					     OMEGA
					     Y2)
				       ADIV3)
				 (LIST '(MPLUS)
				       (LIST '(MTIMES)
					     OMEGA^2
					     Y2)
				       ADIV3))))
	HARDER
	     (SETQ 
	      QDIV-2
	      (RDIS (RATPLUS (RATTIMES (RATPLUS (RATTIMES A1 A2 T)
						(RATTIMES '(-3. . 1.)
							  A0
							  T))
				       '(1. . 6.)
				       T)
			     (RATTIMES (RATEXPT A2 3.)
				       '(-1. . 27.)
				       T))))
	     (COND ((EQUAL QDIV-2 0.)
		    (SETQ U (SIMPNRT PDIV3 2))
		    (SETQ Y1 ADIV3))
		   (T (SETQ DISCR (SIMPLUS (LIST '(MPLUS)
						 (LIST '(MEXPT)
						       PDIV3
						       3.)
						 (LIST '(MEXPT)
						       QDIV-2
						       2.))
					   1.
					   NIL))
		      (COND ((EQUAL DISCR 0.)
			     (SETQ U (SIMPNRT QDIV-2 3)))
			    (T (SETQ DISCR (SIMPNRT DISCR 2))
			       (AND (COMPLICATED DISCR)
				    (SETQ DISCR (adispline DISCR)))
			       (SETQ U (SIMPEXPT (LIST '(MEXPT)
					     (LIST '(MPLUS)
						   QDIV-2
						   DISCR)
					     '((RAT) 1 3)) 1 NIL))
			       (AND (COMPLICATED U)
				    (SETQ U (adispline U)))))))
	     (OR Y1
		 (SETQ Y1 (SIMPLUS (LIST '(MPLUS)
					 ADIV3
					 U
					 (LIST '(MTIMES)
					       -1.
					       PDIV3
					       (LIST '(MEXPT)
						     U
						     -1.)))
				   1.
				   NIL)))
	     (RETURN
	      (COND (FLAG4 (SOLVE3 Y1 MULT))
		    (T (MAPC 
			#'(LAMBDA (J) (SOLVE3 J MULT))
			(LIST Y1
			      (LIST '(MPLUS)
				    ADIV3
				    (LIST '(MTIMES) OMEGA U)
				    (LIST '(MTIMES)
					  -1.
					  PDIV3
					  OMEGA^2
					  (LIST '(MEXPT)
						U
						-1.)))
			      (LIST '(MPLUS)
				    ADIV3
				    (LIST '(MTIMES) OMEGA^2 U)
				    (LIST '(MTIMES)
					  -1.
					  PDIV3
					  OMEGA
					  (LIST '(MEXPT)
						U
						-1.))))))))))

(DECLARE (SPLITFILE SQUART))

(DEFMFUN SOLVEQUARTIC (X) 
       (PROG (A0 A1 A2 B1 B2 B3 B0 LCOEF Z1 R TR1 TR2 D D1 E SQB3) 
	     (SETQ X (CDR X) LCOEF (CADR X))
	     (SETQ B3 (RATREDUCE (PTERM X 3.) LCOEF))
	     (SETQ B2 (RATREDUCE (PTERM X 2.) LCOEF))
	     (SETQ B1 (RATREDUCE (PTERM X 1.) LCOEF))
	     (SETQ B0 (RATREDUCE (PTERM X 0.) LCOEF))
	     (SETQ A2 (RATMINUS B2))
	     (SETQ A1 (RATDIF (RATTIMES B1 B3 T)
			      (SETQ A0 (RATTIMES B0
						 '(4. . 1.)
						 T))))
	     (SETQ A0
		   (RATDIF (RATDIF (RATTIMES B2 A0 T)
				   (RATTIMES (SETQ SQB3
						   (RATEXPT B3 2.))
					     B0
					     T))
			   (RATEXPT B1 2.)))
	     (SETQ 
	      TR2
	      (SIMPLIFY (RDIS
	       (RATTIMES
		'(1. . 4.)
		(RATDIF (RATDIF (RATTIMES B3
					  (RATTIMES B2
						    '(4. . 1.)
						    T)
					  T)
				(RATTIMES '(8. . 1.) B1 T))
			(RATTIMES SQB3 B3 NIL))
		T))))
	     (SETQ Z1 (RESOLVENT A2 A1 A0))
	     (SETQ R
		   (SIMPLUS (LIST '(MPLUS)
				  Z1
				  (RDIS (RATDIF (RATTIMES SQB3
							  '(1. . 4.)
							  T)
						B2)))
			    1.
			    NIL))
	     (AND (EQUAL R 0.) (GO L0))
	     (SETQ R (SIMPNRT R 2))
	     (AND (COMPLICATED R) (SETQ R (adispline R)))
	     (AND (COMPLICATED TR2) (SETQ TR2 (adispline TR2)))
	     (SETQ TR1
		   (SIMPLUS (LIST '(MPLUS)
				  (RDIS (RATDIF (RATTIMES SQB3
							  '(1. . 2.)
							  T)
						B2))
				  (LIST '(MTIMES) -1. Z1))
			    1.
			    NIL))
	     (AND (COMPLICATED TR1) (SETQ TR1 (adispline TR1)))
	     (SETQ TR2 (DIV* TR2 R))
	     (GO LB1)
	L0   (SETQ D1
		   (SIMPNRT (SIMPLIFY (LIST '(MPLUS)
				  (LIST '(MEXPT) Z1 2.)
				  (LIST '(MTIMES)
					-4.
					(RDIS B0))))
			    2))
	     (SETQ TR2 (SIMPLIFY (LIST '(MTIMES) 2. D1)))
	     (AND (COMPLICATED TR2) (SETQ TR2 (adispline TR2)))
	     (SETQ TR1
		   (SIMPLIFY (RDIS (RATDIF (RATTIMES SQB3 '(3. . 4.) T)
				 (RATTIMES B2 '(2. . 1.) T)))))
	     (AND (COMPLICATED TR1) (SETQ TR1 (adispline TR1)))
	LB1  (SETQ D (SIMPNRT (SIMPLIFY (LIST '(MPLUS) TR1 TR2)) 2))
	     (SETQ E
		   (SIMPNRT (SIMPLIFY (LIST '(MPLUS)
				  TR1
				  (LIST '(MTIMES) -1. TR2)))
			    2))
	     (SETQ D (DIV* D 2.))
	     (AND (COMPLICATED D) (SETQ D (adispline D)))
	     (SETQ E (DIV* E 2.))
	     (AND (COMPLICATED E) (SETQ E (adispline E)))
	     (SETQ A2 (RDIS (RATTIMES B3 '(-1. . 4.) T)))
	     (SETQ A1 (DIV* R 2.))
	     (SETQ Z1
		   (LIST (LIST '(MPLUS) A2 A1 D)
			 (LIST '(MPLUS)
			       A2
			       A1
			       (LIST '(MTIMES) -1. D))
			 (LIST '(MPLUS)
			       A2
			       (LIST '(MTIMES) -1. A1)
			       E)
			 (LIST '(MPLUS)
			       A2
			       (LIST '(MTIMES) -1. A1)
			       (LIST '(MTIMES) -1. E))))
	     (RETURN (MAPC #'(LAMBDA (J) (SOLVE3 J MULT))
			   Z1))))

;;; SOLVES RESOLVENT CUBIC EQUATION
;;; GENERATED FROM QUARTIC

(DEFUN RESOLVENT (A2 A1 A0) 
       (PROG (*ROOTS FLAG4 *FAILURES $solvefactors)	;undoes binding in
	     (SETQ FLAG4 T $solvefactors t)		;algsys
	     (SOLVE (SIMPLUS (LIST '(MPLUS)
				   (LIST '(MEXPT)
					 'YY
					 3.)
				   (LIST '(MTIMES)
					 (RDIS A2)
					 (LIST '(MEXPT)
					       'YY
					       2.))
				   (LIST '(MTIMES)
					 (RDIS A1)
					 'YY)
				   (RDIS A0))
			     1.
			     NIL)
		    'YY
		    1.)
	     (COND ((MEMBER 0. *ROOTS) (RETURN 0.)))
	     (RETURN (CADDAR (CDR (REVERSE *ROOTS))))))

(DECLARE (UNSPECIAL MULT))
