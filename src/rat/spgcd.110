;;;                   -*- Mode:LISP; Package:MACSYMA -*-
;;;   *****************************************************************
;;;   ***** SPGCD ******* Sparse polynomial routines for GCD **********
;;;   *****************************************************************
;;;   ** (C) COPYRIGHT 1982 MASSACHUSETTS INSTITUTE OF TECHNOLOGY *****
;;;   ****** THIS IS A READ-ONLY FILE! (ALL WRITES RESERVED) **********
;;;   *****************************************************************

(macsyma-module spgcd)

(declare (special modulus temp genvar *alpha *which-factor*
		  $algebraic algfac* $GCD)
	 (mapex t)
	 (genprefix spgcd))

(load-macsyma-macros ratmac)

(defmvar $POINTBOUND *alpha)

(defmacro 0? (x) `(= ,x 0))

(defmacro melt (a . indices) `(arraycall fixnum ,a . ,indices))

(defmacro ARRAYTYPE (m) `(car (arraydims ,m)))

(defmacro NCOLS (m) `(cadr (arraydims ,m)))

(defmacro NROWS (m) `(caddr (arraydims ,m)))

(defmacro LEN (lobj) `(cadr ,lobj))

(defmacro SKEL (lobj) `(caddr ,lobj))

(defmacro MATRIX (lobj) `(cadddr ,lobj))

(defmacro CURROW (lobj) `(cadr (cdddr ,lobj)))

(defmacro BADROWS (lobj) `(cadr (cddddr ,lobj)))


(defun PINTERP (x pts vals)
       (do ((u (car vals)
	       (pplus u (ptimes
			 (pctimes (crecip (pcsubstz (car xk) qk))
				  qk)
			 (pdifference (car uk)
				      (pcsubstz (car xk) u)))))
	    (uk (cdr vals) (cdr uk))
	    (qk (list x 1 1 0 (cminus (car pts)))
		(ptimes qk (list x 1 1 0 (cminus (car xk)))))
	    (xk (cdr pts) (cdr xk)))
	   ((null xk) u)))

(defun PCSUBSTZ (val p)
       (if (pcoefp p) p
	   (do ((l (p-terms p) (pt-red l))
		(ans 0
		     (ctimes
		      (cplus ans (pt-lc l))
		      (cexpt val (- (pt-le l) (pt-le (pt-red l)))))))
	       ((null (pt-red l))
		(ctimes
		 (cplus ans (pt-lc l))
		 (if (0? (pt-le l))
		     1
		     (cexpt val (pt-le l))))))))

;skeletons consist of list of exponent vectors
;lifting structures are as follows:

;(matrix <n>            ;length of <skel>
;        <skel>		;skeleton of poly being lifted
;        <matrix>       ; partially diagonalized matrix used to obtain sol.
;        <row>          ;we have diagonalized this far
;        <bad rows>)    ; after we get 

(defun EVAL-MON (mon pt)
       (do ((l mon (cdr l))
	    (ll pt (cdr ll))
	    (ans 1 (ctimes
		    (if (0? (car l)) 1
			(cexpt (car ll) (car l)))
		    ans)))
	   ((null l) ans)))

; ONE-STEP causes the  (row,col) element of mat to be made to be zero.  It is
; assumed that row > col, and that the matrix is diagonal above the row.  
; n indicates how wide the rows are suppoded to be.

(defun ONE-STEP (mat row col n)
       (do ((i col (1+ i))
	    (c (melt mat row col)))	;Got to save this away before it is
					;zeroed
	   ((> i n) mat)
	   (store (melt mat row i)
		  (cdifference (melt mat row i)
			       (ctimes c (melt mat col i))))))

; MONICIZE-ROW assumes the (row,row) element is non-zero and that this element
; is to be made equal to one.  It merely divides the entire row by the 
; (row,row) element.  It is assumed that the (row,n) elements with n < row are
; already zero.  Again n is the width of the rows.

(defun MONICIZE-ROW (mat row n)
       (do ((i n (1- i))
	    (c (CRECIP (melt mat row row))))
	   ((= i row)
	    (store (melt mat row row) 1))	;Don't bother doing the
					;division on the diagonal
	   (store (melt mat row i) (ctimes (melt mat row i) c))))

; FILL-ROW is given a point and the value of the skeleton at the point and
; fills the apropriate row in the matrix. with the values of the monomials
; n is the length of the skeleton

(defun FILL-ROW (skel mat n row pt val)
       (do ((i 0 (1+ i))
	    (l skel (cdr l)))
	   ((= i n)			;l should be nil now,
	    (if (not (null l))		;but lets check just to make sure
		(merror "Skeleton too long in  FILL-ROW: ~S"
			(list n '= skel)))
	    (store (melt mat row n) val))	;The value is stored in the
					;last column
	   (store (melt mat row i)
		  (eval-mon (car l) pt))))	;Should think about a better
					;way to do this evaluation.

(defun SWAP-ROWS (mat m n)		;Interchange row m and n
       (do ((k 0 (1+ k))
	    (l (ncols mat)))
	   ((> k l) mat)
	   (store (melt mat m k)
		  (prog2 0 (melt mat n k)
			 (store (melt mat n k) (melt mat m k))))))

; PARTIAL-DIAG fills in one more row of the matrix and tries to diagonalize
; what it has so far.  If the row which has just been introduced has a 
; zero element on the diagonal then it is scanned for its first non-zero
; element and it is placed in the matrix so that the non-zero element is 
; on the diagonal.  The rows which are missing are added to the list in 
; badrows.  The current row pointer may skip a couple of numbers here, so
; when it is equal to n, the only empty rows to add thing to are on the
; bad rows list.

(defun PARTIAL-DIAG (lobj pt val)	; Does one step of diagonalization of
   (let ((n (len lobj))		;the matrix in lobj
	 (skel (skel lobj))		
	 (mat (matrix lobj))		;The matrix, obviously
	 (row (currow lobj))		;This is the row which is to be 
					;introduced
	 (badrows (badrows lobj))	;Rows which could not be used when
					;their time came, and will be used later
	 crow)
       (cond ((= row n)			;All rows already done, must start
					;using the rows in badrows.
	      (fill-row skel mat n (setq crow (car badrows)) pt val))
	     ((fill-row skel mat n row pt val)	;Fill up the data
	      (setq crow row)))

;; This loop kills all the elements in the row up to the diagonal.

       (do ((i 0 (1+ i))		;runs over the columns of mat
	    (l (setq badrows (cons nil badrows)))
	    (flag))
	   ((= i crow)
	    (setq badrows (cdr badrows)))	;update badrows
	   (if (cdr l)			;Any bad rows around?
	       (if (= (cadr l) i)	;No one for this row,
		   (if (and (null flag)	;So if this guy can fill in
			    (not (0? (melt mat crow i))))
		       (progn
			(swap-rows mat crow i)	;Put this guy in the right spot
			(rplacd l (cddr l))
			(setq flag t crow i))	; and make him a winner
		       (setq l (cdr l)))	;At any rate this guy isn't 
					;used any more.
		   (one-step mat crow i n))
	       (one-step mat crow i n)))

       (if (0? (melt mat crow crow))	;diagonal is zero?
	   (setq badrows (cons crow badrows))
	   (progn
	    (monicize-row mat crow n)	;Monicize the diagonal element on this
					;row
	    (do ((j 0 (1+ j)))		;For each element in the rows above 
					;this one zero the the crow column
		((= j crow))		;Don't zero the diagonal element
		(one-step mat j crow n))))
       (cond ((and (= (1+ row) n)
		   (setq row (1- row))	;Decrement it just in case
		   (null (cdr badrows)))
	      (do ((l nil (cons (melt mat i n) l))
		   (i (1- n) (1- i)))
		  ((< i 0)
		   (list 'SOLUTION n skel mat l))))
	     (t (list 'MATRIX n skel mat (1+ row) badrows)))))

(defun GEN-POINT (vars)
       (do ((l vars (cdr l))
	    (ans nil (cons (cmod (random $POINTBOUND)) ans)))
	   ((null l) ans)))

; PDIAG-ALL introduces a new row in each matrix in the list of l-lobjs.
; The RHS of the equations is stripped off of poly.

(defun PDIAG-ALL (l-lobjs poly pt)
       (do ((l l-lobjs (cdr l))
	    (lp (p-terms poly))
	    (solved t) (c))
	   ((null l)
	    (if solved (cons 'SOLVED l-lobjs)
		l-lobjs))
	   (if (and lp (= (caar l) (pt-le lp)))	;This term corresponds to the
					;current lobj, set c to the coefficient
	       (setq c (pt-lc lp) lp (pt-red lp))
	       (setq c 0))
;FIXTHIS				;Should put it some check for extra 
					;terms in the polynomial
	   (if (not (eq (cadar l) 'SOLUTION))
	       (progn (rplacd (car l)
			      (partial-diag (cdar l) pt c))
		      (and solved (null (eq (cadar l) 'SOLUTION)) 
			   (setq solved nil))))))

;; not currently called
;; (defun CREATE-INTVECT (h)
;;      (do ((l (cdr h) (cddr l))
;; 	    (ans nil (cons (list (car l) (cadr l))
;; 			   ans)))
;; 	   ((null l)
;; 	    (nreverse ans))))

;; (defun MERGE-INTVECT (iv h)
;;      (do ((l iv (cdr l))
;; 	    (h (cdr h)))
;; 	   ((null l) iv)
;; 	   (cond ((or (null h) (> (caar l) (car h)))
;; 		  (rplacd (car l) (cons 0 (cdar l))))
;; 		 ((= (caar l) (car h))
;; 		  (rplacd (car l) (cons (cadr h) (cdar l)))
;; 		  (setq h (cddr h)))
;; 		 (t (error '|Bad Evaluation point - MERGE-INTVECT|)))))


(defun MERGE-SKEL (mon poly)
       (cond ((pcoefp poly)
	      (list (cons 0 mon)))
	     ((do ((l (cdr poly) (cddr l))
		   (ans nil
			(cons (cons (car l) mon) ans)))
		  ((null l) ans)))))

(defun NEW-SKEL (skel polys)
       (list
	(mapcan (fn (mon poly) (merge-skel mon poly))
		skel polys)
	(mapcan (fn (q)
		    (cond ((pcoefp q) (list q))
			  ((do ((l (cdr q) (cddr l))
				(ans nil (cons (cadr l) ans)))
			       ((null l) ans)))))
		polys)))

(defun CREATE-LOBJS (prev-lift)
  (mapcar #'(lambda (q)
	      (let ((n (length (cadr q))))
		(cons (car q)
		      (list 'MATRIX n (cadr q)
			    (*array nil 'fixnum n (1+ n))
			    0 nil))))
	  prev-lift))

(defun CLEAR-LOBJS (lobjs)
  (mapcar #'(lambda (q)
	      (cons (car q)
		    (list 'MATRIX (caddr q) (cadddr q)
			  (caddr (cddr q)) 0 nil)))
	  lobjs))

(defun SPARSE-LIFT (c f g l-lobjs vars)
       (do ((pt (gen-point vars) (gen-point vars))
	    (gcd))
	   ((eq (car l-lobjs) 'SOLVED)
	    (cdr l-lobjs))
	   (setq gcd (lifting-factors-image
		      (pcsub c pt vars) (pcsub f pt vars) (pcsub g pt vars)))
	   (if (or (pcoefp gcd)
		   (not (= (pt-le (p-terms gcd)) (caar l-lobjs))))
	       (*throw 'Bad-Point nil)
	       (setq l-lobjs (pdiag-all l-lobjs gcd pt)))))

(defun LIFTING-FACTORS-IMAGE (c f g)
       (let ((gcd (pgcdu f g)))
	    (caseq *which-factor*
		   (1 (pctimes c gcd))
		   (2 (pquotient f gcd))
		   (3 (pquotient g gcd)))))

(defun ZGCD-LIFT* (c f g vars degb)
       (do ((vals (gen-point vars) (gen-point vars))
	    (ans))
	   ((not (null ans))
	    ans)
	   (setq ans
		 (*catch 'Bad-Point
			 (ZGCD-LIFT c f g vars vals degb)))))

; ZGCD-LIFT returns objects called lifts.  These have the the following 
; structure
;      ((n <skel> <poly>) ...  )
; n corresponds to the degree in the main variable to which this guy 
; corresponds.

(defun ZGCD-LIFT (c f g vars vals degb)
       (cond ((null vars)		;No variables left, just the main one
	      (let ((p (lifting-factors-image c f g)))	;Compute factor and 
					;enforce leading coefficient
		   (if (pcoefp p) (*throw 'relprime 1)	;if the GCD is 1 quit
		       (do ((l (p-terms p) (pt-red l))	;otherwise march
					;though the polynomial
			    (ans nil	;constructing a lift for each term.
				 (cons (list (pt-le l) '(nil) (list (pt-lc l)))
				       ans)))
			   ((null l)
			    (nreverse ans))))))
	     ((let ((prev-lift		;Recurse if possible
		     (zgcd-lift (pcsubsty (car vals) (car vars) c)
				(pcsubsty (car vals) (car vars) f)
				(pcsubsty (car vals) (car vars) g)
				(cdr vars) (cdr vals) (cdr degb))))
		    (do ((i 0 (1+ i))	;counts to the degree bound
			 (lobjs (create-lobjs prev-lift)	;need to create
					;the appropriate matrices
				(clear-lobjs lobjs))	;but reuse them at each
					;step
			 (pts (add-point (list (car vals)))	;List of random
			      (add-point pts))	;points
			 (linsols (mapcar 'make-linsols prev-lift)
				  (merge-sol-lin
				   linsols
				   (sparse-lift
				    (pcsubsty (car pts) (car vars) c)
				    (pcsubsty (car pts) (car vars) f)
				    (pcsubsty (car pts) (car vars) g)
				    lobjs (cdr vars)))))
			((= i (car degb))
			 (interp-polys linsols (cdr pts) (car vars))))))))

(defun MAKE-LINSOLS (prev-lift)
  (list (car prev-lift)
	(cadr prev-lift)
	(mapcan #'(lambda (q)
		    (cond ((pcoefp q) (list (list q)))
			  (t (do ((l (p-terms q) (pt-red l))
				  (ans nil (cons (list (pt-lc l)) ans)))
				 ((null l) ans)))))
		(caddr prev-lift))))

(defun ADD-POINT (l)
       (do ((try (cmod (random $pointbound))
		 (cmod (random $pointbound))))
	   ((null (member try l))
	    (cons try l))))

(defun MERGE-SOL-LIN (l1 l2)
       (do ((l l1 (cdr l))
	    (l2 l2 (cdr l2)))
	   ((null l) l1)
	   (cond ((= (caar l) (caar l2))
		  (rplaca (cddar l)
			  (mapcar 'cons (cadddr (cddar l2)) (caddar l)))))))

(defun INTERP-POLYS (l pts var)
  (mapcar #'(lambda (q)
	      (cons (car q)
		    (new-skel
		     (cadr q)
		     (mapcar #'(lambda (r) (pinterp var pts r))
			     (caddr q)))))
	  l))

(defun ZGCD (f g &aux $algebraic algfac*)
   (let ((f (oldcontent f))			;This is a good spot to
	 (g (oldcontent g))			;initialize random
	 (gcd) (mon) 
	 (*which-factor*))
 ;; *WHICH-FACTOR* is interpreted as follows.  It is set fairly deep in the
 ;; algorithm, inside ZGCD1.
 ;; 1 -> Lift the GCD
 ;; 2 -> Lift the cofactor of F
 ;; 3 -> Lift the cofactor of G


       (setq mon (pgcd (car f) (car g))	;compute GCD of content
	     f (cadr f) g (cadr g))	;f and g are now primitive
       (if (or (pcoefp f) (pcoefp g)
		  (not (eq (car f) (car g))))
	   (merror "Bad args to ZGCD"))
       (ptimes mon
	       (do ((test))
		   (nil)
		   (setq gcd (*catch 'relprime (zgcd1 f g)))
		   (setq test
			 (caseq *which-factor*
				(1 (testdivide f gcd))
				(2 (testdivide f gcd))
				(3 (testdivide g gcd))))
		   (cond ((not (null test))
			  (return
			   (cond ((equal *which-factor* 1)
				  gcd)
				 (t test))))
			 ((not (null modulus))
			  (return (let (($GCD '$RED))
				    (pgcd f g)))))))))

(defun ZGCD1 (f g)
   (let* ((modulus modulus)
	  (first-lift)
	  (H) (degb) (c)
	  (vars (sort (union1 (listovars f) (listovars g))
		       #'pointergp))

 ;; The elements of the following degree vectors all correspond to the 
 ;; contents of var.  Thus there may be variables missing that are in 
 ;; GENVAR.
	  (f-degv (zpdegreevector f vars))
	  (g-degv (zpdegreevector g vars))
	  (gcd-degv (gcd-degree-vector f g vars)))

;; First we try to decide which of the gcd and the cofactors of f and g 
;; is smallest.  The result of this decision is indicated by *which-factor*.
;; Then the leading coefficient that is to be enforced is changed if a 
;; cofactor has been chosen.
	(caseq (setq *which-factor*
		     (determine-lifting-factor f-degv g-degv gcd-degv))
	       (1 (setq c (pgcd (p-lc f) (p-lc g))))
	       (2 (setq c (p-lc f)))
	       (3 (setq c (p-lc g))))

 ;; Next a degree bound must be chosen.
	(setq degb
	      (reverse
	       (mapcar #'plus
		       (caseq *which-factor*
			      (1 gcd-degv)
			      (2 (mapcar #'difference f-degv gcd-degv))
			      (3 (mapcar #'difference g-degv gcd-degv)))
		       (zpdegreevector c vars))))

	(cond ((not (null modulus))
	       (lobj->poly (car vars) (cdr vars)
		(zgcd-lift* c f g (cdr vars) (cdr degb))))
	      (t
	       (setq h (times (maxcoefficient f)
			      (maxcoefficient g)))
	       (setq modulus *alpha)		    ;Really should randomize
	       (setq first-lift
		     (zgcd-lift* (pmod c) (pmod f) (pmod g)
				 (cdr vars) (cdr degb)))
	       (do ((linsols (mapcar #'(lambda (q)
					 (cons (car q)
					       (new-skel (cadr q) (caddr q))))
				     first-lift)
			     (merge-sol-lin-z linsols
					      (sparse-lift cm fm gm lobjs (cdr vars))
					      (times coef-bound
						     (crecip (cmod coef-bound)))
					      (times modulus coef-bound)))
		    (lobjs (create-lobjs first-lift)
			   (clear-lobjs lobjs))
		    (coef-bound *alpha (times modulus coef-bound))
		    (cm) (fm) (gm))
		   ((greaterp coef-bound H)
		    (setq modulus nil)
		    (lobj->poly (car vars) (cdr vars) linsols))
		   (setq modulus (newprime modulus))
		   (setq cm (pmod c)
			 fm (pmod f)
			 gm (pmod g)))))))

(defun LOBJ->POLY (var vars lobj)
       (primpart
	(cons var
	      (mapcan
	       #'(lambda (q) 
		    (list (car q)
			  (do ((x (cadr q) (cdr x))
			       (y (caddr q) (cdr y))
			       (ans 0
				    (pplus ans
					   (disrep-monom (cdar x) (car y)
							 vars))))
			      ((null x) ans))))
	       lobj))))

(defun DISREP-MONOM (monom c vars)
       (cond ((null monom) c)
	     ((equal 0 (car monom))
	      (disrep-monom (cdr monom) c (cdr vars)))
	     ((list (car vars) (car monom)
		    (disrep-monom (cdr monom) c (cdr vars))))))

(defun MERGE-SOL-LIN-Z (l1 l2 c new-coef-bound)
       (do ((l l1 (cdr l))
	    (l2 l2 (cdr l2))
	    (modulus new-coef-bound)
	    (n))
	   ((null l) l1)
	   (cond ((= (caar l) (caar l2))
		  (rplaca (cddar l)
		   (mapcar
		    #'(lambda (a b)
			  (cond ((greaterp
				  (abs
				   (setq n
					 (cplus b (ctimes c (cdifference a b)))))
				  new-coef-bound)
				 (*throw 'relprime 1))
				(n)))
			   (cadddr (cddar l2)) (caddar l)))))))

;; The following function tries to determine the degree of gcd(f, g) in each
;; variable.  This is done in the following manner:  All but one of the
;; variables in f and g are replaced by randomly chosen integers.  The
;; resulting polynomials are called f* and g*.   The degree of gcd(f*, g*) is
;; used as the degree of gcd(f, g) in that variable.
;;
;; The univariate gcd's are computed with modulus=*alpha.

(defun GCD-DEGREE-VECTOR (f g vars)
   (let ((modulus *alpha))
     (setq f (pmod f) g (pmod g))
     (do ((vn (cdr vars) (cdr vn))
	  (vs (delete (car vars) (copy1 vars))
	      (delete (car vn) (copy1 vars)))
	  (l) (f*) (g*) (gcd*) (rand))
	 (nil)
	 (setq rand (gen-point vs))
	 (setq f* (pcsub f rand vs)
	       g* (pcsub g rand vs))
	 (cond ((or (pcoefp f*) (pcoefp g*)
		    (pcoefp (setq gcd* (pgcdu f* g*))))
		(push 0 l))
	       (t (push (pt-le (p-terms gcd*)) l)))
	 (cond ((null vn)
		(return l))))))		;No reverse needed here

; DETERMINE-LIFTING-FACTOR returns a number indicating which factor of f or g
; to which to lift 

(defun DETERMINE-LIFTING-FACTOR (f-degv g-degv gcd-degv)
       (let* ((fv (apply 'plus (mapcar 'difference f-degv gcd-degv)))
	      (gv (apply 'plus (mapcar 'difference g-degv gcd-degv)))
	      (gcdv (apply 'plus gcd-degv)))
	     (if (lessp fv gcdv)
		 (if (lessp fv gv) 2 3)
		 (if (lessp gv gcdv) 3 1))))


(defun EXCISE-EXTRA-VARIABLES (degv vars)
       (do ((l (reverse degv) (cdr l))
	    (lv (reverse genvar) (cdr lv))
	    (ndegv))
	   ((null l)
	    ndegv)
	   (cond ((eq (car lv) (car vars))
		  (push (car l) ndegv)
		  (setq vars (cdr vars))))))

(defun ZPDEGREEVECTOR (p vars)
       (excise-extra-variables (pdegreevector p) vars))

;; Local Modes:
;; Mode:LISP
;; Fill Column:76
;; Auto Fill Mode:1
;; Comment Column:40
;; END:

