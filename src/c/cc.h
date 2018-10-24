/*

	C Compiler
	Manifest Constants Include File

*/


/*	configuration selectors

	To select the indicated option, uncomment
	the corresponding #define.

	To not select the indicated option, enclose
	the corresponding #define in comments.

*/

# define MERGE_LP 1
			/* are phases L and P merged?
			   affects C1.C and C21.C only	*/
# define CALL_ERROR 1
			/* is error phase called directly by control
			   routine?  affects C5.C only */

# define BOTHCASE 1
			/* distinct upper/lower case in idns */

/*	various values		*/

# define MREAD 'r'	/* read mode */
# define MWRITE 'w'	/* write mode */
# define MAPPEND 'a'	/* append mode */
# define TEXT "t"	/* text file */
# define BINARY "b"	/* binary file */
# define LEXEOF 0	/* lexget end of file indicator */

# define TRUE 1
# define FALSE 0
# define NULL 0
# define UNDEF -1
# define OPENLOSS -1	/* value returned for unsuccessful open */

/*	table sizes	*/

# define maxfarg 30	/* maximum number of function arguments */
# define maxreg 16	/* maximum number of abstract machine registers */
# define MAXDIMS 8	/* maximum number of dimensions in a type */
# define maxccl 10	/* size of compiler control line table */
# define maxargs 10	/* maximum number of args to input macro */
# define maxdepth 5	/* maximum depth of input macro expansion */
# define maxicb 3	/* maximum nesting of included files */
# define margbsz 200	/* size of table holding macro arg tokens */
# define mhsize 0400	/* size of macro hash table */
# define mhmask 0377	/* mask for accessing macro hash table */
# define hshsize 1999	/* size of hash table (prefer prime) */
# define icb_size 10	/* macro definition level */
# define cssiz 10000	/* size of character store */
# define stsize 300	/* size of symbol table (dict) */
# define mcdsz 3000	/* manifest constant definition table size */
# define coresz 6600	/* size of core array for function tree */
# define acoresz 150	/* size of array for expression tree */
# define pssize 300	/* size of parser stack */
# define tbsize 30	/* size of parser token buffer */
# define TTSIZE 600	/* type table size */
# define GSSIZE 20	/* group stack size */

/*	character types		*/

# define _LETTER 0	/* identifier or keyword */
# define _DIGIT 1	/* constant or identifier */
# define _QUOTE 2	/* character string */
# define _MCOP 3	/* possible beginning of multi-character op */
# define _EOL 4		/* carriage return or newline */
# define _BLANK 5	/* blank or tab */
# define _INVALID 6	/* invalid character */
# define _SQUOTE 7	/* character constant */
# define _PERIOD 8	/* operator or beginning of float constant */
# define _ESCAPE 9	/* escape character */
# define _CONTROL 10	/* compiler control line indicator */
# define _NAME		ttype<2

/*	token tags	*/

# define TEOF 1		/* end of file */
# define TCONTROL 2	/* beginning of control line (internal) */
# define TEQOP 36	/* =op's */
# define TIDN 75	/* identifiers */
# define TINTCON 76	/* integer constants */
# define TFLOATC 77	/* float constants */
# define TSTRING 78	/* string constants */
# define TLINENO 79	/* line number */
# define TMARG 80	/* macro argument (internal) */

/*	type tags	*/

# define TTCHAR 0	/* the first four values may not be changed */
# define TTINT 1
# define TTFLOAT 2
# define TTDOUBLE 3
# define TTLONG 4
# define TTUNSIGNED 5
# define TTUNDEF 6
# define TTCFIELD 7
# define TTIFIELD 8
# define TTPTR 9
# define TTFUNC 10
# define TTARRAY 11
# define TTSTRUCT 12
# define TTDUMMY 13

/*	type modifier indicators	*/

# define MPTR 1
# define MFUNC 2
# define MARRAY 3

/*	storage classes	*/

# define c_register 0		/* register */
# define c_temp 1		/* temporary */
# define c_auto 1		/* automatic */
# define c_extdef 2		/* external definition */
# define c_static 3		/* static */
# define c_param 4		/* parameter */
# define c_label 5		/* label */
# define c_integer 6		/* integer literal */
# define c_float 7		/* floating-point literal */
# define c_string 8		/* string literal */
# define c_indirect 9		/* indirection through reg #0 ... */
# define c_extern 50		/* external */
# define c_struct 51		/* structure type */
# define c_mos 52		/* member of structure */
# define c_typedef 53		/* type defintion */
# define c_ustruct 54		/* undefined structure type */
# define c_ulabel 55		/* undefined label */
# define c_uauto 56		/* unused auto variable */

/*	condition codes		*/

# define cc_eq0	0
# define cc_ne0	1
# define cc_lt0	2
# define cc_gt0	3
# define cc_le0	4
# define cc_ge0	5

/*	ctypes		*/

# define ct_bad 0
# define ct_struct 1
# define ct_char 2
# define ct_int 3
# define ct_float 4
# define ct_double 5
# define ct_p0 6
# define ct_p1 7
# define ct_p2 8
# define ct_p3 9

/*	loc flags	*/

# define l_label 0
# define l_reg 1
# define l_mem 2
# define l_any 3

/*	nodes		*/

# define n_idn		2
# define n_int		3
# define n_float	4
# define n_string	5
# define n_call		6
# define n_qmark	7
# define n_incb		8
# define n_inca		9
# define n_decb		10
# define n_deca		11
# define n_star		12
# define n_addr		13
# define n_uminus	14
# define n_bnot		15
# define n_tvnot	16
# define n_band		17
# define n_bior		18
# define n_bxor		19
# define n_mod		20
# define n_div		21
# define n_times	22
# define n_minus	23
# define n_plus		24
# define n_assign	25
# define n_eq		26
# define n_ne		27
# define n_lt		28
# define n_gt		29
# define n_le		30
# define n_ge		31
# define n_ls		32
# define n_rs		33
# define n_ars		34
# define n_als		35
# define n_aplus	36
# define n_aminus	37
# define n_atimes	38
# define n_adiv		39
# define n_amod		40
# define n_aand		41
# define n_axor		42
# define n_aior		43
# define n_tv_and	44
# define n_tv_or	45
# define n_dot		46
# define n_colon	47
# define n_comma	48
# define n_sizeof	49
# define n_if		80
# define n_goto		81
# define n_branch	82
# define n_label	83
# define n_stmtl	84
# define n_switch	85
# define n_case		86
# define n_def		87
# define n_return	88
# define n_prog		89
# define n_exprs	90
# define n_elist	91

/*	initializer types	*/

# define i_int 1
# define i_float 2
# define i_negfloat 3
# define i_string 4
# define i_idn 5

/*	enodes		*/

# define e_iminus 0000
# define e_dminus 0001
# define e_incbi 0002
# define e_bnot 0006
# define e_not 0007
# define e_lseq 0010
# define e_sw 0012
# define e_incbc 0013
# define e_a0 0017
# define e_a3 0022
# define e_ind 0023
# define e_jz0 0024
# define e_jz3 0027
# define e_jn0 0030
# define e_jn3 0033
# define e_addi 0100
# define e_eaddi 0101
# define e_subi 0104
# define e_esubi 0105
# define e_muli 0110
# define e_divi 0114
# define e_mod 0120
# define e_ls 0122
# define e_els 0123
# define e_rs 0124
# define e_ers 0125
# define e_band 0126
# define e_eand 0127
# define e_xor 0130
# define e_exor 0131
# define e_bor 0132
# define e_eor 0133
# define e_and 0134
# define e_or 0135
# define e_p0sub 0136
# define e_assign 0137
# define e_argi 0140
# define e_argd 0141
# define e_arg0 0142
# define e_add0 0146
# define e_add3 0151
# define e_sub0 0152
# define e_sub3 0155
# define e_movec 0160
# define e_comma 0170
# define e_idn 0177
# define e_int 0176
# define e_string 0175
# define e_float 0174
# define e_call 0173
# define e_colon 0172
# define e_qmark 0171
# define e_eqi 0200
# define e_eqd 0206
# define e_eqp0 0214
# define e_gep3 0243
# define e_incbf 0250
# define e_incbd 0254
# define e_incb0 0260

/*	object_modes		*/

# define o_pure 0	/* pure - instructions only */
# define o_impure 1	/* impure - uninitialized data areas */
# define o_data 2	/* data - initialized data areas */
# define o_pdata 3	/* pure data - constants */

# define pure	if (objmode != o_pure) mpure()
# define impure	if (objmode != o_impure) mimpure()
# define data	if (objmode != o_data) mdata()
# define pdata	if (objmode != o_pdata) mpdata()

/*	structure definitions		*/

# define typedesc struct _typedesc
# define type struct _typedesc *
# define field struct _fielddesc
struct _typedesc {
	int	tag;	/* the basic type or type modifier */
	int	size;	/* the size of objects of the type
			   -1 => size undefined */
	int	align;	/* the alignment class of objects of the type */
	type	val;	/* first additional value */
	int	nelem;	/* number of elements in an array */
	};
struct _fielddesc {
	int	name;	/* UNDEF => end of list */
	type	dtype;	/* field type */
	int	offset;	/* offset in structure */
	};
struct _token {int tag, index, line;};
struct _cclent {int cname; int (*cproc)();};

# define token struct _token
# define cclent struct _cclent

/* machine dependencies of the machine on which the compiler is running */

# define WORDMASK 077777777777		/* mask all but high 3 bits */
# define SMALLEST "-34359738368"	/* smallest integer as string */
