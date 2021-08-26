.nd chapter 4-1
.nd current_figure 7
.so clu/clupap.header
.
.sr words 2words*
.sr wordbag 2wordbag*
.sr sorted_bag 2sorted_bag*
.sr sorted_bags 2sorted_bags*
.sr wordtree 2wordtree*
.sr tree 2tree*
.sr node 2node*
.sr r 2r*
.sr x 2x*
.sr t 2t*
.sr count_words 2count_words*
.sr count_numeric 2count_numeric*
.sr lt 2lt*
.sr equal 2equal*
.sr print 2print*
.sr string_chars 2string_chars*
.sr create 2create*
.sr insert 2insert*
.sr size 2size*
.sr increasing 2increasing*
.sr s 2s*
.sr n 2n*
.sr index 2index*
.sr limit 2limit*
.sr count 2count*
.sr next_word 2next_word*
.sr elements 2elements*
.sr reverse_elements 2reverse_elements*
.
.
.chapter "More Abstraction Mechanisms"
.para
In this section we continue our discussion of
abstraction mechanisms in CLU.
A generalization of the 2wordbag* abstraction,
called 2sorted_bag*,
is presented as an illustration of parameterized clusters,
which are a means for implementing
more generally applicable data abstractions.
The presentation of 2sorted_bag*
is also used to motivate the introduction of a control
abstraction called an 2iterator*,
which is a mechanism for incrementally generating 
the elements of a collection of objects.
Finally, we show an implementation of the sorted_bag
abstraction and illustrate how sorted_bag
can be used in implementing count_words.
.section "Properties of the Sorted_bag Abstraction"
.para
In the count_words procedure given earlier,
a data abstraction called wordbag was used.
A wordbag object is a collection of strings,
each with an associated count.
Strings are inserted into a wordbag object one at a time.
Strings in a wordbag object may be printed in alphabetical order,
each with a count of the number of times it was inserted.
.para
Although wordbag has properties that are specific to the usage
in count_words,
it also has properties in common with a more general abstraction,
sorted_bag.
A bag is similar to a set
(it is sometimes called a multi-set)
except that an item can appear in a bag many times.
For example, if the integer 1 is inserted in the set {1,2},
the result is the set {1,2},
but if 1 is inserted in the bag {1,2},
the result is the bag {1,1,2}.
A sorted_bag is a bag that affords access
to the items it contains
according to an ordering relation on the items.
.para
The concept of a sorted_bag is meaningful not only for strings
but for many types of items.
Therefore, we would like to parameterize the sorted_bag abstraction,
the parameter being the type of item to be collected
in the sorted_bag objects.
.para
Most programming languages provide built-in parameterized
data abstractions.
For example, the concept of an array is a parameterized
data abstraction.
.ne 3
An example of a use of arrays in Pascal is
.code
	1array* 1..n 1of* 1integer*
.end_code
These arrays have two parameters,
one specifying the array bounds (1..n)
and one specifying the type of element in the array (integer).
In CLU we provide mechanisms allowing user-defined
data abstractions (like sorted_bag) to be parameterized.
.para
In the sorted_bag abstraction,
not all types of items make sense.
Only types that define a total ordering on their objects
are meaningful,
since the sorted_bag abstraction depends on the presence
of this ordering.
In addition, information about the ordering must be
expressed in a way that is useful for programming.
A natural way to express this information
is by means of operations of the item type.
Therefore, we require that the item type provide
less than and equal operations
(called lt and equal).
.ne 5
This constraint is expressed in the header for sorted_bag:
.code
	sorted_bag = cluster [t: type] is create, insert, dots
		where t has
			lt, equal: proctype (t, t) returns (bool);
.end_code
The item type t is a 2formal parameter* of the sorted_bag
cluster; whenever the sorted_bag abstraction is used,
.ne 3
the item type must be specified as an 2actual parameter*, e.g.,
.code
	sorted_bag[string]
.end_code
.para
The information about required operations
informs the programmer about legitimate uses of sorted_bag.
The compiler will check each use of sorted_bag to ensure
that the item type provides the required operations.
The where clause specifies exactly the information
that the compiler can check.
Of course, more is assumed about the item type 2t*
than the presence of 
operations with appropriate names and functionalities:
these operations must also define a total ordering on the items.
Although we expect formal and complete specifications
for data abstractions to be included in the CLU library eventually,
we do not include in the CLU language declarations
that the compiler cannot check.
This point is discussed further in Section discussion.
.para
Now that we have decided to define a
sorted_bag abstraction that works for many item types,
we must decide what operations this abstraction provides.
When an abstraction (like wordbag)
is written for a very specific purpose,
it is reasonable to have
some specialized operations.
For a more general abstraction,
the operations should be more generally useful.
.para
The 2print* operation is a case in point.
Printing is only one possible use of the information contained
in a 2sorted_bag*.
It was the only use in the case of 2wordbag*,
so it was reasonable to have a 2print* operation.
However, if 2sorted_bags* are to be generally useful,
there should be some way for the user to obtain
the elements of the 2sorted_bag*; the user can then
perform some action on the elements (for example, print them).
.para
What we would like is an operation on sorted_bags
that makes all of the elements available to the caller
in increasing order.
One possible approach is to map
the elements of a sorted_bag
into a sequence object,
a solution potentially requiring a large amount of space.
A more efficient method is provided by CLU and is discussed below.
This solution computes the sequence
one element at a time, thus saving space.
If only part of the sequence is used
(as in a search for some element),
then execution time can be saved as well.
.section "Control Abstractions"
.para
The purpose of many loops is to perform an action
on some or all of the objects in a collection.
For such loops,
it is often useful to separate the
selection of the next object
from the action performed on that object.
CLU provides a control abstraction that permits
a complete decomposition of the two activities.
The for statement available in many programming languages
provides a limited ability in this direction:
it iterates over ranges of integers.
The CLU for statement
can iterate over collections of any
type of object.
The selection of the next object in the collection
is done by a user-defined 2iterator*.
The iterator
produces the objects in the collection one at a time
(the entire collection need not physically exist);
each object is consumed by the for statement in turn.
.nr rra0 current_figure
.para
Figure rra0 gives an example of a simple iterator
called string_chars, which produces the characters in a string in
the order in which they appear.
.begin_figure "Use and definition of a simple iterator."
.code
count_numeric = proc (s: string) returns (int);
	count: int := 0;
	for c: char in string_chars (s) do
		if char_is_numeric (c)
			then count := count + 1;
			end;
		end;
	return count;
	end count_numeric;

string_chars = iter (s: string) yields (char);
	index: int := 1;
	limit: int := string$size (s);
	while index <= limit do
		yield string$fetch (s, index);
		index := index + 1;
		end;
	end string_chars;
.ns
.end_code
.finish_figure
This iterator uses string operations 2size@(s)*,
which tells how many characters are in the string s,
and 2fetch@(s,@n)*,
which returns the n!th character in the string s
(provided the integer n is greater than zero
and does not exceed the size of the string).
.foot
A while loop is used in the implementation of
string_chars so that the example would be based
on familiar concepts.  In actual practice, such a
loop would be written using a for statement invoking
a primitive iterator.
.efoot
.br
.ne 5
.para
The general form of the CLU for statement is
.code
	for declarations in iterator-invocation do
		body
		end;
.end_code
An example of the use of the for statement
occurs in the count_numeric procedure
(see Figure rra0),
which contains a loop
that counts the number of numeric characters in a string.
Note that the details of how the characters are obtained
from the string are entirely contained
in the definition of the iterator.
.para
Iterators work as follows:
A for statement initially invokes an iterator,
passing it some arguments.
Each time a yield statement is executed in the iterator,
the objects yielded
.foot
Zero or more objects may be yielded,
but the number and types of objects yielded each time by an iterator
must agree with the number and types of variables in
a for statement using the iterator.
.efoot
are assigned to the variables declared in the for statement
(following the reserved word for)
in corresponding order, and the body of the for
statement is executed.
Then the iterator is resumed at the statement
following the yield statement,
in the same environment as when the objects were yielded.
When the iterator terminates, by either an implicit
or explicit return, then the invoking for statement
terminates.  The iteration may also be prematurely
terminated by a return in the body of the
for statement.
.para
For example, suppose that string_chars is invoked
with the string ``a3''.
The first character yielded is `a'.
At this point within string_chars, index@=@1 and limit@=@2.
Next the body of the for statement is performed.
Since the character `a' is not numeric,
count remains at 0.
Next string_chars is resumed at the statement after the yield
statement, and when resumed, index@=@1 and limit@=@2.
Then index is assigned 2,
and the character `3' is selected from the string and yielded.
Since `3' is numeric, count becomes@1.
Then string_chars is resumed,
with index@=@2 and limit@=@2, and index is incremented,
which causes the while loop to terminate.
The implicit return terminates both the iterator and the
for statement, with control resuming at the statement
after the for statement,
and count@=@1.
.para
While iterators are useful in general,
they are especially valuable in conjunction with data abstractions
that are collections of objects (such as sets, arrays, and
sorted_bags).
Iterators afford users of such abstractions access to all objects
in the collection, without exposing irrelevant details.
Several iterators may be included in a data abstraction.
When the order of obtaining the objects is important,
different iterators may provide different orders.
.section "Implementation and Use of Sorted_bag"
.para
Now we can describe a minimal set of operations
for sorted_bag.
The operations are create, insert, size, and increasing.
2Create*, insert, and size are procedural abstractions
that, respectively,
create a sorted_bag, insert an item into a sorted_bag,
and give the number of items in a sorted_bag.
2Increasing* is a control abstraction
that produces the items in a sorted_bag in increasing order;
each item produced is accompanied by
an integer representing the number of times
the item appears in the sorted_bag.
Note that other operations might also
be useful for sorted_bag,
for example, an iterator yielding the items
in decreasing order.
In general, the definer of a data abstraction
can provide as many operations as seems reasonable.
.para
In Figure current_figure, we give an implementation
of the sorted_bag abstraction.
.begin_figure "The sorted_bag cluster."
.code
sorted_bag = cluster [t: type] is create, insert, size, increasing
	where t has equal, lt: proctype (t, t) returns (bool);

	rep = record [contents: tree[t], total: int];

create = proc () returns (cvt);
	return rep${contents: tree[t]$create (), total: 0};
	end create;

insert = proc (sb: cvt, v: t);
	sb.contents := tree[t]$insert (sb.contents, v);
	sb.total := sb.total + 1;
	end insert;

size = proc (sb: cvt) returns (int);
	return sb.total;
	end size;

increasing = iter (sb: cvt) yields (t, int);
	for item: t, count: int
		in tree[t]$increasing (sb.contents) do
			yield item, count;
			end;
	end increasing;

end sorted_bag;
.ns
.end_code
.finish_figure
It is implemented using a sorted binary tree,
just as wordbag was implemented.
Thus, a subsidiary abstraction is necessary.
This abstraction, called tree, is a generalization
of the wordtree abstraction (used in Section example),
which has been parameterized to work for all ordered types.
An implementation of tree is given in Figure current_figure.
Notice that both the tree abstraction and the sorted_bag abstraction
place the same constraints on their type parameters.
.begin_page_figure "The tree cluster."
.code
tree = cluster [t: type] is create, insert, increasing
	where t has equal, lt: proctype (t, t) returns (bool);

	node = record [m!value: t, count: int,
(mark!m)lesser: tree[t], greater: tree[t]];
	rep = oneof [empty: null, non_empty: node];

create = proc () returns (cvt);
	return rep$make_empty (nil);
	end create;

insert = proc (x: cvt, v: t) returns (cvt);
	tagcase x
		tag empty:
			n: node := node${m!value: v, count: 1,
(mark!m)lesser: tree[t]$create (),
(mark!m)greater: tree[t]$create ()};
			return rep$make_non_empty (n);
		tag non_empty (n: node):
			if t$equal (v, n.value)
					then n.count := n.count + 1;
				elseif t$lt (v, n.value)
					then n.lesser := tree[t]$insert (n.lesser, v);
				else n.greater := tree[t]$insert (n.greater, v);
				end;
			return x;
		end;
	end insert;

increasing = iter (x: cvt) yields (t, int);
	tagcase x
		tag empty: ;
		tag non_empty (n: node):
			for item: t, count: int
				in tree[t]$increasing (n.lesser) do
					yield item, count;
					end;
			yield n.value, n.count;
			for item: t, count: int
				in tree[t]$increasing (n.greater) do
					yield item, count;
					end;
		end;
	end increasing;
end tree;
.ns
.end_code
.finish_figure
.para
An important feature of the 2sorted_bag*
and 2tree* clusters
is the way that the cluster parameter is used in places
where the type string was used in wordbag and wordtree.
This usage is especially evident in the implementation of tree.
For example, tree has a representation that stores values of
type t: the 2value* component of a node
must be an object of type t.
.para
In the insert operation of tree,
the lt and equal operations of type t are used.
We have used the compound form, e.g. 2t$equal@(v,@n.value)*,
to emphasize that the equal operation of t is being used.
The short form, 2v@=@n.value*, could have been used instead.
.para
The increasing iterator of tree works as follows:
First it yields all items in the current tree
that are less than the item at the top node;
the items are obtained by a recursive use of itself,
passing the 2lesser* subtree as a parameter.
Next it yields the contents of the top node,
and then it yields all items in the current tree
that are greater than the item at the top node
(again by a recursive use of itself).
In this way it performs a complete walk over the tree,
yielding the values at all nodes, in increasing order.
.nr rra1 current_figure
.para
Finally, we show in Figure rra1 how the original
procedure count_words can be implemented in terms of sorted_bag.
.begin_figure "The count_words procedure using iterators."
.code
count_words = proc (i: instream, o: outstream);

	wordbag = sorted_bag[string];

	% create an empty wordbag
	wb: wordbag := wordbag$create ();

	% scan document, adding each word found to wb
	for word: string in words (i) do
		wordbag$insert (wb, word);
		end;

	% print the wordbag
	total: int := wordbag$size (wb);
	for w: string, count: int in wordbag$increasing (wb) do
		print_word (w, count, total, o);
		end;
	end count_words;
.ns
.end_code
.finish_figure
.
Note that the count_words procedure now uses 2sorted_bag*[string]
instead of wordbag.
2Sorted_bag*[string] is legitimate, since the type string
provides both lt and equal operations.
Note that two for statements are used in count_words.
The second for statement prints the words
in alphabetic order,
using the increasing iterator of sorted_bag.
.ne 4
The first for statement inserts the words into the sorted_bag;
it uses an iterator
.code
	words = iter (i: instream) yields (string);
		dots
		end words;
.widow 2
.end_code
The definition of words is left as an exercise for the reader.
