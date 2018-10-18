#include "c.defs"

/**********************************************************************

	RENAME (file1, file2)

	Should work even if a file2 already exists.
	Return 0 if no error.

	*ITS VERSION*

**********************************************************************/

rename (s1, s2) char *s1, *s2;

	{filespec fs1, fs2;
	fparse (s1, &fs1);
	fparse (s2, &fs2);
	if (fs1.dev==0) fs1.dev = csto6 ("DSK");
	sysdelete (&fs2);
	sysrname (&fs1, &fs2);
	return (0);
	}
