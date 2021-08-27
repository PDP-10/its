# define buffer_size 400

/* renamings to handle long names */

# define unpack_file upfile
# define open_output opout
# define close_output clout
# define read_line rdline
# define write_line wrline
# define title_line tiline

main (argc, argv)
	int argc;
	char *argv[];

	{int i;

	for (i=1;i<argc;++i) unpack_file (argv[i]);
	}

unpack_file (s)
	char *s;

	{int f, out;
	char buf[buffer_size], *name, *title_line();

	f = copen (s, 'r');
	if (f == -1)
		{cprint ("unable to open: %s\n", s);
		return;
		}
	out = -1;
	while (read_line (f, buf))
		{if (name = title_line (buf))
			{close_output (out);
			out = open_output (name);
			}
		else write_line (buf, out);
		}
	close_output (out);
	}

close_output (f)
	int f;

	{if (f != -1) cclose (f);
	}

int open_output (name)
	char *name;

	{int f;
	char buf[100], *s;

	f = -1;
	s = name;
	if (s[0]) while (f == -1)
		{f = copen (s, 'w');
		if (f == -1)
			{cprint ("unable to open: %s\n", s);
			cprint ("  use what file instead? ");
			gets (buf);
			s = buf;
			}
		}
	cprint ("writing: %s\n", s);
	return (f);
	}

int read_line (f, buf)
	int f;
	char buf[];

	{char *p, *q;
	int c;

	p = buf;
	q = buf+(buffer_size-1);

	c = cgetc (f);
	while (c!='\n' && (c>0 || !ceof (f)))
		{if (p>=q)
			{cprint ("buffer overflow\n");
			break;
			}
		*p++ = c;
		c = cgetc (f);
		}
	*p = 0;
	if (p>buf) return (1);
	return (!ceof (f));
	}

char *title_line (buf)
	char buf[];

	{int i;
	char *s;

	i = 0;
	s = buf;
	while (*s++ == 'Q') ++i;
	if (i==10)
		{if (s[-1]==' ') return (s);
		if (s[-1]==0) return (s-1);
		}
	return (0);
	}

write_line (buf, f)
	char buf[];
	int f;

	{int c;

	if (f != -1)
		{while (c = *buf++) cputc (c, f);
		cputc ('\n', f);
		}
	}
