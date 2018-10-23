# include "c.defs"

/**********************************************************************

	SMATCH - pattern matching procedure

	The pattern P is a character string which is to be matched
	with the data string S.  Certain characters in P are treated
	special:

		'*'	match any substring
		'?'	match any character
		'\\'	quote following character

**********************************************************************/

int smatch (p, s)
	char *p;
	char *s;

	{int c1, c2, i;

	while (TRUE)
		{c1 = *p++;
		c2 = *s++;
		switch (c1) {

	case 0:		return (!c2);
	case '?':	if (!c2) return (FALSE);
			continue;
	case '*':	while (*p=='*') ++p;
			if (*p==0) return (TRUE);
			i = -1;
			do if (smatch (p, s+i)) return (TRUE);
			   while (s[i++]);
			return (FALSE);
	case '\\':	if (!(c1 = *p++)) return (FALSE);
			/* fall through */
	default:	if (c1 != c2) return (FALSE);
			continue;
			}
		}
	}

/**********************************************************************

	SINDEX (P, DS)  

	Return the index of the first occurrence of the string P
	in the string DS.  Return -1 if P does not occur in DS.

**********************************************************************/

int sindex (p, ds)
	char *p;
	char *ds;

	{int c1, c2, start;
	char *s, *t1, *t2, *tail;

	s = ds;
	start = p[0];
	tail = p+1;
	if (start) while (TRUE)
		{while ((c2 = *s++) != start)
			if (c2==0) return (-1);
		t1 = tail;
		t2 = s;
		while ((c1 = *t1++) == (c2 = *t2++))
			if (c1==0) break;
		if (c1==0) break;
		}
	return (s-ds-1);
	}

# ifdef test

int main ()

	{char buf1[100], buf2[100];

	while (TRUE)
		{cprint ("Pattern: ");
		gets (buf1);
		cprint ("Data: ");
		gets (buf2);
		if (smatch (buf1, buf2))
			cprint ("Matched.\n");
		else cprint ("No match.\n");
		}
	}

# endif
