log_progress "ENTERING BUILD SCRIPT: LISP"


# lisp
respond "*" ":link l;fasdfs 1,lisp;.fasl defs\r"
respond "*" ":link lisp;grind fasl,lisp;gfile fasl\r"
respond "*" ":link lisp;grinde fasl,lisp;gfn fasl\r"
respond "*" ":link l;loop fasl,liblsp;loop fasl\r"
respond "*" ":link lisp;loop fasl,liblsp;loop fasl\r"

midas ".temp.;" "l;*lisp" {
    respond "end input with ^C" "\003"
}
respond "*" ":job lisp\r"
respond "*" ":load .temp.;*lisp bin\r"
respond "*" "\033g"
respond "*" "purify\033g"
respond "*" ":pdump sys;purqio 2156\r"
respond "*" ":kill\r"

respond "*" ":link sys;ts lisp,sys:purqio >\r"
respond "*" ":link sys;ts q,sys;purqio >\r"
respond "*" ":link sys;atsign lisp,sys;purqio >\r"
respond "*" ":link sys;ts l,sys;ts lisp\r"

respond "*" ":link .info.;lisp step,.info.;step info\r"
respond "*" ":link libdoc;struct 280,alan;struct >\r"
respond "*" ":link libdoc;struct doc,alan;struct doc\r"
respond "*" ":link .info.;lisp struct,libdoc;struct doc\r"
respond "*" ":link l;-read- -this-,lisp;-read- -this-\r"

# lisp compiler
respond "*" ":link comlap;cdmacs fasl,cd.fas >\r"
respond "*" ":link comlap;complr fasl,comlap;cl.fas >\r"
respond "*" ":link comlap;phas1 fasl,comlap;ph.fas >\r"
respond "*" ":link comlap;comaux fasl,comlap;cx.fas >\r"
respond "*" ":link comlap;faslap fasl,comlap;fl.fas >\r"
respond "*" ":link comlap;maklap fasl,comlap;mk.fas >\r"
respond "*" ":link comlap;initia fasl,comlap;in.fas >\r"
respond "*" ":link comlap;srctrn fasl,comlap;st.fas >\r"
mkdir "lspdmp"
respond "*" "lisp\013"
respond "Alloc?" "n\r"
respond "*" "(load \"comlap;ccload\")"
respond ";BKPT CCLOAD:DUMPVERNO" "(setq ccload:dumpverno 1998)"
respond "1998" "(return)"
respond "*" ":kill\r"
respond "*" ":link sys;ts complr,lspdmp;cl.dmp >\r"
respond "*" ":link sys;ts cl,sys;ts complr\r"
respond "*" ":link info;complr 1,info;lispc >\r"

# lisp;* fasl that that have autoload properties in interpreter
respond "*" ":link sys;.fasl defs,lisp;.fasl defs\r"
respond "*" ":link sys;fasdfs 1,lisp;.fasl defs\r"
midas "lisp;" "l;allfil"
midas "lisp;" "l;bltarr"
midas "lisp;" "lspsrc;edit"
midas "lisp;" "l;getmid"
midas "lisp;" "l;humble"
midas "lisp;" "lspsrc;sort"

respond "*" ":link lisp;subloa lsp,nilcom;subloa >\r"

complr {"liblsp;_libdoc;loop"}

complr {"lisp;_lspsrc;umlmac" "lisp;_nilcom;sharpa"
        "lisp;_nilcom;sharpc" "lisp;_nilcom;defvst"}

complr {"lisp;_nilcom;errck"}
complr {"lisp;_nilcom;backq"}
complr {"lisp;_lspsrc;bits" "lisp;_lspsrc;cerror" "lisp;_nilcom;defmac"}
complr {"lisp;_nilcom;defmax"}
complr {"lisp;_nilcom;defvsx"}
complr {"lisp;_nilcom;defvsy" "lisp;_lspsrc;descri" "lisp;_lspsrc;dumpar"}

complr {"lisp;_lspsrc;extmac" "lisp;_lspsrc;extbas" "lisp;_lspsrc;extsfa"
        "lisp;_nilcom;evonce" "lisp;_lspsrc;extend" "lisp;_lspsrc;grind"
        "lisp;_lspsrc;grinde" "lisp;_lspsrc;lap" "lisp;_comlap;ledit"
        "lisp;_nilcom;let"}

respond "*" ":link l;humble fasl,lisp;\r"
respond "*" ":link l;ledit* fasl,lisp;\r"
respond "*" ":link l;let fasl,lisp;\r"

complr {"lisp;_nilcom;macaid"}
complr {"lisp;_lspsrc;mlmac" "lisp;_lspsrc;mlsub"}

complr_action {respond "*" "(remprop 'eval-ordered* '*lexpr)"
               expect "(T AUTOLOAD ((LISP) EVONCE FASL))"} \
    {"lisp;_nilcom;setf"}

complr {"lisp;_nilcom;sharpm"}
complr {"lisp;_nilcom;string"}
complr {"lisp;_nilcom;subseq" "lisp;_lspsrc;trace"}
complr {"lisp;_nilcom;yesnop"}
complr {"liblsp;_libdoc;lspmac" "liblsp;_libdoc;lusets"}

complr_load {"((lisp) extend)"} {"lisp;_lspsrc;extstr"}

# inquir
midas "inquir;" "lsrrtn"
midas "inquir;" "cstacy;netrtn"

respond "*" ":link liblsp;debug fasl,liblsp;dbg fasl\r"
respond "*" ":link lisp;debug fasl,liblsp;debug fasl\r"

complr {"liblsp;_libdoc;tty" "inquir;reader" "inquir;fake-s"
        "rwk;debmac" "liblsp;_libdoc;lispm" "inquir;inquir"}

midas "inquir;ts inqexm" "inqexm"
midas "inquir;ts inqrep" "inqrep"
respond "*" ":link inquir;ts inqchk,ts inquir\r"

complr {"liblsp;_libdoc;dbg ejs2" "liblsp;_libdoc;comrd kmp1"}

respond "*" ":lisp inquir;inquir (dump)\r"
respond "*" ":link inquir;ts inquir,inquir;inqbin >\r"
respond "*" ":link sys;ts inquir,inquir;ts inquir\r"

respond "*" ":link inquir;ts inqcpy,inqupd bin\r"
respond "*" ":link inquir;ts inqpat,inqupd bin\r"
respond "*" ":link inquir;ts lsrini,inqupd bin\r"

# od
complr {"liblsp;_libdoc; od"}
respond "*" ":lisp libdoc;od (dump)\r"
expect ":KILL"

# comred
complr {"liblsp;_libdoc; comred"}

respond "*" ":link inquir;lsrtns 1,syseng;lsrtns >\r"

midas "inquir;ts lookup" "inquir;lookup"
respond "*" ":link sys1;ts lookup,inquir;ts lookup\r"

midas "sys3;ts lsrprt" "sysen1; lsrprt"

midas "sys3;ts lsrdmp" "bawden; lsrdmp"

# more lisp packages
respond "*" ":link lisp;tty fasl,liblsp;tty fasl\r"
complr_load {"((lisp) subloa lsp)"} \
    {"lisp;_lspsrc;funcel" "lisp;_lspsrc;reap"
     "lisp;_lspsrc;lexprf" "lisp;_lspsrc;ldbhlp"}

respond "*" "complr\013"
respond "_" "lisp;_nilcom;lsets\r"
respond "_" "lisp;_nilcom;drammp\r"
respond "(Y or N)" "Y"
respond "_" "\032"
type ":kill\r"

complr_load {"((lisp) subloa lsp)"} {"lisp;_lspsrc;nilaid"}

complr {"liblsp;_libdoc;sharab" "liblsp;_libdoc;bs"}

respond "*" ":link lisp;sharab fasl,liblsp;\r"
respond "*" ":link lisp;bs fasl,liblsp;\r"

complr_load {"((lisp) subloa lsp)"} {"lisp;_nilcom;thread"}

midas "lisp;" "l;lchnsp"
midas "lisp;" "l;purep"

# struct

respond "*" ":link alan;dprint fasl,liblsp;dprint fasl\r"
respond "*" ":link alan;struct 9,alan;nstruc 280\r"
respond "*" ":copy liblsp;struct fasl,alan;struct boot\r"
respond "*" ":link alan;struct fasl,liblsp;struct fasl\r"

complr {"alan;lspcom" "alan;lspenv" "alan;lspint" "alan;setf"
        "alan;binda" "alan;crawl" "alan;nstruc 280"}
respond "*" ":copy alan;nstruc fasl,liblsp;struct fasl\r"
respond "*" ":link lisp;struct fasl,liblsp;struct fasl\r"

midas "liblsp;" "alan;macits"

complr {"liblsp;_alan;dprint"}

#complr {"alan;ljob" "liblsp;_libdoc;gprint rcw3" "alan;lspgub"}

# compile lisp compiler
complr {"comlap;cd.fas 40_cdmacs" "comlap;cx.fas 25_comaux"
        "comlap;cl.fas 936_complr" "comlap;fl.fas 392_faslap"
        "comlap;in.fas 120_initia" "comlap;mk.fas 80_maklap"
        "comlap;ph.fas 86_phas1" "comlap;st.fas 20_srctrn"}

# and redump compiler
respond "*" "comlap\033\033\023"
respond "*" ":lisp ccload\r"
expect "Dumping LSPDMP"
sleep 1
type ":vk\r"
respond "*" ":kill\r"

# Additional LSPLIB packages
complr {"liblsp;_libdoc;iota" "liblsp;_libdoc;time" "liblsp;_libdoc;letfex"
        "liblsp;_libdoc;break" "liblsp;_libdoc;smurf" "liblsp;_rlb%;fasdmp"
        "liblsp;_libdoc;lispt"}

respond "*" ":link liblsp;gcdemn fasl,lisp;\r"

### more lisplib stuff
complr {"liblsp;_libdoc;%print" "liblsp;_libdoc;6bit" "liblsp;_libdoc;apropo"
        "liblsp;_libdoc;arith" "liblsp;_libdoc;aryfil" "liblsp;_libdoc;atan"
        "liblsp;_libdoc;autodf" "liblsp;_libdoc;bboole"}

complr {"liblsp;_libdoc;bench" "liblsp;_libdoc;binprt" "liblsp;_lmlib;gprint"
        "liblsp;_libdoc;carcdr" "liblsp;_libdoc;char" "liblsp;_libdoc;debug*"
        "liblsp;_libdoc;defsta" "liblsp;_libdoc;doctor"}

complr {"liblsp;_libdoc;dow" "liblsp;_libdoc;dribbl" "liblsp;_libdoc;dumpgc"
        "liblsp;_libdoc;fake-s" "liblsp;_libdoc;fforma" "liblsp;_libdoc;filbit"
        "liblsp;_libdoc;fload" "liblsp;_libdoc;fontrd"}

complr {"liblsp;_libdoc;for" "lisp;_lspsrc;gcdemn" "liblsp;_libdoc;genfns"
        "liblsp;_libdoc;graphs" "liblsp;_libdoc;graphm" "liblsp;_libdoc;graph$"
        "liblsp;_libdoc;grapha" "liblsp;_libdoc;grapht" "liblsp;_libdoc;impdef"
        "liblsp;_libdoc;laugh" "liblsp;_libdoc;lets" "liblsp;_libdoc;linere"}

respond "*" ":delete libdoc;gcdemn 999999\r"
respond "*" ":link libdoc;gcdemn 999999,lspsrc;gcdemn >\r"

complr {"liblsp;_libdoc;loop" "liblsp;_libdoc;more" "liblsp;_libdoc;nshare"
        "liblsp;_libdoc;octal" "liblsp;_libdoc;optdef" "liblsp;_libdoc;phsprt"
        "liblsp;_libdoc;privob" "liblsp;_libdoc;prompt" "liblsp;_libdoc;qtrace"}

complr {"liblsp;_libdoc;reads" "liblsp;_libdoc;redo"
       "liblsp;_libdoc;save" "liblsp;_libdoc;sets"}

complr {"liblsp;_libdoc;share" "liblsp;_libdoc;sixbit" "liblsp;_libdoc;split"
        "liblsp;_libdoc;stack" "liblsp;_libdoc;statty" "liblsp;_libdoc;stepmm"
        "liblsp;_libdoc;stepr" "liblsp;_libdoc;string" "liblsp;_libdoc;sun"
        "liblsp;_libdoc;trap" "liblsp;_libdoc;ttyhak" "liblsp;_libdoc;wifs"
        "liblsp;_libdoc;window"}

respond "*" ":link liblsp;defvst fasl,lisp;\r"
respond "*" ":link liblsp;format fasl,liblsp;fforma fasl\r"
respond "*" ":link libdoc;lispt info,info;lispt >\r"
respond "*" ":link liblsp;sharpm fasl,lisp;\r"
respond "*" ":copy nilcom;sharpm >,libdoc;sharpm nil\r"
respond "*" ":link libdoc;step info,.info.;\r"
respond "*" ":link libdoc;stepmm info,.info.;lisp stepmm\r"
respond "*" ":copy nilcom;string >,libdoc;string nil\r"

# can't build any more LIBLSP FASLs because directory is full
# cleanup unfasl files in lisp;
respond "*" ":dired liblsp;\r"
respond "@" "delete * unfasl\r"
respond "Delete? (Y or N):" "y"
respond "@" "q\r"
expect ":KILL"

complr_load {"((libdoc) set ira10)"} \
    {"liblsp;_libdoc;askusr" "liblsp;_pratt;cgrub"}

# compile cgol
complr {"lisp;_pratt;cgol"}

complr_load {"((lisp) cgol fasl)"} {"liblsp;_pratt;cgprin"}

# clean up remaining unfasl files in liblsp
respond "*" ":dired liblsp;\r"
respond "@" "delete * unfasl\r"
respond "Delete? (Y or N):" "y"
respond "@" "q\r"
expect ":KILL"

complr_action {respond "*" "(sstatus features Compile-Subload)"
               expect "COMPILE-SUBLOAD"} \
       {"lisp;_nilcom;subloa"}

midas "liblsp;" "libdoc;bssq"
midas "liblsp;" "libdoc;aryadr"
midas "liblsp;" "libdoc;link"
midas "liblsp;" "libdoc;lscall"
midas "liblsp;" "libdoc;cpyhnk"

respond "*" ":link lisp;defns mid,l;defns >\r"
midas "liblsp;" "libdoc;fft"
midas "liblsp;" "libdoc;phase"

# More LIBLSP packages
complr {"liblsp;_libdoc;didl" "liblsp;_libdoc;getsyn" "liblsp;_libdoc;iter"
        "liblsp;_libdoc;hash" "liblsp;_libdoc;graph3" "liblsp;_libdoc;ledit*"}

complr {"liblsp;_libdoc;stacks"}

midas "liblsp;" "libdoc;dirsiz"
midas "liblsp;" "z;timer"

respond "*" ":link lisp;vsaid lisp,nilcom;vsaid >\r"
complr {"lisp;_nilcom;vsaid"}
respond "*" ":link liblsp;vsaid fasl,lisp;\r"

# cleanup unfasl files in lisp;
respond "*" ":dired lisp;\r"
respond "@" "delete * unfasl\r"
respond "Delete? (Y or N):" "y"
respond "@" "q\r"
expect ":KILL"

midas "liblsp;" "gsb;ttyvar" {
    respond "Use what filename instead?" "lisp;\r"
}

midas "liblsp;" "libdoc;aryadr"
midas "liblsp;" "libdoc;bssq"

complr {"liblsp;_libdoc;lddt"}
complr {"liblsp;_libdoc;ndone"}

respond "*" ":link graphs;graph3 fasl,liblsp\r"
respond "*" ":link graphs;plot3 fasl,liblsp\r"
respond "*" ":link graphs;plot fasl,liblsp\r"
complr {"liblsp;_libdoc;plot" "liblsp;_libdoc;plot3"}

complr {"liblsp;_libdoc;prime"}
complr {"liblsp;_libdoc;step"}
complr {"liblsp;_libdoc;utils"}

# cleanup unfasl files in liblsp;
respond "*" ":dired liblsp;\r"
respond "@" "delete * unfasl\r"
respond "Delete? (Y or N):" "y"
respond "@" "q\r"
expect ":KILL"

# DEFSET
complr {"lisp;_nilcom;defset"}

# compile some lisp; libraries
complr {"lisp;_nilcom;cnvd" "lisp;_lspsrc;exthuk"
        "lisp;_lspsrc;gfile" "lisp;_lspsrc;gfn"}

complr {"lisp;_lspsrc;querio" "lisp;_lspsrc;vector"}

midas "lisp;" "lspsrc;sendi"
midas "lisp;" "lspsrc;straux"

# lispt source is in libdoc, therefore fasl should be in liblsp
# version in lisp; should be a link to liblsp;lispf fasl
respond "*" ":delete lisp;lispt fasl\r"
respond "*" ":link lisp;lispt fasl,liblsp;\r"
respond "*" ":link sys2;ts lispt,sys2;ts edit\r"

# Lisp display library
midas "lisp; slave fasl" "l; slave"

# Lisp display slave, PDP-10 and GT40 version.
midas "sys; atsign 10slav" "sysen2; ld10" {
    respond "   PDP6F = " "0\r"
    respond "GT40F=" "1\r"
}

# animal
complr {"games;_games;parse" "games;_games;pattrn"
        "games;_games;words" "games;_games;word"}

complr {"games;_games;animal 133"}

respond "*" "l\013"
respond "Alloc?" "n"
respond "*" "(load '((games) animal fasl))"
respond_load "(dump '((games) ts animal))"
expect "KILL"

# think
complr {"games;_games;think"}

# wa
complr {"games;_games;wa 10"}

# chase
complr {"games;_chase"}

# yahtze
complr {"sca;macros" "sca;modeb"}

# note sca;mode > will not compile. Yahtze will load it interpreted

complr {"games;yahtze"}

# ITSter
complr {"games;_hibou;itster"}

# Knight TV Spacewar
respond "*" ":lisp gjd; sine lisp\r"
expect ":KILL"

# Kermit
respond "*" ":link math;defset fasl,lisp;\r"
complr {"math;common" "math;kermit"}
respond "*" ":lisp math; kermit dumper\r"
respond "to dump.|" "(kermit-dump)"
expect ":KILL"
respond "*" ":link sys3;ts kermit,math;\r"

# SUPDUP ARDS
complr {"dcp;sgincl" "dcp;supard"}
respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" {(load "dcp;supard")}
respond "system program" "(bootstrap)"

# ARDS to SVG converter
complr {"victor; ards"}

# Forth
complr {"kle;forth"}

# ULisp
complr {"teach; ulisp"}
respond "*" ":lisp\r"
respond "Alloc?" "n\r"
respond "*" "(load '((teach) ulisp))"
expect -re {\n[1-7]}
respond "\n" {(dump "teach; ts ulisp")}
respond ":" "t\r"
respond ":" "emacs\r"
respond ":" "edit\r"
respond ":" "script\r"
respond ":" "nil\r"
respond ":" "nil\r"
respond ":" "t\r"
respond ":" "t\r"
respond "\n" ":vk\r"
respond "*" ":kill\r"

# AS8748
complr {"lmio1;as8748"}
complr {"moon;8478sa"}

respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" "(load '((lmio1) as8748))"
respond_load "(load '((lmio1) ukbd))"
respond "T" "(as 'ukbd)"
respond "UKBD" "(quit)"
expect ":KILL"

# Lisp Logo
cwd "llogo"
complr {"germ" "ioc"}
complr_load {"ioc" "define"} {"define"}
complr_load {"ioc" "define"} \
    {"error" "parser" "primit" "print" "reader" "setup" "unedit" "music"
     "turtle" "tvrtle"}
respond "*" ":lisp loader\r"
respond "?" "Y\r"
respond "?" "LLOGO\r"
respond "?" "1700\r"
expect ":KILL"
respond "*" ":link sys1; ts llogo, llogo; ts llogo\r"

# 2500 assembler
complr_load {"ioc"} {"2500;zap"}

# 2500 microcode
cwd "minsky"
respond "*" "lisp\013"
respond "Alloc?" "n\r"
respond "*" "(setq gc-overflow '(lambda (x) t))"
respond "T)" "(setsyntax '/, 'a '/,)"
respond "T" "(load \"minsky;tvdis\")"
respond "T" "(load \"2500;zap\")"
respond_load "(array im fixnum 4096)"
respond "IM" "(zap tvdis)"
respond "FINISH)" "(quit)"
expect ":KILL"

# TEACH;TS XLISP

complr {"teach;macro"}

complr {"teach;apropos" "teach;compla" "teach;databa" "teach;errhan"
        "teach;errhel" "teach;exlist" "teach;io" "teach;lessn"
        "teach;more" "teach;record" "teach;teach" "teach;treepr"}

respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" "(load '((teach) start))"
respond "T" "(load '((teach) teach dump))"
expect ":KILL"

respond "*" ":rename teach;ts xlisp,ts lisp\r"

# Munching squares for display terminals.
complr {"lars; munch lisp"}

# CUBE, Rubik's cube by Bernard Greenberg.
complr {"bsg;cube" "bsg;cutils" "bsg;csolve" "bsg;cinput" "bsg;cxfrm"}
respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" {(load "bsg;cdriv")}
respond "T" "(make-cube)"
respond "*" ":pdump sys3;ts cube\r"
respond "*" ":kill\r"

# LMODEM
complr {"eb;sfadcl" "eb;errmac" "eb;signal" "eb;dsk8" "eb;lmodem"}
respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" {(load "eb;lmodem")}
expect -re {[\r\n][\r\n][1-7][0-7][0-7]}
type "(dump-lmodem-program)"
respond "Filename in which to dump:" "eb; ts lmodem\r"
expect -re {[\r\n][\r\n]T ?[\r\n][\r\n]}
type "(quit)"
expect ":KILL"
# Make a link for the CP/M archive users.
respond "*" ":link cpm; ts lmodem, eb;\r"
