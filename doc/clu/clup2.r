.nd chapter 2-1
.so clu/clupap.header
.
 string registers for italic variable names
.
.sr i 2i*
.sr s 2s*
.sr o 2o*
.sr c 2c*
.sr n 2n*
.sr t 2t*
.sr r 2r*
.sr x 2x*
.sr tr 2tr*
.sr w 2w*
.sr wb 2wb*
.sr total 2total*
.sr contents 2contents*
.sr count_words 2count_words*
.sr next_word 2next_word*
.sr wordbag 2wordbag*
.sr wordtree 2wordtree*
.sr wordbags 2wordbags*
.sr wordtrees 2wordtrees*
.sr insert 2insert*
.sr create 2create*
.sr print 2print*
.sr instream 2instream*
.sr instreams 2instreams*
.sr outstream 2outstream*
.sr outstreams 2outstreams*
.
.chapter "An Example of Data Abstraction"
.para
This section introduces the basic data
abstraction mechanism of CLU, the cluster.
By means of an example, we intend to show how
abstractions occur naturally in program design,
and how they are used and implemented in CLU.
In particular, we show how a data abstraction
can be used as structured intermediate storage.
.para
Consider the following problem:
Given some document, we wish to compute,
for each distinct word in the document,
the number of times the word occurs
and its frequency of occurrence as a percentage of the total
number of words.
The document will be
represented as a sequence of characters.
A word is any non-empty sequence of
alphabetic characters.
Adjacent words are
separated by one or more non-alphabetic
characters such as spaces, punctuation, or newline
characters.
In recognizing distinct words, the
difference between upper and lower case letters should
be ignored.
.para
The output is also to be a sequence of characters,
divided into lines.
Successive lines should contain an alphabetical
list of all the distinct words in the document,
one word per line.
Accompanying each word should
be the total number of occurrences and the
.ne 5
frequency of occurrence.  For example:
.table
.ta 8 20 28
	a	2	3.509%
	access	1	1.754%
	and	2	3.509%
		dots
.rtabs
.end_table
.para
Specifically, we are required to write the
procedure count_words, which takes two arguments:
an instream and an outstream.
The former is the
source of the document to be processed, and the latter
is the destination of the required output.
.ne 5
The form of this procedure will be
.code
	count_words = proc (i: instream, o: outstream);
		dots
		end count_words;
.end_code
Note that count_words does not return any results;
its only effects are modifications of i (reading the entire
document) and of o (printing the required statistics).
.para
2Instream* and outstream are data abstractions.
An instream i contains a sequence of characters.
Of the primitive
operations on instreams, only two will be of interest to us.
2Empty@(i)* returns true if there are no characters available
in i, and returns false otherwise.
2Next@(i)* removes the first character from the sequence
and returns it.
Invoking the next operation on an empty instream is an
error.
.foot
The CLU error handling mechanism is discussed in [LCS75].
.efoot
An outstream also contains a sequence of characters.
The interesting operation on outstreams is
2put_string@(s,@o)*,
which appends the string s to the existing sequence of characters
in o.
.para
Now consider how we might implement count_words.
We begin by deciding how to handle words.
We could define a new abstract data type 2word*.
However, we choose instead to use strings (a primitive
CLU type), with the restriction that only strings of
lower-case alphabetic characters will be used.
.foot
Sometimes it is difficult to decide whether to introduce
a new data abstraction or to use an existing abstraction.
Our decision to use strings to represent words was made
partly to shorten the presentation.
.efoot
.para
Next, we investigate how to scan the document.
Reading a word requires knowledge of the
exact way in which words occur in the input stream.
We choose to isolate this information in a procedural abstraction,
called next_word,
which takes in the instream i and returns the next word
(converted to lower case characters) in the document.
If there are no more words,
next_word must communicate this fact to count_words.
A simple way to indicate that there are no
more words is by returning an ``end of document'' word,
one that is distinct from any other word.
A reasonable choice for the ``end of document'' word is
the empty string.
.para
It is clear that in count_words we must scan the
entire document before we can print our results, and
therefore, we need some receptacle
to retain information about words between these two
actions (scanning and printing).
Recording the
information gained in the scan and organizing it
for easy printing will probably be fairly complex.
Therefore, we will defer such considerations until later
by introducing a data abstraction wordbag with the
appropriate properties.
In particular, wordbag provides
three operations:  create, which creates an empty wordbag;
insert, which adds a word to the wordbag; and print, which
prints the desired statistical information about the words
in the wordbag.
.foot
The print operation is not the ideal choice, but a better
solution requires the use of control abstractions.
This solution is presented in Section more_abstraction.
.efoot
.nr count_words current_figure
.para
The implementation of count_words is shown in
Figure count_words.
.begin_figure "The count_words procedure."
.code
count_words = proc (i: instream, o: outstream);

	% create an empty wordbag
	wb: wordbag := wordbag$create ();

	% scan document, adding each word found to wb
	w: string := next_word (i);
	while w ~= "" do
		wordbag$insert (wb, w);
		w := next_word (i);
		end;

	% print the wordbag
	wordbag$print (wb, o);

	end count_words;
.ns
.end_code
.finish_figure
The ``%'' character starts a comment,
which continues to the end of the line.
The ``~'' character stands for boolean negation.
The notation 2variable:@type* is used
in formal argument lists and declarations
to specify the types of variables;
a declaration may be combined with an assignment
specifying the initial value of the variable.
Boldface is used for reserved words, including the
names of primitive CLU types.
 CLU does not permit
 redefinition of the primitive types; however,
 primitive types are used in the same way as abstract
 types.
.para
The count_words procedure declares four variables:
i, o, wb, and w.
The first two denote the instream and
outstream that are passed as arguments to count_words.
The third, wb, denotes the wordbag used to hold
the words read so far,
and the fourth, w, the word
currently being processed.
.para
Operations of a data abstraction are named by
a compound form that specifies both the type and
the operation name.  Three examples of operation calls
appear in count_words: 2wordbag$create@()*,
2wordbag$insert@(wb,@w)*
and 2wordbag$print@(wb,@o)*.
The CLU system provides a mechanism that avoids conflicts
between names of abstractions; this mechanism is discussed in
Section library.
However, operations of two different data abstractions may have
the same name;
the compound form serves to resolve this ambiguity.
Although the ambiguity could in most cases be resolved by context,
we have found in using CLU that the compound
form enhances the readability of programs.
.nr next_word current_figure
.para
The implementation of next_word is shown in
Figure next_word.
.begin_figure "The next_word procedure."
.code
next_word = proc (i: instream) returns (string);

	c: char := 1' '*;

	% scan for first alphabetic character
	while ~alpha (c) do
		if instream$empty (i)
			then return "";
			end;
		c := instream$next (i);
		end;

	% accumulate characters in word
	w: string := "";
	while alpha (c) do
		w := string$append (w, c);
		if instream$empty (i)
			then return w;
			end;
		c := instream$next (i);
		end;

	return w;	% the non-alphabetic character c is lost

	end next_word;
.ns
.end_code
.finish_figure
The 2string$append* operation creates a new string
by appending a character to the characters in the
string argument
(it does 2not* modify the string argument).
Note the use of the instream operations
2next* and 2empty*.
Note also that two additional procedures have been used:
2alpha@(c)*,
which tests whether a character is alphabetic or not,
and 2lower_case@(c)*,
which returns the lower case version of a character.
The implementations of these procedures are not shown in the paper.
.para
Now we must implement the type wordbag.
.ne 5
The cluster will have the form
.code
	wordbag = cluster is create, insert, print;
		dots
		end wordbag;
.end_code
This form expresses the idea that the data abstraction is a set
of operations as well as a set of objects.
The cluster must
provide a representation for objects of the type wordbag and
an implementation for each of the operations.
We are free to choose from the possible representations the
one best suited to our use of the wordbag cluster.
.para
The representation that we choose should allow
reasonably efficient storage of words and easy printing,
in alphabetic order, of the words and associated statistics.
For efficiency in computing the statistics, maintaining
a count of the total number of words in the document
would be helpful.
Since the total number of words in the document is probably
much larger than the number of distinct words, the
representation of a wordbag should contain only one ``item'' for
each distinct word (along with a multiplicity count), rather
than one ``item'' for each occurrence.
This choice of representation requires that, at
each insertion, we check whether the new word is already
present in the wordbag.
We would like a representation that
allows the search for a matching ``item'' and the insertion of a
not-previously-present ``item'' to be efficient.
A binary tree representation [Knu73] fits our requirements nicely.
.para
Thus the main part of the wordbag representation will
consist of a binary tree.
The binary tree is another data abstraction,
wordtree.  The data abstraction wordtree
provides operations very similar to those of wordbag:
2create@()* returns an empty wordtree;
2insert@(tr,@w)* returns a wordtree containing all the
words in the wordtree tr plus the additional word w
(the wordtree tr may be modified in the process);
and 2print@(tr,@n,@o)* prints the contents of the
wordtree tr in alphabetic order on outstream o, along with the
number of occurrences and the frequency (based on a total of
n words).
.nr wordbag current_figure
.para
The implementation of wordbag is given in Figure wordbag.
.begin_figure "The wordbag cluster."
.code
wordbag = cluster is
	create,		% create an empty bag
	insert,		% insert an element
	print;		% print contents of bag

	rep = record [contents: wordtree, total: int];

create = proc () returns (cvt);
	return rep${contents: wordtree$create (), total: 0};
	end create;

insert = proc (x: cvt, v: string);
	x.contents := wordtree$insert (x.contents, v);
	x.total := x.total + 1;
	end insert;

print = proc (x: cvt, o: outstream);
	wordtree$print (x.contents, x.total, o);
	end print;

end wordbag;
.ns
.end_code
.finish_figure
Following the header, we find the definition of the
.ne 3
representation selected for wordbag objects:
.code
	rep = record [contents: wordtree, total: int];
.end_code
The reserved type identifier rep indicates that the type
specification to the right of the equal sign is the representing
type for the cluster.
We have defined the representation of a wordbag object to
consist of two pieces:  a wordtree,
as explained above, and an integer, which records the total
number of words in the wordbag.
.para
A CLU record is an object with one or more named
components.
For each component name, there is an operation to select
and an operation to set the corresponding component.
The operation 2get_n@(r)* returns the n component
of the record r (this operation is usually
abbreviated 2r.n*).
The operation 2put_n@(r,@x)* makes x the n component
of the record r (this operation is usually
abbreviated 2r.n@*:=2@x*,
by analogy with the assignment statement).
A new record is created by an expression of the form
type${name1: value1, dots}.
.para
There are two different 
types associated with any cluster:  the abstract
type being defined (wordbag in this case) and the
representation type (the record).
Outside of the cluster,
type-checking will ensure that a wordbag object will always be
treated as such.
In particular, the ability to convert a wordbag object into its
representation is not provided (unless one of the
wordbag operations does so explicitly).
.para
Inside the cluster, however, it is necessary to view
a wordbag object as being of the representation type,
because the implementations of the
operations are defined in terms of the representation.
This change of viewpoint is signalled by having the
reserved word cvt appear as the type of an
argument (as in the insert and print operations).
1Cvt* may also appear as a return type
(as in the create operation);
here it indicates that a returned object
will be changed into an object of abstract type.
Whether cvt appears as the type of an
argument or as a return type,
it stipulates a ``conversion'' of viewpoint
between the external abstract type and the internal representation type.
1Cvt* can be used only within a cluster,
and conversion can be done only between the single abstract
type being defined and the (single) representation type.
.foot
1Cvt* corresponds to Morris' seal and unseal [Mor73],
except that 1cvt* represents a change in viewpoint only;
no computation is required.
.efoot
.para
The procedures in wordbag are very simple.
2Create* builds a new instance of the rep by use of the
.ne 3
record constructor
.code
	rep${contents: wordtree$create (), total: 0}
.end_code
Here total is initialized to 0, and contents to the
empty wordtree (by calling the create operation of wordtree).
This rep object is converted to a wordbag object as it
is being returned.
2Insert* and print are implemented directly
in terms of wordtree operations.
.nr wordtree current_figure
.para
The implementation of wordtree is shown in Figure wordtree.
In the wordtree representation, each node
contains a word and the number of times that word has been
inserted into the wordbag, as well as two subtrees.
.begin_page_figure "The wordtree cluster."
.code
wordtree = cluster is
	create,		% create empty contents
	insert,		% add item to contents
	print;		% print contents

	node = record [m!value: string, count: int,
(mark!m)lesser: wordtree, greater: wordtree];
	rep = oneof [empty: null, non_empty: node];

create = proc () returns (cvt);
	return rep$make_empty (nil);
	end create;

insert = proc (x: cvt, v: string) returns (cvt);
	tagcase x
		tag empty:
			n: node := node${m!value: v, count: 1,
(mark!m)lesser: wordtree$create (),
(mark!m)greater: wordtree$create ()};
			return rep$make_non_empty (n);
		tag non_empty (n: node):
			if v = n.value
					then n.count := n.count + 1;
				elseif v < n.value
					then n.lesser := wordtree$insert (n.lesser, v);
				else n.greater := wordtree$insert (n.greater, v);
				end;
			return x;
		end;
	end insert;

print = proc (x: cvt, total: int, o: outstream);
	tagcase x
		tag empty: ;
		tag non_empty (n: node):
			wordtree$print (n.lesser, total, o);
			print_word (n.value, n.count, total, o);
			wordtree$print (n.greater, total, o);
		end;
	end print;

end wordtree;
.ns
.end_code
.finish_figure
For any
particular node, the words in the ``lesser'' subtree must
alphabetically precede the word in the node, and the words
in the ``greater'' subtree must follow the word in the node.
.ne 4
This information is described by 
.code
	node = record [m!value: string, count: int,
(mark!m)lesser: wordtree, greater: wordtree];
.end_code
which defines ``node'' to be an
abbreviation for the information following
the equal sign.
(The reserved word rep is used similarly,
as an abbreviation for the representation type.)
.para
Now consider the representation of wordtrees.
A non-empty wordtree can be represented by its top node.
An empty wordtree, however, contains no information.
The ideal type to represent an empty wordtree
is the CLU type null,
which has a single data object nil.
So the representation of a wordtree should
be either a node or nil.
.ne 3
This representation is expressed by
.code
	rep = oneof [empty: null, non_empty: node];
.end_code
.para
Just as the record is the basic CLU
mechanism to form an object
that is a collection of other objects,
the oneof is the basic CLU mechanism to form an object
that is ``one of'' a set of alternatives.
Oneof is CLU's method of forming a
discriminated union, and is somewhat similar to 
a variant component of a record in Pascal [Wir71b].
.para
An object of the type oneof@[s1:@T1 dots sn:@Tn]
can be thought of as a pair.
The ``tag'' component is an
identifier from the set {s1 dots sn}.
The ``value''
component is an object of the type corresponding to the
tag.
That is, if the tag component is si then the
value is some object of type Ti.
.para
Objects of type oneof@[s1:@T1 dots sn:@Tn]
are created by the operations 2make_si@(x)*, each of
which takes an object x of type Ti
and returns the pair <si,@x>.
Because the type of the value component of a oneof object is not
known at compile-time, allowing direct access
to the value component
could result in a run-time type error (e.g., assigning an object
to a variable of the wrong type).  To eliminate this possibility,
.ne 7
we require the use of a special tagcase statement to decompose
a oneof object:
.code
	tagcase e
		tag s1 (id1: T1):  @@@m!statements dots
			dots
		tag sn (idn: Tn):(mark!m)statements dots
		end;
.end_code
This statement evaluates the expression 2e*
to obtain an object of type
oneof@[s1:@T1@dots@sn:@Tn].
If the tag is si,
then the value is assigned to the new variable
idi and the statements following the ith alternative
are executed.
The variable idi is local to those statements.
If, for some reason, we do not need the value,
we can omit the parenthesized variable declaration.
.para
The reader should now know enough to understand
Figure wordtree.
Note, in the create operation, the use
of the construction operation 2make_empty*
of the representation type of wordtree
(the discriminated union oneof@[empty:@null,@non-empty:@node])
to create the empty wordtree.
The tagcase statement is used in both insert and print.
Note that if insert is given an empty wordtree, it creates a
new top node for the returned value,
but if insert is given a non-empty wordtree,
it modifies the given wordtree and returns it.
.foot
It is necessary for insert to return a value in addition to
having a side-effect because, in the case of an empty wordtree
argument, side-effects are not possible.  Side-effects are not
possible because of the representation chosen for the empty
wordtree and because of the CLU parameter passing mechanism
(see Section semantics).
.efoot
The insert operation depends on the dynamic
allocation of space for newly-created records (see
Section semantics).
.para
The print operation uses the obvious recursive descent.
It makes use of procedure
2print_word@(w,@c,@t,@o)*, which generates a single line of
output on 2o*, consisting of the word 2w*,
the count 2c*, and the frequency of occurrence
derived from 2c* and 2t*.
The implementation of 2print_word* has been omitted.
.para
We have now completed
our first discussion of the count_words procedure.
We return to this problem in Section more_abstraction,
where we present a superior solution.
