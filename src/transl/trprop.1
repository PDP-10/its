;;;;;;;;;;;;;;;;;;; -*- Mode: Lisp; Package: Macsyma -*- ;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1981 Massachusetts Institute of Technology         ;;;
;;;                 GJC 10:11pm  Tuesday, 14 July 1981                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(macsyma-module trprop)

;; Many macsyma extension commands, e.g. $INFIX, $TELLSIMP,
;; $DEFTAYLOR work by doing explicit PUTPROPS.
;; These META-PROP functions allow selected commands to
;; also output DEFPROP's when processed in the Macsyma->lisp translation.

(DEFMVAR META-PROP-P NIL)
(DEFMVAR META-PROP-L NIL)

(DEFUN META-OUTPUT (FORM)
  (IF *IN-TRANSLATE-FILE* (PUSH FORM META-PROP-L))
  ;; unfortunately, MATCOM needs to see properties in order
  ;; to compose tellsimps. so eval it always.
  (EVAL FORM))

(DEFMFUN META-ADD2LNC (ITEM SYMBOL)
  (IF META-PROP-P
      (META-OUTPUT `(ADD2LNC ',ITEM ,SYMBOL))
      (ADD2LNC ITEM (SYMEVAL SYMBOL))))

(DEFMFUN META-PUTPROP (SYMBOL ITEM KEY)
  (IF META-PROP-P
      (PROG1 ITEM (META-OUTPUT `(DEFPROP ,SYMBOL ,ITEM ,KEY)))
      (PUTPROP SYMBOL ITEM KEY)))

(DEFMFUN META-MPUTPROP (SYMBOL ITEM KEY)
  (IF META-PROP-P
      (PROG1 ITEM (META-OUTPUT `(MDEFPROP ,SYMBOL ,ITEM ,KEY)))
      (MPUTPROP SYMBOL ITEM KEY)))

(DEFMFUN META-FSET (SYMBOL DEFINITION)
  (IF META-PROP-P
      (PROG1 DEFINITION (META-OUTPUT `(FSET ',SYMBOL ',DEFINITION)))
      (FSET SYMBOL DEFINITION)))
