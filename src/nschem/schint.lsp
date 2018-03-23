
;for compiler, speedup hacks.

(declare (mapex t)
         (special **exp** **beta** **vals** **unevlis** **evlis** **pc** **clink**
                  **fun** **val** **tem** **fluid!vars** **fluid!vals**
                  **queue** **tick** **quantum** **process** **procnum**
                  **jpcr** version lispversion))

(defun version macro (x)
       (cond (compiler-state
	      (list 'quote
		    (cond ((status feature newio) (list (namestring (truename infile))))
			  (t (status uread)))))
	     (t (rplaca x 'quote)
		(rplacd x (list version))
		(list 'quote version))))

(declare (read))

(setq version ((lambda (compiler-state) (version)) t))

(defun fastcall (atsym)
       (cond ((eq (car (cdr atsym)) 'subr)
	      (subrcall nil (cadr (cdr atsym))))
	     (t ((lambda (subr)
			 (cond ((and subr
				     (null (get atsym 'expr)))	;don't screw TRACE
				(remprop atsym 'subr)
				(putprop atsym subr 'subr)
				(subrcall nil subr))
			       (t (apply atsym nil))))
		 (get atsym 'subr)))))

;control stack stuff

(defun push macro (l) (list 'setq '**clink** (push1 (cdr l))))

(declare (eval (read)))

(defun push1 (x)
       (cond ((null x) '**clink**)
             (t (list 'cons (car x) (push1 (cdr x))))))

(defun top macro (l)
   (list 
     (list 'lambda '(ltem)
       (cons 'setq
             (mapcan '(lambda (x)
                        (list x '(car ltem)  'ltem '(cdr ltem) ))
                     (cdr l))))
     '**clink**))

(defun pop macro (l)
 (list 'setq '**clink**
   (list 
     (list 'lambda '(ltem)
       (cons 'setq
             (mapcan '(lambda (x)
                        (list x '(car ltem)  'ltem '(cdr ltem) ))
                     (cdr l))))
     '**clink**)))

(defun 1st macro (l) (list 'car '**clink**))
(defun 2nd macro (l) (list 'cadr '**clink**))
(defun 3rd macro (l) (list 'caddr '**clink**))


;environment manipulation

(defun betacons (lamb obeta ovals name)
       (cons 'beta
             (cons (reverse (cadr lamb))
                   (cons (cons obeta ovals)
                         (cons (caddr lamb) name)))))

(defun bind (newvars newvals name)
       (setq **beta** (cons name
                            (cons newvars
                                  (cons (cons **beta** **vals**)
                                        nil)))
             **vals** newvals))

(defun vars macro (l) (list 'cadr (cadr l)))

(defun obeta macro (l) (list 'caaddr (cadr l)))

(defun ovals macro (l) (list 'cdaddr (cadr l)))

(defun body macro (l) (list 'cadddr (cadr l)))

(defun name macro (l) (list 'cddddr (cadr l)))

(defun lookup (identifier beta vals)
       (prog (vars)
        nextbeta
           (setq vars (vars beta))
        nextvar
           (cond ((null vars)
                  (setq vals (ovals beta))
                  (cond ((setq beta (obeta beta)) (go nextbeta))
                        (t (return nil))))
                 ((eq identifier (car vars)) (return vals))
                 (t (setq vars (cdr vars)
                          vals (cdr vals))
                    (go nextvar)))))

(defun locin macro (l) (list 'car (cadr l)))


;Enclose is the user level operator for making lambda expressions into closures.
;  The first argument is the lambda expression, the second is an arbitrary name to
;  be printed out by WHERE.

(defun enclose nargs
       (betacons (arg 1)
		 nil
		 nil
		 (cond ((> nargs 1) (arg 2))
		       (t '*anonymous-closure*))))

(defprop moonphase (phase fasl dsk liblsp) autoload)
(defprop phaseprinc (phsprt fasl dsk liblsp) autoload)
(defprop datimprinc (phsprt fasl dsk liblsp) autoload)
(defprop sunposprinc (phsprt fasl dsk liblsp) autoload)

;basic interpreter -- initialization, main-loop, time slicing.

(defun scheme (garbagep prompt)
       (cond (garbagep
	      (setq version (version)  lispversion (status lispversion))
	      (terpri)
	      (princ '|This is SCHEME |)
	      (princ version)
	      (princ '| running in LISP |)
	      (princ lispversion)
	      (princ '|.|)
	      (terpri)
	      (princ '|   |)
	      (phaseprinc (moonphase))
	      (terpri)
	      (princ '|   |)
	      (sunposprinc)
	      (terpri)
	      (princ '|   |)
	      (datimprinc 'hack)))
       (setq **beta** nil  **vals** nil  **fluid!vars** nil  **fluid!vals** nil
	     **queue** nil
             **process** (create!process (list '**top** (list 'quote prompt) ''|==> |)))
       (swapinprocess)
       (alarmclock 'runtime **quantum**)
       (mloop))

(defun mloop ()			;The "machine".
       (do ((**tick** nil))  (nil)
	  (and **jpcr** (inc-jpcr))
          (and **tick** (allow) (schedule))
          (fastcall **pc**)))

(defun inc-jpcr ()
       (cond ((eq (car **jpcr**) **beta**))
	     (t (setq **jpcr** (cddr **jpcr**))
		(rplaca **jpcr** **beta**)
		(rplaca (cdr **jpcr**) **vals**))))

(defun set-jpcr (n)
       (setq **jpcr** nil)
       (do i n (- i 1) (= i 0)
	   (setq **jpcr** (nconc (list nil nil) **jpcr**)) )
       (nconc **jpcr** **jpcr**))

(setq **jpcr** nil)

(defun allow ()
  ((lambda (vcell)
       (cond (vcell (car vcell))
             (t t)))
   (lookup '*allow* **beta** **vals**)))

(defun schedule ()
       (cond (**queue**
	      (swapoutprocess)
	      (nconc **queue** (list **process**))
	      (setq **process** (car **queue**)
		    **queue** (cdr **queue**))
	      (swapinprocess)))
       (setq **tick** nil)
       (alarmclock 'runtime **quantum**))

(defun swapoutprocess ()
       (putprop **process**
                (list **exp** **beta** **vals** **evlis** **unevlis** **pc** **clink**
		      **fun** **fluid!vars** **fluid!vals** **val** **tem**)
                '**process**))

(defun swapinprocess () 
       (mapc 'set
             '(**exp** **beta** **vals** **evlis** **unevlis** **pc** **clink**
	       **fun** **fluid!vars** **fluid!vals** **val** **tem**)
             (get **process** '**process**) ))

(defun settick (x) (setq **tick** t))
(setq **quantum** 1000000. alarmclock 'settick)

;central evaluator functions.

(defun symbol-value (symbol beta vals)
       (cond ((setq **tem** (lookup symbol beta vals))
	      (locin **tem**))
	     ((getl symbol '(subr expr lsubr)))
	     ((boundp symbol) (symeval symbol))
	     (t (symbol-value (error '|Unbound Symbol| symbol 'unbnd-vrbl) beta vals))))

(defun dispatch ()
       (cond ((atom **exp**)
              (cond ((numberp **exp**) (setq **val** **exp**))
		    (t (setq **val** (symbol-value **exp** **beta** **vals**)))))
	     ((eq (car **exp**) 'lambda)
	      (setq **val** (betacons **exp** **beta** **vals** **exp**)))
	     (t (dispatch1))))

(defun dispatch1 ()			;This winning bum is due to Charlie Rich.
       (cond ((atom (car **exp**))
              (cond ((setq **tem** (get (car **exp**) 'aint))
                     (fastcall **tem**))
		    (t (setq **fun** (symbol-value (car **exp**) **beta** **vals**))
		       (setq **unevlis** (cdr **exp**)  **evlis** nil)
		       (evlis-nopush))))
	     ((eq (caar **exp**) 'lambda)
	      (setq **fun** (betacons (car **exp**) **beta** **vals** (car **exp**)))
	      (setq **unevlis** (cdr **exp**)  **evlis** nil)
	      (evlis-nopush))
	     ((null (cdr **exp**))
	      (push **pc**)
	      (setq **exp** (car **exp**)  **pc** 'nargs)
	      (dispatch1))
             (t (push **exp** **beta** **vals** **pc**)
                (setq **exp** (car **exp**)  **pc** 'gotfun)
                (dispatch1))))

(defun evlis-nopush ()
       (cond ((null **unevlis**)
	      (setq **unevlis** **pc**  **pc** 'tapply))
	     ((atom (car **unevlis**))
	      (setq **evlis**
		    (cons (cond ((numberp (car **unevlis**))
				 (car **unevlis**))
				(t (symbol-value (car **unevlis**) **beta** **vals**)))
			  **evlis**)
		    **unevlis** (cdr **unevlis**))
	      (evlis-nopush))
	     ((eq (caar **unevlis**) 'lambda)
	      (setq **evlis**
		    (cons (betacons (car **unevlis**) **beta** **vals** (car **unevlis**))
			  **evlis**)
		    **unevlis** (cdr **unevlis**))
	      (evlis-nopush))
	     ((null (cdr **unevlis**))
	      (push **evlis** **fun** **pc**)
	      (setq **exp** (car **unevlis**)  **pc** 'evlast)
	      (dispatch1))
	     (t (push **evlis** **unevlis** **fun** **beta** **vals** **pc**)
		(setq **exp** (car **unevlis**)  **pc** 'evlis1)
		(dispatch1))))

(defun tapply () (setq **pc** **unevlis**) (sapply))

(defun gotfun ()
       (pop **exp**)
       (push **val**)			;stack = fun,beta,vals,pc.
       (setq **unevlis** (cdr **exp**)  **evlis** nil)
       (evlis))

(defun evlis ()
       (cond ((null **unevlis**)
              (pop **fun** **beta** **vals** **pc**)
	      (sapply))
	     ((atom (car **unevlis**))
	      (setq **evlis**
		    (cons (cond ((numberp (car **unevlis**))
				 (car **unevlis**))
				(t (symbol-value (car **unevlis**) (2nd) (3rd))))
			  **evlis**)
		    **unevlis** (cdr **unevlis**))
	      (evlis))
	     ((eq (caar **unevlis**) 'lambda)
	      (setq **evlis**
		    (cons (betacons (car **unevlis**) (2nd) (3rd) (car **unevlis**))
			  **evlis**)
		    **unevlis** (cdr **unevlis**))
	      (evlis))
	     ((null (cdr **unevlis**))
	      (pop **fun** **beta** **vals**)
	      (push **evlis** **fun**)
	      (setq **exp** (car **unevlis**)  **pc** 'evlast)
	      (dispatch1))
             (t (top **fun** **beta** **vals**)
                (push **evlis** **unevlis**) 
                (setq **exp** (car **unevlis**) **pc** 'evlis1)
                (dispatch1))))

(defun evlis1 ()
      (pop **evlis** **unevlis**)
      (setq **evlis** (cons **val** **evlis**)  **unevlis** (cdr **unevlis**))
      (evlis))

(defun evlast ()
       (pop **evlis** **fun** **pc**)
       (setq **evlis** (cons **val** **evlis**))
       (sapply))

(defun nargs ()
       (pop **pc**)
       (setq **evlis** nil  **fun** **val**)
       (sapply))

(defun sapply ()
       (cond ((eq (car **fun**) 'subr)
	      (setq **val** (revsubrapply **fun** **evlis**)))
	     ((eq (car **fun**) 'lsubr)
	      (setq **val** (revlsubrapply **fun** **evlis**)))
	     ((eq (car **fun**) 'beta)
	      (setq **exp** (body **fun**) **beta** **fun** **vals** **evlis**)
	      (dispatch))
	     ((eq (car **fun**) 'expr)
	      (setq **val** (revapply (cadr **fun**) **evlis**)))
	     ((eq (car **fun**) 'cbeta)
	      (compiled-beta-entry))		;See SCHUUO
	     ((eq (car **fun**) 'delta)
	      (setq **clink** (cadr **fun**))
	      (pop **beta** **vals** **fluid!vars** **fluid!vals** **pc**)
	      (setq **val** (car **evlis**)))
	     (t (error '|Bad Function - Evlis| **fun** 'fail-act))))

(defun revapply (fn vals)
       (prog (a b c d e)
	     (or vals (return (funcall fn)))
	     (setq a (car vals) vals (cdr vals))
	     (or vals (return (funcall fn a)))
	     (setq b (car vals) vals (cdr vals))
	     (or vals (return (funcall fn b a)))
	     (setq c (car vals) vals (cdr vals))
	     (or vals (return (funcall fn c b a)))
	     (setq d (car vals) vals (cdr vals))
	     (or vals (return (funcall fn d c b a)))
	     (setq e (car vals) vals (cdr vals))
	     (or vals (return (funcall fn e d c b a)))
	     (return (apply fn (reverse vals)))))

(defun revsubrapply (fn vals)
       (prog (a b c d e)
	     (or vals (return (subrcall nil (cadr fn))))
	     (setq a (car vals) vals (cdr vals))
	     (or vals (return (subrcall nil (cadr fn) a)))
	     (setq b (car vals) vals (cdr vals))
	     (or vals (return (subrcall nil (cadr fn) b a)))
	     (setq c (car vals) vals (cdr vals))
	     (or vals (return (subrcall nil (cadr fn) c b a)))
	     (setq d (car vals) vals (cdr vals))
	     (or vals (return (subrcall nil (cadr fn) d c b a)))
	     (setq e (car vals) vals (cdr vals))
	     (or vals (return (subrcall nil (cadr fn) e d c b a)))
	     (error '|Too Many Arguments to a Subr| (cons fn vals) 'wrng-no-args)))

(defun revlsubrapply (fn vals)
       (prog (a b c d e temp)
	     (setq temp vals)
	     (or temp (return (lsubrcall nil (cadr fn))))
	     (setq a (car temp) temp (cdr temp))
	     (or temp (return (lsubrcall nil (cadr fn) a)))
	     (setq b (car temp) temp (cdr temp))
	     (or temp (return (lsubrcall nil (cadr fn) b a)))
	     (setq c (car temp) temp (cdr temp))
	     (or temp (return (lsubrcall nil (cadr fn) c b a)))
	     (setq d (car temp) temp (cdr temp))
	     (or temp (return (lsubrcall nil (cadr fn) d c b a)))
	     (setq e (car temp) temp (cdr temp))
	     (or temp (return (lsubrcall nil (cadr fn) e d c b a)))
	     (setplist 'the-lsubr-apply-atom fn)
	     (return (apply 'the-lsubr-apply-atom (reverse vals)))))

;Basic AINTs.

(defprop evaluate aeval aint)

(defun aeval ()
       (push **beta** **vals** **pc**)
       (setq **exp** (cadr **exp**)  **pc** 'aeval1)
       (dispatch))

(defun aeval1 ()
       (pop **beta** **vals** **pc**)
       (setq **exp** **val**)
       (dispatch))


(defprop if aif aint)

(defun aif ()
       (push **exp** **beta** **vals** **pc**)
       (setq **exp** (cadr **exp**)  **pc** 'if1)
       (dispatch))

(defun if1 ()
       (pop **exp** **beta** **vals** **pc**)
       (setq **exp** (cond (**val** (caddr **exp**)) (t (cadddr **exp**))))
       (dispatch))


(defprop block ablock aint)


(defun ablock ()
       (push **beta** **vals** **pc**)
       (setq **unevlis**
	     (or (cdr **exp**)
		 (error '|Strange Block -- Ablock| **exp** 'fail-act)))
       (ablock1))

(defun ablock1 ()
       (cond ((cdr **unevlis**)
	      (top **beta** **vals**)
	      (push **unevlis**)
	      (setq **pc** 'ablock2))
	     (t (pop **beta** **vals** **pc**)))
       (setq **exp** (car **unevlis**))
       (dispatch))

(defun ablock2 ()
       (pop **unevlis**)
       (setq **unevlis** (cdr **unevlis**))
       (ablock1))

(defprop quote aquote aint)

(defun aquote () (setq **val** (cadr **exp**)))


(defprop labels alabels aint)

(defun alabels ()
       (bind (mapcar 'car (cadr **exp**))
             (mapcar 'car (cadr **exp**))
             'labels)
       (map '(lambda (defl vall)
		     (rplaca vall
			     (betacons (cadar defl)
				       **beta**
				       **vals**
				       (caar defl))))
	    (cadr **exp**)
	    **vals**)
       (setq **exp** (caddr **exp**))
       (dispatch))


;Amacros for SCHEME syntax extension.

(defun amacro ()
       (setq **tem** (getl (car **exp**) '(amacro macro)))
       (setq **exp** (funcall (cadr **tem**) **exp**))
       (dispatch))


;Side effects.

(defprop define adefine aint)

(defun adefine () (setq **val** (eval **exp**)))

(defun define fexpr (l)
       (setq **tem** (cond ((cdr l) (putprop (car l) (cadr l) 'scheme!function))
                           ((get (car l) 'scheme!function))
                           (t (error '|Bad Definition - Define| l 'fail-act))))
       (set (car l) (betacons **tem** nil nil (car l)))
       (car l))

(defprop aset aaset aint)

(defun aaset ()
       (push **exp** **beta** **vals** **pc**)
       (setq **exp** (cadr **exp**)  **pc** 'aset1)
       (dispatch))

(defun aset1 ()
       (pop **exp**)
       (top **beta** **vals**)
       (setq **exp** (caddr **exp**)  **pc** 'aset2)
       (push **val**)
       (dispatch))

(defun aset2 ()
       (pop **tem** **beta** **vals** **pc**)	; tem is the identifier to be clobbered.
       ((lambda (vc)
                (cond (vc (rplaca vc **val**))
                      (t (set **tem** **val**))))
        (lookup **tem** **beta** **vals**)))

;Fluid variable stuff.

(defprop fluid!bind afluidbind aint)

(defun afluidbind ()
       (push **beta** **vals** **exp** **fluid!vars** **fluid!vals** **pc**)
       (setq **evlis** **fluid!vals**  **unevlis** (cadr **exp**))
       (afluidbind1))

(defun afluidbind1 ()
       (cond ((null **unevlis**)
	      (pop **beta** **vals** **exp**)
	      (setq **fluid!vars** (nconc (reverse (cadr **exp**)) **fluid!vars**))
	      (setq **fluid!vals** **evlis**)
	      (setq **exp** (caddr **exp**))
	      (setq **pc** 'unbind)
	      (dispatch))
	     (t (top **beta** **vals**)
		(setq **exp** (cadar **unevlis**))
		(setq **pc** 'afluidbind2)
		(push **evlis** **unevlis**)
		(dispatch))))

(defun afluidbind2 ()
       (pop **evlis** **unevlis**)
       (setq **evlis** (cons **val** **evlis**)  **unevlis** (cdr **unevlis**))
       (setq **pc** 'afluidbind1))

(defun unbind () (pop **fluid!vars** **fluid!vals** **pc**))

(defprop fluid!value afluidval aint)

(defun afluidval ()
       (setq **val**
	     ((lambda (vc)
		      (cond (vc (car vc))
			    ((boundp (cadr **exp**)) (symeval (cadr **exp**)))
			    (t (error '|Unbound Fluid Variable| (cadr **exp**) 'fail-act))))
	      (fluid!lookup (cadr **exp**) **fluid!vars** **fluid!vals**))))

(defun fluid!set (var val)
       ((lambda (vc)
                (cond (vc (rplaca (cdr vc) val))
                      (t (set var val))))
        (fluid!lookup var **fluid!vars** **fluid!vals**)))

(defun fluid!lookup (id vars vals)
       (prog ()
         lp (cond ((null vars) (return nil))
                  ((eq id (car vars))
                   (cond ((null vals) (error '|Vals too short -- fluid!lookup| id 'fail-act)))
                   (return vals))
                  ((null vals) (error '|Too few vals - fluid!lookup| id 'fail-act)))
            (setq vars (cdr vars)  vals (cdr vals))
            (go lp)))

;Hairy control structure.

(setq **procnum** 0)

(defun genprocname ()
       ((lambda (base *nopoint)
		(implode (append '(p r o c e s s)
				  (exploden (setq **procnum** (1+ **procnum**))))))
	10. t))

(defun create!process (exp)
       ((lambda (**process** **beta** **vals** **evlis** **unevlis** **pc** **clink**
		 **fun** **exp** **fluid!vars** **fluid!vals** **val** **tem**)
                (dispatch)
                (swapoutprocess)
                **process**)
        (genprocname) **beta** **vals** nil nil 'terminate nil nil
        exp **fluid!vars** **fluid!vals** nil nil))

(defun start!process (p)
       (cond ((or (not (atom p)) (not (get p '**process**)))
	      (error '|Bad Process - START!PROCESS| p 'fail-act)))
       (or (eq p **process**) (memq p **queue**)
	   (setq **queue** (nconc **queue** (list p))))
       p)

(defun stop!process (p)
       (cond ((memq p **queue**)
	      (setq **queue** (delete p **queue**))
	      p)
	     ((eq p **process**)
	      (setq **val** p)
	      (terminate))))

(defun terminate ()
       (swapoutprocess)
       (cond ((null **queue**)
	      (setq **beta** nil  **vals** nil  **fluid!vars** nil  **fluid!vals** nil)
	      (setq **process**
		    (create!process '(**top** '|SCHEME: Queue Ran Out| '|==> |))))
	     (t (setq **process** (car **queue**)
		      **queue** (cdr **queue**))))
       (swapinprocess)
       **val**)


(defprop evaluate!uninterruptibly evun aint)

(defun evun ()
       (bind (list '*allow*) (list nil) 'evaluate!unterruptibly)
       (setq **exp** (cadr **exp**))
       (dispatch))


(defprop catch acatch aint)

(defun acatch ()
       (bind (list (cadr **exp**))
             (list (list 'delta
                         ((lambda (**clink**)
                           (push **beta** **vals** **fluid!vars** **fluid!vals** **pc**)
                           **clink**)
                          **clink**)
			 (cadr **exp**)))
             'catch)
       (setq **exp** (caddr **exp**))
       (dispatch))

(defun punt ()
       (and **queue**
	    (progn (swapoutprocess)
		   (setq **queue** (nconc **queue** (list **process**))
			 **process** (car **queue**)
			 **queue** (cdr **queue**))
		   (swapinprocess)
		   **val**)))


;The read-eval-print loop.

(define **top**
	(lambda (**message** **prompt**)
		(labels ((**top1**
                          (lambda (**ignore0** **ignore1** **ignore2** **ignore3**
					       **ignore4** **ignore5** **ignore6**
					       **ignore7** **ignore8**)
                             (**top1** (labels ((**puntloop**
						 (lambda (**ignore8**)
							 (if **queue**
							     (**puntloop** (punt))))))
					       (**puntloop** nil))
				       (terpri)
				       (princ **prompt**)
				       (set '++ --)
				       (set '-- (read))
				       (set '** (evaluate --))
				       (if (not ^q) (terpri)
					   (if (> (charpos (symeval 'tyo)) 10.)
					       ((lambda (x) (princ '|    |)) (terpri))))
                                       (schprin1 **)
				       (princ '| |)))))
                    (**top1** (set '-- nil) (terpri) (princ **message**) nil
			      nil nil nil))))

(defun schprin1 (x)
       (cond (prin1 (funcall prin1 x))
	     (t (prin1 x))))

(defun where ()
       (do ((prinlevel 3) (prinlength 6)
            (b **beta** (obeta b)))
           ((null b) nil)
          (cond ((eq (car b) 'beta) (print (name b)))
                (t (print (car b))))))

(defun schval fexpr (l)
       (locin (lookup (car l) **beta** **vals**)))

