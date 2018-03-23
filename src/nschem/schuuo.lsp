
; SCHEME compiled code linker.

(declare (special **exp** **beta** **vals** **clink** **fun** **pc** **val** **evlis**
		  **fluid!vars** **fluid!vals** **cont** **env** **argument-registers** **nargs**
	          **cont+arg-regs** **number-of-arg-regs**
		  **one** **two** **three** **four** **five** **six** **seven** **eight**))



(defun body macro (l) (list 'cadddr (cadr l)))

;control stack stuff

(defun push macro (l) (list 'setq '**clink** (push1 (cdr l))))

(declare (eval (read)))

(defun push1 (x)
       (cond ((null x) '**clink**)
             (t (list 'cons (car x) (push1 (cdr x))))))

(defun pop macro (l)
 (list 'setq '**clink**
   (list 
     (list 'lambda '(ltem)
       (cons 'setq
             (mapcan '(lambda (x)
                        (list x '(car ltem)  'ltem '(cdr ltem) ))
                     (cdr l))))
     '**clink**)))

(setq **argument-registers** '(**one** **two** **three** **four**
			       **five** **six** **seven** **eight**))

(setq **cont+arg-regs** (cons '**cont** **argument-registers**))

(setq **env+cont+arg-regs** (cons '**env** **cont+arg-regs**))

(setq **number-of-arg-regs** (length **argument-registers**))

(defun compiled-beta-entry ()
       (setq **env** (cddr **fun**))
       (setq **cont**
	     (list 'epsilon
		   ((lambda (**clink**)
			    (push **pc**)
			    **clink**)
		    **clink**)))
       (spread-evlis **evlis**)
       (setq **pc** 'jrsticate)
       (subrcall nil (cadr **fun**)))

(defun spread-evlis (evlis)
       (cond ((> (length evlis) **number-of-arg-regs**)
	      (setq **one** (reverse evlis)))
	     (t (spread-evlis1 evlis))))

(defun spread-evlis1 (evlis)
       (cond (evlis
	      ((lambda (tem)
		       (set (car tem)
			    (car evlis))
		       (cdr tem))
	       (spread-evlis1 (cdr evlis))))
	     (t **argument-registers**)))

(setq **jrst** nil)

(defun cheapy-jpc ()
	(mapcar '(lambda (x) (subr (cadr x))) **jrst**))

(defun rabbit-jpc ()
	(mapcar '(lambda (x) (list (get (subr (cadr x))
					'user-function)
				   (caddr x)))
		**jrst**))

(defun jrsticate ()
       (cond ((eq (car **fun**) 'cbeta)
	      (setq **env** (cddr **fun**))
	      (and **jrst**
		   (setq **jrst** (cons **fun** **jrst**)))
	      (subrcall nil (cadr **fun**)))
	     ((eq (car **fun**) 'subr)
	      (setq **one** (spreadsubrcall))
	      (setq **fun** **cont**)
	      (jrsticate))
	     ((eq (car **fun**) 'lsubr)
	      (setq **one** (spreadlsubrcall))
	      (setq **fun** **cont**)
	      (jrsticate))
	     ((eq (car **fun**) 'expr)
	      (setq **one** (spreadexprcall))
	      (setq **fun** **cont**)
	      (jrsticate))
	     ((eq (car **fun**) 'beta)
	      (setq **vals** (gather-evlis))
	      (cond ((eq (car **cont**) 'epsilon)
		     (setq **clink** (cadr **cont**))
		     (pop **pc**))
		    (t (setq **clink** **cont**)
		       (setq **pc** 'jrsticate1)))
	      (setq **exp** (body **fun**))
	      (setq **beta** **fun**)
	      (dispatch))
	     ((eq (car **fun**) 'epsilon)
	      (setq **clink** (cadr **fun**))
	      (pop **pc**)
	      (setq **val** **one**))
	     ((eq (car **fun**) 'delta)
	      (setq **clink** (cadr **fun**))
	      (pop **beta** **vals** **fluid!vars** **fluid!vals** **pc**)
	      (setq **val** **one**))
	     (t (error '|Bad Function - Jrsticate| **fun** 'fail-act))))

(defun jrsticate1 ()
       (setq **one** **val**)
       (setq **fun** **clink**)
       (setq **pc** 'jrsticate)				;must set up pc
       (jrsticate))					;faster than going through MLOOP


(defun gather-evlis ()
       (cond ((> **nargs** 8.) (reverse **one**))
	     (t (do ((n 0 (+ 1 n))
		     (argl nil (cons (symeval (car regl)) argl))
		     (regl **argument-registers** (cdr regl)))
		    ((= n **nargs**)
		     argl)))))

(defun spreadsubrcall ()
       (cond ((= **nargs** 0)
	      (subrcall nil (cadr **fun**)))
	     ((= **nargs** 1)
	      (subrcall nil (cadr **fun**) **one**))
	     ((= **nargs** 2)
	      (subrcall nil (cadr **fun**) **one** **two**))
	     ((= **nargs** 3)
	      (subrcall nil (cadr **fun**) **one** **two** **three**))
	     ((= **nargs** 4)
	      (subrcall nil (cadr **fun**) **one** **two** **three** **four**))
	     ((= **nargs** 5)
	      (subrcall nil (cadr **fun**) **one** **two** **three** **four** **five**))
	     (t (error '|Too many arguments to a SUBR -- SPREAD|
		       (list **fun** **nargs**)
		       'fail-act))))

(defun spreadlsubrcall ()
       (cond ((= **nargs** 0)
	      (lsubrcall nil (cadr **fun**)))
	     ((= **nargs** 1)
	      (lsubrcall nil (cadr **fun**) **one**))
	     ((= **nargs** 2)
	      (lsubrcall nil (cadr **fun**) **one** **two**))
	     ((= **nargs** 3)
	      (lsubrcall nil (cadr **fun**) **one** **two** **three**))
	     ((= **nargs** 4)
	      (lsubrcall nil (cadr **fun**) **one** **two** **three** **four**))
	     ((= **nargs** 5)
	      (lsubrcall nil (cadr **fun**) **one** **two** **three** **four** **five**))
	     ((= **nargs** 6)
	      (lsubrcall nil (cadr **fun**) **one** **two** **three** **four**
		                          **five** **six**))
	     ((= **nargs** 7)
	      (lsubrcall nil (cadr **fun**) **one** **two** **three** **four**
		                          **five** **six** **seven**))
	     ((= **nargs** 8.)
	      (lsubrcall nil (cadr **fun**) **one** **two** **three** **four**
		                          **five** **six** **seven** **eight**))
	     (t (setplist 'the-lsubr-apply-atom **fun**)
		(apply 'the-lsubr-apply-atom **one**))))

(defun spreadexprcall ()
       (cond ((= **nargs** 0)
	      (funcall nil (cadr **fun**)))
	     ((= **nargs** 1)
	      (funcall nil (cadr **fun**) **one**))
	     ((= **nargs** 2)
	      (funcall nil (cadr **fun**) **one** **two**))
	     ((= **nargs** 3)
	      (funcall nil (cadr **fun**) **one** **two** **three**))
	     ((= **nargs** 4)
	      (funcall nil (cadr **fun**) **one** **two** **three** **four**))
	     ((= **nargs** 5)
	      (funcall nil (cadr **fun**) **one** **two** **three** **four** **five**))
	     ((= **nargs** 6)
	      (funcall nil (cadr **fun**) **one** **two** **three** **four**
		                          **five** **six**))
	     ((= **nargs** 7)
	      (funcall nil (cadr **fun**) **one** **two** **three** **four**
		                          **five** **six** **seven**))
	     ((= **nargs** 8.)
	      (funcall nil (cadr **fun**) **one** **two** **three** **four**
		                          **five** **six** **seven** **eight**))
	     (t (apply (cadr **fun**) **one**))))
