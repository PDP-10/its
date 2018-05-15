# include <c.defs>
# define QUOTE 22	/* control-V */

/**********************************************************************

	EXPAND ARGUMENT VECTOR CONTAINING FILE NAME PATTERNS
	TOPS-20 Version

**********************************************************************/

static char **next;
static char *bufp;

int exparg (argc, argv, outv, buffer)
	char *argv[], *outv[], buffer[];

	{register int i;
	int expfile();
	register char *s;

	bufp = buffer;
	next = outv;
	i = 0;
	while (i < argc)
		{s = argv[i++];
		if (expmagic (s)) fdmap (s, expfile);
		else *next++ = s;
		}
	return (next - outv);
	}

int expmagic (s)	/* does it contain magic pattern chars? */
	register char *s;

	{register int c;
	while (c = *s++) switch (c) {
		case '%':
		case '*':	return (TRUE);
		case QUOTE:	if (*s) ++s; continue;
		}
	return (FALSE);
	}

expfile (s)
	register char *s;

	{*next++ = bufp;
	while (*bufp++ = *s++);
	}
