#include <stdio.h>

# define TRUE  1
# define FALSE 0

/* Low level I/O stuff for HP plotters */
/* Routines include:
	h_init
	h_open
	h_close
	h_exit
	h_flush
	h_putc
	h_puts
	h_sbn
	h_mbn
	h_mbp
	h_pmb
	h_mba
	
*/

#define BUF_ENQ '\005'	
#define BUF_RDY '\006'
#define BUFSIZE 128

#define init_plotter _hpip


#define REP struct _rep
struct _rep {
	int jfn;
	int index;
	char can_use;
	char buffer[BUFSIZE];
	};


/**********************************************************************
* 	h_init - returns pointer to a "stream"
**********************************************************************/

REP *h_init ()
	{
	register REP *temp;

	temp = (REP *) calloc (1, sizeof (REP));
	temp->can_use = FALSE;
	return (temp);
	}

/**********************************************************************
*	h_open -  attach a stream to a device name
**********************************************************************/

h_open (stream, file)
register REP *stream;
char *file;
	{ 
	int errno,flag,oflag;

	flag = 01000000;
	
	stream->jfn = _GTJFN (flag,mkbptr(file));
	if (stream->jfn > 0600000) {
		h_error ("h_open: Can't find the plotter...");
		exit(1);
		}
	oflag = 04000300000;	/* read/write, image... */
	errno = _OPENF(stream->jfn,oflag | 7<<30);
	if (errno) {
		h_error ("h_open: Can't open plotter (probably in use...)");
		exit(1);
		}	
	stream->can_use = TRUE;
	stream->index = 0;

	init_plotter(stream);
	}

static init_plotter (stream)
REP *stream;
	{
	char line[200], temp[100];
	
	strcpy (line, "\033.(\033.J\033.K\033.I");
	sprintf (temp, "%d;%d;%d;0:", BUFSIZE,BUF_ENQ,BUF_RDY);
	strcat (line, temp);
	h_pts (stream, line);
	_dump (stream);
	}


/**********************************************************************
*	h_close - close stream
**********************************************************************/

h_close (stream)
REP *stream;
	{
	if (stream->can_use = TRUE) {
		h_flush (stream);
		h_pts (stream, "\033.L");	/* wait till buffer empty */
		_dump (stream);
		while (h_getc (stream) != '\015')
			;
		h_pts (stream, "\033.)");	/* turn plotter off */
		_dump (stream);
		_CLOSF(stream->jfn);
		stream->can_use = FALSE;
		}
	}


/***********************************************************************
*	check if stream to plotter is alive
**********************************************************************/

static check_can_use (stream)
REP *stream;
	{
	return (stream->can_use);
	}

/**********************************************************************
*	write a char to the plotter
**********************************************************************/

h_ptc (stream,chr)
register REP *stream;
char chr;
	{
	register int i;

	i = stream->index + 1;
	stream->index = i;
	stream->buffer[i] = chr;
	if (i >= BUFSIZE)
		h_flush (stream);
	}

/**********************************************************************
* 	h_getc - get char from plotter (unbuffered)
**********************************************************************/

static h_getc (stream)
REP *stream;
	{
	return ((_BIN (stream->jfn)) & 0177);
	}


/**********************************************************************
*	write a string to the plotter
**********************************************************************/

h_pts (stream, str)
register REP *stream;
register char *str;
	{
	while (*str) {
		h_ptc (stream, *str);
		str++;
		}
	}

/**********************************************************************
*	write a SBN to the plotter
**********************************************************************/

h_sbn (stream, i)
register REP *stream;
int i;
	{
	if ((i < 0) || (i > 63)) {
		h_error ("h_sbn: SBN out of range");
		i = 0;
		}
	if (i < 32) i += 64;
	_puti (stream, i);
	}

/**********************************************************************
*	write a MBN to the plotter
**********************************************************************/

h_mbn (stream, i)
REP *stream;
register int i;
	{
	register int n1,n2,n3,nr;

	if ((i < 0) || (i > 32767)) {
		h_error ("h_mbn: MBN out of range");
		i = 0;
		}
	if (i < 16) {	/* single byte */
		_puti (stream, i + 96);
		return;
		}
	if (i < 1024 ) {	/* two bytes needed */
		n1 = i / 64;
		n2 = i % 64;
		_puti (stream, n1 + 96);
		h_sbn (stream, n2);
		return;
		}
				/* here for three digit number */
	n1 = i / 4096;
	nr = i % 4096;
	n2 = nr / 64;
	n3 = nr % 64;
	_puti (stream, n1 + 96);
	h_sbn (stream, n2);
	h_sbn (stream, n3);
	}

/**********************************************************************
*	write MBP to plotter
**********************************************************************/

h_mbp (stream, x, y)
REP *stream;
register int x,y;
	{
	int nx1,nx2,nx3,nxr;
	int ny1,ny2,ny3,ny4,ny5,nyr;
	int nmax;

	if ((x < 0) || (x > 16383) || (y < 0) || (y > 16383)) {
		h_error ("h_mbp: MBP out of range");
		x = y = 0;
		}
	if (x > y) nmax = x; else nmax = y;
	if  (nmax < 4) {	/* single byte */
		_puti (stream, y + 4*x + 96);
		return;
		}
	if (nmax < 32) {	/* two bytes */
		nx1 = x / 2;
		nx2 = x % 2;
		_puti (stream, nx1 + 96);
		h_sbn (stream, y + 32*nx2);
		return;
		}
	if (nmax < 256) {	/* three bytes */
		nx1 = x / 16;
		nx2 = x % 16;
		ny2 = y / 64;
		ny3 = y % 64;
		_puti (stream, nx1 + 96);
		h_sbn (stream, ny2 + 4*nx2);
		h_sbn (stream, ny3);
		return;
		}
	if (nmax < 2048) {	/* four bytes */
		nx1 = x / 128;
		nxr = x % 128;
		nx2 = nxr / 2;
		nx3 = nxr % 2;
		ny3 = y / 64;
		ny4 = y % 64;
		_puti (stream, nx1 + 96);
		h_sbn (stream, nx2);
		h_sbn (stream, ny3 + 32*nx3);
		h_sbn (stream, ny4);
		return;
		}
				/* here for five bytes */
	nx1 = x / 1024;
	nxr = x % 1024;
	nx2 = nxr / 16;
	nx3 = nxr % 16;
	ny3 = y / 4096;
	nyr = y % 4096;
	ny4 = nyr / 64;
	ny5 = nyr % 64;
	_puti (stream, nx1 + 96);
	h_sbn (stream, nx2);
	h_sbn (stream, ny3 + 4*nx3);
	h_sbn (stream, ny4);
	h_sbn (stream, ny5);
	}

/**********************************************************************
*	write PMB to plotter
**********************************************************************/

h_pmb (stream, x, y)
REP *stream;
int x,y;
	{
	_ppmb (stream, x, 64);
	_ppmb (stream, y, 32);
	}

static _ppmb (stream, val, flag)
REP *stream;
int val, flag;
	{
	register int nx1,nx2,nx3,nxr;

	if ((val < -16384) || (val > 16383)) {
		h_error ("_ppmb: PMB out of range");
		val = 0;
		}
	if ((-16 <= val) && (val < 16)) {
		val = _abs (val, 32);
		_puti (stream, val + flag);
		return;
		}
	if ((-512 <= val) && (val < 512)) {
		val = _abs (val, 1024);
		nx1 = val / 32;
		nx2 = val % 32;
		_puti (stream, nx1 + flag);
		_puti (stream, nx2 + flag);
		return;
		}
	val = _abs (val, 32768);
	nx1 = val / 1024;
	nxr = val % 1024;
	nx2 = nxr / 32;
	nx3 = nxr % 32;
	_puti (stream, nx1 + flag);
	_puti (stream, nx2 + flag);
	_puti (stream, nx3 + flag);
	}

/**********************************************************************
*	h_mba - write MBA to plotter
**********************************************************************/

h_mba (h,a)
REP *h;
int a;
	{
	int na,np1,na1,na2,na3,nr;
	if ((a < 0) || (a > 360)) {
		h_error ("h_mba: Angle out of range");
		a = 0;
		}
	np1 = 0;
	if (a > 180) {
		np1 = 8;
		a -= 180;
		}
	na = (int) (((float) a) * 32768.0 / 180.0);
	na1 = na / 4096;
	_puti (h,np1+na1+96);
	nr = na % 4096;
	if (nr = 0)
		return;
	na2 = nr / 64;
	h_sbn (h,na2);
	na3 = nr % 64;
	if (na3 = 0)
		return;
	h_sbn (h,na3);
	}


static _abs (i, offset)
register int i, offset;
	{
	if (i < 0) i += offset;
	return (i);
	}

/**********************************************************************
*	h_error - report an error
**********************************************************************/

h_error (msg)
register char *msg;
	{
	fprintf (stderr, "%s\n", msg);
	}

/**********************************************************************
*	h_flush - send accumulated output
**********************************************************************/

h_flush (stream)
REP *stream;
	{
	buf_wait (stream);
	_dump (stream);
	er_chk (stream);
	}

static _puti (stream, i)
REP *stream;
int i;
	{
	h_ptc (stream,i);
	}

static buf_wait (stream)
REP *stream;
	{
	char c;

	_BOUT (stream->jfn, BUF_ENQ);
	if (h_getc (stream) != BUF_RDY) {
		h_error ("Bad handshake character received");
		exit (1);
		}
	}		

static er_chk (stream)
REP *stream;
	{;}

static _dump (stream)
register REP *stream;
	{
	register int i;

	for (i = 0; i <= stream->index; i++) 
		_BOUT (stream->jfn, stream->buffer[i]);
	stream->index = 0;
	}