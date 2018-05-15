# include <c.defs>

/**********************************************************************

	rename (fn1, fn2)
	delete (fn)

**********************************************************************/

/**********************************************************************

	RENAME (file1, file2)

	Should work even if a file2 already exists.
	Return 0 if no error.

	*TOPS-20 VERSION*

**********************************************************************/

int rename (s1, s2)
	char *s1, *s2;

	{register int jfn1, jfn2, rc;
	char buf1[100], buf2[100];

	fnstd (s1, buf1);
	fnstd (s2, buf2);
	jfn1 = SYSGTJFN (halves (0100001, 0), mkbptr (buf1));	/* old file */
	if (jfn1 >= 0600000) return (jfn1);
	jfn2 = SYSGTJFN (halves (0400001, 0), mkbptr (buf2));	/* new file */
	if (jfn2 >= 0600000) return (jfn2);
	if (rc = _RNAMF (jfn1, jfn2))
		{SYSRLJFN (jfn1);
		SYSRLJFN (jfn2);
		return (rc);
		}
	SYSRLJFN (jfn2);
	return (0);
	}

/**********************************************************************

	DELETE

**********************************************************************/

delete (s)
	char *s;

	{register int jfn;
	char buf[100];
	fnstd (s, buf);
	jfn = SYSGTJFN (halves (0100001, 0), mkbptr (buf));	/* old file */
	if (jfn < 06000000)
		{SYSDELF (jfn & 0777777);
		SYSCLOSF (jfn);
		}
	}
