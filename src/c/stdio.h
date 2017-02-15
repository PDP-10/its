/* STDIO.H for DEC20 implementation */

/* actual code is in <C.LIB>C20STD.C */

# define BUFSIZ 512		/* this number is irrelevant */
# define FILE int		/* the actual structure is irrelevant */
# define NULL 0			/* null file pointer for error return */
# define EOF (-1)		/* returned on end of file */

# define peekchar pkchar	/* rename to avoid name conflict */
# define fopen flopen		/* " */
# define getc fgetc		/* " */
# define getchar fgeth		/* " */
# define fprintf ffprintf	/* " */
# define calloc fcalloc		/* " */

# define feof ceof		/* direct translation */
# define putc cputc		/* " */
# define fputc cputc		/* " */

extern FILE *stdin, *stdout, *stderr;
