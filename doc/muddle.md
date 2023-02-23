# Introduction to Muddle

### Background

Muddle, later renamed MDL, was a programming language created by the
Dynamic Modeling group (also known as the Programming Technology
Division) at MIT.  The most famous application written in this
language is the Zork interactive fiction game.  The influental CLU
programming language was bootstrapped from Muddle.

Muddle is a dialect of Lisp, but with the distinct difference that
forms are bracketed by `<` and `>` instead of parentheses.  `(` and
`)` still denote lists and are occasionally present in the language
syntax.  The language is case sensitive, and all standard names must
be entered in upper case.  To submit an expression to the interpreter,
type the <kbd>Escape</kbd> key which echoes as `$`.

### Interpreted Example

A common way to develop applications in Muddle, is to build a program
in the interpreter and write out a `SAVE` image file.  This file can
later be recalled using `RESTORE`.

To make a "hello world" application, create a file called HELLO MUD
with this content:

```
<DEFINE HELLO ()
  <PRINC "Hello, muddled world!">
  <TERPRI>
  <QUIT>>

<DEFINE SAVE-IT ()
  <COND (<=? <SAVE "HELLO SAVE"> "SAVED"> <QUIT>)>
  <HELLO>>
```

`HELLO` is the main program which prints a message and terminates.
`SAVE-IT` is used to create a `SAVE` file and arranges to call `HELLO`
when it's restored.

Now start `:mud55` and type `<FLOAD "HELLO MUD">` and
<kbd>Escape</kbd>.  Next, type `<SAVE-IT>`<kbd>Escape</kbd>.
It should look like this:

```
:mud55
MUDDLE 55 IN OPERATION.
LISTENING-AT-LEVEL 1 PROCESS 1
<FLOAD "HELLO MUD">$
"DONE"
<SAVE-IT>$
:KILL
```

A `HELLO SAVE` file has been created with the `HELLO` procedure in it.
To run it, start `:mud55` again and type `<RESTORE "HELLO SAVE">`:

```
*:mud55
MUDDLE 55 IN OPERATION.
LISTENING-AT-LEVEL 1 PROCESS 1
<RESTORE "HELLO SAVE">$
Hello, muddled world!

:KILL
```

The sample program can be found in the HELLO directory.

### Compiled Example

Any serious Muddle program would be compiled.  To do this, invoke the
`PCOMP` program which is Muddle with the compiler built in.  Then call
the procedure `FILE-COMPILE` to compile the source file.  The compiler
will work in the background.

```
:pcomp
MUDDLE COMPILER NOW READY.
<FILE-COMPILE "HELLO MUD">$

Toodle-oo.
:PROCED
*
Job PCOMP wants the TTY
```

When the compiler is done, it leaves the compiled file `HELLO NBIN` in
your directory.  Start Muddle again, and this time load the compiled
file.  Then make the `SAVE` file:

```
:mud55
MUDDLE 55 IN OPERATION.
LISTENING-AT-LEVEL 1 PROCESS 1
<FLOAD "HELLO NBIN">$
"DONE"
<SAVE-IT>$
:KILL
```

The new `SAVE` file can be restored like before, but it can also be
used to make a standalone executable.  This is done by having the
MIDAS assembler process the file SUBSYS MAKER.  The assembler will
request information to locate your `SAVE` file.  The file name is
`HELLO SAVE`, which is the "Subsystem name" and "Second Name" below.
The directory is the last question about the "Sname".

```
:MIDAS TS HELLO_MUDSYS;SUBSYS MAKER
Muddle Subsystem Bootstrap
Type in Subsystem (Save File) name: HELLO
Type Y if you wish to have Save File directly restored: Y
Type Second Name of Save File: SAVE
Type Sname of Save File: HELLO
:KILL
```

This will produce an exectutable file called TS HELLO.

### More Information

For more information, see these documents:

- [MDL Programming Primer](https://raw.githubusercontent.com/PDP-10/muddle/master/doc/MDL_Programming_Primer.pdf)
- [MDL Programming Language](https://raw.githubusercontent.com/PDP-10/muddle/master/doc/MDL_Programming_Language.pdf)
- [MDL Primer and Manual](https://raw.githubusercontent.com/PDP-10/muddle/master/doc/MDL_Primer_and_Manual.pdf)
- [MDL Programming Environment](https://raw.githubusercontent.com/PDP-10/muddle/master/doc/MDL_Programming_Environment.pdf)
