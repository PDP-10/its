/*

	ESC '7' is reverse-line-feed.
	Other ESCs treated normally.

*/



# define PL 102		/* maximum page length */
# define LINELN 800	/* maximum line length */

# define ESC 033
# define SI 017
# define SO 016

char *page[PL];
char lbuff [LINELN], *line;

main ()
	{int c, i, ll, cp, mustwr;

	for (ll=0; ll<PL; ll++) page[ll] = 0;
	c = 1;
	cp = ll = 0;
	line = lbuff;
	mustwr = PL;

	while (c>0)
		switch (c = getchar()) {
		case '\n':
			store (ll%PL);
			if (++ll >= mustwr)
				if (page[ll%PL] != 0)
					{cprint ("%s\n",page[ll%PL]);
					mustwr++;
					cfree (page[ll%PL]);
					page[ll%PL]=0;
					}
			fetch (ll%PL);
			cp = 0;
			continue;
		case '\0': 
			continue;
		case ESC:
			c = getchar();
			if (c == '7')
				{store(ll%PL);
				ll--;
				fetch (ll%PL);
				}
			else
				{outc (ESC, &line);
				outc (c, &line );
				}
			continue;
		case '\r':
			line = lbuff;
			continue;
		case '\t':
			outc (' ', &line);
			cp = line-lbuff;
			while (cp++%8)
				outc(' ', &line);
			continue;
		default:
			outc(c, &line);
			}
	for (i=0; i<PL; i++)
		if (page[(mustwr+i)%PL] != 0)
			cprint ("%s\n",page[(mustwr+i) % PL]);
	}

outc (c, lp)
	char **lp;

	{int j;
	j = 0;
	while (j >0 || *(*lp) == '\b' || *(*lp) == ESC || **lp == SI || **lp == SO)
		{switch (*(*lp)) {
		case '\b':
			j++;
			(*lp)++;
			break;
		case '\0':
			*(*lp)++ = ' ';
			j--;
			break;
		case ESC: /* 'escape' */
			(*lp) =+ 2;
			break;
		case SI:
		case SO:
			(*lp)++;
			break;
		default:
			(*lp)++;
			j--;
			break;
			}
		}
	if (c != ' ' || *(*lp) == '\0')
		*(*lp) = c;
	(*lp)++;
	}

store (ll)
	{if (page[ll] != 0)
		cfree (page[ll]);
	page[ll] = calloc (leng (lbuff) + 2);
	copy (page[ll],lbuff);
	}

fetch(ll)
	{int i;
	for (i=0; i < LINELN; i++)
		lbuff[i] = '\0';
	copy (line=lbuff, page[ll]);
	}

copy (s,t)
char *s, *t;
	{if (t == 0)
		return (*s=0);
	while (*s++ = *t++);
	}

leng (s)
char *s;
	{int l;
	for (l=0; s[l]; l++);
	return (l);
	}
