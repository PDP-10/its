; This is USER.LSP[A110PS99], a  basic set of extensions to OPS4
; provided for  users  who  do not  wish  to provide  their  own
; extensions.   It contains the necessary  calls to define seven
; LHS functions, two new variable types, and five RHS functions.

; The two  new variable  types are  the <  and >  types.  The  <
; variable  will match numeric  atoms that are equal  to or less
; than the  atoms matching the corresponding  = variable.  The >
; variables  will match  numeric  atoms  that are  equal  to  or
; greater than the  atoms matching the corresponding = variable.
; In order not to  slow the execution, the functions that define
; the  variable  types  are compiled.   (This  file  contains  a
; command  to  read  in  the  compiled  code.)   The  uncompiled
; functions are:
;
	(DEFUN L1ST (L G) 
	  (AND (NUMBERP G) (NUMBERP L) (NOT (LESSP G L))))

	(DEFUN L2ND (G L) 
	  (AND (NUMBERP G) (NUMBERP L) (NOT (LESSP G L))))

; The  seven new  LHS  functions  are  <<, >>,  <=,  >=,  <ANY>,
; <NOTANY>,  and <TYPE>.   The first  four of  these are numeric
; functions which take exactly one argument.  << matches numbers
; that  are strictly  smaller  than  its argument.   >>  matches
; numbers  that  are  strictly greater  than  its  argument.  <=
; matches  numbers  that  are  equal  to  or  smaller  than  its
; argument.   >= matches  numbers that  are equal  to or greater
; than its argument.  The other three functions will accept more
; than one  argument.  <ANY> will match any  atom which is equal
; to one of its  arguments.  <NOTANY> will match any atom except
; one which is equal to one of its arguments.  <TYPE> will match
; any  element whose  type  is  listed in  its  argument.   This
; function accepts  for arguments  one or  more of  ATOM,  LIST,
; NUMBER, and SYMBOL.   Thus (<TYPE> SYMBOL) will match symbolic
; atoms only,  and (<TYPE> LIST NUMBER)  will match anything but
; symbolic atoms.   Note that <ANY> can be used  as a LHS quote:
; in order to get an atom like  & or = in the LHS, one put it as
; an argument  to  <ANY>.  For  example, the  condition  element
; (<ANY> =X)  will match the atom =X.   The definitions of these
; functions:
;
	(DEFUN << (CONST ELEM)
	  (AND (NUMBERP ELEM) (LESSP ELEM (CAR CONST))))

	(DEFUN >> (CONST ELEM)
	  (AND (NUMBERP ELEM) (GREATERP ELEM (CAR CONST))))

	(DEFUN >= (CONST ELEM)
	  (AND (NUMBERP ELEM) (NOT (LESSP ELEM (CAR CONST)))))

	(DEFUN <= (CONST ELEM)
	  (AND (NUMBERP ELEM) (NOT (GREATERP ELEM (CAR CONST)))))

	(DEFUN <ANY> (ARG ELM) (MEMBER ELM ARG))

	(DEFUN <NOTANY> (ARG ELM) (NOT (MEMBER ELM ARG)))

	(DEFUN <TYPE> (TYPES E)
	  (OR (AND (MEMQ 'ATOM TYPES) (ATOM E))
	      (AND (MEMQ 'LIST TYPES) (NOT (ATOM E)))
	      (AND (MEMQ 'NUMBER TYPES) (NUMBERP E))
	      (AND (MEMQ 'SYMBOL TYPES) 
		   (ATOM E) (NOT (NUMBERP E)))))

; The five  RHS functions,  <+>, <->,  <*>, <//>,  and <^>,  are
; arithmetic functions.  <+>, <->, <*>, and <//> take any number
; of arguments; <^> takes exactly  two arguments.   <+> adds its
; arguments  together.    <*>  multiplies  its  arguments.   <->
; subtracts the second through  last arguments (if there is more
; than  one argument)  from the  first.  <//>  divides the first
; argument by the second through last arguments.  <^> raises the
; first argument  to the power of the  second argument.  All the
; functions are  capable  of mixed  mode arithmetic.   They  are
; defined as follows.
;
	(DEFUN <+> FEXPR (X) 
	  (LIST (APPLY 'PLUS (APPLY 'EVAL-LIST X))))

	(DEFUN <-> FEXPR (X) 
	  (LIST (APPLY 'DIFFERENCE (APPLY 'EVAL-LIST X))))

	(DEFUN <*> FEXPR (X) 
	  (LIST (APPLY 'TIMES (APPLY 'EVAL-LIST X))))

	(DEFUN <//> FEXPR (X) 
	  (LIST (APPLY 'QUOTIENT (APPLY 'EVAL-LIST X))))

	(DEFUN <^> FEXPR (X) 
	  (LIST (APPLY 'EXPT (APPLY 'EVAL-LIST X))))


;;; (FASLOAD  USER FAS)    ; Load the compiled code

(VARIABLE < L2ND L1ST)		; Make the declarations
(VARIABLE > L1ST L2ND)

(PREDICATE << >> <= >= <ANY> <NOTANY> <TYPE>)

(RHS-FUNCTION <+> <-> <*> <//> <^>)

