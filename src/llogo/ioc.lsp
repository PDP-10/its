;;; -*- lisp -*-
;;; Emulate old Maclisp special forms IOC and IOG.

(defmacro ioc (sym)
  (cond
    ((eq sym 'G)   `(^G))
    ((eq sym 'R)   `(setq ^R t))
    ((eq sym 'T)   `(setq ^R nil))
    ((eq sym 'V)   `(setq ^W nil))
    ((eq sym 'W)   `(setq ^W t))
    ((eq sym 'RW)  `(progn (ioc R) (ioc W)))
    (t             (error "Unknown IOC character"))))

(defmacro iog (sym &rest forms)
  `(let ((^Q nil) (^R nil) (^W nil))
     ,@(if sym `((ioc ,sym)))
     ,@forms))
