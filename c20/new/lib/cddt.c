#include <stdio.h>
#include <ctype.h>
#include "cddt.h"

#rename uuohnd "UUOHND"

uuohnd(op,arglist)
int op;
int *arglist;
{
	switch(op) {
	case 1:	/* initialization. happens right before main() */
		/* is executed. no args, this is just to let the */
		/* user get control and set things up		*/

		iniddt();
		break;

	case 2:	/* beginning of execution of a line of code */
		/* *arglist is the line number, *(arglist+1) */
		/* is the starting address of a packed asciz */
		/* string giving the file name */

		line(arglist);
		break;
	
	case 3:	/* function entry point. *arglist is the address */
		/* of a packed asciz string containing the funct */
		/* name. *(arglist+1) is the number of arguments */
		/* *(arglist+2) on up is the address of a data   */
		/* block for each argument. I dont know what's in*/
		/* each data block yet.				 */

		break;

	case 4: /* function exit. arglist should be some information */
		/* about the returned value, i guess		*/

		break;
	}

}

extern int consbp(),ildb();

static line(arglist)
int *arglist;
{
	int lineno;
	int bp;
	char filename[40];
	register char *fp;

	lineno = *arglist;		/* get line number */
	bp = consbp(7,arglist+1);	/* get file name */
	fp = filename;
	while (*fp = ildb(&bp))
		if (*fp != '"') fp++;	/* kill quotes */
	*fp = 0;

	printf("Line %d, file %s\n",lineno,filename);
}


/* gets control whenever we want info from the user */

static command()
{
	char ch;

again:
	tyos("\r\nCDDT>");
	tyo_flush();
	ch = utyi();
	ch = isupper(ch) ? tolower(ch): ch;
	switch (ch) {
	case '?':
		tyos("\n\tType one of the following single character commands:");
		tyos("\r\n\n");
		tyos("\tS(et) a breakpoint or variable\r\n");
		tyos("\tR(emove) a breakpoint\r\n");
		tyos("\tB(egin) tracing at specified line number or function\r\n");
		tyos("\tE(nd) tracing at specified line number or function\r\n");
		tyos("\tD(isplay) stack frames\r\n");
		tyos("\tC(ontinue) program execution\r\n");
		tyos("\tQ(uit) to superior level\r\n");
		tyo_flush();
		goto again;
	case 'c':
		return;
	case 's':			/* set something */
		doset();
		goto again;
	case 'r':
		doremove();
		goto again;
	case 'b':
		dobeg();
		goto again;
	case 'e':
		doend();
		goto again;
	case 'd':
		dodisp();
		goto again;
	case 'q':
		tyos("Quit\r\n");
		exit();
	default:
		tyos(" Unknown command - type a ? for help\r\n");
	}
}

static doset()
{
	char ch;

	tyos("Set ");
again:
	tyo_flush();
	ch = utyi();
	ch = isupper(ch) ? tolower(ch): ch;
	switch (ch) {
	case '?':
		tyos("\r\n");
		tyos("\tB(reakpoint) at line or function call\r\n");
		tyos("\tV(ariable) to a value\r\n");
		tyos("\tQ(uit) to main command loop\r\n");
		tyos("\r\nSet ");
		goto again;
	case 'b':
		setbreak();
		break;
	case 'v':
		setvar();
		break;
	case 'q':
		tyos("Quit\r\n");
		tyo_flush();
		break;
	default:
		loser();
		tyos("Set ");
		goto again;
	}
}

static setvar()
{
	char ch;

	tyos("Variable ");
	notyet();
	return;
}


static setbreak()
{
	char ch;

	tyos("Breakpoint at ");
again:
	tyo_flush();
	ch = utyi();
	ch = isupper(ch) ? tolower(ch): ch;
	switch (ch) {
	case '?':
		tyos("\r\n");	
		tyos("\tL(ine) number\r\n");
		tyos("\tF(unction) name\r\n");
		tyos("\tE(xit) from function\r\n");
		tyos("\tQ(uit) to main command loop\r\n");
		tyos("\nSet Breakpoint at ");
		goto again;
	case 'l':
		setbln();
		break;
	case 'f':
		notyet();
		break;
	case 'e':
		notyet();
		break;
	case 'q':
		tyos("Quit\r\n");
		break;
	default:
		loser();
		tyos("Set Breakpoint ");
		goto again;
	}
}


static doremove()
{
	char ch;

	tyos("Remove breakpoint number (? to show current breakpoints)");
again:
	tyo_flush;
	ch = utyi();
	ch = isupper(ch) ? tolower(ch): ch;
	switch (ch) {
	case '?':
		listbps();
		tyos("Remove Breakpoint ");
		goto again;
	default:
		notyet;
	}
}

static dobeg()
{
	char ch;

again:
	tyos("Begin Tracing at ");
	tyo_flush();
	ch = utyi();
	ch = isupper(ch) ? tolower(ch) : ch;
	switch (ch) {
	case '?':
		tyos("\r\n");
		tyos("\tL(ine) number\r\n");
		tyos("\tF(unction) entry point\r\n");
		tyos("\tE(xit) from function\r\n");
		tyos("\tQ(uit) to main command loop\r\n");
		tyos("\r\n");
		goto again;
	default:
		notyet();
		break;
	}
}

static doend()
{
	char ch;

again:
	tyos("End Tracing at ");
	tyo_flush();
	ch = utyi();
	ch = isupper(ch) ? tolower(ch) : ch;
	switch (ch) {
	case '?':
		tyos("\r\n");
		tyos("\tL(ine) number\r\n");
		tyos("\tF(unction) entry point\r\n");
		tyos("\tE(xit) from function\r\n");
		tyos("\tQ(uit) to main command loop\r\n");
		tyos("\r\n");
		goto again;
	default:
		notyet();
		break;
	}
}

static dodisp()
{

	tyos("D(isplay) stack frames. Number of levels? ");
	tyo_flush();
	notyet();
}

static notyet()
{

	tyos("\r\n\n - Sorry this isn't written yet\r\n");
	tyo_flush();
}

static loser()
{
	tyos(" Unknown command - type a ? for help\r\n");
}

static iniddt()
{;}

main() { command();}

listbps()
{
notyet();
}

setbln()
{
notyet();
}

static char *strsave(s) /* save a string somewhere */
char *s;	
{
char *temp;

if ((temp = calloc(1,1+strlen(s))) != NULL)
	strcpy(temp,s);
else printf("CDDT: free memory exhausted\n");
return (temp);
}

tnode *tree(p,w,c,n)  
tnode *p;
char *w;
int c;					/* object class */
int n;					/* object number */
{
	int cond;

	if (p == NULL) {	/*at a leaf */
		p = (tnode *) calloc(1,sizeof(tnode));
		p->word = strsave(w);
		p->left = p->right = NULL;
		p->class = c;
		p->number = n;
		}
	else if ((cond = strcmp(w,p->word) == 0) && c == p->class)
		printf("tree: duplicate word: %s\n",w);
	else if (cond < 0)
		p->left = tree(p->left,w);
	else
		p->right = tree(p->right,w);
	return(p);
}

treeprint(p)
struct tnode *p;
{
	if (p != NULL) {
		treeprint(p->left);
		printf("%s\n",p->word);
		treeprint(p->right);
	}
}

main()
{
	struct tnode *root;
	char word[500];
	char * t;

	root = NULL;
	while ((t = gets(word)) != NULL)
		root = tree(root,word);
	treeprint(root);
}
