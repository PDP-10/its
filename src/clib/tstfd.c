/**********************************************************************

	TSTFD
	Test routine for FD

**********************************************************************/

main ()

	{char buf[200];
	extern int puts ();
	for (;;)
		{cprint ("Enter pattern: ");
		gets (buf);
		fdmap (buf, puts);
		puts ("");
		}
	}
