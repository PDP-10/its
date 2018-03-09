;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module sumcon)

(declare (special $genindex $niceindicespref $sumexpand)
	 (*lexpr $min $max))

(defmfun $sumcontract (e)  ; e is assumed to be simplified
       (cond ((atom e) e)
	     ((eq (caar e) 'mplus)
	      (do ((x (cdr e) (cdr x)) (sums) (notsums) (car-x))
		  ((null x) (cond ((null sums)
				   (subst0 (cons '(mplus)
						 (nreverse notsums))
					   e))
				  (t (setq sums (sumcontract1 sums))
				     (addn (cons sums notsums) t))))
		  (setq car-x (car x))
		  (cond ((atom car-x)
			 (setq notsums (cons car-x notsums)))
			((eq (caar car-x) '%sum)
			 (setq sums (cons (cons ($sumcontract (cadr car-x))
						(cddr car-x))
					  sums)))
			(t (setq notsums (cons car-x notsums))))))
	     (t (recur-apply #'$sumcontract e))))

(defmfun $intosum (e)  ; e is assumed to be simplified
  (let (($sumexpand t))
       (cond ((atom e) e)
	     ((eq (caar e) 'mtimes)	;puts outside product inside
	      (do ((x (cdr e) (cdr x)) (sum) (notsum))
		  ((null x) (cond ((null sum)
				   (subst0 (cons '(mtimes)
						 (nreverse notsum))
					   e))
				  (t (simpsum
				      (let ((new-index
					     (cond ((free (cons nil notsum)
							  (caddr sum))
						    (caddr sum))
						   (t (get-free-index
						       (cons nil (cons sum notsum)))))))
					   (setq sum (subst new-index (caddr sum) sum))
					   (rplaca (cdr sum) (muln (cons (cadr sum) notsum) t))
					   (rplacd (car sum) nil)
					   sum)
				      1 t))))
		  (cond ((atom (car x))
			 (setq notsum (cons (car x) notsum)))
			((eq (caaar x) '%sum)
			 (setq sum (if (null sum)
				       (car x)
				       (muln (list sum (car x)) t))))
			(t (setq notsum (cons ($sumcontract (car x))
					      notsum))))))
	     (t (recur-apply #'$intosum e)))))

(defun sumcontract1 (sums) (addn (sumcontract2 nil sums) t))

(defun sumcontract2 (result left)
       (cond ((null left) result)
	     (t ((lambda (x) (sumcontract2 (append (car x) result)
					   (cdr x)))
		 (sumcombine1 (car left) (cdr left))))))

(defun sumcombine1 (pattern list)
       (do ((sum pattern) (non-sums nil)
	    (un-matched-sums nil) (try-this-one)
	    (list list (cdr list)))
	   ((null list) (cons (cons (simpsum (cons '(%sum) sum) 1 t)
				    non-sums)
			      un-matched-sums))
	   (setq try-this-one (car list))
	   (cond ((and (numberp (sub* (caddr sum) (caddr try-this-one)))
		       (numberp (sub* (cadddr sum) (cadddr try-this-one))))
		  ((lambda (x) (setq sum (cdar x)
				     non-sums (cons (cdr x) non-sums)))
		   (sumcombine2 try-this-one sum)))
		 (t (setq un-matched-sums (cons try-this-one un-matched-sums))))))

(defun sumcombine2 (sum1 sum2)
       ((lambda (e1 e2 i1 i2 l1 l2 h1 h2)
		((lambda (newl newh newi extracted new-sum)
			 (setq e1 (subst newi i1 e1))
			 (setq e2 (subst newi i2 e2))
			 (setq new-sum (list '(%sum)
					     (add2 e1 e2)
					     newi
					     newl
					     newh))
			 (setq extracted
			       (addn
				(mapcar (function dosum)
					(list e1 e1 e2 e2)
					(list newi newi newi newi)
					(list l1 (add2 newh 1)
					      l2 (add2 newh 1))
					(list (sub* newl 1) h1
					      (sub* newl 1) h2)
					'(t t t t))
				t))
			 (cons new-sum extracted))
		 ($max l1 l2) ($min h1 h2) (cond ((eq i1 i2) i1)
						 ((free e1 i2) i2)
						 ((free e2 i1) i1)
						 (t (get-free-index (list nil
									  i1 i2
									  e1 e2
									  l1 l2
									  h1 h2))))
		 nil nil))
	(car sum1) (car sum2)
	(cadr sum1) (cadr sum2)
	(caddr sum1) (caddr sum2)
	(cadddr sum1) (cadddr sum2)))

(progn 'compile
       (or (boundp '$niceindicespref)
	   (setq $niceindicespref '((mlist simp) $i $j $k $l $m $n))))

(defun get-free-index (list)
       (or (do ((try-list (cdr $niceindicespref) (cdr try-list)))
	       ((null try-list))
	       (and (free list (car try-list))
		    (return (car try-list))))
	   (do ((n 0 (1+ n)) (try))
	       (nil)
	       (setq try (implode (append (exploden (cadr $niceindicespref))
					  (exploden n))))
	       (and (free list try) (return try)))))

(defmfun $bashindices (e)  ; e is assumed to be simplified
       (let (($genindex '$j))
	    (cond ((atom e) e)
		  ((memq (caar e) '(%sum %product))
		   (subst (gensumindex) (caddr e) e))
		  (t (recur-apply #'$bashindices e)))))

(defmfun $niceindices (e)
  (if (atom e) e
	       (let ((e (recur-apply #'$niceindices e)))
		    (if (memq (caar e) '(%sum %product))
			(subst (get-free-index e) (caddr e) e)
			e))))
