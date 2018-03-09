;;; -*- Mode: Lisp; Package: Macsyma -*-
;;;
;;;	** (c) Copyright 1981 Massachusetts Institute of Technology **
;;;
;;; Toplevel Functions: ($ASKINTEGER EXP <OPTIONAL-ARG>)
;;;
;;;                      EXP -> any Macsyma expression.
;;;                      <OPTIONAL-ARG> -> $EVEN, $ODD, $INTEGER.
;;;                                        If not given, defaults to $INTEGER.
;;;                      
;;;                      returns -> $YES, $NO, $UNKNOWN.
;;;
;;; If LIMITP is non-NIL the facts collected will be consed onto the list
;;; INTEGER-INFO.
;;;
;;; Implementors Functions: (ASK-INTEGER <EXP> <WHAT-KIND>)
;;;                         same as $ASKINTEGER with less error checking and
;;;                         requires two arguments.
;;;
;;; Support Functions: ASK-EVOD -> is a symbol an even or odd number?
;;;                    ASK-INTEGERP -> is a symbol an integer?
;;;                    ASK-PROP -> ask the user a question about a symbol.
;;;

(macsyma-module askp)

(declare (special limitp integer-info)
	 (fixnum n)
	 (*expr evod free $numberp integerp retrieve $featurep
		sratsimp ssimplifya ratnump))
   
(defmfun $askinteger n
  (if (or (> n 2) (< n 1)) (wna-err '$askinteger))
  (if (= n 1) (ask-integer (arg 1) '$integer)
	      (if (memq (arg 2) '($even $odd $integer))
		  (ask-integer (arg 1) (arg 2))
		  (improper-arg-err (arg 2) '$askinteger))))

(defmfun ask-integer (x even-odd)
  (setq x (sratsimp (sublis '((z** . 0) (*z* . 0)) x)))
  (cond ((or (not (free x '$%pi)) (not (free x '$%i)) (ratnump x)) '$no)
	((eq even-odd '$integer) (ask-integerp x))
	(t (ask-evod x even-odd))))

(defun ask-evod (x even-odd)
  (let ((evod-ans (evod x)) (is-integer (integerp x)))
    (cond ((equal evod-ans even-odd) '$yes)
	  ((and ($numberp x) (not is-integer)) '$no)
	  ((and is-integer evod-ans) '$no)
	  ((eq (setq evod-ans
		     (ask-prop x
			       (if (eq even-odd '$even) '|even| '|odd|)
			       '|number|))
	       '$yes)
	   (ask-declare x even-odd) '$yes)
	  ((eq evod-ans '$no) 
	   (if is-integer 
	       (if (eq even-odd '$even) (ask-declare x '$odd)
				        (ask-declare x '$even)))
	   '$no)
	  (t '$unknown))))

(defun ask-integerp (x)
  (let (integer-ans)
    (if (and (mplusp x) (fixp (cadr x))) (setq x (addn (cddr x) t)))
    (cond ((integerp x) '$yes)
	  (($numberp x) '$no)
	  (($featurep x '$noninteger) '$no)
	  ((eq (setq integer-ans (ask-prop x '|integer| nil)) '$yes)
	   (ask-declare x '$integer) '$yes)
	  ((eq integer-ans '$no)
	   (ask-declare x '$noninteger) '$no)
	  (t '$unknown))))

(defun ask-declare (x property)
  (when (atom x)
	(meval `(($declare) ,x ,property))
	(if limitp 
	    (setq integer-info (cons `(($kind) ,x ,property) integer-info)))))

(defun ask-prop (object property fun-or-number)
       (if fun-or-number (setq fun-or-number (list '| | fun-or-number)))
;;; Asks the user a question about the property of an object.
;;; Returns only $yes, $no or $unknown.
       (do ((end-flag) (answer))
	   (end-flag (cond ((memq answer '($yes $y)) '$yes)
			   ((memq answer '($no $n)) '$no)
			   ((memq answer '($unknown $uk)) '$unknown)))
	   (setq answer (retrieve
			 `((mtext) |Is  | ,object 
				   ,(if (member (getcharn property 1)
					        '(#/a #/e #/i #/o #/u))
					'|  an |
					'|  a |)
				   ,property ,@fun-or-number |?|)
			 nil))
	   (cond 
	    ((memq answer '($yes $y $no $n $unknown $uk))
	     (setq end-flag t))
	    (t (mtell
		"~%Acceptable answers are Yes, Y, No, N, Unknown, Uk~%")))))

(declare (notype n))
