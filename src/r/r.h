#

/*

	R Text Formatter
	Header File

	Copyright (c) 1976, 1977 by Alan Snyder

*/

/**********************************************************************

	CONFIGURATION OPTIONS

	For the following options, TRUE == the symbol is #define'd,
	FALSE == the symbol is not #defined'd.

	Option USE_PORTABLE_OUTPUT: if TRUE, output is performed
	by the standard COPEN/CPUTC/CPRINT/CCLOSE.  Otherwise, the
	routines OOPN, OUTC, OUTI, OUTS, and OCLS are assumed to be
	elsewhere defined.

	Option SCRIMP: if TRUE, tables sizes are reduced to minimize
	storage space.

	Option USE_MACROS: if TRUE, the various non-essential macros
	are used.  Otherwise, the corresponding routines are used.
	Many of the routines do (hopefully) redundant error checking.

	WORD SIZE OPTION

	If the type INT has 32 or more bits, #define BIGWORD.
	[IGNORE:
	  Otherwise, if the type LONG has 32 or more bits, #define 
	  BIGWORD and #define BIGLONG.]
	Otherwise, do not #define either of these, and only 16 bits
	per word will be used.  The penalty of not using BIGWORD
	seems to have gone away.

	DEVICE OPTIONS:

	HAVE_XGP => include XGP support
	HAVE_VARIAN => include VARIAN support

**********************************************************************/

# ifdef unix		/* UNIX settings */
# define USE_PORTABLE_OUTPUT
# define SCRIMP
# define USE_MACROS
# define HAVE_VARIAN
# endif

# ifndef unix		/* ITS settings */
# define USE_MACROS
# define BIGWORD
# define HAVE_XGP
# endif

/*	complete set:

	# define USE_PORTABLE_OUTPUT
	# define SCRIMP
	# define USE_MACROS
	# define BIGWORD
	# define BIGLONG
	# define HAVE_XGP
	# define HAVE_VARIAN

*/

/**********************************************************************

	ROUNDING

	If the default float-to-int conversion of your C does not
	round (i.e. it truncates), then a ROUND function must be
	provided.  Otherwise, an "identity" macro is sufficient.
	NOTE: round(-x) must be equal to -round(x).  I weakly prefer
	that round(1.5)=1.

**********************************************************************/

# ifdef unix
# define round(x) ((x)>=0 ? (int)((x)+0.4999) : -((int)(-(x)+0.4999)))
# endif

# ifndef unix
# define round(x) (x)
# endif

/**********************************************************************

	END OF CONFIGURATION OPTIONS

**********************************************************************/

/*	new types	*/

# ifdef BIGLONG
# define bits long
# endif
# ifndef BIGLONG
# define bits int
# endif
extern bits btemp;

# define token bits		/* input tokens */
# define word int		/* text words */
# define idn int		/* index into hash table */
# define ac int			/* extendible character arrays */
# define ichar int		/* logical input character */

/*	sizes not subject to easy change	*/

# define ndev 3			/* number of output devices */
# define max_args 10		/* max number of macro arguments */
# define max_fonts 16		/* max number of fonts */

/*	changeable sizes	*/

# define max_env 20		/* max number of environments */
# define max_tabs 30		/* max number of tab stops */
# define FRSIZE 10		/* font ring-buffer size */

/*	changeable SCRIMP-dependent sizes	*/

# ifndef SCRIMP
# define FNSIZE 100		/* max size of file names */
# define max_idn 1000		/* max number of identifiers */
# define max_var 200		/* maximum number of variables */
# define tcstore_size 010000	/* storage for text words;
				   must be power of 2 and <= 010000 */
# define max_group 30		/* max depth of group nesting */
# define max_icb 30		/* max depth of input stack */
# define max_traps 20		/* max number of traps */
# define max_tokens 300		/* max number tokens per line */
# define gc_tab_size 100	/* temporary storage for GC */
# endif

# ifdef SCRIMP
# define FNSIZE 50		/* max size of file names */
# define max_idn 600		/* max number of identifiers */
# define max_var 50		/* maximum number of variables */
# define tcstore_size 04000	/* storage for text words;
				   must be power of 2 and <= 010000 */
# define max_group 20		/* max depth of group nesting */
# define max_icb 15		/* max depth of input stack */
# define max_traps 10		/* max number of traps */
# define max_tokens 100		/* max number tokens per line */
# define gc_tab_size 50		/* temporary storage for GC */
# endif

/*	useful values	*/

# define TRUE 1
# define FALSE 0
# define infinity 30000		/* a large integer */
# define OPENLOSS (-1)		/* value returned by failing open */
# define TCMASK (tcstore_size-1)

# define max_voff 8191		/* largest vertical offset */
# define min_voff (-8192)	/* smallest vertical offset */
# ifndef BIGLONG
# ifdef BIGWORD
# define max_voff 32767		/* largest vertical offset */
# define min_voff (-32768)	/* smallest vertical offset */
# endif
# endif

# ifdef BIGWORD
# define WVMASK 0177777
# define WSHIFT 16
# define WOSIZE 5
# define WOMASK 037
# endif

# ifndef BIGWORD
# define WVMASK 07777
# define WSHIFT 12
# define WOSIZE 4
# define WOMASK 017
# endif

/*	tokens types	*/

/*	tokens with no value component:		*/

# define t_null 0
# define t_center 1
# define t_right 2

/*	tokens with a value component:		*/

# define t_offset 9
# define t_nlspace 10
# define t_hpos 11
# define t_pos 12
# define t_space 13
# define t_tabc 14
# define t_text 15

/*	devices		*/

# define d_xgp 0
# define d_lpt 1
# define d_varian 2

/*	adjustment modes	*/

# define a_left 0
# define a_right 1
# define a_center 2
# define a_both 3

/*	font modes	*/

# define f_normal 0
# define f_underline 1
# define f_overprint 2
# define f_caps 3

/*	control-character types	*/

# define cc_text 1		/* part of text */
# define cc_separator 2		/* separates text */
# define cc_universal 3		/* separator recognized everywhere */
# define cc_input 4		/* interpreted by input scanner */

/*	input source types	*/

# define i_file 0
# define i_char 1
# define i_string 2
# define i_ac 3
# define i_macro 4
# define i_peekc 5
# define i_nomore 6

/*	input character types	*/

# define i_text 0
# define i_control 1
# define i_protect 10

/*	some ICHAR literals	*/

# define i_space 01040
# define i_newline 01152
# define i_eof 01000
# define i_dot 01056		/* ^. */
# define i_quote 01047		/* ^' */
# define i_back 01134		/* ^\ */
# define i_ctrl_a 01141		/* ^a */
# define i_ctrl_g 01147		/* ^g */
# define i_ictr_g 01107		/* ^G (internal) */
# define i_tab 01151		/* ^i */
# define i_comment 01153	/* ^k */
# define i_ctrl_n 01156		/* ^n */
# define i_ctrl_q 01161		/* ^q */
# define i_ctrl_s 01163		/* ^s */
# define i_ctrl_x 01170		/* ^x */

/*	input modes	*/

# define m_quote 0
# define m_args 1
# define m_text 2

/*	name_info bits	*/

# define NRDEFINED	00001	/* named number register exists */
# define NRBUILTIN	00002	/* number register is built-in */
# define NRFREEZE	00004	/* built-in number register freezes */
# define SRDEFINED	00010	/* named string register exists */
# define SRBUILTIN	00020	/* string register is built-in */
# define SRFREEZE	00040	/* built-in string register freezes */
# define RQMACRO	00100	/* request is a macro */
# define RQFREEZE	00200	/* built-in request freezes */
# define RQBREAK	00400	/* built-in request causes break */
# define RQTHAW		01000	/* built-in request must precede freeze */
# define RQBITS		01700	/* request info bits */

/*	code sequences	*/

# define freeze if (!frozen) header ()
# define not_frozen if (frozen) toolate ()

/*	types	*/

struct _env {
	idn	ename;			/* environment name */
	int	line_spacing;		/* in lines * 100 */
	int	indent;			/* in HU */
	int	right_indent;		/* in HU */
	int	adjust_mode;
	int	nofill_adjust_mode;
	int	filling;		/* boolean */
	int	temp_indent;		/* -1 if none */
	int	tn;			/* number of tokens in line_buf */
	int	ha;			/* height of line above baseline */
	int	hb;			/* height of line below baseline */
	int	hp;			/* current horizontal position in line */
	int	rm;			/* right margin for current line */
	int	text_seen;		/* text seen in current line */
	int	default_height;		/* determines line spacing */
	int	space_width;		/* width of space in HU */
	int	char_width;		/* nominal char width in HU */
	int	pfont;			/* principle font */
	int	ifont;			/* current input font */
	int	iul;			/* input underline mode */
	int	ivoff;			/* input vertical offset */
	int	tab_stops[max_tabs];	/* in HU */
	token	line_buf[max_tokens];	/* current partially collected line */
	int	partial_word;
		/* flag set by ^g and ^G (internal):
		   bit PWCONCAT: causes concatenation if last word
			on line is text
		   bit PWEATNL: inhibits newlines
		*/
	int	end_of_sentence;	/* should newline be 2 spaces? */
	int	delflag;		/* delete when next deselected */
	};

# define env struct _env

# define PWCONCAT 01
# define PWEATNL 02


struct _fontdes {
	char fname[FNSIZE];	/* font file name */
	int fha;		/* height above baseline */
	int fhb;		/* height below baseline */
# ifdef unix
	int cpadj;		/* font column position adjustment */
# endif
	int fwidths[0200];	/* character widths */
# ifdef unix
	int flkern[0200];	/* character lkerns */
# endif
	int fmode;		/* LPT mode */
	};

# define fontdes struct _fontdes

/*	renamings to handle long names	*/

# define	LineBrkjust		lnbrkjust
# define	LineNLSpace		lnnlspace
# define	LineReset		lnreset
# define	LineTabc		lntabc
# define	LineText		lntext
# define	append_string		astring
# define	append_token		atoken
# define	check_prefix		chkprx
# define	cntrl_stat		ctrlstat
# define	current_adjust_mode	curadjust_mode
# define	decode_backslash	dcbackslash
# define	decode_sharp		dcsharp
# define	eprint_lineno		epline
# define	find_env		fenv
# define	find_pos		fpos
# define	find_trap		ftrap
# define	font_exists		fexists
# define	font_ha			fntha
# define	font_name		foname
# define	font_table		ftable
# define	font_width		fwidth
# define	get_cc			getcc
# define	get_font		gt_font
# define	get_input_pos		ginppos
# define	get_input_type		ginptype
# define	get_lineno		gt_lineno
# define	getc_ac			gcac
# define	getc_char		gcchar
# define	getc_eof		gceof
# define	getc_file		gcfile
# define	getc_macro		gcmacro
# define	getc_peekc		gcpeekc
# define	getc_string		gcstring
# define	getc_trace		gctrace
# define	ichar_cons		iccons
# define	ichar_type		ictype
# define	ichar_val		icval
# define	insert_number		insnumber
# define	insert_string		insstring
# define	lpt_eof			lpteof
# define	lpt_eop			lptep
# define	lpt_eow			lptew
# define	make_ac_idn		mk_ac_idn
# define	make_env		mk_env
# define	move_up			movup
# define	new_pfont		npfont
# define	next_tab		nxtab
# define	next_trap		nxtrap
# define	old_env			oldenv
# define	output_init		oinit
# define	output_line		oline
# define	page_empty		pgempty
# define	page_length		pglength
# define	page_number		pgnumber
# define	po_eof			poeof
# define	po_eop			poeop
# define	po_eow			poeow
# define	process_args		proargs
# define	process_break		probrk
# define	process_options		proopts
# define	push_ac			pac
# define	push_char		pchar
# define	push_file		pfile
# define	push_for		psh_for
# define	push_group		psh_group
# define	push_icb		picb
# define	push_if			psh_if
# define	push_macro		pmacro
# define	push_string		pstring
# define	push_var		psh_var
# define	push_while		psh_while
# define	reset_overprint		rsoverprint
# define	reset_traps		rtraps
# define	scan_macro_body		scanmacrobody
# define	set_lpt			setlpt
# define	skip_arg		skiparg
# define	skip_until_end		skp_until_end
# define	text_ha			txha
# define	text_hb			txhb
# define	text_init		txinit
# define	text_mark		txmrk
# define	text_update		txupd
# define	token_cons		tkcons
# define	token_type		tktype
# define	token_val		tkval
# define	trace_off		trcoff
# define	trace_on		trcon
# define	xgp_eof			xgpeof
# define	xgp_eop			xgpep
# define	xgp_eow			xgpew

/*	end of renamings	*/

/*	MACROS	*/

# ifdef USE_MACROS
# define max(a,b) ((a)<(b) ? (b) : (a))
# define min(a,b) ((a)<(b) ? (a) : (b))
extern char ctab[];
# define alpha(c) (!((c)&~0177) && ctab[c])

# ifndef BIGLONG
# define token_cons(type,val) (((type)<<WSHIFT)|(val))
# endif
# ifdef BIGLONG
# define token_cons(type,val) (((btemp=(type),btemp)<<WSHIFT)|(val))
# endif
# define token_val(w) ((w) & WVMASK)
# define token_type(w) (((w)>>WSHIFT)&WOMASK)

extern int tcstore[];
# define text_width(w) (tcstore[w])
# define text_ha(w) (tcstore[(w) + 1])
# define text_hb(w) (tcstore[(w) + 2])

extern int device;
extern fontdes *font_table[];

# define font_ha(n) (device==d_lpt?1:font_table[n]->fha)
# define font_hb(n) (device==d_lpt?0:font_table[n]->fhb)
# define font_width(n,c) (device==d_lpt?1:font_table[n]->fwidths[c])

# define ichar_type(ic) (((ic)>>9) & 077)
# define ichar_val(ic) ((ic) & 0777)
# define ichar_cons(type,val) (((type)<<9) | (val))

extern char *nametab[];
# define idn_string(i) (nametab[i])

# endif /* USE_MACROS */

/* ichar macros */

# define is_separator(ic) ((ic) == i_space || (ic) == i_tab)
# define is_terminator(ic) ((ic)==i_space||(ic)==i_tab||(ic)==i_newline||(ic)==i_eof)

/* high-level trace macros */

# define trace_character(ic) if (f2trace>=0) tr_character (ic); else
# define trace_int(i) if (f2trace>=0) tr_int (i); else
# define trace_hu(i) if (f2trace>=0) tr_hu (i); else
# define trace_vu(i) if (f2trace>=0) tr_vu (i); else
# define trace_fixed(i) if (f2trace>=0) tr_fixed (i); else

/*	output macros	*/

# ifdef USE_PORTABLE_OUTPUT
# define outc(c) cputc ((c), fout)		/* output ascii char */
# define outi(c) cputc ((c) | 0400, fout)	/* output image char */
# define outs(str) cprint (fout, "%s", (str))	/* output string */
# define ocls() cclose (fout)			/* close output */
# endif

/*	INDIRECT ROUTINES	*/

extern ichar (*pgetc)();
# define getc1() ((*pgetc)())
# define getc2() ((*pgetc)())

extern int (*po_char)(), (*po_eow)(), (*po_vp)(), (*po_space)(),
	(*po_eol)(), (*po_eop)(), (*po_eof)();
# define output_char (*po_char)
# define output_eow (*po_eow)
# define output_vp (*po_vp)
# define output_space (*po_space)
# define output_eol (*po_eol)
# define output_eop (*po_eop)
# define output_eof (*po_eof)

double gete1();
# define gete() (gete1 (-1))
