# ifdef unix

main (argc, argv) char **argv;

	{cmain (argc, argv);
	}

# endif

#ifndef unix

main (argc, argv) char **argv;

	{char xyzbuf[2000], *xyzvec[100];
	argc = exparg (argc, argv, xyzvec, xyzbuf);
	cmain (argc, xyzvec);
	}

# endif
