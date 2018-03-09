;; -*- Mode: Lisp; Package: Macsyma; Ibase: 8 -*-

(macsyma-module edbuf)

;; Macsyma display-oriented expression editor
;; Buffer management functions
;; See EMAXIM;ED > and EMAXIM;EDCOM > for more information.
;; Written:	Feb 17, 1979 By RZ, based on a version by CWH and BEE
;; Rewritten:   June 2, 1979 by CWH for Macsyma Users' Conference

;; Global variables and structure definitions.

(load-macsyma-macros edmac)

;; Creating new expressions -- By copying old ones and typing in new ones

;; Add a newly created expression to some buffer.  Which buffer and whether or
;; not it becomes the selected expression is determined by the numerical
;; argument.
;; Currently copy region and copy expression immediately stick things in
;; a buffer.  Later they will simply push it on the kill pdl and 
;; things can be brought back anyplace.

(defun add-exp-to-buffer (exp argument)
  (cond
   ;;Empty buffer.
   ((and (null (expression-list current-buffer))
	 (or (not argument) (= argument 0)))
    (setf (expression-list current-buffer) (list exp))
    (make-current-exp exp))
   ;;If no argument given, add the expression to the buffer immediately
   ;;after the current one and make the new expression current.
   ;;With zero argument, add it after the current one but don't
   ;;change which one is current.
   ((or (not argument) (= argument 0))
    (do ((e-list (expression-list current-buffer) (cdr e-list)))
	((null e-list)
	 (ed-internal-error 'add-exp-to-buffer
			    "Current expression not in current buffer."))
	(cond ((eq (car e-list) current-exp)
	       (rplacd e-list (cons exp (cdr e-list)))
	       (return nil))))
    (cond ((null argument)
	   (make-current-exp exp)
	   (setf (current-exp-distance-from-top current-buffer)
		 (1+ (current-exp-distance-from-top current-buffer))))))
   ;;Add the expression to the end of a different buffer.
   (t (let* ((buffer-name
	      (read-line "Buffer to insert expression into (~A): "
			 (buffer-name previous-buffer)))
	     (buffer (select-buffer buffer-name)))
	    (setf (expression-list current-buffer)
		  (nconc (expression-list current-buffer) (list exp)))
	    (make-current-exp exp)
	    (setf (current-exp-distance-from-top buffer) 100.)))))

(set-key 'copy-region "C-c")
(defcom copy-region ((argument n))
"Creates a new expression from the region and enters it in the current buffer.
With no argument, makes the new expression be current.
With 0 argument, don't change which expression is current.
With any other argument, prompt for a buffer in which to insert the new expression."
    (add-exp-to-buffer (make-exp (region-as-mexp current-exp)) n))

(set-key 'copy-expression "M-c")
(defcom copy-expression ((argument n))
"Creates a new expression from the current one and enters it in the current buffer.
With no argument, makes the new expression be current.
With 0 argument, don't change which expression is current.
With any other argument, prompt for a buffer in which to insert the new expression."
    (add-exp-to-buffer (make-exp (cadr (displayed current-exp))) n))

(set-key 'insert-expression "M-i")
(defcom insert-expression ((argument n)
			   (read-expression exp
					    "Insert expression: ~A"
					    (if n "(no evaluation) " "")))
"Creates a new expression from one read in the minibuffer.
If a numeric argument is given, don't evaluate the entered expression."
    ;;Since we're not calling replace-region, must do this ourselves.
    (if (expression-list current-buffer)
	(setq exp (subst (region-as-mexp current-exp) '$% exp)))
    (if (not n) (setq exp (meval exp)))
    (add-exp-to-buffer (make-exp exp) nil))

(set-key 'replace-expression "M-r")
(defcom replace-expression ((argument n)
			    (read-expression exp
					     "Replace expression: ~A"
					     (if n "(no evaluation) " "")))
"Replace the current expression with one read from the minibuffer.
If a numeric argument is given, don't evaluate the entered expression."
    (if (not (region-contains-top-node?)) (top-level))
    (replace-region n exp))

;  Add yank-expression here at some point.


;  Changing expressions within the buffer.

(set-key 'first-expression "M-a")
(set-key 'first-expression "M-<")
(defcom first-expression ((discard-argument))
"Makes the first expression in the buffer be the current one."
    (if (not (expression-list current-buffer))
	(ed-error "No expressions in this buffer."))
    (make-current-exp (car (expression-list current-buffer)))
    (setf (current-exp-distance-from-top current-buffer) 0))	

(set-key 'last-expression "M-e")
(set-key 'last-expression "M->")
(defcom last-expression ((discard-argument))
"Makes the last expression in the buffer be the current one."
    (if (not (expression-list current-buffer))
	(ed-error "No expressions in this buffer."))
    (make-current-exp (car (last (expression-list current-buffer))))
    (setf (current-exp-distance-from-top current-buffer) 100.))

(set-key 'previous-expression "M-p")
(defcom previous-expression ()
"Selects the expression preceding the current one as current."
    (if (not (expression-list current-buffer))
	(ed-error "No expressions in this buffer."))
    (if (eq (car (expression-list current-buffer)) current-exp)
	(ed-error "Current expression is first expression in buffer."))
    (do ((e-list (expression-list current-buffer) (cdr e-list)))
	((eq (cadr e-list) current-exp) (make-current-exp (car e-list))))
    (setf (current-exp-distance-from-top current-buffer)
	  (max 0 (1- (current-exp-distance-from-top current-buffer)))))

(set-key 'next-expression "M-n")
(defcom next-expression ()
"Selects the expression following the current one as current."
    (if (not (expression-list current-buffer))
	(ed-error "No expressions in this buffer."))
    (let ((exp-list (memq current-exp (expression-list current-buffer))))
	 (if (null (cdr exp-list))
	     (ed-error "Current expression is last expression in buffer."))
	 (make-current-exp (cadr exp-list))
	 (setf (current-exp-distance-from-top current-buffer)
	       (1+ (current-exp-distance-from-top current-buffer)))))

(set-key 'transpose-expression "M-t")
(defcom transpose-expression ()
"Transpose the current expression with the one below it.
The current expression remains current."

    (if (null (expression-list current-buffer))
	(ed-error "No expressions in this buffer."))
    (if (null (cdr (expression-list current-buffer)))
	(ed-error "Only one expression in this buffer."))
    (do ((el (expression-list current-buffer) (cdr el)))
	((null el)
	 (ed-internal-error 'transpose-expression
			    "Current expression not in current buffer."))
	(cond ((eq (car el) current-exp)
	       (if (null (cdr el))
		   (ed-error "Current expression is last in current buffer."))
	       (rplaca el (cadr el))
	       (rplaca (cdr el) current-exp)
	       (setf (current-exp-distance-from-top current-buffer)
		     (1+ (current-exp-distance-from-top current-buffer)))
	       (return nil)))))

;  Deleting expressions from a buffer.

(set-key 'delete-expression "M-d")
(defcom delete-expression ()
"Delete the current expression from the current buffer.
If the current expression is the last one in the buffer, the previous one is
selected.  Otherwise, the following expression is selected."

    (if (null (expression-list current-buffer))
	(ed-error "No expressions in this buffer."))
    (cond
     ;;Current exp is at the top of the buffer.
     ((eq current-exp (car (expression-list current-buffer)))
      (pop (expression-list current-buffer))
      (if (expression-list current-buffer)
	  (make-current-exp (car (expression-list current-buffer)))))
     ;;Here exp-list is that part of the expression list beginning
     ;;just before the current expression.
     (t (let ((exp-list (do ((el (expression-list current-buffer) (cdr el)))
			    ((eq (cadr el) current-exp) el))))
	  (rplacd exp-list (cddr exp-list))
	  (cond
	   ;;Current exp is last in buffer.  Make preceding one
	   ;;become current.  If it was the only expression on the
	   ;;screen, be careful not to let distance-from-top go negative.
	   ((null (cdr exp-list))
	    (make-current-exp (car exp-list))
	    (setf (current-exp-distance-from-top current-buffer)
		  (max 0 (1- (current-exp-distance-from-top current-buffer)))))
	   ;;If there exists an expression after the current one, make
	   ;;it now become current.
	   (t (make-current-exp (cadr exp-list))))))))

(set-key 'kill-following-expressions "M-k")
(defcom kill-following-expressions ((argument n))
"Delete the expressions following the current expression.
All equations following the current expression are removed from the current
buffer.  With a negative argument, those equations preceding the current
expression are removed from the current buffer.  The current expression is
not removed."

    (if (null (expression-list current-buffer))
	(ed-error "No expressions in this buffer."))
    (if (not n) (setq n 1))
    (do ((el (expression-list current-buffer) (cdr el)))
	((null el)
	 (ed-internal-error 'kill-following-expressions
			    "Current expression missing from current buffer."))
	(cond ((eq (car el) current-exp)
	       (cond ((> n 0)
		      (rplacd el nil))
		     ((< n 0)
		      (setf (expression-list current-buffer) el)
		      (setf (current-exp-distance-from-top current-buffer) 0)))
	       (return nil)))))

;; Commands for adjusting a window onto a buffer.


(set-key 'new-window '("C-l" "FORM"))
(defcom new-window ((argument n))
"Adjust the window onto the current buffer.
With no argument, completely redisplay the screen and leave the current
window where it is.  With an argument of n, make the current expression
be the nth from the top of the buffer."
    (if n
	(setf (current-exp-distance-from-top current-buffer) n)
	(full-redisplay)))


;; Changing and listing buffers

(set-key 'select-buffer "C-x" "b")
(defcom select-buffer ((discard-argument)
		       (read-line name
				  "Select Buffer (~A):  "
				  (buffer-name previous-buffer)))
"Selects the specified buffer as the named buffer.
If carriage return is typed in response to the prompt, then the previously
selected buffer is made current.  The previously selected buffer is shown
in parenthesis in the prompt."

    (let ((new-buffer (if (string-equal name "")
			  previous-buffer
			  (find-buffer-from-name name))))
	 (cond ((null new-buffer)
		(setq new-buffer (make-buffer buffer-name name))
		(push new-buffer buffer-list)))
	 (make-current-buffer new-buffer)
	 new-buffer))

(defun find-buffer-from-name (buffer-name)
    (do ((bl buffer-list (cdr bl)))
	((null bl) nil)
	(if (string-equal buffer-name (buffer-name (car bl)))
	    (return (car bl)))))

(set-key 'list-buffers "C-x" "C-b")
(defcom list-buffers ((discard-argument))
    "Lists the currently active buffers."
    (cursorpos 0 0)
    (cursorpos 'L)					;Clear to EOL
    (format t "  # ~15A~15A~15A~%" "Buffer" "(Mode)" "Expressions")
    (cursorpos 'L)
    (format t "~%")
    (do ((bl (reverse buffer-list) (cdr bl))
	 (i 1 (1+ i)))
	((null bl))
	(cursorpos 'L)
	(format t "~3D ~15A~15A~4D~%"
		i
		(buffer-name (car bl))
		(buffer-mode (car bl))
		(length (expression-list (car bl)))))
    (setq screen-exp-list nil)				;Kludge to say that screen image
    (setq supress-redisplay t))				;destroyed.
