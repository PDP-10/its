# define nwords 1500		/* number of different words */
# define wsize 20		/* max chars per word */
# define tnode struct _tnode	/* make tnode look like a type */

struct _tnode	/* the basic structure */
	{char tword[wsize];
	int count;
	tnode *left, *right;
	};

tnode space[nwords];	/* the words themselves */
int nnodes nwords;	/* number of remaining slots */
tnode *nextp space;	/* next available slot */
tnode *freep;		/* free list */

/*
 * The main routine reads words until end-of-file ('\0' returned from "getchar")
 * "tree" is called to sort each word into the tree.
 */


main (argc, argv)
	int argc;
	char *argv[];

	{tnode *top, *tree();
	char c, word[wsize];
	int i;

	i = top = 0;
	while (c = getchar ())
		{if ('A'<=c && c <= 'Z') c =+ ('a' - 'A');
		if ('a'<=c && c<='z')
			{if (i<wsize-1)
				word[i++] = c;
			}
		else
			if (i)
				{word[i++] = '\0';
				top = tree (top, word);
				i = 0;
				}
		}
	tprint (top);
	}

/*
 * The central routine.  If the subtree pointer is null, allocate a new node for it.
 * If the new word and the node's word are the same, increase the node's count.
 * Otherwise, recursively sort the word into the left or right subtree according
 * as the argument word is less or greater than the node's word.
 */

tnode *tree (p, word)
	tnode *p;
	char word[];

	{tnode *alloc ();
	int cond;

	/* Is pointer null? */
	if (p == 0)
		{p = alloc ();
		copy (word, p->tword);
		p->count = 1;
		p->right = p->left = 0;
		return (p);
		}
	/* Is word repeated? */
	if ((cond = compar (word, p->tword)) == 0)
		{p->count++;
		return (p);
		}
	/* Sort into left or right */
	if (cond < 0)
		p->left = tree (p->left, word);
	else
		p->right = tree (p->right, word);
	return (p);
	}

/*
 * Print the tree by printing the left subtree, the given node, and the right subtree.
 */

tprint (p)
	tnode *p;

	{while (p)
		{tprint (p->left);
		cprint ("%4d:  %s\n", p->count, p->tword);
		p = p->right;
		}
	}

/*
 * String comparison: return number (>, =, <) 0
 * according as s1 (>, =, <) s2.
 */

compar (s1, s2)
	char *s1, *s2;

	{int c1, c2;

	while ((c1 = *s1++) == (c2 = *s2++))
		if (c1 == '\0') return (0);
	return (c1-c2);
	}

/*
 * String copy: copy s1 into s2 until the null
 * character appears.
 */

copy (s1, s2)
	char *s1, *s2;

	{while (*s2++ = *s1++);
	}

/*
 * Node allocation: return pointer to a free node.
 * Bomb out when all are gone.  Just for fun, there
 * is a mechanism for using nodes that have been
 * freed, even though no one here calls "free."
 */

tnode *alloc ()

	{tnode *t;

	if (freep)
		{t = freep;
		freep = freep->left;
		return (t);
		}
	if (--nnodes < 0)
		{cprint ("Out of space\n");
		cexit (1);
		}
	return (nextp++);
	}

/*
 * The uncalled routine which puts a node on the free list.
 */

free (p)
	tnode *p;

	{p->left = freep;
	freep = p;
	}

