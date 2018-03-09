;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module mhayat macro)

;;;   **************************************************************
;;;   ***** HAYAT ******* Finite Power Series Routines *************
;;;   **************************************************************
;;;   ** (c) Copyright 1980 Massachusetts Institute of Technology **
;;;   ****** This is a read-only file! (All writes reserved) *******
;;;   **************************************************************

;;; Note: be sure to recompile this file if any modifications are made!

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

(declare (special tlist ivars key-vars last-exp))


		(Comment Subtitle HAYAT macros)

(defmacro pszero (var pw) var pw ''(0 . 1)) ; until constants are fixed

(defmacro psp (e) `(eq (car ,e) 'ps))

(defmacro pscoefp (e) `(null (psp ,e)))

(defmacro psquo (ps1 &optional ps2)
	  (ifn ps2 `(let (($maxtayorder t)) (psexpt ,ps1 (rcmone)))
	       `(pstimes ,ps1 (let (($maxtayorder t))
				   (psexpt ,ps2 (rcmone))))))

(defmacro pslog-gvar (gvar) `(pslog2 (get-inverse ,gvar)))

(defmacro gvar-o (e) `(cadr ,e))

(defmacro gvar (e) `(car (gvar-o ,e)))

(defmacro eqgvar (x y) `(eq (car ,x) (car ,y)))

(defmacro pointerp (x y) `(> (cdr ,x) (cdr ,y)))

(defmacro poly-data (p) `(caddr ,p))

(defmacro trunc-lvl (p) `(car (poly-data ,p)))

(defmacro terms (p) `(cdddr ,p))

(defmacro lt (terms) `(car ,terms))

(defmacro le (terms) `(caar ,terms))

(defmacro lc (terms) `(cdar ,terms))

(defmacro e (term) `(car ,term))

(defmacro c (term) `(cdr ,term))

(defmacro n-term (terms) `(cdr ,terms))

(defmacro mono-term? (terms) `(null (n-term ,terms)))

(defmacro nconc-terms (oldterms newterms) `(nconc ,oldterms ,newterms))

(defmacro term (e c) `(cons ,e ,c))

(defmacro make-ps (var-or-data-poly pdata-or-terms
				      &optional (terms () var-pdata-case?))
   (if var-pdata-case?
       `(cons 'ps (cons ,var-or-data-poly (cons ,pdata-or-terms ,terms)))
       `(cons 'ps (cons (gvar-o ,var-or-data-poly)
			(cons (poly-data ,var-or-data-poly)
			      ,pdata-or-terms)))))

;; Be sure that PS has more than one term when deleting the first with del-lt

(defmacro del-lt (ps) `(rplacd (cddr ,ps) (cddddr ,ps)))

(defmacro add-term (terms &optional (term-or-e nil adding?) (c nil e-c?))
	  (cond ((null adding?) `(rplacd ,terms nil))
		((null e-c?)
		 `(rplacd ,terms (cons ,term-or-e (cdr ,terms))))
		(`(rplacd ,terms (cons (cons ,term-or-e ,c) (cdr ,terms))))))

(defmacro add-term-&-pop (terms &rest args)
   `(progn (add-term ,terms . ,args) (setq ,terms (n-term ,terms))))

;; Keep both def'ns around until a new hayat is stable.

(defmacro change-coef (terms coef)  `(rplacd (lt ,terms) ,coef))

(defmacro change-lc (terms coef)  `(rplacd (lt ,terms) ,coef))

(defmacro getdisrep (var)  `(get (car ,var) 'disrep))

(defmacro getdiff (var)  `(get (car ,var) 'diff))

(defmacro lt-poly (p)
	  `(make-ps (gvar-o ,p) (poly-data ,p)
		      (list (lt (terms ,p)))))

(defmacro oper-name (func)  `(if (atom ,func) ,func (caar ,func)))
				     
(defmacro oper-namep (oper-form) `(atom ,oper-form))

(defmacro integer-subscriptp (subscr-fun)
	  `(apply 'and (mapcar #'fixp (cdr ,subscr-fun))))

(defmacro mlet (varl vals comp)
  `(mbinding (,varl ,vals) ,comp))


;;; these macros access "tlist" to get various global information
;;; "tlist" is structured as a list of datums, each datum having
;;; following form:
;;;
;;;	(<var> <trunc-lvl stack> <pt of expansion>
;;;	       <list of switches> <internal var = gvar> . <ord-num>)
;;;
;;; possible switches are:
;;;	$asymp = t 	asymptotic expansion
;;;	multi       	variable in a multivariate expansion
;;;	multivar	the actual variable of expansion in a multi-
;;;			variate expansion
;;;

;;; macros for external people to access the tlist

(defmacro mrat-header (mrat) `(car ,mrat))

(defmacro mrat-tlist (mrat) `(fifth (mrat-header ,mrat)))

;;; internal macros

(defmacro push-pw (datum pw)
	  `(rplaca (cdr ,datum) (cons ,pw (cadr ,datum))))

(defmacro pop-pw (datum)
	  `(rplaca (cdr ,datum) (cdadr ,datum)))

(defmacro current-trunc (datum) `(caadr ,datum))

(defmacro orig-trunc (datum) `(car (last (cadr ,datum))))

(defmacro exp-pt (datum) `(caddr ,datum))

(defmacro switches (datum) `(cadddr ,datum))

(defmacro switch (sw datum) `(cdr (assq ,sw (switches ,datum))))

(defmacro int-var (datum) `(cddddr ,datum))

(defmacro data-gvar-o (data) `(cddddr ,data))

(defmacro int-gvar (datum) `(car (int-var ,datum)))

(defmacro data-gvar (data) `(car (data-gvar-o ,data)))

(defmacro get-inverse (gensym) `(cdr (assq ,gensym ivars)))

(defmacro gvar->kvar (gvar) `(cdr (assq ,gvar ivars)))

(defmacro get-key-var (gensym) `(cdr (assq ,gensym key-vars)))

(defmacro gvar->var (gvar) `(cdr (assq ,gvar key-vars)))

(defmacro dummy-var () '(cdar key-vars))

(defmacro first-datum () '(car tlist))

(defmacro get-datum (expr) `(assoc ,expr tlist))

(defmacro var-data (var) `(assoc ,var tlist))

(defmacro gvar-data (gvar) `(var-data (gvar->var ,gvar)))

(defmacro ps-data (ps) `(gvar-data (gvar ,ps)))

(defmacro t-o-var (gensym) `(current-trunc (get-datum (get-key-var ,gensym))))

(defmacro gvar-trunc (gvar) `(current-trunc (gvar-data ,gvar)))

(defmacro ps-arg-trunc (ps) `(gvar-trunc (gvar ,ps)))

(defmacro ps-le (ps) `(le (terms ,ps)))

(defmacro ps-le* (ps) `(if (psp ,ps) (ps-le ,ps) '(0 . 1)))

(defmacro ps-lc (ps) `(lc (terms ,ps)))

(defmacro ps-lc* (ps) `(if (psp ,ps) (ps-lc ,ps) ,ps))

(defmacro ps-lt (ps) `(lt (terms ,ps)))

(defmacro getexp-le (fun) `(car (getexp-lt ,fun)))

(defmacro getexp-lc (fun) `(cdr (getexp-lt ,fun)))

(defmacro let-pw (datum pw comp)
	  `(let ((d ,datum))
		(prog2 (push-pw d ,pw)
		       ,comp
		       (pop-pw d))))

(defmacro if-pw (pred datum pw comp)
	  `(let ((p ,pred) (d ,datum))
		(prog2 (and p (push-pw d ,pw))
		       ,comp
		       (and p (pop-pw d ,pw)))))

(defmacro tlist-mapc (datum-var &rest comp)
	  `(mapc #'(lambda (,datum-var) . ,comp) tlist))

(defmacro find-lexp (exp &optional e-start errflag accum-vars)
	  `(get-lexp ,exp ,e-start ,errflag ,(and accum-vars '(ncons t))))

(defmacro tay-err (msg) `(*throw 'tay-err (list ,msg last-exp)))

(defmacro zero-warn (exp)
  `(mtell "~%~M~%Assumed to be zero in TAYLOR~%"
	  `((MLABLE) () ,,exp)))


(defmacro merrcatch (form) `(*catch 'errorsw ,form))

;There is a duplicate version of this in MAXMAC
;(defmacro infinities () ''($INF $MINF $INFINITY))

;; Macros for manipulating expansion data in the expansion table.

(defmacro exp-datum-lt (fun exp-datum)
	  `(if (atom (cadr ,exp-datum))
	       (funcall (cadr ,exp-datum) (cdr ,fun))
	       (copy (cadr ,exp-datum))))

(defmacro exp-datum-le (fun exp-datum)  `(e (exp-datum-lt ,fun ,exp-datum)))

(defmacro exp-fun (exp-datum)
	  `(if (atom (car ,exp-datum)) (car ,exp-datum) (caar ,exp-datum)))

;;; These macros are used to access the various extendable
;;; portions of a polynomial.

(defmacro ext-fun (p) `(cadr (poly-data ,p)))

(defmacro ext-args (p) `(caddr (poly-data ,p)))

(defmacro extendablep (p)
	  `((lambda (d)
		   (or (null (car d))
		       (cdr d)))
	   (poly-data ,p)))

(defmacro exactp (p) `(null (trunc-lvl ,p)))

(defmacro nexactp (p) `(trunc-lvl ,p))

;;; These macros are used to access user supplied information.

(defmacro get-ps-form (fun) `(get ,fun 'sp2))

(defmacro term-disrep (term p) `(m* (srdis (c ,term))
				    (m^ (get-inverse (gvar ,p))
					(edisrep (e ,term)))))


		(comment coefficient arithmetic)

(defmacro rczero ()  ''(0 . 1))

(defmacro rcone () ''(1 . 1))

(defmacro rcfone () ''(1.0 . 1.0))

(defmacro rctwo () ''(2 . 1))

(defmacro rcmone () ''(-1 . 1))

(defmacro rczerop (r)
	  `(signp e (car ,r)))

(defmacro rcintegerp (c) `(and (fixp (car ,c)) (equal (cdr ,c) 1)))

(defmacro rcpintegerp (c) `(and (rcintegerp ,c) (signp g (car ,c))))

(defmacro rcmintegerp (c) `(and (rcintegerp ,c) (signp l (car ,c))))

(defmacro rcplus (x y) `(ratplus ,x ,y))

(defmacro rcdiff (x y) `(ratdif ,x ,y))

(defmacro rcminus (x) `(ratminus ,x))

(defmacro rctimes (x y) `(rattimes ,x ,y t))

(defmacro rcquo (x y) `(ratquotient ,x ,y))

(defmacro rcdisrep (x) `(cdisrep ,x))

(defmacro rcderiv (x v) `(ratderivative ,x ,v))

(defmacro rcderivx (x) `(ratdx1 (car ,x) (cdr ,x)))

		(comment exponent arithmetic)

;; These macros are also used in BMT;PADE and RAT;NALGFA.

(defmacro infp (x) `(null ,x))

(defmacro inf nil nil)

(defmacro e- (e1 &optional (e2 nil 2e?))
	  (cond (2e? `(ediff ,e1 ,e2))
		(`(cons (- (car ,e1)) (cdr ,e1)))))

(defmacro e// (e1 &optional (e2 nil 2e?))
	  (cond (2e? `(equo ,e1 ,e2))
		(`(erecip ,e1))))

(defmacro e>= (e1 e2) `(or (e> ,e1 ,e2) (e= ,e1 ,e2)))

(defmacro ezero () ''(0 . 1))

(defmacro eone () ''(1 . 1))

(defmacro ezerop (e) `(zerop (car ,e)))

(defmacro rcinv (r) `(ratinvert ,r))
