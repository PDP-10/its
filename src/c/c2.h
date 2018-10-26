/*

	C COMPILER
	Phase P: Parser
	Insert File

	Copyright (c) 1977 by Alan Snyder

*/

/*	types	*/

struct _dentry		/* dictionary entry */
	{int	name;	/* the identifier, struct types stored +cssiz */
	type	dtype;	/* data type */
	int	offset;	/* addressing info */
	int	class;	/* storage class */
	};

# define dentry struct _dentry

/*      machine description tables      */

extern  int     tsize[], talign[], calign[], tpoint[], ntype,
		nac, sv_area_sz;

/*	variables	*/

extern	dentry	*dbegin, *dgdp, *dldp, *dend;
extern	int	lineno;

/*	functions	*/

int	*top(), *get_top(), *push(), *setsp();
dentry	*find(), *define();

/*	special type values	*/

extern type	TCHAR;
extern type	TINT;
extern type	TFLOAT;
extern type	TDOUBLE;
extern type	TLONG;
extern type	TUNSIGNED;
extern type	TUNDEF;
extern type	TPCHAR;
extern type	TACHAR;
extern type	TFINT;
