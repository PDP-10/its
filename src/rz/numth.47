;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;   *****************************************************************
;;;   ***** NUMTH ******* VARIOUS NUMBER THEORY FUNCTIONS *************
;;;   *****************************************************************

(macsyma-module numth)

(declare (special primechannel $intfaclim))

(load-macsyma-macros rzmac)

(comment PRIME number generator)

(defmvar $maxprime 489318.)

(or (boundp 'primechannel) (setq primechannel nil))

#+ITS
(defun open-primechannel nil
      (setq primechannel (open '|mc:maxdmp;ptable >| '(in fixnum))
	    $maxprime (1- (car (syscall 1 'fillen primechannel)))))

#+LISPM
(defun open-primechannel nil
       (setq primechannel
	     (open "mc:maxdmp;ptable >" '(:read :fixnum :byte-size 9))))

(defun prime (n)
       (cond ((or (< n 1) (> n $maxprime))
	      nil)
	     (#M (filepos primechannel (1- n)) #M (in primechannel)
	      #Q (input-word n))))

#Q
(defmacro byte-in (file) `(funcall ,file ':tyi))
#Q
(defun input-word (n)
       (funcall primechannel ':set-pointer (* 4 (1- n)))
       (dpb (byte-in primechannel) 3311
	    (dpb (byte-in primechannel) 2211
		 (dpb (byte-in primechannel) 1111 (byte-in primechannel)))))

(defmfun $prime (n)
       (prog2 (open-primechannel)
	      (if (eq (typep n) 'fixnum)
		  (or (prime n) (list '($prime) n))
		  (list '($prime) n))
	      (close primechannel)))

(comment Sum of divisors and Totient functions)

(DEFMFUN $divsum n
       (or (< n 3)
	   (merror "To many arguments to DIVSUM"))
       ((lambda ($intfaclim k n) 
		(cond ((and (fixp k) (fixp n))
		       (setq n (abs n))
		       (cond ((equal k 0)
			      (cond ((= n 1) 1)
				    ((= n 0) 1)
				    (t (do ((l (cfactorw n) (cddr l))
					    (a 1 (times a (1+ (cadr l)))))
					   ((null l) a)))))
			     (t (divsum (cfactorw n) k))))
		      ((list '($divsum) n k))))
	nil
	(cond ((= n 1) 1)
	      ((arg 2)))
	(arg 1)))

(defun divsum (l k)
       (do ((l l (cddr l))
	    (ans 1) (temp))
	   ((null l) ans)
	   (cond ((equal (car l) 1))
		 ((setq temp (expt (car l) k)
			ans (times
			     (*quo (sub1 (expt temp (add1 (cadr l))))
				   (sub1 temp))
			     ans))))))

(defmfun $totient (n)
  (cond ((fixp n)
	 (setq n (abs n))
	 (cond ((lessp n 1) 0)
	       ((equal n 1) 1)
	       (t (do ((factors (let ($intfaclim) (cfactorw n))
				(cddr factors))
		       (total 1 (times total
				       (sub1 (car factors))
				       (expt (car factors)
					     (sub1 (cadr factors))))))
		      ((null factors) total)))))
	(t (list '($totient) n))))

(comment JACOBI symbol and Gaussian factoring)

(declare (special *incl modulus $intfaclim))

(setq *incl (list 2 4))

(and (nconc *incl *incl) 'noprint)

(defun rtzerl2 (n)
       (cond ((zerop n) 0)
	     (t (do ((n n (quotient n 4)))
		    ((not (zerop (haipart n -2))) n)))))

(defun imodp (p)
       (cond ((not (equal (remainder p 4) 1)) nil)
	     ((equal (remainder p 8) 5) (imodp1 2 p))
	     ((equal (remainder p 24) 17) (imodp1 3 p))	;p=2(mod 3)
	     (t (do ((i 5 (plus i (car j)))	;p=1(mod 24)
		     (j *incl (cdr j)))
		    ((equal (jacobi i p) -1) (imodp1 i p))))))

(defun imodp1 (i modulus)
       (abs (cexpt i (quotient (sub1 modulus) 4) )))

(DEFMFUN $jacobi (p q)
       (cond ((null (and (fixp p) (fixp q)))
	      (list '($jacobi) p q))
	     ((zerop q) (merror "Zero denominator?"))
	     ((minusp q) ($jacobi p (minus q)))
	     ((and (evenp (setq q (rtzerl2 q)))
		   (setq q (quotient q 2))
		   (evenp p)) 0)
	     ((equal q 1) 1)
	     ((minusp (setq p (remainder p q)))
	      (jacobi (rtzerl2 (plus p q)) q))
	     (t (jacobi (rtzerl2 p) q))))

(defun jacobi (p q)
       (do ((r1 p (rtzerl2 (remainder r2 r1)))
	    (r2 q r1)
	    (bit2 (haipart q -2))
	    (odd 0 (boole 6 odd (boole 1 bit2
				       (setq bit2 (haipart r1 -2))))))
	   ((zerop r1) 0)
	   (cond ((evenp r1) (setq r1 (quotient r1 2))
			     (setq odd (boole 6 odd
					      (lsh (^ (haipart r2 -4) 2) -2)))))
	   (and (equal r1 1) (return (expt -1 (boole 1 1 (lsh odd -1)))))))

(defun psumsq (p)
       ((lambda (x)
		(cond ((equal p 2) (list 1 1))
		      ((null x) nil)
		      (t (psumsq1 p x))))
	(imodp p)))

(defun psumsq1 (p x)
       (do ((sp ($isqrt p))
	    (r1 p r2)
	    (r2 x (remainder r1 r2)))
	   ((not (greaterp r1 sp)) (list r1 r2))))

(defun gctimes (a b c d)
       (list (difference (times a c)
			 (times b d))
	     (plus (times a d)
		   (times b c))))

(declare (*lexpr $rat))

(DEFMFUN $gcfactor (n)
       (setq n (cdr ($totaldisrep ($bothcoef ($rat n '$%i) '$%i))))
       (cond ((and (fixp (car n)) (fixp (cadr n)))
	      (setq n (map2c (fn (term exp)
				 (cond ((= exp 1) (gcdisp term))
				       (t (list '(mexpt) (gcdisp term) exp))))
			     (gcfactor (cadr n) (car n))))
	      (cond ((null (cdr n)) (car n))
		    (t (cons '(mtimes simp) (nreverse n)))))
	     (t (gcdisp (nreverse n)))))

(defun gcdisp (term)
       (cond ((atom term) term)
	     ((let ((rp (car term))
		    (ip (cadr term)))
		   (setq ip (cond ((equal ip 1) '$%i)
				  (t (list '(mtimes) ip '$%i))))
		   (cond ((equal rp 0) ip)
			 (t (list '(mplus) rp ip)))))))


(defun gcfactor (a b) 
       (prog (gl cd dc econt p e1 e2 ans plis nl $intfaclim)
       (setq e1 0
	     e2 0
	     econt 0
	     gl (gcd a b)
	     a (quotient a gl)
	     b (quotient b gl)
	     nl (cfactorw (plus (times a a) (times b b)))
	     gl (cfactorw gl))
       (and (equal 1 (car gl)) (setq gl nil))
       (and (equal 1 (car nl)) (setq nl nil))
loop   (cond ((null gl)
	      (cond ((null nl) (go ret))
		    ((setq p (car nl)))))
	     ((null nl) (setq p (car gl)))
	     (t (setq p (max (car gl) (car nl)))))
       (setq cd (psumsq p))
       (cond ((null cd)
	      (setq plis (cons p (cons (cadr gl) plis)))
	      (setq gl (cddr gl)) (go loop))
	     ((equal p (car nl))
	      (cond ((zerop (remainder (plus (times a (car cd))	;gcremainder
					     (times b (cadr cd))) p))
		     (setq e1 (cadr nl)) (setq dc cd))
		    (t (setq e2 (cadr nl))
		       (setq dc (reverse cd))))
	      (setq dc (gcexpt dc (cadr nl))
		    dc (gctimes a b (car dc) (minus (cadr dc)))
		    a (quotient (car dc) p)
		    b (quotient (cadr dc) p)
		    nl (cddr nl))))
       (cond ((equal p (car gl))
	      (setq econt (plus econt (cadr gl)))
	      (cond ((equal p 2)
		     (setq e1 (+ e1 (* 2 (cadr gl)))))
		    (t (setq e1 (+ e1 (cadr gl))
			     e2 (+ e2 (cadr gl)))))
	      (setq gl (cddr gl))))
       (and (not (zerop e1))
	    (setq ans (cons cd (cons e1 ans)))
	    (setq e1 0))
       (and (not (zerop e2))
	    (setq ans (cons (reverse cd) (cons e2 ans)))
	    (setq e2 0))
       (go loop)
ret    (setq cd (gcexpt (list 0 -1) (\ econt 4)))
       (setq a (gctimes a b (car cd) (cadr cd)))
       (cond ((or (equal (car a) -1) (equal (cadr a) -1))
	      (setq plis (cons -1 (cons 1 plis)))))
       (cond ((equal (car a) 0)
	      (setq ans (cons '(0 1) (cons 1 ans)))))
       (return (nconc plis ans))))

(defun gcexpt (a n)
       (cond ((zerop n) '(1 0))
	     ((equal n 1) a)
	     (t (gctime1 a (gcexpt a (1- n))))))

(defun gctime1 (a b) (gctimes (car a) (cadr a) (car b) (cadr b)))
