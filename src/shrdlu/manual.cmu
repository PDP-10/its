








                             PROVISIONAL

                        SHRDLU USERS' MANUAL

                             (Version 0)



                   S. Card, A. Rubin, T. Winograd







                          For CMU-1 Version
                            10/50 Monitor


                           August 14, 1972
                     Carnegie-Mellon University
                        Pittsburgh, Pa 15213
BRIEF DESCRIPTION OF SHRDLU
---------------------------


         SHRDLU IS A SYSTEM FOR THE  COMPUTER  UNDERSTANDING
    OF  ENGLISH.    THE  SYSTEM  ANSWERS QUESTIONS, EXECUTES
    COMMANDS, AND  ACCEPTS  INFORMATION  IN  NORMAL  ENGLISH
    DIALOG.    IT  USES  SEMANTIC INFORMATION AND CONTEXT TO
    UNDERSTAND DISCOURSE AND TO DISAMBIGUATE SENTENCES.   IT
    COMBINES  A COMPLETE SYNTACTIC ANALYSIS OF EACH SENTENCE
    WITH A "HEURISTIC  UNDERSTANDER"  WHICH  USES  DIFFERENT
    KINDS  OF  INFORMATION  ABOUT A SENTENCE, OTHER PARTS OF
    THE DISCOURSE, AND GENERAL INFORMATION ABOUT  THE  WORLD
    IN DECIDING WHAT THE SENTENCE MEANS.

         SHRDLU  IS  BASED  ON  THE  BELIEF  THAT A COMPUTER
    CANNOT DEAL  REASONABLY  WITH  LANGUAGE  UNLESS  IT  CAN
    "UNDERSTAND"  THE  SUBJECT IT IS DISCUSSING. THE PROGRAM
    IS GIVEN A DETAILED MODEL OF THE KNOWLEDGE NEEDED  BY  A
    SIMPLE  ROBOT  HAVING  ONLY A HAND AND AN EYE.  THE USER
    CAN GIVE IT  INSTRUCTIONS  TO  MANIPULATE  TOY  OBJECTS,
    INTERROGATE  IT ABOUT THE SCENE, AND GIVE IT INFORMATION
    IT WILL USE IN DEDUCTION.  IN ADDITION  TO  KNOWING  THE
    PROPERTIES  OF  TOY  OBJECTS,  THE  PROGRAM HAS A SIMPLE
    MODEL OF  ITS  OWN  MENTALITY.    IT  CAN  REMEMBER  AND
    DISCUSS ITS PLANS AND ACTIONS AS WELL AS CARRY THEM OUT.
    IT ENTERS INTO A DIALOG WITH  A  PERSON,  RESPONDING  TO
    ENGLISH  SENTENCES WITH ACTIONS AND ENGLISH REPLIES, AND
    ASKING FOR CLARIFICATION  WHEN  ITS  HEURISTIC  PROGRAMS
    CANNOT  UNDERSTAND A SENTENCE THROUGH USE OF CONTEXT AND
    PHYSICAL KNOWLEDGE.

         IN THE PROGRAMS, SYNTAX, SEMANTICS,  AND  INFERENCE
    ARE INTEGRATED IN A "VERTICAL" SYSTEM IN WHICH EACH PART
    IS CONSTANTLY COMMUNICATING WITH THE OTHERS. SHRDLU USES
    SYSTEMIC  GRAMMAR, A TYPE OF SYNTACTIC ANALYSIS WHICH IS
    DESIGNED  TO  DEAL  WITH   SEMANTICS.      RATHER   THAN
    CONCENTRATING  ON  THE EXACT FORM OF RULES FOR THE SHAPE
    OF LINGUISTIC  CONSTITUENTS,  IT  IS  STRUCTURED  AROUND
    CHOICES   FOR  CONVEYING  MEANING.    IT  ABSTRACTS  THE
    RELEVANT FEATURES OF THE LINGUISTIC STRUCTURES WHICH ARE
    IMPORTANT FOR INTERPRETING THEIR MEANING.

         IN  SHRDLU  MANY KINDS OF KNOWLEDGE ARE REPRESENTED
    IN THE FORM OF PROCEDURES RATHER THAN TABLES OF RULES OR
    LISTS  OF  PATTERNS.    BY DEVELOPING SPECIAL PROCEDURAL
    LANGUAGES FOR GRAMMAR, SEMANTICS, AND  DEDUCTIVE  LOGIC,
    THE  FLEXIBILITY  AND  POWER OF PROGRAMMING LANGUAGES IS
    GAINED    WHILE    RETAINING    THE    REGULARITY    AND
    UNDERSTANDABILITY  OF SIMPLER RULE FORMS.  EACH PIECE OF
    KNOWLEDGE CAN BE A PROCEDURE, AND CAN CALL ON ANY  OTHER
    PIECE OF KNOWLEDGE IN THE SYSTEM.
IMPLEMENTATION AND VERSION INFORMATION
--------------------------------------



	SHRDLU  WAS  PROGRAMMED  AT   THE   MIT   ARTIFICIAL
    INTELLIGENCE  LABORATORY  BY  T.   WINOGRAD AS PART OF A
    DOCTORAL DISSERTATION IN MATHEMATICS.

	THE PROGRAM WAS MODIFIED DURING THE LAST YEAR BY  T.
    WINOGRAD,  D.  MACDONALD, J. HILL, AND S. CARD TO CHANGE
    SOME OF ITS INTERNAL REPRESENTATIONS  AND  TO  MAKE  THE
    CODE  EASIER  TO UNDERSTAND FOR PERSONS WISHING TO STUDY
    THE PROGRAM.  NO MAJOR ATTEMPTS WERE  MADE  TO  INCREASE
    ITS POWER.

	THE PROGRAM RUNNING AT C-MU IS THE MODIFIED VERSION.
    THE DISPLAY FACILITIES OF  THE  PROGRAM  HAVE  NOT  BEEN
    IMPLEMENTED  AT  C-MU.  THE PROGRAM WAS COAXED AWAY FROM
    MIT'S  INCOMPATIBLE  TIME-SHARING   SYSTEM   (ITS)   AND
    CONVERTED  TO RUN UNDER THE DEC TOPS10 (10-50) OPERATING
    SYSTEM BY CONVERTING MACLISP ITSELF  (AND  TO  DO  THAT,
    CONVERTING  THE  MIDAS  ASSEMBLY LANGUAGE).  THE MACLISP
    CONVERSION WAS DONE BY GEORGE ROBERTSON.

THE VERSION OF SHRDLU BEING DISTRIBUTED FROM  CMU  IS  NAMED
    THE  C1  VERSION.  IT IS CURRENT WITH THE MIT VERSION TO
    JUNE 1972.  THE SHOW AND TELL USER INTERFACE AND VARIOUS
    CHANGES   WERE  ADDED  FOR  THE  C-MU  WORKSHOP  ON  NEW
    TECHNOLOGIES IN COGNITIVE RESEARCH IN JUNE 1972.

	SHRDLU IS  WRITTEN  IN  MACLISP  1.6  (VINTAGE  JUNE
    1972).  IT USES ABOUT 100 TO 140K 36-BIT WORDS OF MEMORY
    ON A PDP-10.
THE SHRDLU DISTRIBUTION PACKAGE
-------------------------------

	A  distribution  package  of  the C1 system has been
    make up containing basically

	1. a SAV copy of MACLSP which runs under a version
	of the DEC 10/50 monitor on a PDP-10. TRACE and GRIND
	files are also included.

	2.  a MICROPLANNER (EXPR version)

	3.  a SHRDLU, in two parts.

Together  these constitute a SHRDLU Kit from which it should
    be possible to fashion a full SHRDLU  or  a  parser-only
    system  or  a  MICROPLANNER.   It  is  thought  that the
    package has a good chance of running on any (unmodified)
    10/50  system  or  on  any  other  system  with  a fully
    compatible MACLISP (ha!).

The system currently running at C-mu uses 134K of core,  but
    with  hand  editing this should go down to 100k.  Please
    note that a SAVE file of the system occupies between 800
    and  1000  blocks  of  disk  space.  A SAVE file is not,
    therefor, even remotely close to fitting onto a DECTAPE.

MACLISP:
	MACLISP  has  not been completely implemented.  This
    version is, however, sufficient to run SHRDLU.  A couple
    perversities:

	1. most LISP control characters don't work.  To
	do a <control g> type (IOC G).

	2. Because of an incompatibility problem, UWRITE files
	and (IOC B) printer output are double spaced.

	3. occasionally the garbage collector fails.
	(IOC D) makes it print out every time it is garbage-
	collecting so you can usually figure out what 
	happened.  (IOC C) turns off this printout.  To
	get around the garbage collector's always failing 
	in the same place in your program, try forcing
	a garbage collect with (GC) so that it gets to
	garbage collect in some other part of your program. 

It is possible to obtain a version of MICROPLANNER which has
    been  compliled  into  LAP  in which case you need a LAP
    loader (which comes in both LAP and EXPR versions).  The
    LISP  compiler does work in 10-50 MACLISP so if you want
    to roll your own that is available too.   All of this is
    another good couple of DECTAPES.

SHRDLU is distributed as 2 large files to prevent parts from
    falling off and for ease  in  loading.   The  boundaries
    between  the  traditional  SHRDLU files used for editing
    are indicate by (e.g.)  ;;;[S->GLOBAL]  which  indicates
    the  Start  of a subfile called GLOBAL.  TECO buffs take
    note.

CAVEAT EMPTOR
-------------

This  set  of  probrams  is  distributed  in  the  cause  of
    dissemination of research.  There is no warranty  either
    expressed  or  implied  for  labor, parts, or servicing.
    Various bugs are known to lurk in  the  systems:  SHRDLU
    bugs  +  MICROPLANNER bugs + MACLISP bugs + MIDAS bugs +
    conversion  bugs   +   Monitor   bugs   +   installation
    incompatability  bugs  +  hardware bugs. Furthermore the
    system is presently in a state  of  development  (active
    and  suspended)  with various uncompleted projects here,
    notes to friends there, etc.

ASSEMBLING YOUR SHRDLU KIT
--------------------------

Before you begin assembling a SHRDLU it is probably wise  to
    get a listing of all of files (except MACLSP!!!).  Start
    by listing this one.  It is also helpful to transfer all
    of  the  files  to  dsk.  The names are designed so that
    this  can  be  done  with  pip  in   few   instructions.
    BEWARE!!!!  when  moving MACLSP around with PIP remember
    to use the /B switch.

Also note that the alt-mode which MACLSP looks for  to  tell
    it  that  you are through doing allocation is an 033 and
    not a 175 or 176.  The MACLISP editor also  requires  an
    033.   If  you  don't  have one type <space> after every
    allocation opportunity when entering MACLSP.  And  don't
    type (EDIT) or you'll get stuck.

Below  is  the  TTY listing for building a SHRDLU.  What you
    type is indicated in lower case letters, what  it  types
    in capitals.


..........STEP 1: Reading in and allocating MACLSP
.run dsk:maclsp

BIG NUMBER LISP 229
ALLOC? y
CORE = 26       170
FXS = 2000      $

*

..........STEP 2: Reading in MICROPLANNER

(uread plnr c1)
(DSK +)
(ioc q)
T

COMMENT

C1

DECLARE

    .
    .
    .
   etc


..........STEP 3: Reading in Trace and GRIND files

(uread trace c1)
(DSK +)
(ioc q)
T

TRACE 16, LOADING:
(? ?? REMTRACE UNTRACE TRACE)
FOR EXPLANATION, TYPE
(?)
(uread grind c1)
(DSK +)
(ioc q)
T
LOADING GRIND C1
*
(uread grinit c1)
(DSK +)
(ioc q)
T

BUILD

(ERT ERTSTOP ERTERR GLOBAL-ERR BUG SAY)

PDEFINE

DEFS

(OBJECT RELATION)

(thinit)

((PRINT (QUOTE MICRO-PLANNER)) (PRINC THVERSION) (COND ((ERRSET (APPLY
 (QUOTE UREAD) (APPEND (QUOTE (/.PLNR/. /(INIT/))) (CRUNIT))) NIL) (SE
TQ ERRLIST (CDDDDR ERRLIST)) (SETQ THTREE NIL) (SETQ THLEVEL NIL) (THE
RT TH%0% READING /.PLNR/. /(INIT/)))) (SETQ ERRLIST (CDDDDR ERRLIST)) 
(SETQ THINF NIL) (SETQ THTREE NIL) (SETQ THLEVEL NIL) (THERT TOP LEVEL
))

..........STEP3-1/2: Arming MICROPLANNER - This MUST be done to
           activate Macro-characters for subsequent readins

(ioc q)QUIT
MICRO-PLANNER C1
>>>  TOP-LEVEL
LISTENING  THVAL
..........STEP 3-3/4: (OPTIONAL) This is a good place to do a 
           SAVE to hedge against subsequent disaster.

^C
.sav dsk:shrdlu
JOB SAVED

.start


>>>  TOP LEVEL
LISTENING  THVAL

..........STEP 4: Reading first SHRDLU file

(uread shrdl1 c1)
DSK ")
(ioc q)
T

ERT

ERTEX

PRINT2

   .
   .
   .
  ETC


..........STEP 5: Reading 2nd SHRDLU file

(uread shrdl2 c1)
(DSK ")
(ioc q)
T
ABSVAL

   .
   .
   .
  etc

..........STEP 6: Arming SHRDLU 

(ioc g)
(ioc g)QUIT

..........STEP 7: INITIAL switch settings. Don't you dare.

      At this point SHRDLU will print out a list of some
      its internal switches and invite you to change them.
      The first time you run the program you should probably
      leave them as they are (type space after each arrow).
      Within SHRDLU these same switches can be changed
      with the TELL command.  Or, if you insist, this same
      display can be brought back by evaluating (SW).

      Then SHRDLU will print
READY

..........STEP 8: Saving SHRDLU


      Save immediately before you mung up the nice clean
      core image inside by playing with it.

^C
.sav dsk:shrdlu
JOB SAVED


..........STEP 9: Playing with SHRDLU.


.start



READY
      Now SHRDLU wants to eat a sentence.  And please don't
      forget the proper punctuation, especially the terminal
      punctuation mark at the end. Type sentences in
      upper case.  A capitalization is indicated by (e.g.) =A.
      This is useful for getting proper nouns across to
      the program.  The beginning of a sentence need not be capitalized.

      See Appendices 2 through 6 for examples
 To see if program is running try
      doing

<control x>
LISTENING---> tell parsing node on
*
LISTENING---> <CONTROL X>
READY
PICK UP A BIG RED BLOCK.

      The parser should start happily spewing forth 
      trace messages.





INSTRUCTIONS FOR RUNNING SHRDLU
-------------------------------

     SHRDLU can be in 4 basic states, COMMAND, READY, RUN,
and REQUEST.  It is initially in COMMAND when loaded.
***
******COMMAND STATE
***
     In this state, SHRDLU expects the user to type a command.
It lets you know this by typing "LISTENING-->".
A command is a line containing one or more words, separated by 
spaces and terminated by a carriage return (<CR>).  The first
word must be one of the three words SHOW, TELL, or GO.  The
SHOW command is used to ask the system to show such things
as definitions, structures it is building, and the states of various
parameters and switches.  TELL is used to tell the system new
definitions and settings.
     After executing a COMMAND, the system is ready for
another one, and prompts by saying LISTENING-->.
You can leave COMMAND state by typing <CONTROL X>
instead of a command.  This will cause the program to continue
whatever it was doing before it entered COMMAND
state, or to go to READY state if it was not already in the
process of analyzing a sentence.  If instead, you type the
command "GO", it will drop the sentence it is working on, and go 
into READY state for a new one.
****
******COMMAND FORMATS
****
     The SHOW and TELL commands are based on a ZOG-like tree
(one tree for each).  The first word of the command is SHOW
or TELL, the second names a node in the corresponding tree,
and the rest are any arguments appropriate to the action
at that node.
For example, the command:

SHOW FUNCTION MEET

will display the contents of the LISP function "MEET".

SHOW SHOW

displays the "SHOW" tree, while for the "TELL" tree, you type

SHOW TELL

     If all of the arguments are not specified, the system will
request more.  For example, typing:
SHOW FUNCTION
would cause it to type out:
FUNCTION:
requesting the name of a function from the user.  It is then
in REQUEST state (see below.)
     Non-terminal nodes of the tree may or may not have corresponding
actions.  For example, the command

TELL PLANNER OFF

causes the entire batch of PLANNER tracing devices to be turned off
at once, even though there are subnodes of the PLANNER node which
can be used to turn individual features on and off selectively.
If there is no action associated with such a node, the system will
ask the user to select one of its subnodes.
     If you type "SHOW" or "HELP" followed by a carriage return,
it will guide you through the choices, using REQUESTS
(see below).
*****
*****REQUEST STATE
*****
     SHRDLU can request two kinds of information from
the user.  If it wants him to CHOOSE between a set of alternatives,
it will end the request with a ?.  If it wants him to SPECIFY 
a name or list of names, it will end it with a :.
     For a CHOOSE, all it needs is enough information to decide
between the alternatives.  Begin typing your choice, and when it
is complete enough, type a <control x>.  If you type fewer
letters than necessary (e.g. typing just a P, when PLANNER
and PARSING are among the choices) it will ring the bell and wait
for you to continue.  If you type more than necessary it doesn't
matter.
     For a SPECIFY, type the required response, terminated by a
<CR>.  If you type a <CR> with nothing else, it will take some
default response which is appropriate to the action (For example,
typing a <CR> in response to a request for which properties of an
atomare to be displayed will have the effect of displaying
all of them.
    For either SPECIFY or CHOOSE, you can get more information on
what is expected by typing a ?<CR>.  It will then give you the 
request again.  Typing QUIT<CR> at a "SPECIFY" REQUEST or QUIT
<CONTROL X> at a "CHOOSE" REQUEST will cause the entire command
of which it was a part to be discarded without finishing,
returning to COMMAND state.
*****
******READY STATE
*****
     The READY state is entered only when a new English sentence is to
be input.  You can tell you are in it when the sytem types
READY
Respond by typing in an English sentence in normal punctuation
(i.e. ending with a question mark or period) followed by a <CR>.
The system will automatically begin processing it, entering
RUN state.  To get into a COMMAND state while entering a sentence,
type a <CONTROL X>.
*****
******RUN STATE
*****
     Whenever a sentence is input, the system begins to RUN.  It
will stop at selected places, entering COMMAND state so the user can
SHOW things and TELL it things before continuing.  There are various
TELL commands which explain how to change these stopping points.
When a <CONTROL X> is typed at the COMMAND, the system returns to RUN
and continues.
*****
*******ABBREVIATIONS
*****
     Any word which appears in the SHOW or TELL trees can be
abbreviated by typing its first two letters.  For example,
our first command above could have been abbreviated as:
SH FU MEET
Note that arguments cannot be abbreviated since the system has no
list to check the abbreviations against.  This is also true
of responses to a "SPECIFY" REQUEST.  Responses to a "CHOOSE" REQUEST
are abbreviated by typing any initial letter string followed by
<CONTROL X> as described above.
*****
*****
To  see examples of the various commands, run one of the demonstration
programs.  They inclde explanatory comments.


SOME FACTS ABOUT THE PROGRAM
----------------------------

1. PARSER
	SHRDLU calls the parser by calling

	(PARSE <CONSTITUENT-CLASS> LIST-OF-SEMANTIC-FEATURES)

	This causes the 'PROGRAMMAR' program which embodies
the grammar for that constituent-class to be run.  Turning
on the parser trace causes a message 'PASSING ...' to
print out as each node in the grammar for the
constituent-class is passed (with a flowchart or program
listing of the grammar you can follow the parsing path
through it).

	At various points the grammar calls on 'Semantic
Specialists' with the

	(CALLSM <SEMANTIC-SPECIALIST>)

function.  If this function returns NIL, the Semantic-Specialist
objected to the parse.

	As the parser progresses it builds and rebuilds a 
parser-tree whose nodes are labeled NODE1, NODE2, ... etc.
When the parse-trace is turned on, these nodes are displayed
whenever they are created or changed.

	The parse-tree is really a complex data structure to
which the syntactic and semantic routines contribute
information as it is developed.

	An important concept is that the surface structure of
the sentence is never destroyed.  The parse-node itself
contains pointers to the beginning (FIRSTWORD) and end
(WORDAFTER) of the constituent in the surface structure.
Whenever the grammar finds it has been partially fooled
and must try another parsing it adjusts these pointers.


2. SEMANTIC-SPECIALISTS

	Part of the work of the Semantic Specialists is to build up
interpretive semantic structures as the parsing of the sentence
proceeds.  The semantic structures built include OSS'S (Object
Semantic Structures), RSS'S (Relational Semantic Structures, TSS's
(Time Semantic Structures) and ANS's (Answer Semantic Structures).
	The Semantic Specialists are all entered through the function

	(CALLSM <SEMANTIC-SPECIALIST>) 

from the gramar.


3. INFERENCE MECHANISM - PLANNER

	SHRDLU makes all references to its world model
through the function 

	(THVAL2 <MICROPLANNER-STATEMENT>).
REFERENCES FOR MORE INFORMATION
-------------------------------

MACLISP
	1. MIT AI Memo 116A PDP-6 LISP (LISP 1.6) 
	2. MIT AI Memo 190 - Interim LISP Users' Guide
	3. LISP INFO update file

The first 2 can only be obtained from the MIT AI Laboratory.
The last is available for this version of MACLISP from me (S.C.) at CMU) as well.
These documents contain what you have to know to really use
MACLISP as a programming system (provided you already know
how to use LISP before you read them).  They are probably not
necessary to run SHRDLU (until you get into trouble).

MICROPLANNER
	1. Winograd's thesis is the best introduction to it.
	2. A manual is available from MIT AI Laboratory.
	3. Ira Goldstein (MIT AI Laboratory) has an excellent
	    demonstration program for teaching it.  
	4. For the real PLANNER stuff there's Hewett's Thesis
	   which has been printed and is available from MIT AI Lab.
	5. Hewett also has several AI Memos and papers in the
	   two Int'l Conferences on AI.

	6. Sussman and McDermott and there
	   friends have recently created a warring siblisng
	   to PLANNER called CONNIVER which is explained in
	   two AI Memos.

SHRDLU
	1. Winograd's thesis has been published in various
	   forms including as issue of
	   COGNITIVE PSYCHOLOGY and a book.

	2. You are currently reading what is probably the
	   most obscure SHRDLU reference.

APPENDIX 1
----------
I

      ****** SHRDLU States and What They Want    *****

READY   (types out READY)
     English sentence ended with punctuation, followed by <CR>
        or <CONTROL X> to go to COMMAND
COMMAND  (types out LISTENING--->)
     Command terminated by <CR>
      or <CONTROL X> to proceed program
      or GO<CR> to prepare for new sentence
REQUEST  (types out request)
   CHOOSE (request ends with ?)
     Enough of any choice to specify it, followed by
          <CONTROL X>
        or ?<CONTROL X> to see information and choices
        or QUIT<CONTROL X> to abort command
   SPECIFY   (request ends with :)
     Name or list, ended with <CR>
        or just <CR> for default value (if appropriate)
        or QUIT<CR> to abort command
        or ?<CR> for info
Abbreviate commands by first two letters.






@
APPENDIX 2:  
----------

PARSER TRACES EXAMPLE
======================
(NOTE ^X MEANS <CONTROL-X>)
LISTENING---> SHOW

(SHOW TELL LISP PLANNER PARSING DEFINITIONS INPUT) 
WHICH OPTION? SHOW
CANSHOW
       SHOW
       TELL
       LISP
               PROPERTY
               FUNCTION
               VALUE
       PLANNER
               ASSERTIONS
               THEOREM
               SCENE
       PARSING
               NODE
               TREE
       DEFINITIONS
               UNIT
               WORD
               MARKER
       INPUT
               ALL
               REST
               CURRENT
* 
LISTENING---> SHOW SCENE
  CURRENT SCENE

:B1 -->  A SMALL RED BLOCK  AT (110 100 0)SUPPORTS (:B2)
:B2 -->  A SMALL GREEN PYRAMID  AT (110 100 100)
:B3 -->  A LARGE GREEN BLOCK  AT (400 0 0)SUPPORTS (:B5)
:B4 -->  A LARGE BLUE PYRAMID  AT (640 640 1)
:B5 -->  A SMALL RED PYRAMID  AT (500 100 200)
:B6 -->  A LARGE RED BLOCK  AT (0 300 0)SUPPORTS (:B7)
:B7 -->  A LARGE GREEN BLOCK  AT (0 240 300)
:B10 -->  A LARGE BLUE BLOCK  AT (300 640 0)
:BOX -->  A LARGE WHITE BOX  AT (600 600 0)SUPPORTS (:B4)
THE HAND IS GRASPING  NOTHING
* 
LISTENING---> TELL PARSING 

(NODE LABEL ATTEMPT)
WHICH OPTION? NODE
ON OR OFF? ON
LISTENING---> TELL SEMANTICS

DO SEMANTIC ANALYSIS? YES
SHOW BUILDING OF SEMANTIC STRUCTURES? NO
* 
LISTENING---> TELL PLANNER OFF

* 
LISTENING---> TELL PL

(INPUT ACTION THEOREM ASSERTIONS) 
WHICH OPTION? INPUT
ON OR OFF? ON
* 
* 
LISTENING---> GO
QUIT
READY 
PICK UP A BIG RED BLOCK.

[1] 

[NODE1]
   SEMANTICS      NIL
   DAUGHTERS      NIL
   WORDAFTER      (PICK UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (TOPLEVEL MAJOR CLAUSE)

>>> 
LISTENING--->TE AT ON

* 
LISTENING---> 
PASSING ENTERING-CLAUSE

[TSS1]
   TSSNODE=       TSS1

>>> 
LISTENING---> 
PASSING INIT
PASSING MAJOR
PASSING THEREINIT
PASSING THER2
(1 ENTER PARSE (NG TIME)) 

[NODE2]
   SEMANTICS      NIL
   DAUGHTERS      NIL
   WORDAFTER      (PICK UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (TIME NG)

>>> 
LISTENING---> 
PASSING ENTERING-NG
PASSING NGSTART
PASSING TIME
PASSING FAIL
(1 EXIT PARSE NIL) 
PASSING CLAUSETYPE
(1 ENTER PARSE (VG IMPER)) 

[NODE3]
   SEMANTICS      NIL
   DAUGHTERS      NIL

   WORDAFTER      (PICK UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (IMPER VG)

>>> 
LISTENING---> 
PASSING ENTERING-VG
PASSING IMPER
(2 ENTER PARSE (VB DO NEG INF)) 
(2 EXIT PARSE NIL) 
(2 ENTER PARSE (VB (MVB) INF)) 

[NODE4]
   SEMANTICS      ((TRANS (#NOTICE)))
   DAUGHTERS      WORD
   WORDAFTER      (UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (VPRT VB INF TRANS MVB)

>>> 
LISTENING---> 

[NODE3]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE4)
   WORDAFTER      (UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (IMPER VG)

>>> 
LISTENING---> 
(2 EXIT PARSE (NODE3)) 
PASSING RETURN

[NODE3]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE4)
   WORDAFTER      (UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (VG IMPER)

>>> 
LISTENING---> 

[NODE1]
   MVB            (NODE4)
   TIME   TSS1
   PARENT         NIL
   SEMANTICS      NIL
   DAUGHTERS      (NODE3)
   WORDAFTER      (UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (TOPLEVEL MAJOR CLAUSE)

>>> 
LISTENING---> 
(1 EXIT PARSE (NODE3)) 
PASSING VG1
(1 ENTER PARSE (PRT)) 

[NODE5]
   SEMANTICS      T
   DAUGHTERS      WORD
   WORDAFTER      (A BIG RED BLOCK)
   FIRSTWORD      (UP A BIG RED BLOCK)
   FEATURES       (PRT)

>>> 
LISTENING---> 

[NODE1]
   MVB            (NODE4)
   TIME   TSS1
   PARENT         NIL
   SEMANTICS      NIL
   DAUGHTERS      (NODE5 NODE3)
   WORDAFTER      (A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (ACTV IMPER TOPLEVEL MAJOR CLAUSE)

>>> 
LISTENING---> SHOW TREE

NODE-SPECIFICATION: C
(((PICK UP) (ACTV IMPER TOPLEVEL MAJOR CLAUSE)
             NIL
             (((PICK) (VG IMPER) NIL ((PICK (VPRT VB INF TRANS MVB))))
              (UP (PRT))))
 NIL)
* 
LISTENING---> 
(1 EXIT PARSE (NODE1)) 
PASSING TRANSP
(1 ENTER PARSE (NG OBJ OBJ1)) 

[NODE6]
   SEMANTICS      NIL
   DAUGHTERS      NIL
   WORDAFTER      (A BIG RED BLOCK)
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (OBJ1 OBJ NG)

>>> 
LISTENING---> 
PASSING ENTERING-NG
PASSING NGSTART
PASSING LOOK
PASSING DET
(2 ENTER PARSE (DET)) 

[NODE7]
   SEMANTICS      T
   DAUGHTERS      WORD
   WORDAFTER     (A BIG RED BLOCK)

   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (DET NS INDEF)

>>> 
LISTENING---> 

[NODE6]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE7)
   WORDAFTER      (BIG RED BLOCK)
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (OBJ1 OBJ NG)

>>> 
LISTENING---> 
(2 EXIT PARSE (NODE6)) 
PASSING IND
PASSING ADJ
(2 ENTER PARSE (ADJ)) 

[NODE10]
   SEMANTICS      (OBJECT 
                      (MARKERS: (#PHYSOB #BIG) 
                       PROCEDURE: ((#MORE #SIZE
                                          ***
                                          (200 200
                                               200)))))
   DAUGHTERS      WORD
   WORDAFTER      (RED BLOCK)
   FIRSTWORD      (BIG RED BLOCK)
   FEATURES       (ADJ)

>>> 
LISTENING---> 

[NODE6]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE10 NODE7)
   WORDAFTER      (RED BLOCK)
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (INDEF NS DET OBJ1 OBJ NG)

>>> 
LISTENING---> 
(2 EXIT PARSE (NODE6)) 
PASSING ADJ
(2 ENTER PARSE (ADJ)) 

[NODE11]
   SEMANTICS      (#COLOR #RED)
   DAUGHTERS      WORD
   WORDAFTER      (BLOCK)
   FIRSTWORD      (RED BLOCK)
   FEATURES       (ADJ)

>>> 
LISTENING---> 

[NODE6]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE11 NODE10 NODE7)
   WORDAFTER      (BLOCK)
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (INDEF NS DET OBJ1 OBJ NG)

>>> 
LISTENING---> SHOW CURRENT

A BIG RED 
* 
LISTENING---> 
(2 EXIT PARSE (NODE6)) 
PASSING ADJ
(2 ENTER PARSE (ADJ)) 
(2 EXIT PARSE NIL) 
PASSING CLASF
(2 ENTER PARSE (VB ING (CLASF))) 
(2 EXIT PARSE NIL) 
(2 ENTER PARSE (VB EN (CLASF))) 
(2 EXIT PARSE NIL) 
(2 ENTER PARSE (CLASF)) 
(2 EXIT PARSE NIL) 
PASSING NOUN
(2 ENTER PARSE (NOUN)) 

[NODE12]
   SEMANTICS      (OBJECT 
                      (MARKERS: (#MANIP
                                 #RECTANGULAR) 
                       PROCEDURE: ((#IS *** #BLOCK))))
   DAUGHTERS      WORD
   WORDAFTER      NIL
   FIRSTWORD      (BLOCK)

   FEATURES       (NOUN NS)

>>> 
LISTENING---> 

[NODE6]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE12 NODE11 NODE10 NODE7)
   WORDAFTER      NIL
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (INDEF NS DET OBJ1 OBJ NG)

>>> 
LISTENING---> 
(2 EXIT PARSE (NODE6)) 
PASSING SMNG
(1 ENTER CALLSM ((SMNG1))) 

>>> 
LISTENING---> 
(1 EXIT CALLSM (OSS4)) 
PASSING RETSM
(1 ENTER CALLSM ((SMNG2))) 
(1 EXIT CALLSM (OSS4)) 
PASSING RETURN

[NODE6]
   HEAD   (NODE12 NODE11 NODE10 NODE7)
   PARENT         (NODE1)
   SEMANTICS      (OSS4)
   DAUGHTERS      (NODE12 NODE11 NODE10 NODE7)
   WORDAFTER      NIL
   FIRSTWORD      (A BIG RED BLOCK)

   FEATURES       (NG OBJ OBJ1 DET NS INDEF)

>>> 
LISTENING---> 

[NODE1]
   MVB            (PICK-UP)
   TIME   TSS1
   PARENT         NIL
   SEMANTICS      NIL
   DAUGHTERS      (NODE6 NODE5 NODE3)
   WORDAFTER      NIL
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (PRT ACTV
                       IMPER
                       TOPLEVEL
                       MAJOR
                       CLAUSE)

>>> 
LISTENING---> SHOW WORD PICK-UP


[PICK-UP]
   FEATURES       (COMBINATION TRANS)
   SEMANTICS      ((TRANS
                    (RELATION 
                        (RESTRICTIONS: (((#ANIMATE))
                                        ((#MANIP))) 
                         MARKERS: (#EVENT) 
                         PROCEDURE: ((#EVAL
                                      (COND
                                       ((MEMQ (NUMBER? SMOB1)
                                              '(1 NS))
                                        '(#PICKUP #2 *TIME))
                                       ('(#PUTIN
                                          #2
                                          :BOX
                                          *TIME)))))))))
   ROOT   (PICK UP)

>>> 
LISTENING---> 
* 
LISTENING---> 
(1 EXIT PARSE (NODE6)) 
PASSING OBB
PASSING FQPRT
PASSING ONT
(1 ENTER CALLSM ((SMCL1))) 

>>> 
LISTENING---> 
(1 EXIT CALLSM (RSS1)) 
PASSING RETSM
(1 ENTER CALLSM ((SMCL2))) 
(1 EXIT CALLSM (NODE6 NODE5 NODE3)) 
PASSING RETURN

[NODE1]
   OBJ1   (NODE6 NODE5 NODE3)
   MVB            (PICK-UP)
   TIME   TSS1
   PARENT         NIL
   SEMANTICS      (RSS1)
   DAUGHTERS      (NODE6 NODE5 NODE3)
   WORDAFTER      NIL
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (CLAUSE MAJOR
                          TOPLEVEL
                          IMPER
                          ACTV
                          PRT
                          TRANS)

>>> 
LISTENING---> SHOW TREE C

(((PICK UP A BIG RED BLOCK)
  (CLAUSE MAJOR TOPLEVEL IMPER ACTV PRT TRANS)
  (RSS1)
  (((PICK) (VG IMPER) NIL ((PICK (VPRT VB INF TRANS MVB))))
   (UP (PRT))
   ((A BIG RED BLOCK)
    (NG OBJ OBJ1 DET NS INDEF)
    (OSS4)
    ((A (DET NS INDEF)) (BIG (ADJ)) (RED (ADJ)) (BLOCK (NOUN NS))))))
 NIL)
* 
LISTENING---> 

(THAND (THGOAL (#PICKUP OSS4) (THDBF MUMBLE) (THUSE TC-2))
        (VALUEPUT)
        (SETQ SUCCESS T)
        (SETQ PLAN2 PLAN))
>>>  FOR PLANNER
OK.
APPENDIX 3
----------

THIS IS THE SEMANTIC STRUCTURES TRACE FOR "PICK UP A BIG RED BLOCK"
===================================================================
LISTENING---> SHOW

(SHOW TELL LISP PLANNER PARSING DEFINITIONS INPUT) 
WHICH OPTION? SHOW
CANSHOW
       SHOW
       TELL
       LISP
               PROPERTY
               FUNCTION
               VALUE
       PLANNER
               ASSERTIONS
               THEOREM
               SCENE
       PARSING
               NODE
               TREE
       DEFINITIONS
               UNIT
               WORD
               MARKER
       INPUT
               ALL
               REST
               CURRENT
* 
LISTENING---> SHOW SCENE
  CURRENT SCENE

:B1 -->  A SMALL RED BLOCK  AT (110 100 0)SUPPORTS (:B2)
:B2 -->  A SMALL GREEN PYRAMID  AT (110 100 100)
:B3 -->  A LARGE GREEN BLOCK  AT (400 0 0)SUPPORTS (:B5)
:B4 -->  A LARGE BLUE PYRAMID  AT (640 640 1)
:B5 -->  A SMALL RED PYRAMID  AT (500 100 200)
:B6 -->  A LARGE RED BLOCK  AT (0 300 0)SUPPORTS (:B7)
:B7 -->  A LARGE GREEN BLOCK  AT (0 240 300)
:B10 -->  A LARGE BLUE BLOCK  AT (300 640 0)
:BOX -->  A LARGE WHITE BOX  AT (600 600 0)SUPPORTS (:B4)
THE HAND IS GRASPING  NOTHING
* 
LISTENING---> TELL PARSING OFF

* 
LISTENING---> TELL SEMANTICS

DO SEMANTIC ANALYSIS? YES
SHOW BUILDING OF SEMANTIC STRUCTURES? YES
* 
LISTENING---> TELL PLANNER OFF

* 
LISTENING---> TELL PL

(INPUT ACTION THEOREM ASSERTIONS) 
WHICH OPTION? INPUT
ON OR OFF? ON
* 
LISTENING---> GO
QUIT
READY 
PICK UP A BIG RED BLOCK.

>>> 
LISTENING---> SH NODE C

[NODE3]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE4)
   WORDAFTER      (UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (VG IMPER)

>>>
LISTENING---> SHOW NODE C

[NODE6]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE12 NODE11 NODE10 NODE7)
   WORDAFTER      NIL
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (INDEF NS DET OBJ1 OBJ NG)


[OSS1]
   OSSNODE=       OSS1
   PARSENODE=     (NODE6)
   VARIABLE=      X1
   DETERMINER=    (NS INDEF NIL)

>>> 
LISTENING---> SH CU

A BIG RED BLOCK 
* 
LISTENING---> 

[OSS2]
   OSSNODE=       OSS2
   PARSENODE=     (NODE6)
   VARIABLE=      X1
   RELATIONS=     ((#IS OSS1 #BLOCK))
   DETERMINER=    (NS INDEF NIL)
   PLAUSIBILITY= 0
   SYSTEMS=       (#SHAPES #PHYSOB #THING #SYSTEMS)
   MARKERS=       (#SHAPES #RECTANGULAR
                           #SYSTEMS
                           #THING
                           #PHYSOB
                           #MANIP)

>>> 
LISTENING---> SHOW MA #SHAPES

#SHAPES
* 
LISTENING---> SHOW MA #PHYSOB

#PHYSOB
       #BOX
       #CONSTRUCT
               #STACK
               #ROW
       #HAND
       #MANIP
       #TABLE
* 
LISTENING---> 

[OSS3]
   OSSNODE=       OSS3
   PARSENODE=     (NODE6)
   VARIABLE=      X1
   RELATIONS=     ((#COLOR OSS2 #RED)
                   (#IS OSS1 #BLOCK))
   DETERMINER=    (NS INDEF NIL)
   PLAUSIBILITY=  0                     
   SYSTEMS=     (#SPECTRUM #SHAPES
                           #PHYSOB
                           #THING
                           #SYSTEMS)
   MARKERS=       (#SPECTRUM #RED
                             #SHAPES
                             #RECTANGULAR
                             #SYSTEMS
                             #THING
                             #PHYSOB
                             #MANIP)

>>> 
LISTENING---> 

[OSS4]
   OSSNODE=       OSS4
   PARSENODE=     (NODE6)
   VARIABLE=      X1
   RELATIONS=     ((#MORE #SIZE OSS3 (200 200 200))
                   (#COLOR OSS2 #RED)
                   (#IS OSS1 #BLOCK))
   DETERMINER=    (NS INDEF NIL)
   PLAUSIBILITY= 0
   SYSTEMS=       (#SPECTRUM #SHAPES
                             #PHYSOB
                             #THING
                             #SYSTEMS)
   MARKERS=       (#BIG #SPECTRUM
                        #RED
                        #SHAPES
                        #RECTANGULAR
                        #SYSTEMS
                        #THING
                        #PHYSOB
                        #MANIP)

>>> 
LISTENING---> SHOW NODE C

[NODE1]
   MVB            (PICK-UP)
   TIME   TSS1
   PARENT         NIL
   SEMANTICS      NIL
   DAUGHTERS      (NODE6 NODE5 NODE3)
   WORDAFTER      NIL
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (PRT ACTV
                       IMPER
                       TOPLEVEL
                       MAJOR
                       CLAUSE)


[RSS1]
   PARSENODE=     (NODE1)
   RSSNODE=       RSS1
   VARIABLE=      EVX1
   RELATIONS=     ((#PICKUP OSS4 TSS1))
   PLAUSIBILITY= 0
   SYSTEMS=       (#SYSTEMS)
   MARKERS=       (#SYSTEMS #EVENT)

>>> 
LISTENING---> SH NODE C

[NODE1]
   OBJ1   (NODE6 NODE5 NODE3)
   MVB            (PICK-UP)
   TIME   TSS1
   PARENT         NIL
   SEMANTICS      (RSS1)
   DAUGHTERS      (NODE6 NODE5 NODE3)
   WORDAFTER      NIL
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (CLAUSE MAJOR
                          TOPLEVEL
                          IMPER
                          ACTV
                          PRT
                          TRANS)

>>> 
LISTENING---> SHOW TREE C

(((PICK UP A BIG RED BLOCK)
  (CLAUSE MAJOR TOPLEVEL IMPER ACTV PRT TRANS)
  (RSS1)
  (((PICK) (VG IMPER) NIL ((PICK (VPRT VB INF TRANS MVB))))
   (UP (PRT))
   ((A BIG RED BLOCK)
    (NG OBJ OBJ1 DET NS INDEF)
    (OSS4)
    ((A (DET NS INDEF)) (BIG (ADJ)) (RED (ADJ)) (BLOCK (NOUN NS))))))
 NIL)
* 
LISTENING---> 

(THAND (THGOAL (#PICKUP OSS4) (THDBF MUMBLE) (THUSE TC-2))
        (VALUEPUT)
        (SETQ SUCCESS T)
        (SETQ PLAN2 PLAN))
>>>  FOR PLANNER
OK.
APPENDIX 4
----------

THIS IS THE INFERENCE TRACE FOR "PICK UP A BIG RED BLOCK."
===============================================================
 ]--> LOADING SHRDLU
         <CONTROL N> GETS BACK TO ZOG
>>> SHRDLU COMMAND STATE, TYPE HELP <CR> FOR INSTRUCTIONS.
LISTENING---> SHOW

(SHOW TELL LISP PLANNER PARSING DEFINITIONS INPUT) 
WHICH OPTION? SHOW
CANSHOW
       SHOW
       TELL
       LISP
               PROPERTY
               FUNCTION
               VALUE
       PLANNER
               ASSERTIONS
               THEOREM
               SCENE
       PARSING
               NODE
               TREE
       DEFINITIONS
               UNIT
               WORD
               MARKER
       INPUT
               ALL
               REST
               CURRENT
* 
LISTENING---> SHOW SCENE
  CURRENT SCENE

:B1 -->  A SMALL RED BLOCK  AT (110 100 0)SUPPORTS (:B2)
:B2 -->  A SMALL GREEN PYRAMID  AT (110 100 100)
:B3 -->  A LARGE GREEN BLOCK  AT (400 0 0)SUPPORTS (:B5)
:B4 -->  A LARGE BLUE PYRAMID  AT (640 640 1)
:B5 -->  A SMALL RED PYRAMID  AT (500 100 200)
:B6 -->  A LARGE RED BLOCK  AT (0 300 0)SUPPORTS (:B7)
:B7 -->  A LARGE GREEN BLOCK  AT (0 240 300)
:B10 -->  A LARGE BLUE BLOCK  AT (300 640 0)
:BOX -->  A LARGE WHITE BOX  AT (600 600 0)SUPPORTS (:B4)
THE HAND IS GRASPING  NOTHING
* 
LISTENING---> TELL PARSING OFF
* 
LISTENING---> TELL SEMANTICS

DO SEMANTIC ANALYSIS? YES
SHOW BUILDING OF SEMANTIC STRUCTURES? NO
* 
LISTENING---> TELL PLANNER OFF
* 
LISTENING---> GO
QUIT
READY 
PICK UP A BIG RED BLOCK.

* 
LISTENING---> 

(THAND (THGOAL (#PICKUP OSS4) (THDBF MUMBLE) (THUSE TC-2))
        (VALUEPUT)
        (SETQ SUCCESS T)
        (SETQ PLAN2 PLAN))
>>>  FOR PLANNER
LISTENING---> 
>>>  ENTERING FINDCHOOSE EXPR (OSS X ANS2)

* 
LISTENING---> SHOW VALUE OSS

OSS4
* 
LISTENING---> 
>>>  EXITING FINDCHOOSE
LISTENING---> SHOW VALUE X

:B6
* 
LISTENING---> SHOW PLANNER

(ASSERTIONS THEOREM SCENE) 
WHICH OPTION? ASSERTIONS
ATOM: ?

SHOW ALL ASSERTIONS WHICH CONTAIN THE GIVEN ATOM 
ATOM: :B6

(((#COLOR :B6 #RED)) ((#SHAPE :B6 #RECTANGULAR))
                      ((#SUPPORT :B6 :B7))
                      ((#AT :B6 (0 300 0)))
                      ((#IS :B6 #BLOCK))
                      ((#MANIP :B6))
                      ((#SUPPORT :TABLE :B6)))
* 
LISTENING---> TELL PLANNER ON

* 
LISTENING---> 
TRYING GOAL G1 (#PICKUP :B6)
>>> 
LISTENING---> 
ENTERING THEOREM TC-PICKUP
TRYING GOAL G2 (#GRASP :B6)
>>> 
LISTENING---> SHOW THEOREM TC-PICKUP

(THCONSE (X (WHY (EV)) EV) (#PICKUP $?X) 
          (MEMORY)

          (THGOAL (#GRASP $?X) (THUSE TC-GRASP))
          (THGOAL (#RAISEHAND) (THNODB) (THUSE TC-RAISEHAND))
          (MEMOREND (#PICKUP $?EV $?X)))
* 
ENTERING THEOREM TC-GRASP
TRYING GOAL G3 (#GRASPING :B6)
G3 FAILED 
TRYING GOAL G4 (#CLEARTOP :B6)
ENTERING THEOREM TC-CLEARTOP
TRYING GOAL G5 (#SUPPORT :B6 ?)
G5 SUCCEEDED ((#SUPPORT :B6 :B7))
TRYING GOAL G6 (#SUPPORT :B6 (THNV Y))
G6 SUCCEEDED ((#SUPPORT :B6 :B7))
TRYING GOAL G7 (#GET-RID-OF :B7)
ENTERING THEOREM TC-GET-RID-OF
TRYING GOAL G10 (#FINDSPACE :TABLE (200 200 200) :B7 (THNV Y))
ENTERING THEOREM TC-FINDSPACE
TC-FINDSPACE SUCCEEDED THNOVAL
G10 SUCCEEDED
ENTERING THEOREM TC-PUT
TRYING GOAL G12 (#GRASP :B7)
ENTERING THEOREM TC-GRASP

TRYING GOAL G13 (#GRASPING :B7)
G13 FAILED 
TRYING GOAL G14 (#CLEARTOP :B7)
G14 SUCCEEDED ((#CLEARTOP :B7))
TRYING GOAL G15 (#GRASPING (THNV Y))
G15 FAILED 
TRYING GOAL G16 (#MOVEHAND2 (100 340 500))
ENTERING THEOREM TC-MOVEHAND2
TC-MOVEHAND2 SUCCEEDED THNOVAL
G16 SUCCEEDED (#MOVEHAND2 (100 340 500))
ASSERTING A17 (#GRASPING :B7)
A17 SUCCEEDED 
ASSERTING A20 (#GRASP E5 :B7)
A20 SUCCEEDED 
TC-GRASP SUCCEEDED THNOVAL
G12 SUCCEEDED (#GRASP :B7)
>>> 
LISTENING---> SHOW PR E5


[E5]
   TYPE   #GRASP
   THASSERTION    (NIL (2 (3 1 ((#GRASP E5 :B7)))))
   END            1
   WHY            E4
   START          0

* 
TRYING GOAL G21 (#MOVEHAND (600 374 200))
ENTERING THEOREM TC-MOVEHAND
TRYING GOAL G22 (#GRASPING (THV X))
G22 SUCCEEDED ((#GRASPING :B7))
TRYING GOAL G23 (#AT :B7 (THNV W))
G23 SUCCEEDED ((#AT :B7 (0 240 300)))
ERASING E24 (#AT :B7 (0 240 300))
ENTERING THEOREM TE-SUPP
TRYING GOAL G25 (#SUPPORT :B7 (THNV Y))
G25 FAILED 
TRYING GOAL G26 (#SUPPORT (THNV Y) :B7)
G26 SUCCEEDED ((#SUPPORT :B6 :B7))
ERASING E27 (#SUPPORT :B6 :B7)
E27 SUCCEEDED 
TRYING GOAL G30 (#PART :B7 (THNV Y))
G30 FAILED 
TE-SUPP SUCCEEDED THNOVAL
ENTERING THEOREM TE-CONTAIN
TRYING GOAL G31 (#CONTAIN (THNV Y) :B7)
G31 FAILED 
TE-CONTAIN FAILED 
E24 SUCCEEDED 
ASSERTING A32 (#AT :B7 (500 274 0))
ENTERING THEOREM TA-AT
TA-AT SUCCEEDED THNOVAL
ENTERING THEOREM TA-SUPP
TRYING GOAL G33 (#MANIP :TABLE)
G33 FAILED 
ASSERTING A34 (#SUPPORT :TABLE :B7)
A34 SUCCEEDED 
TRYING GOAL G35 (#CLEARTOP :TABLE)
G35 FAILED 
TA-SUPP SUCCEEDED THNOVAL
ENTERING THEOREM TA-CONTAIN
TRYING GOAL G36 (#MANIP :B7)
G36 SUCCEEDED ((#MANIP :B7))
TRYING GOAL G37 (#SUPPORT (THV Y) :B7)
G37 SUCCEEDED ((#SUPPORT :TABLE :B7))
TRYING GOAL G40 (#IS :TABLE #BOX)
G40 FAILED 
TRYING GOAL G41 (#CONTAIN (THV Z) :TABLE)
G41 FAILED 
G37 FAILED 
G36 FAILED 
TA-CONTAIN FAILED 

A32 SUCCEEDED 
TRYING GOAL G42 (#MOVEHAND2 (600 374 200))
ENTERING THEOREM TC-MOVEHAND2
TC-MOVEHAND2 SUCCEEDED THNOVAL
G42 SUCCEEDED (#MOVEHAND2 (600 374 200))
TRYING GOAL G43 (#SUPPORT (THV Y) :B7)
G43 SUCCEEDED ((#SUPPORT :TABLE :B7))
TC-MOVEHAND SUCCEEDED THNOVAL
G21 SUCCEEDED (#MOVEHAND (600 374 200))
TRYING GOAL G44 (#UNGRASP)
ENTERING THEOREM TC-UNGRASP
TRYING GOAL G45 (#GRASPING (THV X))
G45 SUCCEEDED ((#GRASPING :B7))
TRYING GOAL G46 (#SUPPORT ? :B7)
G46 SUCCEEDED ((#SUPPORT :TABLE :B7))
ERASING E47 (#GRASPING :B7)
E47 SUCCEEDED 
ASSERTING A50 (#UNGRASP E6 :B7)
A50 SUCCEEDED 
TC-UNGRASP SUCCEEDED THNOVAL
G44 SUCCEEDED (#UNGRASP)
TC-PUT SUCCEEDED THNOVAL
G11 SUCCEEDED (#PUT :B7 (500 274 0))
ASSERTING A51 (#GET-RID-OF E4 :B7)
A51 SUCCEEDED 
TC-GET-RID-OF SUCCEEDED THNOVAL
G7 SUCCEEDED (#GET-RID-OF :B7)
TRYING GOAL G52 (#SUPPORT :B6 (THNV Y))
G52 FAILED 
ASSERTING A53 (#CLEARTOP :B6)
A53 SUCCEEDED 
ASSERTING A54 (#CLEARTOP E3 :B6)
A54 SUCCEEDED 
TC-CLEARTOP SUCCEEDED THNOVAL
G4 SUCCEEDED (#CLEARTOP :B6)
>>> 
LISTENING---> SHOW EVENT E3

E3  (#CLEARTOP E3 :B6)  --  TIME0 TO 3
    E6  (#UNGRASP E6 :B7)  --  TIME2 TO 2
    E4  (#GET-RID-OF E4 :B7)  --  TIME0 TO 3
         E5  (#GRASP E5 :B7)  --  TIME0 TO 1
* 
TRYING GOAL G55 (#GRASPING (THNV Y))
G55 FAILED 
TRYING GOAL G56 (#MOVEHAND2 (100 440 300))
ENTERING THEOREM TC-MOVEHAND2
TC-MOVEHAND2 SUCCEEDED THNOVAL
G56 SUCCEEDED (#MOVEHAND2 (100 440 300))
ASSERTING A57 (#GRASPING :B6)
A57 SUCCEEDED 
ASSERTING A60 (#GRASP E2 :B6)
A60 SUCCEEDED 
TC-GRASP SUCCEEDED THNOVAL
G2 SUCCEEDED (#GRASP :B6)
TRYING GOAL G61 (#RAISEHAND)
ENTERING THEOREM TC-RAISEHAND
TRYING GOAL G62 (#MOVEHAND (100 440 1000))
>>> 
LISTENING---> TELL PL

(INPUT ACTION THEOREM ASSERTIONS) 
WHICH OPTION? ACTION
ON OR OFF? OFF

* 
LISTENING---> TELL ACTION (THASSERT)

* 
ASSERTING A63 (#AT :B6 (0 300 500))
A63 SUCCEEDED 
G62 SUCCEEDED (#MOVEHAND (100 440 1000))
ASSERTING A64 (#RAISEHAND E7)
A64 SUCCEEDED  SUCCEEDED (#RAISEHAND)
ASSERTING A65 (#PICKUP E1 :B6)
A65 SUCCEEDED 
TC-PICKUP SUCCEEDED THNOVAL

G1 SUCCEEDED (#PICKUP :B6)
>>> 
LISTENING---> SHOW EVENT E1

E1  (#PICKUP E1 :B6)  --  TIME 0 TO 5
    E2  (#GRASP E2 :B6)  --  TIME 0 TO 4
         E3  (#CLEARTOP E3 :B6)  --  TIME 0 TO 3
              E4  (#GET-RID-OF E4 :B7)  --  TIME 0 TO 3
                   E5  (#GRASP E5 :B7)  --  TIME 0 TO 1
              E6  (#UNGRASP E6 :B7)  --  TIME 2 TO 2
    E7  (#RAISEHAND E7)  --  TIME 4 TO 5
(EE LISTENING---> 

[ANS1]
   ACTION=        ((MOVETO 100 340 500) (GRASP ':B7)
                                        (MOVETO 600 374 200)
                                        (UNGRASP)
                                        (MOVETO 100 440 300)
                                        (GRASP ':B6)
                                        (MOVETO 100 440 1000)
                                        (SAY OK))
   ANSRSS=        RSS1
   ANSNODE=       ANS1
   PLAUSIBILITY= 0

* 
MOVETO (100 340 500)
GRASP :B7
MOVETO (600 374 200)
UNGRASP 
MOVETO (100 440 300)
GRASP :B6
MOVETO (100 440 1000)OK .

APPENDIX 5
----------

 THIS IS ALL THREE TRACES COMBINED FOR "PICK UP A BIG RED BLOCK."
(I.E. PARSING, SEMANTIC STRUCTURES AND INFERENCE)
=================================================================
>SHRDLU RUN!
>>> SHRDLU COMMAND STATE, TYPE HELP <CR> FOR INSTRUCTIONS.
LISTENING---> SHOW

(SHOW TELL LISP PLANNER PARSING DEFINITIONS INPUT) 
WHICH OPTION? SHOW
CANSHOW
       SHOW
       TELL
       LISP
               PROPERTY
               FUNCTION
               VALUE
       PLANNER
               ASSERTIONS
               THEOREM
               SCENE
       PARSING
               NODE
               TREE
       DEFINITIONS
               UNIT
               WORD
               MARKER
       INPUT
               ALL
               REST
               CURRENT
* 
LISTENING---> SHOW SCENE
  CURRENT SCENE

:B1 -->  A SMALL RED BLOCK  AT (110 100 0)SUPPORTS (:B2)
:B2 -->  A SMALL GREEN PYRAMID  AT (110 100 100)
:B3 -->  A LARGE GREEN BLOCK  AT (400 0 0)SUPPORTS (:B5)
:B4 -->  A LARGE BLUE PYRAMID  AT (640 640 1)
:B5 -->  A SMALL RED PYRAMID  AT (500 100 200)
:B6 -->  A LARGE RED BLOCK  AT (0 300 0)SUPPORTS (:B7)
:B7 -->  A LARGE GREEN BLOCK  AT (0 240 300)
:B10 -->  A LARGE BLUE BLOCK  AT (300 640 0)
:BOX -->  A LARGE WHITE BOX  AT (600 600 0)SUPPORTS (:B4)
THE HAND IS GRASPING  NOTHING
* 
LISTENING---> TELL PARSING

(NODE LABEL ATTEMPT) 
WHICH OPTION? NODE
ON OR OFF? ON

* 
LISTENING---> TELL LABEL ON

* 
LISTENING---> TELL SEMANTICS

DO SEMANTIC ANALYSIS? YES
SHOW BUILDING OF SEMANTIC STRUCTURES? YES
* 
LISTENING---> TELL PLANNER OFF

* 
LISTENING---> TELL PL

(INPUT ACTION THEOREM ASSERTIONS) 
WHICH OPTION? INPUT
ON OR OFF? ON
* 
LISTENING---> TE FUNCTION FINDCHOOSE

TRACE BREAK UNTRACE OR UNBREAK? BREAK
FINDCHOOSE 
* 
LISTENING---> GO
QUIT
READY 
PICK UP A BIG RED BLOCK.

[1] 

[NODE1]
   SEMANTICS      NIL
   DAUGHTERS      NIL
   WORDAFTER      (PICK UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (TOPLEVEL MAJOR CLAUSE)

>>> 
LISTENING--->TE AT ON

* 
LISTENING---> 
PASSING ENTERING-CLAUSE

[TSS1]
   TSSNODE=       TSS1

>>> 
LISTENING---> 
PASSING INIT
PASSING MAJOR
PASSING THEREINIT
PASSING THER2
(1 ENTER PARSE (NG TIME)) 

[NODE2]
   SEMANTICS      NIL
   DAUGHTERS      NIL
   WORDAFTER      (PICK UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (TIME NG)

>>> 
LISTENING---> 
PASSING ENTERING-NG
PASSING NGSTART
PASSING TIME
PASSING FAIL
(1 EXIT PARSE NIL) 
PASSING CLAUSETYPE
(1 ENTER PARSE (VG IMPER)) 

[NODE3]
   SEMANTICS      NIL
   DAUGHTERS      NIL

   WORDAFTER      (PICK UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (IMPER VG)

>>> 
LISTENING---> 
PASSING ENTERING-VG
PASSING IMPER
(2 ENTER PARSE (VB DO NEG INF)) 
(2 EXIT PARSE NIL) 
(2 ENTER PARSE (VB (MVB) INF)) 

[NODE4]
   SEMANTICS      ((TRANS (#NOTICE)))
   DAUGHTERS      WORD
   WORDAFTER      (UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (VPRT VB INF TRANS MVB)

>>> 
LISTENING---> 

[NODE3]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE4)
   WORDAFTER      (UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (IMPER VG)

>>> 
LISTENING---> 
(2 EXIT PARSE (NODE3)) 
PASSING RETURN

[NODE3]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE4)
   WORDAFTER      (UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (VG IMPER)

>>> 
LISTENING---> 

[NODE1]
   MVB            (NODE4)
   TIME   TSS1
   PARENT         NIL
   SEMANTICS      NIL
   DAUGHTERS      (NODE3)
   WORDAFTER      (UP A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (TOPLEVEL MAJOR CLAUSE)

>>> 
LISTENING---> 
(1 EXIT PARSE (NODE3)) 
PASSING VG1
(1 ENTER PARSE (PRT)) 

[NODE5]
   SEMANTICS      T
   DAUGHTERS      WORD
   WORDAFTER      (A BIG RED BLOCK)
   FIRSTWORD      (UP A BIG RED BLOCK)
   FEATURES       (PRT)

>>> 
LISTENING---> 

[NODE1]
   MVB            (NODE4)
   TIME   TSS1
   PARENT         NIL
   SEMANTICS      NIL
   DAUGHTERS      (NODE5 NODE3)
   WORDAFTER      (A BIG RED BLOCK)
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (ACTV IMPER TOPLEVEL MAJOR CLAUSE)

>>> 
LISTENING---> SHOW TREE

NODE-SPECIFICATION: C
(((PICK UP) (ACTV IMPER TOPLEVEL MAJOR CLAUSE)
             NIL
             (((PICK) (VG IMPER) NIL ((PICK (VPRT VB INF TRANS MVB))))
              (UP (PRT))))
 NIL)
* 
LISTENING---> 
(1 EXIT PARSE (NODE1)) 
PASSING TRANSP
(1 ENTER PARSE (NG OBJ OBJ1)) 

[NODE6]
   SEMANTICS      NIL
   DAUGHTERS      NIL
   WORDAFTER      (A BIG RED BLOCK)
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (OBJ1 OBJ NG)

>>> 
LISTENING---> 
PASSING ENTERING-NG
PASSING NGSTART
PASSING LOOK
PASSING DET
(2 ENTER PARSE (DET)) 

[NODE7]
   SEMANTICS      T
   DAUGHTERS      WORD
   WORDAFTER     (A BIG RED BLOCK)

   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (DET NS INDEF)

>>> 
LISTENING---> 

[NODE6]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE7)
   WORDAFTER      (BIG RED BLOCK)
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (OBJ1 OBJ NG)

>>> 
LISTENING---> 
(2 EXIT PARSE (NODE6)) 
PASSING IND
PASSING ADJ
(2 ENTER PARSE (ADJ)) 

[NODE10]
   SEMANTICS      (OBJECT 
                      (MARKERS: (#PHYSOB #BIG) 
                       PROCEDURE: ((#MORE #SIZE
                                          ***
                                          (200 200
                                               200)))))
   DAUGHTERS      WORD
   WORDAFTER      (RED BLOCK)
   FIRSTWORD      (BIG RED BLOCK)
   FEATURES       (ADJ)

>>> 
LISTENING---> 

[NODE6]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE10 NODE7)
   WORDAFTER      (RED BLOCK)
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (INDEF NS DET OBJ1 OBJ NG)

>>> 
LISTENING---> 
(2 EXIT PARSE (NODE6)) 
PASSING ADJ
(2 ENTER PARSE (ADJ)) 

[NODE11]
   SEMANTICS      (#COLOR #RED)
   DAUGHTERS      WORD
   WORDAFTER      (BLOCK)
   FIRSTWORD      (RED BLOCK)
   FEATURES       (ADJ)

>>> 
LISTENING---> 

[NODE6]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE11 NODE10 NODE7)
   WORDAFTER      (BLOCK)
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (INDEF NS DET OBJ1 OBJ NG)

>>> 
LISTENING---> SHOW CURRENT

A BIG RED 
* 
LISTENING---> 
(2 EXIT PARSE (NODE6)) 
PASSING ADJ
(2 ENTER PARSE (ADJ)) 
(2 EXIT PARSE NIL) 
PASSING CLASF
(2 ENTER PARSE (VB ING (CLASF))) 
(2 EXIT PARSE NIL) 
(2 ENTER PARSE (VB EN (CLASF))) 
(2 EXIT PARSE NIL) 
(2 ENTER PARSE (CLASF)) 
(2 EXIT PARSE NIL) 
PASSING NOUN
(2 ENTER PARSE (NOUN)) 

[NODE12]
   SEMANTICS      (OBJECT 
                      (MARKERS: (#MANIP
                                 #RECTANGULAR) 
                       PROCEDURE: ((#IS *** #BLOCK))))
   DAUGHTERS      WORD
   WORDAFTER      NIL
   FIRSTWORD      (BLOCK)

   FEATURES       (NOUN NS)

>>> 
LISTENING---> 

[NODE6]
   PARENT         (NODE1)
   SEMANTICS      NIL
   DAUGHTERS      (NODE12 NODE11 NODE10 NODE7)
   WORDAFTER      NIL
   FIRSTWORD      (A BIG RED BLOCK)
   FEATURES       (INDEF NS DET OBJ1 OBJ NG)

>>> 
LISTENING---> 
(2 EXIT PARSE (NODE6)) 
PASSING SMNG
(1 ENTER CALLSM ((SMNG1))) 

[OSS1]
   OSSNODE=       OSS1
   PARSENODE=     (NODE6)
   VARIABLE=      X1
   DETERMINER=    (NS INDEF NIL)

>>> 
LISTENING---> SH CU

A BIG RED BLOCK 
* 
LISTENING---> 

[OSS2]
   OSSNODE=       OSS2
   PARSENODE=     (NODE6)
   VARIABLE=      X1
   RELATIONS=     ((#IS OSS1 #BLOCK))
   DETERMINER=    (NS INDEF NIL)
   PLAUSIBILITY= 0
   SYSTEMS=       (#SHAPES #PHYSOB #THING #SYSTEMS)
   MARKERS=       (#SHAPES #RECTANGULAR
                           #SYSTEMS
                           #THING
                           #PHYSOB
                           #MANIP)

>>> 
LISTENING---> SHOW MA #SHAPES

#SHAPES
* 
LISTENING---> SHOW MA #PHYSOB

#PHYSOB
       #BOX
       #CONSTRUCT
               #STACK
               #ROW
       #HAND
       #MANIP
       #TABLE
* 
LISTENING---> 

[OSS3]
   OSSNODE=       OSS3
   PARSENODE=     (NODE6)
   VARIABLE=      X1
   RELATIONS=     ((#COLOR OSS2 #RED)
                   (#IS OSS1 #BLOCK))
   DETERMINER=    (NS INDEF NIL)
   PLAUSIBILITY=  0                     
   SYSTEMS=     (#SPECTRUM #SHAPES
                           #PHYSOB
                           #THING
                           #SYSTEMS)
   MARKERS=       (#SPECTRUM #RED
                             #SHAPES
                             #RECTANGULAR
                             #SYSTEMS
                             #THING
                             #PHYSOB
                             #MANIP)

>>> 
LISTENING---> 

[OSS4]
   OSSNODE=       OSS4
   PARSENODE=     (NODE6)
   VARIABLE=      X1
   RELATIONS=     ((#MORE #SIZE OSS3 (200 200 200))
                   (#COLOR OSS2 #RED)
                   (#IS OSS1 #BLOCK))
   DETERMINER=    (NS INDEF NIL)
   PLAUSIBILITY= 0
   SYSTEMS=       (#SPECTRUM #SHAPES
                             #PHYSOB
                             #THING
                             #SYSTEMS)
   MARKERS=       (#BIG #SPECTRUM
                        #RED
                        #SHAPES
                        #RECTANGULAR
                        #SYSTEMS
                        #THING
                        #PHYSOB
                        #MANIP)

>>> 
LISTENING---> 
(1 EXIT CALLSM (OSS4)) 
PASSING RETSM
(1 ENTER CALLSM ((SMNG2))) 
(1 EXIT CALLSM (OSS4)) 
PASSING RETURN

[NODE6]
   HEAD   (NODE12 NODE11 NODE10 NODE7)
   PARENT         (NODE1)
   SEMANTICS      (OSS4)
   DAUGHTERS      (NODE12 NODE11 NODE10 NODE7)
   WORDAFTER      NIL
   FIRSTWORD      (A BIG RED BLOCK)

   FEATURES       (NG OBJ OBJ1 DET NS INDEF)

>>> 
LISTENING---> 

[NODE1]
   MVB            (PICK-UP)
   TIME   TSS1
   PARENT         NIL
   SEMANTICS      NIL
   DAUGHTERS      (NODE6 NODE5 NODE3)
   WORDAFTER      NIL
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (PRT ACTV
                       IMPER
                       TOPLEVEL
                       MAJOR
                       CLAUSE)

>>> 
LISTENING---> SHOW WORD PICK-UP


[PICK-UP]
   FEATURES       (COMBINATION TRANS)
   SEMANTICS      ((TRANS
                    (RELATION 
                        (RESTRICTIONS: (((#ANIMATE))
                                        ((#MANIP))) 
                         MARKERS: (#EVENT) 
                         PROCEDURE: ((#EVAL
                                      (COND
                                       ((MEMQ (NUMBER? SMOB1)
                                              '(1 NS))
                                        '(#PICKUP #2 *TIME))
                                       ('(#PUTIN
                                          #2
                                          :BOX
                                          *TIME)))))))))
   ROOT   (PICK UP)

>>> 
LISTENING---> 
* 
LISTENING---> 
(1 EXIT PARSE (NODE6)) 
PASSING OBB
PASSING FQPRT
PASSING ONT
(1 ENTER CALLSM ((SMCL1))) 

[RSS1]
   PARSENODE=     (NODE1)
   RSSNODE=       RSS1
   VARIABLE=      EVX1
   RELATIONS=     ((#PICKUP OSS4 TSS1))
   PLAUSIBILITY= 0
   SYSTEMS=       (#SYSTEMS)
   MARKERS=       (#SYSTEMS #EVENT)

>>> 
LISTENING---> 
(1 EXIT CALLSM (RSS1)) 
PASSING RETSM
(1 ENTER CALLSM ((SMCL2))) 
(1 EXIT CALLSM (NODE6 NODE5 NODE3)) 
PASSING RETURN

[NODE1]
   OBJ1   (NODE6 NODE5 NODE3)
   MVB            (PICK-UP)
   TIME   TSS1
   PARENT         NIL
   SEMANTICS      (RSS1)
   DAUGHTERS      (NODE6 NODE5 NODE3)
   WORDAFTER      NIL
   FIRSTWORD      (PICK UP A BIG RED BLOCK)
   FEATURES       (CLAUSE MAJOR
                          TOPLEVEL
                          IMPER
                          ACTV
                          PRT
                          TRANS)

>>> 
LISTENING---> SHOW TREE C

(((PICK UP A BIG RED BLOCK)
  (CLAUSE MAJOR TOPLEVEL IMPER ACTV PRT TRANS)
  (RSS1)
  (((PICK) (VG IMPER) NIL ((PICK (VPRT VB INF TRANS MVB))))
   (UP (PRT))
   ((A BIG RED BLOCK)
    (NG OBJ OBJ1 DET NS INDEF)
    (OSS4)
    ((A (DET NS INDEF)) (BIG (ADJ)) (RED (ADJ)) (BLOCK (NOUN NS))))))
 NIL)
* 
LISTENING---> 

(THAND (THGOAL (#PICKUP OSS4) (THDBF MUMBLE) (THUSE TC-2))
        (VALUEPUT)
        (SETQ SUCCESS T)
        (SETQ PLAN2 PLAN))
>>>  FOR PLANNER
LISTENING---> 
>>>  ENTERING FINDCHOOSE EXPR (OSS X ANS2)

* 
LISTENING---> SHOW VALUE OSS

OSS4
* 
LISTENING---> 
>>>  EXITING FINDCHOOSE
LISTENING---> SHOW VALUE X

:B6
* 
LISTENING---> SHOW PLANNER

(ASSERTIONS THEOREM SCENE) 
WHICH OPTION? ASSERTIONS
ATOM: ?

SHOW ALL ASSERTIONS WHICH CONTAIN THE GIVEN ATOM 
ATOM: :B6

(((#COLOR :B6 #RED)) ((#SHAPE :B6 #RECTANGULAR))
                      ((#SUPPORT :B6 :B7))
                      ((#AT :B6 (0 300 0)))
                      ((#IS :B6 #BLOCK))
                      ((#MANIP :B6))
                      ((#SUPPORT :TABLE :B6)))
* 
LISTENING---> TELL PLANNER ON

* 
LISTENING---> 
TRYING GOAL G1 (#PICKUP :B6)
>>> 
LISTENING---> 
ENTERING THEOREM TC-PICKUP
TRYING GOAL G2 (#GRASP :B6)
>>> 
LISTENING---> SHOW THEOREM TC-PICKUP

(THCONSE (X (WHY (EV)) EV) (#PICKUP $?X) 
          (MEMORY)

          (THGOAL (#GRASP $?X) (THUSE TC-GRASP))
          (THGOAL (#RAISEHAND) (THNODB) (THUSE TC-RAISEHAND))
          (MEMOREND (#PICKUP $?EV $?X)))
* 
ENTERING THEOREM TC-GRASP
TRYING GOAL G3 (#GRASPING :B6)
G3 FAILED 
TRYING GOAL G4 (#CLEARTOP :B6)
ENTERING THEOREM TC-CLEARTOP
TRYING GOAL G5 (#SUPPORT :B6 ?)
G5 SUCCEEDED ((#SUPPORT :B6 :B7))
TRYING GOAL G6 (#SUPPORT :B6 (THNV Y))
G6 SUCCEEDED ((#SUPPORT :B6 :B7))
TRYING GOAL G7 (#GET-RID-OF :B7)
ENTERING THEOREM TC-GET-RID-OF
TRYING GOAL G10 (#FINDSPACE :TABLE (200 200 200) :B7 (THNV Y))
ENTERING THEOREM TC-FINDSPACE
TC-FINDSPACE SUCCEEDED THNOVAL
G10 SUCCEEDED
ENTERING THEOREM TC-PUT
TRYING GOAL G12 (#GRASP :B7)
ENTERING THEOREM TC-GRASP

TRYING GOAL G13 (#GRASPING :B7)
G13 FAILED 
TRYING GOAL G14 (#CLEARTOP :B7)
G14 SUCCEEDED ((#CLEARTOP :B7))
TRYING GOAL G15 (#GRASPING (THNV Y))
G15 FAILED 
TRYING GOAL G16 (#MOVEHAND2 (100 340 500))
ENTERING THEOREM TC-MOVEHAND2
TC-MOVEHAND2 SUCCEEDED THNOVAL
G16 SUCCEEDED (#MOVEHAND2 (100 340 500))
ASSERTING A17 (#GRASPING :B7)
A17 SUCCEEDED 
ASSERTING A20 (#GRASP E5 :B7)
A20 SUCCEEDED 
TC-GRASP SUCCEEDED THNOVAL
G12 SUCCEEDED (#GRASP :B7)
>>> 
LISTENING---> SHOW PR E5


[E5]
   TYPE   #GRASP
   THASSERTION    (NIL (2 (3 1 ((#GRASP E5 :B7)))))
   END            1
   WHY            E4
   START          0

* 
TRYING GOAL G21 (#MOVEHAND (600 374 200))
ENTERING THEOREM TC-MOVEHAND
TRYING GOAL G22 (#GRASPING (THV X))
G22 SUCCEEDED ((#GRASPING :B7))
TRYING GOAL G23 (#AT :B7 (THNV W))
G23 SUCCEEDED ((#AT :B7 (0 240 300)))
ERASING E24 (#AT :B7 (0 240 300))
ENTERING THEOREM TE-SUPP
TRYING GOAL G25 (#SUPPORT :B7 (THNV Y))
G25 FAILED 
TRYING GOAL G26 (#SUPPORT (THNV Y) :B7)
G26 SUCCEEDED ((#SUPPORT :B6 :B7))
ERASING E27 (#SUPPORT :B6 :B7)
E27 SUCCEEDED 
TRYING GOAL G30 (#PART :B7 (THNV Y))
G30 FAILED 
TE-SUPP SUCCEEDED THNOVAL
ENTERING THEOREM TE-CONTAIN
TRYING GOAL G31 (#CONTAIN (THNV Y) :B7)
G31 FAILED 
TE-CONTAIN FAILED 
E24 SUCCEEDED 
ASSERTING A32 (#AT :B7 (500 274 0))
ENTERING THEOREM TA-AT
TA-AT SUCCEEDED THNOVAL
ENTERING THEOREM TA-SUPP
TRYING GOAL G33 (#MANIP :TABLE)
G33 FAILED 
ASSERTING A34 (#SUPPORT :TABLE :B7)
A34 SUCCEEDED 
TRYING GOAL G35 (#CLEARTOP :TABLE)
G35 FAILED 
TA-SUPP SUCCEEDED THNOVAL
ENTERING THEOREM TA-CONTAIN
TRYING GOAL G36 (#MANIP :B7)
G36 SUCCEEDED ((#MANIP :B7))
TRYING GOAL G37 (#SUPPORT (THV Y) :B7)
G37 SUCCEEDED ((#SUPPORT :TABLE :B7))
TRYING GOAL G40 (#IS :TABLE #BOX)
G40 FAILED 
TRYING GOAL G41 (#CONTAIN (THV Z) :TABLE)
G41 FAILED 
G37 FAILED 
G36 FAILED 
TA-CONTAIN FAILED 

A32 SUCCEEDED 
TRYING GOAL G42 (#MOVEHAND2 (600 374 200))
ENTERING THEOREM TC-MOVEHAND2
TC-MOVEHAND2 SUCCEEDED THNOVAL
G42 SUCCEEDED (#MOVEHAND2 (600 374 200))
TRYING GOAL G43 (#SUPPORT (THV Y) :B7)
G43 SUCCEEDED ((#SUPPORT :TABLE :B7))
TC-MOVEHAND SUCCEEDED THNOVAL
G21 SUCCEEDED (#MOVEHAND (600 374 200))
TRYING GOAL G44 (#UNGRASP)
ENTERING THEOREM TC-UNGRASP
TRYING GOAL G45 (#GRASPING (THV X))
G45 SUCCEEDED ((#GRASPING :B7))
TRYING GOAL G46 (#SUPPORT ? :B7)
G46 SUCCEEDED ((#SUPPORT :TABLE :B7))
ERASING E47 (#GRASPING :B7)
E47 SUCCEEDED 
ASSERTING A50 (#UNGRASP E6 :B7)
A50 SUCCEEDED 
TC-UNGRASP SUCCEEDED THNOVAL
G44 SUCCEEDED (#UNGRASP)
TC-PUT SUCCEEDED THNOVAL
G11 SUCCEEDED (#PUT :B7 (500 274 0))
ASSERTING A51 (#GET-RID-OF E4 :B7)
A51 SUCCEEDED 
TC-GET-RID-OF SUCCEEDED THNOVAL
G7 SUCCEEDED (#GET-RID-OF :B7)
TRYING GOAL G52 (#SUPPORT :B6 (THNV Y))
G52 FAILED 
ASSERTING A53 (#CLEARTOP :B6)
A53 SUCCEEDED 
ASSERTING A54 (#CLEARTOP E3 :B6)
A54 SUCCEEDED 
TC-CLEARTOP SUCCEEDED THNOVAL
G4 SUCCEEDED (#CLEARTOP :B6)
>>> 
LISTENING---> SHOW EVENT E3

E3  (#CLEARTOP E3 :B6)  --  TIME0 TO 3
    E6  (#UNGRASP E6 :B7)  --  TIME2 TO 2
    E4  (#GET-RID-OF E4 :B7)  --  TIME0 TO 3
         E5  (#GRASP E5 :B7)  --  TIME0 TO 1
* 
TRYING GOAL G55 (#GRASPING (THNV Y))
G55 FAILED 
TRYING GOAL G56 (#MOVEHAND2 (100 440 300))
ENTERING THEOREM TC-MOVEHAND2
TC-MOVEHAND2 SUCCEEDED THNOVAL
G56 SUCCEEDED (#MOVEHAND2 (100 440 300))
ASSERTING A57 (#GRASPING :B6)
A57 SUCCEEDED 
ASSERTING A60 (#GRASP E2 :B6)
A60 SUCCEEDED 
TC-GRASP SUCCEEDED THNOVAL
G2 SUCCEEDED (#GRASP :B6)
TRYING GOAL G61 (#RAISEHAND)
ENTERING THEOREM TC-RAISEHAND
TRYING GOAL G62 (#MOVEHAND (100 440 1000))
>>> 
LISTENING---> TELL PL

(INPUT ACTION THEOREM ASSERTIONS) 
WHICH OPTION? ACTION
ON OR OFF? OFF

* 
LISTENING---> TELL ACTION (THASSERT)

* 
ASSERTING A63 (#AT :B6 (0 300 500))
A63 SUCCEEDED 
G62 SUCCEEDED (#MOVEHAND (100 440 1000))
ASSERTING A64 (#RAISEHAND E7)
A64 SUCCEEDED  SUCCEEDED (#RAISEHAND)
ASSERTING A65 (#PICKUP E1 :B6)
A65 SUCCEEDED 
TC-PICKUP SUCCEEDED THNOVAL

G1 SUCCEEDED (#PICKUP :B6)
>>> 
LISTENING---> SHOW EVENT E1

E1  (#PICKUP E1 :B6)  --  TIME 0 TO 5
    E2  (#GRASP E2 :B6)  --  TIME 0 TO 4
         E3  (#CLEARTOP E3 :B6)  --  TIME 0 TO 3
              E4  (#GET-RID-OF E4 :B7)  --  TIME 0 TO 3
                   E5  (#GRASP E5 :B7)  --  TIME 0 TO 1
              E6  (#UNGRASP E6 :B7)  --  TIME 2 TO 2
    E7  (#RAISEHAND E7)  --  TIME 4 TO 5
(EE LISTENING---> 

[ANS1]
   ACTION=        ((MOVETO 100 340 500) (GRASP ':B7)
                                        (MOVETO 600 374 200)
                                        (UNGRASP)
                                        (MOVETO 100 440 300)
                                        (GRASP ':B6)
                                        (MOVETO 100 440 1000)
                                        (SAY OK))
   ANSRSS=        RSS1
   ANSNODE=       ANS1
   PLAUSIBILITY= 0

* 
MOVETO (100 340 500)
GRASP :B7
MOVETO (600 374 200)
UNGRASP 
MOVETO (100 440 300)
GRASP :B6
MOVETO (100 440 1000)OK .

APPENDIX 6
----------

THIS SHOWS THE PROCESS OF ADDING WORDS, THEOREMS AND ASSERTIONS
TO SHRDLU'S DATA BASE AND THEIR INTERACTION IN THE UNDERSTANDING
OF NEW SENTENCES.
==================================================================
                                                                       
READY 

>>> 
LISTENING---> TELL WORD

WORD: SKUNK

NOUN OR VERB? NOUN
MARKERS: (#ANIMAL)

PROCEDURE: ?

LIST OF EXPRESSIONS TO BE PUT IN PLANNER GOALS TO DESCRIBE OBJECT - 
USE *** TO REPRESENT OBJECT BEING DESCRIBED BY WORD 
PROCEDURE: ((*** #IS-A #SKUNK))

LISTENING---> SHOW WORD SKUNK


[SKUNK]
   SEMANTICS      ((NOUN
                    (OBJECT 
                        (MARKERS: (#ANIMAL) 
                         PROCEDURE: ((*** #IS-A
                                          #SKUNK))))))
   FEATURES       (NOUN NS)

>>> 
LISTENING---> TELL MA

MARKER: #ANIMAL

PARENT: #PHYSOB

* 
LISTENING---> TELL WORD ANIMAL

WORD: ANIMAL

NOUN OR VERB? NOUN
MARKERS: (#ANIMAL)

PROCEDURE: ((*** #IS-A #ANIMAL))

>>>
LISTENING---> TELL THEOREM

THEOREM-TYPE: ?

ANTECEDENT, ERASING, OR CONSEQUENT THEOREM 
THE CHOICES ARE: 
(THANTE THERASING THCONSE) 
THEOREM-TYPE: THANTE
VARIABLE-LIST: (X)

PATTERN: ($?X #IS-A #SKUNK)

BODY: ((THASSERT  ($?X #IS-A #ANIMAL)))

* 
LISTENING---> SHOW THEOREM THEOREM1

 (THANTE (X)
($?X #IS-A #SKUNK) (THASSERT ($?X #IS-A #ANIMAL)))
* 
LISTENING---> TELL PLANNER ON

* 
LISTENING---> TELL AS

ASSERTION: (=FLOWER #IS-A #SKUNK)

ASSERTING A66 (=FLOWER #IS-A #SKUNK)
ENTERING THEOREM THEOREM1
ASSERTING A67 (=FLOWER #IS-A #ANIMAL)
A67 SUCCEEDED 
THEOREM1 SUCCEEDED THNOVAL
A66 SUCCEEDED 
* 
LISTENING---> SHOW AS =FLOWER

(((=FLOWER #IS-A #ANIMAL)) ((=FLOWER #IS-A #SKUNK)))
* 
LISTENING---> TELL WORD

WORD: STINK

NOUN OR VERB? VERB
MARKERS: (#EVENT)

TRANSITIVE OR INTRANSITIVE? INTRANSITIVE
RESTRICTIONS ON SUBJECT: (#PHYSOB)

LISTENING---> 

PROCEDURE:  ?
LIST OF EXPRESSIONS TO BE PUT INTO PLANNER GOALS TO DESCRIBE ACTION 
OR RELATION -- USE #1 FOR SUBJECT, #2 FOR OBJECT. 
PROCEDURE:  ((#ODERIFEROUS #1))
* 
LISTENING---> TELL TELLABLE #ODERIFEROUS

* 
LISTENING---> TELL PA OFF

* 
LISTENING---> GO
QUIT
READY 
ALL SKUNKS STINK.
[1] 

[TSS1]
   TSSNODE=       TSS1

>>> 
LISTENING---> 

[OSS1]
   OSSNODE=       OSS1
   PARSENODE=     (NODE3)
   VARIABLE=      X1
   DETERMINER=    (NPL NDET NIL)

>>> 
LISTENING---> 

[OSS2]
   OSSNODE=       OSS2
   PARSENODE=     (NODE3)
   VARIABLE=      X1
   RELATIONS=     ((OSS1 #IS-A #SKUNK))
   DETERMINER=    (NPL NDET NIL)
   PLAUSIBILITY= 0
   SYSTEMS=       (#PHYSOB #THING #SYSTEMS)
   MARKERS=       (#SYSTEMS #THING #PHYSOB #ANIMAL)

>>> 
LISTENING---> 

[TSS2]
   TSSNODE=       TSS2

>>> 
LISTENING---> 

[RSS1]
   PARSENODE=     (NODE1)
   RSSNODE=       RSS1
   REL=   OSS2
   VARIABLE=      EVX1
   RELATIONS=     ((#ODERIFEROUS OSS2))
   PLAUSIBILITY= 0
   RELMARKERS=    ((#SYSTEMS #THING #PHYSOB #ANIMAL)
                   (#PHYSOB #THING #SYSTEMS))
   SYSTEMS=       (#SYSTEMS)
   MARKERS=       (#SYSTEMS #EVENT)

>>> 
LISTENING---> 

[ANS1]
   ACTION=        ((SAY I UNDERSTAND)
                   (THADD 'THEOREM2 NIL))
   ANSRSS=        RSS1
   ANSNODE=       ANS1
   PLAUSIBILITY= 0

>>> 
LISTENING---> SH TH THEOREM2

(THCONSE (X1) (#ODERIFEROUS $?X1) 
          (THGOAL ($?X1 #IS-A #SKUNK) (THDBF MUMBLE))

          )
* 
LISTENING---> TELL SE

DO SEMANTIC ANALYSIS? YES
SHOW BUILDING OF SEMANTIC STRUCTURES? NO
* 
LISTENING---> 
* I UNDERSTAND .

>>> 
LISTENING---> 
READY 
DOES ANY ANIMAL STINK?




(THAND (THFIND ALL
                $?X2
                (X2)
                (THGOAL ($?X2 #IS-A #ANIMAL) (THDBF MUMBLE))
                (THGOAL (#ODERIFEROUS $?X2) (THDBF MUMBLE)
                                            (THTBF THTRUE)))
        (THPUTPROP 'X2 THVALUE 'BIND))
>>>  FOR PLANNER
LISTENING---> TELL PLANNER ON

* 
LISTENING---> 
TRYING GOAL G70 ((THV X2) #IS-A #ANIMAL)
>>> 
LISTENING---> 
G70 SUCCEEDED ((=FLOWER #IS-A #ANIMAL))
>>> 
LISTENING---> 
TRYING GOAL G71 (#ODERIFEROUS =FLOWER)
>>> 
LISTENING---> 
ENTERING THEOREM THEOREM2
TRYING GOAL G72 (=FLOWER #IS-A #SKUNK)
>>> 
LISTENING---> 
G72 SUCCEEDED ((=FLOWER #IS-A #SKUNK))
>>> 
LISTENING---> 
THEOREM2 SUCCEEDED THNOVAL
G71 SUCCEEDED (#ODERIFEROUS =FLOWER)
>>> 
LISTENING---> 
* YES,FLOWER. 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     