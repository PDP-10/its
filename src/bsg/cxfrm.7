;;; -*- package:cube -*-

;;;
;;; cube transform interpreter
;;; BSG 8 Jan 1981
;;;

(declare (or (status feature lispm)(macros t)))

(declare (special known-cube-transforms))

(or (boundp 'known-cube-transforms)(setq known-cube-transforms nil))


;;; Load time hacks

(defun defxform macro (x)
       (list 'add-cube-transform
	     (list 'quote (cadr x))
	     (list 'quote (cddr x))))

(defun add-cube-transform (name meaning)
  (setq known-cube-transforms (cons name (delq name known-cube-transforms)))
  (putprop name meaning 'cube-transform))



;;; interpret a single-char primitive move
(defun dfxfm-primitive (c inv)
  (let ((face (cadr (assq c '((f FRONT)(l LHS)(u TOP)(b BACK)(r RHS)(d BOTTOM))))))
    (or face (error '|dfxfm-primitive: bad char: | c 'fail-act))
    (rotate-face (symeval face)
		 (cond (inv 'left)
		       (t 'right)))))

;;; interpret a 2-character sequence such as f* or f2
(defun dfxfm-2char (c tag inv)
  (cond ((eq tag '*)(dfxfm-atom c (not inv)))	;invert the move
	((eq tag '/2)(dfxfm-atom c nil)(dfxfm-atom c nil))
	(t (error '|dfxfm-2char: meaningless tag: | tag 'fail-act))))

;;; break down and interpret an atomic symbol
(defun dfxfm-atom (x inv)
  (cond ((memq x '(f l u b r d F L U B R D))
	 (dfxfm-primitive
	   (or (cadr (assq x '((F f)(L l)(U u)(B b)(R r)(D d))))
	       x)
	   inv))
	((= (flatc x) 1)
	 (error '|invalid flubrd-code: | x 'fail-act))
	((null inv)
	 (do l (explodec x)(cdr l)(null l)
	     (cond ((memq (cadr l) '(* /2))
		    (dfxfm-2char (car l)(cadr l) nil)	;inv = nil
		    (setq l (cdr l)))		;2 frobbies
		   (t (dfxfm-atom (car l) nil)))))
	(t					;inv = t
	 (do l (nreverse (explodec x))(cdr l)(null l)
	     (cond ((memq (car l) '(* /2))
		    (dfxfm-2char (cadr l)(car l) t)
		    (setq l (cdr l)))
		   (t (dfxfm-atom (car l) t)))))))

;;; macro operands

(defun run-xform (f)(dfxfm-macopd f nil))

(defun dfxfm-macopd (opd inv)
  (or (symbolp opd)(error '|invalid cube-transform apply/inverse operand: | opd 'fail-act))
  (let ((prop (get opd 'cube-transform)))
    (or prop (error '|undefined cube transform: | opd 'fail-act))
    (dfxfm-interpret prop inv)))

;;; main interpreter
(defun dfxfm-interpret (x inv)
  (cond ((atom x)(dfxfm-atom x inv))
	(t (mapc '(lambda (x)
		    (cond ((atom x)(dfxfm-atom x inv))
			  ((eq (car x) 'apply)
			   (dfxfm-macopd (cadr x) inv))
			  ((eq (car x) 'inverse)
			   (dfxfm-macopd (cadr x) (not inv)))
			  (t (dfxfm-interpret x inv))))	;random cruft
		 (cond ((null inv) x)
		       (t (reverse x)))))))

;;; Here are some random transforms

(defxform monotwist-op
	  (ld l*d*) ldl*)

(defxform monotwist
	  (apply monotwist-op) u (inverse monotwist-op) u*)

(defxform quark
	  r2 (apply monotwist) r2)

(defxform pons f2 b2 r2 l2 u2 d2)

(defxform christman-cross	;Saxe 16 dec 1980
	f ud llrr ud fb uudd b)

(defxform plummer-cross		;Saxe 3 dec 1980
	f (ll rr) f b (ll rr) f
	l (bb ff) l r (bb ff) l (uu dd))
