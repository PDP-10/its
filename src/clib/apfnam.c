/**********************************************************************

	APFNAME - Append suffix to file name

**********************************************************************/

char *apfname (dest, source, suffix)
	char *dest, *source, *suffix;

	{fnsfd (dest, source, 0, 0, 0, suffix, "", "");
	return (dest);
	}

/**********************************************************************

	FNMKOUT - Make output file name

**********************************************************************/

char *fnmkout (dest, source, suffix)
	char *dest, *source, *suffix;

	{fnsfd (dest, source, "", 0, 0, suffix, "", "");
	return (dest);
	}
