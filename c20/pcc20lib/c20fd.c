# include <c.defs>

/**********************************************************************

	FD-20
	File Directory Routines
	TOPS-20 Version

**********************************************************************/


/**********************************************************************

	FDMAP (P, F)

	Call F(S) for all filenames S that match the pattern P.

**********************************************************************/

fdmap (p, f)
	char *p;
	int (*f)();

	{register int jfn, rc;
	char buf[100];

	fnstd (p, buf);
	rc = jfn = SYSGTJFN (halves (0100121, 0),
					/* GJ%OLD+GJ%IFG+GJ%FLG+GJ%SHT */
			     mkbptr (buf));
	while ((rc & 0600000) == 0)
		{SYSJFNS (mkbptr (buf), jfn & 0777777, 0);
		(*f)(buf);
		SYSCLOSF (jfn);
		rc = SYSGNJFN (jfn);
		}
	}

