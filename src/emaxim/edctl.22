;; -*- Mode: Lisp; Package: Macsyma; Ibase: 8 -*-

(macsyma-module edctl)

;; Macsyma display-oriented expression editor
;; Control function package
;; See CWH;ED > and CWH;EDCOM > for more information.
;; Written:	Feb 17, 1979 By RZ, based on a version by CWH and BEE
;; Rewritten:   June 2, 1979 by CWH for Macsyma Users' Conference

;; Global variables and structure definitions.

(load-macsyma-macros edmac)

;; Initialize the static variables.  These are preserved between invocations of
;; the editor.

(setq buffer-list nil
      mark-pdl nil
      kill-pdl nil
;     current-exp nil
      supress-redisplay nil
      %kbd-control 		#o400
      %kbd-meta			#o1000
      %kbd-control-meta		(+ %kbd-control %kbd-meta)
      )

(defun $displayedit (&rest exps)
  (unwind-protect (progn (ed-prologue)
			 (display-edit exps))
		  (ed-epilogue)))

(defun display-edit (exp-list &aux buffer)
   (cond (exp-list
	  (setq exp-list (mapcar #'make-exp exp-list))
	  (setq buffer (make-buffer buffer-name     (make-buffer-name)
				    expression-list exp-list
				    current-exp	    (car exp-list)))
	  (push buffer buffer-list)
	  (make-current-buffer buffer))
	 ((null buffer-list)
	  (setq buffer (make-buffer buffer-name (make-buffer-name)))
	  (push buffer buffer-list)
	  (make-current-buffer buffer)))
   (full-redisplay)
   (*catch 'exit-editor (ed-command-loop))
   (and (boundp 'current-exp)
	(cadr (body current-exp))))


;; Create an expression from one in the macsyma internal format.  ED format
;; expressions are usually labelled "exp".  Those in macsyma format are
;; labelled "mexp".

(defun make-exp (mexp &optional (label nil))
	(cond (label (setq label (make-symbol label)))
	      (t (setq label (makelabel $outchar))
		 (setq $linenum (1+ $linenum))))
	(setq mexp (list nil (nformat-all mexp)))
	(setq mexp (make-expression body mexp displayed mexp region mexp))
	(label-exp mexp label)
	mexp)

;  For changing an expression's label.
(defun label-exp (exp label)
       (mset label (cadr (body exp)))
       (setf (expression-label exp) label))

;  Used for switching between buffers.
(defun make-current-buffer (buffer)
       (cond ((not (and (boundp 'current-buffer)
			(eq buffer current-buffer)))
	      (setq previous-buffer
		    (if (boundp 'current-buffer) current-buffer buffer))
	      (setq current-buffer buffer)
	      (if (expression-list buffer)
		  (make-current-exp (current-exp buffer))))))

;; Used for switching between expressions within a given buffer.
;; Makes "exp" be the current expression.  Note that "current expression"
;; is defined with respect to a buffer.  

(defun make-current-exp (exp)
       (cond ((not (and (boundp 'current-exp)
			(eq exp current-exp)))
	      (if (boundp 'current-exp)
		  (setf (region-boxed? current-exp) nil))
	      (setq current-exp exp)
	      (setf (region-boxed? exp) t)
	      (setf (current-exp current-buffer) exp)
;	      (set '$% (cadr (region exp)))
;	      (set '$%% (cadr (displayed exp)))
;	      (set '$%%% (cadr (body exp)))
	      )))

;; Generates new buffer names.
;; (format nil ...) creates a string.  Format is special and
;; interned on the macsyma package in the lisp machine.

(setq buffer-name-count 1)
(defun make-buffer-name ()
    (cond ((null buffer-list) "Main")
	  (t (setq buffer-name-count (1+ buffer-name-count))
	     (format nil "Buffer ~D" buffer-name-count))))

;  Simple, isn't it.  Well, it won't be for long.
(defun ed-command-loop ()
    (do ()
	(nil)
	(*catch 'command-loop
		(ed-dispatch (read-key t nil) single-char-table nil))
	(cond (supress-redisplay (setq supress-redisplay nil))
	      ((not (zerop (listen))))	;Don't redisplay on typeahead
	      (need-full-redisplay (full-redisplay))
	      (t (redisplay)))))

;; Takes a character in internal format and a dispatch table and numeric
;; argument.  Looks up function to find what to do with arg.  When echoing
;; character, should use raw output so character 7 gets printed as pi and not a
;; bell.

(defun ed-dispatch (char table arg)
  (declare (fixnum char))
  (let* ((function (get-key table char)))
	(if (not function)
	    (if (eq table single-char-table)
		(ed-error "Undefined key:  ~A"
			  (char-to-descriptor char))
		(ed-error "Undefined key:  Control-x ~A"
			  (char-to-descriptor char)))
	    (ed-dispatch-command function arg char))))

;; Takes a command defined with DEFCOM, a numeric argument (if any) and an
;; invoking character (if any) and calls the command.

(defun ed-dispatch-command (function arg char)
    (if (not (fboundp function))
	(if char
	    (ed-error "Undefined command on ~A:  ~A"
		      (char-to-descriptor char)
		      function)
	    (ed-error "Undefined command:  ~A" (symbol-to-descriptor function))))
    (let ((arg-action (get function 'ed-arg-action))
	  (char-action (get function 'ed-char-action))
	  (arg-list nil))
      (if (eq arg-action 'pass) (push arg arg-list))
      (if (eq char-action 'pass) (push char arg-list))
      (setq arg-list (nreverse arg-list))
      (caseq arg-action
	     ((pass discard) (apply function arg-list))
	     (t  (if arg
		     (dotimes (i (abs (fixnum-identity arg)))
			      (apply function arg-list))
		     (apply function arg-list)))
	     )))

;; For signalling errors.  Throws back into command loop and does a redisplay
;; immediately after.

(defun ed-error (&rest args)
  (cond ((not (null args))
	 (minibuffer-clear)
	 (apply 'minibuffer-print args)))
       (tv-beep)
       (*throw 'command-loop nil))

(defun ed-internal-error (function message &optional datum)
   (dotimes (i 3) (tv-beep))
   (minibuffer-clear)
   (minibuffer-print
    "Macsyma Display Toplevel internal error -- please report to CWH or RZ:~%")
   (if datum
       (minibuffer-print "~A: ~A -- ~S" function message datum)
       (minibuffer-print "~A: ~A" function message))
   (*throw 'command-loop nil))

;; Redisplay

;; The purpose of this function is to look at what is currently on the screen
;; and what should be on the screen.  It finds out what is different between
;; them and updates the screen.  This algorithm can become arbitrarily hairy.
;; Right now, it simply recognizes EQness of expressions and makes no attempt
;; to optimize the redisplay of a single expression.

;; Screen state information:
;; If this list gets too long, may want to create a structure.
;;  
;; screen-exp-list -- list of expressions displayed on the screen.
;; Equation at the top of this list is one at the top of the screen.
;; The needed information for each expression is the displayed region,
;; the label, the reveal depth, and whether its command region is
;; boxed.  If its command region is boxed, then we must know the command
;; region and the region-length (i.e. where the box is).
;;  
;; screen-buffer-name -- name displayed
;; screen-exp-list-length -- expression count displayed.


;; Stolen from MRG;DISPLA.  Find the height in characters of an expression.
;; Later, we may want to save the dimension list returned to optimize
;; redisplay.  This will lose completely if the expression has to be broken
;; across two lines -- fix later.  We have a big problem here -- displa is
;; assuming that the expression is simplified, but we are handing it
;; non-simplified expressions.  Either we can patch displa or start simplifying
;; everything.

(defun dimension-exp (exp)
  (if (region-boxed? exp) (box-region exp))
  (let ((displayp t) (mratp (checkrat exp)) (^r ^r) (maxht 1) (maxdp 0)
	(width 0) (height 0) (depth 0) (level 0) (size 2) (break 0) (right 0)
	(lines 1) bkpt (bkptwd 0) (bkptht 1) (bkptdp 0) (bkptout 0) (bkptlevel 0)
	more-^w)
    (checkbreak (dimension (cadr (displayed exp)) nil 'mparen 'mparen 0 0)
		width)
    (if (region-boxed? exp) (unbox-region exp))
    (max (+ maxht maxdp) (+ bkptht bkptdp))))

;; Produce a new list of expressions to appear on the screen.  Heights
;; of expressions stored in them.  The expressions in this list are
;; the actual expressions in the buffer.  The screen-list, however,
;; is a copy of a previously generated list.
;; If current buffer is empty, returns nil.

(defun generate-new-screen-image
       (&aux (upward-exp-list nil)		;Exps above the current exp
	     (downward-exp-list nil)		;Exps below the current exp
	     total-height			;How many lines needed
	     screen-image)			;List of exps to display
  (cond ((expression-list current-buffer)
	 (setq total-height (dimension-exp current-exp))
	 (setq screen-image (list current-exp))
	 (setf (expression-height current-exp) total-height)
	 
	 ;;Split the expression list into two lists -- those above the 
	 ;;current expression (in reverse order) and those below the current
	 ;;expression.
	 (do ((el (expression-list current-buffer) (cdr el)))
	     ((eq (car el) current-exp) (setq downward-exp-list (cdr el)))
	   (push (car el) upward-exp-list))
	 
	 ;;If distance from the top is less than the number of expressions
	 ;;above us, cut them off.
	 (if (> (length upward-exp-list)
		(current-exp-distance-from-top current-buffer))
	     (setq upward-exp-list
		   (firstn (current-exp-distance-from-top current-buffer)
			   upward-exp-list)))
	 
	 ;;Now redimension every equation on the screen.  Since some
	 ;;equations above us may have grown, the distance from the top will
	 ;;be the same it was before or will decrease.
	 (setf (current-exp-distance-from-top current-buffer) 0)
	 (*catch 'screen-full
		 (progn
		   (do ((ul upward-exp-list (cdr ul)))
		       ((null ul))
		     (setf (expression-height (car ul)) (dimension-exp (car ul)))
		     (setq total-height (+ total-height
					   (expression-height (car ul)) 1))
		     ;;DISPLA clobbers line following last line of expression
		     ;;displayed.
		     (if (>= (+ total-height 1) expr-area-height)
			 (*throw 'screen-full t))
		     (push (car ul) screen-image)
		     (setf (current-exp-distance-from-top current-buffer)
			   (1+ (current-exp-distance-from-top current-buffer))))
		   (do ((dl downward-exp-list (cdr dl)))
		       ((null dl))
		     (setf (expression-height (car dl)) (dimension-exp (car dl)))
		     (setq total-height (+ total-height
					   (expression-height (car dl)) 1))
		     (if (>= (+ total-height 1) expr-area-height)
			 (*throw 'screen-full t))
		     (setq screen-image (nconc screen-image (list (car dl)))))))
	 screen-image)))

;; The real thing.  Maybe we should be storing vertical position on screen in
;; each expression.

(defun redisplay ()
  (let ((new-exp-list (generate-new-screen-image)))

       ;;Redisplay the expression region.
       (do ((old-list screen-exp-list (cdr old-list))
	    (new-list new-exp-list (cdr new-list))
	    (old-height-from-top 0 (+ old-height-from-top
				      (expression-height (car old-list)) 1))
	    (new-height-from-top 0 (+ new-height-from-top
				      (expression-height (car new-list)) 1)))
	   (nil)
	   (cond

	    ;;Just as many old equations as new.  Clear whatever of the
	    ;;bottom portion of the old equations that might be left over.
	    ((and (null old-list) (null new-list))
	     (if (> old-height-from-top new-height-from-top)
		 (dctl-clear-lines new-height-from-top
				     (- old-height-from-top new-height-from-top)))
	     (return nil))

	    ;;More new equations than old.  Quit comparison and finish
	    ;;displaying new equations.
	    ((null old-list)
	     (do ((list new-list (cdr list))
		  (height-from-top new-height-from-top
				   (+ height-from-top
				      (expression-height (car list)) 1)))
		 ((null list))
		 (display-expression (car list) height-from-top))
	     (return nil))

	    ;;More old equations than new.  Quit comparison and erase from
	    ;;current position to last equation displayed.
	    ((null new-list)
	     (do ((list old-list (cdr list))
		  (lines-to-clear 0 (+ 1 lines-to-clear
				       (expression-height (car list)))))
		 ((null list)
		  (dctl-clear-lines new-height-from-top (1- lines-to-clear))))
	     (return nil))
		     
	    ;;Got the same expressions on the same line.  Skip to next
	    ;;expression.
	    ((and (= old-height-from-top new-height-from-top)
		  (same-exp-image (car new-list) (car old-list))))

	    ;;Display the expression on the current line if we can't scroll
	    ;;regions of the screen.
	    (t (display-expression (car new-list) new-height-from-top))
	    ))

;  	    ;;Display the expression on the current line if we can't scroll
;  	    ;;regions of the screen.
;  	    ((not idel-lines-available?)
;  	     (display-expression (car new-list) new-height-from-top))

;  	    ;;First look to see if the new expression is anywhere below us
;  	    ;;on the screen.  If it is, bring it up to where we are.
;  	    ((do ((ol (cdr old-list) (cdr ol))
;  		  (lines-to-scroll (1+ (expression-height (car old-list)))))
;  		 ((null ol) nil)
;  		 (cond ((same-exp-image (car new-list) (car ol))
;  			(dctl-scroll-region-up ...)
;  			(setq old-list ol)
;  			(return t)))))

;  	     ;;Otherwise, see if the old expression is anywere below is in
;  	     ;;the new screen image.  If so, move it down to where it belongs.

       (setq screen-exp-list (mapcar 'rdis-copy-expression new-exp-list))

       ;;Redisplay the mode line.
       (cond ((or (not (eq screen-buffer-name (buffer-name current-buffer)))
		  (not (= screen-exp-list-length
			  (length (expression-list current-buffer)))))
	      (display-mode-line)
	      (setq screen-buffer-name (buffer-name current-buffer))
	      (setq screen-exp-list-length
		    (length (expression-list current-buffer)))))

       ;;Home the cursor.  ITS won't send any characters if the cursor
       ;;is already up there.
       (cursorpos 0 0)))

;; This is really a kludge for our current mode of using this thing.  We're
;; going to need something better if people start hacking macros, like EQUAL of
;; the displayed portions of the two expressions, whereby the screen expression
;; has been entirely copied.

(defun same-exp-image (new-exp screen-exp)
       (and (eq (displayed new-exp) (displayed screen-exp))
	    (eq (expression-label new-exp) (expression-label screen-exp))
	    (= (reveal-depth new-exp) (reveal-depth screen-exp))
	    (= (length (operand new-exp)) (length (operand screen-exp)))
	    (or (and (not (region-boxed? new-exp))
		     (not (region-boxed? screen-exp)))
		(and (region-boxed? new-exp)
		     (region-boxed? screen-exp)
		     (eq (cadr (region new-exp)) (cadr (region screen-exp)))
		     (eq (save-pdl new-exp) (save-pdl screen-exp))
		     (= (region-length new-exp) (region-length screen-exp))))))

;; This function only used by the redisplay for storing screen state
;; information, so don't have to copy whole thing.  Maybe we should create a
;; special structure for the screen image.  Region and region-length only have
;; to be remembered for screen-current-exp.

(defun rdis-copy-expression (exp)
       (make-expression displayed (displayed exp)
			operand (append (operand exp) nil)
			expression-label (expression-label exp)
			expression-height (expression-height exp)
			reveal-depth (reveal-depth exp)
			region-boxed? (region-boxed? exp)
			;;The followning slots only needed for the current
			;;expression.  Copy region cons so that the screen
			;;version won't also get clobbered.  Displaying
			;;this won't work since region not part of
			;;displayed.
			save-pdl (save-pdl exp)
			region (list nil (cadr (region exp)))
			region-length (region-length exp)
			))

;; Completely restores the screen image.
;; Later make this move current expression to the top of the screen.

(defun full-redisplay ()
       (setq need-full-redisplay nil)
       (cursorpos 'C)		;Clear screen
       (let ((screen-image (generate-new-screen-image)))
	    (display-expressions screen-image)
	    (setq screen-exp-list
		  (mapcar 'rdis-copy-expression screen-image)))
       (display-mode-line)
       (minibuffer-clear)
       (cursorpos 0 0)
       (setq screen-buffer-name (buffer-name current-buffer))
       (setq screen-exp-list-length (length (expression-list current-buffer)))
       )


;; Dispatch Tables
;;  
;; The expression editor's idea of what a character is follows that of the Lisp
;; Machine.  The low order eight bits of the character is a single key portion,
;; with 0-177 being alphanumeric.  Bits 9 and 10 are set if control key or
;; meta keys were depressed, respectively.  These bits can also be set for
;; a given character by typing a control, meta or control-meta prefix.
;; The item associated with each character is a symbol, which contains
;; a function to call and associated information about that function.

;; The "single-char-table" array contains those functions which are associated
;; with a single keystroke command.
;;    0-177	Alphanumeric characters
;;  200-377	Other single-key characters
;;  400-777	Control characters
;; 1000-1377	Meta characters
;; 1400-1777	Control-Meta characters (not used currently)

;; The "c-x-prefix-table" array contains those functions associated with a control-x
;; prefix.

;; Stick this elsewhere.
#+MacLisp (defmacro make-array (size) `(array nil t ,size))

;; Don't clobber the table if it already exists.  For debugging purposes.

(cond ((not (boundp 'single-char-table))
       (setq single-char-table-size #o1400)
       (setq single-char-table (make-array single-char-table-size))
       (setq c-x-prefix-table-size #o1400)
       (setq c-x-prefix-table (make-array c-x-prefix-table-size))))

;; Take a description of the form Control-Meta-rubout and return the corresponding
;; character object.

(defun descriptor-to-char (descriptor)
  (setq descriptor (string descriptor))
  (let ((character 0)
	(symbolic-name))
       (if (or (string-search "C-" descriptor)
	       (string-search "Control-" descriptor))
	   (setq character (+ 1_8 character)
		 descriptor (substring descriptor
				       (1+ (string-search "-" descriptor)))))
       (if (or (string-search "M-" descriptor)
	       (string-search "Meta-" descriptor))
	   (setq character (+ 1_9 character)
		 descriptor (substring descriptor
				       (1+ (string-search "-" descriptor)))))
       (setq symbolic-name (assq (intern (make-symbol (string-upcase descriptor)))
				 descriptor-to-char-alist))
       (if symbolic-name
	   (+ character (cdr symbolic-name))
	   (+ character (character descriptor)))))

;; Take a character object and return a desciption.
;; On lispm, use special characters.

(defun char-to-descriptor (char &optional (brief nil))
  (let ((descriptor "")
	(symbolic-name))
       (if (not (= 0 (logand char %kbd-control)))
	   (setq descriptor (string-append descriptor (if brief "C-" "Control-"))))
       (if (not (= 0 (logand char %kbd-meta)))
	   (setq descriptor (string-append descriptor (if brief "M-" "Meta-"))))
       (setq symbolic-name (rassoc (logand char #o377) descriptor-to-char-alist))
       (if symbolic-name
	   (string-append descriptor (string (car symbolic-name)))
	   (string-append descriptor (string (logand char #o 377))))))

(setq descriptor-to-char-alist
      '((ALT      . #o33)  (SPACE  . #o40)   (CALL   . #o203)
	(BREAK    . #o201) (CLEAR  . #o202)  (ESCAPE . #o204)
	(BACKNEXT . #o205) (HELP   . #o206)  (RUBOUT . #o207)
	(BS       . #o210) (TAB    . #o211)  (LINE   . #o212)
	(VT       . #o213) (FORM   . #o214)  (RETURN . #o215)))


;; Key binding functions

;; Single characters are specified as C-M-A or Control-Meta-A.  Case matters in
;; the final letter.  "C-" and "M-" set control and meta bits respectively.
;; (set-key 'exit-editor "C-x" "C-c") will associate "exit-editor" with C-x
;; C-c.  Prefix characters may want to be generalized later on.

(defun set-key (function first-char &optional (second-char nil) &aux table)
   (cond (second-char (setq table c-x-prefix-table)
		      (setq first-char second-char))
	 (t (setq table single-char-table)))
   (if (atom first-char)
       (aset function table (descriptor-to-char first-char))
       (mapcar #'(lambda (key)
			 (aset function table (descriptor-to-char key)))
	       first-char)))

(defcom assign-key ((discard-argument)
		    (read-line command "Command Name: ")
		    (read-key key "On Key: "))
    "Associate a single key with a command.
The name of the command is asked for first, then the key to associate it
with.  When asked for the key, actually type the key you wish to place the
command on, not a description of the key. "

    (setq command (descriptor-to-symbol command))
    (let ((table))
      (cond ((= key (descriptor-to-char "Control-x"))
	     (setq key (read-key nil t " (prefix character) "))
	     (setq table c-x-prefix-table))
	    (t (setq table single-char-table)))
      (aset command table key)))


;; Returns function associated with a given key.  If function not there or
;; reference beyond array bounds, then return nil.

(defun get-key (table char)
       (declare (fixnum char))
       (cond ((eq table single-char-table)
	      (and (< char single-char-table-size) (aref single-char-table char)))
	     ((eq table c-x-prefix-table)
	      (and (< char c-x-prefix-table-size) (aref c-x-prefix-table char)))
	     (t (ed-internal-error 'get-key "Random table" table))))

;; Read a virtual character from the minibuffer, i.e. a single character from
;; the Lisp Machine's point of view.  Note that CONTROL-PREFIX, META-PREFIX,
;; and CONTROL-META-PREFIX are now wired in functions.
;; Note on terminology here:  A key is a virtual character -- something that
;; can be typed on a 12-bit keyboard in a single keystroke.  A character
;; is something that can be typed on the keyboard in use in a single keystroke.

(defun read-key (&optional (clear-on-multiple-keystroke nil) (echo-key t)
			   &rest format-args)
  (setq *multiple-keystroke-char-typed* nil)
  (if format-args (apply 'minibuffer-print format-args))
  (let* ((char (read-char))
	 (function (get-key single-char-table char))
	 (control-bit 0)
	 (meta-bit 0))
	(cond ((memq function '(control-prefix meta-prefix control-meta-prefix))
	       (setq *multiple-keystroke-char-typed* t)
	       (if clear-on-multiple-keystroke (minibuffer-clear))
	       (cond ((eq function 'control-prefix)
		      (minibuffer-print "Control-")
		      (setq control-bit %kbd-control))
		     ((eq function 'meta-prefix)
		      (minibuffer-print "Meta-")
		      (setq meta-bit %kbd-meta))
		     ((eq function 'control-meta-prefix)
		      (minibuffer-print "Control-Meta-")
		      (setq control-bit %kbd-control meta-bit %kbd-meta)))
	       (setq char (read-char))))
	;;If a multiple keystroke character is typed, the key is always echoed.
	;;Global used in lieu of multiple value return.
	(if (or *multiple-keystroke-char-typed* echo-key)
	    (minibuffer-print "~A" (char-to-descriptor char)))
	(+ char control-bit meta-bit)))

;; Prefix Keys

(set-key 'control-prefix "C-^")
(set-key 'meta-prefix "")
(putprop 'control-prefix
"Sets the control bit of the next character typed.
For example, typing this key and then typing /"A/" is equivalent
to typing /"Control-A/"." 'ed-documentation)
(putprop 'meta-prefix
"Sets the meta bit of the next character typed.
For example, typing this key and then typing /"A/" is equivalent
to typing /"Meta-A/"." 'ed-documentation)

(set-key 'control-x-prefix "C-x")
(defcom control-x-prefix ((argument n))
"This command is a prefix character."
    ;;First arg to read-key means clear screen if no argument present
    ;;Second arg means always echo character typed.
    ;;Third arg is message.
    (if (not n) (minibuffer-clear))
    (ed-dispatch (read-key nil t "Control-x ") c-x-prefix-table n))

;  Argument accumulators

(set-key 'accumulate-argument 
	 '("0" "1" "2" "3" "4" "5" "6" "7" "8" "9"
	   "C-0" "C-1" "C-2" "C-3" "C-4" "C-5" "C-6" "C-7" "C-8" "C-9"
	   "M-0" "M-1" "M-2" "M-3" "M-4" "M-5" "M-6" "M-7" "M-8" "M-9"))

;  Fix this up later to work like C-U in clearing to end of line.
;  Must have character redisplay by then, though.
(defcom accumulate-argument ((argument n) (character c))
  "This forms part of the next command's numeric argument."
  (setq c (- (logand c #o377) #/0))
    (cond ((not n) (minibuffer-clear)
		   (minibuffer-print "Argument: ~D " c))
	  ;; This is a special case hack to distinguish "-" from "-1",
	  ;; i.e. so that "-3" does not become -13.
	  ;; If we come here, "Argument: -1 " is displayed.
	  ((eq n 'negation)
	   (cond ((not (= c 1))
		  (dotimes (i 2) (cursorpos 'X))
		  (minibuffer-print "~D " c))))
	  ((= n 0)
	   (cond ((not (= c 0))
		  (dotimes (i 2) (cursorpos 'X))
		  (minibuffer-print "~D " c))))
	  (t (cursorpos 'B)				;Backward char
	     (minibuffer-print "~D " c)))
    (setq n (cond ((not n) c)
		  ((eq n 'negation) (- c))
		  ((< n 0) (+ (* n 10.) (- c)))
		  (t (+ (* n 10.) c))))
    (let ((char (read-key nil nil)))
	 (if (not (or (memq (get-key single-char-table char)
			    '(accumulate-argument multiply-argument-by-4
						  negate-argument))
		      *multiple-keystroke-char-typed*))
	     (minibuffer-print "~A" (char-to-descriptor char)))
	 (ed-dispatch char single-char-table n)))

(set-key 'multiply-argument-by-4 "C-u")
(defcom multiply-argument-by-4 ((argument n))
"Multiply the number of times to do the following command by 4."
    (cond (n (cursorpos minibuffer-vpos 10.)
	     (cursorpos 'L)
	     (minibuffer-print "~D " (* n 4)))
	  (t (minibuffer-clear)
	     (minibuffer-print "Argument: 4 ")))
    (let ((char (read-key nil nil)))
	 (if (not (or (memq (get-key single-char-table char)
			    '(accumulate-argument multiply-argument-by-4
						  negate-argument))
		      *multiple-keystroke-char-typed*))		      
	     (minibuffer-print "~A" (char-to-descriptor char)))
	 (ed-dispatch char single-char-table (if n (* n 4) 4))))

(set-key 'negate-argument '("-" "C--" "M--"))
(defcom negate-argument ((argument n))
"Negate the numeric argument."
    (cond (n (cursorpos minibuffer-vpos 10.)
	     (cursorpos 'L)
	     (minibuffer-print "~D " (- n)))
	  (t (minibuffer-clear)
	     (minibuffer-print "Argument: -1 ")))
    (let ((char (read-key nil nil)))
	 (caseq (get-key single-char-table char)
		(accumulate-argument 
		 (ed-dispatch char single-char-table (if n (- n) 'negation)))
		((multiply-argument-by-4 negate-argument)
		 (ed-dispatch char single-char-table (if n (- n) -1)))
		(t (if (not *multiple-keystroke-char-typed*)
		       (minibuffer-print "~A" (char-to-descriptor char)))
		   (ed-dispatch char single-char-table (if n (- n) -1))))))

;  Documentation Commands
;  Translates "FORWARD-BRANCH" to "Forward Branch" for purposes of printing.
(defun symbol-to-descriptor (symbol)
       (setq symbol (string symbol))
       (do ((old-string symbol (substring old-string (1+ index)))
	    (new-string "" (string-append new-string 
					  (string-capitalize
					   (substring old-string 0 index))
					  " "))
	    (index))
	   (nil)
	   (setq index (string-search "-" old-string))
	   (if (not index)
	       (return (string-append new-string (string-capitalize old-string))))))

;  We really need a general purpose translation function.  Write one at some point.
;      (setq descriptor (string-translate descriptor '(#/-) '(#\SP)))
(defun descriptor-to-symbol (descriptor)
       (setq descriptor (string-upcase (string-trim '(#\SP) (string descriptor))))
       (do ((old-string descriptor (substring old-string (1+ index)))
	    (new-string "" (string-append new-string (substring old-string 0 index) "-"))
	    (index))
	   (nil)
	   (setq index (string-search " " old-string))
	   (if (not index)
	       (return (intern (string-append new-string old-string))))))

;; Turn off interrupts here so can describe control-g.
;; *** Note *** A quickie kludge was added here to need-full-redisplay
;; to allow multiple key descriptions without redisplay.  Be sure to
;; fix asap.  Right thing to do is record how many lines of current window
;; have been messed up and only redisplay as needed.

(set-key 'describe-key '("?" "C-?" "M-?" "HELP"))
(defcom describe-key ((discard-argument) (read-key first-char "Describe Key: "))
"Describes the command associated with a given key."
    (let ((function)
	  (second-char))
	 (setq function (get-key single-char-table first-char))
	 ;; Need a more general way of doing this.
	 (when (eq function 'control-x-prefix)
	       (setq second-char (read-key nil t " (prefix character) "))
	       (setq function (get-key c-x-prefix-table second-char)))
	 ;;Flush when we get multiple windows in.
	 (if (and need-full-redisplay (fixp need-full-redisplay))
	     (cursorpos need-full-redisplay 0)
	     (cursorpos 0 0))
	 (cursorpos 'L)
	 (format t "~A" (char-to-descriptor first-char))
	 (if second-char
	     (format t " ~A" (char-to-descriptor second-char)))
	 (format t " is ~A.~%"
		  (if function (symbol-to-descriptor function) "an undefined key"))
	 (if function
	     (format t "~A~%"
		      (or (get function 'ed-documentation)
			  "No documentation found."))))
    (setq supress-redisplay t)
    ;;Change this to (setq screen-exp-list nil) when multiple windows are in.
    (setq need-full-redisplay (car (cursorpos))))

(defcom describe-command ((discard-argument)
			  (read-line name "Describe Command: "))
"Describes a command specified by its long name."
    (cursorpos 0 0)
    (cursorpos 'L)
    (setq name (descriptor-to-symbol name))
    (if (get name 'ed-documentation)
	(format t "~A~%" (get name 'ed-documentation))
	(format t "No documentation found for ~A.~%" name))
    (setq supress-redisplay t)
    (setq need-full-redisplay t))

(defcom list-keys ((discard-argument))
"Lists those keys which are associated with editor commands."
    (cursorpos 0 0)
    (cursorpos 'L)
    (make-key-listing #+lispm standard-output #+maclisp tyo)
    ;;Supress redisplay of this command, but do a full redisplay after
    ;;next command is typed.
    (setq supress-redisplay t)
    (setq need-full-redisplay t))

;  Once we start maintaining a list of commands.
;  (defcom list-commands ((discard-argument))
;  "Lists all commands which are part of the display toplevel.
;  If the command is associated with a key, then the key is also listed.  Ony
;  the first line of documentation for each command is printed.  For more
;  documentation on a command, use the /"Describe Command/" extended command."

;  Walk through the key dispatch tables and print the key, its binding,
;  and the first line of documentation.
(defun make-key-listing (stream)
    (format stream "Macsyma Display Toplevel -- Command Summary~2%")
    (format stream "Single Character Commands~2%")
    (make-key-listing-table single-char-table single-char-table-size stream)
    (format stream "~2%Control-x Prefix Commands~2%")
    (make-key-listing-table c-x-prefix-table c-x-prefix-table-size stream))

;  Search a single table.
(defun make-key-listing-table (table size stream &aux function documentation)
    (format stream "~8A~30A~A~%" "Key" "Command" "Description")
    (format stream "~8A~30A~A~%" "---" "-------" "-----------")
    (do i 0 (1+ i) (= i size)
	;;Don't display Sail characters if using an Ascii keyboard.
	(setq function
	      #-lispm (if (or 12-bit-kbd-available?
			      (= i #o33)
			      (> i #o37))
			  (get-key table i))
	      #+lispm (get-key table i))
	(cond (function
	       (setq documentation (get function 'ed-documentation))
	       (if documentation
		   (setq documentation
			 (substring documentation 0
				    (min (- linel 38.)
					 (or (string-search-char #\CR documentation)
					     (string-length documentation))))))
	       (format stream "~8A~30A~A~%"
		       (char-to-descriptor i t)
		       (symbol-to-descriptor function)
		       (if documentation documentation "Not documented."))))))


;  Miscellaneous stuff.

(set-key 'extended-command-prefix "M-x")
(defcom extended-command-prefix
	((argument n)
	 (read-line command
		    "Extended Command: ~A"
		    (if n (format nil "(argument = ~D) " n) "")))
"Invoke a command by specifying its long name."
    (setq command (descriptor-to-symbol command))
    (ed-dispatch-command command n nil))

(set-key 'command-quit "C-g")
(set-key 'command-quit "C-x" "C-g")
(defcom command-quit ((discard-argument))
"Abort the current command and return to editor toplevel."
    (minibuffer-clear))

(set-key 'no-op " ")
(defcom no-op ((discard-argument))
"Does nothing other than redisplaying the screen.
Useful for reconstructing the screen image after a message or documentation
has been printed." nil)

(set-key 'debug-it "~")
(defcom debug-it ((discard-argument))
"Break into Lisp.  Control-G takes you back to editor toplevel."
	(setq need-full-redisplay t)
	#+its (enable-echoing)
	#+its (unwind-protect (break debug) (disable-echoing))
	#+lispm (break debug))

(set-key 'exit-editor "C-z")
(set-key 'exit-editor "C-x" "C-c")
(defcom exit-editor ((discard-argument))
"Exit the editor."
    (*throw 'exit-editor nil))

;; Rethink this.  Need ways to eval Lisp and Macsyma forms.
;; What about typing monitor commands?

(set-key 'eval-macsyma-expression "C-x" "C-e")
(set-key 'eval-macsyma-expression "M-")
(defcom eval-macsyma-expression ((discard-argument)
				 (read-expression exp "Evaluate: "))
"Evaluate a Macsyma expression."
    (if (expression-list current-buffer)
	(setq exp (subst (region-as-mexp current-exp) '$% exp)))
    (meval exp))

(set-key 'return-to-emacs "C-x" "z")
(defcom return-to-emacs ((discard-argument))
"Return to Emacs from Macsyma."
    #+its (setq need-full-redisplay t)
    (minibuffer-print " [into emacs] ")
    #+its (ledit)
    #+lispm (ed)
    )
