
(defun schemestart nargs
       (sstatus toplevel '(schemestart1))
       (nointerrupt nil)
       (^g))

(defun schemestart1 ()
       (sstatus toplevel nil)
       (cursorpos 'c)
       (cond ((not (= tty 5)) (scheme nil '|Quit|))
	     (t (scheme t '|SCHEME: Top Level|))))

(cond ((status feature newio)
       (sstatus ttyint '/ 'schemestart))
      (t (sstatus interrupt 16. 'schemestart)))

(declare (read))
(sstatus macro /% '(lambda ()()))
(declare (sstatus macro /% '(lambda () ((lambda (/%) (eval /%) /%) (read)))) )

(declare (mapex t) (macros t))

;first, some useful macros.

(declare (special *displace-sw* *displace-save-sw* *displace-list* *displace-count*))
%
(defun displace (x y)
   (cond ((atom y) y)
	 (*displace-sw*
	  (cond (*displace-save-sw*
		 (setq *displace-count* (1+ *displace-count*))
		 (setq *displace-list*
		       (cons (cons (cons (car x) (cdr x))
				   x)
			     *displace-list*))))
	  (rplaca x (car y))
	  (rplacd x (cdr y))
	  x)
	 (t y)) )
%
(or (boundp '*displace-sw*)
    (setq *displace-sw* t))
%
(or (boundp '*displace-save-sw*)
    (setq *displace-save-sw* t))
%
(or (boundp '*displace-list*)
    (setq *displace-list* nil))
%
(or (boundp '*displace-count*)
    (setq *displace-count* 0))
%
(defun replace ()
       ((lambda (n)
		(declare (fixnum n))
		(cond ((not (= n *displace-count*))
		       (terpri) (princ '|Someone's been hacking my *displace-list*!!!|)
		       (terpri) (princ '|Do it again and I won't speak to you anymore.|)
		       (break replace-lossage t)))
		(mapc '(lambda (z)
			(rplaca (cdr z) (caar z))
			(rplacd (cdr z) (cdar z)))
		      *displace-list*)
		(setq *displace-count* 0)
		(setq *displace-list* nil))
	(length *displace-list*)))
%
(defun qexpander (m)
       (prog (x y)
	     (cond ((atom m) (return (list 'quote m)))
		   ((eq (car m) '/,) (return (cdr m)))
		   ((and (not (atom (car m)))
			 (eq (caar m) '/@))
		    (return (list 'append (cdar m) (qexpander (cdr m))))))
	     (setq x (qexpander (car m))
		   y (qexpander (cdr m)))
	     (and (not (atom x))
		  (not (atom y))
		  (eq (car x) 'quote)
		  (eq (car y) 'quote)
		  (eq (cadr x) (car m))
		  (eq (cadr y) (cdr m))
		  (return (list 'quote m)))
	     (return (list 'cons x y))))

%(defun qmac () (qexpander (read)))
%(defun cmac () (cons '/, (read)))
%(defun amac () (cons '/@ (read)))

%(sstatus macro /" 'qmac)
%(sstatus macro /, 'cmac)
%(sstatus macro /@ 'amac))

(defprop let amacro aint)

(defun let macro (x)
   (displace x
	     "((lambda ,(mapcar 'car (cadr x)) ,(blockify (cddr x)))
	       @(mapcar 'cadr (cadr x)))))

(defun if macro (x)
       (displace x
		 "(cond (,(cadr x) ,(caddr x))
			(t ,(cadddr x)))))

(putprop 'if (prog2 nil (get 'if 'aint) (remprop 'if 'aint)) 'aint)

(declare (special **doname** **dobody**))

(defprop do ado amacro) (defprop do amacro aint)

(defun ado (x)
   (displace x
      "(labels ((,**doname**
                  (lambda (,**dobody** @(mapcar 'car (cadr x)))
                          (if ,(caaddr x) ,(blockify (cdaddr x))
                              (,**doname** ,(blockify (cdddr x))
                                       @(mapcar '(lambda (y)
							 (cond ((and (cdr y) (cddr y))
								(caddr y))
							       (t (car y))))
						(cadr x)))))))
          (,**doname** nil @(mapcar '(lambda (y) (and (cdr y) (cadr y))) (cadr x))))))

(setq **doname** (maknam (explodec '*doloop*)))
(setq **dobody** (maknam (explodec '*dobody*)))

(defprop cond acond amacro) (defprop cond amacro aint)

(defun acond (x)
       (cond ((null (cdr x)) (error '|Peculiar Cond| x 'fail-act))
	     (t (displace x (acond1 (cdr x))))))

(defun acond1 (x)
      (cond ((null x) nil)
            ((eq (caar x) 't) (blockify (cdar x)))
	    ((null (cdar x))
	     "(test ,(caar x)
		    (lambda (x) x)
		    ,(acond1 (cdr x))))
	    ((eq (cadar x) '=>)
	     "(test ,(caar x) ,(caddar x)
		     ,(acond1 (cdr x))))
            (t "(if ,(caar x) ,(blockify (cdar x))
                    ,(acond1 (cdr x))))))

(defprop test atest amacro) (defprop test amacro aint)

(defun atest (x)
       (displace x
		 "((lambda (a b c)
			   (if a (b a) (c)))
		   ,(cadr x)
		   ,(caddr x)
		   (lambda () ,(cadddr x)))))

;(defprop block ablock amacro) (defprop block amacro aint)

;(defun ablock (x)
;       (cond ((or (null (cdr x))
;                  (null (cddr x)))
;              (error '|Peculiar Block| x 'fail-act))
;	     ((null (cdddr x))
;	      (cond ((eq (cadadr x) '/:=)
;		     (displace x
;			 "((lambda ,(cond ((atom (caadr x))
;					   (list (caadr x)))
;					  (t (caadr x)))
;				   ,(caddr x))
;			   @(cddadr x))))
;		    (t (displace x
;			   "((lambda (a b) (b)) ,(cadr x) (lambda () ,(caddr x)))))))
;	     (t (displace x
;		    "(block ,(cadr x) (block @(cddr x)))))))

(defun blockify (x)
       (cond ((null x) nil)
             ((null (cdr x)) (car x))
             (t "(block @x))))

(defprop and aand amacro) (defprop and amacro aint)

(defun aand (x)
       (displace x (cond ((or (null (cdr x))
			      (null (cddr x)))
			  (error '|Peculiar And| x 'wrng-no-args))
			 (t (aand1 (cdr x))))))

(defun aand1 (x)
       (cond ((null (cdr x)) (car x))
	     (t "(if ,(car x) ,(aand1 (cdr x)) nil))))

(defprop or aor amacro) (defprop or amacro aint)

(defun aor (x)
       (displace x (cond ((or (null (cdr x))
			      (null (cddr x)))
			  (error '|Peculiar Or| x 'wrng-no-args))
			 (t (aor1 (cdr x))))))

(defun aor1 (x)
       (cond ((null (cdr x)) (car x))
	     (t "(test ,(car x)
		       (lambda (x) x)
		       ,(aor1 (cdr x))))))

(defun orify (x)
       (cond ((null x) nil)
	     ((null (cdr x)) (car x))
	     (t (cons 'or x))))

(defprop amapcar amapcar1 amacro) (defprop amapcar amacro aint)

(defun amapcar1 (x)
       (cond ((null (cddr x))
	      (error '|Peculiar Amapcar| x 'wrng-no-args))
	     (t ((lambda (names)
		     (displace x
			 "(do ((,(car names)
				nil
				(cons (,(cadr x) @(mapcar '(lambda (y) "(car ,y))
							   (cdr names)))
				      ,(car names)))
			       @(mapcar '(lambda (y n) "(,n ,y (cdr ,n)))
					 (cddr x)
					 (cdr names)))
			      (,(orify (mapcar '(lambda (n) "(null ,n)) (cdr names)))
			       (nreverse ,(car names))))))
		 (do ((z (cdr x) (cdr z))
		      (n nil (cons (gensym) n)))
		     ((null z) n))))))

(defprop amapc amapc1 amacro) (defprop amapc amacro aint)

(defun amapc1 (x)
       (cond ((null (cddr x))
	      (error '|Peculiar Amapc| x 'wrng-no-args))
	     (t ((lambda (names)
		     (displace x
			 "(do ,(mapcar '(lambda (y n) "(,n ,y (cdr ,n)))
					 (cddr x)
					 names)
			      (,(orify (mapcar '(lambda (n) "(null ,n)) names))
			       nil)
			      (,(cadr x)
			       @(mapcar '(lambda (y) "(car ,y))
					names)))))
		 (do ((z (cddr x) (cdr z))
		      (n nil (cons (gensym) n)))
		     ((null z) n))))))

(defprop amaplist amaplist1 amacro) (defprop amaplist amacro aint)

(defun amaplist1 (x)
       (cond ((null (cddr x))
	      (error '|Peculiar Amaplist| x 'wrng-no-args))
	     (t ((lambda (names)
		     (displace x
			 "(do ((,(car names)
				nil
				(cons (,(cadr x) @(cdr names)) ,(car names)))
			       @(mapcar '(lambda (y n) "(,n ,y (cdr ,n)))
					 (cddr x)
					 (cdr names)))
			      (,(orify (mapcar '(lambda (n) "(null ,n)) (cdr names)))
			       (nreverse ,(car names))))))
		 (do ((z (cdr x) (cdr z))
		      (n nil (cons (gensym) n)))
		     ((null z) n))))))

(defprop arraycall aarraycall amacro) (defprop arraycall amacro aint)

(defun aarraycall (x)
       (displace x
		 "(funcall @(cddr x))))

(defprop uread afsubr amacro) (defprop uread amacro aint)
(defprop uwrite afsubr amacro) (defprop uwrite amacro aint)
(defprop ufile afsubr amacro) (defprop ufile amacro aint)
(defprop grindef afsubr amacro) (defprop grindef amacro aint)
(defprop fasload afsubr amacro) (defprop fasload amacro aint)
(defprop edit afsubr amacro) (defprop edit amacro aint)
(defprop status afsubr amacro) (defprop status amacro aint)
(defprop sstatus afsubr amacro) (defprop sstatus amacro aint)
(defprop setq afsubr amacro) (defprop setq amacro aint)
(defprop defprop afsubr amacro) (defprop defprop amacro aint)
(defprop break afsubr amacro) (defprop break amacro aint)
(defprop defun afsubr amacro) (defprop defun amacro aint)
(defprop trace afsubr amacro) (defprop trace amacro aint)
(defprop untrace afsubr amacro) (defprop untrace amacro aint)
(defprop grindef afsubr amacro) (defprop grindef amacro aint)
(defprop comment afsubr amacro) (defprop comment amacro aint)
(defprop declare afsubr amacro) (defprop declare amacro aint)
(defprop proclaim afsubr amacro) (defprop proclaim amacro aint)
(defprop include afsubr amacro) (defprop include amacro aint)

(defun afsubr (x) "(eval ',x))

(defun proclaim fexpr (x) 'proclamation)

(declare (special **genprogtag**))

(defun genprogtag ()
       ((lambda (base *nopoint)
		(implode (append '(T A G)
				 (explodec (setq **genprogtag**
						 (1+ **genprogtag**))))))
	10.
	t))

(setq **genprogtag** 0)

(defprop go ago amacro) (defprop go amacro aint)

(defun ago (x) (error '|Illegal GO| x 'unseen-go-tag))

(defprop return areturn amacro) (defprop return amacro aint)

(defun areturn (x) (error '|Illegal RETURN| x 'unseen-go-tag))

(defprop prog aprog amacro) (defprop prog amacro aint)

(defun aprog (x)
       (displace x (aprog1 (cdr x) nil nil)))

(defun aprog1 (x rnl ret)
       "((lambda ,(car x) ,(aprog2 (cdr x) rnl ret))
	 @(mapcar '(lambda (x) nil) (car x))))

(defun aprog2 (body rnl ret)
       ((lambda (stuff)
		"(labels ,(maplist '(lambda (z)
					"(,(caar z)
					  (lambda ()
					      ,(aprogx (cadar z)
						       (cond ((cdr z) (caadr z))
							     (t ret))
						       (cdr stuff)
						       ret))))
				    (car stuff))
			  (,(caaar stuff))))
	(aprog3 body rnl ret)))

(defun aprog3 (body rnl ret)
       (do ((b body (cdr b))
	    (r rnl)
	    (tags nil
		  (and (atom (car b)) (cons (car b) tags)))
	    (x nil
	       (cond ((atom (car b)) x)
		     (t ((lambda (g)
			     (setq r (do ((z tags (cdr z))
					  (y r (cons (cons (putprop g (car z) 'gotag)
							   g)
						     y)))
					 ((null z) y)))
			     (cons (list g (car b)) x))
			 (genprogtag))))))
	   ((null b)
	    (cons (nreverse x)
		  (do ((z tags (cdr z))
		       (y r (cons (cons (car z) ret) y)))
		      ((null z) y))))))

(defun aprogx (form next rnl ret)
       (cond ((atom form)
	      (cond (next "(,next))
		    (t (error '|What The Hell? - PROG| form 'fail-act))))
	     ((eq (car form) 'go)
	      ((lambda (x)
		   (cond ((null x)
			  (error '|Illegal GO| form 'unseen-go-tag))
			 (t "(,(cdr x)))))
	       (assq (cadr form) rnl)))
	     ((eq (car form) 'return)
	      (cond (ret "(,ret))
		    (t (cadr form))))
	     ((eq (car form) 'if)
	      "(if ,(cadr form)
		   ,(aprogx (caddr form) next rnl ret)
		   ,(aprogx (cadddr form) next rnl ret)))
	     ((eq (car form) 'lambda)
	      "(lambda ,(cadr form) ,(aprogx (caddr form) next rnl ret)))
	     ((eq (car form) 'labels)
	      "(labels @(mapcar '(lambda (x) "(,(car x)
					       ,(aprogx (cadr x) next rnl ret)))
				(cadr form))
		       ,(aprogx (caddr form) next rnl ret)))
	     ((eq (car form) 'prog)
	      (aprog1 (cdr form) rnl next))
	     ((and (atom (car form))
		   (get (car form) 'amacro))
	      (aprogx (apply (get (car form) 'amacro) form)
		      next rnl ret))
	     (t ((lambda (fm)
		     (cond (next "(block ,fm (,next)))
			   (t fm)))
		 (mapcar '(lambda (x)
				      (cond ((atom x) x)
					    ((eq (car x) 'lambda)
					     (aprogx x next rnl ret))
					    (t x)))
				 form)))))

(defprop thunk athunk amacro) (defprop thunk amacro aint)

(defun athunk (x)
       (displace x
		 "(cons (lambda (,(cond ((eq (cadr x) 'newval)
					 'the-newval)
					(t 'newval)))
				,(cond ((eq (typep (cadr x)) 'symbol)
					"(aset' ,(cadr x)
						 ,(cond ((eq (cadr x) 'newval)
							 'the-newval)
							(t 'newval))))
				       (t "(error ',(implode (append
							      (explodec '|cannot be assigned to the call-by-name parameter |)
							      (explode (cadr x))))
						  ,(cond ((eq (cadr x) 'newval)
							  'the-newval)
							 (t 'newval))
						  'fail-act))))
			(lambda () ,(cadr x)))))

(defprop thunkget athunkget amacro) (defprop thunkget amacro aint)

(defun athunkget (x)
       (or (eq (typep (cadr x)) 'symbol)
	   (error '|Bad thunk variable - THUNKGET| x 'wrng-type-arg))
       (displace x
		 "((cdr ,(cadr x)))))

(defprop thunkset athunkset amacro) (defprop thunkset amacro aint)

(defun athunkset (x)
       (or (eq (typep (cadr x)) 'symbol)
	   (error '|Bad thunk variable - THUNKSET| x 'wrng-type-arg))
       (displace x
		 "((car ,(cadr x)) ,(caddr x))))

; Defmac's allow for variable lists of the form (a1 ,,, an)
;  or alternatively, allow a dotted list construction (a1 ,,, an-1 . an)
;  so that an will be bound to the remainder of the calling form.
; In addition, the list of arguments will be bound to the given
;  variable in LSUBR fashion if a variable (not a list) is supplied.

(declare (defun /@define fexpr (x) nil)
	 (/@define defmac |lisp macro|))

(defprop defmac amacro aint)

(defun defmac macro (x)			;define MacLISP macro
       (displace x
		 "(progn

		   'compile

		   (defprop ,(cadr x) amacro aint)

		   (defun ,(cadr x) macro (*z*)
			   (displace *z*
				     ((lambda ,(do ((a (caddr x) (cdr a))
						    (b nil (cons (car a) b)))
						   ((or (null a) (eq (typep a) 'symbol))
						    (cond ((null a) (nreverse b))
							  (t (nreverse (cons a b))))))
					       ,(cadddr x))
				      @(do ((a (caddr x) (cdr a))
					    (b '(cdr *z*) "(cdr ,b))
					    (c nil (cons "(car ,b) c)))
					   (nil)
					   (cond ((null a) (return (nreverse c)))
						 ((eq (typep a) 'symbol)
						  (return
						   (nreverse (cons b c))))))))))))

;SCHMACs are for SCHEME what DEFMACs are for LISP, with similar syntax.

(declare (/@define schmac |scheme macro|))

(defprop schmac amacro aint)

(defun schmac macro (x)			;define SCHEME macro
       ((lambda (newname)
		(displace x
			  "(progn 'compile
				  (defprop ,(cadr x) amacro aint)
				  (defprop ,(cadr x) ,newname amacro)
				  (defun ,newname (*z*)
					 (displace *z*
						   ((lambda ,(do ((a (caddr x) (cdr a))
								  (b nil (cons (car a) b)))
								 ((or (null a)
								      (eq (typep a) 'symbol))
								  (cond ((null a) (nreverse b))
									(t (nreverse
									    (cons a b))))))
							    ,(cadddr x))
						    @(do ((a (caddr x) (cdr a))
							  (b '(cdr *z*) "(cdr ,b))
							  (c nil (cons "(car ,b) c)))
							 (nil)
							 (cond ((null a) (return (nreverse c)))
							       ((eq (typep a) 'symbol)
								(return
								 (nreverse (cons b c))))))))))))
	(implode (append (explodec (cadr x)) '(- a m a c r o)))))

