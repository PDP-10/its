;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module edmac macro)

#-lispm
(progn 'compile
       (load-macsyma-macros lmrund)
       (load-macsyma-macros-at-runtime 'lmrund)
       )

;; Macsyma display-oriented expression editor
;; Macros and structure definitions
;; See EMAXIM;ED > and EMAXIM;EDCOM > for more information.
;; Written:	Feb 17, 1979 By RZ, based on a version by CWH and BEE
;; Rewritten:   June 2, 1979 by CWH for Macsyma Users' Conference
;; Alt:         July 1, 1981 by GJC, annointing for NIL.

;; Data Structures

;; The smallest fundamental data unit is the expression -- this consists of a
;; macsyma expression, formatting information, a displayed region, and a
;; command region.  Buffers consist of a collection of expressions and may
;; share expressions among one another.  A subset of the expressions within a
;; buffer will be displayed in a window.  Only complete sub expressions are
;; displayed, although REVEAL may be used to hide inner structure.

(defstruct (expression)
    body			;Body of the expression.  A complete
				;subnode of this expression is always
				;displayed.
    displayed			;The displayed portion of the expression.
				;Always a complete subnode.
    region			;That portion of the expression which
				;subsequent commands will affect.  May
				;be several branches of a subnode.
    (save-pdl nil)		;Current way of keeping track of where
				;we are.
    (region-length 1)		;Region length -- number of branches included
				;in region.  Normally 1 unless extended with
				;extend-forward.
    (operator nil)		;Operator of region node, i.e. this level
    (operand nil)		;Entire node, i.e. the level itself
				;The are both nil when the region is the same
				;as the body.
    expression-label		;Need some way of referring to expressions
				;within a buffer.  This label is a symbol
				;and is bound to the body of the expression.
    expression-height		;The height in characters of the expression.
				;Used by the redisplay.
    (reveal-depth 0)		;If depth = 0, then reveal all of expression.
				;See Macsyma $REVEAL function.
    (region-boxed? nil)		;Right now, this means that the expression
				;is current.
    )

(defstruct (buffer)
    buffer-name			;Name of the buffer.  Used for moving between
				;them.
    (expression-list nil)	;All of the expressions contained within
				;the buffer.  Currently, all are displayed.
    (current-exp nil)		;The current expression in this buffer.
    (current-exp-distance-from-top 0)		;If this field is 0, then the
				;current expression is the top expression on
				;the screen.
    (buffer-mode '|Expression|)	;Do we want this?
    )


;; Command definition macro

;; Defines an editor command (and a lisp function) with the specified name.
;; The possible options are:
;;  
;;   (argument n)	Makes "n" an entry in the bvl of the function.
;; 			Means that this function gets passed its argument
;; 			which it uses as it pleases.
;;  
;;   (discard-argument)	This function doesn't use its argument and
;;			and doesn't want to be iterated.  If neither
;;			of the above two argument options are specified,
;;			then the character dispatcher will iterate the
;;			command if an argument is given.
;;   
;;   (character c)	Makes "c" an entry in the bvl of the function.  Means
;; 			that this function gets passed the character which
;; 			invoked it.
;;  
;;   (read-key key "Key: ")	This function wants a character to be typed
;; 				for purposes of description, assignment, etc.
;; 				Control and Meta prefixes are taken care of
;; 				by READ-KEY.
;;  
;;   (read-line file-name "File Name:  ")	This function wants a string
;; 						argument to be typed in the
;; 						minibuffer, terminated by a
;; 						carriage return.  "file-name"
;; 						will be in the bvl of the function.
;;  
;;   (read-expression exp "Expression:  ")	This function wants a macsyma
;; 						expression as an argument.
;; 						Expression returned in the
;; 						macsyma internal format.
;;  
;; Note that the CDDR of the forms starting with READ-LINE and READ-EXPRESSION
;; can be any arbitrary format string.  Note also that the order in which these
;; forms appear in the bvl is critical.  They must appear in the same order
;; as presented above.

;; (defcom foo ((argument n) (character c) (read-line line "Type a ~A:" frobboz))
;; 	"Random documentation"
;; 	(random-code)) -->
;;  
;; (progn 'compile
;;        (putprop 'foo 'ed-documentation "Random documentation")
;;        (putprop 'foo 'ed-arg-action 'pass)
;;        (putprop 'foo 'ed-char-action 'pass)
;;        (defun foo (n c &optional (line (read-line "Type a ~A:" frobboz)))
;; 	       (random-code)))

(defmacro defcom (name option-list documentation &rest body)
   (let ((arg-list nil)
	 (arg-action 'iterate)
	 (char-action 'discard))
	(mapcar
	 #'(lambda (option)
            (caseq (car option)
		   (argument (push (cadr option) arg-list)
			     (setq arg-action 'pass))
		   (discard-argument (setq arg-action 'discard))
		   (character (push (cadr option) arg-list)
			      (setq char-action 'pass))
		   (read-key
		    (or (memq '&optional arg-list)
			(push '&optional arg-list))
		    (push `(,(cadr option) (progn (minibuffer-clear)
						  (read-key nil t . ,(cddr option))))
			  arg-list))
		   ((read-line read-expression)
		    (or (memq '&optional arg-list)
			(push '&optional arg-list))
		    (push `(,(cadr option) (,(car option) . ,(cddr option)))
			  arg-list))
		   (t (error "Unknown defcom option" (car option)))))
	 option-list)
	(setq arg-list (nreverse arg-list))
	`(progn 'compile
		(putprop ',name ,documentation 'ed-documentation)
		(putprop ',name ',arg-action 'ed-arg-action)
		(putprop ',name ',char-action 'ed-char-action)
		#+maclisp
		,@(if (memq '&optional arg-list) `((declare (*lexpr ,name))))
		(defun ,name ,arg-list . ,body))))

;; Compatibility macros and other random stuff

(defmacro string-capitalize (string)
	  `(string-append (string-upcase (substring ,string 0 1))
			  (string-downcase (substring ,string 1))))


;; Useful predicates for examining the state of an expression.
;; Please use these if possible so as to avoid dependence upon our
;; current form of expression representation.

;  (eq (body current-exp) (region current-exp)) is also a test for this.
(defmacro region-contains-top-node? ()
	  '(null (save-pdl current-exp)))

(defmacro region-contains-terminal-node? ()
	  '(atom (cadr (region current-exp))))

;  (eq (caar (save-pdl current-exp)) 'CDR) is also a test for this.
(defmacro region-contains-first-branch? ()
	  '(eq (region current-exp) (operand current-exp)))

(defmacro region-contains-last-branch? ()
	  '(null (nthcdr (1+ (region-length current-exp))
			 (region current-exp))))

(defmacro region-contains-entire-level? ()
	  '(= (region-length current-exp)
	      (length (cdr (operand current-exp)))))


;; Declarations:

(if (fboundp 'special)
    (special buffer-list		;All of the buffers being used.
					;Maintained between invocations
	     current-buffer		;Contains the current expression.
	     current-exp		;Expression currently being edited.

	     screen-exp-list		;Redisplay state information
	     screen-buffer-name		;Should be made intelligent about
	     screen-exp-list-length	;windows.

	     previous-buffer		;Previously selected buffer

	     single-char-table		;Dispatch table for single character commands
	     c-x-prefix-table		;Dispatch table for control-x prefix commands
	     single-char-table-size	;Size of array
	     c-x-prefix-table-size	;Size of array

	     buffer-name-count		;For generating buffer names
	     kill-pdl			;pdl of deleted expressions
	     mark-pdl			;pdl of marks
	     need-full-redisplay	;When screen has been completely destroyed
					;Rename to full-redisplay?
	     supress-redisplay		;Deliberately supress redisplay until after
					;next command typed.

	     char-to-descriptor-alist	;For converting between 
	     descriptor-to-char-alist	;characters and their
					;description.

	     idel-chars-available?	;Terminal control information
	     idel-lines-available?
	     overstrike-available?
	     12-bit-kbd-available?
	     12-bit-input		;Fixnum input stream for
					;Knight keyboards.

	     %kbd-control		;Bit specifiers for the appropriate
	     %kbd-meta			;fields in the Lisp Machine character
	     %kbd-control-meta		;representation.

	     *multiple-keystroke-char-typed*	;READ-KEY has to return
					;two values, but can't in Maclisp.  Use this
					;global instead.  Indicates that a control
					;or meta prefix was typed as a part of the
					;most recently typed character.

	     expr-area-height		;Screen parameters.
	     minibuffer-height		;Single window only.
	     mode-line-vpos
	     minibuffer-vpos
	     ))

(if (fboundp 'fixnum)
    (fixnum screen-region-length buffer-name-count
	    single-char-table-size c-x-prefix-table-size
	    expr-area-height minibuffer-height
	    mode-line-vpos minibuffer-vpos
	    %kbd-control %kbd-meta %kbd-control-meta
	    ))

;; Macsyma special variables

(if (fboundp 'special)
    (special $outchar $boxchar ttyheight linel $linenum))

(if (fboundp 'fixnum)
    (fixnum ttyheight linel $linenum))

;; Special variables in MRG;DISPLA

(load-macsyma-macros-at-runtime 'displm)

;; Inter-module functions -- generally I/O stuff.

(if (fboundp '*expr)
    (*expr ed-prologue ed-epilogue enable-echoing disable-echoing
	   display-expression display-expressions display-mode-line
	   dctl-clear-lines dctl-scroll-region-up dctl-scroll-region-down
	   minibuffer-clear expr-area-clear read-char tv-beep
	   label-exp box-region unbox-region
	   region-as-mexp delete-expression top-level
	   make-current-exp make-current-buffer full-redisplay))

(if (fboundp '*lexpr)
    (*lexpr set-key make-exp
	    read-key read-line read-expression
	    minibuffer-print char-to-descriptor
	    ed-error ed-internal-error
	    replace-region select-buffer))

(if (fboundp 'notype)
    (notype (dctl-clear-lines fixnum fixnum)
	    (dctl-scroll-region-up fixnum fixnum fixnum)
	    (dctl-scroll-region-down fixnum fixnum fixnum)))

;; Macsyma system functions.
(if (fboundp '*expr)
    (*expr retrieve simplify ssimplifya nformat-all meval makelabel mset
	   $partfrac))

(sstatus feature emaxim-edmac)
