# Introduction to Maclisp

### A "hello world" example

Lisp programs can be developed in the interpreter, but serious
applications will usually be compiled and saved as standalone
executable programs.

Enter this small program and save it as `hello lisp`.  Then compile it
with the command `:complr hello lisp`.  Now the compiled code will be
in the file `hello fasl`.  Make sure to kill the lingering COMPLR job,
or else the next step might fail.

```
(defun hello ()
  (princ "Hello Maclisp!")
  (terpri)
  (quit))
```

To make the executable program, enter this code (comments are
optional) and save it as `hello dumper`.  Then run the command `:lisp
hello dumper`.  The result will be that Maclisp loads the `hello fasl`
file and writes out `ts hello`.

```
(comment)                             ;Avoid question about allocation.
(progn
  (close (prog1 infile (inpush -1)))  ;Make sure file channels are closed.
  (fasload hello)                     ;Load the compiled program.
  (gc)                                ;Garbage collect.
  (purify 0 0 'bporg)                 ;Purify memory pages.
  (sstatus flush t)                   ;Share pure pages with Maclisp.
  (suspend ":kill " '(ts hello))      ;Save image as an executable program.
  (hello))                            ;Executable program will start from here.
```

These files are available in the HELLO directory.
