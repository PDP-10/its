#include <stdio.h>
#include <lex.h>

extern int _lmovb();

#line 4 "CLEX.LXI"

extern	char	*install();

#line 11 "CLEX.LXI"

main()
{
	register int	i;
	char		buffer[80];
	extern char	*token();

	while (i = yylex()) {
		gettoken(buffer, sizeof buffer);
		printf("yylex returns %d, token = \"%s\"\n",
			i, buffer);
		if (i == LEXERR) {
			error("LEXERR -- abort");
			break;
		}
	}
}
_Alextab(__na__) {

#line 30 "CLEX.LXI"

	register int	c;
	switch (__na__) {
	case 0:

#line 33 "CLEX.LXI"
 return(__na__);
	break;
	case 1:

#line 34 "CLEX.LXI"
 return(__na__);
	break;
	case 2:

#line 35 "CLEX.LXI"
 return(__na__);
	break;
	case 3:

#line 36 "CLEX.LXI"
 return(__na__);
	break;
	case 4:

#line 37 "CLEX.LXI"
 return(__na__);
	break;
	case 5:

#line 38 "CLEX.LXI"
 return(-1);
	break;
	case 6:

#line 39 "CLEX.LXI"
 return(__na__);
	break;
	case 7:

#line 40 "CLEX.LXI"
 return(__na__);
	break;
	case 8:

#line 41 "CLEX.LXI"
 return(__na__);
	break;
	case 9:

#line 42 "CLEX.LXI"
 return(__na__);
	break;
	case 10:

#line 43 "CLEX.LXI"
 return(__na__);
	break;
	case 11:

#line 44 "CLEX.LXI"
 return(__na__);
	break;
	case 12:

#line 45 "CLEX.LXI"
 return(__na__);
	break;
	case 13:

#line 46 "CLEX.LXI"
 return(__na__);
	break;
	case 14:

#line 47 "CLEX.LXI"
 return(__na__);
	break;
	case 15:

#line 48 "CLEX.LXI"
 return(__na__);
	break;
	case 16:

#line 49 "CLEX.LXI"
 return(__na__);
	break;
	case 17:

#line 50 "CLEX.LXI"
 return(__na__);
	break;
	case 18:

#line 51 "CLEX.LXI"
 return(__na__);
	break;
	case 19:

#line 52 "CLEX.LXI"
 return(__na__);
	break;
	case 20:

#line 53 "CLEX.LXI"
 return(__na__);
	break;
	case 21:

#line 54 "CLEX.LXI"
 return(__na__);
	break;
	case 22:

#line 55 "CLEX.LXI"
 return(__na__);
	break;
	case 23:

#line 56 "CLEX.LXI"
 return(__na__);
	break;
	case 24:

#line 57 "CLEX.LXI"
 return(__na__);
	break;
	case 25:

#line 58 "CLEX.LXI"

			lexval = install();
			return(6);

	break;
	case 26:

#line 62 "CLEX.LXI"

			lexval = install();
			return(7);

	break;
	case 27:

#line 66 "CLEX.LXI"
 return(__na__);
	break;
	case 28:

#line 67 "CLEX.LXI"
 return(__na__);
	break;
	case 29:

#line 68 "CLEX.LXI"
 return(__na__);
	break;
	case 30:

#line 69 "CLEX.LXI"
 return(__na__);
	break;
	case 31:

#line 70 "CLEX.LXI"
 return(__na__);
	break;
	case 32:

#line 71 "CLEX.LXI"
 return(__na__);
	break;
	case 33:

#line 72 "CLEX.LXI"
 return(__na__);
	break;
	case 34:

#line 73 "CLEX.LXI"
 return(__na__);
	break;
	case 35:

#line 74 "CLEX.LXI"
 return(__na__);
	break;
	case 36:

#line 75 "CLEX.LXI"
 return(__na__);
	break;
	case 37:

#line 76 "CLEX.LXI"
 return(__na__);
	break;
	case 38:

#line 77 "CLEX.LXI"
 return(__na__);
	break;
	case 39:

#line 78 "CLEX.LXI"
 return(__na__);
	break;
	case 40:

#line 79 "CLEX.LXI"
 return(__na__);
	break;
	case 41:

#line 80 "CLEX.LXI"
 return(__na__);
	break;
	case 42:

#line 81 "CLEX.LXI"
 return(__na__);
	break;
	case 43:

#line 82 "CLEX.LXI"
 return(__na__);
	break;
	case 44:

#line 83 "CLEX.LXI"
 return(__na__);
	break;
	case 45:

#line 84 "CLEX.LXI"
 return(__na__);
	break;
	case 46:

#line 85 "CLEX.LXI"
 return(__na__);
	break;
	case 47:

#line 86 "CLEX.LXI"
 return(__na__);
	break;
	case 48:

#line 87 "CLEX.LXI"
 return(__na__);
	break;
	case 49:

#line 88 "CLEX.LXI"
 return(__na__);
	break;
	case 50:

#line 89 "CLEX.LXI"
 return(__na__);
	break;
	case 51:

#line 90 "CLEX.LXI"
 return(__na__);
	break;
	case 52:

#line 91 "CLEX.LXI"
 return(__na__);
	break;
	case 53:

#line 92 "CLEX.LXI"
 return(__na__);
	break;
	case 54:

#line 93 "CLEX.LXI"
 return(__na__);
	break;
	case 55:

#line 94 "CLEX.LXI"
 return(__na__);
	break;
	case 56:

#line 95 "CLEX.LXI"
 return(__na__);
	break;
	case 57:

#line 96 "CLEX.LXI"

			comment("*/");
			return(LEXSKIP);

	break;
	case 58:

#line 100 "CLEX.LXI"

			if ((c = mapch('\'', '\\')) != -1)
				while (mapch('\'', '\\') != -1)
					lexerror("Long character constant");
			printf("%c", c);
			return(__na__);

	break;
	case 59:

#line 107 "CLEX.LXI"
 return(__na__);
	break;
	case 60:

#line 108 "CLEX.LXI"
 return(__na__);
	break;
	case 61:

#line 109 "CLEX.LXI"
 return(__na__);
	break;
	case 62:

#line 110 "CLEX.LXI"
 return(__na__);
	break;
	case 63:

#line 111 "CLEX.LXI"
 return(__na__);
	break;
	case 64:

#line 112 "CLEX.LXI"
 return(__na__);
	break;
	case 65:

#line 113 "CLEX.LXI"
 return(__na__);
	break;
	case 66:

#line 114 "CLEX.LXI"
 return(__na__);
	break;
	case 67:

#line 115 "CLEX.LXI"
 return(__na__);
	break;
	case 68:

#line 116 "CLEX.LXI"
 return(__na__);
	break;
	case 69:

#line 117 "CLEX.LXI"
 return(__na__);
	break;
	case 70:

#line 118 "CLEX.LXI"
 return(__na__);
	break;
	}
	return(LEXSKIP);
}

#line 119 "CLEX.LXI"

char *
install()
/*
 * Install the current token in the symbol table
 */
{
	register char	*buffer;	/* Where to put the character	*/
	register char	*first;		/* -> first byte of the token	*/
	char		*last;		/* Can't be in a register	*/
	extern char	*token();

	first = token(&last);		/* Find first/last of token	*/
	if ((buffer = alloc((last - first) + 1)) == NULL) {
		error("Out of space in install");
		exit(1);
	}
	first = copy(buffer, first, (last - first));
	*first = '\0';
	return(buffer);
}

int _Flextab[] {
 -1, 70, 69, 68, 67, 66, 65, 62, 61, 60, 59, 58, 56, 55, 54, 53,
 50, 52, 49, 51, 46, 63, 45, 64, 41, 40, 57, 39, 32, 34, 31, -1,
 30, 29, 48, 47, -1, 44, -1, 43, 42, 38, 37, 36, 35, 27, 33, 28,
 26, 26, 25, 25, 25, 25, 25, 25, 25, 24, 25, 25, 25, 25, 25, 25,
 23, 25, 25, 21, 25, 25, 25, 25, 25, 25, 20, 19, 25, 25, 25, 25,
 17, 25, 25, 25, 25, 25, 25, 25, 18, 25, 25, 16, 25, 25, 25, 25,
 13, 25, 12, 25, 25, 25, 10, 25, 25, 25, 25, 25, 11, 25, 25, 25,
 25, 25, 9, 25, 25, 25, 14, 25, 25, 25, 25, 7, 25, 25, 25, 6,
 25, 25, 25, 25, 25, 22, 25, 25, 25, 25, 15, 25, 25, 25, 25, 8,
 25, 25, 25, 5, -1, -1, -1, -1, -1, -1, -1, 4, -1, -1, -1, 3,
 -1, -1, -1, -1, 2, -1, -1, 1, -1, -1, -1, -1, -1, 0, -1,
};

#line 140 "CLEX.LXI"

#define	LLTYPE1	char

LLTYPE1 _Nlextab[] {
 174, 174, 174, 174, 174, 174, 174, 174, 174, 7, 9, 174, 174, 174, 174, 174,
 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174,
 8, 31, 10, 148, 50, 27, 22, 11, 6, 5, 24, 18, 12, 16, 13, 25,
 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 17, 15, 45, 33, 28, 14,
 19, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 4, 23, 3, 26, 50,
 32, 124, 76, 81, 68, 115, 65, 99, 50, 97, 50, 50, 50, 50, 50, 50,
 50, 50, 103, 128, 58, 53, 50, 92, 50, 50, 50, 2, 20, 1, 21, 30,
 29, 41, 34, 37, 39, 54, 40, 44, 55, 43, 56, 42, 46, 47, 49, 49,
 49, 49, 49, 49, 49, 49, 49, 49, 38, 57, 36, 59, 52, 60, 61, 62,
 63, 64, 66, 67, 70, 71, 72, 73, 51, 51, 51, 51, 51, 51, 51, 51,
 51, 51, 74, 77, 78, 79, 80, 83, 84, 52, 52, 52, 52, 52, 52, 52,
 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
 52, 52, 52, 85, 86, 87, 88, 52, 35, 52, 52, 52, 52, 52, 52, 52,
 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52, 52,
 52, 52, 52, 69, 89, 90, 91, 93, 94, 95, 96, 98, 100, 75, 101, 102,
 104, 109, 82, 106, 107, 108, 110, 111, 112, 113, 114, 116, 117, 118, 105, 120,
 121, 122, 123, 125, 126, 127, 129, 119, 130, 131, 132, 133, 135, 136, 137, 138,
 140, 139, 141, 142, 134, 143, 145, 146, 147, 168, 160, 156, 151, 152, 149, 153,
 154, 144, 155, 150, 157, 158, 159, 165, 162, 161, 163, 164, 166, 167, 169, 170,
 171, 172, 173,
};

LLTYPE1 _Clextab[] {
 -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0,
 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 25, 0,
 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 20, 28,
 28, 33, 33, 36, 38, 53, 33, 33, 54, 33, 55, 33, 45, 45, 48, 48,
 48, 48, 48, 48, 48, 48, 48, 48, 33, 56, 33, 58, 50, 59, 60, 61,
 62, 63, 65, 66, 69, 70, 71, 72, 50, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 73, 76, 77, 78, 79, 82, 83, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 84, 85, 86, 87, 50, 33, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 68, 81, 89, 90, 92, 93, 94, 95, 97, 99, 68, 100, 101,
 103, 104, 81, 105, 106, 107, 109, 110, 111, 112, 113, 115, 116, 117, 104, 119,
 120, 121, 122, 124, 125, 126, 128, 115, 129, 130, 131, 132, 134, 135, 136, 137,
 139, 128, 140, 141, 128, 142, 144, 145, 146, 148, 148, 149, 150, 151, 148, 152,
 153, 139, 154, 149, 156, 157, 158, 160, 161, 160, 162, 163, 165, 166, 168, 169,
 170, 171, 172,
};

LLTYPE1 _Dlextab[] {
 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174,
 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174,
 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174,
 174, 48, 174, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
 50, 50, 50, 50, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174,
 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174,
};

int _Blextab[] {
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 13, 0, 21, 0, 2, 0, 54, 0, 0, 52, 0, 0, 66, 0, 0, 35,
 0, 92, 0, 0, 69, 0, 72, 0, 0, 0, 0, 0, 0, 80, 0, 0,
 94, 0, 120, 0, 0, 23, 31, 27, 43, 0, 34, 45, 57, 59, 59, 59,
 0, 51, 49, 0, 142, 62, 68, 49, 59, 62, 0, 0, 65, 79, 84, 75,
 0, 147, 73, 68, 106, 102, 96, 113, 0, 130, 145, 0, 143, 143, 141, 149,
 0, 149, 0, 141, 138, 144, 0, 155, 154, 142, 146, 151, 0, 157, 148, 148,
 164, 152, 0, 159, 153, 168, 0, 155, 171, 159, 164, 0, 158, 160, 166, 0,
 173, 158, 180, 171, 181, 0, 179, 169, 187, 183, 0, 191, 174, 186, 194, 0,
 177, 196, 180, 0, 197, 197, 201, 193, 186, 204, 205, 0, 208, 208, 208, 0,
 203, 212, 209, 213, 0, 201, 216, 0, 217, 217, 215, 211, 221, 0, 0,
};

struct	lextab	lextab {
	174,	/* last state */
	_Dlextab,	/* defaults */
	_Nlextab,	/* next */
	_Clextab,	/* check */
	_Blextab,	/* base */
	322,	/* last in base */
	_lmovb,	/* byte-int move routines */
	_Flextab,	/* final state descriptions */
	_Alextab,	/* action routine */
	NULL,	/* look-ahead vector */
	0,	/* no ignore class */
	0,	/* no break class */
	0,	/* no illegal class */
};
