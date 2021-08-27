int slevel[10];
int clevel 0;
int spflg[20][10];
int sind[20][10];
int siflev[10];
int sifflg[10];
int iflev 0;
int ifflg -1;
int level 0;
int ind[10] {0,0,0,0,0,0,0,0,0,0};
int eflg 0;
int paren 0;
int pflg[10] {0,0,0,0,0,0,0,0,0,0};
char lchar;
char pchar;
int ct;
int stabs[20][10];
int qflg 0;
char *wif[]{"if",0};
char *welse[]{"else",0};
char *wfor[]{"for",0};
char *wds[]{"case","default",0};
int j 0;
char string[200];
char cc;
int sflg 1;	/* in function: indent output */
int aflg 0;	/* also output extra 1/2 tab */
int bflg 0;
int peek -1;
int tabs 0;
char lastchar;
char c;

main(argc,argv) int argc;
char *argv[];
{
	while((c = agetc()) != '\0'){
		switch(c){
		case ' ':
		case '\t':
			if(lookup(welse) == 1){
				gotelse();
				if(sflg == 0 || j > 0)string[j++] = c;
				cputs();
				sflg = 0;
				continue;
			}
			if(sflg == 0 || j > 0)string[j++] = c;
			continue;
		case '\n':
			if(eflg = lookup(welse) == 1)gotelse();
			cputs();
			cprint("\n");
			sflg = 1;
			if(eflg == 1){
				pflg[level]++;
				tabs++;
			}
			else
				if(pchar == lchar)
					aflg = 1;
			continue;
		case '{':
			if(lookup(welse) == 1)gotelse();
			siflev[clevel] = iflev;
			sifflg[clevel] = ifflg;
			iflev = ifflg = 0;
			clevel++;
			if(sflg == 1 && pflg[level] != 0){
				pflg[level]--;
				tabs--;
			}
			if (j > 0)
				{cputs();
				cprint("\n");
				}
			else cputs();
			tabs++;
			string[j++] = c;
			getnl();
			sflg = 1;
			if(pflg[level] > 0){
				ind[level] = 1;
				level++;
				slevel[level] = clevel;
			}
			continue;
		case '}':
			clevel--;
			if((iflev = siflev[clevel]-1) < 0)iflev = 0;
			ifflg = sifflg[clevel];
			cputs();
			ptabs();
			tabs--;
			if((peek = agetc()) == ';'){
				cprint("%c;",c);
				peek = -1;
			}
			else cprint("%c",c);
			getnl();
			cputs();
			cprint("\n");
			sflg = 1;
			if(clevel < slevel[level])if(level > 0)level--;
			if(ind[level] != 0){
				tabs =- pflg[level];
				pflg[level] = 0;
				ind[level] = 0;
			}
			continue;
		case '"':
		case '\'':
			string[j++] = c;
			while((cc = agetc()) != c){
				string[j++] = cc;
				if(cc == '\\'){
					string[j++] = agetc();
				}
				if(cc == '\n'){
					cputs();
					sflg = 1;
				}
			}
			string[j++] = cc;
			if(getnl() == 1){
				lchar = cc;
				peek = '\n';
			}
			continue;
		case ';':
			string[j++] = c;
			cputs();
			if(pflg[level] > 0 && ind[level] == 0){
				tabs =- pflg[level];
				pflg[level] = 0;
			}
			getnl();
			cputs();
			cprint("\n");
			sflg = 1;
			if(iflev > 0)
				if(ifflg == 1){iflev--;
					ifflg = 0;
				}
				else iflev = 0;
			continue;
		case '\\':
			string[j++] = c;
			string[j++] = agetc();
			continue;
		case '?':
			qflg = 1;
			string[j++] = c;
			continue;
		case ':':
			string[j++] = c;
			if(qflg == 1){
				qflg = 0;
				continue;
			}
			if(lookup(wds) == 0){
				sflg = 0;
				cputs();
			}
			else{
				tabs--;
				cputs();
				tabs++;
			}
			if((peek = agetc()) == ';'){
				cprint(";");
				peek = -1;
			}
			getnl();
			cputs();
			cprint("\n");
			sflg = 1;
			continue;
		case '/':
			string[j++] = c;
			if((peek = agetc()) != '*')continue;
			string[j++] = peek;
			peek = -1;
			comment();
			continue;
		case ')':
			paren--;
			string[j++] = c;
			cputs();
			if(getnl() == 1){
				peek = '\n';
				if(paren != 0)aflg = 1;
				else if(tabs > 0){
					pflg[level]++;
					tabs++;
					ind[level] = 0;
				}
			}
			continue;
		case '#':
			string[j++] = c;
			while((cc = agetc()) != '\n')string[j++] = cc;
			string[j++] = cc;
			sflg = 0;
			cputs();
			sflg = 1;
			continue;
		case '(':
			string[j++] = c;
			paren++;
			if(lookup(wfor) == 1){
				while((c = cgets()) != ';');
				ct=0;
cont:
				while((c = cgets()) != ')'){
					if(c == '(') ct++;
				}
				if(ct != 0){
					ct--;
					goto cont;
				}
				paren--;
				cputs();
				if(getnl() == 1){
					peek = '\n';
					pflg[level]++;
					tabs++;
					ind[level] = 0;
				}
				continue;
			}
			if(lookup(wif) == 1){
				cputs();
				stabs[clevel][iflev] = tabs;
				spflg[clevel][iflev] = pflg[level];
				sind[clevel][iflev] = ind[level];
				iflev++;
				ifflg = 1;
			}
			continue;
		default:
			string[j++] = c;
			if(c != ',')lchar = c;
		}
	}
}
ptabs(){
	int i;
	for(i=0; i < tabs; i++)cprint("\t");
}
agetc(){
	if(peek < 0 && lastchar != ' ' && lastchar != '\t')pchar = lastchar;
	lastchar = (peek<0) ? getchar():peek;
	peek = -1;
	return(lastchar);
}
cputs(){
	if(j > 0){
		if(sflg != 0){
			ptabs();
			sflg = 0;
			if(aflg == 1){
				aflg = 0;
				if(tabs > 0)cprint("    ");
			}
		}
		string[j] = '\0';
		cprint("%s",string);
		j = 0;
	}
	else{
		if(sflg != 0){
			sflg = 0;
			aflg = 0;
		}
	}
}
lookup(tab)
char *tab[];
{
	char r;
	int l,kk,k,i;
	if(j < 1)return(0);
	kk=0;
	while(string[kk] == ' ')kk++;
	for(i=0; tab[i] != 0; i++){
		l=0;
		for(k=kk;(r = tab[i][l++]) == string[k] && r != '\0';k++);
		if(r == '\0' && (string[k] < 'a' || string[k] > 'z'))return(1);
	}
	return(0);
}
cgets(){
	char ch;
beg:
	if((ch = string[j++] = agetc()) == '\\'){
		string[j++] = agetc();
		goto beg;
	}
	if(ch == '\'' || ch == '"'){
		while((cc = string[j++] = agetc()) != ch)if(cc == '\\')string[j++] = agetc();
		goto beg;
	}
	if(ch == '\n'){
		cputs();
		aflg = 1;
		goto beg;
	}
	else return(ch);
}
gotelse(){
	tabs = stabs[clevel][iflev];
	pflg[level] = spflg[clevel][iflev];
	ind[level] = sind[clevel][iflev];
	ifflg = 1;
}
getnl(){
	while((peek = agetc()) == '\t' || peek == ' '){
		string[j++] = peek;
		peek = -1;
	}
	if((peek = agetc()) == '/'){
		peek = -1;
		if((peek = agetc()) == '*'){
			string[j++] = '/';
			string[j++] = '*';
			peek = -1;
			comment();
		}
		else string[j++] = '/';
	}
	if((peek = agetc()) == '\n'){
		peek = -1;
		return(1);
	}
	return(0);
}
comment(){
rep:
	while((c = string[j++] = agetc()) != '*')
		if(c == '\n'){
			cputs();
			sflg = 1;
		}
gotstar:
	if((c = string[j++] = agetc()) != '/'){
		if(c == '*')goto gotstar;
		goto rep;
	}
}
