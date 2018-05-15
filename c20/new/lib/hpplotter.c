/**********************************************************************

	HPPLOTTER - this is a set of routines which drive an HP 
	plotter. HPIO.C is used as a low-level interface to the
	operating system

	Functions in this package:

		open			set up and get a plotter
		close			punt plotter
		flush			execute commands now
		set_char_size		set char size
		set_print_space		set size of character square
		set_char_slant
		get_char_size
		get_print_space
		set_color		select a pen
		get_color
		set_page_size		set max x,y coordinates
		get_page_size		get max x,y coordinates
		set_solid_line		start using solid line
		set_dash_line		start using dashed lines
		set_dot_line		start using dotted lines
		set_scale		scale factor for entire drawing
		set_offset		offset for entire drawing
		get_scale_offset
		printc			write a text character
		prints			write a text string
		draw_to			draw from current to given
		draw_by			draw from current to c + given
		move_to			same as above with pen up
		move_by			  "   "   "     "   "   "
		line			draw a line from here to there
		box			draw box given center and size
		square			draw square given center and size
		circle			draw circle given center, diameter
		text			write text, start at given point
			
*********************************************************************/

#include "hpplotter.h"
#include <stdio.h>

#define scale _hscle

#define REP struct _hpplotter
struct _hpplotter {
	int stm;	/* plotter stream */
	char lbl_trm;	/* label terminator */
	int line_space;	/* between lines */
	int char_space;	/* between chars */
	int h_offset;
	int v_offset;
	int h_page_size; /* page size in plotter coordinates */
	int v_page_size;
	float scale_factor;
	};

/* default parameter values */
#define LBL_TRM '\003'
#define PAGE_H_SIZE 3040
#define PAGE_V_SIZE 2000

/* hacks */
#define PUTC h_ptc
#define PUTS h_pts

/**********************************************************************
* 	HP_OPEN - open a plotter. 
**********************************************************************/

REP *hp_open (hpname)
char *hpname;
	{
	register int hpstm;
	register REP *temp;

	hpstm = h_init ();
	temp = (REP *) calloc (1, sizeof (REP));
	temp->stm = hpstm;
	temp->h_offset = temp->v_offset = 0;
	temp->line_space = 50;
	temp->char_space = 25;
	temp->lbl_trm = LBL_TRM;
	temp->scale_factor = 1.0;

	h_open (hpstm, hpname);
	h_pts (hpstm, "~_");		/* init plotter */
	h_pts (hpstm, "~\\");		/* set label terminator */
	h_mbn (hpstm, LBL_TRM);
	hp_set_page_size (temp, PAGE_H_SIZE, PAGE_V_SIZE);
	h_flush (hpstm);
	return (temp);
	}

/**********************************************************************
*	HP_CLOSE - close plotter stream
**********************************************************************/

hp_close (h)
REP *h;
	{
	hp_set_color (h,"");
	hp_flush (h);
	h_close (h->stm);
	free (h);
	}

/**********************************************************************
* 	HP_FLUSH - send data to plotter
**********************************************************************/

hp_flush (h)
REP *h;
	{
	h_ptc (h->stm, '}');	/* NOP to force last graphics cmd */
	h_flush (h->stm);
	}

/**********************************************************************
*	HP_SET_COLOR - pick a pen
**********************************************************************/

hp_set_color (h, color)
REP *h;
char *color;
	{
	register int ccode;

	if (!strcmp (color, ""))	/* no pen */
		ccode = 0;
	else if (!strcmp (color, "black"))
		ccode = 1;
	else if (!strcmp (color, "red"))
		ccode = 2;
	else if (!strcmp (color, "green"))
		ccode = 3;
	else if (!strcmp (color, "blue"))
		ccode = 4;
	else {
		h_error ("hp_set_color: Unknown color, using black");
		ccode = 1;
		}

	PUTC (h->stm, 'v');
	h_sbn (h->stm, ccode);
	hp_flush (h);
	}

/**********************************************************************
*	HP_SET_PAGE_SIZE
**********************************************************************/

hp_set_page_size (pltr, h, v)
REP *pltr;
int h, v;
	{
	pltr->h_page_size = h;
	pltr->v_page_size = v;
	PUTS (pltr->stm, "~S");
	h_mbp (pltr->stm, h, v);
	}

/**********************************************************************
*	HP_GET_PAGE_SIZE
**********************************************************************/

hp_get_page_size(p,h,v)
REP *p;
int *h,*v;
{
	*h = p->h_page_size;
	*v = p->v_page_size;
}

/**********************************************************************
*	HP_SET_CHAR_SLANT
**********************************************************************/

hp_set_char_slant (p,a)
REP *p;
int a;
	{
	PUTS (p->stm,"/");
	h_mba (p->stm, a);
	}

/**********************************************************************
*	HP_SET_SCALE
**********************************************************************/

hp_set_scale (p,sc)
REP *p;
float sc;
	{
	p->scale_factor = sc;
	}

/**********************************************************************
*	HP_SET_OFFSET
**********************************************************************/

hp_set_offset (p,hb,vb)
REP *p;
int hb,vb;
	{
	p->h_offset = hb;
	p->v_offset = vb;
	}

/**********************************************************************
*	HP_INCREMENT_SCALE
**********************************************************************/

hp_increment_scale (p,sc)
REP *p;
float sc;
	{
	p->scale_factor = p->scale_factor * sc;
	}

/**********************************************************************
*	HP_SET_PRINT_SPACE
**********************************************************************/

hp_set_print_space (p,h,v)
REP *p;
int h,v;
	{
	p->char_space = h;
	p->line_space = v;
	}

/**********************************************************************
*	HP_SET_CHAR_SIZE
**********************************************************************/

hp_set_char_size (p,h,v)
REP *p;
int h,v;
	{
	hp_set_print_space (p,(3*h)/2,2*v);
	}

/**********************************************************************
*	HP_MOVE_TO
**********************************************************************/

hp_move_to (p, h, v)
REP *p;
int h,v;
	{
	s_offset (p,h,v,&h,&v);
	PUTC (p->stm, 'p');
	h_mbp (p->stm, h, v);
	}

/**********************************************************************
*	HP_MOVE_BY
**********************************************************************/

hp_move_by (p, dh, dv)
REP *p;
int dh,dv;
	{
	scale (p,dh,dv,&dh,&dv);
	PUTC (p->stm, 'r');
	h_pmb (p->stm,dh,dv);
	}

/**********************************************************************
*	HP_DRAW_TO
**********************************************************************/

hp_draw_to (p,h,v)
REP *p;
int h,v;
	{
	s_offset (p,h,v,&h,&v);
	PUTC (p->stm, 'q');
	h_mbp (p->stm,h,v);
	}

/**********************************************************************
*	HP_DRAW_BY
**********************************************************************/

hp_draw_by (p,dh,dv)
REP *p;
int dh,dv;
	{
	scale (p,dh,dv,&dh,&dv);
	PUTC (p->stm, 's');
	h_pmb (p->stm, dh,dv);
	}

/**********************************************************************
*	HP_PRINTS
**********************************************************************/

hp_prints (p, string)
REP *p;
register char *string;
	{
	int h,v;
	register int stream;
	register char t;

	stream = p->stm;
	scale (p, p->char_space, p->line_space, &h,&v);
	PUTS (stream, "~%");
	h_mbp (stream, h, v);
	PUTS (stream, "~'");
	while (t = *string++) {
		PUTC (stream, t);
		}
	PUTC (stream, p->lbl_trm);
	}

/**********************************************************************
*	HP_PRINTC
**********************************************************************/

hp_printc (p, chr)
REP *p;
char chr;
	{
	char buff[2];

	buff[1] = chr;
	buff[2] = 0;
	hp_prints (p, buff);
	}

/**********************************************************************
*	HP_SET_SOLID_LINE
**********************************************************************/

hp_set_solid_line (p)
REP *p;
	{
	PUTS (p->stm, "~Q");
	}

/**********************************************************************
*	HP_SET_DASH_LINE
**********************************************************************/

hp_set_dash_line (p,l)
REP *p;
int l;
	{
	register int stm;

	stm = p->stm;
	PUTS (stm, "~Q");
	h_sbn (stm, 32 + 2);
	h_sbn (stm, 2);
	h_mbn (stm, sscale (p,l));
	}

/**********************************************************************
*	HP_SET_DOT_LINE
**********************************************************************/

hp_set_dot_line (p,s)
REP *p;
int s;
	{
	register int stm;
	int t;
	
	stm = p->stm;
	PUTS (stm, "~R");
	s = sscale (p,s);
	h_sbn (stm, 32 + 1);
	for (t = 1; t <= (s-1)/31; t++)
		h_sbn (stm,31);
	h_sbn (stm, (s-1)%31);
	h_mbn (stm, s);
	}

/**********************************************************************
*	HP_CIRCLE
**********************************************************************/

hp_circle (p,h,v,d)
REP *p;
int h,v,d;
	{
	int r;

	r = d/2;
	hp_move_to (p,h + r,v);
	PUTC (p->stm, 'u');
	h_mbn (p->stm, sscale (p,r));
	}

/**********************************************************************
*	HP_BOX
**********************************************************************/

hp_box (p,h,v,dh,dv)
REP *p;
int h,v,dh,dv;
	{
	hp_move_to (p,h - dh/2,v - dv/2);
	hp_draw_by (p,dh,0);
	hp_draw_by (p,0,dv);
	hp_draw_by (p,-dh,0);
	hp_draw_by (p,0,-dv);
	}

/**********************************************************************
*	HP_SQUARE
**********************************************************************/

hp_square (p,h,v,d)
REP *p;
int h,v,d;
	{
	hp_box (p,h,v,d,d);
	}

/**********************************************************************
*	HP_LINE
**********************************************************************/

hp_line (p,h,v,dh,dv)
REP *p;
int h,v,dh,dv;
	{
	hp_move_to (p,h,v);
	hp_draw_by (p,dh,dv);
	}

/**********************************************************************
*	HP_TEXT
**********************************************************************/

hp_text (p,h,v,string)
REP *p;
int h,v;
char *string;
	{
	hp_move_to (p,h,v);
	hp_prints (p,string);
	}


/**********************************************************************
*	 internal routines
**********************************************************************/

static scale (p,x,y,ax,ay)
REP *p;
int x,y;
int *ax, *ay;
	{
	register float sc;

	sc = p->scale_factor;
	*ax = (int) (sc * (float) x);
	*ay = (int) (sc * (float) y);
	}

static s_offset (p,h,v,ah,av)
REP *p;
int h,v;
int *ah, *av;
	{
	int ht,vt;

	if (p->scale_factor != 1.0)
		scale (p,h,v,&h,&v);
	if ((p->h_offset != 0) || (p->v_offset != 0)) {
		*ah = h + sscale (p,p->h_offset);
		*av = v + sscale (p,p->v_offset);
		}
	else {
		*ah = h;
		*av = v;
		}
	}

static sscale (p,i)
REP *p;
int i;
	{
	return ((int) (p->scale_factor * (float) i));
	}	