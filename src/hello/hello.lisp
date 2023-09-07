;;; -*- lisp -*-

;; Hello world example for Maclisp.  When this is compiled to HELLO
;; FASL, the file HELLO (DUMP) will dump out an executable program.
(defun hello ()
  (princ "Hello Maclisp!")
  (terpri)
  (quit))
