# include "c/c.defs"

int s_hit;
extern int cout;

setsf ()
	{s_hit = TRUE;
	tyo ('\r');
	}

main (argc, argv) int argc; char *argv[];

	{if (ask ("Would you rather play Othello instead", 0)) othello ();
	zork ();
	}

zork ()

	{filespec fs;

	fs.dev = csto6 ("DSK");
	fs.dir = csto6 ("SYS2");
	fs.fn1 = csto6 ("TS");
	fs.fn2 = csto6 ("ZORK");
	bootstrap (&fs);
	cprint ("I'm sorry, ZORK does not seem to be available\n");
	}

othello ()

	{filespec fs;

	cprint ("Play Othello and see if you can beat the system!\n");
	if (!ask ("Have you played the Othello program before", 0))
		{if (!ask ("Do you know how to play Othello", 0))
			type_file ("DSK:.INFO.;O INFO");
		else cprint ("Type ? for help.\n\
Moves are entered by typing the XY coordinates of the\n\
legal move followed by carriage return (no commas please).\n\
Type R<CR> to resign.\n");
		cprint ("--MORE--");
		utyi ();
		}

	fs.dev = csto6 ("DSK");
	fs.dir = csto6 ("SYS2");
	fs.fn1 = csto6 ("TS");
	fs.fn2 = csto6 ("O");
	bootstrap (&fs);
	cprint ("I'm sorry, Othello does not seem to be available\n");
	}

int type_file (s)
	char *s;

	{int f;
	f = copen (s, 'r');
	if (f == OPENLOSS) return;
	s_hit = FALSE;
	on (ctrls_interrupt, 1);
	on (ctrls_interrupt, setsf);
	file_type (f);
	cclose (f);
	on (ctrls_interrupt, 0);
	}

file_type (in)

	{int c;

	if (s_hit) return;
	cputc ('\n', cout);
	while ((c = cgetc (in)) > 0 || !ceof (in))
		{cputc (c, cout);
		if (s_hit) break;
		}
	if (!s_hit) cputc ('\n', cout);
	}

int ask (s, flag)
	char *s;

	{int c;

	if (flag=='+') return (TRUE);
	if (flag=='-') return (FALSE);
	while (TRUE)
		{tyos (s);
		tyos (" (Y or N)? ");
		while (TRUE)
			{c = lower (utyi ());
			if (c=='y') {tyos ("yes\r"); return (TRUE);}
			if (c=='n') {tyos ("no\r"); return (FALSE);}
			if (c=='\p') {spctty ('C'); break;}
			tyo (07);
			}
		}
	}

char *sconcat(buf,n,s1,s2,s3)
	char *s1, *s2, *s3;

	{int c;
	char **s, *p, *q;
	p = buf;
	s = &s1;
	while (--n >= 0)
		{q = *s++;
		while (c = *q++) *p++ = c;
		}
	*p = 0;
	return (buf);
	}

