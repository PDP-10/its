;;;   -*-Mode: Lisp; Package: Macsyma -*-
;;;   **************************************************************
;;;   ***** HAYAT ******* Finite Power Series Routines *************
;;;   **************************************************************
;;;   ** (c) Copyright 1981 Massachusetts Institute of Technology **
;;;   ****** This is a read-only file! (All writes reserved) *******
;;;   **************************************************************

;;;		TOP LEVEL STRUCTURE

;;;	Power series have the following format when seen outside the power
;;; series package:
;;; 
;;;    ((MRAT SIMP <varlist> <genvar> <tlist> trunc) <poly-form>)
;;; 
;;; This is the form of the output of the expressions, to
;;; be displayed they are RATDISREPed and passed to DISPLA.

;;; The <poly-forms> consist of a header and list of exponent-coefficient
;;; pairs as shown below.  The PS is used to distinguish power series
;;; from their coefficients which have a similar representation.
;;; 
;;;   (PS (<var> . <ord-num>) (<trunc-lvl>)
;;;	  (<exponent> . <coeff>) (<exponent> . <coeff>) . . .)
;;; 
;;; The <var> component of the power series is a gensym which represents the
;;; kernel of the power series.  If the package is called with the arguments:
;;; Taylor(<expr>, x, a, n)  then the kernel will be (x - a).
;;; The <ord-num> is a relative ordering for the various kernels in a
;;; multivariate expansion.  
;;; <trunc-lvl> is the highest degree of the variable <var> which is retained
;;; in the current power series.
;;; The terms in the list of exponent-coefficient pairs are ordered by
;;; increasing degree.

(macsyma-module hayat)

(load-macsyma-macros mhayat rzmac ratmac)

		(comment Subtitle Special Stuff for Compiling)

(declare (special vlist		;
		  varlist	;List of all the variables occuring in a power
				;series, the power series variables at the end
		  genvar	;The list of gensyms corresponding to varlist
		  modulus       ;
		  *a*		;Temporary special
		  sub-exprs	;
		  silent-taylor-flag	;If true indicates that errors will be 
				;returned via a throw to TAY-ERR
		  tlist		;An association list which contains the
				;relevant information for the expansion which
				;is passed in at toplevel invocation.  
		  $float	;Indicates whether to convert rational numbers
				;to floating point numbers.
		  $keepfloat	;When true retains floatin point numbers 
				;internal to Taylor.
		  $radexpand    ;
		  log-1		;What log(-1) should be log(-1) or pi*i.
		  log%i		;Similarly for log(i)
		  exact-poly    ;Inicates whether polynomials are to be
		                ;considered exact or not.  True within SRF,
				;false within TAYLOR.
		  ngps		;
		  num-syms	;
		  loc-gensym	;
		  syms		;
		  tvars		;
		  pssyms	;
		  half%pi	;Has pi/2 to save space.
		  const-funs	;
		  const-exp-funs;
		  tay-const-expand	;For rediculousness like csch(log(x))
		  $exponentialize       ;which we do by exponentiation.
		  tay-pole-expand;
		  trigdisp	;
		  last-exp	;last-expression through taylor2
		  $taylordepth	;
		  $ratexpand	;
		  $psexpand	;
		  genpairs	;List of dotted pairs 
		  ps-bmt-disrep	;
		  ivars		;Pairlist if gensym and disreped version
		  key-vars	;Pairlist of gensym and key var (for searching
				;TLIST)
		  $algebraic	;
		  *psacirc	;
		  *pscirc	;
		  full-log	;
		  $logarc	;
		  trunclist	;
		  mainvar-datum ;
	          $zerobern $simp 0p-funord lexp-non0)	;
	 (*expr lcm)
	 (muzzled t))	;Don't want to see closed compilation notes.

(defmvar $MAXTAYORDER T
 "When FALSE truncation orders are combined by taking their minimum; otherwise
  (the default) truncation orders are combined by taking the maximum order
  which is a formally correct truncation.")

(defmvar $TAYLOR_TRUNCATE_POLYNOMIALS T
 "When FALSE polynomials input to TAYLOR are considered to have infinite
  precison; otherwise (the default) they are truncated based upon the input
  truncation levels.")

(defmvar $TAYLOR_LOGEXPAND T
 "Unless FALSE log's of products will be expanded fully in TAYLOR (the default)
  to avoid identically-zero constant terms which involve log's. When FALSE,
  only expansions necessary to produce a formal series will be executed.")


		(comment Subtitle Coefficient Arithmetic)

(defun rcexpt (x y)
       (cond ((equal x (rcone)) (rcone))
	     ((rczerop y) (rcone))
	     ((and (equal (cdr y) 1) (eq (typep (car y)) 'FIXNUM))
	      (ratexpt x (car y)))
	     ((and $radexpand (numberp (car y)) (numberp (cdr y)))
	      (if (eq (typep (car y)) 'FLONUM) 
		  (setq y (rationalize (*quo (car y) (cdr y)))))
	      (ratexpt (rcquo (rcexpt1 (car x) (cdr y))
			      (rcexpt1 (cdr x) (cdr y)))
		       (car y)))
	     (t (let ($keepfloat)
		     (prep1 (m^ (rcdisrep x) (rcdisrep y)))))))

(defun rcexpt1 (p n)
  (cond ((equal p 1) (rcone))
	((pcoefp p) (prep1 (m^ (pdis p) (*red 1 n))))
	(t (do ((l (psqfr p) (cddr l))
		(ans (rcone)))
	       ((null l) ans)
	       (if (equal (/\ (cadr l) n) 0)
		   (setq ans (rctimes ans (ratexpt (cons (car l) 1)
						   (// (cadr l) n))))
		   (setq ans (rctimes ans (prep1 (m^ (pdis (car l))
						     (*red (cadr l) n))))))))))

(defun rccoefp (e)		;a sure check, but expensive
       (and (null (atom e))
	    (or (atom (car e))
		(memq (caar e) genvar))
	    (or (atom (cdr e))
		(memq (cadr e) genvar))))

		(Comment Subtitle Exponent arithmetic)

(defun e+ (x y)
    (cond ((or (infp x) (infp y)) (inf))
	  ((and (equal (cdr x) 1) (equal (cdr y) 1))
	   (cons (plus (car x) (car y)) 1))
	  (t (ereduce (plus (times (car x) (cdr y)) (times (cdr x) (car y)))
		      (times (cdr x) (cdr y))))))

(defun ediff (x y)
    (cond ((infp x) (inf))
	  ((and (equal (cdr x) 1) (equal (cdr y) 1))
	   (cons (*dif (car x) (car y)) 1))
	  (t (ereduce (*dif (times (car x) (cdr y)) (times (cdr x) (car y)))
		      (times (cdr x) (cdr y))))))

(defun emin (x y)
    (cond ((infp x) y)
	  ((infp y) x)
	  ((equal (cdr x) (cdr y)) (cons (min (car x) (car y)) (cdr x)))
	  ((lessp (times (car x) (cdr y)) (times (cdr x) (car y))) x)
	  (t y)))

(defun emax (x y)
    (cond ((or (infp x) (infp y)) (inf))
	  ((equal (cdr x) (cdr y)) (cons (max (car x) (car y)) (cdr x)))
	  ((greaterp (times (car x) (cdr y)) (times (cdr x) (car y))) x)
	  (t y)))

(defun e* (x y)
    (cond ((or (infp x) (infp y)) (inf))
	  ((and (equal (cdr x) 1) (equal (cdr y) 1))
	   (cons (times (car x) (car y)) 1))
	  (t (ereduce (times (car x) (car y)) (times (cdr x) (cdr y))))))

(defun erecip (e)
       (if (minusp (car e))
	   (cons (minus (cdr e)) (minus (car e)))
	   (cons (cdr e) (car e))))

(defun equo (x y)
       (cond ((infp x) (inf))
	     ((infp y) (rczero))
	     (t (ereduce (times (car x) (cdr y))
			 (times (cdr x) (car y))))))

(defun e1+ (x)
    (cond ((infp x) (inf))
	  ((= (cdr x) 1) (cons (add1 (car x)) 1))
	  (t (cons (plus (cdr x) (car x)) (cdr x)))))

(defun e1- (x)
    (cond ((infp x) (inf))
	  ((equal (cdr x) 1) (cons (sub1 (car x)) 1))
	  (t (cons (*dif (car x) (cdr x)) (cdr x)))))

(defun e> (x y)
    (cond ((infp x) t)
	  ((infp y) ())
	  ((equal (cdr x) (cdr y)) (greaterp (car x) (car y)))
	  (t (greaterp (times (car x) (cdr y)) (times (car y) (cdr x))))))

(defun e= (e1 e2)
	  (cond ((eq e1 e2) t)
		((or (null e1) (null e2)) ())
		(t (and (equal (car e1) (car e2))
			(equal (cdr e1) (cdr e2))))))

(defun ereduce (n d)
       (if (signp l d) (setq d (minus d) n (minus n)))
       (if (zerop n) (rczero)
	   (let ((gcd (gcd n d)))
		(cons (*quo n gcd) (*quo d gcd)))))

(defun egcd (x y)
       (let ((xn (abs (car x))) (xd (cdr x))
	     (yn (abs (car y))) (yd (cdr y)))
	    (cons (gcd xn yn) (times xd (*quo yd (gcd xd yd))))))

		(Comment Subtitle polynomial arithmetic)

(declare (special vars))

(defun ord-vector (p)
  (let ((vars (mapcar #'(lambda (datum) (list (int-gvar datum)))
		      tlist)))
       (ifn (cdr vars) (ncons (ps-le* p))
	    (ord-vect1 p)
	    (mapcar #'(lambda (x) (or (cdr x) (rczero)))
		    vars))))

(defun ord-vect1 (p)
  (ifn (pscoefp p)
       (let ((dat (assq (gvar p) vars))
	     (le (ps-le p)))
	    (rplacd dat (ifn (cdr dat) le (emin (cdr dat) le)))
	    (map #'(lambda (l) (ord-vect1 (lc l)))
		 (terms p)))))

;;; Currently unused
;;;
;;; (defun trunc-vector (p)
;;;   (let ((vars (mapcar #'(lambda (datum) (list (int-gvar datum)))
;;;   		      tlist)))
;;;       (ifn (cdr vars) (ncons (if (psp p) (trunc-lvl p) ()))
;;;	    (trunc-vect1 p)
;;;	    (mapcar 'cdr vars))))
;;;
;;; (defun trunc-vect1 (p)
;;;       (ifn (pscoefp p)
;;;	    (let ((dat (assq (gvar p) vars))
;;;		  (trnc (trunc-lvl p)))
;;;		 (and trnc
;;;		      (rplacd dat
;;;			      (ifn (cdr dat) trnc (emin (cdr dat) trnc)))))))

(declare (unspecial vars))

(defun psplus (x y)
    (cond ((pscoefp x) (cond ((pscoefp y) (rcplus x y))
			     ((rczerop x) y)
			     (t (pscplus x y))))
	  ((pscoefp y) (if (rczerop y) x (pscplus y x)))
	  ((eqgvar (gvar-o x) (gvar-o y)) (psplus1 x y))
	  ((pointerp (gvar-o x) (gvar-o y)) (pscplus y x))
	  (t (pscplus x y))))

(defun psdiff (x y)
    (cond ((pscoefp x) (cond ((pscoefp y) (rcdiff x y))
			     ((rczerop x) (pstimes (rcmone) y))
			     (t (pscdiff x y ()))))
	  ((pscoefp y) (if (rczerop y) x (pscdiff y x t)))
	  ((eqgvar (gvar-o x) (gvar-o y)) (psdiff1 x y))
	  ((pointerp (gvar-o x) (gvar-o y)) (pscdiff y x t))
	  (t (pscdiff x y ()))))

(defun psplus1 (x y)
       (let ((ans (cons () ())))
	    (psplus2 (gvar-o x)
		     (emin (trunc-lvl x)  (trunc-lvl y))
		     (cons 0 (terms x)) (cons 0 (terms y)) ans ans)))

(defun pscplus (c p)
       (if (e> (rczero) (trunc-lvl p)) p
	   (pscheck (gvar-o p) (poly-data p)
		    (pscplus1 c (terms p)))))

(defun pscdiff (c p fl)
       (if (e> (rczero) (trunc-lvl p))
	   (if fl p (psminus p))
	   (pscheck (gvar-o p) (poly-data p)
		    (ifn fl (pscplus1 c (psminus-terms (terms p)))
			 (pscplus1 (psminus c) (terms p))))))

(defun pscplus1 (c l)
       (cond ((null l) (list (term (rczero) c)))
	     ((rczerop (le l)) (setq c (psplus c (lc l)))
	      (if (rczerop c) (n-term l)
		  (cons (term (rczero) c)
			(n-term l))))
	     ((e> (le l) (rczero)) (cons (term (rczero) c) l))
	     (t (cons (lt l) (pscplus1 c (n-term l))))))

;;; Both here and in psdiff2 xx and yy point one before where one
;;; might think they should point so that extensions will be retained.

(defun psplus2 (varh trunc xx yy ans a)
  (prog (c)
   a	(cond ((mono-term? xx)
	       (if (mono-term? yy) (go end) (go null)))
	      ((mono-term? yy) (setq yy xx) (go null)))
        (cond ((equal (le (n-term xx)) (le (n-term yy)))
	       (setq xx (n-term xx) yy (n-term yy))
	       (setq c (psplus (lc xx) (lc yy)))
	       (if (rczerop c) (go a) (add-term a (le xx) c)))
	      ((e> (le (n-term xx)) (le (n-term yy)))
	       (setq yy (n-term yy))
	       (add-term a (lt yy)))
	      (t (setq xx (n-term xx))
		 (add-term a (lt xx))))
	(setq a (n-term a))
	(go a)
   null (if (or (mono-term? yy) (e> (le (n-term yy)) trunc))
	    (go end)
	    (setq yy (n-term yy))
	    (add-term-&-pop a (lt yy))
	    (go null))
   end  (return (pscheck varh (list trunc) (cdr ans)))))

(defun psdiff1 (x y)
       (let ((ans (cons () ())))
	    (psdiff2 (gvar-o x)
		     (emin (trunc-lvl x) (trunc-lvl y))
		     (cons 0 (terms x)) (cons 0 (terms y)) ans ans)))

(defun psdiff2 (varh trunc xx yy ans a)
  (prog (c)
   a	(cond ((mono-term? xx)
	       (if (mono-term? yy) (go end)
		   (setq yy (cons 0 (mapcar
				     #'(lambda (q)
					  (term (e q) (psminus (c q))))
				     (cdr yy))))
		   (go null)))
	      ((mono-term? yy)
	       (setq yy xx) (go null)))
        (cond ((equal (le (n-term xx)) (le (n-term yy)))
	       (setq xx (n-term xx) yy (n-term yy))
	       (setq c (psdiff (lc xx) (lc yy)))
	       (if (rczerop c) (go a)
		   (add-term a (le xx) c)))
	      ((e> (le (n-term xx)) (le (n-term yy)))
	       (setq yy (n-term yy))
	       (add-term a (le yy) (psminus (lc yy))))
	      (t (setq xx (n-term xx))
		 (add-term a (lt xx))))
	(setq a (n-term a))
	(go a)
   null (if (or (mono-term? yy) (e> (le (n-term yy)) trunc))
	    (go end)
	    (setq yy (n-term yy))
	    (add-term-&-pop a (le yy) (lc yy))
	    (go null))
   end	(return (pscheck varh (list trunc) (cdr ans)))))

(defun psminus (x)
       (if (psp x) (make-ps x (psminus-terms (terms x)))
	   (rcminus x)))

(defun psminus-terms (terms)
       (let ((ans (cons () ())))
	    (do ((q terms (n-term q))
		 (a ans (cdr a)))
		((null q) (cdr ans))
		(add-term a (le q) (psminus (lc q))))))

(defun pscheck (a b terms)
       (cond ((null terms) (rczero))
	     ((and (mono-term? terms)
		   (rczerop (le terms)))
	      (lc terms))
	     (t (make-ps a b terms))))

(defun pstrim-terms (terms e)
       (do () (())
	   (cond ((null terms) (return ()))
		 ((null (e> e (le terms)))
		  (return terms))
		 (t (setq terms (n-term terms))))))

(defun psterm (terms e)
       (psterm1 (pstrim-terms terms e) e))

(defun psterm1 (l e) 
       (cond ((null l) (rczero))
	     ((e= (le l) e) (lc l))
	     (t (rczero))))

(defun pscoeff1 (a b c)		;a is an mrat!!!
       (let ((tlist (cadddr (cdar a)))
	     v)
	    (setq v (int-gvar (get-datum b)))
	    (cons
	     (nconc (list 'MRAT 'SIMP (caddar a) (car (cdddar a)))
		    (do ((l (cadddr (cdr (car a))) (cdr l))
			 (ans () (cons (car l) ans)))
			((null l) ans)
			(and (alike1 (caar l) b)
			     (return
			      (if (or ans (cdr l))
				  (list (nreconc ans (cdr l)) 'TRUNC))))))
	     (pscoef (cdr a) v (prep1 c)))))

(defun pscoef (a b c)
       (cond ((pscoefp a)
	      (cond ((rczerop c) a)
		    ((rczero))))
	     ((eq b (gvar a))
	      (psterm (terms a) c))
	     (T (do ((gvar-o (gvar-o a))
		     (poly-data (poly-data a))
		     (ans (rczero))
		     (terms (terms a) (n-term terms))
		     (temp))
		    ((null terms) ans)	
		   (unless (rczerop (setq temp (pscoef (lc terms) b c)))
		      (setq ans (psplus ans
					(make-ps gvar-o poly-data
						 (ncons (term (le terms)
							      temp))))))))))

(defun psdisextend (p)
  (ifn (psp p) p
       (make-ps p
		(mapcar #'(lambda (q) (cons (car q)
					    (psdisextend (cdr q))))
			(terms p)))))

(defun psfloat (p)
       (if (psp p) (psfloat1 p (trunc-lvl p) (terms p) (ncons 0))
	   (rctimes (rcfone) p)))

(defun psfloat1 (p trunc l ans)
       (do (($float t)
	    (a (last ans) (n-term a)))
	   ((or (null l) (e> (le l) trunc))
	    (pscheck (gvar-o p) (poly-data p) (cdr ans)))
	   (add-term a (le l) (psfloat (lc l)))
	   (setq l (n-term l))))

(defun pstrunc (p)
  (pstrunc1 p (mapcar #'(lambda (q) (cons (int-gvar q) (current-trunc q)))
		      tlist)))

(defun pstrunc1 (p trlist)
  (ifn (psp p) p
       (let ((trnc (cdr (assq (gvar p) trlist))))
	   (ifn (e> (trunc-lvl p) trnc)
		(pscheck (gvar-o p) (poly-data p)
			 (maplist #'(lambda (l)
					    (term (le l)
						  (pstrunc1 (lc l) trlist)))
				  (terms p)))
		(do ((l (terms p) (n-term l))
		     (a () (cons (term (le l)
				       (pstrunc1 (lc l) trlist))
				 a)))
		    ((null l)
		     (pscheck (gvar-o p) (ncons (trunc-lvl p)) (nreverse a)))
		    (when (e> (le l) trnc)
		     (return 
		      (pscheck (gvar-o p) (ncons trnc) (nreverse a)))))))))

(defun pstimes (x y)
    (cond ((or (rczerop x) (rczerop y)) (rczero))
	  ((pscoefp x) (cond ((pscoefp y) (rctimes x y))
			     ((equal x (rcone)) y)
			     (t (psctimes* x y))))
	  ((pscoefp y) (if (equal y (rcone)) x (psctimes* y x)))
	  ((eqgvar (gvar-o x) (gvar-o y)) (pstimes*1 x y))
	  ((pointerp (gvar-o x) (gvar-o y)) (psctimes* y x))
	  (t (psctimes* x y))))

(defun psctimes* (c p)
  (make-ps p (maplist #'(lambda (l)
			   (term (le l) (pstimes c (lc l))))
		      (terms p))))

(defun pstimes*1 (xa ya)
       (let ((ans (cons () ()))
	     (trunc (let ((lex (ps-le xa))
			  (ley (ps-le ya)))
			 (e+ (emin (e- (trunc-lvl xa) lex)
				   (e- (trunc-lvl ya) ley))
			     (e+ lex ley)))))
	    (and (null $maxtayorder)
		 (setq trunc (emin trunc (t-o-var (gvar xa)))))
	    (pstimes*2 xa ya trunc ans)))

(defun pstimes*2 (xa ya trunc ans)
       (prog (a c e x y yy)
	(setq x (terms xa) y (setq yy (terms ya))
	      a ans)
   a	(cond ((or (null y) (e> (setq e (e+ (le x) (le y))) trunc))
	       (go b))
	      ((null (rczerop (setq c (pstimes (lc x) (lc y)))))
	       (add-term-&-pop a e c)))
        (setq y (n-term y))
	(go a)
   b	(and (null (setq x (n-term x)))
	     (return (pscheck (gvar-o xa) (list trunc) (cdr ans))))
        (setq y yy a ans)
   c	(if (or (null y) (e> (setq e (e+  (le x) (le y))) trunc))
	    (go b))
        (setq c (pstimes (lc x) (lc y)))
   d	(cond ((or (mono-term? a) (e> (le (n-term a)) e))
	       (add-term-&-pop a e c))
	      ((e> e (le (n-term a)))
	       (setq a (n-term a))
	       (go d))
	      (t (setq c (psplus c (lc (n-term a))))
		 (if (rczerop c) (rplacd a (n-term (n-term a)))
		     (change-lc (n-term a) c) (setq a (n-term a)))))
        (setq y (n-term y))
	(go c)))

(defun pscsubst (c v p)
  (cond ((pscoefp p) p)
	((eq v (gvar p)) (pscsubst1 c p))
	((pointerp v (gvar p)) p)
	(t (make-ps p (maplist
		       #'(lambda (q) (term (le q)
					   (pscsubst c v (lc q))))
		       (terms p))))))

(defun pscsubst1 (v u)
       (do ((a (rczero))
	    (ul (terms u) (n-term ul)))
	   ((null ul) a)
	   (setq a (psplus a (pstimes (lc ul) (psexpt v (le ul)))))))

(defun get-series (func trunc var e c)
       (let ((pw (e// trunc e)))
	    (setq e (if (and (equal e (rcone)) (equal c (rcone)))
			(getexp-fun func var pw)
			(psmonsubst (getexp-fun func var pw)
				    trunc e c)))
	    (if (and $float $keepfloat) (psfloat e) e)))

(defun psmonsubst (p trunc e c)
       (psmonsubst1 p trunc e c `(() . ,(terms p)) (ncons ())
		    (rcone) (rczero)))

(defun psmonsubst1 (p trunc e c l ans cc el)
       (prog (a ee varh)
	     (setq a ans varh (gvar-o p))
	a    (cond ((or (mono-term? l)
			(e> (setq ee (e* e (le (n-term l)))) trunc))
		    (go end))
		   ((rczerop (setq cc
				(pstimes cc
					 (psexpt c (e- (le (setq l (n-term l)))
						       el))))))
		   ((mono-term? a)
		    (add-term a ee (pstimes cc (lc l)))))
	     (setq a (n-term a) el (le l))
	     (go a)
	end  (return (pscheck varh (list trunc) (cdr ans)))))

(defun psexpon-gcd (terms)
       (do ((gcd (le terms) (egcd (le l) gcd))
	    (l (n-term terms) (n-term l)))
	   ((null l) gcd)))

(defun psfind-s (p)
       (if (psp p) (psfind-s (psterm (terms p) (rczero)))
	   (psfind-s1 p)))

(defun psfind-s1 (r)
       (cond ((null (atom (cdr r)))
	      (rczero))
	     ((atom (car r)) r)
	     (t (do ((p (pterm (cdar r) 0) (pterm (cdr p) 0)))
		    ((atom p) (cons p (cdr r)))))))

(defun psexpt (p n)
    (cond ((rczerop n)		;p^0
	   (if (rczerop p)	;0^0
	       (merror "~&Indeterminate form 0^0 generated inside PSEXPT~%")
	       (rcone)))	;Otherwise can let p^0 = 1
	  ((or (equal n (rcone)) (equal n (rcfone)))	;P^1 cases
	   p)
	  ((pscoefp p) (rcexpt p n))
	  ((mono-term? (terms p))	;A monomial to a power
	   (let ((s (psfind-s n)) (n-s) (x) (l (terms p)))
		;s is the numeric part of the exponent
		(if (eq (typep (car s)) 'FLONUM)	;Perhaps we souldn't
		       ;rationalize if $keepfloat is true?
		    (setq s (rationalize (*quo (car s) (cdr s)))))
		(setq n-s (psdiff n s)	;the non-numeric part of exponent
		      x   (e* s (le l)))	;the degree of the lowest term
		(setq x (if (and (null $maxtayorder)  ;if not getting all terms
				 (e> x (t-o-var (gvar p))))
			                ;and result is of high order
			    (rczero)	;then zero is enough
			    (pscheck (gvar-o p)	;otherwise
				     (ncons (e+ (trunc-lvl p) ;new trunc-level
						(e- x (le l)))) ;kick exponent
				     (ncons (term x (psexpt (lc  l) n))))))
		;x is now p^s
		(if (or (rczerop n-s) (rczerop x)) ;is that good enough?
		    x	;yes!  the rest is bletcherous.
		    (pstimes x (psexpt (prep1 (m^ (get-inverse (gvar p))
						  (rcdisrep n-s)))
				       (ps-le p))))))
	  (t (prog (l lc le inc trunc s lt mr lim lcinv ans)
		   (setq lc (lc (setq l (terms p)))
			 le (le l) lt (lt l) trunc (trunc-lvl p)
			 inc (psexpon-gcd l) s (psfind-s n))
		   (if (eq (typep (car s)) 'FLONUM)
		       (setq s (rationalize (*quo (car s) (cdr s)))))
		   (setq ans (psexpt (setq lt (pscheck (gvar-o p) (list trunc)
						       (list lt))) n)
			 lcinv (psexpt lc (rcmone))
			 mr (e+ inc (e* s le))
			 lim (if (and (infp trunc) (not (e> s (rczero))))
				 (t-o-var (gvar p))
				 (e+ trunc (e* (e1- s) le)))
			 ans
			 (if (or (pscoefp ans) (null (eq (gvar p) (gvar ans))))
			     (list 0 (term (rczero) ans))
			     (cons 0 (terms ans))))
		   (and (null $maxtayorder)
			(if (infp lim)
			    (if (rcintegerp s)
				(e> (e* s (le (last l))) (t-o-var (gvar p)))
				T)
			    T)
			(setq lim (emin lim (t-o-var (gvar p)))))
		   ;;(and (infp lim) (n-term l) (e> (rczero) n)
		   ;;	  (infin-ord-err))
		   (return (psexpt1 (gvar-o p)
				    lim l n s inc 1 mr ans le lcinv))))))

(defun psexpt1 (varh trunc l n s inc m mr ans r linv)
       (declare (fixnum m))
       s ;Ignored
       (prog (a k ak cm-k c ma0 sum kr tr)
	   (declare (fixnum k))
	   ;; truly unfortunate that we need so many variables in this hack
	   (setq a (last ans) tr trunc)
	   (and (infp tr)
		(if (rcintegerp s)
		    (setq tr (e* s (le (last l))))
		    (merror "Bad power series arg in PSEXPT")))
	 b (and (e> mr tr) (go end))
	   (setq kr inc ak l ma0 (pstimes (cons 1 m) linv)
		 k 1 sum (rczero))
	 a (if (or (> k m) (null (setq cm-k (psterm (cdr ans) (e- mr kr)))))
	       (go add-term))
	   (setq ak (or (pstrim-terms ak (e+ kr r)) (go add-term))
		 c (pstimes (psdiff (pstimes (cons k 1) n)
				    (cons (- m k) 1))
			    (pstimes (if (e= (e+ kr r) (le ak))
					 (lc ak)
					 (rczero))
				     cm-k)))
	   (setq sum (psplus sum c)
		 k (1+ k) kr (e+ kr inc))
	   (go a)
	 add-term 
	  (and (null (rczerop sum))
	       (add-term-&-pop a mr (pstimes ma0 sum)))
	  (setq m (1+ m) mr (e+ mr inc))
	 (go b)
	 end (return (pscheck varh (list trunc) (cdr ans)))))

(defun psderivative (p v)
    (cond ((pscoefp p) (rcderiv p v))
	  ((eq v (gvar p))
	   (psderiv1 (gvar-o p)
		     (trunc-lvl p) (cons 0 (terms p)) (list 0)))
	  (t (psderiv2 (gvar-o p)
		       (trunc-lvl p) v (cons 0 (terms p)) (list 0)))))

(defun psderiv1 (varh trunc l ans)
       (do ((a (last ans)))
	   ((or (mono-term? l) (e> (le (n-term l)) trunc))
	    (pscheck varh (list (e1- trunc)) (cdr ans)))
	   (setq l (n-term l))
	   (when (null (rczerop (le l)))
		 (add-term-&-pop a (e1- (le l)) (pstimes (le l) (lc l))))))

(defun psderiv2 (varh trunc v l ans)
       (do ((a (last ans) (n-term a)) (c))
	   ((or (mono-term? l) (e> (le (n-term l)) trunc))
	    (pscheck varh (list trunc) (cdr ans)))
	   (setq l (n-term l))
	   (or (rczerop (setq c (psderivative (lc l) v)))
	       (add-term a (le l) c))))

(defun psdp (p)
  (let (temp temp2)
   (cond ((pscoefp p) (rcderivx p))
	 ((or (rczerop (setq temp (getdiff (gvar-o p))))
	      (eq (car temp) 'MULTI))
	  (setq temp2 (psdp2 (gvar-o p) (trunc-lvl p)
			     (cons 0 (terms p)) (list 0)))
	  (if (eq (car temp) 'MULTI)
	      (pstimes temp2
		       (make-ps (gvar-o p) (ncons (inf))
				(list (term (cdr temp) (rcone)))))
	      temp2))
	 (t (psdp1 (gvar-o p)
		   (trunc-lvl p) (cons 0 (terms p))
		   (list 0) temp)))))

(defun psdp1 (varh trunc l ans dx)
       (do ((a (last ans)) (c (rczero)))
	   ((or (mono-term? l) (e> (le (n-term l)) trunc))
	    (psplus c (pscheck varh (list (e1- trunc)) (cdr ans))))
	   (setq l (n-term l))
	   (if (rczerop (le l)) (setq c (psdp (lc l)))
	       (add-term-&-pop
		a (e1- (le l)) (pstimes (le l) (pstimes dx (lc l)))))))

(defun psdp2 (varh trunc l ans)
       (do ((a (last ans)) (c))
	   ((or (mono-term? l) (e> (le (n-term l)) trunc))
	    (pscheck varh (list trunc) (cdr ans)))
	   (setq l (n-term l))
	   (when (null (rczerop (setq c (psdp (lc l)))))
		 (add-term-&-pop a (le l) c))))

;;; Currently unused
;;;
;;; (defun psintegrate (p v)
;;;    (cond ((rczerop p) (rczero))
;;;	  ((pscoefp p)
;;;	   (pstimes p (taylor2 (get-inverse (car v)))))
;;;	  ((eqgvar v (gvar-o p))
;;;	   (psinteg1 (gvar-o p)
;;;		     (trunc-lvl p) (cons 0 (terms p)) (list 0)))
;;;	  (t (psinteg2 (gvar-o p)
;;;		       (trunc-lvl p) v (cons 0 (terms p)) (list 0)))))
;;;
;;; (defun psinteg1 (varh trunc l ans)
;;;       (prog (a)
;;;	     (setq a (last ans))
;;;	a    (if (or (null (n-term l)) (e> (le (n-term l)) trunc))
;;;		 (go end)
;;;		 (add-term a (e1+ (le (setq l (n-term l))))
;;;			   (pstimes (le l)
;;;				    (if (e= (le l) (rcmone))
;;;					(prep1 (list '(%LOG)
;;;						     (get-inverse
;;;						      (car varh))))
;;;					(lc l))))
;;;		 (setq a (n-term a)))
;;;	     (go a)
;;;        end  (return (pscheck varh (list (e1+ trunc)) (cdr ans)))))
;;;
;;; (defun psinteg2 (varh trunc v l ans)
;;;        (prog (a)
;;; 	     (setq a (last ans))
;;;     a    (if (or (null (n-term l)) (e> (le (n-term l)) trunc))
;;;		 (go end)
;;;		 (add-term a (le l)
;;;			   (psintegrate (lc (setq l (n-term l))) v))
;;;		 (setq a (n-term a)))
;;;	     (go a)
;;;	end  (return (pscheck varh (list trunc) (cdr ans)))))

(defun psexpt-log-ord (p)
       (cond ((null $maxtayorder) (emin (trunc-lvl p) (t-o-var (gvar p))))
	     ((infp (trunc-lvl p)) (t-o-var (gvar p)))
	     (t (trunc-lvl p))))

(defun psexpt-fn (p)
  (cond ((pscoefp p) (psexpt-fn2 (rdis p)))
	((e> (rczero) (ps-le p))  (essen-sing-err))
	((null (cdr (terms p)))
	 (get-series '%EX (psexpt-log-ord p) (gvar-o p)
		     (ps-le p) (ps-lc p)))
	((e= (rczero) (ps-le p))
	 (pstimes (psexpt-fn2 (srdis (lc (terms p))))
		  (psexpt-fn (pscheck (gvar-o p) (list (trunc-lvl p))
				      (n-term (terms p))))))
	(t (prog (l le inc trunc lt ea0 ans)
   	    (setq l (terms p) le (le l) lt (lt l)
		  trunc (trunc-lvl p) inc (psexpon-gcd l))
	    (cond ((e> (rczero) le)
		   (essen-sing-err))
		  ((e> le (rczero))
		   (setq ea0 (rcone)))
		  (t (setq ea0 (psexpt-fn
				(setq lt (pscheck (gvar-o p)
						  (list trunc)
						  (list lt))))))) 
	    (setq ans
		  (if (or (pscoefp ea0) (null (eq (gvar p) (gvar ea0))))
		      (list 0 (term (rczero) ea0))
		      (cons 0 (terms ea0))))
	    (ifn $maxtayorder (setq trunc (emin trunc (t-o-var (gvar p)))))
	    (ifn trunc (infin-ord-err))
	    (return (psexpt-fn1 (gvar-o p) trunc l inc 1 inc ans))))))

(defun psexpt-fn1 (varh trunc l inc m mr ans)
       (declare (fixnum m k))
       (prog (a k ak cm-k c sum kr lim)
           ;; truly unfortunate that we need so many variables in this hack
	   ;; 
	   (setq a (last ans))
	 b (and (e> mr trunc) (go end))
	   (setq kr inc ak l k 1 sum (rczero) lim m)
	 a (cond ((or (> k lim)
		      (null (setq cm-k (psterm (cdr ans) (e- mr kr)))))
		  (go add-term)))
	   (setq ak (or (pstrim-terms ak kr)
			(go add-term))
		 c (pstimes (ereduce k m)
			    (pstimes (psterm1 ak kr) cm-k))
		 sum (psplus sum c))
	   (setq k (1+ k) kr (e+ kr inc))
	   (go a)
	 add-term 
	   (when (null (rczerop sum)) (add-term-&-pop a mr sum))
	   (setq m (1+ m) mr (e+ mr inc))
	   (go b)
	 end
	   (return (pscheck varh (list trunc) (cdr ans)))))

;;; PSEXPT-FN2 and RED-MONO-LOG are needed to reduce exponentials of logs.

(defun psexpt-fn2 (p)
   (cond ((atom p) (prep1 `((MEXPT) $%E ,p)))
	 ((eq (caar p) '%LOG)
	  (if (get-datum (cadr p)) (taylor2 (cadr p)) (prep1 (cadr p))))
	 ((or (eq (caar p) 'MPLUS) (eq (caar p) 'MTIMES))
	  (let ((e ($ratexpand p)) temp)
	       (if (eq (caar e) 'MPLUS)
		   (do ((sumnds (cdr e) (cdr sumnds))
			(log-facs) (l))
		       ((null sumnds)
			(ifn log-facs (tsexpt '$%E p)
			     (tstimes (cons (m^t '$%E (m+l l)) log-facs))))
		       (if (setq temp (red-mono-log (car sumnds)))
			   (push temp log-facs)
			   (push (car sumnds) l)))
		   (setq temp (red-mono-log e)) 
		   (if temp (taylor2 temp) (prep1 (power '$%E p))))))
	 (t (prep1 (power '$%E p)))))

(defun red-mono-log (e)
   (cond ((atom e) ())
	 ((eq (caar e) '%LOG) (cadr e))
	 ((mtimesp e)
	  (do ((facs (cdr e) (cdr facs)) (log-term))
	      ((null facs)
	       (when log-term
		     (m^t (cadr log-term) (m*l (remq log-term (cdr e))))))
	      (if (and (null (atom (car facs))) (eq (caaar facs) '%LOG))
		  (if log-term (return ()) (setq log-term (car facs)))
		  (ifn (mfree (car facs) tvars) (return () )))))
	 (t ())))


(defun pslog (p)
   (if (pscoefp p) (pslog2 (rdis p))
       (let ((terms (terms p)))
	  (cond ((mono-term? terms)
		 (if $TAYLOR_LOGEXPAND
		     (psplus (pslog (lc terms))
			     (rctimes (le terms)
				      (pslog2
				       (get-inverse (gvar p)))))
		     (prep1 `((%LOG) ,(term-disrep (lt terms) p)))))
		((null (or (n-term (setq terms (terms (psplus p (rcmone)))))
			   (e> (rczero) (le terms))))
		 (get-series '%LOG (psexpt-log-ord p) (gvar-o p)
			     (le terms) (lc terms)))
		(T (prog (l inc trunc lt ans lterm $maxtayorder)
		    (setq trunc (trunc-lvl p)
			  lterm (pslog
				 (setq lt (pscheck (gvar-o p)
						   (ncons trunc)
						   (ncons (ps-lt p)))))
			  p (pstimes p (let (($maxtayorder t))
					  (psexpt lt (rcmone)))))
		    (if (pscoefp p) (return lterm))
		    (setq l (terms p) inc (psexpon-gcd l)
			  l (n-term l)		;;;forget about 1, log(1+x).
			  ans
			  (cond ((rczerop lterm) (ncons 0))
				((or (pscoefp lterm)
				     (null (eq (gvar p) (gvar lterm))))
				 (list 0 (term (rczero) lterm)))
				(t (cons 0 (terms lterm)))))
		    (ifn $maxtayorder
			 (setq trunc (emin trunc (t-o-var (gvar p)))))
		    (return (pslog1 (gvar-o p) trunc l inc 1 inc ans))))))))

(defun pslog1  (varh trunc l inc m mr ans)
       (declare (fixnum m k))
       (prog (a k ak cm-k c sum kr m-kr)
	   ;; truly unfortunate that we need so many variables in this hack
	   ;; 
	   (setq a (last ans))
	 b (and (e> mr trunc) (go end))
	   (setq kr inc ak l k 1 sum (rczero))
	 a (cond ((or (= k m)
		      (null (setq cm-k (psterm (cdr ans)
					       (setq m-kr (e- mr kr))))))
		  (go add-term)))
	   (setq ak (or (pstrim-terms ak kr)
			(go add-term))
		 c (pstimes m-kr (pstimes (psterm1 ak kr) cm-k))
		 sum (psplus sum c)
		 k (1+ k) kr (e+ kr inc))
	   (go a)
	 add-term 
	   (cond ((setq c (pstrim-terms ak mr))
		  (setq c (psterm1 c mr)))
		 ((setq c (rczero))))		
	   (setq sum (psdiff c (pstimes sum (e// mr))))
	   (when (null (rczerop sum)) (add-term-&-pop a mr sum))
	   (setq m (1+ m) mr (e+ mr inc))
	   (go b)
	 end
	   (return (pscheck varh (list trunc) (cdr ans)))))

(defun pslog2 (p) (let ($logarc) (pslog3 p)))

(defun pslog3 (p)
       (cond ((atom p)
	      (prep1 (cond ((equal p 1) 0)
			   ((equal p -1) log-1)
			   ((eq p '$%I) log%i)
			   ((eq p '$%E) 1)
			   ((and (get-datum p)
				 (switch 'MULTIVAR (get-datum p)))
			    0)
			   (t (list '(%LOG) p)))))
	     ((eq (caar p) 'RAT)
	      (prep1 (ifn $TAYLOR_LOGEXPAND `((%LOG) ,p)
			  (m- `((%LOG) ,(cadr p)) `((%LOG) ,(caddr p))))))
	     ((and full-log (null (free p '$%I)))
	      (let ((full-log))
		    (pslog3 ($polarform p))))
	     ((eq (caar p) 'MEXPT)
	      (if (and (atom (cadr p)) (mnump (caddr p)) (get-datum (cadr p)))
		  (let ((e (taylor2 p)))
		       (if (rczerop e) (prep1 `((%LOG) ,p))	;Crock
			   (pstimes (ps-le e)
				    (psplus (pslog3 (psdisrep (lc (terms e))))
					    (prep1
					     `((%LOG) ,(get-inverse
							(gvar e))))))))
		  (pstimes (taylor2 (caddr p)) (pslog3 (cadr p)))))
	     ((and (eq (caar p) 'MTIMES) $TAYLOR_LOGEXPAND)
	      (do ((l (cddr p) (cdr l))
		   (ans (pslog3 (cadr p)) (psplus ans (pslog3 (car l)))))
		  ((null l) ans)))
	     (t (prep1 `((%LOG) ,p)))))

		(Comment Subtitle Extending Routines)

(defun getfun-lt (fun)
   (let ((exp-datum (get (oper-name fun) 'EXP-FORM)))
	(cond (exp-datum
		   ;; Info not needed yet.
		   ;; (or (atom (car exp-datum))
		   ;;     (setq 0p-funord (copy (cdar exp-datum))))
	       (exp-datum-lt fun exp-datum))
	      ((setq exp-datum (get (oper-name fun) 'SP2))
	       (setq exp-datum (get-lexp (subst (dummy-var) 'SP2VAR exp-datum)
					 (rcone) ()))
		   ;; Info not needed yet; need to bind lexp-non0 to T when
		   ;; this is used though so n-term will be there.
		   ;; (and (rczerop (le exp-datum))
		   ;;      (setq 0p-funord (le (n-term exp-datum))))
	       (if (psp exp-datum) (ps-lt exp-datum)
		   (term (rczero) exp-datum)))
	      (t (merror "~&~A---Unknown function in getfun-lt~%" fun)))))

(declare (special var))

(defun getexp-fun (fun var pw)
   (let ((exp-datum (copy (get (oper-name fun) 'EXP-FORM))))
	(cond ((infp pw) (infin-ord-err))
	      ((null exp-datum)
	       (if (setq exp-datum (get-ps-form fun))
		   (ts-formula exp-datum var pw)
		   (merror "~&~A---power series unavailable, internal error~%"
			   fun)))
	      ((e> (exp-datum-le fun exp-datum) pw) (pszero var pw))
	      ((setq exp-datum
		     (apply (exp-fun exp-datum)
			    (if (atom fun) (cons pw (cdr exp-datum))
				(cons pw (cons (cdr fun) (cdr exp-datum))))))
	       (cond ((null exp-datum) (pszero var pw))
		     ((psp exp-datum) exp-datum)
		     (t (make-ps var (ncons pw) exp-datum)))))))

(declare (unspecial var))
		      
(defun EXPEXP-FUNS (pw l sign chng inc)
       (prog (e lt-l)
	     (setq e (e l) lt-l (setq l (ncons l)))
        a    (cond ((e> (setq e (e+ e inc)) pw) (return l))
		   (t (add-term-&-pop
		       lt-l
		       e
		       (rctimes (e// sign
				     (cond ((e= inc (rcone)) e)
					   ((e* e (e1- e)))))
				(cons 1 (cdr (lc lt-l)))))
		      (setq sign (e* sign chng))))
	     (go a)))

(defun EXPLOG-FUNS (pw l sign chng inc)
       (prog (e lt-l)
	     (setq e (e l) lt-l (setq l (ncons l)))
	a    (cond ((e> (setq e (e+ e inc)) pw) (return l))
		   (t (add-term lt-l e (e// sign e))
		      (setq lt-l (n-term lt-l)
			    sign (e* sign chng))))
	     (go a)))

(defun EXPTAN-FUNS (pw l chng)
       (prog (e lt-l sign fact pow)
	     (setq e (e l) lt-l (setq l (ncons l))
		   sign (rcone) fact '(1 . 2) pow '(4 . 1))
	a    (cond ((e> (setq e (e+ (rctwo) e)) pw) (return l))
		   (t (setq fact (e// fact (e* e (e1+ e)))
			    pow (e* '(4 . 1) pow)
			    sign (e* chng sign))
		      (add-term lt-l e (e* (e* sign fact)
					   (e* (prep1
						($bern (rcdisrep (e1+ e))))
					       (e* pow (e1- pow)))))
		      (setq lt-l (n-term lt-l))))
	     (go a)))

(defun EXPCOT-FUNS (pw l sign chng plus)
       (prog (e lt-l fact pow)
	     (setq e (e l) lt-l (setq l (ncons l))
		   fact (rcone) pow (rcone))
	a    (cond ((e> (setq e (e+ (rctwo) e)) pw) (return l))
		   (t (setq fact (e// fact (e* e (e1+ e)))
			    pow (e* '(4 . 1) pow)
			    sign (e* chng sign))
		      (add-term lt-l e (e* (e* sign fact)
					   (e* (prep1
						($bern (rcdisrep (e1+ e))))
					       (e+ pow plus))))
		      (setq lt-l (n-term lt-l))))
	     (go a)))

(defun EXPSEC-FUNS (pw l chng)
       (prog (e lt-l sign fact)
	     (setq e (e l) lt-l (setq l (ncons l))
		   sign (rcone)  fact (rcone))
	a    (cond ((e> (setq e (e+ (rctwo) e)) pw) (return l))
		   (t (setq fact (e// fact (e* e (e1- e)))
			    sign (e* chng sign))
		      (add-term lt-l e (e* (e* sign fact)
					   (prep1 ($euler (rcdisrep e)))))
		      (setq lt-l (n-term lt-l))))
	     (go a)))

(defun EXPASIN-FUNS (pw l chng)
       (prog (e lt-l sign n d)
	     (setq e (e l) lt-l (setq l (ncons l)) sign 1 n 1 d 1)
	a    (cond ((e> (setq e (e+ (rctwo) e)) pw) (return l))
		   (t (setq n (times n (car (e- e (rctwo))))
			    d (times d (car (e1- e)))
			    sign (times sign chng))
		      (add-term lt-l e  ; need to reduce here ? - check this.
				(let ((x (*red (times n sign)
					      (times d (car e)))))
				     (if (atom x) x
					 (cons (cadr x) (caddr x)))))
		      (setq lt-l (n-term lt-l))))
	     (go a)))

;;; This is the table of expansion data for known functions.
;;; The format of the EXP-FORM property is as follows:
;;;	(<name of the expanding routine for the function or
;;;	  (name . le of n-term) if expansion is of order 0>
;;;      <first term in the expansion or the name of a routine which
;;;	  computes the order when it may depend on parameters (e.g subsripts)>
;;;      <data for the expanding routine>)

(map2c
 '(lambda (fun exp) (putprop fun exp 'EXP-FORM))
 '(%EX    ((EXPEXP-FUNS 1 . 1) ((0 . 1) 1 . 1) (1 . 1) (1 . 1) (1 . 1))
   %SIN   (EXPEXP-FUNS ((1 . 1) 1 . 1) (-1 . 1) (-1 . 1) (2 . 1))
   %COS   ((EXPEXP-FUNS 2 . 1) ((0 . 1) 1 . 1) (-1 . 1) (-1 . 1) (2 . 1))
   %SINH  (EXPEXP-FUNS ((1 . 1) 1 . 1) (1 . 1) (1 . 1) (2 . 1))
   %COSH  ((EXPEXP-FUNS 2 . 1) ((0 . 1) 1 . 1) (1 . 1) (1 . 1) (2 . 1))
   %LOG   (EXPLOG-FUNS ((1 . 1) 1 . 1) (-1 . 1) (-1 . 1) (1 . 1))
   %ATAN  (EXPLOG-FUNS ((1 . 1) 1 . 1) (-1 . 1) (-1 . 1) (2 . 1))
   %ATANH (EXPLOG-FUNS ((1 . 1) 1 . 1) (1 . 1) (1 . 1) (2 . 1))
   %COT   (EXPCOT-FUNS ((-1 . 1) 1 . 1) (1 . 1) (-1 . 1) (0 . 1))
   %CSC   (EXPCOT-FUNS ((-1 . 1) 1 . 1) (-1 . 1) (-1 . 1) (-2 . 1))
   %CSCH  (EXPCOT-FUNS ((-1 . 1) 1 . 1) (-1 . 1) (1 . 1) (-2 . 1))
   %COTH  (EXPCOT-FUNS ((-1 . 1) 1 . 1) (1 . 1) (1 . 1) (0 . 1))
   %TAN   (EXPTAN-FUNS ((1 . 1) 1 . 1) (-1 . 1))
   %TANH  (EXPTAN-FUNS ((1 . 1) 1 . 1) (1 . 1))
   %SEC   ((EXPSEC-FUNS 2 . 1) ((0 . 1) 1 . 1) (-1 . 1))
   %SECH  ((EXPSEC-FUNS 2 . 1) ((0 . 1) 1 . 1) (1 . 1))
   %ASIN  (EXPASIN-FUNS ((1 . 1) 1 . 1) 1)
   %ASINH (EXPASIN-FUNS ((1 . 1) 1 . 1) -1)
   %GAMMA (EXPGAM-FUN ((-1 . 1) 1 . 1))
   $PSI   (EXPPLYGAM-FUNS plygam-ord)))

(defun known-ps (fun) (getl fun '(EXP-FORM SP2)))

	        (comment Autoload Properties)

#+ITS (mautoload '(fasl dsk maxout)
		 (plygam EXPGAM-FUN EXPPLYGAM-FUNS PLYGAM-POLE GAM-CONST
			 PLYGAM-CONST BETA-TRANS))

		(comment Taylor series expansion routines)

(defun srf (x) (let ((exact-poly t))
		    (taylor1 x ())))

;;; [var, pt, order, asymp]

(defmfun $taylor n
   (if (= n 0) (wna-err '$taylor))
   (taylor* (arg 1) (listify (- 1 n))))

(defun taylor* (arg l)
  (let (tlist $maxtayorder (exact-poly
			    (ifn l 'User-specified
				 (not $taylor_truncate_polynomials))))
     (parse-tay-args l)
     (taylor1 arg (ncons tlist))))

(defun tay-order (n)
       (let (($float) (modulus))
	  (cond ((eq n '$INF) (ncons (inf)))
		((null n) (wna-err '$taylor))
		((null (mnump n))
		 (merror "~&~:M---non-numeric expansion order~%" n))
		(t (ncons (prep1 n))))))

(defun re-erat (head exp)
       (taylor1 exp (list (cadddr (cdr head)))))

(defun parse-tay-args (l)
       (cond ((null l))
	     ((symbolp (car l))
	      (parse-tay-args1
	       (list (car l) ($ratdisrep (cadr l)) (caddr l)))
	      (parse-tay-args (cdddr l)))
	     ((or (numberp (car l)) (null (eq (caaar l) 'MLIST)))
	      (merror "Variable of expansion not atomic: ~M"
		      (CAR L)))
	     ((do ((l (cddar l) (cdr l)))
		  ((null l) ())
		  (and (or (mnump (car l)) (eq (car l) '$INF))
		       (return t)))
	      (parse-tay-args1 (cdar l))
	      (parse-tay-args (cdr l)))
	     (t (parse-tay-args2 (list (car l) (cadr l) (caddr l)))
		(parse-tay-args (cdddr l)))))

(defun parse-tay-args1 (l)
       (if ($listp (car l)) (parse-tay-args2 l)
	   (let ((v (car l))
		 (pt ($ratdisrep (cadr l)))
		 (ord (tay-order (caddr l)))
		 (switches (make-switch-list (cdddr l))))
		(setq tlist (cons (list v ord pt switches) tlist)))))

(defun parse-tay-args2 (l)
       (let ((label (gensym))
	     (vs (cdar l))
	     (pts (make-long-list (if ($listp (cadr l))
				      (append (cdadr l) nil)
				      (ncons (ratdisrep (cadr l))))))
	     (ord (caddr l))
	     (switches (make-switch-list (cdddr l)))
	     (lcm 1)
	     (max 0))
	    (if (atom ord)
		(setq lcm ord max ord ord (make-long-list (ncons ord)))
		(do ((a vs (cdr a))
		     (l (cdr ord) (cdr l)))
		    ((null a) (setq ord (cdr ord)))
		    (ifn l (merror "Ran out of truncation levels")
			 (setq lcm (lcm lcm (car l))
			       max (max max (car l))))))
	    (setq tlist (cons (list label (tay-order max) 0
				    (ncons (list 'MULTIVAR lcm vs)))
			      tlist))
	    (do ((vl vs (cdr vl))
		 (ordl ord (cdr ordl))
		 (ptl pts (cdr ptl)))
		((null vl))
		(ifn ptl (merror "~&Ran out of matching pts of expansion~%")
		     (setq tlist
			   (cons
			    (list (car vl) (tay-order (car ordl)) (car ptl)
				  (cons (list 'MULTI label
					      (timesk lcm
						      (expta (car ordl) -1)))
					switches))
			    tlist))))))

(defun make-switch-list (l) (mapcar #'(lambda (q) (cons q t)) l))

(defun make-long-list (q) (nconc q q))

(defun ratwtsetup (l)
       (do ((l l (cdr l))
	    (a) (sw))
	   ((null l))
	   (setq a (switch 'MULTIVAR (car l)))
	   (and a
	    (do ((ll (cadr a) (cdr ll)))
		((null ll))
		(cond ((equal (cadr (switch 'MULTI (get-datum (car ll)))) 1))
		      (sw (merror "Can't have two sets of multi dependent
variables which require different orders of expansion"))
		      (T (setq sw t) (return t)))))))

(defun taylor1 (e tlist)
  (setq tlist (tlist-merge (nconc (find-tlists e) tlist)))
  (prog ($zerobern $simp $algebraic genpairs varlist tvars
	 log-1 log%i ivars key-vars ans full-log last-exp
	 mainvar-datum)
	(setq $zerobern t $simp t $algebraic t last-exp e
	      log-1 '((%LOG SIMP) -1) log%i '((%LOG SIMP) $%I)
	      varlist (copy1* (setq tvars (mapcar 'car tlist))))
	(orderpointer varlist)
	(setq ivars
	      (maplist 
	       #'(lambda (q g)
		   (setq key-vars (cons (cons (car g) (car q)) key-vars))
		   (let ((data (get-datum (car q))))
			 (prog1
			    (cons (car g)
				  (car
				   (cond ((and (signp e (exp-pt data))
					       (null (switch '$ASYMP data)))
					  q)	;Simple case
					 ((memq (exp-pt data) '($INF INFINITY))
					  (rplaca q (m^ (car q) -1)))
					 ((eq (exp-pt data) '$MINF)
					  (rplaca q (m- (m^ (car q) -1))))
					 ((rplaca q
				      (let ((temp
					      (m- (car q) (exp-pt data))))
					    (cond ((switch '$ASYMP data)
						   (m^ temp -1))
						  (temp))))))))
			    (rplacd (cdddr data)
				    (cons (car g) (symeval (car g)))))))
	       varlist
	       (do ((v varlist (cdr v))
		    (g genvar (cdr g)))
		   ((eq (car v) (car tvars)) g))))
	(setq genpairs (mapcar #'(lambda (y z)
				   (putprop z y 'DISREP)
				   (cons y (cons (pget z) 1)))
			       varlist genvar))
	(ratwtsetup tlist)
	(ratsetup varlist genvar)
	(setq mainvar-datum (car (last tlist)))
	(setq ans (*catch 'tay-err (taylor3 e)))
	(return
	 (if (atom (car ans)) (tay-error (car ans) (cadr ans)) ans))))

(defun taylor3 (e)
       (cond ((mbagp e) (cons (car e) (mapcar #'TAYLOR3 (cdr e))))
	     ((and (null tlist) (not (eq exact-poly 'User-specified)))
	      (xcons (prep1 e)
		     (list 'MRAT 'SIMP varlist genvar)))
	     (t (xcons (taylor2 e)
		       (list 'MRAT 'SIMP varlist genvar tlist 'TRUNC)))))

(defun find-tlists (e) (let (*a*) (findtl1 e) *a*))

(defun findtl1 (e)
  (cond ((or (atom e) (mnump e)))
	((eq (caar e) 'MRAT)
	 (cond ((memq 'TRUNC (car e))
		(setq *a* (cons
			   (mapcar #'(lambda (q) (copy q)) ; This is a macro!!!
				   (cadddr (cdar e))) *a*)))))
	(t (mapc 'FINDTL1 (cdr e)))))

(defun tlist-merge (l)
    (do ((l l (cdr l))
	 (tlist))
	((null l) (nreverse tlist))
	(do ((ll (car l) (cdr ll))
	     (temp))
	    ((null ll))
	    (ifn (setq temp (assoc (caar ll) tlist))
		 (setq tlist (cons (list (caar ll) (cadar ll)
					 (caddar ll) (cadddr (car ll)))
				   tlist))
		 (or (e> (caadar ll) (caadr temp))
		     (rplaca (cdr temp) (cadar ll)))
		 (or (alike1 (caddr temp) (caddar ll))
		     (merror "Cannot combine two expressions
expanded at different points"))
		 (rplaca (cdddr temp) (union* (switches temp)
					      (car (cdddar ll))))))))

(defun compattlist (list)
       (do ((l list (cdr l)))
	   ((null l) t)
	   (or (alike1 (exp-pt (get-datum (caar l)))
		       (exp-pt (car l)))
	       (return ()))))

(defun taylor2  (e)
 (let ((last-exp e))	    ;; lexp-non0 should be bound here whene needed
  (cond ((assolike e tlist) (var-expand e 1))
	((or (mnump e) (atom e) (mfree e tvars))
	 (if (e> (rczero) (current-trunc mainvar-datum))
	     (pszero (data-gvar-o mainvar-datum)
		     (current-trunc mainvar-datum))
	     (prep1 e)))
	((null (atom (caar e))) (merror "Bad arg TAYLOR2 - internal error"))
	((eq (caar e) 'MRAT)
	 (if (and (memq 'TRUNC (car e))
		  (compatvarlist varlist (caddar e)
				 genvar (cadddr (car e)))
		  (compattlist (cadddr (cdar e))))
	     (cdr e)
	     (let ((exact-poly))
		  (taylor2 ($ratdisrep e)))))
	((eq (caar e) 'MPLUS) (tsplus (cdr e)))
	((eq (caar e) 'MTIMES) (tstimes (cdr e)))
	((eq (caar e) 'MEXPT) (tsexpt (cadr e) (caddr e)))
	((eq (caar e) '%LOG) (tslog (cadr e)))
	((and (or (known-ps (caar e)) (get (caar e) 'TAY-TRANS))
		  (not (memq 'array (cdar e))))
	     (expand (ifn (cddr e) (cadr e) (cdr e))
		     (caar e)))
	((and (mqapplyp e)
	      (cond ((get (subfunname e) 'SPEC-TRANS)
		     (funcall (get (subfunname e) 'SPEC-TRANS) e))
		    ((known-ps (subfunname e))
		     (expand (caddr e) (cadr e))))))
	((memq (caar e) '(%SUM %PRODUCT)) (tsprsum (cadr e) (cddr e) (caar e)))
	((eq (caar e) '%DERIVATIVE) (tsdiff (cadr e) (cddr e) e))
	((or (eq (caar e) '%AT)
	     (do ((l (mapcar 'car tlist) (cdr l)))
		 ((null l) t)
		 (or (free e (car l)) (return ()))))
	 (newsym e))
	(t (let ((exact-poly))		;Taylor series aren't exact
	        (taylor2 (diff-expand e tlist)))))))

(defun compatvarlist (a b c d)
       (cond ((null a) t)
	     ((or (null b) (null c) (null d)) nil)
	     ((alike1 (car a) (car b))
	      (cond ((not (eq (car c) (car d))) nil)
		    (t (compatvarlist (cdr a) (cdr b) (cdr c) (cdr d)))))
	     (t (compatvarlist a (cdr b) c (cdr d)))))

(defun var-expand (var exp)
  (let (($keepfloat) ($float) (modulus))
       (setq exp (prep1 exp)))		;;;exp must be a rat-num
  (let ((temp (get-datum var)))
       (cond ((null temp) (merror "Invalid call to var-expand"))
	     ((switch 'MULTI temp)
	      (psexpt (pstimes (taylor2 (car (switch 'MULTI temp)))
			       (cons (list (int-gvar temp) 1 1) 1))
		      exp))
	     ((signp e (exp-pt temp))
	      (if (e> exp (current-trunc temp)) (rczero)
		  (make-ps (int-var temp)
			   (ncons (if exact-poly (inf) (current-trunc temp)))
			   (ncons (term (if (switch '$ASYMP temp)
					    (rcminus exp)
					    exp)
					(rcone))))))
	     ((memq (exp-pt temp) '($INF $MINF $INFINITY))
	      (cond ((switch '$ASYMP temp)
		     (merror
		      "Cannot create an asymptotic expansion at infinity"))
		    ((e> (setq exp (rcminus exp)) (current-trunc temp))
		     (rczero))
		    (t (make-ps (int-var temp)
				(ncons (if exact-poly (inf) (current-trunc temp)))
				(ncons (term exp
					     (if (eq (exp-pt temp) '$MINF)
						 (rcmone)
						 (rcone))))))))
	     (t (psexpt (psplus
			 (make-ps (int-var temp)
				  (ncons (if exact-poly (inf) (current-trunc temp)))
				  (ncons (term (if (switch '$ASYMP temp)
						   (rcmone)
						   (rcone))
					       (rcone))))
			 (taylor2 (exp-pt temp)))
			exp)))))

(defun expand (arg func)
   (prog (funame funord fun-lc argord psarg arg-trunc temp)
      ;; Since only fixnum subscripted polygamma functions are supported,
      ;; try diff-expanding anything with non-integral subscripts
      (ifn (or (atom func) (integer-subscriptp func))
	   (taylor2 (diff-expand `((MQAPPLY) ,func ,arg) tlist)))
      (if (setq temp (get (setq funame (oper-name func)) 'TAY-TRANS))
	  (return (funcall temp arg func)))
      (let ((lterm (getfun-lt func)))
	   (setq funord (e lterm) fun-lc (c lterm)))
      (if (rczerop (setq psarg (get-lexp arg (rcone) () )))
	  (return (cond ((e> (rczero) funord) (tay-depth-err))
			((setq temp (assq funame TAY-POLE-EXPAND))
			 (funcall (cdr temp) arg psarg func))
			((rczerop funord) fun-lc)
			(t (rczero)))))
      (when (pscoefp psarg) (setq psarg (taylor2 arg)))
      (when (pscoefp psarg)
	    (return
	     (cond ((null (mfree (rdis psarg) tvars))
		    (symbolic-expand arg psarg func))
		   ((setq temp (assq funame TAY-POLE-EXPAND))
		    (funcall (cdr temp) arg psarg func))
		   (t (prep1 (simplify
			      (if (atom func) `((,func) ,(rcdisrep psarg))
				  `((MQAPPLY) ,func ,(rcdisrep psarg)))))))))
      (when (e> (rczero) (setq argord (le (terms psarg))))
	    (if (memq funame '(%ATAN %ASIN %ASINH %ATANH))
		(return (atrigh arg func))
		(essen-sing-err)))
      (setq temp (t-o-var (gvar psarg)))
      (when (e> (e* funord argord) temp) (return (rczero)))
      ;; The following form need not be executed if psarg is really exact.
      ;; The constant problem does not allow one to determine this now,
      ;; so we always have to execute this currently.
      ;; This really should be 
      ;; (unless (infp (trunc-lvl psarg)) ... )
      ;; Likewise, the infp checks shouldn't be there; have to assume
      ;; nothing is exact until constant problem is fixed.
      (setq arg-trunc (if (and (not (infp (trunc-lvl psarg)))
			       (e= funord (rcone)))
			  temp
			  (e- temp (e* (e1- funord) argord)))
	    psarg (let-pw (get-datum (get-key-var (gvar psarg)))
			  arg-trunc
			  (if (or (infp (trunc-lvl psarg))
				  (e> arg-trunc (trunc-lvl psarg)))
			      (taylor2 arg)
			      (pstrunc psarg))))
      (return
       (cond
	((rczerop argord)
	 (setq temp (assq funame const-exp-funs))
	 (cond ((memq funame '(%ATAN %ASIN %ASINH %ATANH)) (atrigh arg func))
	       (temp (funcall (cdr temp) arg psarg func))
	       (T (exp-pt-err))))
	((prog2
	  (setq temp (current-trunc (get-datum (get-key-var (gvar psarg)))))
	  (mono-term? (terms psarg)))
	 (get-series func temp (gvar-o psarg) (ps-le psarg) (ps-lc psarg)))
	(T (setq temp (get-series func (e// temp argord) (gvar-o psarg)
				  (rcone) (rcone)))
	   (ifn (psp temp) temp (pscsubst1 psarg temp)))))))

(defun symbolic-expand (arg psarg func) ; should be much stronger
       arg ;Ignored.
       (prep1 (simplifya (if (atom func) `((,func) ,(rcdisrep psarg))
			     `((MQAPPLY) ,func ,(rcdisrep psarg)))
			 ())))

(defun trig-const (a arg func)
       (let ((const (ps-lc* arg)) (temp (cdr (assq func trigdisp))))
	    (cond ((and (pscoefp const)
			(memq func '(%TAN %COT))
			(multiple-%pi a (srdis const) func)))
		  (temp (funcall temp (setq const (psdisrep const))
				 (m- a const)))
		  (t (tsexpt `((,(get func 'RECIP)) ,(srdis arg)) -1)))))

(defun multiple-%pi (a const func)
  (let (coef)
    (and (equal ($hipow const '$%PI) 1)
	 (ratnump (setq coef ($ratcoef const '$%PI 1)))
	 (cond ((numberp coef) (expand (m- a const) func))
	       ((equal (caddr coef) 2)
		(psminus (expand (m- a const)
				 (cond ((eq func '%TAN) '%COT)
				       ((eq func '%COT) '%TAN)
				       (t (merror "Internal error in TAYLOR"
						  ))))))))))

(setq *pscirc '(%COT %TAN %CSC %SIN %SEC %COS %COTH
		%TANH %CSCH %SINH %SECH %COSH)

      *psacirc '(%ACOT %ATAN %ACSC %ASIN %ASEC %ACOS %ACOTH
		       %ATANH %ACSCH %ASINH %ASECH %ACOSH))

(setq const-exp-funs
      `((%GAMMA . GAM-CONST) ($PSI . PLYGAM-CONST)
	. ,(mapcar '(lambda (q) (cons q 'TRIG-CONST)) *pscirc))

      trigdisp '((%SIN . PSINA+B) (%COS . PSCOSA+B) (%TAN . PSTANA+B)
                 (%SINH . PSINHA+B) (%COSH . PSCOSHA+B) (%TANH . PSTANHA+B))
      
      tay-pole-expand '((%GAMMA . PLYGAM-POLE) ($PSI . PLYGAM-POLE))

      tay-const-expand ; !these should be handled by symbolic-expand
		       ; be sure to change this with tay-exponentialize!
      (append (mapcar '(lambda (q) (cons q 'TAY-EXPONENTIALIZE)) *PSCIRC)
	      (mapcar '(lambda (q) (cons q 'TAY-EXPONENTIALIZE)) *PSACIRC)))

(mapc '(lambda (q) (putprop q 'ATRIG-TRANS 'TAY-TRANS))
      '(%ACOS %ACOT %ASEC %ACSC %ACOSH %ACOTH %ASECH %ACSCH))

(defprop MFACTORIAL FACTORIAL-TRANS TAY-TRANS)

(defun factorial-trans (arg () ) ; ignore func
       (taylor2 `((%GAMMA) ,(m1+ arg))))

;;; Not done properly yet
;;;
;;; (defprop $BETA BETA-TRANS TAY-TRANS)

(defun psina+b (a b)
	(psplus (pstimes (expand a '%SIN) (expand b '%COS))
	        (pstimes (expand a '%COS) (expand b '%SIN))))

(defun pscosa+b (a b)
	(psdiff (pstimes (expand a '%COS) (expand b '%COS))
		(pstimes (expand a '%SIN) (expand b '%SIN))))

(defun pstana+b (a b)
	(setq a (expand a '%TAN) b (expand b '%TAN))
	(pstimes (psplus a b)
		 (psexpt (psdiff (rcone) (pstimes a b))
			 (rcmone))))

(defun psinha+b (a b)
	(psplus (pstimes (expand a '%SINH) (expand b '%COSH))
	        (pstimes (expand a '%COSH) (expand b '%SINH))))

(defun pscosha+b (a b)
	(psplus (pstimes (expand a '%COSH) (expand b '%COSH))
		(pstimes (expand a '%SINH) (expand b '%SINH))))

(defun pstanha+b (a b)
	(setq a (expand a '%TANH) b (expand b '%TANH))
	(pstimes (psplus a b)
		 (psexpt (psplus (rcone) (pstimes a b))
			 (rcmone))))

(defun atrig-trans (arg func)
       (taylor2
	(if (memq func '(%ACOS %ACOSH))
	    `((MPLUS)
	      ,HALF%PI
	      ((MTIMES) -1
			((,(cdr (assq func
				      '((%ACOS . %ASIN) (%ACOSH . %ASINH)))))
			 ,arg)))
	    `((,(cdr (assq func '((%ACSC . %ASIN) (%ASEC . %ACOS)
				  (%ACOT . %ATAN) (%ACSCH . %ASINH)
				  (%ASECH . %ACOSH) (%ACOTH . %ATANH)))))
	      ,(m^ arg -1)))))

(defun atrigh (arg func)
       (let ((full-log t) ($logarc t) (log-1 '((MTIMES) $%I $%PI))
	     (log%i '((MTIMES) ((RAT) 1 2) $%I $%PI)))
	    (taylor2 (simplify `((,func) ,arg)))))

(defun tay-exponentialize (arg fun) ; !this should be in symbolic-expand!
       (let (($EXPONENTIALIZE t) ($LOGARC t))
	     (setq arg (meval `((,fun) ,arg))))
       (taylor2 arg))

(defun tsplus (l)
       (do ((l (cdr l) (cdr l))
	    (ans (taylor2 (car l))
		 (psplus ans (taylor2 (car l)))))
	   ((null l) ans)))

(defun ts-formula (form var pw)
       (let ((datum (get-datum
		      (get-key-var (car var)))))
	    (let-pw datum pw (ts-formula1 form (car var)))))

(defun ts-formula1 (form gensym)
       (taylor2	(subst (get-inverse gensym) 'SP2VAR form)))

(defmacro next-series (l) `(cdadr ,l))

(defun tstimes-get-pw (l pw)
  (do ((l l (cdr l))
       (vect))
      ((null l) pw)
      (setq pw (mapcar #'(lambda (pwq ple) (e+ pwq ple))
		       pw
		       (setq vect (ord-vector (cdar l)))))
      (rplacd (car l) (cons (cdar l) vect))))

(defun tstimes-l-mult (a)
       (do ((l (cdr a) (cdr l)) ($maxtayorder t)
	    (a (car a) (pstimes a (car l))))
	   ((null l) a)))

(defun mzfree (e l)
       (do ((l l (cdr l)))
	   ((null l) t)
	   (or (zfree e (car l)) (return ()))))

;;; The lists posl, negl and  zerl have the following format:
;;;
;;;   ( (<expression> <expansion> <order vector>) . . . )

(defun tstimes (l)
  (*bind* ((funl) (expl) (negl) (zerl) (posl)
	   (pw) (negfl) (temp) (fixl (rcone)))
    (do ((l l (cdr l)))			;;; find the exponentials
	((null l) ())
	(if (mexptp (car l))
	    (setq expl (cons (if (free (caddar l) (car tvars)) (car l)
				 `((MEXPT) $%E ,(m* (caddar l)
						    `((%LOG) ,(cadar l)))))
			     expl))
	    (setq funl (cons (car l) funl))))
    (and expl
	(setq expl (tsexp-comb expl))		;;; simplify exps
	(setq expl (tsbase-comb expl)))		;;; and again
    (setq l (nconc expl funl))			;;; now try expanding
    (setq expl (cons 0 (mapcar #'(lambda (exp)
				   (cons exp (taylor2 exp)))
			       l))) 
    (do ((l expl) (tem))
	((null (cdr l)) ())
 	(cond ((rczerop (next-series l))
	       (cond ((null $maxtayorder)
		       (setq zerl (cons (cadr l) zerl))
		       (rplacd l (cddr l)))
		     ((rczerop (setq tem (get-lexp (caadr l) (rcone) ())))
		      (return (setq zerl 0)))
		     (t (setq posl (cons (cons (caadr l) tem) posl))
			(rplacd l (cddr l)))))
	      ((pscoefp (next-series l))
	       (cond ((mzfree (caadr l) tvars) ;must be zfree to permit ratfuns
		      (setq fixl (pstimes (next-series l) fixl))
		      (rplacd l (cddr l)))
		     ((setq zerl (cons (cadr l) zerl))
		      (rplacd l (cddr l)))))
	      ((rczerop (ps-le (next-series l)))
	       (setq zerl (cons (cadr l) zerl))
	       (rplacd l (cddr l)))
	      ((e> (ps-le (next-series l)) (rczero))
	       (setq posl (cons (cadr l) posl))
	       (rplacd l (cddr l)))
	      (t (setq l (cdr l)))))
    (and (equal zerl 0) (return (rczero)))
    (setq negl (cdr expl))
    (setq temp (ord-vector fixl))
    (mapcar #'(lambda (x) (and (e> (rczero) x) (setq negfl t))) temp)
    (tstimes-get-pw zerl temp)
    (setq pw (tstimes-get-pw posl (tstimes-get-pw negl temp)))
    (if (or negl negfl)
	(setq posl
	      (mapcar #'(lambda (x)
				(prog2 (mapcar #'(lambda (datum lel pwl)
						  (push-pw datum
							   (e+ (current-trunc datum)
							       (e- lel pwl))))
					       tlist (cddr x) pw)
				       (taylor2 (car x))
				       (mapcar #'(lambda (datum)
							 (pop-pw datum))
					       tlist)))
		      (nconc posl zerl negl)))
	(setq posl (nconc (mapcar 'cadr posl)
			  (mapcar 'cadr zerl)
			  (mapcar 'cadr negl))))
    (setq posl (tstimes-l-mult posl))
    (let ((ans (cond ((null fixl) posl)
		     ((null posl) fixl)
		     (t (pstimes fixl posl)))))
	 (if $maxtayorder ans (pstrunc ans)))))

;;; this routine transforms a list of exponentials as follows
;;; 
;;;	a^c*b^(n*c) ===> (a*b^n)^c
;;; 
;;; here n is free of var.
;;;this transformation is only applicable when c is not free of var

(defun tsexp-comb (l)	;;;*****clobbers l***** 
    (setq l (cons '* l))
    (do ((a l))		;;;updated by a rplacd or cdr.
	((null (cddr a)) (cdr l))	;;; get rid of the *
	(if (mfree (caddr (cadr a)) tvars) (pop a)
	    (do ((b (cddr a) (cdr b))
		 (n))
		((null b) (setq a (cdr a)))
		(setq n ($ratsimp (div* (caddar b) (caddr (cadr a)))))
		(cond ((mfree n tvars)	;;; we win
		       (rplaca b (list '(MEXPT SIMP)
				       (m* (cadadr a)
					   (m^ (cadar b) n))	;;;b^n
				       (caddr (cadr a))))
		       (rplacd a (cddr a))			;;; delete a^c
		       (return t)))))))

;;; this routine transforms a list of exponentials as follows:
;;; 
;;;	a^c*b^c ===> a^(b+c)
;;; 
;;; this is only necessary when b and c depend on "var."

(defun tsbase-comb (l)		;;; *******clobbers l********
    (setq l (cons '* l))
    (do ((a l))			;;; undated by a rplacd o cdr
	((null (cddr a)) (cdr l))
	(do ((b (cddr a) (cdr b)))
	    ((null b) (setq a (cdr a)))	;;; did not return early so cdr.
	    (cond ((alike1 (cadar b) (cadadr a))
		   (rplaca b
			   (m^ (cadar b) (m+ (caddar b) (caddr (cadr a)))))
		   (rplacd a (cddr a))
		   (return t))))))

(defun tsexpt (b e)
       (cond ((and (atom b) (mnump e))
	      (if (get-datum b) (var-expand b e) (prep1 (m^ b e))))
	     ((mfree e tvars) (tsexpt1 b e))
	     ((eq '$%E b) (tsexpt-red (list e)))
	     (t (tsexpt-red (list (list '(%LOG) b) e)))))

(defun tsexpt-red (l)
       (*bind* ((free) (nfree) (full-log) ($logarc t)
	      (log-1 '((MTIMES) $%I $%PI))
	      (log%i '((MTIMES) ((RAT) 1 2) $%I $%PI)))
	a    (do ((l l (cdr l)))
		 ((null l))
		 (cond ((mtimesp (car l))
			(setq l (append l (cdar l))))
		       ((mfree (car l) tvars)
			(push (car l) free))
		       (t (push (car l) nfree))))
	     (cond ((or (cdr nfree) (atom (car nfree)))
		    (psexpt-fn (taylor2 (m*l (append nfree free)))))
		   ((eq (caaar nfree) '%LOG)
		    (tsexpt1 (cadar nfree) (m*l free)))
		   ((memq (caaar nfree) *psacirc)	;Remove simp flag
		    (setq l (list (simplifya (cons (list (caaar nfree))
						   (cdar nfree))
					     ()))
			  nfree (cdr nfree))
		    (go a))
		   (t (psexpt-fn (taylor2 (m*l (append nfree free))))))))

(defun tsexpt1 (b e)
  (prog (s le pw tb)
	(setq e (prog2 (mapcar
			#'(lambda (datum)
				  (push-pw datum
					   (emax (current-trunc datum) (rczero))))
			tlist)
		       (taylor2 e)
		       (mapcar #'(lambda (datum) (pop-pw datum)) tlist))
	      s (psfind-s e)
	      tb (taylor2 b)
	      pw (if (psp tb) (current-trunc (get-datum
				      (get-key-var (gvar tb))))
		     (if (rczerop tb) (current-trunc (car tlist)) (rczero))))
	(if (eq (typep (car s)) 'FLONUM)
	    (setq s (rationalize (*quo (car s) (cdr s)))))
	(cond ((rczerop tb)
	       (if (or (e> (rcone) s) (and (e> (rczero) pw) (e> s (rcone))))
		   (setq tb (get-lexp b () t)))
	       (setq le (ps-le* tb)))
	      ((psp tb) (setq le (ps-le tb)))
	      (t (return (rcexpt tb e))))
	(and (e> (e* s le) pw)
	     (null $maxtayorder)
	     (return (rczero)))
	(setq s (e- pw (e* le (e1- s))))
	(return
	 (psexpt
	  (if (e> pw s)
	      (if $maxtayorder tb
		  (pstrunc1 tb (list (cons (gvar tb) s))))
	      ;; because of constants not retaining info, have to
	      ;; just keep the constant here
	      (ifn (psp tb) tb
		   (let-pw (get-datum (get-key-var (gvar tb)))
			   s (taylor2 b))))
	  e))))

;;; TSLOG must find the lowest degree term in the expansion of the
;;; log arg, then expand with the orders of all var's in this low term
;;; incremented by their order in this low term. Note that this is
;;; only necessary for var's with ord > 0, since otherwise we have
;;; already expanded to a higher ord than required. Also we must
;;; not do this for var's with trunc < 0, since this may incorrectly
;;; truncate terms which should end up as logs.

(defun tslog (arg)
  (let ((psarg (taylor2 arg)) datum)
   (if (rczerop psarg) (setq psarg (get-lexp arg () t)))
   (do ((ps psarg (ps-lc ps)))
       ((pscoefp ps)
	(cond (datum (setq psarg (taylor2 arg))
		     (if (rczerop psarg) (setq psarg (get-lexp arg () t)))
		     (mapc '(lambda (dat) (pop-pw dat)) datum)))
	(pslog psarg))
       (push (assq (get-key-var (gvar ps)) tlist) datum)
       (if (and (e> (ps-le ps) (rczero))
		(e> (current-trunc (car datum)) (rczero)))
	   (push-pw (car datum) (e+ (ps-le ps) (current-trunc (car datum))))
	   (pop datum)))))

;; When e-start is non-null we start expanding at order e-start, ... , 2^m,
;; then 2^m*pow, instead of the normal sequence pow, ... , 2^m*pow
;; (where m = $taylordepth, pow = ord of var). This is done because it is
;; usually much more efficient for large, non-trivial expansions when we only
;; want the lowest order term.

(defun get-lexp (exp e-start errflag)
 (tlist-mapc d (push-pw d (cond (e-start)
				(t (emax (orig-trunc d) (rcone))))))
 (do ((psexp) (i (1+ $TAYLORDEPTH) (1- i)))
     ((signp e i)
      (tlist-mapc d (pop-pw d))
      (if errflag (tay-depth-err)
	  (zero-warn exp)
	  (rczero)))
     (declare (fixnum i))
     (cond ((rczerop (setq psexp (taylor2 exp))))
	   ;; Info not needed yet.
	   ;; ((and lexp-non0 (rczerop (le (terms psexp)))
	   ;;       (mono-term? (terms psexp))))
	   (t (tlist-mapc d (pop-pw d))
	      (return psexp)))
     (cond ((and (= i 1) e-start)
	    (setq e-start () i 2)
	    (tlist-mapc d (push-pw d (prog1 (e* (orig-trunc d) (current-trunc d))
					    (pop-pw d)))))
	   (t (tlist-mapc d (push-pw d (prog1 (e* (rctwo) (current-trunc d))
					      (pop-pw d))))))))


(defun 1p (x) (or (equal x 1) (equal x 1.0)))

(defun [max-trunc] ()
   (do ((l tlist (cdr l)) (emax (rczero)))
       ((null l) (1+ (// (car emax) (cdr emax))))
       (if (e> (current-trunc (car l)) emax) (setq emax (orig-trunc (car l))))))

(defun tsprsum (f l ind)
   (if (mfree f tvars) (newsym f)
       (let ((li (ncons (car l))) (hi (caddr l)) (lv (ncons (cadr l))) a aa)
	  (if (and (numberp (car lv)) (numberp hi) (greaterp (car lv) hi))
	      (if (eq ind '%SUM) (taylor2 0) (taylor2 1))
	      (if (eq ind '%SUM) (setq ind ()))
	      (do ((m (* 2 ([max-trunc]))) (k 0 (1+ k))
		   (ans (mlet li lv (taylor2 (meval f)))))
		  ((equal hi (car lv)) ans)
		  (rplaca lv (m1+ (car lv)))
		  ;; A cheap heuristic to catch infinite recursion when 
		  ;; possible, should be improved in the future
		  (if (> k m) (exp-pt-err)
		      (setq a (mlet li lv (taylor2 (setq aa (meval f))))))
		  (if ind 
		      (if (and (1p (car a)) (1p (cdr a)) (not (1p aa)))
			  (return ans)
			  (setq ans (pstimes a ans)))
		      (if (and (rczerop a) (not (signp e aa)))
			  (return ans)
			  (setq ans (psplus ans a)))))))))

(defun tsdiff (e l check)
	(*bind* ((n) (v) (u))
	      (do ((l l (cddr l)))
		  ((null l))
		  (if (and (atom (car l)) (numberp (cadr l))
			   (assq (car l) tlist))
		      (setq n (cons (cadr l) n) v (cons (car l) v))
		      (setq u (cons (car l) (cons (cadr l) u)))))
	      (or n (return (prep1 check)))
	      (if u (setq e (meval (cons '($DIFF) (cons e l)))))
	      (setq l (mapcar #'(lambda (x) (get-datum x)) v))
	      (mapcar #'(lambda (datum pw)
			  (push-pw datum (e+ (current-trunc datum) (prep1 pw))))
		      l n)
	      (setq e (taylor2 e))
	      (mapc #'(lambda (datum) (pop-pw datum)) l)
	      (do ((vl v (cdr vl))
		   (nl n (cdr nl)))
		  ((null vl ) e)
		  (do ((i 1 (1+ i)))
		      ((> i (car nl)) )
		      (mapc #'(lambda (a b)
				(putprop a (prep1 (sdiff b (car v)))
					 'DIFF))
			    genvar varlist)
		      (setq e (psdp e))))))

(declare (special errorsw))

(defun no-sing-err (x)			;; try to catch all singularities
       (let* ((errorsw t)
	      (ans (*catch 'errorsw (eval x))))
	     (if (eq ans t) (unfam-sing-err) ans)))

(declare (unspecial errorsw))

(defun check-inf-sing (pt-list) ; don't know behavior of random fun's @ inf
       (and (or (memq '$inf pt-list) (memq '$minf pt-list))
	    (unfam-sing-err)))
	     
(defun diff-expand (exp l)	;l is tlist
       (check-inf-sing (mapcar (function caddr) l))
       (ifn l exp
	    (setq exp (diff-expand exp (cdr l)))
	    (do ((deriv (sdiff exp (caar l))
			(sdiff deriv var))
		 (var (caar l))
		 (coef 1 (times coef (1+ cnt)))
		 (cnt 1 (1+ cnt))
		 (pt (exp-pt (car l)))
		 (lim (rcdisrep (current-trunc (car l))))
		 (ans (list
		       (no-sing-err
			`(meval
			  '(($AT) ,exp
				  ((MEQUAL) ,(caar l)
					    ,(exp-pt (car l)))))))
		      (cons
		       `((MTIMES)
			 ((RAT SIMP) 1 ,coef)
			 ,(no-sing-err
			   `(meval '(($AT) ,deriv
					   ((MEQUAL) ,var ,pt))))
			 ((MEXPT) ,(sub* var pt) ,cnt))
		       ans)))
		((or (great cnt lim) (equal deriv 0))
		 (cons '(MPLUS) ans)))))

		(Comment  Subtitle Disreping routines)

(defun edisrep (e)
       (if (= (cdr e) 1) (car e) (list '(RAT) (car e) (cdr e))))

(defun striptimes (a)
       (if (mtimesp a) (cdr a) (ncons a)))

(defun srdis (x)
       ($ratdisrep
	(cons (list 'MRAT 'SIMP varlist genvar tlist 'TRUNC)
	      x)))

(defun srdisrep (r)
       (mapc #'(lambda (q) (and (switch 'MULTIVAR q)
			  (remprop (int-gvar q) 'DISREP)))
	     (cadddr (cdar r)))
       (cond ((eq $psexpand '$MULTI)
	      (psdisexpand (cdr r)))
	     ((psdisrep (cdr r)))
	     (t 0)))

(defun psdisrep (p)
       (if (psp p) (psdisrep+ (psdisrep2 (terms p) (getdisrep (gvar-o p))
					 (trunc-lvl p))
			      ()
			      (cond ((or $psexpand (trunc-lvl p))
				     '(MPLUS TRUNC))
				    ('(MPLUS EXACT))))
	   (rcdisrep p)))

(defun psdisrep^ (n var)
	(cond ((or (rczerop n)
		   (null var))
	       1)
	      ((equal n (rcone)) var)
	      ((and ps-bmt-disrep
		    (mexptp var)
		    (equal (caddr var) -1))
	       (psdisrep^ (e- n) (cadr var)))
	      (t (list '(MEXPT RATSIMP) var (edisrep n)))))

(defun psdisrep+ (p a plush)
	(cond ((null (cdr p)) (car p))
	      (t (setq a (last p))
		 (cond ((mplusp (car a))
		       (rplacd a (cddar a))
		       (rplaca a (cadar a))))
		 (cons plush p))))

(defun psdisrep* (a b)
	 (cond ((equal a 1) b)
	       ((equal b 1) a)
	       (t (cons '(MTIMES RATSIMP)
			(nconc (striptimes a) (striptimes b))))))


(defun psdisrep2 (p var trunc)
       (if (or $ratexpand $psexpand) (psdisrep2expand p var)
	   (do ((a () (cons (psdisrep* (psdisrep (lc p))
				       (psdisrep^ (le p) var))
			    a))
		(p p (cdr p)))
	       ((or (null p) (e> (le p) trunc)) a))))

(defun psdisrep2expand (p var)
       (do ((p p (cdr p))
	    (l () (nconc (psdisrep*expand (psdisrep (lc p))
					   (psdisrep^ (le p) var))
			  l)))
	   ((null p) l)))

(defun psdisrep*expand (a b)
  (cond ((equal a 1) (list b))
	((equal b 1) (list a))
	((null (mplusp a))
	 (list (cons '(MTIMES RATIMES) (nconc (striptimes a) (striptimes b)))))
	(t (mapcar #'(lambda (z) (psdisrep* z b))
		   (cdr a)))))

(declare (special ans))

(defun psdisexpand (p)
  (let ((ans (ncons ())))
       (psdisexcnt p () (rczero))
       (setq ans
	     (nreverse
	      (mapcar #'(lambda (x) (ifn (cddr x) (cadr x)
					 (cons '(MPLUS TRUNC) (cdr x))))
		      (cdr ans))))
       (ifn (cdr ans) (car ans) (cons '(MPLUS TRUNC) ans))))

(defun psdisexcnt (p l n)
       (if (psp p)
	   (do ((var (getdisrep (gvar-o p)))
		(ll (terms p) (n-term ll)))
	       ((null ll) ())
	       (if (rczerop (le ll)) (psdisexcnt (lc ll) l n)
		   (psdisexcnt (lc ll)
			       (cons (psdisrep^ (le ll) var) l)
			       (e+ (le ll) n))))
	   (psans-add (ifn l (rcdisrep p)
			   (psdisrep* (rcdisrep p)
				      (ifn (cdr l) (car l)
					   (cons '(MTIMES TRUNC) l))))
		      n)))

(defun psans-add (exp n)
       (do ((l ans (cdr l)))
	   ((cond ((null (cdr l)) (rplacd l (ncons (list n exp))))
		  ((e= (caadr l) n) (rplacd (cadr l) (cons exp (cdadr l))))
		  ((e> (caadr l) n) (rplacd l (cons (list n exp) (cdr l))))))))

(declare (unspecial ans))

(defun srconvert (r)
  (ifn (atom (caadr (cdddar r))) (cons (car r) (psdisextend (cdr r)))
       (*bind* ((trunclist (cadr (cdddar r)))
		(tlist) (gps) (temp) 
		(vs (caddar r))
		(gens (cadddr (car r))))
	       (setq gps (mapcar 'cons gens vs))
	       (do ((tl (cdr trunclist) (cddr tl)))
		   ((null tl) (cons (list 'MRAT 'SIMP vs gens tlist 'TRUNC)
				    (srconvert1 (cdr r))))
		   (setq temp (cdr (assq (car tl) gps)))
		   (cond ((null (memq (car tl) (cdr trunclist))))
			 ((mplusp temp) (merror "FOO"))
			 (t (setq tlist
				  (cons (list* temp
					       (tay-order (cadr tl))
					       0 ()
					       (cons (car tl)
						     (symeval (car tl))))
					tlist))))))))

(defun srconvert1 (p)
       (ifn (memq (car p) genvar) p
	    (do ((l (cdr p) (cddr l))
		 (a () (cons (term (prep1 (car l))
				   (srconvert1 (cadr l)))
			     a)))
		((null l)
		 (make-ps (cons (car p) (symeval (car p)))
			  (tay-order (get trunclist (car p)))
			  a)))))

		(Comment Subtitle ERROR HANDLING)

(defun tay-error (msg exp)
  (if silent-taylor-flag (*throw 'taylor-catch ())
      (IF EXP
	  (merror "TAYLOR~A~%~%~M" MSG EXP)
	  (merror "TAYLOR~A" MSG))))

(defun exp-pt-err ()
       (tay-err " unable to expand at a point specified in:"))

(defun essen-sing-err ()
       (tay-err " encountered an essential singularity in:"))

(defun unfam-sing-err ()
       (tay-err " encountered an unfamiliar singularity in:"))

(defun infin-ord-err ()
       (tay-err ": Expansion to infinite order?"))

(defun tay-depth-err ()
       (tay-err ": TAYLORDEPTH exceeded while expanding:"))

		(Comment Subtitle TAYLORINFO)

(DEFMFUN $taylorinfo (x)
  (ifn (memq 'TRUNC (car x)) ()
       (cons '(MLIST)
	     (mapcar
	      #'(lambda (q)
		  (nconc
		   `((MLIST) ,(car q) ,(exp-pt q)
			     ,(let ((tr (current-trunc q)))
				   (cond ((null tr) '$INF)
					 ((equal (cdr tr) 1)
					  (car tr))
					 (t `((RAT) ,(car tr) ,(cdr tr))))))
		   (mapcar #'(lambda (w)
				     (list '(MEQUAL) (car w) (cdr w)))
			   (switches q))))
	      (cadddr (cdar x))))))

