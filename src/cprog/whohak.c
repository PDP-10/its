
main ()

	{int i;

	for (i=0;i<0400;++i) try (i);
	}

try (i)

	{char buf[10];
	int f, j, c, lastc;

	cprint ("trying %o:\n", i);
	f = copen (buf, 'w', "s");
	cprint (f, "%o", i);
	cclose (f);
	j = j_fload ("/dsk/as/ts.whod");
	j_sjcl (j, buf);
	j_give_tty (j);
	j_start (j);
	j_wait (j);
	j_take_tty (j);
	j_kill (j);
	f = fopen ("wall >", 0);
	if (f >= 0)
		{lastc = -1;
		while ((c = uiiot (f)) > 0)
			{switch (c) {
				case 3: case '\p': break;
				case '\r': putchar ('\n'); break;
				case '\n': if (lastc != '\r') putchar ('\n'); break;
				default: putchar (c); break;
				}
			lastc = c;
			}
		close (f);
		}
	delete ("dsk:wall >");
	}
