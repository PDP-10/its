# include "c/c.defs"

extern int cout, cerr;

main (argc, argv) int argc; char *argv[];

	{filespec fs;
	int snum, c, fin, fout;
	int tflag, qflag, sflag, cflag, nflag, mflag, gflag, pflag,
		hflag, bflag;
	char *p, *name, fname[40], sname[12], buf[10];

	if (argc<2)
		{puts ("\
Usage: CMUD name1 name2 ...\n\
To COMBAT files name1.cmud (or name1.mud or name1.>), name2.cmud ...\n\
Options:\n\
	-q	quick (RIOT instead of COMBAT)\n\
	-p	write PCOMP file instead of COMBAT\n\
	-c	be CAREFUL\n\
	-s	default SPECIAL\n\
	-n	use NEW muddle compiler\n\
	-m	use CLU macros\n\
	-g	GROUP compile\n\
	-h	do HAIRY-ANALYSIS\n\
	-b	big compilation: use MAX-SPACE\n\
	-t	test: output to TTY\n");
		return;
		}

	c6tos (rsname (), sname);
	pflag = tflag = qflag = sflag = cflag = nflag = mflag = gflag
		= hflag = bflag = FALSE;
	for (snum=1;snum<argc;++snum)
		{name = argv[snum];
		if (name[0]=='-')
			{p = name+1;
			while (c = *p++) switch (lower (c)) {

	case 't':	tflag=TRUE; break;
	case 'q':	qflag=TRUE; break;
	case 'p':	pflag=TRUE; break;
	case 's':	sflag=TRUE; break;
	case 'c':	cflag=TRUE; break;
	case 'n':	nflag=TRUE; break;
	case 'm':	mflag=TRUE; break;
	case 'g':	gflag=TRUE; break;
	case 'h':	hflag=TRUE; break;
	case 'b':	bflag=TRUE; break;
	default:	cprint ("Unrecognized Option: '%c'\n", c);
				}
			continue;
			}

		fs.dev = csto6 ("dsk");
		fs.dir = rsname ();
		fs.fn1 = csto6 (name);
		fs.fn2 = csto6 ("cmud");

		fin = open (&fs, 0);
		if (fin<0)
			{fs.fn2 = csto6 ("mud");
			fin = open (&fs, 0);
			}
		if (fin<0)
			{fs.fn2 = csto6 (">");
			fin = open (&fs, 0);
			}
		if (fin<0)
			{cprint (cerr, "Can't find %s\n", name);
			continue;
			}
		close (fin);

		prfile (&fs, fname);
		c6tos (fs.fn1, buf);

		on (ctrlg_interrupt, 1);
		fout = tflag ? cout : copen (pflag ? "pcomp.>" :
			(qflag ? "/dsk/combat/riot.>" :
				"/dsk/combat/plan.>"), 'w');

		if (fout<0)
			{cprint (cerr, "Unable to write PLAN file");
			return (-1);
			}

		cprint (fout, "<SNAME \"%s\">\n", sname); 
		if (nflag) cprint (fout,
		 "<COND (<AND <GASSIGNED? EXPERIMENTAL!-> ,EXPERIMENTAL> <GC-MON <>>)\n\
       (T <CLOSE %.INCHAN> <NEWCOMP!->)>\n");
		cprint (fout, "<SETG COMBAT!- \"%s\">\n", fname);
		if (gflag) cprint (fout, "<SET GROUP-MODE %s>\n", buf);
		if (!cflag) cprint (fout, "<SET CAREFUL <>>\n");
		if (sflag) cprint (fout, "<SET SPECIAL T>\n");
		cprint (fout, "<SET REASONABLE T>\n");
		cprint (fout, "<SET GLUE T>\n");
		cprint (fout, "<SETG USE-RGLOC T>\n");
		if (!hflag) cprint (fout, "<SET HAIRY-ANALYSIS <>>\n");
		if (bflag) cprint (fout, "<SET MAX-SPACE T>\n");
		if (mflag) cprint (fout, "<FLOAD \"CLU;CLU MACROS\">\n");
		cprint (fout, "<PROG () <CLOSE %.INCHAN>\n");
		cprint (fout, "<COND (<SETG LOSER <FILE-COMPILE \"%s\">>)\n", fname);
		cprint (fout, " (<ERROR ,LOSER>)> <QUIT>>\n");
		if (!tflag) cclose (fout);
		if (!pflag) demsig (csto6 ("zone"));
		on (ctrlg_interrupt, 0);
		cprint ("queued: %s\n", fname);
		}
	}
