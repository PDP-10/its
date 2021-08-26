# include "c/c.defs"
# define FORFEIT 'F'

char *filename;
char *itoa();

int formno;	/* 0=old form (backwards init position),
		   1=new form */

main (argc, argv)
int argc;
char *argv[];

	{int fout, fin, n;
	static char opnstr[13] 
		{'o', 'g', 'a', 'm', 'e', '.', '1'		};
	fout = copen("o.xgp",'w');	/* open output file */
	prxgpheader (fout);
	--argc; 
	++argv;
	n = 0;
	if (argc == 0)
		{filename = opnstr;
		fin = copen ("ogame.<", 'r');
		if (fin > 0)
			{filespec fs;
			filnam (itschan (fin), &fs);
			c6tos (fs.fn2, opnstr+6);
			n = atoi (opnstr+6);
			cclose (fin);
			while (TRUE)
				{fin = copen (opnstr, 'r');
				if (fin > 0) dofile (fin, fout, opnstr);
				else break;
				++n;
				itoa (n, opnstr+6);
				}
			}
		}
	else
		{while (--argc >= 0)
			{filename = *argv;
			fin = copen (*argv, 'r');
			if (fin > 0) dofile (fin, fout, *argv);
			++argv;
			}
		}
	cclose(fout);
	}

prxgpheader (fout)
	{cprint(fout,";SKIP 1\n;VSP 0\n;LFTMAR 96\n;TOPMAR 0\n;BOTMAR 0\n");
	cprint(fout,";KSET DSK:FONTS1;O20,DSK:FONTS1;METM,DSK:FONTS;20FG\n");
	}

dofile(fin,fout,fname)
	char *fname;

	{while (dogame (fin, fout, fname));
	cclose(fin); 
	}

dogame (fin, fout, fname)
	char *fname;

	{char board [8] [8] [8];
	char movstr [8][4], gmstr[200], title[100];
	int m, blen, scores [8][2], bnum;
	blen = parse(fin, gmstr, title);
	if (blen < 0) return (0);
	cprint(fout, "\p\nÉ\400`Å%s (%s)\n\nÅ\412", title, fname);
	initboard (board, scores);
	bnum=0;
	for (m=0;m<blen;m=+16)
		{doline (fout, blen, m, bnum, gmstr, board, scores, movstr);
		bnum =+ 4;
		}
	return (1);
	}

initboard (board, scores)
	char board [8] [8] [8];
	int scores [8][2];

	{register int i, j;

	for(i=0; i<8; ++i) for(j=0; j<8; ++j) board[0][i][j] = '_';
	if (formno == 1)
		{board[0][3][3]='W';
		board[0][3][4]='B';
		board[0][4][3]='B';
		board[0][4][4]='W';
		}
	else
		{board[0][3][3]='B';
		board[0][3][4]='W';
		board[0][4][3]='W';
		board[0][4][4]='B';
		}
	scores[0][0]=2;
	scores[0][1]=2;
	}

int doline (fout, blen, m, bnum, gmstr, board, scores, movstr)
	char board [8] [8] [8];
	char movstr [8][4], gmstr[200];
	int scores [8][2], bnum;

	{register int i, j, k;

	/* start of making 2 elements of line of 8 */
	for (i=0;;)
		{if (gmstr[m]!=FORFEIT && gmstr[m]!=' ')
			{k=makmv(board[i], 'B', gmstr[m], gmstr[m+1], movstr[i]);
			if (k==0)
			 cprint ("File %s, move %d invalid for black\n",
				 filename, (m/4)+1);
			scores[i][0]=scores[i][0]+k+1;
			scores[i][1]=scores[i][1]-k;
			}
		else 
			{if (gmstr[m]==' ') movstr[i][0]='\0';
			else movstr[i][0] = -1;
			}
		m = m + 2;
		if (m == blen) 
			{movstr[++i][0] = -2; 
			break;
			}  
		for (j=0; j<8; ++j) for (k=0; k<8; ++k)
			board[i+1][j][k]=board[i][j][k];
		scores[i+1][0]=scores[i][0];
		scores[i+1][1]=scores[i][1];
		++i;
		if (gmstr[m] != FORFEIT)
			{k=makmv(board[i], 'W', gmstr[m], gmstr[m+1],
				movstr[i]);
			if (k==0)
			 cprint ("File %s, move %d invalid for white\n",
			 filename, (m/4)+1);
			scores[i][0]=scores[i][0]-k;
			scores[i][1]=scores[i][1]+k+1;
			}
		else movstr[i][0] = -1;
		m = m + 2;
		if (i==7) break;
		if (m == blen) 
			{movstr[++i][0] = -2; 
			break;
			}  
		for (j=0; j<8; ++j) for (k=0; k<8; ++k)
			board[i+1][j][k]=board[i][j][k];
		scores[i+1][0]=scores[i][0];
		scores[i+1][1]=scores[i][1];
		++i;
		/* end of making pair of two of 8 */
		}

	/* print the headings of the eight positions */
	pr8head (fout, movstr, bnum, scores);

	/* print the eight board positions */
	pr8pos (fout, movstr, board);

	/* print the bottom line */
	prbottom (fout, movstr);

	if (blen < 73) cprint(fout, "\n\nÅ\412");
	else cprint(fout, "\nÅ\412");
	if (m < blen)
		{for (j=0; j<8; ++j) for (k=0; k<8; ++k)
			board[0][j][k]=board[7][j][k];
		scores[0][0]=scores[7][0];
		scores[0][1]=scores[7][1];
		}
	}

	/* print the headings of the eight positions */

pr8head (fout, movstr, bnum, scores)
	char movstr [8][4];
	int scores [8][2], bnum;

	{int i;

	char static *xgpst1[7] 
		{"Å%d.Å %sÅ bÅÅ#\412%2dÅ#x%2dÅ",
		"Å N%sÅ ÅÅ#\412%2dÅ#x%2dÅ",
		"Å \\%d.Å %sÅ ^ÅÅ#\412%2dÅ#x%2dÅ",
		"Å J%sÅ ÅÅ#\412%2dÅ#x%2dÅ",
		"Å X%d.Å %sÅ ZÅÅ#\412%2dÅ#x%2dÅ",
		"Å F%sÅ \tÅÅ#\412%2dÅ#x%2dÅ",
		"Å \tT%d.Å \412%sÅ \412VÅÅ#\412%2dÅ#x%2dÅ",
		"Å B%sÅ \p\412ÅÅ#\412%2dÅ#x%2dÅ"		};
	char static *xgpst2[7]
		{"Å%d.Å Forfeit",
		"Å NForfeit",
		"Å \\%d.Å Forfeit",
		"Å JForfeit",
		"Å X%d.Å Forfeit",
		"Å FForfeit",
		"Å \tT%d.Å \412Forfeit",
		"Å BForfeit"		};

	for (i=0; i<8; ++i)
		{if (movstr[i] [0] >= 0)
			cprint(fout, xgpst1[i] , ++bnum, movstr [i],
				scores [i] [0], scores [i] [1]);
		else 
			{if (movstr[i] [0] == -1)
				cprint(fout, xgpst2[i], ++bnum);
			else break;
			}
		if (movstr[++i] [0] >= 0)
			cprint(fout, xgpst1[i] , movstr [i],
				scores [i] [0], scores [i] [1]);
		else 
			{if (movstr[i] [0] == -1)
				cprint(fout, xgpst2[i]);
			else break;
			}
		}
	cprint(fout, "\nÅ\"\412Å\400");
	}

	/* print the eight board positions */

pr8pos (fout, movstr, board)
	char board[8] [8] [8];
	char movstr [8][4];

	{register int i, j, k;

	for(j=0; j<8; ++j)
		{for (i=0;i<8;++i)
			{if (movstr[i] [0] == -2) break;
			for (k=0; k<8; ++k)
				cputc(board [i] [j] [k], fout);
			cputc(' ', fout);
			if (movstr [++i] [0] == -2) break;
			for (k=0; k<8; ++k)
				cputc(board [i] [j] [k], fout);
			cprint(fout, "  ");
			}
		cprint(fout, "\n");
		}
	}

	/* print the bottom line */

prbottom (fout, movstr)
	char movstr[8][4];

	{register int j;
	char static *xgpst3[7]
		{"", "Å ", "Å \\", "Å ",
		"Å X", "Å \p", "Å \tT", "Å "};

	for(j=0; j<8; ++j)
		{if (movstr[j][0] == -2) break;
		cprint(fout, "%sÅ!j\"", xgpst3[j]); 
		}
	}

int makmv(board, color, hpos, vpos, movstr)
char board [8] [8];
char movstr[4];
int color, hpos, vpos;

	{int i,j,ocolor;
	int nchng;

	movstr[0] = hpos;
	movstr[1] = '-';
	movstr[2] = vpos;
	movstr[3] = '\0';
	hpos = hpos - '0';
	vpos = vpos - '0';

	if (board[--hpos][--vpos] !='_') return(0);

	nchng = 0;
	ocolor = 'B';
	if (color=='B') ocolor = 'W';

	if ((hpos>1) && (board [hpos-1] [vpos] == ocolor))
		{
			{for (i=hpos-2;
			(i>=0)&&(board[i] [vpos]==ocolor);
			--i) ;
			}
		if ((i>=0)&&(board[i][vpos]==color))
			{nchng = nchng+(hpos-(++i));
			do board [i] [vpos] = color; 
			while (++i < hpos);
			}
		}

	if ((hpos>1) && (vpos>1) && (board [hpos-1] [vpos-1] == ocolor))
		{
			{for (i=hpos-2, j=vpos-2;
			(i>=0)&&(j>=0)&&(board[i] [j]==ocolor);
			--i, --j) ;
			}
		if ((i>=0)&&(j>=0)&&(board[i][j]==color))
			{nchng = nchng+(hpos-(++i));
			do board[i][++j]=color; 
			while (++i < hpos);
			}
		}

	if ((vpos>1) && (board [hpos] [vpos-1] == ocolor))
		{
			{for (j=vpos-2;
			(j>=0)&&(board[hpos] [j]==ocolor);
			--j) ;
			}
		if ((j>=0)&&(board[hpos][j]==color))
			{nchng = nchng+(vpos-(++j));
			do board [hpos] [j] = color; 
			while (++j < vpos);
			}
		}

	if ((hpos<6) && (vpos>1) && (board [hpos+1] [vpos-1] == ocolor))
		{
			{for (i=hpos+2, j=vpos-2;
			(i<=7)&&(j>=0)&&(board[i] [j]==ocolor);
			++i, --j) ;
			}
		if ((i<=7)&&(j>=0)&&(board[i][j]==color))
			{nchng = nchng+((--i)-hpos);
			do board [i][++j] = color; 
			while (--i > hpos);
			}
		}

	if ((hpos<6) && (board [hpos+1] [vpos] == ocolor))
		{
			{for (i=hpos+2;
			(i<=7)&&(board[i] [vpos]==ocolor);
			++i) ;
			}
		if ((i<=7)&&(board[i][vpos]==color))
			{nchng = nchng+((--i)-hpos);
			do board [i] [vpos] = color; 
			while (--i > hpos);
			}
		}

	if ((hpos<6) && (vpos<6) && (board [hpos+1] [vpos+1] == ocolor))
		{
			{for (i=hpos+2, j=vpos+2;
			(i<=7)&&(j<=7)&&(board[i] [j]==ocolor);
			++i, ++j) ;
			}
		if ((i<=7)&&(j<=7)&&(board[i][j]==color))
			{nchng = nchng+((--i)-hpos);
			do board[i][--j] = color; 
			while (--i > hpos);
			}
		}

	if ((vpos<6) && (board [hpos] [vpos+1] == ocolor))
		{
			{for (j=vpos+2;
			(j<=7)&&(board[hpos] [j]==ocolor);
			++j) ;
			}
		if ((j<=7)&&(board[hpos][j]==color))
			{nchng = nchng+((--j)-vpos);
			do board [hpos] [j] = color; 
			while(--j > vpos);
			}
		}

	if ((hpos>1) && (vpos<6) && (board [hpos-1] [vpos+1] == ocolor))
		{
			{for (i=hpos-2, j=vpos+2;
			(i>=0)&&(j<=7)&&(board[i] [j]==ocolor);
			--i, ++j) ;
			}
		if ((i>=0)&&(j<=7)&&(board[i][j]==color))
			{nchng = nchng+(hpos-(++i));
			do board [i] [--j] = color; 
			while(++i < hpos);
			}
		}

	if (nchng) board [hpos] [vpos] = color;
	return(nchng);
	}

int parse (fin, gmstr, title)
int fin;
char gmstr[], title[];

	{int n, i, c;
	if (ceof (fin)) return (-1);
	formno = 0;
	c = cgetc (fin);
	if (c && c != '1')
		{while (c && c == ' ') c = cgetc (fin);
		while (c && c != '\n' && c != '\p')
			{*title++ = c;
			if (c == '(') formno = 1;
			c = cgetc (fin);
			}
		if (c != '\n') return (-1);
		while (c != '1' && c) c = cgetc (fin);
		}
	*title = 0;

	if (ceof (fin)) return (-1);
	n = 0;
	do
		{i = rdline (fin, gmstr, n);
		n =+ i;
		}
		while (i == 4);
	while (gmstr[n-2] == FORFEIT) n =- 2;
	return (n);
	}

int rdline (fin, gmstr, n)
char gmstr[];

	{int chr;

	gmstr[n] = gmstr[n+2] = FORFEIT;
	if (ceof (fin)) return (0);
	if (n>0)	/* initial 1 already read */
		{cgetc(fin);
		if (n>=((10-1)*4)) cgetc(fin);
		}
	if (cgetc(fin) != '.')
		{pskip (fin); 
		return (0);
		}
	cgetc (fin);
	if ((chr=cgetc(fin)) == 'F') skip (fin, 6);
	else if (chr=='R')
		{pskip (fin);
		return (0);
		}
	else
		{gmstr[n] = chr;
		cgetc(fin);
		gmstr[n+1] = cgetc(fin);
		}
	chr = cgetc (fin);
	if (chr == ' ')
		{chr = cgetc (fin);
		if (chr == '(')
			{do chr=cgetc (fin);
			    while (chr && chr != '\n' && chr != '\p'
				       && chr != ')');
			if (chr==')') chr=cgetc (fin);
			}
		}
	if (chr != '.')
		{pskip (fin); 
		return (2);
		}
	skip (fin, 2);
	if ((chr=cgetc(fin)) == 'F') skip (fin, 6);
	else if (chr=='R')
		{pskip (fin);
		return (2);
		}
	else
		{gmstr[n+2] = chr;
		cgetc(fin);
		gmstr[n+3] = cgetc(fin);
		}
	while ((chr=cgetc(fin)) != '\n' && chr != '\p' && chr);
	return (4);
	}

skip (f, n) 
	{while (--n>=0) cgetc (f);
	}

pskip (f) 
	{int c; 
	while (((c = cgetc (f)) != '\p') && c);
	}

atoi (s)
char *s;

	{int n, c;
	n = 0;
	while (c = *s++) n = (n * 10) + (c - '0');
	return (n);
	}

char *itoa (n, s)
char *s;

	{int a;
	if (n<0) n=0;
	if (a = (n / 10)) s = itoa (a, s);
	*s++ = '0' + n%10;
	*s = 0;
	return (s);
	}
