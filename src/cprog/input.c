# include "c.defs"

main (argc, argv)

	{int n;
	char buf[300];

	on (ctrlg_interrupt, 1);
	for (;;)
		{n = get_buf (buf, 299, '\r', ":");
		if (n<=0) break;
		buf[n-1]=0;
		if (buf[0]=='\n') puts (buf+1);
		else puts (buf);
		}
	}
