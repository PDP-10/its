#include <stdio.h>

#rename stacktrace "STACKT"
#rename getfp "GETFP"
#rename pdlbot "PDL"
#rename seg1lo "SEG1LO"
#rename seg1hi "SEG1HI"
#rename begint "BEGINT"
#rename endint "ENDINT"
#rename pclev3 "PCLEV3"
#rename debug "DEBUG"
#rename debugc "DEBUGC"

extern int *pdlbot,*seg1lo,*seg1hi,*pclev3;
extern int begint,endint;
char debugc;	/* current debugger interrupt char */

stacktrace()
{
	int *fp,*rpc,*bp,*aptr,*crpc;
	char funname[9],*funptr;
	int nargs;

	printf("Stack trace:\n\n");
	fp = getfp() & 0777777;
	while (fp > pdlbot) {
		rpc = *(fp-1) & 0777777;
		fp = *fp & 0777777;
		crpc = *(fp-1) & 0777777;
		aptr = (int *) ((int) (fp-2) & 0777777);
		if ((rpc >= &begint) && (rpc <= &endint)) {
			rpc = (int *) ((int) pclev3 & 0777777);
		}
		if ((rpc < seg1lo) || (rpc > seg1hi)) {
			printf("Trace error: PC not in Code segment\n\n");
			printf("This may occur if the stack is trashed,\n");
			printf("or you may have been in the middle of a\n");
			printf("procedure call. Try again.\n");
			return;
		}
		while (rpc >= seg1lo) {
			if ((*rpc >> 27) == 0) break;	/* should be header */
			rpc--;
		}
		bp = consbp(7,*rpc & 0777777);	/* get function name */
		funptr = funname;
		while (*funptr = ildb(&bp))
			funptr++;
		*funptr = 0;
		nargs = (*rpc >> 18) & 077;
		printf("%s (",funname);
		for (;nargs > 0;nargs--,aptr--) {
			printf("%d",*aptr);
			if (nargs > 1) putchar(',');
		}
		printf(")\n\tCalled from %o\n\n",crpc);
		if (!strcmp(funname,"main")) break;
	}
}

chgdbc(chr)	/* change debugger interrupt char, or -1 to have none */
int chr;
{
	if (debugc != -1)
		_dti(halves(debugc,0));
	if (chr != -1)
		_ati(halves(chr,0));
	debugc = chr;
}

debug(argc,argv)	/* called instead of "main" by runtimes */
int argc; char **argv;
{

	iset(0,stacktrace);		/* tie channel 0 to stacktrace  */
	debugc = '\004';
	_ati(halves('\004',0));		/* tie channel 0 to ^D  */
	main(argc,argv);		/* go to it */
}
