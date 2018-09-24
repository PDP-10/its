;;; -*- lisp -*-

(defmacro ioc (sym)
  (cond
    ((eq sym 'G)   `(^G))
    ((eq sym 'R)   `(setq ^R t))
    ((eq sym 'T)   `(setq ^R nil))
    (t             (error "Unknown IOC character"))))

(defmacro iog (sym &rest forms)
  `(let ((^Q nil) (^R nil) (^W nil)
         ,@(if sym `((ioc ,sym))))
     ,@forms))
