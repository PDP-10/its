;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module specfn)

   ;*********************************************************************
   ;****************                                   ******************
   ;**************** Macsyma Special Function Routines ******************
   ;****************                                   ******************
   ;*********************************************************************

(load-macsyma-macros rzmac)
(load-macsyma-macros mhayat)

(defmacro mnumericalp (arg)
	  `(or (floatp ,arg) (and (or $numer $float) (fixp ,arg))))

		(comment Subtitle Polylogarithm Routines)

(declare (splitfile plylog))

(declare (special $zerobern ivars key-vars tlist)
	 (notype (li2numer flonum) (li3numer flonum)))

(defun lisimp (exp vestigial z)
       vestigial ;; Ignored
       (let ((s (simpcheck (car (subfunsubs exp)) z))
	     ($zerobern t)
	     (a))
	    (subargcheck exp 1 1 '$li)
	    (setq a (simpcheck (car (subfunargs exp)) z))
	    (or (cond ((zerop1 a) 0)
		      ((not (fixp s)) ())
		      ((= s 1) (m- `((%log) ,(m- 1 a))))
		      ((and (fixp a) (> s 1)
			    (cond ((= a 1) ($zeta s))
				  ((= a -1)
				   (m*t (m1- `((rat) 1 ,(expt 2 (- s 1))))
					($zeta s))))))
		      ((= s 2) (li2simp a))
		      ((= s 3) (li3simp a)))
		(eqtest (subfunmakes '$li (ncons s) (ncons a))
			exp))))

(defun li2simp (arg)
       (cond ((mnumericalp arg) (li2numer (float arg)))
	     ((alike1 arg '((rat) 1 2))
	      (m+t (m// ($zeta 2) 2)
		   (m*t '((rat simp) -1 2)
			(m^ '((%log) 2) 2))))))

(defun li3simp (arg)
       (cond ((mnumericalp arg) (li3numer (float arg)))
	     ((alike1 arg '((rat) 1 2))
	      (m+t (m* '((rat simp) 7 8) '(($zeta) 3))
		   (m*t (m// ($zeta 2) -2) (simplify '((%log) 2)))
		   (m*t '((rat simp) 1 6) (m^ '((%log) 2) 3))))))


(declare (flonum x))

;; Numerical evaluation for Chebyschev expansions of the first kind

(defun cheby (x chebarr)
       (declare (flonum x))
       (let ((Bn+2 0.0) (Bn+1 0.0))
	    (declare (flonum Bn+1 Bn+2))
	    (do ((i (fix (arraycall flonum chebarr 0)) (1- i)))
		((< i 1) (-$ Bn+1 (*$ Bn+2 x)))
		(setq Bn+2
		      (prog1 Bn+1 (setq Bn+1
					(+$ (arraycall flonum chebarr i)
					    (-$ (*$ 2.0 x Bn+1)
						Bn+2))))))))

(defun cheby/' (x chebarr)
       (declare (flonum x))
       (-$ (cheby x chebarr) (*$ (arraycall flonum chebarr 1) .5)))

;; These should really be calculated with minimax rational approximations.
;; Someone has done LI[2] already, and this should be updated; I haven't
;; seen any results for LI[3] yet.

(defun li2numer (x)
       (cond ((= x 0.0) 0.0)
	     ((= x 1.0) 1.64493407)
	     ((= x -1.0) -.822467033)
	     ((< x -1.0) 
	      (-$ (+$ (chebyli2 (//$ x)) 1.64493407
		      (//$ (expt (log (-$ x)) 2) 2.0))))
	     ((not (> x .5)) (chebyli2 x))
	     ((< x 1.0)
	      (-$ 1.64493407 (*$ (log x) (log (-$ 1.0 x)))
		  (chebyli2 (-$ 1.0 x))))
	     (t (m+t (-$ 3.28986813 (//$ (expt (log x) 2) 2.0)
			 (li2numer (//$ x)))
		     (m*t (-$ (*$ 3.14159265 (log x))) '$%i)))))

(defun li3numer (x)
       (cond ((= x 0.0) 0.0)
	     ((= x 1.0) 1.20205690)
	     ((< x -1.0)
	      (-$ (chebyli3 (//$ x)) (*$ 1.64493407 (log (-$ x)))
		  (//$ (expt (log (-$ x)) 3) 6.0)))
	     ((not (> x .5)) (chebyli3 x))
	     ((not (> x 2.0))
	      (let ((fac (*$ (expt (log x) 2) .5))) 
		   (m+t (+$ 1.20205690 
			    (-$ (*$ (log x)
				    (-$ 1.64493407 (chebyli2 (-$ 1.0 x))))
				(chebyS12 (-$ 1.0 x))
				(*$ fac
				    (log (cond ((< x 1.0) (-$ 1.0 x))
					       ((1-$ x)))))))
			(cond ((< x 1.0) 0)
			      ((m*t (*$ fac -3.14159265) '$%i))))))
	     (t (m+t (+$ (chebyli3 (//$ x)) (*$ 3.28986813 (log x))
			 (//$ (expt (log x) 3) -6.0))
		     (m*t (*$ -1.57079633 (expt (log x) 2)) '$%i)))))

(array li2 flonum 15.)

(fillarray 'li2 
	   '(14.0       1.93506430 .166073033 2.48793229e-2 4.68636196e-3
	     1.0016275e-3 2.32002196e-4 5.68178227e-5 1.44963006e-5
	     3.81632946e-6 1.02990426e-6 2.83575385e-7 7.9387055e-8
	     2.2536705e-8 6.474338e-9))

(array li3 flonum 15.)

(fillarray 'li3
	   '(14.0       1.95841721 8.51881315e-2 8.55985222e-3 1.21177214e-3
	     2.07227685e-4 3.99695869e-5 8.38064066e-6 1.86848945e-6
	     4.36660867e-7 1.05917334e-7 2.6478920e-8 6.787e-9 
	     1.776536e-9 4.73417e-10))

(array S12 flonum 18.)

(fillarray 'S12
	   '(17.0      1.90361778 .431311318 .100022507 2.44241560e-2
	     6.22512464e-3 1.64078831e-3 4.44079203e-4 1.22774942e-4
	     3.45398128e-5 9.85869565e-6 2.84856995e-6 8.31708473e-7
	     2.45039499e-7 7.2764962e-8 2.1758023e-8 6.546158e-9
	     1.980328e-9))

(defun chebyli2 (x)
       (*$ x (cheby/' (//$ (1+$ (*$ x 4.0)) 3.0)
		      #-Franz '#,(get 'li2 'array)
		      #+Franz (getd 'li2))))

(defun chebyli3 (x)
       (*$ x (cheby/' (//$ (1+$ (*$ 4.0 x)) 3.0)
		      #-Franz '#,(get 'li3 'array)
		      #+Franz (getd 'li3))))

(defun chebyS12 (x)
       (*$ (//$ (expt x 2) 4.0) (cheby/' (//$ (1+$ (*$ 4.0 x)) 3.0)
					 #-Franz '#,(get 'S12 'array)
					 #+Franz (getd 'S12))))

(declare (notype x))

		(comment Subtitle Polygamma Routines)

(declare (splitfile plygam))

;; gross efficiency hack, exp is a function of *k*, *k* should be mbind'ed

(declare (special *k*))

(defun msum (exp lo hi)
       (if (< hi lo)
	   0
	   (let ((sum 0))
		(do ((*k* lo (1+ *k*)))
		    ((> *k* hi) sum)
		    (setq sum (add2 sum (meval exp)))))))

(declare (unspecial *k*) (special errorsw))

(defun pole-err (exp)
       (cond (errorsw (*throw 'errorsw t))
	     (t (merror "Pole encountered in: ~M" exp)
		)))


(declare (unspecial errorsw)
	 (special
	  $maxpsiposint $maxpsinegint $maxpsifracnum $maxpsifracdenom)
	 (fixnum 
	  $maxpsiposint $maxpsinegint $maxpsifracnum $maxpsifracdenom)
	 (*lexpr $diff))

(defprop $psi psisimp specsimp)

(mapcar (function (lambda (var val)
			  (and (not (boundp var)) (set var val))))
	'($maxpsiposint $maxpsinegint $maxpsifracnum $maxpsifracdenom)
	'(20. -10. 4 4))

(defun psisimp (exp a z)
       (let ((s (simpcheck (car (subfunsubs exp)) z)))
	    (subargcheck exp 1 1 '$psi)
	    (setq a (simpcheck (car (subfunargs exp)) z))
	    (and (fixp a) (< a 1) (pole-err exp))
	    (eqtest (psisimp1 s a) exp)))

;; This gets pretty hairy now.

(declare (special *k* $z))

(defun psisimp1 (s a)
 (let ((*k*))
      (or
       (and (not $numer) (not $float) (fixp s) (> s -1)
	(cond
	 ((fixp a)
	  (and (not (> a $maxpsiposint))    ; integer values
	       (m*t (expt -1 s) (factorial s)
		    (m- (msum (inv (m^t '*k* (1+ s))) 1 (1- a))
			(cond ((zerop s) '$%gamma)
			      (($zeta (1+ s))))))))
	 ((or (not (ratnump a)) (ratgreaterp a $maxpsiposint)) ())
	 ((ratgreaterp a 0)
	  (cond
	   ((ratgreaterp a 1)
	    (let* ((int ($entier a))    ; reduction to fractional values
		   (frac (m-t a int)))
		  (m+t
		   (psisimp1 s frac)
		   (if (> int $maxpsiposint)
		       (subfunmakes '$psi (ncons s) (ncons int))
		       (m*t (expt -1 s) (factorial s)
			    (msum (m^t (m+t (m-t a int) '*k*)
				       (1- (- s)))
				  0 (1- int)))))))
	   ((= s 0)
	    (let ((p (cadr a)) (q (caddr a)))
	     (cond
	      ((or (greaterp p $maxpsifracnum)
		   (greaterp q $maxpsifracdenom) (bigp p) (bigp q)) ())
	      ((and (= p 1)
		(cond ((= q 2)
		       (m+ (m* -2 '((%log) 2)) (m- '$%gamma)))
		      ((= q 3)                            
		       (m+ (m* '((rat simp) -1 2)
			       (m^t 3 '((rat simp) -1 2)) '$%pi)
			   (m* '((rat simp) -3 2) '((%log) 3))
			   (m- '$%gamma)))
		      ((= q 4)
		       (m+ (m* '((rat simp) -1 2) '$%pi)
			   (m* -3 '((%log) 2)) (m- '$%gamma))))))
	      ((and (= p 2) (= q 3))
	       (m+ (m* '((rat simp) 1 2)
		       (m^t 3 '((rat simp) -1 2)) '$%pi)
		   (m* '((rat simp) -3 2) '((%log) 3))
		   (m- '$%gamma)))
	      ((and (= p 3) (= q 4))
	       (m+ (m* '((rat simp) 1 2) '$%pi)
		   (m* -3 '((%log) 2)) (m- '$%gamma)))
	      ;; Gauss's Formula
	      ((let ((f (m* `((%cos) ,(m* 2 a '$%pi '*k*))
			    `((%log) ,(m-t 2 (m* 2 `((%cos) 
						     ,(m//t (m* 2 '$%pi '*k*)
							    q))))))))
		    (m+t (msum f 1 (1- (// q 2)))
			 (let ((*k* (// q 2)))
			      (m*t (meval f)
				   (cond ((oddp q) 1)
					 ('((rat simp) 1 2)))))
			 (m-t (m+ (m* '$%pi '((rat simp) 1 2)
				      `((%cot) ((mtimes simp) ,a $%pi)))
				  `((%log) ,q)
				  '$%gamma))))))))
	   ((alike1 a '((rat) 1 2))
	    (m*t (expt -1 (1+ s)) (factorial s)
		 (1- (expt 2 (1+ s))) (simplify ($zeta (1+ s)))))))
	 ((ratgreaterp a $maxpsinegint)  ;;; Reflection Formula
	  (m*t
	   (^ -1 s)
	   (m+t (m+t (psisimp1 s (m- a))
		     (let ((dif ($diff `((%cot) ,(m* '$%pi '$z)) '$z s))
			   ($z (m-t a)))
			  (meval dif)))
		(m*t (factorial s) (m^t (m-t a) (1- (- s)))))))))
       (subfunmakes '$psi (ncons s) (ncons a)))))

(declare (unspecial *k* $z))

		(comment Subtitle Polygamma Tayloring Routines)

;; These routines are specially coded to be as fast as possible given the
;; current $TAYLOR; too bad they have to be so ugly.

(declare (special var subl last sign last-exp))

(defun expgam-fun (pw temp)
       (setq temp (get-datum (get-key-var (car var))))
       (let-pw temp pw
	       (pstimes
		(let-pw temp (e1+ pw)
			(psexpt-fn (getexp-fun '(($PSI) -1) var (e1+ pw))))
		(make-ps var (ncons pw) '(((-1 . 1) 1 . 1))))))

(defun expplygam-funs (pw subl l) ; l is a irrelevant here
       (setq subl (car subl))
       (if (or (not (fixp subl)) (lessp subl -1))
	   (tay-err "Unable to expand at a subscript in")
	   (prog (e sign npw)
	    (declare (flonum npw) (fixnum e) #-Multics (fixnum sign))
	    (setq npw (//$ (float (car pw)) (float (cdr pw))))
	    (setq
	     l (cond ((= subl -1)
		      `(((1 . 1) . ,(prep1 '((mtimes) -1 $%gamma)))))
		     ((= subl 0)
		      (cons '((-1 . 1) -1 . 1)
			    (if (> 0.0 npw) ()
				`(((0 . 1)
				   . ,(prep1 '((mtimes) -1 $%gamma)))))))
		     (T (setq last (factorial subl))
			`(((,(- (1+ subl)) . 1)
			   ,(times (^ -1 (1+ subl))
				   (factorial subl)) . 1))))
	     e (if (< subl 1) (- subl) -1)
	     sign (if (< subl 1) -1 (^ -1 subl)))
	  a (setq e (1+ e) sign (- sign))
	    (if (greaterp e npw) (return l)
		(rplacd (last l)
			`(((,e . 1)
			   . ,(rctimes (rcplygam e)
				       (prep1 ($zeta (+ (1+ subl) e))))))))
	    (go a))))

(defun rcplygam (k)
       (declare (fixnum k) #-Multics (fixnum sign))
       (cond ((= subl -1) (cons sign k))
	     ((= subl 0) (cons sign 1))
	     (t (prog1 (cons (times sign last) 1)
		       (setq last
			     (*quo (times last (plus subl (add1 k)))
				   (add1 k)))))))

(defun plygam-ord (subl)
       (if (equal (car subl) -1) (ncons (rcone))
	   `((,(- (1+ (car subl))) . 1))))

(defun plygam-pole (a c func)
       (if (rcmintegerp c)
	   (let ((ps (get-lexp (m- a (rcdisrep c)) () t)))
		(rplacd (cddr ps) (cons `((0 . 1) . ,c) (cdddr ps)))
		(if (atom func) (gam-const a ps func)
		    (plygam-const a ps func)))
	   (prep1 (simplifya
		   (if (atom func) `((%GAMMA) ,(rcdisrep c))
		       `((MQAPPLY) ,func ,(rcdisrep c)))
		   () ))))

(defun gam-const (a arg func)
   (let ((const (ps-lc* arg)) (arg-c))
	(ifn (rcintegerp const)
	     (taylor2 (diff-expand `((%GAMMA) ,a) tlist))
	     (setq const (car const))
	     ;; Try to get the datum
	     (if (pscoefp arg)
		 (setq arg-c (get-lexp (m+t a (minus const)) (rcone)
				       (signp le const))))
	     (if (and arg-c (not (psp arg-c)))	; must be zero
		 (taylor2 (simplify `((%GAMMA) ,const)))
		 (let ((datum (get-datum (get-key-var
					  (gvar (or arg-c arg)))))
		       (ord (if arg-c (le (terms arg-c))
				(le (n-term (terms arg))))))
		    (setq func (current-trunc datum))
		    (if (greaterp const 0)
			(pstimes 
			 (let-pw datum (e- func ord)
				 (expand (m+t a (minus const)) '%GAMMA))
			 (let-pw datum (e+ func ord)
				 (tsprsum (m+t a (m-t '%%taylor-index%%))
					  `(%%taylor-index%% 1 ,const)
					  '%PRODUCT)))
			(pstimes 
			 (expand (m+t a (minus const)) '%GAMMA)
			 (let-pw datum (e+ func ord)
				 (psexpt 
				  (tsprsum (m+t a '%%taylor-index%%)
					   `(%%taylor-index%% 0
					       ,(minus (add1 const))) '%PRODUCT)
				  (rcmone))))))))))

(defun plygam-const (a arg func)
   (let ((const (ps-lc* arg)) (sub (cadr func)))
	(cond 
	 ((or (not (fixp sub)) (< sub -1))
	  (tay-err "Unable to expand at a subscript in"))
	 ((not (rcintegerp const))
	  (taylor2 (diff-expand `((MQAPPLY) ,func ,a) tlist)))
	 (T (setq const (car const))
	    (psplus
	     (expand (m+t a (- const)) func)
	     (if (> const 0)
		 (pstimes
		  (cons (times (^ -1 sub) (factorial sub)) 1)
		  (tsprsum `((MEXPT) ,(m+t a (m-t '%%taylor-index%%)) ,(- (1+ sub)))
			   `(%%taylor-index%% 1 ,const) '%SUM))
		 (pstimes
		  (cons (times (^ -1 (1+ sub)) (factorial sub)) 1)
		  (tsprsum `((MEXPT) ,(m+t a '%%taylor-index%%) ,(- (1+ sub)))
			   `(%%taylor-index%% 0 ,(- (1+ const))) '%SUM))))))))

(declare (unspecial var subl last sign last-exp))

;; Not done correctly
;;
;; (defun beta-trans (argl funname)
;;   funname ;ignored
;;   (let ((sum (m+t (car argl) (cadr argl))) (PSI[-1] '(($PSI ARRAY) -1)))
;;     (if (zerop sum) (unfam-sing-err)
;; 	(taylor2 `((MTIMES)
;; 		   ((MEXPT) $%E ((MPLUS) ((MQAPPLY) ,PSI[-1] ,(car argl))
;; 					 ((MQAPPLY) ,PSI[-1] ,(cadr argl))
;; 					 ((MTIMES) -1
;; 						   ((MQAPPLY) ,PSI[-1] ,sum))))
;; 		   ((MPLUS) ((MEXPT) ,(car argl) -1)
;; 			    ((MEXPT) ,(cadr argl) -1)))))))
