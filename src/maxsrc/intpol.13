;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Interpolation routine by CFFK.

(macsyma-module intpol)
(load-macsyma-macros transm numerm)

(declare (special $intpolrel $intpolabs $intpolerror)
	 (flonum $intpolrel $intpolabs a b c fa fb fc)
	 (fixnum lin)
	 (notype (interpolate-check flonum flonum flonum flonum))) 

(COMMENT  |  For historical information ONLY.  |
(defun fmeval2 (x) 
       (cond ((fixp (setq x (meval x))) (float x))
	     ((floatp x) x)
	     (t (displa x) (error '|not floating point|))))
(defun qeval (y x z) (cond (x (fmeval2 (list '($ev) y (list '(mequal) x z) '$numer)))
			   (t (funcall y z))))
)

(or (boundp '$intpolabs) (setq $intpolabs 0.0)) 
(or (boundp '$intpolrel) (setq $intpolrel 0.0))
(or (boundp '$intpolerror) (setq $intpolerror t))

(Defun $interpolate_SUBR (F LEFT RIGHT)
  (BIND-TRAMP1$
   F F
   (prog (a b c fa fb fc lin)
     (declare (flonum a b c fa fb fc) (fixnum lin))
     (setq A (FLOAT LEFT)
	   B (FLOAT RIGHT))
     (or (> b a) (setq a (prog2 niL b (setq b a))))
     (setq fa (FCALL$ f a)
	   fb (FCALL$ f b))
     (or (> (abs fa) $intpolabs) (return a))
     (or (> (abs fb) $intpolabs) (return b))
     (and (> (*$ fa fb) 0.0)
	  (cond ((eq $intpolerror t)
		 (merror "function has same sign at endpoints~%~M"
			 `((mlist)
			   ((mequal) ((f) ,a) ,fa)
			   ((mequal) ((f) ,b) ,fb))))
		(t (return $intpolerror))))
     (and (> fa 0.0)
	  (setq fa (prog2 nil fb (setq fb fa)) a (prog2 nil b (setq b a))))
     (setq lin 0.)
    binary
     (setq c (//$ (+$ a b) 2.0)
	   fc
	   (FCALL$ f c))
     (and (interpolate-check a c b fc) (return c))
     (cond ((< (abs (-$ fc (//$ (+$ fa fb) 2.0))) (*$ 0.1 (-$ fb fa)))
	    (setq lin (1+ lin)))
	   (t (setq lin 0.)))
     (cond ((> fc 0.0) (setq fb fc b c)) (t (setq fa fc a c)))
     (or (= lin 3.) (go binary))
    falsi
     (setq c (cond ((> (+$ fb fa) 0.0)
		    (+$ a (*$ (-$ b a) (//$ fa (-$ fa fb)))))
		   (t (+$ b (*$ (-$ a b) (//$ fb (-$ fb fa)))))) 
	   fc (FCALL$ f c))
     (and (interpolate-check a c b fc) (return c))
     (cond ((> fc 0.0) (setq fb fc b c)) (t (setq fa fc a c)))
     (go falsi))))

(defun interpolate-check (a c b fc)
       (not (and (prog2 nil (> (abs fc) $intpolabs) (setq fc (max (abs a) (abs b))))
		 (> (abs (-$ b c)) (*$ $intpolrel fc))
		 (> (abs (-$ c a)) (*$ $intpolrel fc)))))




(DEFUN INTERPOLATE-MACRO (FORM TRANSLP)
       (SETQ FORM (CDR FORM))
       (COND ((= (LENGTH FORM) 3)
	      (COND (TRANSLP
		     `(($INTERPOLATE_SUBR) ,@FORM))
		    (T
		     `((MPROG) ((MLIST) ((msetq) $NUMER T))
			       (($INTERPOLATE_SUBR)  ,@FORM)))))
	     ((= (LENGTH FORM) 4)
	      (LET (((EXP VAR . BNDS) FORM))
		   (SETQ EXP (SUB ($LHS EXP) ($RHS EXP)))
		   (COND (TRANSLP
			  `(($INTERPOLATE_SUBR)
			    ((LAMBDA-I) ((MLIST) ,VAR)
					(($MODEDECLARE) ,VAR $FLOAT)
					,EXP)
			    ,@BNDS))
			 (T
			  `((MPROG) ((MLIST) ((msetq) $NUMER T))
				    (($INTERPOLATE_SUBR)
				     ((LAMBDA) ((MLIST) ,VAR) ,EXP)
				     ,@BNDS))))))
	     (T (merror "wrong number of args to INTERPOLATE"))))

(DEFMSPEC $INTERPOLATE (FORM)
  (MEVAL (INTERPOLATE-MACRO FORM NIL)))

(def-translate-property $INTERPOLATE (FORM)
  (let (($tr_numer t))
    (TRANSLATE (INTERPOLATE-MACRO FORM t))))


