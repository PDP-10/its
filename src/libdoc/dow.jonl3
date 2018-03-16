
;;; THE FOLLOWING FUNCTION, WHEN GIVEN THE DATE AS THREE NUMBERS,
;;; WILL PRODUCE THE 0-ORIGIN NUMBER OF THE DAY-OF-WEEK FOR THAT DATE.
;;; E.G.,  (DAY-NAME (DOW 1963. 11. 22.)) ==> FRIDAY,  WHICH HAPPENED
;;; TO BE THE DAY PRESIDENT JOHN F. KENNEDY WAS ASSASINATED.



(DEFUN DOW (YEAR MONTH DAY) 
    (AND (AND (FIXP YEAR) (FIXP MONTH) (FIXP DAY))
	 ((LAMBDA (A) 
		  (DECLARE (FIXNUM A))
		  (\ (+ (// (1- (* 13. (+ MONTH 10. (* (// (+ MONTH 10.) -13.) 12.))))
			    5.)
			DAY
			77.
			(// (* 5. (- A (* (// A 100.) 100.))) 4.)
			(// A -2000.)
			(// A 400.)
			(* (// A -100.) 2.))
		     7.))
	     (+ YEAR (// (+ MONTH -14.) 12.)))))


(DEFUN DAY-NAME (N)
    (DECLARE (FIXNUM N))
    (COND ((> N 3)
	   (COND ((> N 5) 'SATURDAY)
		 ((> N 4) 'FRIDAY)
		 ('THURSDAY)))
	  ((> N 1) (COND ((> N 2) 'WEDNESDAY) ('TUESDAY)))
	  ((ZEROP N) 'SUNDAY)
	  ('MONDAY))) 
