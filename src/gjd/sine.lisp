(comment) ;-*- lisp -*-

(eval-when (eval load compile)
  (load '((liblsp) lispm fasl)))

(defvar radius 255.)
(defvar steps 512.)
(defvar file "GJD; SINE BINARY")

(defvar 2pi (quotient (times 2 3.141592654) steps))

(defun round (x)
  (fix (plus x 0.5)))

(with-open-file (f file '(single fixnum out))
  (dotimes (i steps)
    (out f (round (times radius (sin (times i 2pi)))))))

(quit)
