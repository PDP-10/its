;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module logarc)

;;;  Logarc and Halfangles

(defmfun $logarc (exp)
	 (cond ((atom exp) exp)
	       ((arcp (caar exp)) (logarc (caar exp) ($logarc (cadr exp))))
	       ((eq (caar exp) '$atan2)
		(logarc '%atan ($logarc (div (cadr exp) (caddr exp)))))
	       (t (recur-apply #'$logarc exp))))

(defmfun logarc (f x)
  ;;Gives logarithmic form of arc trig and hyperbolic functions
 (let ((s (memq f '(%acos %atan %asinh %atanh))))
   (cond 
    ((memq f '(%acos %asin))
     (mul (min%i)
	  (take '(%log)
		(add (mul (if s '$%i 1)
			   (root (add 1 (neg (power x 2))) 2))
		     (mul (if s 1 '$%i) x)))))
    ((memq f '(%atan %acot))
     (mul (i//2)
	  (take '(%log) (div (add 1 (morp s (mul '$%i x)))
			     (add (mul '$%i x) (porm s 1))))))
    ((memq f '(%asinh %acosh))
     (take '(%log) (add x (root (add (power x 2) (porm s 1)) 2))))
    ((memq f '(%atanh %acoth))
     (mul (half) (take '(%log) (div (add 1 x) (morp s (add x -1))))))
    ((memq f '(%asec %acsc %asech %acsch))
     (logarc (get (get (get f '$inverse) 'recip) '$inverse) (inv x)))
    (t (merror "Bad argument to Logarc")))))

(defun halfangle (f a)
       (and (mtimesp a)
	    (ratnump (cadr a))
	    (equal (caddr (cadr a)) 2)
	    (halfangleaux f (mul 2 a))))

(defun halfangleaux (f a)  ;; f=function; a=twice argument
   (let ((sw (memq f '(%cos %cot %coth %cosh))))
     (cond ((memq f '(%sin %cos))
	    (power (div (add 1 (porm sw (take '(%cos) a))) 2) (1//2)))
	   ((memq f '(%tan %cot))
	    (div (add 1 (porm sw (take '(%cos) a))) (take '(%sin) a)))
	   ((memq f '(%sinh %cosh))
	    (power (div (add (take '(%cosh) a) (porm sw 1)) 2) (1//2)))
	   ((memq f '(%tanh %coth))
	    (div (add (take '(%cosh) a) (porm sw 1)) (take '(%sinh) a)))
	   ((memq f '(%sec %csc %sech %csch))
	    (inv (halfangleaux (get f 'recip) a))))))
