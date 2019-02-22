;; The following is a tiny Prolog interpreter in MacLisp
;; written by Ken Kahn.
;; It was inspired by other tiny Lisp-based Prologs of
;; Par Emanuelson and Martin Nilsson
;; There are no side-effects in anywhere in the implementation
;; Though it is very slow of course.

(defun Prolog (database) ;; a top-level loop for Prolog
  (prove (list (rename-variables (read) '(0)))
         ;; read a goal to prove
         '((bottom-of-environment)) database 1)
  (prolog database))

(defun prove (list-of-goals environment database level)
  ;; proves the conjunction of the list-of-goals
  ;; in the current environment
  (cond ((null list-of-goals)
         ;; succeeded since there are no goals
         (print-bindings environment environment)
          ;; the user answers "y" or "n" to "More?"
         (not (y-or-n-p "More?")))
        (t (try-each database database
                     (rest list-of-goals) (first list-of-goals)
                     environment level))))

(defun try-each (database-left database goals-left goal
                               environment level)
 (cond ((null database-left)
        ()) ;; fail since nothing left in database
       (t (let ((assertion
                 ;; level is used to uniquely rename variables
                 (rename-variables (first database-left)
                                   (list level))))
            (let ((new-environment
                   (unify goal (first assertion) environment)))
              (cond ((null new-environment) ;; failed to unify
                     (try-each (rest database-left)
                               database
                               goals-left
                               goal
                               environment level))
                    ((prove (append (rest assertion) goals-left)
                            new-environment
                            database
                            (add1 level)))
                    (t (try-each (rest database-left)
                                 database
                                 goals-left
                                 goal
                                 environment
                                 level))))))))

(defun unify (x y environment)
  (let ((x (value x environment))
        (y (value y environment)))
    (cond ((variable-p x) (cons (list x y) environment))
          ((variable-p y) (cons (list y x) environment))
          ((or (atom x) (atom y))
           (and (equal x y) environment))
          (t (let ((new-environment
                    (unify (first x) (first y) environment)))
               (and new-environment
                    (unify (rest x) (rest y)
                           new-environment)))))))

(defun value (x environment)
  (cond ((variable-p x)
         (let ((binding (assoc x environment)))
           (cond ((null binding) x)
                 (t (value (second binding) environment)))))
        (t x)))

(defun variable-p (x) ;; a variable is a list beginning with "?"
  (and (listp x) (eq (first x) '?)))

(defun rename-variables (term list-of-level)
  (cond ((variable-p term) (append term list-of-level))
        ((atom term) term)
        (t (cons (rename-variables (first term)
                                   list-of-level)
                 (rename-variables (rest term)
                                   list-of-level)))))

(defun print-bindings (environment-left environment)
  (cond ((rest environment-left)
         (cond ((zerop
                 (third (first (first environment-left))))
                (print
                 (second (first (first environment-left))))
                (princ " = ")
                (prin1 (value (first (first environment-left))
                              environment))))
         (print-bindings (rest environment-left) environment))))

;; a sample database:
(setq db '(((father jack ken))
           ((father jack karen))
           ((grandparent (? grandparent) (? grandchild))
            (parent (? grandparent) (? parent))
            (parent (? parent) (? grandchild)))
           ((mother el ken))
           ((mother cele jack))
           ((parent (? parent) (? child))
            (mother (? parent) (? child)))
           ((parent (? parent) (? child))
            (father (? parent) (? child)))))

;; the following are utilities

(defun first (x) (car x))
(defun rest (x) (cdr x))
(defun second (x) (cadr x))
(defun third (x) (caddr x))

