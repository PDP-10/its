# include "c.defs"

/*
 * grep -- print lines matching (or not matching) a pattern
 *
 */

# define	STAR	1
# define	CCHR	2
# define	CDOT	4
# define	CCL	6
# define	NCCL	8
# define	CDOL	10
# define	EOF	11

# define	LBSIZE	1000
# define	ESIZE	256

char		expbuf[ESIZE], linebuf[LBSIZE+1];
long int	lnum, count;
int		nflag, cflag, vflag;
int		nfile;
int		circf;

extern int cin, cout, cerr;

quitter ()
	{cexit (1);}

main (argc, argv)
	char **argv;

	{char *outv[50], buffer[1000];
	on (ctrlg_interrupt, quitter);
	on (ctrls_interrupt, quitter);

	if (argc==1)
		{cprint ("Usage: grep {options} pattern file1 file2 file3...\n");
		cprint ("Options are:\n");
		cprint ("\t-v (print lines which don't match)\n");
		cprint ("\t-n (print line numbers of matching lines)\n");
		cprint ("\t-c (just count matching lines)\n");
		cexit (2);
		}

	while (--argc > 0 && (++argv)[0][0]=='-')
		switch (argv[0][1]) {
		case 'v':	vflag++; continue;
		case 'c':	cflag++; continue;
		case 'n':	nflag++; continue;
		default:	error ("Unknown flag: %s\n", argv[0]+1);
				continue;
				}
	if (argc<=0) cexit (2);
	compile (*argv);
	nfile = --argc;
	if (argc<=0) execute(0);
	else
		{nfile = argc = exparg (argc, ++argv, outv, buffer);
		argv = outv;
		while (--argc >= 0) execute (*argv++);
		}
	cexit (0);
	}

compile (astr)
	char *astr;

	{register int c;
	register char *ep, *sp;
	char *lastep;
	int cclcnt;

	ep = expbuf;
	sp = astr;
	if (*sp == '^')
		{circf++;
		sp++;
		}
	for (;;)
		{if (ep >= &expbuf[ESIZE]) goto cerror;
		if ((c = *sp++) != '*') lastep = ep;
		switch (c) {
		case '\0':	*ep++ = EOF; return;
		case '.':	*ep++ = CDOT; continue;
		case '*':	if (lastep==0) goto defchar;
				*lastep =| STAR;
				continue;
		case '$':	if (*sp != '\0') goto defchar;
				*ep++ = CDOL;
				continue;
		case '[':	*ep++ = CCL;
				*ep++ = 0;
				cclcnt = 1;
				if ((c = *sp++) == '^')
					{c = *sp++;
					ep[-2] = NCCL;
					}
				do {
					*ep++ = c;
					cclcnt++;
					if (c=='\0' || ep >= &expbuf[ESIZE])
						goto cerror;
					} while ((c = *sp++) != ']');
				lastep[1] = cclcnt;
				continue;
		case '\\':	if ((c = *sp++) == '\0') goto cerror;
		defchar:
		default:	*ep++ = CCHR;
				*ep++ = c;
			}
		}
cerror:	fatal ("Bad regular expression\n");
	}

execute (file)

	{register char *p1, *p2;
	register int c;
	int f;

	if (file)
		{if ((f = copen (file, 'r')) == OPENLOSS)
			{error ("Can't open %s\n", file);
			return;
			}
		}
	else f = cin;
	lnum = 0;
	count = 0;

	for (;;)
		{++lnum;
		rdline (linebuf, f, LBSIZE);
		if (!linebuf[0] && ceof (f))
			{if (f != cin) cclose (f);
			if (cflag)
				{if (nfile > 1) cprint ("%s: ", file);
				cprint ("%d\n", count);
				}
			return;
			}
		p1 = linebuf;
		p2 = expbuf;
		if (circf)
			{if (advance(p1, p2)) goto found;
			goto nfound;
			}
		/* fast check for first character */
		if (*p2==CCHR)
			{c = p2[1];
			do {
				if (*p1!=c) continue;
				if (advance(p1, p2)) goto found;
				} while (*p1++);
			goto nfound;
			}
		/* regular algorithm */
		do {
			if (advance(p1, p2)) goto found;
			} while (*p1++);
	nfound:	if (vflag) succeed(file);
		continue;
	found:	if (vflag==0) succeed(file);
		}
	}

advance (alp, aep)

	{register char *lp, *ep, *curlp;

	lp = alp;
	ep = aep;
	for (;;) switch (*ep++) {
	case CCHR:	if (*ep++ == *lp++) continue;
			return(0);
	case CDOT:	if (*lp++) continue;
			return(0);
	case CDOL:	if (*lp==0) continue;
			return(0);
	case EOF:	return(1);
	case CCL:	if (cclass(ep, *lp++, 1))
				{ep =+ *ep;
				continue;
				}
			return(0);
	case NCCL:	if (cclass(ep, *lp++, 0))
				{ep =+ *ep;
				continue;
				}
			return(0);
	case CDOT|STAR:	curlp = lp;
			while (*lp++);
			goto do_star;
	case CCHR|STAR:	curlp = lp;
			while (*lp++ == *ep);
			ep++;
			goto do_star;
	case CCL|STAR:
	case NCCL|STAR:	curlp = lp;
			while (cclass(ep, *lp++, ep[-1]==(CCL|STAR)));
			ep =+ *ep;
			goto do_star;
	do_star:	do {
				lp--;
				if (advance(lp, ep)) return (1);
				} while (lp > curlp);
			return(0);
	default:	fatal ("internal RE botch\n");
		}
	}

cclass (aset, ac, af)

	{register char *set, c;
	register int n;

	set = aset;
	if ((c = ac) == 0) return(0);
	n = *set++;
	while (--n) if (*set++ == c) return(af);
	return(!af);
	}

fatal (s, a)

	{error (s, a);
	cexit (2);
	}

error (s, a)

	{cprint (cerr, s, a);
	}

succeed(f)

	{if (cflag) {++count; return;}
	if (nfile > 1) cprint ("%s: ", f);
	if (nflag) cprint ("%d: ", lnum);
	cprint ("%s\n", linebuf);
	}

/**********************************************************************

	RDLINE

**********************************************************************/

rdline (buf, f, size)
	char *buf;

	{int c;

	--size;
	while ((c = cgetc (f)) != '\n' && c)
		if (size>0) {*buf++ = c; --size;}
	*buf = 0;
	}

