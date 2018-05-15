/* STDIO.H for TOPS-20 implementation */

/* The I/O drivers are in the file CLIB:C20IO.C */

typedef struct _file {
	int jfn;		/* JFN */
	struct _file *next;	/* next file block in FILELIST */
	int ftype;		/* file type (see C20IO) */
	int direction;		/* I/O direction */
	int bsize;		/* byte size */
	int bptr;		/* byte pointer into buffer */
	int devtype;		/* for optimization in istty */
	int bcnt;		/* number positions free/avail */
	int eof;		/* end-of-file flag (never reset) */
	int *buf;		/* buffer */
	int *ubuf;		/* unget buffer */
	int ucnt;		/* unget count */
	} FILE;

# define BUFSIZ 512		/* this number is irrelevant */
# define NULL 0			/* null file pointer for error return */
# define EOF (-1)		/* returned on end of file */

typedef struct {		/* used for date and time conversions */
	int year;
	int month; 
	int day;
	int hour; 
	int minute; 
	int second;
	} cal;

extern FILE *stdin,*stdout,*stderr;

extern FILE *fopen(), *freopen();
extern long int ftell();
extern int getc(), fgetc(), peekc(), pkchar(), putc(), fputc();
extern char *gets(), *fgets(), *ftoa(), *getpw(), *ctime();
extern int exit(), _exit();
extern int *malloc(), *realloc();
extern char *calloc();
extern double atof();


# define getchar() getc(stdin)
# define putchar(c) putc((c),(stdout))
# define fgetc(c) getc(c)
# define fputc(c,f) putc((c),(f))
# define halves(l,r) (((l) << 18) | ((r) & 0777777))

#rename strncpy "STRNCP"
#rename strncmp "STRNCM"
