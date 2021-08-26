# ifdef unix
# include <stdio.h>
# endif
# define TRUE 1
# define FALSE 0

/* colors */

# define EMPTY 0	/* - */
# define WHITE 1	/* @ */
# define BLACK 2	/* * */

/* commands */

# define ANALYZ	'a'
# define PBOARD	'b'
# define HCAP	'h'
# define LISTM	'l'
# define MANUAL	'm'
# define OPTCOM	'o'
# define QUIT	'q'
# define RESIGN	'r'
# define READCM	'B'
# define SCORE	's'
# define TREECM	't'
# define WRITCM	'w'
# define XCOM	'x'
# define HELP	'?'
# define SHELL	'!'

/* internal commands */

# define ERROR	0
# define MOVE	'M'
# define DONE	'D'
# define RETRY	'R'

/* answers */

# define YES	'y'
# define NO	'n'

# ifndef unix
# define fastchar int
# endif
# ifdef unix
# define fastchar char
# endif

extern fastchar sqval[100], ssqval[100];
extern int endgame;

typedef fastchar board[100];
typedef int position;
typedef int direction;
typedef int color;

# define oppcolor(c) ((c)^3)
# define bscore(b,c) (b[c])

# define ismove(b,c,p) ((b[p] == EMPTY) && ismov1(b,c,p))

struct	mt	{
		position p;
		int	c;
		int	s;
		};

# define NORTH (-10)
# define EAST 1
# define SOUTH 10
# define WEST (-1)
# define NORTHEAST (-9)
# define NORTHWEST (-11)
# define SOUTHEAST 11
# define SOUTHWEST 9

# define CORNERVALUE 7
# define EDGEVALUE 6
# define HEDGEVALUE 5
# define INTERIORVALUE 4

# define CORNERSCORE 30
# define EDGESCORE 15
# define POINTSCORE 4
# define INTERIORSCORE 3
# define DANGERSCORE 2

# define MIDDLEMOVE 27
# define ENDGAMEMOVE 27

# define sqscore(p) (endgame ? 1 : ssqval[p])

# define valid(p) (sqval[p]>0)
# define edge(p) (ssqval[p]>=EDGESCORE)
# define corner(p) (sqval[p]>=CORNERVALUE)
# define horizedge(p) ((p)<19||(p)>80)
# define adjedge(p) (sqval[p]==2)
# define adjdiag(p) (sqval[p]==1)
# define adjcorner(p) (sqval[p]<=2)

# define forallpos(p) for(p=11;p<89;++p) if(valid(p))
# define nextpos(p,d) (p=+(d))
# define abs(a) ((a)<0?-(a):(a))
# define oppdir(d) (-(d))
# define posx(p) (((p)/10)-1)
# define posy(p) (((p)%10)-1)
# define pos(x,y) ((x)*10+(y)+11)

# ifndef unix
# define FILE int
# define NULL 0
# define EOF -1
# define BUFSIZ 512
extern int stdin, stdout;
# define fopen flopen
# define time nowtime
# endif

# ifndef unix
# define cpybrd(a,b) (blt((b),(a),100))
# endif
