# include	"o.h"
# ifdef unix
char	*log	"/usr/games/o.log";
# endif
# ifndef unix
char	*log		"c/_    o.stat";
char	*recfile	"as/o.record";
# endif
char	*svgame	"o.game";

# define MVNREAL 6	/* after this move, game is for real */

int	n_inhibit;
char	username[100];
static int wizard;
char	buf[BUFSIZ];
char	gambuf[1000];
FILE	*gamefile;
char	*timestring;
int	fcnt[3];
int	machine[3];
int	manmode;	/* redundant variable */
int	handicap;
int	endgame;
int	explain, eflag, debug;
int	mvnhack 1;
int	superself;
int	display;
int	movnum;
color	player;
color	mcolor;
int	selfplay;
int	nanalyze;
position h[4] {pos(0,0),pos(7,7),pos(0,7),pos(7,0)};

char	*helpmsg
"l - list legal moves\n\
a - analyze position (A=best)\n\
b - print board\n\
s - print score\n\
r - resign game (score is recorded)\n\
x - show board after move (toggle)\n\
h - set handicap (-4 .. 4)\n\
m - manual mode (user plays both sides)\n\
q - quit this game (score not recorded)\n\
rb - read board from file\n\
wb - write board to file\n";

main(argc,argv)
	int	argc;
	char	**argv;

	{bk_init ();
	stdio ();
	getuser ();
	setsuper ();
	if (superself) display = 0;
	else
		{checkuser ();
		display = isdisplay ();
		if (argc>1) options (argv[1]);
		if (display) clrscreen ();
		prnews ();
		}
	setrand ();
# ifndef unix
	if (debug>0)
# endif
		mcolor = WHITE;
# ifndef unix
	else mcolor = (rand () & 1 ? WHITE : BLACK);
# endif
	manmode = 0;
	while (playgame () && (superself || ask(stdin,"Another game") == YES));
# ifdef unix
	if (ask(stdin,"Delete saved game") == YES)
		unlink (svgame);
# endif
	exit(0);
	}

options (s)
	char *s;

	{register fastchar c;
	explain = debug = eflag = 0;
	while (c = lower (*s++)) switch (c) {
	case 'x':	if (wizard || explain==0) ++explain; continue;
	case 'd':	if (wizard) ++debug; continue;
	case 'e':	if (wizard) ++eflag; continue;
	case 'm':	if (wizard) mvnhack = !mvnhack; continue;
		}
	if (debug>0) explain=2;
	}

playgame ()

	{board b;
	int i;

	settime();
	clrbrd(b);
# ifndef unix
	gamefile = copen (gambuf, 'w', "s");
# endif
# ifdef unix
	if (superself) gamefile = fopen (svgame, "a");
	else gamefile = fopen (svgame, "w");
	if (gamefile == NULL)
		{printf ("Can't create %s\n", svgame);
		return (0);
		}
# endif
	if (superself) fprintf (gamefile, "----------\n");

# ifdef unix
	else prgame (gamefile);
# endif

	i = game(b);
	if (i != QUIT && i != EOF)
		{putc ('\n', gamefile);
		prtscr (b, gamefile, FALSE);
		putc ('\n', gamefile);
		if (n_inhibit == 0) inhibit ();
		if (!superself && i != RESIGN) shwscore (b);
		if (!manmode) wrstat (b, i==RESIGN);
		}
	fclose (gamefile);
# ifndef unix
	if (i != QUIT && i != EOF)
		{if (!superself && !manmode && cntbrd(b,oppcolor(mcolor))>=50
		     && handicap==0)
			{FILE *f;
			f = fopen (recfile, "a");
			if (f != NULL)
				{prgame (f);
				putc ('\p', f);
				fclose (f);
				}
			}
		}
# endif
	uninhibit ();
# ifndef unix
	if (superself || (movnum > MVNREAL && ask (stdin, "Save game")==YES))
		{FILE *f;
		if (superself) f = fopen ("o.game", "a");
		else f = fopen ("ogame", "w");
		if (f == NULL) printf ("Can't open file\n");
		else
			{prgame (f);
			fclose (f);
			}
		}
# endif
	mcolor = oppcolor (mcolor);
	return (i != EOF);
	}

prgame (f)

	{fprintf (f, "%s (", username);
	if (manmode)
		fprintf (f, "manual");
		else putcolor (oppcolor (mcolor), f);
	fprintf (f, ") %s\n", timestring);
	fprintf (f, "%s", gambuf);
	}

shwscore (b)
	board b;

	{int i;
	printf("\n");
	i = prtscr(b,stdout,TRUE);
	putchar (' ');
	if (i!=0)
		{if (!manmode)
			{if (i > 0) printf("You won by %d\n",i);
			else printf("You lost by %d\n",-i);
			}
		else
			{if (i > 0) printf ("* won by %d\n", i);
			else printf ("@ won by %d\n", -i);
			}
		}
	else printf("A draw\n");
	}

wrstat (b, resigned)
	board b;

	{FILE *f;
	if (debug)
		{wrfstat (b, resigned, stdout);
		if (ask(stdin,"Write stat file")==NO) return;
		}
	if ((f = fopen(log,"a"))!=NULL)
		{wrfstat (b, resigned, f);
		fclose (f);
		}
	}

wrfstat (b, resigned, f)
	board b;
	FILE *f;

	{if (superself) putc ('O', f);
	else fprintf (f, "%s", username);
	putc('\t',f);
	prtscr(b,f,TRUE);
	putc ('\t', f);
	putcolor (oppcolor(mcolor), f);
	if (resigned) putc ('r', f);
	else if (nanalyze>10) putc ('a', f);
	fprintf (f, "%d\t%d+%d\t%s",
		handicap,fcnt[oppcolor(mcolor)],fcnt[mcolor],timestring);
	}

settime ()

	{int tv[2];
	time (tv);
	timestring = ctime(tv);
	}

game (b)
	board b;

	{handicap = fcnt[BLACK] = fcnt[WHITE] = 0;
	endgame = -1000;
	setmov (b, 1);
	machine[mcolor] = TRUE;
	machine[oppcolor(mcolor)] = superself;
	player = BLACK;
	bk_clear (BLACK);
	selfplay = superself;
	nanalyze = 0;
	if (!superself && machine[player] && display) dpyempty ();
	for (;;)
		{position p;
		int mtime;
		mtime = -1;
		if (cntbrd(b,EMPTY) == 0) break;
		if (!anymvs (b, player))
			{if (!anymvs (b, oppcolor(player))) break;
			p = -1;
			++fcnt[player];
			bk_flush ();
			if (!machine[player])
				{do_inhibit ();
				if (explain)
					{prtbrd (b);
					printf ("Forfeit.  ");
					pause ();
					}
				}
			}
		else
			{if (machine[player])
				{if (explain)
					if (explain>1)
						{int temp;
						temp = debug;
						debug = 0;
						analyze(b,player,oppcolor(player));
						debug = temp;
						}
					else auxbrd(b);
				mtime = cputm ();
				p = my_mov(b,player,oppcolor(player));
				if (mtime) mtime = cputm () - mtime;
				else mtime = -1;
				}
			else
				{fastchar c;
				p = onemov (b, player);
				if (p >= 0)
					{do_inhibit ();
					if (explain)
						{prtbrd (b);
						printf ("The only legal move is ");
						printf ("%d-%d.  ",
							posx(p)+1, posy(p)+1);
						pause ();
						}
					}
				else
					{uninhibit ();
					if (player==WHITE) putchar ('\n');
					switch (c = getmov(b,stdin,&p)) {

			case	RESIGN:	if (ask (stdin,
					"You really want to resign") != YES)
						continue;
					if (movnum <= MVNREAL) return (QUIT);
					p = -2;
					break;
			case	QUIT:	if (movnum>MVNREAL && ask (stdin,
					"Would you rather resign") == YES)
						{p = -2; break;}
					if (movnum>MVNREAL) return (EOF);
					    /* penalize quitters */
			case	EOF:	return	(c);
			case	RETRY:	continue;
			case	MOVE:	break;
					}
					}
				}
			bk_move (p);
			putmov(b,player,p);
			}
		if (player==BLACK) mprint ("%d. ", movnum);
		else mprint ("...");
		if (p == -1) mprint ("Forfeit");
		else if (p == -2)  mprint ("Resign");
		else
			{mprint("%d-%d", posx(p)+1, posy(p)+1);
			if (machine[player] && mtime>=0)
				{int ntenths, nsec;
				nsec = mtime / 60;
				ntenths = mtime % 60;
				ntenths = (ntenths+5)/6;
				if (ntenths==10) {ntenths=0;++nsec;}
				mprint (" (%d.%d)", nsec, ntenths);
				}
			}
		if (player == WHITE)
			{mprint ("\n");
			setmov (b, movnum+1);
			}
		else if (machine[player])
			tyo_flush ();
		player = oppcolor (player);
		if (p == -2)
			{if (player == WHITE) mprint ("\n");
			return (RESIGN);
			}
		}
	if (!superself) shwbrd(b);
	return (DONE);
	}

do_inhibit ()

	{if (!debug && !eflag && n_inhibit==0 && !manmode) inhibit ();
	}

setmov (b, n)
	board b;

	{int nend;
	nend = (n >= ENDGAMEMOVE);
	movnum = n;
	if (nend != endgame)
		{endgame = nend;
		fixbrd (b);
		}
	}

getmov (b, f, pp)
	board b;
	FILE *f;
	position *pp;

	{int pflag;

	pflag = 1;
	for (;;)
		{int c, p, i;

		if (pflag && !superself)
			{if (pflag>1 && display)
				{clrscreen ();
				redisplay ();
				tyoflush();
				}
			else if (movnum>=2 || !machine[BLACK]) prtbrd (b);
			else shwbrd (b);
			}
		pflag = 0;
		c = command(stdin,&p);
		*pp = p;
		switch (c) {

case	HELP:	printf ("%s", helpmsg);
		continue;
case	MANUAL:	bk_flush ();
		machine[BLACK] = machine[WHITE] = 0;
		manmode = TRUE;
		continue;
case	PBOARD:	pflag = 2;
		continue;
case	READCM:	bk_flush ();
		if (readbd (b, buf)) return (RETRY);
		printf ("no file\n");
		continue;
case	WRITCM:	if (!writbd (b, buf)) printf ("can't\n");
		continue;
case	TREECM:	dotree (b,player,oppcolor(player),p,stdout);
		continue;
case	OPTCOM:	options (buf);
		continue;
case	XCOM:	explain = !explain;
		continue;
case	SCORE:	i = prtscr(b,stdout,TRUE);
		if (!manmode)
			{if (i > 0) printf(" You're winning.");
			else if (i < 0) printf(" You're losing!");
			}
		else
			{if (i > 0) printf (" * is winning.");
			else if (i < 0) printf (" @ is winning.");
			}
		putchar('\n');
		continue;
case	QUIT:
case	RESIGN:
case	EOF:	return	(c);
case	HCAP:	if (handicap==0 && movnum==1)
			{for (i=0; p!=0; ++i)
				{b[h[i]] = p>0 ? player : oppcolor(player);
				handicap =+ p>0? 1: -1;
				p =+ p>0? -1 : 1;
				pflag = 1;
				}
			if (handicap!=0)
				{printf ("Warning: this game will not be ");
				printf ("counted in the statistics.\n");
				}
			}
		else printf("Too late!\n");
		continue;
case	LISTM:	lstmvs (b,player);
		continue;
case	ANALYZ:	printf (" (%d)\n", ++nanalyze);
		analyze(b,player,oppcolor(player));
		continue;
case	MOVE:	if (ismove(b,player,p)) return (c);
		printf("Illegal!\n");
		continue;
			}
		}
	}

prtscr(b,f,reverse)
	board b;
	FILE *f;

	{register int i, j;
	i = cntbrd (b, BLACK);
	j = cntbrd (b, WHITE);
	if (reverse && machine[BLACK])
		{int temp;
		temp = i;
		i = j;
		j = temp;
		}
	fprintf(f,"%d-%d",i,j);
	return (i-j);
	}

onemov (b,c)
	board b;
	color c;

	{register position p;
	position p1;
	int nmoves;

	p1 = -1;
	nmoves = 0;
	forallpos (p) if (ismove (b,c,p))
		{p1 = p;
		if (++nmoves>1) return (-1);
		}
	return (p1);
	}	

analyze(b,c,o)
	board b;
	color c, o;

	{board a, omb;
	register position p;
	int omvnhack;

	omvnhack = mvnhack;
	if (!machine[c]) mvnhack = 0;
	else sethack (b, c);
	cpybrd(a,b);
	filmvs(b,o,omb);
	forallpos (p) if (ismove (b,c,p))
		a[p] = s_move(b,c,o,p,omb);
	auxbrd(a);
	mvnhack = omvnhack;
	}	

lstmvs(b,c)
	board b;
	color c;

	{board a;

	filmvs(b,c,a);
	auxbrd(a);
	}	

filmvs(b,c,a)
	board b,a;
	color c;

	{register position p;
	cpybrd(a,b);
	forallpos (p) if (ismove (b,c,p))
		a[p] = '?';
	}

command(f,pp)
	FILE	*f;
	position *pp;

	{fastchar a, c;
	char *s;
	int x, y;

	for (;;)
		{putcolor (player, stdout);
		printf (" to move: ");
		switch (c = lower (skipbl(f))) {

#ifdef unix

	case	SHELL:	unix();
			continue;

#endif

	case	RESIGN:
			c = lower (getc (f));
			if (c == '\n') return (RESIGN);
			if (c != 'b') goto flush;
			a = READCM;
			goto rdname;

	case	OPTCOM:	if (!wizard) goto flush;
			a = OPTCOM;
			goto rdname;

	case	WRITCM:	c = lower (getc (f));
			if (c == '\n') goto flushnl;
			if (c != 'b') goto flush;
			a = WRITCM;

	rdname:		s = buf;
			c = getc (f);
			if (c != '\n')
				{if (c != ' ') goto flush;
				c = skipbl (f);
				while (c != '\n')
					{*s++ = c;
					c = getc (f);
					}
				}
			*s++ = 0;
			return (a);

	case	PBOARD:
	case	SCORE:
	case	QUIT:
	case	ANALYZ:
	case	LISTM:
	case	MANUAL:
	case	XCOM:
	case	HELP:
			a = c;
			if ((c = skipbl(f)) != '\n') goto flush;
			return (a);
	case	HCAP:	if ((a = c = skipbl(f)) == '-') c = getc(f);
			if (c < '1' || c > '4' || skipbl(f) != '\n')
				goto flush;
			*pp = a=='-'? -(c-'0'):(c-'0');
			return (HCAP);
	case	TREECM:	a = c;
			c = skipbl(f);
			if (c < '1' || c > '9') goto flush;
			if (!wizard) goto flush;
			*pp = c-'0';
			while (c = skipbl(f))
				{if (c == '\n') return (a);
				if (c < '0' || c > '9') goto flush;
				*pp = (*pp * 10) + (c - '0');
				}
			goto flush;
	case	EOF:	return (c);
	default:	if (c < '1' || c > '8')	goto flush;
			x = c - '1';
			c = skipbl(f);
			if (c < '1' || c > '8')	goto flush;
			y = c - '1';
			if ((c = skipbl(f)) == '\n')
				{*pp = pos(x,y);
				return (MOVE);
				}
	flush:		while (c != '\n' && c != EOF) c = getc(f);
			if (c == EOF) return (c);
	case '\n':
	flushnl:	printf ("Huh?\n");
			}
		}
	}

skipbl(f)
	register FILE	*f;

	{register fastchar c;
	while ((c = getc(f)) == ' ' || c == '\t');
	return (c);
	}

mprint (f, a, b, c, d, e)
	{fprintf (gamefile, f, a, b, c, d, e);
	if (!superself) printf (f, a, b, c, d, e);
	}

getuser ()

	{char *s;
	getpw(getuid(),username);
	s = username;
	while (*s) if (*s == ':') {*s = 0; break;} else ++s;
	if (username[0]==0) exit(255);
	s = username;
	while (*s) {if (*s == ' ') *s = '_'; ++s;}
	setwizard ();
	}

#ifndef unix
#include "c/its.bits"
# include "c/c.defs"
isdisplay ()
	{extern int cout;
	return (istty (cout) && (status (itschan (cout)) & 077) == 2);
	}

setsuper ()

	{if (rsuset (UXJNAME) == csto6 ("OO")) ++superself;}

checkuser ()
	{while (!validuser ())
		{char nambuf[40];
		int n;
		printf ("Enter your user name (6 or fewer letters): ");
		gets (nambuf);
		n = csto6 (nambuf);
		if (n == csto6 ("AS")) n = 0;
		c6tos (n, username);
		wsuset (UXUNAME, n);
		}
	}

validuser ()
	{int n, loser, guest, foo;
	loser = csto6 ("BERN");
	guest = csto6 ("GUEST");
	foo = csto6 ("FOO");
	n = rsuset (UXUNAME);
	if (n == 0) return (FALSE);
	if ((n | 0777777) == -1) return (FALSE);
	if (n == guest || n == foo) return (FALSE);
	if (n == loser)
		return (ask (stdin, "Is your name really BERN") == YES);
	while (n)
		{int c;
		c = ((n >> 30) & 077);
		n = n << 6;
		if (c < ('A'-32) || c > ('Z'-32)) return (FALSE);
		}
	return (TRUE);
	}

setwizard ()
	{if (stcmp (username, "AS")) wizard=TRUE;
	}

prnews ()

	{int f;
	f = copen ("c/_oo.news");
	if (f != OPENLOSS)
		{int c;
		while (c = getc (f)) putchar (c);
		putchar ('\n');
		cclose (f);
		pause ();
		if (display) clrscreen ();
		}
	}

pause ()

	{tyos ("Type anything... ");
	utyi ();
	putchar ('\n');
	}

ask(f,s)

	{while (1)
		{tyos (s);
		tyos (" (Y or N)? ");
		while (1)
			{switch (lower (utyi ())) {
			case 'y':	tyos ("yes\r"); return ('y');
			case EOF:
			case 'n':	tyos ("no\r"); return ('n');
			case '\014':	tyo ('\r'); break;
			default:	tyo (007); continue;
				}
			break;
			}
		}
	}

inhibit ()

	{if (++n_inhibit == 1)
		{int b[3], ch;
		ttyget (ch = tyiopn (), b);
		b[2] =| 02000000;
		ttyset (ch, b);
		}
	}

uninhibit ()

	{if (n_inhibit == 0) return;
	if (--n_inhibit == 0)
		{int b[3], ch;
		ttyget (ch = tyiopn (), b);
		b[2] =& ~02000000;
		ttyset (ch, b);
		}
	}

setrand ()
	{int tv[2], x;
	time (tv);
	x = tv[1];
	x =^ cputm ();
	srand (x);
	x = 20;
	while (--x >= 0) rand();
	}

#endif

#ifdef unix
checkuser () {;}
spctty (c) {;}
stdio () {nice(12);}
lower (c) {if (c>='A' && c<='Z') return (c+32); return (c);}
isdisplay ()
	{struct {char ispeed,ospeed;int x,y;} ttt;
	gtty (1,&ttt);
	return (ttt.ospeed >= 11);
	}

setsuper () {;}
setwizard ()
	{if (username[0] == 's' &&
	     username[1] == 'n') wizard = TRUE;
	}

prnews () {;}

pause ()

	{fastchar c;
	printf ("Type NL...");
	while ((c = getchar ()) != '\n' && c != EOF);
	}

ask(f,s)
	register FILE *f;
	register char *s;

	{fastchar a, c;
	printf("%s? ", s);
	c = a = skipbl(f);
	while (c != '\n' && c != EOF) c = getc(f);
	return (lower (a));
	}

cputm()

	{struct tbuffer { long user,system,childu,childs; } xxx;
	int i;

	times(&xxx); i = xxx.user;
	return(i);
	}

inhibit () {;}
uninhibit () {;}

#define SIGINT 2
#define SIGQIT 3
unix()

	{int rc, status, unixpid;
	if ((unixpid=fork())==0)
		{execl("/bin/sh","sh","-t",0);
		exit(255);
		}
	else if (unixpid == -1) return(0);
	else	{while ((rc = wait(&status)) != unixpid && rc != -1);
		return(1);
		}
	}

setrand ()
	{int tv[2];
	time (tv);
	srand (tv[1]);
	}

tyo_flush ()
	{;}

#endif
