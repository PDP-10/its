# include "c/c.defs"

/**********************************************************************

	EXPAND ARGUMENT VECTOR CONTAINING FILE NAME PATTERNS

**********************************************************************/

static char **next;
static char *bufp;

int exparg (argc, argv, outv, buffer)
	char *argv[], *outv[], buffer[];

	{int i, expfs();
	char *s;

	bufp = buffer;
	next = outv;
	i = 0;
	while (i<argc)
		{s = argv[i++];
		if (expmagic (s)) mapdir (s, expfs);
		else *next++ = s;
		}
	return (next-outv);
	}

int expmagic (s)	/* does it contain magic pattern chars? */
	char *s;

	{int c, flag;
	flag = FALSE;
	while (c = *s++) switch (c) {
		case '?':
		case '*':	flag = TRUE; continue;
		case '/':	flag = FALSE; continue;
		case '\\':	if (*s) ++s; continue;
		}
	return (flag);
	}

expfs (fs)
	filespec *fs;

	{char *prfile (), *p;
	p = bufp;
	bufp = (prfile (fs, bufp)) + 1;
	*next++ = p;
	}
