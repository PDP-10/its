.fo 0 25vg
.fo 1 25vgb
.fo 2 25vgi
.fo 3 31vg
.so r/r.macros
.sr left_heading 2R Ideas*
.sr right_heading 2fdate*
.de sec  title {date}
.fi
.sp
.ne 5
3\0 \1*
.sp
.em
.de bug  date
.fi
.sp
.ne 5
3\0 BUG*
.sp
.em
.sec "Page Selection" 6/29/75
It might be desirable to have a command option, like TROFF, which
causes only designated pages to be output.
.sec "String Substitution" 6/29/75
It has been suggested that R implement some form of low-level
string substitution (without rescanning), so that one could write
<= and have it replaced by ^F1^Q^[^F*.
.sec "Indexes" 9/18/75
One possibility is to be able to specify a list of words to be
indexed when output (don't do unless printing turned on).
XOFF (CMU 10/72) has the following commands:
.table
	.index <word, page>
	.note <word, phrase>
	.print index
.end_table
These produce lines of the form
.table
	word (phrase)page1, page2(5i)
.end_table
In addition, there is 1collate in*, which specifies sorting,
and 1collate out*, which specifies when a blank line should
be left in the index (normally between entries whose first characters
differ).
.sec "Output Diversion" 10/1/75
A possible way to do output diversion is to have another device type,
STRING, and save the actual device output in a macro.  One problem
is to make sure that absolute vertical positions are changed to
relative.

Another possibility is to attempt to store the output in a form
which can be processed as input.  This has the advantage of being
readable, at least.  A new control character or mode would be
needed that would cause justification without filling.
.bug 10/3/75
It is possible to evoke a message, "escape character ('\t') not
allowed as text."  I believe this escape character should be
allowed as text, regardless of how it is obtained.
.sec "Footnote Problems" 10/26/75
See Greif, p. 91, for PUB footnote lossage.  What about footnote
reference in a figure which may be moved to the next page after
it is determined how much room it needs.
.sec "Macro Insertion" 11/1/75
It might be desirable to have some way of dynamically inserting
a macro body inside the definition of another macro.  How should
one be able to concatenate two macros into another macro definition?
