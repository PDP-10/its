# include "c/c.defs"

# define nbucket 2

main ()
	{int tv[2], count[nbucket], n, j;
	for (j=0;j<nbucket;++j) count[j] = 0;
	nowtime (tv);
	srand (tv[1]);
	n = 200;
	while (--n>=0)
		{int i;
		i = rand();
		if (i<0) i= -i;
		i = i%nbucket;
		cprint ("%2d", i);
		++count[i];
		}
	cprint ("\n ");
	for (j=0;j<nbucket;++j) cprint (" %d", count[j]);
	cprint ("\n");
	}

nowtime (tv) int tv[];
	{cal foo;
	now (&foo);
	tv[0] = tv[1] = cal2f (&foo);
	}

