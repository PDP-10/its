(defun munch-compute (size n list)
  (loop with half = (quotient size 2)
        and result = nil
        for i from 0 below (times n n) by n
        for w = (subseq list i n) do
	    (loop for (x y) in w do
		  (push (list x y) result)
		  (push (list (plus x half) (plus y half)) result))
	    (loop for (x y) in w do
		  (push (list (plus x half) y) result)
		  (push (list x (plus y half)) result))
        finally (return  (if (equal half 1)
			     (nreverse result)
			   (munch-compute half (times 2 n)
					  (nreverse result))))))

(defun munch-draw (pixel list)
  (loop for (x y) in list do
	(cursorpos y (times 2 x))
	(tyo (car pixel))
	(tyo (cdr pixel))))

(defun munching-squares ()
  (let ((list (munch-compute 16. 1 '((0 0))))
        (pixels (list '(#/[ . #/]) '(#\Space. #\Space) nil)))
    (setf (cdr (cdr pixels)) pixels)
    (loop
      (munch-draw (car pixels) list)
      (setq pixels (cdr pixels)))))
