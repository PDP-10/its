/*	dependencies upon host machine !!	*/

# define WORDMASK 077777777777		/* mask all but high 3 bits */
# define SMALLEST "-34359738368"	/* smallest negative number */

/*	table sizes	*/

# define hshsize 200	/* size of hash table for identifiers */
# define cssiz 5000	/* size of character store */
# define pssize 100	/* size of action routine stack */
# define mcdsz 200	/* manifest constant definition table size */
# define eopchsz 0300

/*	various values		*/

# define MREAD 'r'	/* read mode */
# define MWRITE 'w'	/* write mode */
# define MAPPEND 'a'	/* append mode */
# define TEXT "t"	/* text file */
# define BINARY "b"	/* binary file */

# define TRUE 1
# define FALSE 0
# define NULL 0
# define UNDEF -1
# define OPENLOSS -1

/*	token types	*/

# define LEXEOF 0	/* internal end of file indicator */
# define TEOF 1		/* end of file */
# define _SEMI 3
# define _LPARN 4
# define _RPARN 5
# define _LBRAK 6
# define _RBRAK 7
# define _COLON 8
# define _COMMA 9
# define _OR 10
# define _NOT 11
# define T_AMOP 12	/* abstract machine operator */
# define _TYPENAMES 13
# define _ALIGN 14
# define _POINTER 15
# define _CLASS 16
# define _CONFLICT 17
# define _TYPE 18
# define _MEMNAMES 19
# define _MACROS 20
# define _SIZE 21
# define _INDIRECT 22
# define _REGNAMES 23
# define _RETURNREG 24
# define _SAVEAREASIZE 25
# define _OFFSETRANGE 26
# define _M 27
# define TIDN 28	/* identifiers */
# define TINTCON 29	/* integer constants */
# define TSTRING 30	/* string constants */

/*	location expression modes	*/

# define l_unknown 0
# define l_register 1
# define l_memory 2

/*	basic data types	*/

# define tchar 0		/* character */
# define tint 1			/* integer */
# define tfloat 2		/* float */
# define tdouble 3		/* double */

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
# define c_dummy 53		/* dummy structure def -
					for recursive definitions */

/*	enodes		*/

# define e_iminus 0000
# define e_dminus 0001
# define e_incbi 0002
# define e_bnot 0006
# define e_not 0007
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
# define e_add0 0146
# define e_add3 0151
# define e_sub0 0152
# define e_sub3 0155
# define e_movec 0160
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
# define e_incb0 0260

/*	STRUCTURES	*/

struct _token {int type,index,line;};
# define token struct _token
