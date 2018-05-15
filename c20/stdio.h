/* STDIO.H for TOPS-20 implementation */

/* actual code is in <C.LIB>C20STD.C */

# define BUFSIZ 512		/* this number is irrelevant */
# define FILE int		/* the actual structure is irrelevant */
# define NULL 0			/* null file pointer for error return */
# define EOF (-1)		/* returned on end of file */

# define peekchar pkchar	/* rename to avoid name conflict */
# define fopen flopen		/* " */
# define getc fgetc		/* " */
# define gets ffgets		/* " */
# define getchar fgeth		/* " */
# define fprintf ffprintf	/* " */
# define calloc fcalloc		/* " */
# define scanf pscanf		/* " */
# rename cscanf "ZSCANF"	/* " */

# define feof ceof		/* direct translation */
# define putc cputc		/* " */
# define fputc cputc		/* " */
# define putw cputi		/* " */
# define fseek seek		/* " */
# define ftell tell		/* " */
# define malloc salloc
# define free sfree

extern int cinblk, coutblk, cerrblk;

# define stdin (&cinblk)
# define stdout (&coutblk)
# define stderr (&cerrblk)

extern FILE *fopen(), *freopen();
extern long int ftell();
extern char getc(), fgetc(), peekc(), pkchar(), putc(), fputc(), getchar();
extern char *gets(), *fgets(), *ftoa(), *getpw(), *ctime();
extern double atof();
extern int *calloc();
