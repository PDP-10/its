;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module csimp)

(declare (special rsn* $factlim $exponentialize 
		  var varlist genvar $%emode $ratprint 
		  nn* dn* $errexp sqrt3//2 sqrt2//2 -sqrt2//2 -sqrt3//2
		  $demoivre errorsw islinp $keepfloat $ratfac)
	 (*lexpr $ratcoef)
	 (genprefix %))

(load-macsyma-macros rzmac)

(setq $demoivre nil rsn* nil $nointegrate nil $lhospitallim 4 
      $tlimswitch nil $limsubst nil $abconvtest nil
      complex-limit nil plogabs nil $intanalysis t)

(defmvar %p%i '((mtimes) $%i $%pi))
(defmvar fourth%pi '((mtimes) ((rat simp) 1 4) $%pi))
(defmvar half%pi '((mtimes) ((rat simp) 1 2) $%pi))
(defmvar %pi2 '((mtimes) 2 $%pi)) 
(defmvar half%pi3 '((mtimes) ((rat simp) 3 2) $%pi)) 
(defmvar $sumsplitfact t)    ;= nil minfactorial is applied after a factocomb.
(defmvar $gammalim 1000000.)

(MAP2C '(LAMBDA (A B) (PUTPROP A B '$INVERSE) (PUTPROP B A '$INVERSE))
       '(/%SIN /%ASIN /%COS /%ACOS /%TAN /%ATAN
	 /%COT /%ACOT /%SEC /%ASEC /%CSC /%ACSC
	 /%SINH /%ASINH /%COSH /%ACOSH /%TANH /%ATANH
	 /%COTH /%ACOTH /%SECH /%ASECH /%CSCH /%ACSCH))

(defmfun $demoivre (exp)
 (let ($exponentialize nexp)
      (cond ((atom exp) exp)
	    ((and (eq (caar exp) 'mexpt) (eq (cadr exp) '$%e)
		  (setq nexp (demoivre (caddr exp))))
	     nexp)
	    (t (recur-apply #'$demoivre exp)))))

(defun demoivre (l) 
       (cond ($exponentialize
	      (merror "Demoivre and Exponentialize may not both be true"))
	     (t (setq l (islinear l '$%i))
		(and l (not (equal (car l) 0))
		     (m* (m^ '$%e (cdr l))
			 (m+ (list '(%cos) (car l))
			     (m* '$%i (list '(%sin) (car l))))))))) 

(defun islinear (exp var1) 
       ;;;If exp is of the form a*var1+b where a is freeof var1
       ;;; then (a . b) is returned else nil
       ((lambda (a) (cond ((freeof var1 a)
			   (cons a (substitute 0 var1 exp)))))
	((lambda (islinp) (sdiff exp var1)) t)))

(DEFMFUN $partition (e var1)
  (prog (k)
	(setq e (mratcheck e) var1 (getopr var1))
	(cond (($listp e)
	       (return (do ((l (cdr e) (cdr l)) (l1) (l2) (x))
			   ((null l) (list '(mlist simp)
					   (cons '(mlist simp) (nreverse l1))
					   (cons '(mlist simp) (nreverse l2))))
			   (setq x (mratcheck (car l)))
			   (cond ((free x var1) (setq l1 (cons x l1)))
				 (t (setq l2 (cons x l2)))))))
	      ((mplusp e) (setq e (cons '(mtimes) (cdr e)) k 0))
	      ((mtimesp e) (setq k 1))
	      (t
	       (merror "~M is an incorrect arg to PARTITION" e)))
	(setq e (partition e var1 k))
	(return (list '(mlist simp) (car e) (cdr e)))))

(defun partition (exp var1 k)  ; k is 1 for MTIMES and 0 for MPLUS.
       (prog (const varbl op)
	     (setq op (cond ((= k 0) '(mplus)) (t '(mtimes))))
	     (cond ((or (alike1 exp var1) (not (eq (caar exp) 'mtimes)))
		    (return (cons k exp))))
	     (setq exp (cdr exp))
	loop (cond ((free (car exp) var1) (setq const (cons (car exp) const)))
		   (t (setq varbl (cons (car exp) varbl))))
	     (cond ((null (setq exp (cdr exp)))
		    (return (cons (cond ((null const) k)
					((null (cdr const)) (car const))
					(t (simplifya (cons op (nreverse const)) t)))
				  (cond ((null varbl) k)
					((null (cdr varbl)) (car varbl))
					(t (simplifya (cons op (nreverse varbl)) t)))))))
	     (go loop)))

;To use this INTEGERINFO and *ASK* need to be special.
;(defun integerpw (x) 
; ((lambda (*ask*) 
;    (integerp10 (ssimplifya (sublis '((z** . 0) (*z* . 0)) x)))) 
;  t))

;(defun integerp10 (x) 
; ((lambda (d) 
;   (cond ((or (null x) (not (free x '$%i))) nil)
;	 ((mnump x) (fixp x))
;	 ((setq d (assolike x integerinfo)) (eq d 'yes))
;	 (*ask* (setq d (cond ((integerp x) 'yes) (t (needinfo x))))
;		(setq integerinfo (cons (list x d) integerinfo))
;		(eq d 'yes))))
; nil))

(setq var (maknam (explode 'foo))) 

(defun numden (e)
 (prog (varlist) 
	   (setq varlist (list var))
	   (newvar (setq e (fmt e)))
	   (setq e (cdr (ratrep* e)))
	   (setq dn*
		 (simplifya (pdis (ratdenominator e))
			    nil))
	   (setq nn*
		 (simplifya (pdis (ratnumerator e))
			    nil))))

(defun fmt (exp) 
  (let (nn*) 
    (cond ((atom exp) exp)
	  ((mnump exp) exp)
	  ((eq (caar exp) 'mexpt)
	   (cond ((and (mnump (caddr exp))
		       (eq ($sign (caddr exp)) '$neg))
		  (list '(mquotient)
			1
			(cond ((equal (caddr exp) -1)
			       (fmt (cadr exp)))
			      (t (list (list (caar exp))
				       (fmt (cadr exp))
				       (timesk -1 (caddr exp)))))))
		 ((atom (caddr exp))
		  (list (list (caar exp))
			(fmt (cadr exp))
			(caddr exp)))
		 ((and (mtimesp (setq nn* (sratsimp (caddr exp))))
		       (mnump (cadr nn*))
		       (equal ($sign (cadr nn*)) '$neg))
		  (list '(mquotient)
			1
			(list (list (caar exp))
			      (fmt (cadr exp))
			      (cond ((equal (cadr nn*) -1)
				     (cons '(mtimes)
					   (cddr nn*)))
				    (t (neg nn*))))))
		 ((eq (caar nn*) 'mplus)
		  (fmt (spexp (cdr nn*) (cadr exp))))
		 (t (cons (ncons (caar exp))
			  (mapcar #'fmt (cdr exp))))))
	  (t (cons (delsimp (car exp)) (mapcar #'fmt (cdr exp)))))))

(defun spexp (expl dn*) 
	 (cons '(mtimes) (mapcar #'(lambda (e) (list '(mexpt) dn* e)) expl)))

(defun subin (y x) (cond ((not (among var x)) x) (t (substitute y var x))))

(DEFMFUN $rhs (eq)
       (cond ((or (atom eq) (not (eq (caar eq) 'mequal))) 0) (t (caddr eq))))

(DEFMFUN $lhs (eq)
       (cond ((or (atom eq) (not (eq (caar eq) 'mequal))) eq) (t (cadr eq))))

(defun ratgreaterp (x y)
       (cond ((and (mnump x) (mnump y))
	      (great x y))
	     ((equal ($asksign (m- x y)) '$pos))))



(defun %especial (e) 
  (prog (varlist y k j ans $%emode $ratprint genvar)
	((lambda ($float $keepfloat) 
	  (cond ((not (setq y (pip ($ratcoef e '$%i)))) (return nil)))
	  (setq j (trigred y))
	  (setq k ($expand (m+ e (m* -1 '$%pi '$%i y)) 1))
	  (setq ans (spang1 j t))) nil nil)
	(cond ((among '%sin ans)
	       (cond ((equal y j) (return nil))
		     ((equal k 0)
		      (return (list '(mexpt simp)
				    '$%e
				    (m* %p%i j))))
		     (t (return (list '(mexpt simp)
				      '$%e
				      (m+ k (m* %p%i j))))))))
	(setq y (spang1 j nil))
	(return (mul2 (m^ '$%e k) (m+ y (m* '$%i ans))))))

(defun trigred (r) 
       (prog (m n eo flag) 
	     (cond ((numberp r) (return (cond ((even r) 0) (t 1)))))
	     (setq m (cadr r))
	     (cond ((minusp m) (setq m (minus m)) (setq flag t)))
	     (setq n (caddr r))
	loop (cond ((greaterp m n)
		    (setq m (difference m n))
		    (setq eo (not eo))
		    (go loop)))
	     (setq m (list '(rat)
			   (cond (flag (minus m)) (t m))
			   n))
	     (return (cond (eo (addk m (cond (flag 1) (t -1))))
			   (t m))))) 

(defun polyinx (exp x ind) 
  (prog (genvar varlist var $ratfac) 
	(setq var x)
	(cond ((numberp exp)(return t))
	      ((polyp exp)
	       (cond (ind (go on))
		     (t (return t))))
	      (t (return nil)))
   on	(setq genvar nil)
	(setq varlist (list x))
	(newvar exp)
	(setq exp (cdr (ratrep* exp)))
	(cond
	 ((or (numberp (cdr exp))
	      (not (eq (car (last genvar)) (cadr exp))))
	  (setq x (pdis (cdr exp)))
	  (return (cond ((eq ind 'leadcoef)
			 (div* (pdis (caddr (car exp))) x))
			(t (setq exp (car exp))
			     (div* (cond ((atom exp) exp)
					 (t
					  (pdis (list (car exp)
						      (cadr exp)
						      (caddr exp)))))
				   x))
			))))))

(defun polyp (a)
  (cond ((atom a) t)
	((memq (caar a) '(mplus mtimes))
	 (andmapc (function polyp) (cdr a)))
	((eq (caar a) 'mexpt)
	 (cond ((free (cadr a) var)
		(free (caddr a) var))
	       (t (and (fixp (caddr a))
		       (greaterp (caddr a) 0)
		       (polyp (cadr a))))))
	(t (andmapcar #'(lambda (subexp)
			  (free subexp var))
		      (cdr a)))))

(defun pip (e)
  (prog (varlist d c) 
	(newvar e)
	(cond ((not (memq '$%pi varlist)) (return nil)))
	(setq varlist '($%pi))
	(newvar e)
	(setq e (cdr (ratrep* e)))
	(setq d (cdr e))
	(cond ((not (atom d)) (return nil))
	      ((equal e '(0 . 1))
	       (setq c 0)
	       (go loop)))
	(setq c (pterm (cdar e) 1))
   loop (cond ((atom c)
	       (cond ((equal c 0) (return nil))
		     ((equal 1 d) (return c))
		     (t (return (list '(rat) c d))))))
   (setq c (pterm (cdr c) 0))
   (go loop)))

(defun spang1 (j ind) 
       (prog (ang ep $exponentialize $float $keepfloat) 
	     (cond ((floatp j) (setq j (rationalize j))
			       (setq j (list '(rat simp) (car j) (cdr j)))))
	     (setq ang j)
	     (cond
	      (ind nil)
	      ((numberp j)
	       (cond ((zerop j) (return 1)) (t (return -1))))
	      (t (setq j
		       (trigred (add2* '((rat simp) 1 2)
				       (list (car j)
					     (minus (cadr j))
					     (caddr j)))))))
	     (cond ((numberp j) (return 0))
		   ((mnump j) (setq j (cdr j))))
	     (return
	      (cond ((equal j '(1 2)) 1)
		    ((equal j '(-1 2)) -1)
		    ((or (equal j '(1 3))
			 (equal j '(2 3)))
		     sqrt3//2)
		    ((or (equal j '(-1 3))
			 (equal j '(-2 3)))
		     -sqrt3//2)
		    ((or (equal j '(1 6))
			 (equal j '(5 6)))
		     '((rat) 1 2))
		    ((or (equal j '(-1 6))
			 (equal j '(-5 6)))
		     '((rat) -1 2))
		    ((or (equal j '(1 4))
			 (equal j '(3 4)))
		     sqrt2//2)
		    ((or (equal j '(-1 4))
			 (equal j '(-3 4)))
		     -sqrt2//2)
		    (t (cond ((mnegp ang)
			      (setq ang (timesk -1 ang) ep t)))
		       (setq ang (list '(mtimes simp)
				       ang
				       '$%pi))
		       (cond (ind (cond (ep (list '(mtimes simp)
						  -1
						  (list '(%sin simp)
							ang)))
					(t (list '(%sin simp)
						 ang))))
			     (t (list '(%cos simp) ang)))))))) 

;(defun scsign (e) 
;       ((lambda (varlist genvar $ratprint) 
;	 (setq *sign* nil)
;	 (setq e (ratf e))
;	 (setq *pform*
;	       (simplifya (rdis (cond ((pminusp (cadr e))
;				       (setq *sign* t)
;				       (cons (pminus (cadr e))
;					     (cddr e)))
;				      (t (cdr e))))
;			  nil)))
;	nil nil nil)) 

(defun archk (a b v) 
     (simplify
       (cond ((and (equal a 1) (equal b 1)) v)
	     ((and (equal b -1) (equal 1 a))
	      (list '(mtimes) -1 v))
	     ((equal 1 b)
	      (list '(mplus) '$%pi (list '(mtimes) -1 v)))
	     (t (list '(mplus) v (list '(mtimes) -1 '$%pi))))))

(defun genfind (h var)
;;; finds gensym coresponding to var h
       (do ((varl (caddr h) (cdr varl))
	    (genl (cadddr h) (cdr genl)))
;;;is car of rat form
	   ((eq (car varl) var) (car genl))))
