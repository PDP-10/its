; FOOLOG Interpreter (c) Martin Nilsson  UPMAIL   1983-06-12

(declare (special *inf* *e* *v* *topfun* *n* *fh* *forward*)
         (special *bagof-env* *bagof-list*))

(defmacro defknas (fun args &rest body)
  `(defun ,fun macro (l)
     (cons 'progn (sublis (mapcar 'cons ',args (cdr l))
                          ',body))))

; ---------- Interpreter

(setq *e* nil *fh* nil *n* nil *inf* 0
      *forward* (munkam (logior 16. (logand (maknum 0) -16.))))
(defknas imm (m x) (cxr x m))
(defknas setimm (m x v) (rplacx x m v))
(defknas makrecord (n)
  (loop with r = (makhunk n) and c for i from 1 to (- n 2) do
        (setq c (cons nil nil))
        (setimm r i (rplacd c c)) finally (return r)))

(defknas transfer (x y)
  (setq x (prog1 (imm x 0) (setq y (setimm x 0 y)))))
(defknas allocate nil
  (cond (*fh* (transfer *fh* *n*) (setimm *n* 7 nil))
        ((setq *n* (setimm (makrecord 8) 0 *n*)))))
(defknas deallocate (on)
  (loop until (eq *n* on) do (transfer *n* *fh*)))
(defknas reset (e n) (unbind e) (deallocate n) nil)
(defknas ult (m x)
  (cond ((or (atom x) (null (eq (car x) '/?))) x)
        ((< (cadr x) 7)
         (desetq (m . x) (final (imm m (cadr x)))) x)
        ((loop initially (setq x (cadr x)) until (< x 7) do
               (setq x (- x 6)
                     m (or (imm m 7)
                           (imm (setimm m 7 (allocate)) 7)))
          finally (desetq (m . x) (final (imm m x)))
          (return x)))))
(defknas unbind (oe)
  (loop with x until (eq *e* oe) do
   (setq x (car *e*)) (rplaca x nil) (rplacd x x) (pop *e*)))
(defknas bind (x y n)
  (cond (n (push x *e*) (rplacd x (cons n y)))
        (t (push x *e*) (rplacd x y) (rplaca x *forward*))))
(lap-a-list '((lap final subr) (hrrzi 1 @ 0 (1)) (popj p) nil))
; (defknas final (x) (cdr (memq nil x))) ; equivalent
(defknas catch-cut (v e)
  (and (null (and (eq (car v) 'cut) (eq (cdr v) e))) v)))

(defun prove fexpr (gs)
  (reset nil nil)
  (seek (list (allocate)) (list (car (convq gs nil)))))

(defun seek (e c)
  (loop while (and c (null (car c))) do (pop e) (pop c))
  (cond ((null c) (funcall *topfun*))
        ((atom (car c)) (funcall (car c) e (cdr c)))
        ((loop with rest = (cons (cdar c) (cdr c)) and
          oe = *e* and on = *n* and e1 = (allocate)
          for a in (symeval (caaar c)) do
          (and (unify e1 (cdar a) (car e) (cdaar c))
               (setq inf* (1+ *inf*)
                     *v* (seek (cons e1 e)
                               (cons (cdr a) rest)))
               (return (catch-cut *v* e1)))
          (unbind oe)
          finally (deallocate on)))))

(defun unify (m x n y)
  (loop do
    (cond ((and (eq (ult m x) (ult n y)) (eq m n)) (return t))
          ((null m) (return (bind x y n)))
          ((null n) (return (bind y x m)))
          ((or (atom x) (atom y)) (return (equal x y)))
          ((null (unify m (pop x) n (pop y))) (return nil)))))

; ---------- Evaluable Predicates

(defun inst (m x)
  (cond ((let ((y x))
           (or (atom (ult m x)) (and (null m) (setq x y)))) x)
        ((cons (inst m (car x)) (inst m (cdr x))))))

(defun lisp (e c)
  (let ((n (pop e)) (oe *e*) (on *n*))
    (or (and (unify n '(? 2) (allocate) (eval (inst n '(? 1))))
             (seek e c))
        (reset oe on))))

(defun cut (e c)
  (let ((on (cadr e))) (or (seek (cdr e) c) (cons 'cut on))))

(defun call (e c)
  (let ((m (car e)) (x '(? 1)))
    (seek e (cons (list (cons (ult m x) '(? 2))) c))))

(defun bagof-topfun nil
  (push (inst *bagof-env* '(? 1)) *bagof-list*) nil)

(defun bagof (e c)
  (let* ((oe *e*) (on *n*) (*bagof-list* nil)
                  (*bagof-env* (car e)))
    (let ((*topfun* 'bagof-topfun)) (seek e '(((call (? 2))))))
    (or (and (unify (pop e) '(? 3) (allocate) *bagof-list*)
             (seek e c))
        (reset oe on))))

; ---------- Utilities

(defun timer fexpr (x)
  (let* ((*rset nil) (*inf* 0) (x (list (car (convq x nil))))
         (t1 (prog2 (gc) (runtime) (reset nil nil)
                    (seek (list (allocate)) x)))
         (t1 (- (runtime) t1)))
    (list (// (* *inf* 1000000.) t1) 'LIPS (// t1 1000.)
          'MS *inf* 'INF)))

(eval-when (compile eval load)
  (defun convq (t0 l0)
    (cond ((pairp t0) (let* (((t1 . l1) (convq (car t0) l0))
                             ((t2 . l2) (convq (cdr t0) l1)))
                        (cons (cons t1 t2) l2)))
          ((null (and (symbolp t0) (eq (getchar t0 1) '/?)))
           (cons t0 l0))
          ((memq t0 l0)
           (cons (cons '/? (cons (length (memq t0 l0))
                                 t0)) l0))
          ((convq t0 (cons t0 l0))))))

(defmacro defpred (pred &rest body)
  `(setq ,pred ',(loop for clause in body
                       collect (car (convq clause nil)))))

(defpred true    ((true)))
(defpred =       ((= ?x ?x)))
(defpred lisp    ((lisp ?x ?y) . lisp))
(defpred cut     ((cut) . cut))
(defpred call    ((call (?x . ?y)) . call))
(defpred bagof   ((bagof ?x ?y ?z) . bagof))
(defpred writeln
  ((writeln ?x) (lisp (progn (princ '?x) (terpri)) ?y)))

(setq *topfun*
      '(lambda nil (princ "MORE? ")
               (and (null (read)) '(top))))
