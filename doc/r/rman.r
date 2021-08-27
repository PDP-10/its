.dv xgp
.fo 0 25vg
.fo 1 25vgb
.fo 2 25vgi
.fo 3 40vg
.fo 4 75vbee
.fo 5 18fg
.fo 6 31as
.fo 7 31vg
.fo 8 25as
.fo 9 22fg
.fo F 2AS
.
.nr sec_map 4
.nr sec_rq 7
.nr req_dev 1
.nr req_fill 3
.nr req_vp 4
.nr req_env 9
.nr sec_cclist 8
.nr sec_delay 9
.nr sec_freeze 11
.nr sec_example 15
.
.ec x 
.ec h 
.
.tr @
.sr r_version 30
.sr edate fdate
.nr both_sides 1
.sr left_heading 2R Reference Manual*
.sr right_heading 2edate*
.sr list_left_margin 500m
.sr list_right_margin 500m
.sr figure_name Figure \
.sr footnote_starter   5\cfn*
.nr fnfont 5
.
.sr asterisk 1**
.sr newline 1newline*
.sr tab 1tab*
.sr quote 8'*
.sr dot dodot()
.sr pom +\h(-fheight/4m)-(+fheight/4m)
.
.de dodot
.hs 10m
.
.hs 10m
.em
.
.de nw
.if ll-rindent-hpos<\0
. bj
.en
.em
.
	lbox - A carefully handcrafted macro to make
	    a letter in a box.  It works only for 25vg
	    and 18fg.

.de lbox
. if ll-rindent-hpos<500
.  bj
. en
. if
.  nv font 0
.  nv S hpos
|\h(+15m)|(-15m)
.  hs (S-hpos+10)m
.  nr font 15
(-25m)_
.  hs (S-hpos+35)m
_(+25m)
.  hs (S-hpos+40)m
.  nr font 9
(+10m)\0(-10m)
.  hs (S-hpos+10)m
.  nr font 15
(+10m)_
.  hs (S-hpos+35)m
_(-10m)
.  hs (-20)m
.  nr font 0
|\h(+15m)|(-15m)
. en
.em
.
.de c
. if nargs>0
.  lbox \0
. ef
.  lbox  
. en
.em
.
.if lpt
.de c
. if
. nv font 0
. if nargs>0
^\0
. ef
.  nr font 1
space
. en
. en
.em
.en
.
.sr space c()
.sr cquote c(')
.
.
.if (?nice==0&lpt)|?m==0
.ex
.en
.if 4*m*m-3*m~=10660
.ex
.en
.tm R Reference Manual - edate - Version r_version
.so r.macros
.rs
.sp 2.5i
.nf c
.new_font 4
R
Reference
Manual
.new_font 0
.sp 3i
.new_font 3
Draft of edate
Corresponds to R Version r_version
.sp 1i
Copyright 6c* 1976, 1977, 1978 by Alan Snyder
.new_font 0
.nf l
.fi
.
	MACROS
.
.am table_of_contents
.new_font 7
.em
.
.
.de para
.sp
.ne 3l
.em
.
.nr sec_no 0
.
.de sec  title
.nr rqsecno 0
.in 0
.fi
.sp
.ne 6l
3\+sec_no.  \0*
.sp
.ns
.am table_of_contents
.nf
.sp .5
\sec_no. \0 . \page
\.em
.if ?user!terisk==0
.tr aeeiioouua
.end
.em
.
.
.de req_summary
.keep
.em
.
.
.de safetab
.lbegin
.nv pos 0
.hx pos \0
.hs 1
.if hpos>=pos
. br
.en
.nr hpos pos
.end
.em
.
.wf index
.we
.
.de req  name args break explanation
.lbegin
.nv breaks 0
.sv no no
.sv break \2
.sc breaks break no
.sv cchar quote
.if breaks
.sr cchar .
.en
.sp
.ne 2
.fi
.in reqindent
.ti -reqindent
\cchar!\0	\1safetab(reqindent)
.am req_summary
\cchar!\0	\1safetab(reqindent)\3  \page@
\.em
.wa index
.wl .index \0 \page
.we
.am table_of_contents
2\0*
\.em
.end
.em
.
.
.
.de reqtabs
.lbegin
.nv s
.hx s 1
.nv i indent/s
.ta i+3.7 i+16 i+16+4 i+16+24
.nr reqindent i+16
.end lbegin
.em
.
.
.de reqh
.sp
.reqtabs
.ne 6l
.
1Request Form	Explanation0
.br
.em
.
.de reqsumh
.sp
.reqtabs
.ne 6l
.
1Request Form	Explanation  Page0
.br
.em
.
.
.nr rqsecno 0
.
.de rqsec
.in 0
.sp
.ne 9l
3\sec_no.\+rqsecno  \0*
.sp
.ns
.am req_summary
.end_keep
.sp
.keep
3\rqsecno.  \0*
.sp
\.em
.am table_of_contents
.ne 2
.ta indent+600m
    \sec_no.\rqsecno	\0 . \page
.fi
	
\.em
.em
.
.
.de examples
.sp
.ne 8l
1Examples.*
.em
.
.de cc_des  name form desc
.ta 2 2+5 2+5+14
.in 2+5+14
.sp
.ne 3l
.ti -(2+5+14)
	\0	\1	
.am cc_summary
.ta 10+2 10+2+5 10+2+5+14
	\0	\1	\2  \page@
.br
\.em
.em
.
.
.de cc_header
.ta 2 2+5 2+5+14
.ne 6l
.br
1D	esig	Form	Explanation*
.br
.em
.
.de cc_sum_header
.ta 10+2 10+2+5 10+2+5+14
1D	esig	Form	Explanation  Page*
.br
.em
.
.nr rqsec 0
.
.
	END OF MACROS
.
.ev contents
.ls 1
.new_font 7
.ev
.
.begin_table_of_contents 2
.sec Introduction
.para
R is a text formatter which produces output for both typesetting devices
(such as the Xerox Graphics Printer) and normal printing devices.
It accepts input containing the text to be formatted,
plus requests and control characters that
indicate how the text is to be formatted.
.para
This document describes the input format and the R requests and
control characters, and presents a number of examples.  It is
not a tutorial; familiarity with the basic concepts of text
formatting is assumed.  R users should also examine the documentation
of any standard macro packages.
.
.foot
R macro files and documentation files are stored in the R directory
on ITS and in the /usr/r directory on Unix.
.efoot
.
.para
R can perform filling, adjusting, centering, indenting, underscoring,
overprinting, superscripting and subscripting.
R can handle
multiple variable-width fonts of different heights.
R supports adjustable tab stops and allows the space created by a tab
to be filled with a sequence of arbitrary text.
R supports text output to multiple files for later processing
by other programs.
.para
R provides the following extension facilities: macros, number
registers and string registers, integer arithmetic and logical
operations, traps, multiple environments, conditionals, iteration,
and local variables (dynamically bound, 2a la* LISP).
Macro packages have been developed that support header and footer
areas, page numbering, sectioning, section numbering, tables of
contents, numbered tables and figures, and footnotes (this
document was produced using such a macro package).
A tracing facility is available for debugging.
.para
The following features are not supported:  multiple columns on the XGP
device, automatic forward references, line numbering, automatic or manual
hyphenation.
.if 0
.para
Implementation notes: (1) superscripting and subscripting are
not implemented for the LPT device.
.end if
.sec Philosophy
The development of R has been motivated in large part
by a small number of good ideas and a larger number
of defects in previous text formatting programs.
Its design goals include:
.ilist 5
2flexibility* - Instead of inflexible,
built-in facilities for things like margins, headers
and footers, sectioning, tables, tables of contents,
and footnotes, R is intended to provide low-level
mechanisms that allow users to implement these
facilities as they desire.  It is intended that
standard macro packages be used to provide these facilities.
.next
2generality* - All ASCII characters should be
allowed in text (although escape sequences may be needed
in order to write some characters); no characters should
be reserved for internal implementation purposes.
Requests should be generalized wherever possible;
uniform mechanisms should be provided for specifying
various options (such as different units of measurement
and relative values) rather than complex, incomplete
sets of specialized requests.
.next
2device compatability* - The device-dependence of the
language should be minimized so that it is easy to write
programs that can be processed for all supported
output devices without change.
.next
2modularity* - It should be possible for a user to
redefine the characters used to represent the R control
characters in the input file without affecting the
operation of separately-written macro packages.
.end_list
.sec "The Logical Input Alphabet"
.para
In describing R, it is convenient to distinguish two
input alphabets, the logical input alphabet and the
physical input alphabet.
The logical input alphabet is an "internal" character set
in terms of which the semantics of R constructs
are defined.  The physical input alphabet is what the
actual input is written in.
Of primary importance to the user is the mapping from
the physical input alphabet to the logical input alphabet.
This mapping is described in Section sec_map.
Two input alphabets are needed because (1) R deals conceptually
with an alphabet (the logical input alphabet) that is larger
than most computer character sets and (2) the rules
mapping the physical input alphabet to the logical input
alphabet will in general be system-dependent.
.
.para
The logical input alphabet consists of text characters and
control characters.
There are 128 ASCII text characters.  Each text
character maps directly into corresponding output
characters (one character for each font).
Not all ASCII characters may be meaningful,
depending on the output device and the particular font
in use.
.
.para
The control characters each have
a corresponding ASCII designation character,
which is used to represent the character in this
document and in some R requests.
A control character is referred to as control-2X*
and written in this manual as \xc(X), where
X is the corresponding ASCII designation character.
The control characters are distinct from ASCII control characters,
which are text characters.  In this document, the
ASCII character control-X is written as ^X.
.
.para
There are 30 control characters, \xc(A) through \xc(Z), plus
\xc(.), cquote, \xc(\), and \xc() (control-space).
(A listing of the R control characters and their functions
appears in Section sec_cclist.)
The \xc(.) and cquote characters are used to begin
R requests.
The space character separates input text words and
causes some width of blank space to appear
in the output (except when at the end of an
output line in fill mode, see Section sec_rq.req_fill below).
The minimum width of blank space so produced
is determined by the 1principal font*
(see Section sec_rq.req_dev below);
this width may be increased by the process of 1justification*
(see Section sec_rq.req_fill below).
.
.para
The \xc(\) character has two functions.  When followed
immediately (in a file) by a letter, the \xc(\) and
the letter together represent an escape character.
There are 26 possible escape characters,
one for each letter of the alphabet.  Each escape character can
be defined to be equivalent to some logical input character,
using the EC request.  When an escape character is read, it is
treated exactly like the corresponding logical input character.
(Use of an undefined escape character is an error.)
.
.para
If a \xc(\) is not followed by a letter, then the \xc(\) serves to
delay the interpretation of an immediately following control
character (see Section sec_delay).
.
.para
The logical input character \xc(I) is also called tab;
the logical input character \xc(J) is also called newline.
Note, however, that the R control characters do not necessarily
correspond to the ASCII control characters.
.
.sec "The Input Mapping"
.para
The physical input alphabet consists of whatever character
code is used by the computer system.  The physical
input alphabet and its mapping to the logical input
alphabet are thus system-dependent.  However, this
section will describe a particular alphabet and mapping
for systems using the ASCII character set.
.para
In this mapping, most of the ASCII characters either
stand for themselves (the corresponding ASCII text logical
input characters) or they stand for particular control
characters (the exact mapping may be set by the user
using R requests).
The exceptions are the characters CR, NL, and FF.
The CR, NL, and FF
characters are either ignored or (perhaps in some
particular system-defined sequences) they represent
the \xc(J) character (newline), which
terminates logical input lines.
.para
Initially, the ASCII control characters ^A (control-A) through
^Z (control-Z) represent the corresponding R control
characters \xc(A) through \xc(Z).
The backslash character (\) represents \xc(\),
and ASCII SP (space) represents \xc().
The characters "." and "quote" (apostrophe), when the first
character of an input line, represent the \xc(.) and cquote logical input
characters, respectively.  When not the first character of an input
line, they represent the corresponding ASCII text characters.
All other ASCII characters (except CR, NL, and FF)
represent the corresponding ASCII text characters.
.
.para
The following escape characters are initially defined to represent ASCII text
characters:
.table 5
.ta 6 20
1	escape char	corresponding text char*
.sp
	1esc-*n	NL
	1esc-*r	CR
	1esc-*p	FF
.end_table
.rtabs
(This is the only way to write text NL, CR, or FF characters.)
The other escape characters have no initially-defined meaning.
.para
The mapping defined in this section is used for all examples
of R input in this document.
Thus, in examples of R input, ^S means
the ASCII ^S physical input character (which
normally maps to the \xc(S) logical input character).
.
.para
The mapping from the physical input alphabet to the logical
input alphabet takes place only upon reading from files.  Once
information enters R, it is stored as strings in the logical
input alphabet.
.sec "Input Modes"
.para
The physical to logical input mapping maps physical input characters
into either the corresponding text characters or to control
characters.
The mapping operates in a number of modes,
depending upon context.  In each mode, some control characters
are recognized and some are not.  If a control character is
not recognized, then a physical input character that would
normally map to that control character instead maps to
the corresponding text character.
For example, if the ASCII ^S physical input character
normally maps to \xc(S) but \xc(S) is not recognized, then
^S maps to the ^S ASCII text character.
.para
The input modes are numbered, from 0
to 2.  The modes are totally ordered, with
mode 0 performing the smallest subset of the mapping and
mode 2 being the full mapping.  Each mode contains all of
the transformations contained in the lower-numbered modes.
.para
The modes are described in the Table :current_table,
along with an enumeration of their uses.  The description of uses
refers to R requests and control characters; these are
described in later sections.
.
.
.begin_table "Input Modes"
.ne 10
.ilist 5
1mode	description*
.next
  0.	In mode 0, the only mapping is from the CR, NL, and
FF characters into either \xc(J) (newline) or nothing.  The exact mapping
is system-dependent.  This mode is used to read the character
following the \xc(Q) character and for skipping comments
and extra characters on request lines.
.next
  1.	In mode 1, mode 0 mapping is performed.  In addition,
the \xc(A), \xc(I), \xc(K), \xc(N), \xc(Q), \xc(S),
\xc(\), and space characters are
recognized.
This mode is used for reading request names, for reading the first
argument to the EC request, and for reading the arguments of
all R requests not mentioned elsewhere in this table.
.next
  2.	In mode 2, mode 1 mapping is performed.  In addition, all
other R control characters are recognized.
This mode is used for
reading text lines, macro definitions, arguments to the SR and XC
requests, arguments to macro invocations, and the second argument
to the EC request, and for skipping the bodies of IF, WHILE,
and FOR statements.
.br
.ns
.end_list
.finish_table
.
.
Note that the \xc(.) and cquote characters are recognized only as the
first character of an input line.
If one wishes to use \xc(A), \xc(S), or \xc(N) to compute a request
argument that is normally read in a mode in which \xc(A), \xc(S),
and \xc(N) are not recognized, one can use the XC (execute)
request, which reads all arguments in mode 2.
Note also that macro bodies are always read in mode 2, regardless
of whether or not the macro bodies contain requests whose arguments
are normally read in some other mode.
.
.sec "Input Format"
.para
The input to R consists of lines of text interspersed with R requests.
An R request is an input line that begins with a period (actually,
the \xc(.) character).
A request consists of a request name optionally followed
by some number of arguments.  The request name may be indented by
inserting space!s or \xc(I)s between the \xc(.) and the
request name.  The request name and the arguments all must be separated
by at least one space or \xc(I).  Any extra arguments to a request
are ignored.  A request may also be written using cquote instead of \xc(.)@;
using this form inhibits the line-break normally caused by
certain R requests.
(Line-breaks are described in Section sec_rq.req_fill.)
A request line containing no request name is ignored.  A request
line naming an undefined request produces an error message.

One may write comments on request lines or text lines using the
\xc(K) character.  This character causes all following input,
up to the next newline, to be ignored.  If the \xc(K) appears as the
first character on a line, then the entire line (including the
terminating newline) is ignored.
.
.sec "Request Descriptions"
.am table_of_contents
.sp .5
.fs 1
.ir +300m
.em
.para
The following sections describe the R requests.  The description of a
request starts with a line containing the form of the request.
Requests that normally cause line-breaks are
shown prefixed by "."; requests that do not cause line-breaks are
shown prefixed by "quote".  Many request descriptions refer to R control
characters; these are described in Section sec_cclist.
.para
The notations used in the description of request arguments are
described in Table :current_table.
.
.
.de arg_notations
.table
.nf
1Argument description syntax: {2name*:}{0pom*}
2type*{(2default*)}*

2Name* - a name used to refer to an argument in descriptions of the request
2Type* - a description of allowed values of an argument
2Default* - the value used if no argument is given

.fi
The notation pom means that the argument may optionally be preceded by a + or a -,
meaning increment or decrement the old value.

A default value of 2prev* means that the previous value of the
relevant parameter is restored.

.nf
The possible types are:

	M	a name (alphanumeric string, case not distinguished, mode 1)
	C	a single text character (mode 1)
	F	a font designator character (mode 1)
	L	a single logical input character (mode 2, one \ removed)
	S	a string terminated by \xc(J) (mode 2)
	T	a string of text characters terminated by \xc(J) (mode 1)
	N	a decimal expression, integer value used (mode 1)
	R	a decimal expression, fractional part allowed (mode 1)
	V	a vertical distance specification having the forms:
			R	R times the height of principal font
			Rl	R times the line separation distance
			Ri	R inches
			Rm	R mils (1/1000 inches)
			Rc	R centimeters
	H	a horizontal distance specification having the forms:
			R	R times the character width of principal font
			Ri	R inches
			Rm	R mils (1/1000 inches)
			Rc	R centimeters
.end_table
.em
.
.
.begin_table "Request Argument Notations"
.lbegin
.nv s
.hx s 1
.nv i indent/s
.ta i+5 i+10 i+13 i+18
.end lbegin
.table 14
.arg_notations
.br
.ns
.end_table
.rtabs
.finish_table
.
.
An argument specified by T may contain the characters
space and \xc(I); they are converted to the
ASCII SP and HT characters, respectively.
.
.para
An 1expression* (forms N, R, V, and H)
may be a simple integer or fixed-point number, a
name, or an expression containing arithmetic and logical operators.
These operators are listed in Table :current_table.
A name used in an expression may not begin with a digit.
When a valid name is encountered during expression evaluation,
it is treated as if it were preceded by a \xc(N), i.e., it
is used as the name of a number register.  Expression evaluation
is performed in floating-point.  The result of an expression is
converted to an integer by rounding to the nearest integer value;
a number 2n*.5 rounds to 2n*.
.
.
.begin_table "Arithmetic and Logical Operators"
.
.
.table 16
.ta 5 20
	+	addition
	-	subtraction
	*	multiplication
	/	division (result is rounded)
	^	integer division (result is truncated toward 0)
	%	mod
	&	logical and
	|	logical or
	==	equal
	~=	not equal
	<	less than
	<=	less than or equal
	>	greater than
	>=	greater than or equal
	+	prefix +
	-	prefix -
	~	prefix logical not
.br
.ns
.end_table
.rtabs
.finish_table
.
.
The logical operators interpret zero as FALSE and non-zero
as TRUE; they return 1 for TRUE.
The usual operator precedence is recognized; in addition,
parentheses may be used to explicity specify the
disambiguation.
.
.para
The suffixes used for vertical and horizontal distance specifications
(forms V and H) may only follow a complete request argument
and may not be attached to individual components of an argument.
The suffixes apply to the entire preceding expression.
Where "mixed mode" calculations are desired, the VX, HX, VV, and HV requests
should be used.  The suffixes are recognized in both upper and
lower case.
.
.para
The notation "prev" used to describe the default value of
a request argument means that if no argument is given, the
previous value of the relevant parameter is used.
Only one "previous value" of a parameter is remembered; it is changed
only when an explicit argument is provided.
.
.rqsec "Output Device Specifications"
.para
The available output devices are line printers
(called LPT, also includes "standard" printing terminals),
Varian Statos printer/plotters (called VARIAN), and the
M.I.T. Xerox Graphics Printer (called XGP).
.foot
The VARIAN device is implemented only on Unix.
The XGP device is not implemented on Unix.
.efoot
The output device may be set either by a command option
or by the DV request.  If not specified, the default
is LPT.
.para
The XGP and VARIAN devices understand up to 16 fonts, which are
designated by the
numbers 0 through 9 and capital letters A through F.  Initially, font
0 is defined to be a standard font;
.foot
This font is currently 25vg.
.efoot
other fonts are initially undefined.  A font must be defined (using
the FO request) before it can be used.
.
.para
When the output device is LPT,
the treatment of characters in a particular font is determined by
the corresponding font mode, which is one of:
.table 4
	n - output normally
	u - underscore
	o - overprint
	c - capitalize
.end_table
Font modes are specified in the FO requests; the default font mode
is Normal for font 0 and Underscore for all other fonts.
.para
The 1principal font* is used to determine the units of horizontal
and vertical measurement when expressed in terms of characters and
lines.  It is also used to determine the vertical spacing of output
lines and the increments of vertical offset for superscripts and
subscripts.
.para
The unit of horizontal measurement is called the 2character width*
of the font.  It is computed as follows:
.table 1
	charwidth = max (width (" "), min (2*width(" "), width ("0")))
.end_table
The character width is (potentially) distinct from the 2space
width*, which is the width of the space character.  The space
width determines the width of blank space produced by the \xc()
character.
.
.para
The 1current font* is used in mapping the 128 ASCII
logical input characters (when occurring in text) into
output characters.  A logical input character
2X* is mapped into the output character
<2F*, 2X*>, where 2F* is the current font
at the time the mapping is performed.
.
.reqh
.
.req dv M(LPT) no "Declare output device to be M."
(Device)
The output device is declared to be that given by the specified name.
The name must be either LPT, VARIAN, or XGP (case not
important).  The DV request, if present, must be
given at the beginning of the input (see Section sec_freeze
for a precise statement of this restriction).
More than one DV request may be given, in which case the
last one is used.
.
.req fo "F T" no "Specify font designated by F to be T."
(Font Definition)
The FO request defines the font designated by F to be that specified
by T.
.foot
In the ITS implementation, T must be a file specification that names
a KST-format font definition file.  The default extension is KST;
the default device is DSK.  If no directory is specified, the
current directory is searched, followed by FONTS and FONTS1.  Because
of a limitation of the XGP spooler, the font file must also
exist in the corresponding location on the AI machine.
In the Unix implementation, T must specify a font name corresponding
to a font definition in /sys/fonts.
.efoot
The font specification T may optionally be followed by a font mode
(described above) in parentheses.
The FO request may appear only at the beginning of the input
(see Section sec_freeze for a precise statement of this restriction).
More than one FO request for a given font designator F may be given,
in which case the last one is used.
Fonts may be selected using the \xc(F) character or the FS request.
Initially, the current font is font 0.
.
.examples
The following is one possible way to begin an R file:
.table
	.dv xgp 	^K make XGP the default device
	.fo 0 30vr	^K define the normal font
	.fo 1 31vgb	^K define the bold font
	.fo 2 30vri	^K define the italic font
	.fo 3 37vrb (c)	^K define the big font (capitalize on LPT)
	.fo 4 75vbee (c)	^K define the huge font (capitalize on LPT)
.end_table
.
.
.req fs F(*) no "Select font F as current and principal font."
(Font Select)
The FS request sets the current font and the principal font
to be that designated by F.
The current font and principal font are initially font 0.
(See also \xc(F) and the FONT and PFONT built-in number registers.)
.para
The FS request and \xc(F), when used with an explicit argument,
first push the old value of the current font on a per-environment
stack.  When FS is used with no argument (or \xc(F)* is used), the
most recent font is removed from the stack and used (implicitly)
as the argument.
The size of the font stack is fixed.  When the stack becomes full,
the oldest value is discarded.  Use of the FONT or PFONT number
registers does not affect the font stack.
.para
The font stack can be used to perform local font changes without
affecting surrounding text.  However, to work properly, all font
changes (using the FS request or \xc(F)) must be properly nested,
with each explicit font change (e.g. \xc(F)1) having a matching implicit
font restoration (e.g. \xc(F)*).
.rqsec "Page Control"
.para
The length of the output page is set by the PL request.
Top and bottom margins are not automatically provided;
they must be explicitly specified by setting traps
at the top of the page and at the bottom margin.
In the absence of such action, R will use the entire
page length for output.  Each output page has a page
number.  The page number is not automatically printed,
but is available for printing in a manner specified
by the user.  Section sec_example presents
a set of macros that define top and bottom margins
and print headings on each page.
These functions are also conventionally performed by
standard macro packages.
.
.para
The EO and OO requests allow the user to shift the entire output
horizontally on the page, without affecting any internal horizontal
position calculations, such as tab stops or indentation.
These requests are used
to set the width of the left margin.
.
.reqh
.
.req pl pom!V(11i) no "Set page length to V."
(Page Length)
The page length is set to the specified vertical distance.  When it
is attempted to make the current vertical position greater than the
page length, a new page is automatically started.
Where possible, the PL request will also change the
actual physical page size.
.foot
To change the page length for the XGP device, the PL request must be given
before any text is output.  The LPT and VARIAN devices do not support
variable page lengths.
.efoot
Thus, this request should not be used to define a bottom
margin.
The page length is initially 11 inches.
(See also the PL built-in number register.)
.
.req bp pom!N(old+1) yes "Begin page (number N)."
(Begin Page)
A new page is started.  If an argument is given, it
specifies the number of the new page.
If no argument is given and no PN requests have been made during the
processing of the current page, the new page will be numbered one
greater than the current page.
.
.req pn pom!N no "Set number for next page to N."
(Page Number)
The next output page (when it occurs) will have the page number N,
unless this request is superseded by another PN request or the new page
is caused by a BP request that explicitly specifies a page number.
The first page is initally numbered page 1.
(See also the PAGE and NEXT_PAGE built-in number registers.)
.
.req eo pom!H(prev) no "Set even page offset to H."
(Even Offset)
The entire output image on even-numbered pages is moved right
the specified horizontal distance.
The initial even page offset is 1 inch, giving a 1 inch
left margin.
.
.req oo pom!H(prev) no "Set odd page offset to H."
(Odd Offset)
The entire output image on odd-numbered pages is moved right
the specified horizontal distance.
The initial odd page offset is 1 inch, giving a 1 inch
left margin.
.
.req ne V(1) yes "Need vertical space of height V."
(Need)
If the vertical distance D to the next trap position (or to the end
of the page) is less than the specified vertical distance,
then the current vertical position will be increased by
the distance D.  This request is used when one wishes to
ensure that a new section, table, etc. does not begin
too close to the bottom of the page.
.rqsec "Text Filling and Adjusting"
.para
R operates in one of two filling modes, fill mode and nofill mode.
In fill mode, words are taken from as many input lines as needed
in order to fill out the current output line.  In nofill mode,
the end of an input text line causes the current output line
to be output and a new output line to be started (this is called
a line-break).  Line-breaks are also caused by blank input lines,
by input lines beginning with space, \xc(C), \xc(I), \xc(P),
or \xc(R), and by many built-in requests.
.para
Output lines may be adjusted by the enlargement of space!s
between words or the insertion of extra space before
the entire line.  The various modes of adjustment are:
(L) left-adjustment, meaning that no extra space is inserted
and the right margin remains ragged,
(R) right-adjustment, meaning that extra space is inserted
at the beginning of the lines so that the right margin is
uniform but the left margin is ragged,
(B) both margins adjusted, meaning that space!s are enlarged
between words so that both the left and right
margins are uniform, and
(C) centered, meaning that extra space is inserted at the
beginning of the line so that the output text is centered on
the line.
Adjustment is specified separately for fill mode and for
nofill mode.
.para
B-mode adjustment is inhibited to the left of a \xc(I) or a \xc(P).
B-mode and C-mode adjustment are superceded by any adjustment
caused by a \xc(C) or a \xc(R).
.
.reqh
.
.req br "" yes "Cause line break."
(Break)
This request causes a line-break.
The output line being constructed is output and a new output line
started.  If in fill mode and the adjustment mode is Normal, then the
output line is not adjusted.
.
.req bj "" yes "Cause line break, with justification."
(Break and Justify)
This request causes a line-break.
The output line being constructed is output and a new output
line started.  Unlike BR, if in fill mode and the adjustment mode is
Normal, then the output line 2is* adjusted.
This request can 2not* be inhibited by using cquote.
.
.req fi C(unchanged) yes "Fill output lines; set adjust mode."
(Fill)
Fill mode is entered.  Subsequent output lines will be filled.
If the argument C is given, the adjustment mode to be used
when in fill mode is set to C (the adjustment modes are listed
above); otherwise, the fill-mode adjustment mode is not
changed.  Initially, R is in fill mode with adjustment mode B.
(See also the FILL and ADJUST built-in number registers.)
.
.req nf C(unchanged) yes "Do not fill output lines; set adjust mode."
(Nofill)
Nofill mode is entered.  Subsequent output lines will not be
filled; each input line will cause exactly one output line.
If the argument C is given, the adjustment mode to be used
when in nofill mode is set to C (the adjustment modes are listed
above); otherwise, the nofill-mode adjustment mode is not
changed.  The initial nofill-mode adjustment mode is L.
(See also the FILL and ADJUST built-in number registers.)
.rqsec "Line Spacing and Blank Lines"
.para
Line spacing determines the default vertical separation
between output lines.  Line spacing is measured in terms of
the height of the principal font.  A line spacing of 1 corresponds
to single spacing, 2 corresponds to double spacing, etc.
Non-integer line spacings (e.g. 1.5) are allowed, although the desired
results will not be obtained when the output device is LPT.
.para
The 1current vertical position* (VPOS) measures the distance
from the top of the page to the 1base line* of the next
text line to be output.
The 1last vertical position used* (LVPU) records the position of the
bottom of the last text line output.  It is used to avoid overlap
between the bottom of one line and the top of the next.
This processing takes place even when output printing is turned
off.  If the current vertical position is ever 2decreased*, then
LVPU is set to 0, so that only overlapping the top
of the page is checked.
.foot
The XGP device does not allow a text line to be output unless
it is below and does not overlap all lines already output on the
same page.  Separate checking is used to prevent this occurrence.
If overlapping lines are produced for the LPT device, a separate
postprocessor must be used.
.efoot
Both VPOS and LVPU are accessible as built-in number registers.
.
.reqh
.
.req ls pom!R(prev) no "Set inter-line spacing to R"
(Line Spacing)
Line spacing is set to R.  After a line is output, the
current vertical position will be increased by R times
the single-space height of the principal font.
The initial line spacing is single spacing (.LS 1).
(See also the LS built-in number register.)
.
.req sp V(1) yes "Space down distance V."
(Space)
The current vertical position is increased by V.
A blank input line is equivalent to a line containing a .SP 1
request (e.g., it is inhibited in no-space mode, described
below).
.
.req vp V(0) yes "Set vertical position to V."
(Vertical Position)
The current vertical position is set to V (V may be
less than or greater than the current vertical postion).
(See also the VPOS and LVPU built-in number registers.)
.
.req ns C(S) no "Enter no-space mode."
(No Spacing)
No-space mode is set according to the mode C.
The possible modes are S and P.
If no-space mode is S, SP requests are inhibited.
If no-space mode is P, SP requests
are inhibited and BP requests that do not specify a
page number are inhibited.
If the no-space mode is P, then an NS request will not reduce it to S.
No-space mode is turned off when a line of
text is output.
No-space mode is initially off.
(See also the SPACING built-in number register.)
.
.req rs "" yes "Resume spacing."
(Resume Spacing)
No-space mode is turned off.
.rqsec "Line Length, Indenting, and Horizontal Positioning"
.para
Requests are provided to set the line length and to cause
indenting of both the left and right margins.  The line
length includes any indenting but does not include the
page offsets.  When in fill mode, no output line containing
more than one word will exceed the line length (including
indenting).  Horizontal positioning may be performed using
the characters \xc(I) and \xc(P) and by the HS and
HP requests,
which allow arbitrary horizontal positioning.  The tab
stops used by \xc(I) are adjustable.
.para
Changes made to the line length or the indentation take effect
at the next output line.  They do not affect
a non-empty current partial line.
.
.reqh
.
.req ll pom!H(prev) no "Set line length to H."
(Line Length)
The line length is set to the specified horizontal distance.
This request is used to set the width of the right margin.
The initial line length is 6.5 inches, giving a right margin
of 1 inch for a page width of 8.5 inches and a page
offset of 1 inch.
(See also the LL built-in number register.)
.
.req in pom!H(prev) yes "Set indentation to H."
(Indent)
The left-margin indent is set to the specified horizontal
distance.  Each output line is begun with blank space
of the specified width (in addition to any implied by the page
offset).  The left-margin indent is initially 0.
(See also the INDENT built-in number register.)
.
.req ti pom!H(1) yes "Temporarily indent next output line by H."
(Temporary Indent)
The next output line (only) will be left-indented the specified
distance (pom relative to the current left-margin indent).
The normal left-margin indent is not changed.
.
.req ir pom!H(prev) yes "Set right-side indentation to H."
(Indent Right)
The right-margin indent is set to the specified horizontal distance.
The indentation is leftwards from the position specified by the
line length.  In fill mode, the
right margin (position) is the line length minus the right-margin
indent.  The right-margin indent is initially 0.
(See also the RINDENT built-in number register.)
.
.req ta "H H ..." no "Set tab stops."
(Tabs)
All existing tab stops are removed.  Then,
tab stops are set at the specified horizontal positions.
Note that tab stops are at absolute horizontal positions, not
at column numbers; to keep tab stops at column numbers one must reset
the tab stops whenever the principal font changes.  Note also that
the positions of tab stops on the output page are not affected
by changes in the indentation (set by the IN request).
The tab stops are initially set at column positions 8, 16, etc.,
with respect to font 0.
.
.req hs H(0) no "Output horizontal space of width H."
(Horizontal Space)
Produce a non-justifiable space of the specified width.
The width 2may* be negative, but may not cause the
current horizontal position to become negative.
.
.req hp pom!H(0) no "Set horizontal position to H."
(Horizontal Position)
The current horizontal position is set to H.  This new horizontal
position may be less than or greater than the old position.
(See also the HPOS built-in number register.)  Warning: use of
the HP request or the HPOS built-in number register is generally
meaningless in the presence of filling or adjusting (other than
L-mode adjusting), since in these cases
the actual horizontal position of a word
on output is not known until the entire output line is determined.
It is recommended that the HS request be used wherever a
change in horizontal position is a intended to
be a relative change, rather than a change to a specific
absolute position.
.
.rqsec "Registers"
.para
It is possible to save both integer and string values in
registers and to insert said values into the input stream
using the characters \xc(N) and \xc(S) (q.v.).
.
.reqh
.
.req nr "M N(0)" no "Define number register M to be N."
(Number Register)
A number register is defined or redefined to have the
specified value.  Its value may be inserted into the
input stream using the \xc(N) character.
Its value may also be referenced in expressions by
writing the number register name (unless the name
begins with a digit).
.
.req sr "M S(null)" no "Define string register M to be S."
(String Register)
A string register is defined or redefined to have the
specified value.  Its value may be inserted into the
input stream using the \xc(S) character.
Note that because space!s and \xc(I)s separate
arguments, to begin the string argument with a space
or \xc(I) one must precede it with \xc(\).
.
.req nd "M N(0)" no "Set default value of number register M to be N."
(Number Default)
If the named number register is undefined, then its value is set
to the given value.  Otherwise, there is no effect.
.
.req sd "M S(null)" no "Set default value of string register M to be S."
(String Default)
If the named string register is undefined, then its value is set
to the given value.  Otherwise, there is no effect.
.
.req hx "M H..." no "Horizontal distance expression."
(Horizontal Expression)
The number register specified by M is defined
or redefined to have a value that is the sum of the
given horizontal distance specifications in mils.
.
.req vx "M V..." - V=0 no "Vertical distance expression."
(Vertical Expression)
The number register specified by M is defined
or redefined to have a value that is the sum of the
given vertical distance specifications in mils.
.
.req xn M no "Expunge number register M."
(Expunge Number Register)
The number register specified by M is made undefined.
This request may specify a built-in number register, in which
case the register ceases to be treated specially.
.
.req xs M no "Expunge string register M."
(Expunge String Register)
The string register specified by M is made undefined.
This request may specify a built-in string register, in which
case the register ceases to be treated specially.
.
.rqsec "String Operations"
.
.para
Requests are provided to operate upon the contents of string registers.
These requests take their string operands in string registers and
produce results in number registers or string registers.  The arguments
to the requests are names of string registers and number registers,
plus integers.
.
.para
The first character in a string is numbered 1.  Note that
string registers contain logical input characters, not just
ASCII characters.  For example, a string can contain space!s,
which are not the same as ASCII SP characters.  This distinction
affects primarily the collating sequence used by the comparison
operator.
.
.reqh
.
.req sb "result:M source:M index:N(1) length:N(infinity)" no "Compute substring."
(Substring)
Argument 2result* is the name of a string register in which to
store the result of this operation.  Argument 2source* is the
name of the source string register.
The SB request computes the substring of the contents of the source
string register and puts it in the result string
register.  The substring begins with the character specified
by 2index* and contains the number of characters specified by
2length*.  There is no error if 2length* is longer than the
number of characters available.  If 2length* is less than 1 or
2index* is out of range, then the result is the null string.
.
.req si "result:M pattern:M source:M skip:N(0)" no "Search for occurrence of string."
(String Index)
Argument 2result* is the name of a number register in which to store
the result of this operation.  Argument 2pattern* is the name of
a string register supplying a pattern.  Argument 2source* is the
name of a string register supplying the source string.
The SI request computes the index of an occurrence of the
contents of the pattern in the source.
The index is made the value of the result number register.
If 2skip* is not present or is not positive, then the index
of the first occurrence is computed.  If 2skip* is positive, then
2skip* occurrences are first skipped.  If there is no such
occurrence, then the value computed is 0.
.
.req sc "result:M sr1:M sr2:M" no "Compare strings."
(String Compare)
Argument 2result* is the name of the result number register.
Arguments 2sr1* and 2sr2* are the names of the string registers containing
the strings to be compared.
The SC request computes an integer value of -1, 0, or
1 by comparing the contents of the two strings.
The value is stored in the result number register.
The value is 0 if the two strings are equal,
-1 if the first is less than the second, 1 otherwise.
The comparison is lexicographic, but note that the characters
are logical input characters, not just ASCII text characters.
Control characters (such as space) are "greater than" all text
characters.
.
.req sl "result:M source:M" no "Compute the length of a string."
(String Length)
Argument 2result* is the name of the result number register.
Argument 2source* is the name of the string register containing the
source string.
The SL request computes the length of the source string
and stores it in the result number register.
The length is the number of logical
input characters in the string.  Note that
nw(1000)\xc(\)\xc(\)\xc(\)\xc(A) is 2one*
logical input character, a "thrice-protected control-A".
.
.
.rqsec "Macros"
.para
A macro is a named set of lines that may be inserted into
the input stream by a request giving that name (normal macro
invocation), by a control character sequence giving that name
(inline macro invocation), or by an attempt to increase the
current vertical position past a specific point (trap invocation, q.v.).
A macro named "foo" may be invoked by a request giving
"foo" as the request name.  Arguments to the macro may
be given on the request line; these arguments may be referenced
by the macro body using the \xc(A) character (q.v.).
The arguments on a request line are separated by space!s and \xc(I)s.
An argument that includes space!s or \xc(I)s may be enclosed
in quotation marks ("); alternatively the space!s or \xc(I)s can be
protected by the \xc(\) character.  Within a quoted argument,
one can write "" to mean ".
Examples of macro definitions are presented in Section sec_example.
.para
The invocation of a macro causes the current input to be suspended
(its current state is saved on a stack) and input to be taken from
the body of the macro (established by DE and/or AM requests).
When the end of the macro body is reached, the input stream is
reset to what it was when the macro invocation occurred, and processing
continues.  If a macro is invoked when in fill mode, some input text may
have been read and collected, but not yet output because not enough
had been collected to fill an output line.  This partially-collected
line will be output in that form if the macro invocation causes a
line-break in that environment (see Section sec_rq.req_env below).
Macro invocation 2per se* does not cause a line-break; however, the
body of the macro may cause a line-break if it contains a request
or text line that causes a line-break.
.para
A macro may be invoked using either \xc(.) or cquote.  The macro
definition 2may* distinquish between these two cases (using
the \xc(A)dot notation).  Otherwise, there is no difference between
using \xc(.) and cquote to invoke a macro.  In particular, using
cquote does 2not* automatically prevent a macro from
causing a line-break.
.para
Macros may be invoked in text lines using the \xc(X) character
(q.v.).  Examples of inline macro invocation are presented in
Section sec_example.
.para
The input file is implicity followed by an invocation of a macro
named 2exit_macro*.  This macro is intended to be used by
macro packages for performing "clean-up" operations.  It may be
defined in the normal manner; there is no error if it is not defined.
.
.reqh
.
.req de "macro:M terminator:M" no "Define or redefine macro."
(Define)
The DE request defines or redefines the macro with name 2macro*.
2Terminator* is an optional name which is used to terminate the macro
body; the default value for 2terminator* is EM.
The contents of the macro begins with the next input line.
It is terminated by a request line whose request name is
the terminator 2terminator*.
After the macro body is read, the terminating request
line is executed normally (the terminating line does not become part
of the macro definition).
The macro
text is processed for the recognition of R control characters;
unprotected \xc(A), \xc(K), \xc(N), and \xc(S) characters are interpreted (see Section
sec_cclist).
Requests in the macro text are not
processed.  No output is produced by the definition of a macro.
A macro definition may contain other macro definitions.
If interior macro definitions use the same terminator as the enclosing
macro definition, then those interior terminator lines must
be preceded by \xc(\) so that they do not inadvertently
terminate the enclosing macro definition.
.
.req rm M no "Remove definition of macro M."
(Remove Macro)
The specified macro name becomes undefined; an invocation of
said macro will produce an error message.
.
.req am "macro:M terminator:M" no "Append to macro definition."
(Append to Macro)
This request is equivalent to the DE request, except that the following
text is 2appended* to the body of the specified macro.  If there
is no macro M (or M is a request), then the AM request
request is exactly equivalent to the DE request.
.
.req eq "new:M old:M" no "Make request NEW equivalent to request OLD."
(Equate)
The name given as 2new* is defined to have the current
definition of 2old* (either a built-in request, a macro
definition, or undefined).  The meaning of 2new* will not
be affected by subsequent redefinitions of 2old*, except
by the AM request.  The EQ request can be used to define
synonyms for requests or macros, or to "save" the definition
of a built-in request so that the initial request name can be
redefined without losing the built-in request definition.
.examples
Suppose that for debugging purposes, one wanted to print
a message each time the DE request is used.  The following
code achieves that purpose:
.table
	.eq old_de de	^K "save" original definition
	.de de	^K make new definition
	.tm Defining macro \^A0	^K type the message
	.old_de \^A0 \^A1	 now use the original definition
	.em
.end_table
The original definition of DE is first given an additional
name, OLD_DE.  We do this because we need to use the original
definition of DE within the definition of the new DE.
The new DE (a macro) first
types out a message, then invokes the orignal DE (now
called OLD_DE).
.
.req em "" no "Terminate a macro body."
(End Macro)
This request is used by default to terminate macro definitions.
When invoked, it has no effect.
.
.rqsec "Environments"
.para
Text processing is performed in one of a number of environments.
Each environment contains the following parameters:
.table 3
.ta .5i 2.56i 4.82i
	principal font	fill mode	indenting
	current font	adjust modes	tab stops
	font stack	vertical offset	underscoring
	line spacing
.end_table
.rtabs
In addition, the environment contains the partially-filled
output line being constructed.  All other information is
global, that is, exists in common for all environments.
.para
Each environment has a name.  Initially, there is one
environment, called "text."  Other environments may
be defined by the user.
Macros that are to be invoked by traps should
in general perform their processing in an environment
other than "text" since when a trap is invoked, the
then current environment often contains a partially-collected
output line that should not be printed at that time.
.
.reqh
.
.req ev M(prev) no "Select environment M as current environment."
(Environment)
The current environment becomes that specified by the given name.  If no
such environment exists, a new one is created.  All environments are
initialized identically as specified in the descriptions of the related
requests.  The initial environment is named "text".
If no argument is specified and the previous environment has been
expunged, then the current environment is unchanged.
This request is used to switch among multiple environments.
(See also the ENV built-in string register.)
.
.req es M no "Save current environment in environment M."
(Environment Save)
The current environment is copied into the named environment (including
the partial line).
A new environment is created if no such environment exists.
The current environment is not changed.
This request is generally used to initialize the parameters of
a new, often temporary environment to the values
from some other environment.
.
.req xe M(current) no "Expunge environment M."
(Expunge Environment)
This request deletes the named environment.  If the specified environment
is the current environment, or no argument is given, then the current
environment is marked as "to be deleted".  The environment will be
deleted the next time that a 2different* environment is selected
as the current environment.  This request is provided to allow the
storage associated with temporary environments to be reclaimed.
.
.rqsec "Blocks, Conditionals, Iteration, and Local Variables"
R provides four forms of control structures: BEGIN blocks,
IF statements, WHILE
statements, and FOR statements.  Each consists of a request (either
BE, IF, WH, or FR) followed by a body of input lines called the
statement body; a statement body consists of the lines following the
BE, IF, WH, or FR request, terminated by the next matching EN request.
BE, IF, WHILE, and FOR statements must be properly nested.
IF, WHILE, and FOR statements must be completely
enclosed in a macro definition or an input file; WHILE and FOR
statements may occur only in macro definitions.  The BK (break)
request may be used to break out of (terminate) the innermost WHILE
or FOR statement; the BK request must appear in the same macro
definition as the corresponding WHILE or FOR statement.
.para
An IF statement may be broken into a number of separate 2cases*
using the EF request.  Associated with each case is a conditional
expression; the conditional expression is written
as an argument to the IF or EF request
that heads the case.  (If no argument is present, the default is
1.)  When an IF statement is executed, the conditional expressions
are evaluated in turn until one evaluates to non-zero.  The
corresponding case is then executed, and the remainder of the IF
statement is skipped.  An EF request with an argument thus performs
as ELSE-IF; an EF request without an argument performs as ELSE.
Only one EN request is needed to terminate an IF statement,
regardless of the number of cases.
.para
Within BE, IF, WHILE, or FOR statements, one may define local
variables using the NV, SV, HV, and VV requests.  These requests are
like NR, SR, HX, and VX, except that they first save the old value
of the register (if any) on a stack; old values are restored
when the end of the innermost enclosing statement body is
reached, in reverse order of variable definition.  (If there
was no value, then the register is made undefined again.)
The NV, SV, HV and VV requests are like declarations with initial values;
subsequent assignments to variables should be made using the
NR, SR, HX, and VX requests.
.
.para
Note that embedded macro definiitons are not
recognized when searching for a matching
EN request.  In general, one should
avoid using macro definitions within statements.
.
.reqh
.
.req be M no "Begin statement block named M."
(Begin)
This request marks the beginning of a BEGIN block.  The name
(which is required) is used to name the block in case it
is not properly terminated.  All statements define new scopes
for variables; begin blocks do nothing else.  Begin blocks are
the only statements that do not have to be properly contained
in files or macro definitions.
.
.req if N(1) no "Conditionally execute statement body."
(If)
If the argument is 0, input is ignored until the next matching EF or
EN request is encountered; \xc(A), \xc(S), and \xc(N) characters in the skipped
input are not interpreted.
Otherwise, the statement body up to any
matching EF request is executed.  An IF statement can be used
in place of a BEGIN block where the block is entirely nested in
a macro definition.  This usage is advantageous in that an error
message will be produced if the IF statement is not terminated
at the end of the macro definition.
.
.req ef N(1) no "Begin an alternative case."
(Else-If)
This request may appear only directly within an IF statement.
If this request is encountered as the result of a successful IF
or EF test, then it causes the remainder of the IF statement to
be skipped.  If it is encountered as the result of an unsuccessful
IF or EF request, then the argument is evaluated and used to
control input execution as for the IF request.
.
.req wh N(1) no "Iterate statement body."
(While)
The argument is evaluated.  If the argument is 0, input is ignored
until the next matching EN request is encountered; \xc(A), \xc(S), and
\xc(N) characters in the skipped input are not interpreted.
Otherwise,
the statement body is executed; when the corresponding EN
request is reached, the process iterates with the evaluation
of the argument to the WH request.
.
.req fr "var:M init:N(1) limit:N(infinity) step:N(1) test:N(1)" no "Iterate statement body."
(For)
This request defines the iteration number variable 2var*
and initializes it to the initial value 2init*;
the 2limit* and 2step* values are evaluated and saved.  Then the
iteration begins: the value of the iteration variable is compared
to the limit value; if the step is positive and the iteration variable
is greater than the limit value or if the step is negative and the
iteration variable is less than the limit value, then the FOR
statement terminates.  The conditional test 2test* is evaluated; if 0, the
FOR statement terminates.  The body of the FOR statement is executed.
The value of the iteration variable is incremented by the step value.
The iteration then repeats.  When the execution of the FOR
statement is completed, the old value of the iteration variable
is restored.
.
.req en "" no "Terminate statement body."
(End)
The body of the innermost BEGIN, IF, WHILE, or FOR statement is
terminated.
.
.req bk "" no "Break out of WHILE or FOR statement."
(Break)
Execution of the innermost WHILE or FOR statement is abandoned.
Input is taken from the point following the corresponding EN
request.
.
.req nv "M N(0)" no "Define number variable M, initialize to N."
(Number Variable)
The old value of the named number register (if any) is saved (after
the second argument is evaluated),
and the value of the number register is set to the given value.
The old value of the number register will be restored when the
end of the innermost enclosing statement body is reached.
.
.req sv "M S(null)" no "Define string variable M, initialize to S."
(String Variable)
The old value of the named string register (if any) is saved (after
the second argument is evaluated),
and the value of the string register is set to the given value.
The old value of the string register will be restored when the
end of the innermost enclosing statement body is reached.
.
.req hv "M H..." no "Define variable; initialize to sum of H..."
(Horizontal Variable)
The old value of the named number register (if any) is saved (after
the remaining arguments are evaluated),
and the value of the number register is set to the sum
of the given horizontal distance specifications in mils.
The old value of the number register will be restored when the
end of the innermost enclosing statement body is reached.
.
.req vv "M V..." no "Define variable; initialize to sum of V..."
(Vertical Variable)
The old value of the named number register (if any) is saved (after
the remaining arguments are evaluated),
and the value of the number register is set to the sum
of the given vertical distance specifications in mils.
The old value of the number register will be restored when the
end of the innermost enclosing statement body is reached.
.
.rqsec "Traps"
.para
A trap causes the dynamic invocation of a macro when a particular
vertical position is reached.  A trap is set by the ST request,
which specifies a macro name and a vertical position.
If any attempt is made to increase the current vertical position
past the specified position V, the current vertical position is set
to V and the specified macro is invoked at that point.
More than one trap may be set at a given vertical position,
in which case the macros are invoked in the order in which
the traps were set.
A macro is guaranteed only to be able
to output one line (without explicitly changing the current
vertical position) before it is itself subject to being "interrupted"
by another trap macro.
.para
Traps may be inhibited by setting the built-in number register
ENABLED to zero.  When traps are inhibited, no trap macros will
be dynamically invoked, regardless of the vertical position.
Traps may be enabled by setting the built-in number register
ENABLED to one.  When traps are turned on,
trap macros will be invoked as described above.
If there are traps set at vertical
positions less than or equal to the current vertical position
at the time traps are turned on and these traps had
not yet been invoked on the current page, then they will
become eligible for invocation after the next attempt
to increase the current vertical position.
.para
A trap set at vertical position 0 is invoked at the beginning
of a page.  However, invocation of such header macros is not
done as soon as a new page is begun.  Instead, it is delayed
until the first text line (perhaps already in progress) or
break-causing request (other than BJ) is seen.  The trap macro is invoked
before the text or break-causing request is actually processed.
Even if a break is not caused, a request that changes the
current vertical position will also invoke header macros,
as normal.  When traps are inhibited, text lines and break-causing
requests do not enable header macros, nor do they disable
later invocation of header macros by text lines or break-causing
requests after traps have been re-enabled.  (See the
PAGE_EMPTY built-in number register.)
.
.para
When all input is exhausted, R (in effect) repeatedly does BPs until
the current page is empty and there is no more input,
in order to flush out all traps pending on the last page.
It is thus incorrect to have a footer trap macro that also puts out the
header on the next page, as an infinitely-long document would result.
.
.para
The built-in number register VTRAP contains the vertical distance
in mils to the next trap position.  When a trap is invoked by an
increase to the vertical position, the vertical position is set
to the trap position, which may be less than the vertical position
that would have been reached had there been no trap invocation.
The built-in number register VPLOST is set to the amount of vertical
distance thus lost.
.
.reqh
.
.req st "M V" no "Set trap to macro M at vertical position V."
(Set Trap)
A trap to the specified macro is set at the specified vertical
position.
.
.req rt "M V" no "Remove trap to macro M (at position V)."
(Remove Trap)
The specified trap is removed.  If no vertical position is
specified, the trap to the named macro at the smallest vertical
position will be removed.
.
.req ct "M pom!V" no "Change position of trap to V."
(Change Trap)
The position of the first trap to the specified macro is
changed to the specified position (pom relative to the
old position).
.rqsec "Stream Switching"
.para
The input to R is normally taken from the file specified
in the command line.  This input may be switched temporarily
(pushed and popped) to other sources.
.
.reqh
.
.req so T no "Insert from file T."
(Source File)
Input is temporarily taken from the specified file.
If the file is not found in the specified (or default)
directory, the standard R directory is also searched.
(See also the CFILENAME built-in string register.)
.
.req nx T no "Begin reading from next file, T."
(Next File)
The current (most recent) input file is terminated.  If an argument
is present, the specified file is opened and used for input.
If the file is not found in the specified (or default)
directory, the standard R directory is also searched.
(See also the CFILENAME built-in string register.)
.
.req rd T(bell) no "Read from standard input; prompt with T."
(Read)
The string T is printed on the standard output and input is
read from the standard input (normal input mapping occurs).
Input from the standard input is terminated by an empty line, at
which point normal input is resumed.  (See also the INTERACTIVE
built-in number register.)
.
.req ex "" no "Exit."
(Exit)
Text processing is terminated as if all current input sources
ended at that point.
.rqsec "Text File Output"
.para
Requests are provided to write text to additional output files
for subsequent processing by other programs.  Only one output file
may be open at one time.  Before text may be output, a file must
be opened by a WF or WA request.  Output is performed by the WS,
WL, and WM requests.  The output file is closed by the WE request.
.para
When logical input characters are output, the inverse of the default
mapping is used to translate them to sequences of physical input
characters.  Thus, for example, text characters that normally
map to a control character are preceded by ^Q when output.
.
.reqh
.
.req wf T no "Begin writing new file T."
(Write File)
A new file with name T is opened for output.
If T consists of a single name, then T is used as a suffix
on the output file name.
.
.req wa T no "Append output to file T."
(Write Append)
The file name T is interpreted as specified for the WF
request.
If the named file exists, then it is opened
for output, with output being appended onto the current contents
of the file.  Otherwise, a new file is created, as for WF.
.
.req ws S no "Write string S to file."
(Write String)
The given string is written (without a trailing newline) onto
the currently-open output file.
.
.req wl S no "Write line S to file."
(Write Line)
The given string is written with a trailing newline onto the
currently-open output file.
.
.req wm M no "Write body of macro M to file."
(Write Macro)
The body of the named macro is written onto the currently-open
output file.
.
.req we "" no "Close output file."
(Write End)
The currently-open output file, if any, is closed.
.rqsec "Control Characters"
.para
The mapping of physical input characters to either the
corresponding ASCII text characters or to R control
characters may be modified using the CC and NC requests.
In addition, the meaning of the escape characters
may be modified using the EC request.
.
.reqh
.
.req cc "C C2" no "Interpret C2 as \xc(C)."
(Control Character)
The physical input character (call it P2) corresponding to
text character C2 is hereafter interpreted to be the R
control character \xc(C) designated by the text
character C.  (See Section sec_cclist for a listing of
the R control characters and their designations.)
This interpretation holds only when reading
is performed in a mode in which the character \xc(C)
is recognized; otherwise, the input character P2 is mapped
to the corresponding text character, C2.  When reading
is performed in a mode in which \xc(C) is recognized, P2 can be
forced to be interpreted as the corresponding text character C2
by immediately preceding it by the \xc(Q) character (q.v.).

This request should 2not* be used to redefine the \xc(J) (newline)
character.  It is also recommended that letters not be used
to represent control characters, so as to avoid conflict
with the representation for escape characters.
.
.req nc C no "Make character C normal."
(Normal Character)
The physical input character corresponding to the text
character C is hereafter interpreted as that text character.
.
.examples
The following sequence gives examples of the use of the CC and NC requests:
.table
	.cc . $ 	^K make $ be \xc(.)
	.nc .   	^K . now does nothing special
	.foobar 	^K this is a text line
	$cc . . 	^K restore original definition of .
	.nc $   	^K restore orignal definition of $
.end_table
.
.
.req ec "C L" no "Define escape character 1esc-*C to be L."
(Escape Character)
The escape character 1esc-*C (C is a text character)
is hereafter interpreted as the logical input
character L.
One level of protection is removed from the character L
when it is read, thus allowing the interpretation of a
\xc(), \xc(I), \xc(A), \xc(K), \xc(N),
\xc(Q), or \xc(S) to be inhibited by preceding it
by a \xc(\).
.
.examples
The following are examples of the use of the EC request:
.table
	.ec a \^A	^K define \a to be \xc(A)
	.ec c ^C	^K define \c to be \xc(C)
	.ec k \^K	^K define \k to be \xc(K)
	.ec q \^Q	\k define \q to be \xc(Q)
	.ec z \q^K	^K define \z to be 2text* ^K
.end_table
.
.rqsec "Output Processing"
.para
Requests are provided to cause character translation in text
and to change the thickness and the relative position of underscoring
caused by \xc(B) and \xc(E).
.para
Output printing may be turned off by setting the built-in
number register PRINTING to zero.  When output printing is
turned off, calculation of horizontal
and vertical position and page numbers continues as usual.
Printing is resumed when the number register PRINTING is set
to one.  This facility can be used to perform two-pass processing.
Caveat utilor.
.
.reqh
.
.req tr "C1 C2(SP)" no "Translate C1 to C2 in text."
(Translate)
This request causes occurrences of the text character C1 to
be replaced by the text character C2, 2when C1 appears
in text words*.  Translation can 2not* be inhibited by \xc(Q).
.
.examples
The TR request is commonly used to define a convenient representation for
the ASCII space character, as follows:
.tr @@
.table
	.tr @
.end_table
Because only one character is given, it is (by default) translated
to ASCII space, a character that normally must be quoted with
\xc(Q).  Hereafter, @ will act like a "dummy" space character,
that is, a character that prints like a space but is not interpreted as
a \xc() and may not therefore be widened during justification
or cause an end-of-line.
.foot
This example assumes that the SP character prints as blank space.
R does not in general make this assumption.
.efoot
The translation can be undone by
.table
	.tr @ @
.end_table
which causes @ to be translated to itself.
.tr @
.
.req uo V no "Set underscoring offset to V."
(Underscore Offset)
This request sets the offset of underscoring (controlled by
\xc(B) and \xc(E)) relative to the base line (negative offset is below
the base line).  The offset specifies the position of the top
of the underscoring.
The initial value of the underscore offset is
device-dependent.  If no argument is given, UO restores the
initial offset.
This request has effect when a line is output;
it may not be used to vary the underscoring within one output line.
.
.req ut V no "Set underscoring thickness to V."
(Underscore Thickness)
This request sets the thickness of underscoring (controlled
by \xc(B) and \xc(E)).  The default thickness is device-dependent.
If no argument is given, UT restores the initial thickness.
This request has effect when a line is output;
it may not be used to vary the underscoring within one output line.
.
.rqsec "Miscellaneous"
.reqh
.
.req tm T no "Type message T."
(Type Message)
The specified string is printed on the standard output unit,
followed by a newline.
(See also the INTERACTIVE built-in number register.)
.
.req rl "M T" no "Read line from standard input into string register M."
(Read Line)
The string specified by T is printed on the standard output
unit, without a trailing newline.  Then, a line of text is
read from the standard input unit and assigned to be the
value of the named string register.
(See also the INTERACTIVE built-in number register.)
.
.req xc "M args" no "Execute request M."
(Execute Request)
The request M is executed with the given arguments.
The arguments are read in mode 2; thus, the \xc(A), \xc(S), and \xc(N)
characters can be used to compute arguments that are normally
quoted.
.am table_of_contents
.br
.fs
.ir -300m
.ne 5i
.em
.
.sec "Control Characters"
.para
There are two stages in the processing of R control characters.  The
first stage is 1recognition*, where a sequence of one or more physical
input characters is transformed into the R control character that it
represents.
The second stage is 1interpretation*, where an already-recognized
R control character causes some action to occur.
This section defines the interpretation of the R control characters.
Those R control characters not defined here have no interpretation,
but are reserved for future use.
.para
There are four classes of control characters, distinguished by
where they are interpreted and their relation to text words.
The four classes are:
.ilist 400m
1text* - These control characters are interpreted only when
processing text, and are considered to be components of text words.
The text control characters are \xc(B), \xc(D), \xc(E), \xc(F), \xc(H),
\xc(U), \xc(V), and \xc(Z).
.next
1text separator* - These control characters are interpreted only
when processing text, but serve to separate text words.  The text
separator control characters are \xc(C), \xc(G), \xc(P), \xc(R), \xc(T),
\xc(W), and \xc(X).
.next
1universal separator* - These control characters are interpreted
everywhere, and also serve to separate text words.  The universal
separator control characters are space, \xc(I), \xc(J) (newline),
\xc(.), and cquote.
.next
1input* - The input control characters are interpreted everywhere,
at the level of input scanning.  The input control characters are
\xc(A), \xc(K), \xc(N), \xc(Q), \xc(S), and \xc(\).
.end_list
There is no need to delay the interpretation of text or text
separator control characters in macro definitions.
.sp
.ne 10l
The following table lists the R control characters and describes
their interpretation:
.sp
.cc_header
.cc_des A \xc(A)2n* "Insert Macro Argument 2n*"
The 2nth* (2n* a decimal digit, arguments counted from 0)
argument of the current macro invocation is
inserted into the input stream, replacing the control character
sequence.  If no 2nth* argument was given in the current
macro invocation, then the null string is inserted.
An error message is printed if \xc(A) is used when there
are no active macro invocations.
.
.cc_des A \xc(A)dot "Test for invocation by \xc(.)"
This control character sequence is replaced by 1 if the current
macro was invoked using \xc(.) and returns 0 if the macro was invoked
by cquote, by \xc(X), or as a trap macro.  This control character
sequence can be used to contruct macros that simulate those
built-in requests that normally cause line-breaks.
An error message is printed if lkeep(\xc(A)dot) is used when there
are no active macro invocations.
.
.cc_des B \xc(B) "Begin Underscore"
The following text, terminated by a \xc(E) character,
is underscored in the output.  Only text is underscored, not
spaces.
.
.cc_des C \xc(C) "Center Following Text"
The text following the \xc(C) and terminated by the next
\xc(R), \xc(P), \xc(I), or line-break is centered within the
horizontal positions defined by the preceding \xc(P), \xc(I),
or the left margin and the next \xc(P), \xc(I),
or the right margin.
A \xc(C) at the beginning of an input line causes a line-break.
.
.cc_des D \xc(D) "Move Down (Subscript)"
The vertical offset is decreased by a device-dependent
distance (LPT: one line height, VARIAN and XGP: one-half the
height of the principal font above the baseline).
An error message is produced if subscripts extend
over more than one input line (see \xc(G)).  (See also the VOFF
built-in number register.)
.
.cc_des E \xc(E) "End Underscore"
Terminates underscoring.
.
.cc_des F \xc(F)2f* "Font Select"
The font designated by 2f* becomes the current font.
The old current font is pushed on the font stack
(see the FS request).
lkeep(\xc(F)*) pops a font from the font stack
and makes it the current font.
.
.cc_des G \xc(G) "Glue Together Adjacent Words"
The immediately preceding and following words are glued together
into one.  More precisely, if the current output line ends with
a space that was produced by a \xc(J) (newline) in fill mode,
then that space is removed.
The last text word in the line is marked as incomplete.
The immediately following word (in the same environment) will be
concatenated to the incomplete word, unless there is an
intervening break.  A single
immediately following \xc(J) (newline)
will not cause a break (in nofill mode), will not
be changed to
space!s, and will not cause error messages for unterminated
superscripts or subscripts.
A leading space, \xc(C), \xc(I), \xc(P), or \xc(R)
following the \xc(J) also will
not cause a break.   (See \xc(W).)
.
.cc_des H \xc(H) Backspace
(Backspace) The "character position" within the text word being
built is decreased by 1.  This control character is used to overprint
multiple text characters in the same position within one text word.
Overprinted characters are centered within a space whose width
is sufficient to contain each of the characters.
.
.cc_des I \xc(I) Tab
(Tab) In text, this character causes the current horizontal position
to be increased by the nominal
character width of the principal font and then to the
next tab stop (if any).
A \xc(I) at the beginning of an input line causes a line-break.
In request lines, this character is used to separate request and macro
arguments.
.
.cc_des J \xc(J) Newline
(Newline) The newline character separates input lines.  In nofill
mode, it causes a line-break.  In fill mode, if it immediately
follows a text word ending with a period, then it is
equivalent to a double-width space character.  Otherwise, it
is equivalent to a normal-width space character.
(See \xc(G).)
.
.cc_des K \xc(K) "Begin Comment"
This control character causes all following input,
up to the next newline, to be ignored.  If the \xc(K) appears as the
first character on a line, then the entire line (including the
terminating newline) is ignored.  This character is interpreted only
for file input.
.
.cc_des N \xc(N){pom}{2m*}M "Insert Number Register"
Here the "{pom}" indicates an optional quote+quote or
quote-quote character,
{2m*} stands for an optional printing mode (listed below),
and M is the name of a number register.
The result of this control sequence is that the control
sequence is replaced by the value of the named number
register.  If the quote+quote is present, the number register
is first incremented.  If the quote-quote is present, the number
register is first decremented.  If a mode is present, the number
is printed as follows:
.br
.lbegin
.sv list_right_margin 0
.ne 7
.ilist 6 0
1mode	format*
.sp
.next
.	lower-case Roman numerals
.next
:	upper-case Roman numerals
.next
,	lower-case alphabetic (a,b, ... z,aa,ab, ... )
.next
;	upper-case alphabetic (A,B, ... Z,AA,AB, ... )
.end_list
.end
Otherwise, the value is printed in the usual decimal
notation.  The control sequence may be followed by quote!!quote
in order to terminate the number register name; this is
necessary only if the control sequence is followed by
a letter, digit, \xc(A), \xc(N), \xc(S), or quote!!quote.
.
.cc_des N \xc(N)?M "Test Number Register Definedness"
This control sequence is replaced by "1" if the named
number register is defined, "0" otherwise.
.
.cc_des P \xc(P)(2h*) "Tab to Specified Position"
This control sequence causes the current horizontal position to be
increased to the horizontal position specified by 2h*.
The horizontal position is always increased by at least the nominal
character width of the principal font.  In this regard,
\xc(P) is similar to \xc(I).
A \xc(P) at the beginning of an input line causes a line-break.
.
.cc_des Q \xc(Q)2c* "Quote Input Character"
The physical input character 2c* is quoted; that
is, the control sequence is replaced by the ASCII
text character corresponding to 2c*.  For example,
the sequence \xc(Q)^Q (written ^Q^Q in the input file)
represents the ASCII control-Q text character.
.
.cc_des R \xc(R) "Right Flush Following Text"
The text following the \xc(R), terminated by the next \xc(P), \xc(I), or
the end of the output line is justified rightmost
against the horizontal position defined by the next \xc(P),
\xc(I), or the right margin.
A \xc(R) at the beginning of an input line causes a line-break.
.
.cc_des S \xc(S)M "Insert String Register"
The value of the string register designated by M
is inserted in place of the control sequence.
The string register name is read as for \xc(N).
.
.cc_des S \xc(S)?M "Test String Register Definedness"
This control sequence is replaced by "1" if the named
string register is defined, "0" otherwise.
.
.cc_des T \xc(T)2s* "Define Tab Replacement Text"
The text word 2s* becomes the text used to fill out the space
generated by the next \xc(I), \xc(P), \xc(C), or \xc(R)
in the same environment.
.
.
.cc_des U \xc(U) "Move Up (Superscript)"
The vertical offset is increased by a device-dependent
distance (same as for \xc(D)).
An error message is produced if superscripts extend
over more than one input line (see \xc(G)).  (See also the VOFF
built-in number register.)
.
.cc_des V \xc(V)(pom2v*) "Change Vertical Offset"
The vertical offset is set to 2v* (a leading pom causes 2v*
to be interpreted pom relative to the
previous vertical offset).  An error message is produced if the
vertical offset is not zero at the end of an input line (see \xc(G)).
(See also the VOFF built-in number register.)
.
.cc_des W \xc(W) "Word-break"
This control character separates text words without resulting
in any output space.  For example, it can be used to allow
a word to be broken after an explicit hyphen, as in the
word "built-^Win".  It can also be used to protect a preceding
space or a following newline from being eaten by a \xc(G).
.
.cc_des X \xc(X)M(2args*) "Inline Macro Invocation"
This control character, 2when occurring in a text line*, causes the
inline invocation of the named macro.  If arguments are to be
given, the argument list must immediately follow the macro name and be enclosed
in parentheses.  Multiple arguments are
separated by space!s and \xc(I)s.  Parentheses in unquoted arguments
must be balanced.  Arguments may be enclosed in quotation marks,
in which case they may contain space!s, \xc(I)s, and unbalanced parentheses.
Nested inline macro invocations are passed unexpanded
to the macro definition.  If no arguments are to be given, then
the parentheses should be omitted, and the macro name may be followed
by quote!!quote as for \xc(N).  Text that is output by the macro invocation will
be concatenated to an immediately preceding word and to an immediately
following word.  \xc(X) is 2not* interpreted in request lines.
.
.cc_des Z \xc(Z) "Set Vertical Offset to Zero"
The vertical offset (used for superscripting and subscripting)
is set to zero (normal).  (See also the VOFF built-in number register.)
.
.cc_des . \xc(.)2request* "Normal Request"
This control character is recognized only as the first character of
an input line, in which case the line is considered to be an R request.
.
.cc_des quote cquote2request* "No-break Request"
This control character is recognized only as the first character of
an input line.  Its effect is the same as the \xc(.) character, except
that a built-in request (other than the BJ request) is inhibited from
causing a line-break.
(In addition, a macro 2may* distinguish between invocations using
cquote and those using \xc(.))
.
.cc_des \ \xc(\) "Delay Control Character Interpretation"
This control character is used
to delay the interpretation of other
control characters (see the next section for a more complete
description).  It is also used in file input to write
escape characters.
.
.cc_des SP \xc() "Space"
This control character separates words and causes a blank
space on output (except when it occurs at the end of an output
line in fill mode, in which case it causes no output).
Multiple \xc()s are not compacted.
A \xc() at the beginning of an input line causes a line-break.
In request lines, this character is used to separate request and macro
arguments.
.in 0
.sec "Delayed Interpretation of Control Characters"
.para
The interpretation of a control character, primarily \xc(A), \xc(N), or \xc(S),
may be delayed for one or more "readings" by preceding it by
one or more \xc(\) characters.  A "reading" is a reading of the character
from an input file, a macro body, or a macro argument.
A sequence of 2n* \xc(\) characters delays the interpretation of an
immediately following control character for 2n*
readings.
For example, the character \xc(A) is interpreted directly and is replaced
by a macro argument.  The sequence \xc(\)\xc(A) is not interpreted, but
if stored in a string register, macro body, or macro argument,
it will be stored as \xc(A), so as to be interpreted when the string
register, macro body, or macro argument is later read.  Each storing
into a string register, macro body, or macro argument removes one \xc(\).
One \xc(\) is also removed from the second argument of the EC
request.
.para
The \xc(\) character is most useful in the bodies of macro definitions.
If one writes \xlkeep(\xc(A)0) in a macro definition, then the control sequence is
interpreted at macro definition time and thus will attempt to insert
the 02th* argument of a current macro expansion, which will be
meaningful only if the macro definition had been written inside the body
of another macro definition.  Most often, one really
wants to write \xlkeep(\xc(\)\xc(A)0) in the macro definition.  The \xc(\) protects
the \xc(A) from being interpreted when the macro definition is first read.
When the macro is later invoked, the macro body is read again,
and the \xc(A) is interpreted, as desired.
(Recall that \xc(\) is written as \ in the physical input alphabet.)
.nr nrtable current_table
.nr srtable current_table+1
.sec "Built-In Registers"
.para
There are a number of built-in number and string registers
that allow the R user access to various R parameters.
Built-in registers are referenced normally, using the
names listed below.   Some built-in registers may not be
redefined; these are indicated in the tables by asterisks.
Built-in registers whose values are dependent on the current
environment are indicated by an E.
The built-in number registers are listed in Table :nrtable;
the built-in string registers are listed in Table :srtable.
.
.
.begin_table "Built-in Number Registers"
.
.
.ta 5 25
.sp
	1name	value*
.sp
	adjust (E)	the current adjust mode (0=left,1=right,2=center,3=both)
	day (*)	the current day of the month (1-31)
	debug (*)	debugging flag (set by -d option)
	enabled	1 <==> traps are enabled
	end_of_sentence (E)	1 <==> last word ended a sentence
	even (*)	1 <==> the current page is even
	fheight (E*)	the height in mils of the principal font
	fill (E)	fill mode (1=fill, 0=nofill)
	font (E)	the current font (0-15)
	fwidth (E*)	the character width in mils of the principal font
	habove (E*)	the height above the baseline of the current output line
	hbelow (E*)	the heignt below the baseline of the current output line
	hpos (E)	the current horizontal position in mils
	indent (E)	the current indentation in mils
	interactive (*)	1 <==> the standard output unit is a terminal
	ll	the line length in mils
	lpt (*)	1 <==> the output device is LPT
	ls (E)	current line spacing * 100
	lvpu	the last vertical position used, in mils
	month (*)	the current month (1-12)
	nargs (*)	the number of arguments to the innermost macro invocation (0-10)
	next_page	the next page number
	page	the current page number
	page_empty	1 <==> a text line or line break will invoke a header trap
	pfont (E)	the principal font (0-15)
	pl	the page length in mils
	printing	1 <==> printing is enabled
	rindent (E)	the current right-margin indentation in mils
	spacing	spacing mode (0=normal, 1=S, 2=P)
	stats	1 <==> print extra statistics when done (set by -s option)
	trace	tracing flag (set by -t option)
	varian (*)	1 <==> the output device is VARIAN
	version (*)	R version number (0 => experimental)
	voff (E)	the vertical offset in mils
	vplost (*)	the vertical distance lost due to most recent trap
	vpos	the current vertical position in mils
	vtrap (*)	the vertical distance to the next trap in mils
	xgp (*)	1 <==> the output device is XGP
	year (*)	the current year (1900-?)
.em
.
.finish_table
.
.
.
.
.begin_table "Built-in String Registers"
.
.
.ta 5 25
.sp
	1name	value*
.sp
	cfilename (*)	the name of the currently-active input file
	date (*)	the current date (e.g. 1 January 1984)
	device (*)	the device name
	env (E)	the current environment name
	fdate (*)	the creation date of the main input file
	filename (*)	the name of the main input file
	ftime (*)	the creation time of the main input file
	lineno (*)	the current line number (as in error messages)
	sdate (*)	the current date (short format, e.g. Jan  1 1984)
	time (*)	the current time (e.g. 20:01:59)
	user (*)	the user name
.em
.
.finish_table
.
.
.ne 13l
.sec "Freezing"
R requires the output device and the fonts
to be specified before any of the following events occur:
.ilist 3 0
1.	A text line is encountered.
.next
2.	A line-break occurs.
.next
3.	A vertical or horizontal distance specification is used.
.next
4.	An environment-dependent built-in register is referenced.
.next
5.	An environment-, trap-, or device-related request (other
than DV or FO) is performed.
.end_list
When any of these events occur, the selection of output device
and fonts is said to be 2frozen*.  Subsequent DV or FO
requests are illegal and cause processing to be aborted.
.
.ne 12
.sec "Invoking R"
.para
R is invoked giving the input file name as a command argument.
.foot
On ITS, the input file name must be surrounded by quotation
marks if it contains spaces, e.g. "PAPER@R".  Alternatively,
one may write paper.r or common/paper.r, avoiding the use
of quotation marks.  On Unix, if no file name is given, R takes
its input from the standard input unit.
.efoot
R produces an output file whose name is the input file name
with a new suffix.  (The exact suffix is system- and device-dependent.)
.
.para
The following options may be given on the command line:
.ilist 14 0
-l	force device to LPT
.next
-v	force device to VARIAN
.next
-x	force device to XGP
.next
-d	initialize 2debug* number register to 1
.next
-t	initialize 2trace* number register to 1
.next
-s	initialize 2stats* number register to 1
.next
2name*=2value*	initialize the number register specified by
2name* to the specified 2value* (an optionally signed integer)
.end_list
The initialization of number registers by the = form of command
takes place immediately, except for certain environment-oriented
or device-oriented built-in number registers.
For these built-in number registers, initialization
takes place when the choice of output device becomes frozen
(as described in the previous section).
.para
As for all C programs, the TTY output of R can be redirected
to a file by adding an extra command argument,
.table 1
	>filename
.end_table
which causes the TTY output to be sent to the named file.
.sec "Error Messages"
.para
R detects various errors in request usage and other anomalous
conditions and reports them to the user on the standard output unit.
The form of an error message is
.table 1
	2line-number*: 2message*
.end_table
The 2line_number* is a description of the currently active
input sources, listed as
.table 1
	2source*,2source*, ... ,2source*
.end_table
with the most recently activated source at the right.  File inputs
are represented by the file name and
the current line number (input from the standard
input unit is represented by "TTY").  Currently active macro
invocations are represented by the macro name.
.sec "The Trace Facility"
.para
R provides a trace facility to aid in the debugging of R programs.
When tracing is on, a complete record of the execution is written
onto two files (with extensions 2rta* and 2rtb*).  The first file
contains a low-level description that indicates the exact input
read, with changes of input indicated as follows:
.rtabs
.table
	[F]	- reading from a file
	[M]	- reading from a macro definition
	[A]	- reading from an argument or string register
	[S]	- reading a pushed-back string
	[C]	- reading a pushed-back character
.end_table
The second file presents a higher-level trace of the requests
executed and the values of evaluated arguments.  In addition,
each output file contains a record of trap invocations and
error messages.
.para
The trace facility is controlled by the 2trace* built-in
number register.  It may also be turned on by a command option -t.
.force_out
.bp
.nr example 0
.de example
.sp
.ne 6l
3\sec_no.\+example  \0*
.sp
.ns
.am table_of_contents
.ta indent+600m
    1\sec_no.\example	\0 . \page*
\.em
.em
.sec Examples
.am table_of_contents
.sp .5
.fs 1
.ir +300m
.em
.para
.rtabs
This section describes a number of examples, ranging from
relatively simple macros for paragraphs, chapter headings, and margins,
to sophisticated formatting macros.
The functions performed by these macros are generally provided by
standard macro packages.
Users should always consult the documentation of available macro
packages before writing their own macros.
.
.example "Paragraphs"
.para
One way to start paragraphs in R is to simply begin the text of the
paragraph on a new line, preceded by a \xc(I) (tab).  The \xc(I) at
the beginning of the line causes a line-break, so that the paragraph
will begin on a new output line; it also causes indentation.  If one
wants to have a blank line between paragraphs in the output document,
one can simply leave a blank line between paragraphs in the input.
.para
While these methods work, they have disadvantages.  One disadvantage
is that one must be careful that the tab stops are always set in
the right place; it may be inconvenient to shift back and forth
between a tab stop at column 5 for paragraphs and a tab stop at
column 8
for tables, for example.  Obviously, other methods, such as
explicit SP requests and TI requests, could be used.  However,
the major disadvantage of these approaches (and any other approaches
involving explicit R requests) is inflexibility.  If at some later
time one decides to change the paragraph format (for example, to
meet the formatting requirements of a journal), changing all of
the paragraphs to the new format will be difficult and error-prone.
If one is lucky, the change can be made by a text editor; however,
one must be careful that there are no non-paragraph uses of the
paragraphing requests.
.para
The right way to do paragraphs (and any other repeated action with
a specific meaning to the user) is to use a macro.  Using a macro
ensures that all of the paragraphs are done the same way and that
it is easy to change the paragraph format.  Using a macro also
encourages adding extra requests that one would be too lazy to
write by hand for each paragraph; in particular, one could have
a NE request to make sure that a paragraph did not start too close
to the bottom of the page.
.ne 16
.para
An example of a paragraph macro that has been used in a technical
paper is:
.table 13
	.if ls<150
	. de para
	.  sp
	.  ne 3l
	.  ti 5
	. em
	.ef
	. de para
	.  br
	.  ne 3l
	.  ti 5
	. em
	.en
.end_table
This macro definition has been conditionalized to work with two
formats, one a single-spaced format with paragraphs separated by
blank lines (camera-ready form) and one a double-spaced format with
no extra blank lines between paragraphs (review form).
.example "Chapter Headings"
.para
A useful macro to have around is one that defines chapter headings.
This macro is intended to be invoked with one argument,
the title of the chapter.  The macro should print
the chapter number and the chapter title and print
blank lines appropriately.
.para
First we will need a number register to keep a count
of the number of chapters.  This is defined using
the request
.table 1
	.nr chapter_no 0
.end_table
which defines the number register and initializes it
to zero.  Now, let's define the actual macro:
.table 6
	.de chapter
	. sp
	. ne 6l
	\^N+:chapter_no. \^A0
	. sp
	. ns
	.em
.end_table
The are a number of points to explain.  The macro begins with an SP
request that causes a line-break and prints out a blank line.  Then a
NE request checks to make sure that we are not too close to the end of
the page; if we are too close, a new page is started.  The next line
prints the chapter number followed by the title.  It uses the
increment form of the \xc(N) sequence and uses upper-case Roman printing
mode.  Note the use of the \xc(\) character to delay the interpretation
of the \xc(N) and \xc(A) characters until the macro is invoked.  Finally,
another SP request prints another blank line, and we enter no-space
mode.  No-space mode is entered in order to inhibit any blank line
that might be caused, for example, by an immediately following
paragraph macro.  If a paragraph macro is used, one must be sure
that the NE distance in the chapter macro is sufficiently larger
than the NE distance in the paragraph macro so that a chapter heading
will never be printed at the bottom of a page with the first paragraph
at the top of the next page.
.para
.ne 7
This macro could be used as follows:
.table 1
	.chapter "Suggestions for Future Research"
.end_table
which would print:
.table 1
	I.  Suggestions for Future Research
.end_table
Note that the macro argument must be enclosed in
quotation marks because it contains space!s.
.example "Margins"
.para
The next example consists of a header and footer
macro that set up one-inch top and bottom margins:
.table 4
	.de header_macro
	. vx lvpu 1i
	. ns p
	.em
.end_table
.table 7
	.de footer_macro
	quote bp
	.em

	.st header_macro 0
	.st footer_macro 10i
.end_table
The header macro is set to be invoked at the beginning
of each page.  It first sets the 2last vertical position used*
(LVPU, see Section sec_rq.req_vp above) to 1 inch from the top of the
page.  Setting LVPU ensures that any subsequent output
will be entirely below the specified position.  In this case,
a top margin of size 1 inch results.
.
.para
The macro concludes by entering no-space no-page mode.
This is to prevent the top margin from being extended by
the accidental occurrence of a SP request immediately
after the invocation of the header macro or a blank
page from being produced by the occurrence of a BP request
immediately after the invocation of the header macro.
(If one desires to have a blank space even at the top
of an output page, one must precede the SP request with
an RS request.)
.
.para
Note that the header macro does not cause
a line-break.  One must be careful to avoid causing a line-break
in a trap-invoked macro.  Often when a trap occurs, a partial
output line will have been collected.  This partial line would
be output immediately if there were a line-break.
.
.para
The footer macro is set to be invoked when the current
vertical position is increased past 10 inches.  It simply
does a BP (note: with the line-break inhibited), resulting
in at least a one inch bottom margin (assuming a page
length of 11 inches).  Note that subscripts may extend into
the bottom margin.
.para
The above code can be parameterized by the page length, as
follows:
.table 1
	.st footer_macro pl-1000m
.end_table
This sets the footer trap at one inch (1000 mils) above the bottom
of the page; the trap position is specified in mils because the
PL number register is in units of mils.  Note that if the page
length is later changed, the trap position will 2not*
automatically change:  the trap position is evaluated 2once*,
when the ST request is processed.
.example "Headings"
.para
A more complicated header macro can be written that
prints a header line at the top of each page, consisting
of a left-heading and a right-heading, with the page
number centered inbetween.
It is assumed that the left and right heading text will
be provided in string registers by the user of the macro;
this decision allows the headings to be changed during the
processing of the text file.
.ne 1
The new header macro is:
.table 10
	.de header_macro
	. ev header
	. nf
	. vp 0.5i
	\^Sleft_heading^C- \^Npage -^R\^Sright_heading
	. ev
	. vx lvpu 1i
	. ns p
	.em
.end_table
This macro needs to use a new environment because it produces
a text line.  If it used the existing environment, the
left-over text from the previous page would get printed
on the header line.
The 2page* number register
is a built-in number register whose value is always
the current page number.
.para
The above macro uses the EV request to change environments.
This has the disadvantage of "remembering" only one old
environment.  If the header macro should go off in the middle
of some other macro that also used the EV request to save
an older environment, then the older
environment would not be restored properly.  The macro can
be improved by using the local variable mechanism to save an
arbitrary number of old environments:
.table 11
	.de header_macro
	. if page>1
	.  sv env header
	.  nf
	.  vp 0.5i
	\^Sleft_heading^C- \^Npage -^R\^Sright_heading
	. en
	. vx lvpu 1i
	. ns p
	.em
.end_table
The IF statement serves to define the scope of the local
variable ENV; it also conveniently serves to prevent the
heading from being printed on the first page.
The environment is set using the SV request, which
automatically saves the old value on a stack; the old value
is restored when the IF statement terminates.
.example "Equations"
.para
The next example is a more sophisticated one.  It is a macro
DIV which takes two text arguments and outputs them one
above the other, separated by a horizontal line, as in
the mathematical notation for division.  A macro WIDTH
is assumed to exist that takes a text argument and
computes its width, height above the baseline, and height
below the baseline; these results are to be left in number
registers WIDTH, HA, and HB, respectively.
(The WIDTH macro is developed in the next example.)
.para
The basic idea of the DIV macro
is compute the maximum width of the two
text strings, output a horizontal line of that width, then
center the two text strings above and below that line, at
appropriate vertical offsets so that the two strings do not
touch the horizontal line.
.para
The actual macro is shown in Figure current_figure.
.begin_figure "The DIV macro."
.rtabs
.table
	.de div
	.if
	. width "\^A0"
	. nv width1 width
	. nv hb1 hb
	. width "\^A1"
	. nv width2 width
	. nv ha2 ha
	. nv total width1
	. if width2>width1
	.  nr total width2
	. en
	. width _
	. nv uwidth width
	. if total%uwidth
	.  nr total total+(uwidth-(total%uwidth))
	. en
	. nv slop1 (total-width1)/2
	. nv slop2 (total-width2)/2
	. nv start hpos
	. nv end start+total
	^U^Xhline(\^Ntotal)^G
	. hs (start+slop1-hpos)m
	^V(+hb1-20m)\^A0^G
	. hs (start+slop2-hpos)m
	^V(-hb1+ha2!m)\^A1^V(+ha2+20m)^D^G
	. hs (end-hpos)m
	.en
	.em

	.de hline
	.if
	. nv end hpos+\^A0
	. wh hpos<end
	_^G
	. en
	.en
	.em
.ns
.end_table
.finish_figure
The macro begins with an IF request that sets up a new scope for
local variables.  It next uses the WIDTH macro to compute the widths
and heights of the two text strings.  It sets the number variable TOTAL
to the maximum width of the two strings and sets the variables HB1 and
HA2 to the height below the baseline of the numerator and the height
above the baseline of the denominator, respectively.
It next computes the width of the underscore character (UWIDTH) and makes
sure that the total width will be an integer multiple of that width.
It then computes the distances that each string will have to be
indented in order to center them with respect to the horizontal
line (SLOP1 and SLOP2).  Finally, it saves the starting horizontal
position as START and computes the ending position as END.
.para
The macro then outputs the horizontal line using a subsidiary
macro HLINE;
the horizontal line is raised using \xc(U) so that it will be approximately
at the midpoint of any adjacent text.
The HS request is used to reset the horizontal position
for each part of the output.  Note the use of \xc(G) to inhibit
the normal effects of the newline!s that terminate text input lines,
since all of this output is to occur on one output line.  The
character \xc(V) is used to raise and lower the various components of the
output; the 20 mils is a fudge factor that compensates for the fact
that underscore characters are usually positioned below rather than
at the baseline.
.
.nr width_level 0
.de width
.if
. nv width_level width_level+1
. es width\width_level
. sv env width\width_level
. nv printing 0
. nv enabled 0
. nv vpos vpos
. nv voff 0
. nv ll 30000
. br
. nv start hpos
\0
. nr width hpos-start
. nr ha habove
. nr hb hbelow
. xe
.en
.em
.
.de div
.if
. width "\0"
. nv width1 width
. nv hb1 hb
. width "\1"
. nv width2 width
. nv ha2 ha
. nv total width1
. if width2>width1
.  nr total width2
. en
. width _
. nv uwidth width
. if total%uwidth
.  nr total total+(uwidth-(total%uwidth))
. en
. nv slop1 (total-width1)/2
. nv slop2 (total-width2)/2
. nv start hpos
. nv end start+total
hline(\total)
. hs (start+slop1-hpos)m
(+hb1-20m)\0
. hs (start+slop2-hpos)m
(-hb1+ha2!m)\1(+ha2+20m)
. hs (end-hpos)m
.en
.em
.
.de hline  <width in mils>
.if
.nv end hpos+\0
.wh hpos<end
_
.en
.en
.em
.
.ne 5
.para
The DIV macro can be used as an ordinary request, such as
.table 1
.nv pfont 7
.nv font 7
	.div "a*b+c" "d+3"
.end_table
.ne 6
which produces an output of
.table
.nv pfont 7
.nv font 7
	div(a*b+c d+3)
.end_table
.ne 4
However, it is most conveniently invoked inline using \xc(X).  For
example, the line
.table
.nv pfont 7
.nv font 7
	a + ^Xdiv(e+^Xdiv(a b+c) a+c) * f
.end_table
.ne 4
produces the output
.table
.nv pfont 7
.nv font 7
.sp
	a + div(e+div(a b+c) a+c) * f
.end_table
.rs
.sp
Note that the HS request is used rather than HP, and the
horizontal line is drawn by a loop rather than using \xc(T)
and \xc(P).  These choices are necessary to allow DIV
to be used in fill mode.  Both the HP request and \xc(P)
cause justification to be inhibited to preceding text;
they are thus inappropriate for use in fill mode.
Similarly, one should always use text spaces rather than
\xc()s in arguments to DIV in fill mode, as \xc()s can be
enlarged by justification.
.para
However, there is another problem using DIV in fill mode.
Because the equations consist of many words,
it is possible for the output line to be broken in the middle
of an equation.  To get around this problem, one need only
be sure that there is enough room on the current line before
beginning an equation, which can be done by using the following macro:
.table
	.de lkeep
	. if
	.  nv width 0
	.  width "\^A0"
	.  if width>ll-rindent-hpos
	.   bj
	.  en
	\^A0^G
	. en
	.em
.end_table
This macro is designed to be invoked using \xc(X).  It takes one
argument, which is some text.  The macro simply outputs the text.
However, if the text would not fit on the remainder of the
current output line, then the current output line is first terminated
(using BJ so as not to inhibit justification), so that the
text will begin the next output line.
.
.
.example "Computing the Width and Height of Text"
.para
The previous example used a macro called WIDTH that computed
the output width and height of a text string.  The implementation of
such a macro involves a number of fine points.
.para
The basic method for computing the width or height of a string is to
begin a new line and output the string.  The width of the string
is then the current horizontal position minus the starting horizontal
position, and the height above and
below the baseline of the string is that of the current output line.
However, in order to be useful,
the macro must not actually output any text, nor should
it cause any other side-effects.  One implication of this
requirement is that the macro must use its own environment,
so that the current partial line will not be disturbed.
This working environment must be initialized from the current
environment, so that the relevant parameters (such as the
current font) will
be the same.  In addition, the macro will have to turn off
printing and traps and preserve the current vertical position.
A width macro is given in Figure current_figure.
.begin_figure "A simple WIDTH macro."
.table
	.de width
	.if
	. es width
	. sv env width
	. nv printing 0
	. nv enabled 0
	. nv vpos vpos
	. nv voff 0
	. nv ll 30000
	. br
	. nv start hpos
	\^A0^G
	. nr width hpos-start
	. nr ha habove
	. nr hb hbelow
	. xe
	.en
	.em
.ns
.end_table
.finish_figure
This macro also increases the line length so that it can accurately
measure strings that are wider than one line.  (The line length
is set to 30000 because this is a large number that is sure to
fit on 16-bit machines.)  An IF statement is used so that the
parameters that are changed will be reset automatically.
.para
Although the macro above will work in many cases, it will not work
if called recursively, as it is called in the last example of the
use of the DIV macro.  It fails on a recursive call because each
invocation uses the same environment, and each causes side-effects
on the partial line.  In order to fix this problem, a number register
is introduced to keep track of the depth of invocation.  This
register is then used to form an environment name that is different
for each level of invocation (see Figure current_figure).
.begin_figure "The correct WIDTH macro."
.table
	.nr width_level 0

	.de width
	.if
	. nv width_level width_level+1
	. es width\^Nwidth_level
	. sv env width\^Nwidth_level
	. nv printing 0
	. nv enabled 0
	. nv vpos vpos
	. nv voff 0
	. nv ll 30000
	. br
	. nv start hpos
	\^A0^G
	. nr width hpos-start
	. nr ha habove
	. nr hb hbelow
	. xe
	.en
	.em
.ns
.end_table
.finish_figure
.
.am table_of_contents
.fs
.ir -300m
.em
.
.bp
.am table_of_contents
.sp .5
Request Summary . page
.em
.
.in 10
.ir 10
.
3REQUEST SUMMARY*
.sp 2
.table 12
3Key to Argument Descriptions*
.sp
.ta 10+5 10+10 10+13 10+18
.arg_notations
.sp 2
.reqtabs
.
.am req_summary
\.em
.end_keep
.em
.
.reqsumh
.
.de temp_header
.reqsumh
.sp
.ns
.em
.
.st temp_header top_margin_size!m
.
.req_summary
.rt temp_header
.ir 0
.in 0
.bp
.am table_of_contents
.sp .5
Control Character Summary . page
.em
3CONTROL CHARACTER SUMMARY*
.sp 2
.ir 10
.cc_sum_header
.sp 2
.cc_summary
.ir 0
.end_table
.
.nr icount 0
.de index  req page
	\0 . \1	
.if \+icount==4
. nr icount 0
. br
.en
.em
.am table_of_contents
.do_index
.em
.
.wf toc
.wl .sr left_heading left_heading
.wl .sr right_heading right_heading
.wl .de table_of_contents
.wm table_of_contents
.wl .em
.we
.
.de do_index
.sp 3
Request Index
.sp 2
.new_font 0
.in 0
.ir 0
.ta .5i 1.5i 2i 3i 3.5i 4.5i 5i 6i
.fi
.so rman.index
.nf
.new_font 7
.em
.
.nr verbose 1
