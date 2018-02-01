30-Aug-78 12:52:43-PDT,180;000000000001
Date: 30 Aug 1978 1252-PDT
From: Agin
Subject: EMACS Simplified
To:   system

Users and prospective users of the text editor EMACS should read
<EMACS>DATAMEDIA.DOC
-------
 1-Sep-78 10:32:54-PDT,1180;000000000001
Date:  1 Sep 1978 1032-PDT
From: Agin
Subject: Changes to EMACS/Datamedia
To:   EMACS/Datamedia Users:

Commands have been set up to give the user several options in the
setting of control and meta bits.  There are three conventions:
	1.  Use the Ctrl and Edit keys on the Datamedia Keyboard.
	2.  Use Escape for Meta and either Edit-Escape or
		Escape-Escape for Control-Meta.  This usage is
		similar to TVEDIT. 
	3.  Use the three unlabeled keys on the left of the keyboard
		(between ^L and ^A).  The bottom key, ^^, is Prefix
		Control.  The middle key, ^], is Prefix Meta.  The
		top key, ^\, is Prefix Control-Meta. 
The Execute Minibuffer command has been moved to ^X-X to free M-escape.

The commands that exchange characters, words, etc. have been moved
from "T" to "E", where they will be more mnemonic.

Back to Indentation has been assigned to ^X-[ .

A No-op macro has been implemented and assigned to C-N.  Try it after
documentation commands, ^C, etc. 

Replace String is no longer assigned to M-R.  It turns out that it
replaces EVERY occurrence of the string.  You can get that by typing
"!" to Query Replace.

	Jerry Agin
-------
 7-Sep-78 13:51:17-PDT,499;000000000001
Date:  7 Sep 1978 1351-PDT
From: Agin
Subject: ^Z Changes
To:   EMACS/Datamedia Users:

^Z had erroneously been assigned to Exit ^R Mode, instead of Return
to Superior.  This has now been fixed.  The problem of accidentally
hitting ^Z and finding yourself in TECO should not happen any more.

A new macro called ^R Save and Return to Superior has been
implemented and assigned to ^X ^Z.  This is the command to use to
exit from EMACS when called from inside SNDMSG, LISP, etc. 
-------
12-Sep-78 17:09:50-PDT,1632;000000000001
Date: 12 Sep 1978 1709-PDT
From: Agin
Subject: Miscellaneous
To:   EMACS/Datamedia Users:

A new function, "TECO Search" has been defined and assigned to ^X S.
This function uses some powerful features of the underlying TECO 
that just ain't available thru the fancied-up "Incremental Search"
function.  TECO Search uses the special character ^B to match any
delimiter, and ^X to match any character.  ^N is used to negate a
match to the following character.  ^O is an "or" function, dividing
the search string into substrings to be searched for simultaneously.

Both TECO Search (^X S) and Query Replace (C-M-R) use the minibuffer
to obtain their arguments.  I'm thinking that it is a mistake to
do it this way--they could just as easily obtain their arguments in
the prompt area the way MM commands do.  The price is that carriage
return can't be part of any argument, but the advantage is that
there's one unusual mode of input the user need not learn.  Does
anyone have reactions?  If I don't hear objections, I'll make the
changes soon.

Another troublesome matter concerns the various flavors of ^Z.  I
discovered that you need the original definition of ^Z (Exit ^R
Mode) to get out of the "Edit Tab Stops" function.  One fix is to
redefine Edit Tab Stops so it temporarily re-assigns ^Z to the 
do what is necessary.  This seems rather unclean, but on the other
hand, a system where you need to remember three different exit
functions that depend on what you're doing isn't very clean either.
Comments anyone?

The "Where am I" function (^X =) now gives the page and line.

	Jerry
-------
13-Sep-78 16:39:37-PDT,384;000000000001
Date: 13 Sep 1978 1639-PDT
From: Riseman
Subject: EMACS Documenatation
To:   agin

Gerry,
Is there any documentation file for EMACS which gives
a nice summary of the basic commands.  I have listed some
of the nodes in INFO, but they are often long-winded and
provide too much detail to start.  I also have listed
the Datamedia chart and conversion tables.
--Ed--
-------
13-Sep-78 17:23:55-PDT,989;000000000001
Date: 13 Sep 1978 1723-PDT
From: Agin
Subject: Re: EMACS Documenatation
To:   Riseman
cc:   AGIN

In response to your message sent 13 Sep 1978 1639-PDT

The node "Basic" in the INFO file is a reasonable summary of the basic
commands (modulo conversion to the Datamedia command set).  If you
don't like poking thru windy explanations, you might prefer to use
some of the self-documenting features of EMACS.  ^_ is the help character;
it is equivalent to the "hold" key.  "^_ A FOO" will type the names
of all commands that have FOO in their names.  ("A" here stands for 
"Apropos".)  "^_ D ^R DOWN LINE" types a complete description of the
command "^R DOWN LINE".  ("D" for describe.)  "^_ C <any keystroke>"
tells you what command is assigned to the key, and its description.
The data base for all these features gets automatically updated
whenever commands are changed, so it always corresponds to the version
you have in core at that given moment.

	Jerry
-------
18-Sep-78 10:54:35-PDT,1470;000000000001
Date: 18 Sep 1978 1054-PDT
From: Agin
Subject: New features
To:   EMACS/Datamedia Users:
cc:   Boyer

Commands for editing LISP code have been added to the command set.
See the latest edition of DATAMEDIA.CHART for where they go.  I am
indebted to Bob Boyer for supplying some redefinitions and character
tables to make it edit Interlisp.  See the file <BOYER>NEMACS.DOC for
the description of a very nice interface that allows you to call EMACS
directly from Interlisp to edit LISP functions and S-expressions.
Note that editing commands get placed on different keys in the Datamedia
environment than Boyer uses in the default environment.  In particular,
^Z is the return-to-LISP function. 

^Z is now the universal pop-a-level character within the EMACS/Datamedia
environment.  You should use it to return to SNDMSG or LISP, and to
return from recursive ^R.  If you use it at any other time, it is
equivalent to ^C.  The implementation of ^Z requires that functions
which invoke recursive ^R set up the return function.  At present
only Query Replace and Edit Tab Stops know about ^Z.  If you use or
know about other functions that call recursive ^R please let me know
so I can set them up to use ^Z also.

Query Replace and TECO Search now take their arguments from the echo
area rather than the minibuffer.

The Incremental Search function now recognizes M-S as equivalent to
^S and M-R as equivalent to ^R.

Enjoy!
	Jerry
-------
 6-Oct-78 09:30:35-PDT,497;000000000001
Date:  6 Oct 1978 0930-PDT
From: Agin
Subject: Changes
To:   EMACS/Datamedia Users:

There's a new SAIL major mode for editing SAIL programs.  Commands
are summarized in the newest edition of DATAMEDIA.CHART.  Very little
of it is implemented now, but it'll grow.

The Help function is improved.

Buffer creation is smarter: It takes its major mode from whatever
was in effect previously.  Auto-filling is local to buffers now, and
gets copied when a new buffer is created.
-------
25-Oct-78 09:23:23-PDT,2279;000000000001
Date: 25 Oct 1978 0923-PDT
From: Agin
Subject: Changes
To:   EMACS/Datamedia Users:

The implementation of the Quit function (^Z) has been changed to
avoid changing all the functions that call ^R recursively.  The way
it works now is that ^Z always leaves ^R mode--the smarts about
buffer saving, returning to SNDMSG or LISP, etc, are in what called
^R in the first place.
	^Z when you are at the top level (and not in SNDMSG or LISP)
will save whatever file you are editing and exit to the EXEC.
CONTINUE after ^Z will return you to the edit.
	To take advantage of this, you will need to change your
EMACS.INIT file.  Replace the cryptic last line of the file with the
following:
		MM Startup Datamedia
Alternatively, copy <AGIN>EMACS.INIT to your own directory.

More goodies in SAIL mode:
	Forward Statement and Forward Block now work.  They both
recognize comments (either the word COMMENT or a bare exclamation
point) and quotes.  M-F is now Forward Statement and C-M-F is Forward
Block--they used to be the other way around.
	Backward Block does NOT understand comments or quotes.
Someday I might get around to fixing it.
	Make BEGIN-END (M-V) creates a BEGIN END pair.  The
indentation level is determined by the position of the cursor at the
time you call it.  Make Labelled BEGIN-END (C-M-V) reads a block name
from the echo area and puts it in quotes after the BEGIN and the END.
With either function, a numeric argument will place a semicolon after
the END.
	Edit-tab has been modified so that a negative argument will
indent yay-many levels to the right of the preceding line's
indentation.  The number of spaces in one level is determined by the
variable Indentation Increment.  This variable may be set in your
INIT file--see <AGIN>EMACS.INIT, for example.  (Note that setting
Indentation Increment must occur AFTER the call to MM Datamedia.)
You can also change this variable using MM Alter Options.  Its
initial value is 1.

	The default search pattern for Character Search is now kept
separately from the default for incremental and string searches.

	Forward and Back DEFUN have been added to LISP Mode.

	TECO Mode has been modified to make M-F and M-B be Forward
and Back TECO Conditional.

	Enjoy!
-------
 9-Nov-78 14:01:52-PST,2083;000000000001
Date:  9 Nov 1978 1401-PST
From: Agin
Subject: New Goodies!
To:   EMACS/Datamedia Users:

A new EMACS was put up November 6.  It's winningest new feature is 
Keyboard Macros!!!  Your keystrokes can be remembered and played back
just like TVEDIT strings.  I've adapted them for Datamedia.
	To start a Keyboard macro definition, type M-/.  The word
"Defining" will appear in your mode line.  Everything you type will
be remembered, until you type another M-/ to end the definition.
	M-X / re-executes the last defined keyboard macro.
	Keyboard macros can be named and can also be assigned to
keystrokes.  Use MM Name Kbd Macro$.  You will be prompted for "^R
Command to define:"  Type a control character (or M-X character).
If you try to redefine certain characters, EMACS will complain.
	If you supply a text arg to MM Name Kbd Macro$ the keyboard
macro will be given a name.  If you name your macro FOO, then MM FOO
will run it now.
	MM View Kbd Macro will display the contents of any keyboard
macro.  It needs either a control-character to which a keyboard macro
has been assigned, or M-X /.

Autosave Filename is now defaulted to AUTOSAVE..1000nn, where nn is
your job number, on your login directory.  In this way, auto saving
needn't fill up your directory with multiple deleted files.  ^X ^S
will write to the "permanent" file name rather than the Auto Save
File, unless you give it an arg of 0.  ^Z saves your file and cleans
up (deletes) auto save files.

Goto Page (M-P) doesn't leave the mark behind any more.

Typing C-M-S in Incremental Search (C-M-S) will start a new search.
Either C-S or M-S will repeat the previous search.

You'll find Overwrite Mode (C-M-O) is much nicer to use now.

Other miscellaneous improvements have been reported in past BBOARD
messages from RMS@MIT-AI.  Use MSG to peruse <BBOARD>MAIL.TXT.

I'm thinking of putting Reverse Character Search on M-R, Reverse
Incremental Search on C-M-R, and moving Query Replace over to M-X R.
Does anybody have any reactions or preferences?

	Jerry Agin
-------
