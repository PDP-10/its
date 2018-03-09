;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module asum)
(load-macsyma-macros rzmac)

(declare (special opers *a *n *times *a* *plus $factlim sum msump
		  $ratsimpexponsusum *i %a* $values
		  $props *opers-list opers-list
		  $ratsimpexpons makef)
	(*expr sum)
	(*lexpr $ratcoef $expand $rat $limit)
	(fixnum %n %a* %k %i %m $genindex)
	(genprefix sm))

(map2c '(lambda (x y) (putprop x y 'recip) (putprop y x 'recip))
	'(%cot %tan %csc %sin %sec %cos %coth %tanh %csch %sinh %sech %cosh))

(defun nill () '(nil))

(setq $zeta%pi t)

	(comment Polynomial predicates and other such things)

(defun zfree (e x)
    (cond ((equal e x) nil)
	  ((atom e) t)
	  ((eq (caar e) 'mrat)
	   (null (member x (cdr ($listofvars e)))))
	  ((do ((l (cdr e) (cdr l)))
	       ((null l) t)
	       (or (zfree (car l) x) (return nil))))))

(defun mfree (exp varl)
	(cond ((atom exp) (not (memq exp varl)))
	      ((eq (caar exp) 'MRAT)
	       (do ((l varl (cdr l))
		    (exp-varl (caddar exp)))
		   ((null l) 'T)
		   (and (memq (car l) exp-varl) (return () ))))
	      (t (and (mfree (caar exp) varl) (mfreel (cdr exp) varl)))))

(defun mfreel (l varl) (or (null l) (and (mfree (car l) varl) (mfreel (cdr l) varl))))

(defun poly? (exp var)
    (cond ((or (atom exp) (free exp var)))
	  ((memq (caar exp) '(mtimes mplus))
	   (do ((exp (cdr exp) (cdr exp)))
	       ((null exp) t)
	       (and (null (poly? (car exp) var))
		    (return nil))))
	  ((and (eq (caar exp) 'mexpt)
	 	(fixp (caddr exp))
		(> (caddr exp) 0))
	   (poly? (cadr exp) var))))

(defun smono (x var) (smonogen x var t))

(defun smonop (x var) (smonogen x var nil))

(defun smonogen (x var fl)	;fl indicates whether to return *a *n
    (cond ((free x var)
	   (and fl (setq *n 0 *a x))
	   t)
	  ((atom x)
	   (and fl (setq *n (setq *a 1)))
	   t)
	  ((eq (caar x) 'mtimes)
	   (do ((x (cdr x) (cdr x))
		(a '(1)) (n '(0)))
	       ((null x)
		(and fl (setq *n (simplus (cons '(mplus) n) 1 nil)
			      *a (simptimes (cons '(mtimes) a) 1 nil)))
		t)
	       ((lambda (*a *n)
		   (cond ((smonogen (car x) var fl)
			  (and fl (setq a (cons *a a) n (cons *n n))))
			 ((return nil))))
		nil nil)))
	  ((eq (caar x) 'mexpt)
	   (cond ((and (free (caddr x) var)
		       (eq (cadr x) var))
		  (and fl (setq *n (caddr x) *a 1))
		  t)))))


	(comment Factorial Stuff)

(setq $factlim -1 makef nil)

(DEFMFUN $genfact %n (cons '(%genfact) (listify %n)))

(defun gfact (n %m i)
  (cond ((minusp %m) (merror "~A Bad argument to GFACT" %m))
	((= %m 0) 1)
	(t (prog (ans)
		 (setq ans n)
	       a (cond ((= %m 1) (return ans)))
	         (setq n (m- n i)
		       %m (1- %m)
		       ans (m* ans n))
		 (go a)))))

(defun factorial (%i)
	(cond ((< %i 2) 1)
	      ((do ((x 1 (times %i x))
		    (%i %i (1- %i)))
		   ((= %i 1) x)))))

(defmfun simpfact (x y z)
	(oneargcheck x)
	(setq y (simpcheck (cadr x) z))
	(cond ((or (floatp y) (and (not makef) (ratnump y) (equal (caddr y) 2)))
	       (simplifya (makegamma1 (list '(mfactorial) y)) nil))
	      ((or (null (eq (typep y) 'fixnum)) (null (> y -1)))
	       (eqtest (list '(mfactorial) y) x))
	      ((or (minusp $factlim) (null (greaterp y $factlim)))
	       (factorial y))
	      (t (eqtest (list '(mfactorial) y) x))))

(defun makegamma1 (e)
    (cond ((atom e) e)
	  ((eq (caar e) 'mfactorial)
	   (list '(%gamma) (list '(mplus) 1 (makegamma1 (cadr e)))))
	  (t (recur-apply #'makegamma1 e))))

(defmfun simpgfact (x vestigial z)
       vestigial ;Ignored.
       (if (not (= (length x) 4)) (wna-err '$genfact))
       (setq z (mapcar #'(lambda (q) (simpcheck q z)) (cdr x)))
       (let ((a (car z))
	     (b ($entier (cadr z)))
	     (c (caddr z)))
	    (cond ((and (eq (typep b) 'fixnum) (> b -1))
		   (gfact a b c))
		  ((fixp b) (merror "Bad second argument to GENFACT: ~:M" b))
		  (t (eqtest (list '(%genfact) a
				   (cond ((and (null (atom b))
					       (eq (caar b) '$entier))
					  (cadr b))
					 (b))
				   c) x)))))

	(comment DEFTAYLOR)

(defmvar $cauchysum nil
	 "When multiplying together sums with INF as their upper limit, 
causes the Cauchy product to be used rather than the usual product.
In the Cauchy product the index of the inner summation is a function of 
the index of the outer one rather than varying independently."
	 modified-commands '$sum)

(defmvar $gensumnum 0
	 "The numeric suffix used to generate the next variable of
summation.  If it is set to FALSE then the index will consist only of
GENINDEX with no numeric suffix."
	 modified-commands '$sum
	 setting-predicate #'(lambda (x) (or (null x) (fixp x))))

(defmvar $genindex '$i
	 "The alphabetic prefix used to generate the next variable of
summation when necessary."
	 modified-commands '$sum
	 setting-predicate #'symbolp)

(defmvar $zerobern t)
(defmvar $simpsum nil)
(defmvar $sumhack nil)
(defmvar $prodhack nil)

(defvar *infsumsimp t)

;; These variables should be initialized where they belong.

(setq $wtlevel nil $cflength 1
      $weightlevels '((mlist)) *trunclist nil $taylordepth 3
      $maxtaydiff 4 $verbose nil $psexpand nil ps-bmt-disrep t
      silent-taylor-flag nil)

(DEFMSPEC $deftaylor (l) (SETQ l (CDR l))
  (prog (ll f s)
   a	(cond ((null l)
	       (return (cons '(mlist) ll))))
    (setq f (meval (car l))
	  s (meval (cadr l))
	  l (cddr l))
    (cond ((or (atom f)
	       (null (atom (cadr f)))
	       (and (get (caar f) 'op)
		    (not (eq (caar f) 'mfactorial)))
	       (eq (caar f) 'mqapply)
	       (not (= (length f) 2)))
	   (merror "Bad argument to DEFTAYLOR:~%~M" f))
	  ((get (caar f) 'sp2)
	   (mtell "~:M being redefined in DEFTAYLOR.~%"
		  (caar f))))
    (setq s (subsum '*index (subst 'sp2var (cadr f) s)))
    (putprop (caar f) s 'sp2)
    (add2lnc (caar f) $props)
    (setq ll (cons (caar f) ll))
    (go a)))

(defun subsum (*i e) (susum1 e))

(defun susum1 (e)
	(cond ((atom e) e)
	      ((eq (caar e) '%sum)
	       (cond ((null (smonop (cadr e) 'sp2var))
		      (merror "Argument to DEFTAYLOR must be power series at 0"))
		     ((subst *i (caddr e) e))))
	      ((cons (car e) (mapcar 'susum1 (cdr e))))))

	(comment SUM begins)

(defmacro sum-arg (sum) `(cadr ,sum))

(defmacro sum-index (sum) `(caddr ,sum))

(defmacro sum-lower (sum) `(cadddr ,sum))

(defmacro sum-upper (sum) `(cadr (cdddr ,sum)))

(DEFMSPEC $sum (l) (SETQ l (CDR l))
  (if (= (length l) 4)
      (dosum (car l) (cadr l) (meval (caddr l)) (meval (cadddr l)) t)
      (wna-err '$sum)))

(defmfun simpsum (x y z)
       (let (($ratsimpexpons t))
	     (setq y (simplifya (sum-arg x) z)))
       (simpsum1 y (sum-index x)
		 (simplifya (sum-lower x) z)
		 (simplifya (sum-upper x) z)))

(defun simpsum1 (exp i lo hi)
       (cond ((not (eq (typep i) 'symbol))
	      (merror "Bad index to SUM:~%~M" i))
	     ((equal lo hi)
	      (MBINDING ((list i) (list hi))
			(MEVAL EXP)))
	     ((and (atom exp) (not (eq exp i))
		   (getl '%sum '($outative $linear)))
	      (freesum exp lo hi 1))
	     ((null $simpsum)
	      (list (get '%sum 'msimpind) exp i lo hi))
	     (t (simpsum2 exp i lo hi))))

(DEFMFUN DOSUM (EXP IND LOW HI SUMP)
 (COND ((NOT (EQ (TYPEP IND) 'SYMBOL))
	(MERROR "Improper index to ~:M:~%~M" (IF SUMP '$SUM '$PRODUCT) IND)))
 (UNWIND-PROTECT 
  (PROG (U *I LIND L*I *HL)
	(COND ((COND (SUMP (NOT $SUMHACK)) (T (NOT $PRODHACK)))
	       (ASSUME (LIST '(MGEQP) IND LOW))
	       (COND ((NOT (EQ HI '$INF))
		      (ASSUME (LIST '(MGEQP) HI IND))))))
	(SETQ LIND (NCONS IND))
	(COND ((NOT (EQ (TYPEP (SETQ *HL (M- HI LOW))) 'FIXNUM))
	       (SETQ EXP (MEVALSUMARG EXP IND))
	       (RETURN (CONS (COND (SUMP '(%SUM)) (T '(%PRODUCT)))
			     (LIST EXP IND LOW HI))))
	      ((EQUAL *HL -1)
	       (RETURN (COND (SUMP 0) (1))))
	      ((SIGNP L *HL)
	       (COND ((AND SUMP $SUMHACK)
		      (RETURN
		       (M- (DOSUM EXP IND (M+ 1 HI) (M- LOW 1) T))))
		     ((AND (NOT SUMP) $PRODHACK)
		      (RETURN
		       (M// (DOSUM EXP IND (M+ 1 HI) (M- LOW 1) NIL)))))
	       (MERROR "Lower bound to ~:M: ~M~%is greater than the upper bound: ~M"
		       (IF SUMP '$SUM '$PRODUCT) LOW HI)))
	(SETQ *I LOW L*I (LIST *I) U (COND (SUMP 0) (T 1)))
    LO  (SETQ U (SIMPLIFYA
		 (LIST (COND (SUMP '(MPLUS)) (T '(MTIMES)))
		       (MBINDING (LIND L*I)
				 (MEVAL EXP)) 
		       U) T))
	(COND ((EQUAL *I HI) (RETURN U)))
	(SETQ *I (CAR (RPLACA L*I (M+ *I 1))))
	(GO LO))
  (COND ((COND (SUMP (NOT $SUMHACK)) (T (NOT $PRODHACK)))
	 (FORGET (LIST '(MGEQP) IND LOW))
	 (COND ((NOT (EQ HI '$INF)) (FORGET (LIST '(MGEQP) HI IND))))))))

(defmfun do%sum (l op)
    (cond ((not (= (length l) 4))
	   (merror "Wrong number of arguments to ~:M" op)))
    (let ((ind (cadr l)))
	 (cond ((mquotep ind) (setq ind (cadr ind))))
	 (cond ((not (eq (typep ind) 'symbol))
		(merror "Illegal index to ~:M:~%~M" op ind)))
	 (list (mevalsumarg (car l) ind)
	       ind (meval (caddr l)) (meval (cadddr l)))))

(defun mevalsumarg (exp ind)
  (let ((msump t) (lind (list ind)))
    (MBINDING (lind lind)
	      (ssimplifya (mevalatoms (cond ((and (not (atom exp))
						  (get (caar exp)
						       'mevalsumarg-macro))
					     (funcall (get (caar exp)
							   'mevalsumarg-macro)
						      exp))
					    (t exp)))))))


	(comment Multiplication of Sums)

(defun gensumindex nil
       (implode (nconc (exploden $genindex)
			(and $gensumnum
			     (mexploden (setq $gensumnum (1+ $gensumnum)))))))

(defun sumtimes (out x) (sumtmsin out x nil))

(defun sumtmsin (x y l)  ; l is a running list of the various indices.
	(cond ((null x) y)
	      ((null y) x)
	      ((or (signp e x) (signp e y)) 0)
	      ((or (atom x) (not (eq (caar x) '%sum))) (sumultin x y))
	      ((or (atom y) (not (eq (caar y) '%sum))) (sumultin y x))
	      (((lambda (i j)
		(setq l (cons i (cons j l)))
		(cond ((and $cauchysum (eq (sum-upper x) '$inf)
				       (eq (sum-upper y) '$inf))
		       (list '(%sum)
			(list '(%sum)
			 (sumtmsin (substitute j i (sum-arg x))
				   (substitute (m- i j) j (sum-arg y))
				   l)
			 j (sum-lower x) (m- i (sum-lower y)))
			i (m+ (sum-lower x) (sum-lower y)) '$inf))
		      ((list '(%sum)
			 (list '(%sum) (sumtmsin (sum-arg x) (sum-arg y) l)
				j (sum-lower y) (sum-upper y))
			 i (sum-lower x) (sum-upper x)))))
		((lambda (i) (setq x (subst i (sum-index x) x)) i)
		 (gensumindex))
		((lambda (j) (setq y (subst j (sum-index y) y)) j)
		 (gensumindex))))))

(defun sumultin (x s)  ; Multiplies x into a sum adjusting indices.
  (cond ((or (atom s) (not (eq (caar s) '%sum))) (m* x s))
	((free x (caddr s))
	 (list* (car s) (sumultin x (cadr s)) (cddr s)))
	(t (let ((ind (gensumindex)))
		(list* (car s)
		       (sumultin x (subst ind (caddr s) (cadr s)))
		       ind
		       (cdddr s))))))

(defun sumpls (out x)
  (prog (l)
	(if (null out) (return (ncons x)))
	(setq out (setq l (cons nil out)))
   a	(if (null (cdr out)) (return (cons x (cdr l))))
	(and (alike1 (cadadr out) (cadr x))
	     (alike1 (caddar (cdr out)) (caddr x))
	     (cond ((onediff (caddr (cddadr out)) (cadddr x))
		    (rplaca (cdr out)
			    (list (caadr out) (cadar (cdr out)) (caddar (cdr out))
				  (cadddr (cadr out)) (caddr (cddr x))))
		    (return (cdr l)))
		   ((onediff (caddr (cdadr out)) (caddr (cddr x)))
		    (rplaca (cdr out)
			    (list (caadr out) (cadadr out) (caddar (cdr out))
				  (cadddr x) (caddr (cddadr out)))))))
	(setq out (cdr out))
	(go a)))

(defun onediff (x y) (equal 1 (m- y x)))

(defun freesum (e b a q) (m* e q (m- (m+ a 1) b)))

	(comment Linear operator stuff)

(setq *opers-list '(($linear . linearize1))
      opers (list '$linear))

(defun oper-apply (e z)
       (cond ((null opers-list)
	      ((lambda (w)
		       (cond (w (funcall w e 1 z))
			     (t (simpargs e z))))
	       (get (caar e) 'operators)))
	     ((get (caar e) (caar opers-list))
	      (let ((opers-list (cdr opers-list))
		     (fun (cdar opers-list)))
		    (funcall fun e z)))
	     ((let ((opers-list (cdr opers-list)))
		    (oper-apply e z)))))

(defun linearize1 (e z)		;z = t means args already simped
       (linearize2
	(cons (car e) (mapcar #'(lambda (q) (simpcheck q z)) (cdr e)))
	nil))

(defun opident (op) (cond ((eq op 'mplus) 0) ((eq op 'mtimes) 1)))

(defun rem-const (e)	;removes constantp stuff
       (do ((l (cdr e) (cdr l))
	    (a (list (opident (caar e))))
	    (b (list (opident (caar e)))))
	   ((null l)
	    (cons (simplifya (cons (list (caar e)) a) nil)
		  (simplifya (cons (list (caar e)) b) nil)))
	   (cond ((or (mnump (car l)) (constant (car l)))
		  (setq a (cons (car l) a)))
		 ((setq b (cons (car l) b))))))

(defun linearize2 (e times)
       (cond ((linearconst e))
	     ((atom (cadr e)) (oper-apply e t))
	     ((eq (caar (cadr e)) 'mplus)
	      (addn (mapcar #'(lambda (q)
				      (linearize2 (list* (car e) q (cddr e)) nil))
			    (cdr (cadr e)))
		    t))
	     ((and (eq (caar (cadr e)) 'mtimes) (null times))
	      (let ((z (cond ((and (cddr e)
				    (or (atom (caddr e))
					($subvarp (caddr e))))
 			       (partition (cadr e) (caddr e) 1))
			      ((rem-const (cadr e)))))
		     (w))
		    (setq w (linearize2 (list* (car e)
					       (simplifya (cdr z) t)
					       (cddr e)) t))
		    (linearize3 w e (car z))))
	     ((oper-apply e t))))

(defun linearconst (e)
       (cond ((or (mnump (cadr e)) (constant (cadr e))
		  (and (cddr e) (or (atom (caddr e)) (memq 'array (cdar (caddr e))))
		       (free (cadr e) (caddr e))))
	      (cond ((or (zerop1 (cadr e))
			 (and (memq (caar e) '(%sum %integrate)) (= (length e) 5)
			      (or (eq (cadddr e) '$minf)
				  (memq (car (cddddr e)) '($inf $infinity)))
			      (eq ($asksign (cadr e)) '$zero)))
		     0)
		    (t (let ((w (oper-apply (list* (car e) 1 (cddr e)) t)))
			     (linearize3 w e (cadr e))))))))

(defun linearize3 (w e x)
  (let (w1)
       (cond ((and (memq w '($inf $minf $infinity)) (signp e x))
	      (merror "Undefined form 0*inf:~%~M" e)))
       (setq w (mul2 (simplifya x t) w))
       (cond ((or (atom w) (getl (caar w) '($outative $linear))) (setq w1 1))
	     ((eq (caar w) 'mtimes)
	      (setq w1 (ncons '(mtimes)))
	      (do ((w2 (cdr w) (cdr w2)))
		  ((null w2) (setq w1 (nreverse w1)))
		  (cond ((or (atom (car w2))
			     (not (getl (caaar w2) '($outative $linear))))
			(setq w1 (cons (car w2) w1))))))
	     (t (setq w1 w)))
       (cond ((and (not (atom w1)) (or (among '$inf w1) (among '$minf w1)))
	      (infsimp w))
	     (t w))))

(setq opers (cons '$additive opers)
      *opers-list (cons '($additive . additive) *opers-list))

(defun rem-opers-p (p)
       (cond ((eq (caar opers-list) p)
	      (setq opers-list (cdr p)))
	     ((do ((l opers-list (cdr l)))
		  ((null l))
		  (cond ((eq (caar (cdr l)) p)
			 (return (rplacd l (cddr l)))))))))

(defun additive (e z)
  (cond ((get (caar e) '$outative)			;Really a linearize!
	 (setq opers-list (append opers-list nil))
	 (rem-opers-p '$outative)
	 (linearize1 e z))
	((mplusp (cadr e))
	 (addn (mapcar #'(lambda (q)
				 (oper-apply (list* (car e) q (cddr e)) z))
		       (cdr (cadr e)))
	       z))
	((oper-apply e z))))

(setq opers (cons '$multiplicative opers)
      *opers-list (cons '($multiplicative . multiplicative) *opers-list))

(defun multiplicative (e z)
  (cond ((mtimesp (cadr e))
	 (simptimes
	  (cons '(mtimes)
		(mapcar #'(lambda (q)
				  (oper-apply (list* (car e) q (cddr e)) z))
			(cdr (cadr e))))
	  1 z))
	((oper-apply e z))))

(setq opers (cons '$outative opers)
      *opers-list (cons '($outative . outative) *opers-list))

(defun outative (e z)
       (setq e (cons (car e) (mapcar #'(lambda (q) (simpcheck q z)) (cdr e))))
       (cond ((get (caar e) '$additive)
	      (setq opers-list (append opers-list nil))
	      (rem-opers-p '$additive)
	      (linearize1 e t))
	     ((linearconst e))
	     ((mtimesp (cadr e))
	      (let ((u (cond ((and (cddr e)
				    (or (atom (caddr e))
					($subvarp (caddr e))))
 			       (partition (cadr e) (caddr e) 1))
			      ((rem-const (cadr e)))))
		     (w))
		    (setq w (oper-apply (list* (car e)
					       (simplifya (cdr u) t)
					       (cddr e)) t))
		    (linearize3 w e (car u))))
	     (t (oper-apply e t))))

(defprop %sum t $outative)
(defprop %sum t opers)
(defprop %integrate t $outative)
(defprop %integrate t opers)
(defprop %limit t $outative)
(defprop %limit t opers)

(setq opers (cons '$evenfun opers)
      *opers-list (cons '($evenfun . evenfun) *opers-list))

(setq opers (cons '$oddfun opers)
      *opers-list (cons '($oddfun . oddfun) *opers-list))

(defmfun evenfun (e z)
 (if (or (null (cdr e)) (cddr e))
     (merror "Even function called with wrong number of arguments:~%~M" e))
 (let ((arg (simpcheck (cadr e) z)))
      (oper-apply (list (car e) (if (mminusp arg) (neg arg) arg)) t)))

(defmfun oddfun (e z)
 (if (or (null (cdr e)) (cddr e))
     (merror "Odd function called with wrong number of arguments:~%~M" e))
 (let ((arg (simpcheck (cadr e) z)))
      (if (mminusp arg) (neg (oper-apply (list (car e) (neg arg)) t))
			(oper-apply (list (car e) arg) t))))

(setq opers (cons '$commutative opers)
      *opers-list (cons '($commutative . commutative1) *opers-list))

(setq opers (cons '$symmetric opers)
      *opers-list (cons '($symmetric . commutative1) *opers-list))

(defmfun commutative1 (e z)
       (oper-apply (cons (car e)
			 (reverse
			  (sort (mapcar #'(lambda (q) (simpcheck q z))
					(cdr e))
				'great)))
		   t))

(setq opers (cons '$antisymmetric opers)
      *opers-list (cons '($antisymmetric . antisym) *opers-list))

(declare (special sign))

(defmfun antisym (e z)
 (let ((l (mapcar #'(lambda (q) (simpcheck q z)) (cdr e))))
      (let (sign) (if (or (not (eq (caar e) 'mnctimes)) (freel l 'mnctimes))
		      (setq l (bbsort1 l)))
		  (cond ((equal l 0) 0)
		        ((prog1 (null sign) (setq e (oper-apply (cons (car e) l) t)))
			 e)
		        (t (neg e))))))

(defun bbsort1 (l)
       (prog (sl sl1)
	     (if (or (null l) (null (cdr l))) (return l))
	     (setq sign nil sl (list nil (car l)))
	loop (setq l (cdr l))
	     (if (null l) (return (nreverse (cdr sl))))
	     (setq sl1 sl)
	loop1(cond ((null (cdr sl1)) (rplacd sl1 (ncons (car l))))
		   ((alike1 (car l) (cadr sl1)) (return 0))
		   ((great (car l) (cadr sl1)) (rplacd sl1 (cons (car l) (cdr sl1))))
		   (t (setq sign (not sign) sl1 (cdr sl1)) (go loop1)))
	     (go loop)))

(setq opers (cons '$nary opers)
      *opers-list (cons '($nary . nary1) *opers-list))

(defmfun nary1 (e z)
 (do ((l (cdr e) (cdr l)) (ans))
     ((null l) (oper-apply (cons (car e) (nreverse ans)) z))
     (setq ans (if (and (not (atom (car l))) (eq (caaar l) (caar e)))
		   (nconc (reverse (cdar l)) ans)
		   (cons (car l) ans)))))

(setq opers (cons '$lassociative opers)
      *opers-list (cons '($lassociative . lassociative) *opers-list))

(defmfun lassociative (e z)
       (let ((ans (cdr (oper-apply (cons (car e) (total-nary e)) z))))
	    (cond ((null (cddr ans)) (cons (car e) ans))
		  ((do ((newans (list (car e) (car ans) (cadr ans))
				(list (car e) newans (car ans)))
			(ans (cddr ans) (cdr ans)))
		       ((null ans) newans))))))

(setq opers (cons '$rassociative opers)
      *opers-list (cons '($rassociative . rassociative) *opers-list))

(defmfun rassociative (e z)
       (let ((ans (nreverse (cdr (oper-apply (cons (car e) (total-nary e)) z)))))
	    (cond ((null (cddr ans)) (cons (car e) ans))
		  ((do ((newans (list (car e) (cadr ans) (car ans))
				(list (car e) (car ans) newans))
			(ans (cddr ans) (cdr ans)))
		       ((null ans) newans))))))

(defmfun total-nary (e)
 (do ((l (cdr e) (cdr l)) (ans))
     ((null l) (nreverse ans))
     (setq ans (if (and (not (atom (car l))) (eq (caaar l) (caar e)))
		   (nconc (reverse (total-nary (car l))) ans)
		   (cons (car l) ans)))))

(setq opers (purcopy opers) *opers-list (purcopy *opers-list))

(setq $opproperties (cons '(mlist simp) (reverse opers)))
