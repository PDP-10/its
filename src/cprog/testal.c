/* test alloc and free */

# define N 1000
int *v[N];

main ()

	{int j;
	pastat();
	j=0;
	while (1)
		{int i;
		if (j==1||j==3)
			for (i=0;i<N;++i)
				v[i] = salloc((i+19+j)/5);
		else for (i=N-1;i>=0;--i)
			v[i] = salloc((i+19-j)/5);
		pastat();
		if (j==2||j==3)
			for (i=0;i<N;++i)
				sfree(v[i]);
		else for (i=N-1;i>=0;--i) sfree(v[i]);
		pastat();
		if (++j>=4) j = 0;
		}
	}

pastat()
	{int nalld, nfree, nblock;
	nfree = alocstat (&nalld, &nblock);
	cprint ("%d words allocated, %d words free in %d blocks\n",
		nalld, nfree, nblock);
	}
