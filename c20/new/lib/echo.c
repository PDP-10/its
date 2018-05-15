



#include <stdio.h>

main (argc, argv)
	char **argv;
	{argv++;
	while (--argc >= 0) print("%s ",*argv++);
	}
