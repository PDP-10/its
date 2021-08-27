# define hshsize 1999

char	cstore[20000];
char	*cwp  {cstore};
char	*hshtab[hshsize];
int	count;
int	hshused;
int	error;

main ()

	{int n, total, avg10, time;

	total = n = 0;
	time = cputm ();
	while (!error)
		{gets (cwp);
		if (cwp[0] == 0) break;
		++n;
		count = 0;
		hash (cwp);
		total =+ count;
		}
	time = cputm () - time;
	avg10 = (10 * total) / n;
	cprint ("%d occurrences of %d identifiers\n", n, hshused);
	cprint ("%d comparisons, %d.%d average\n", total,
		avg10/10, avg10%10);
	cprint ("%d seconds\n", time/60);
	}

hash (np) char *np;

	{int	i, u;
	char	*p, *ep;
	int h;

	h = i = 0;
	p = np;

	while (u = *p++) {i =+ (u << h); if (++h >= 8) h = 0;}

	/* while (u = *p++) i =+ u; */

	if (i<0) i = -i;
	i =% hshsize;

	/* search entries until found or empty */

	while (ep = hshtab[i])
		{++count;
		if (stcmp(np,ep)) return;
		else if (++i>=hshsize) i=0;
		}

	/* not found, so enter */

	if (++hshused >= hshsize)
		{cprint ("hash table overflow\n");
		error = 1;
		return;
		}
	hshtab[i] = cwp;
	if (np == cwp) cwp = p;	/* name already in place */
	else while (*cwp++ = *np++);	/* move name */
	}

