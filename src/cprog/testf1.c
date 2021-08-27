
main ()

	{int n, c, minus;
	extern int cout;
	double d;

	while (1)
		{d = 0.0;
		minus = n = 0;
		if ((c = getchar ()) == '-') {++minus; c = getchar ();}
		while (c != '\n')
			{if (c >= '0' && c <= '9')
				{d = (d * 10.0) + (c - '0');
				if (n > 0) ++n;
				}
			else if (c == '.' && n==0) ++n;
			else if (c == 0) return;
			else putchar ('?');
			c = getchar ();
			}
		while (n > 1) {d =/ 10.0; --n;}
		if (minus) d = -d;
		fprint (d, cout);
		putchar ('\n');
		}
	}
