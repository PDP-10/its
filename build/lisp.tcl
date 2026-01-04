log_progress "ENTERING BUILD SCRIPT: LISP"


# lisp
make_link "l;fasdfs 1" "lisp;.fasl defs"
make_link "lisp;grind fasl" "lisp;gfile fasl"
make_link "lisp;grinde fasl" "lisp;gfn fasl"
make_link "l;loop fasl" "liblsp;loop fasl"
make_link "lisp;loop fasl" "liblsp;loop fasl"

midas ".temp.;" "l;*lisp" {
    respond "end input with ^C" "\003"
}
respond "*" ":job lisp\r"
respond "*" ":load .temp.;*lisp bin\r"
respond "*" "\033g"
respond "*" "purify\033g"
respond "*" ":pdump sys;purqio 2156\r"
respond "*" ":kill\r"

make_link "sys;ts lisp" "sys:purqio >"
make_link "sys;ts q" "sys;purqio >"
make_link "sys;atsign lisp" "sys;purqio >"
make_link "sys;ts l" "sys;ts lisp"

make_link ".info.;lisp step" ".info.;step info"
make_link "libdoc;struct 280" "alan;struct >"
make_link "libdoc;struct doc" "alan;struct doc"
make_link ".info.;lisp struct" "libdoc;struct doc"
make_link "l;-read- -this-" "lisp;-read- -this-"

# lisp compiler
make_link "comlap;cdmacs fasl" "cd.fas >"
make_link "comlap;complr fasl" "comlap;cl.fas >"
make_link "comlap;phas1 fasl" "comlap;ph.fas >"
make_link "comlap;comaux fasl" "comlap;cx.fas >"
make_link "comlap;faslap fasl" "comlap;fl.fas >"
make_link "comlap;maklap fasl" "comlap;mk.fas >"
make_link "comlap;initia fasl" "comlap;in.fas >"
make_link "comlap;srctrn fasl" "comlap;st.fas >"
mkdir "lspdmp"
respond "*" "lisp\013"
respond "Alloc?" "n\r"
respond "*" "(load \"comlap;ccload\")"
respond ";BKPT CCLOAD:DUMPVERNO" "(setq ccload:dumpverno 1998)"
respond "1998" "(return)"
respond "*" ":kill\r"
make_link "sys;ts complr" "lspdmp;cl.dmp >"
make_link "sys;ts cl" "sys;ts complr"
make_link "info;complr 1" "info;lispc >"

# lisp;* fasl that that have autoload properties in interpreter
make_link "sys;.fasl defs" "lisp;.fasl defs"
make_link "sys;fasdfs 1" "lisp;.fasl defs"
midas "lisp;" "l;allfil"
midas "lisp;" "l;bltarr"
midas "lisp;" "lspsrc;edit"
midas "lisp;" "l;getmid"
midas "lisp;" "l;humble"
midas "lisp;" "lspsrc;sort"

make_link "lisp;subloa lsp" "nilcom;subloa >"

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

make_link "l;humble fasl" "lisp;"
make_link "l;ledit* fasl" "lisp;"
make_link "l;let fasl" "lisp;"

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

make_link "liblsp;debug fasl" "liblsp;dbg fasl"
make_link "lisp;debug fasl" "liblsp;debug fasl"

complr {"liblsp;_libdoc;tty" "inquir;reader" "inquir;fake-s"
        "rwk;debmac" "liblsp;_libdoc;lispm" "inquir;inquir"}

midas "inquir;ts inqexm" "inqexm"
midas "inquir;ts inqrep" "inqrep"
make_link "inquir;ts inqchk" "ts inquir"

complr {"liblsp;_libdoc;dbg ejs2" "liblsp;_libdoc;comrd kmp1"}

respond "*" ":lisp inquir;inquir (dump)\r"
make_link "inquir;ts inquir" "inquir;inqbin >"
make_link "sys;ts inquir" "inquir;ts inquir"

make_link "inquir;ts inqcpy" "inqupd bin"
make_link "inquir;ts inqpat" "inqupd bin"
make_link "inquir;ts lsrini" "inqupd bin"

# od
complr {"liblsp;_libdoc; od"}
respond "*" ":lisp libdoc;od (dump)\r"
expect ":KILL"

# comred
complr {"liblsp;_libdoc; comred"}

make_link "inquir;lsrtns 1" "syseng;lsrtns >"

midas "inquir;ts lookup" "inquir;lookup"
make_link "sys1;ts lookup" "inquir;ts lookup"

midas "sys3;ts lsrprt" "sysen1; lsrprt"

midas "sys3;ts lsrdmp" "bawden; lsrdmp"

# more lisp packages
make_link "lisp;tty fasl" "liblsp;tty fasl"
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

make_link "lisp;sharab fasl" "liblsp;"
make_link "lisp;bs fasl" "liblsp;"

complr_load {"((lisp) subloa lsp)"} {"lisp;_nilcom;thread"}

midas "lisp;" "l;lchnsp"
midas "lisp;" "l;purep"

# struct

make_link "alan;dprint fasl" "liblsp;dprint fasl"
make_link "alan;struct 9" "alan;nstruc 280"
respond "*" ":copy liblsp;struct fasl,alan;struct boot\r"
make_link "alan;struct fasl" "liblsp;struct fasl"

complr {"alan;lspcom" "alan;lspenv" "alan;lspint" "alan;setf"
        "alan;binda" "alan;crawl" "alan;nstruc 280"}
respond "*" ":copy alan;nstruc fasl,liblsp;struct fasl\r"
make_link "lisp;struct fasl" "liblsp;struct fasl"

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

make_link "liblsp;gcdemn fasl" "lisp;"

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
make_link "libdoc;gcdemn 999999" "lspsrc;gcdemn >"

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

make_link "liblsp;defvst fasl" "lisp;"
make_link "liblsp;format fasl" "liblsp;fforma fasl"
make_link "libdoc;lispt info" "info;lispt >"
make_link "liblsp;sharpm fasl" "lisp;"
respond "*" ":copy nilcom;sharpm >,libdoc;sharpm nil\r"
make_link "libdoc;step info" ".info.;"
make_link "libdoc;stepmm info" ".info.;lisp stepmm"
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

make_link "lisp;defns mid" "l;defns >"
midas "liblsp;" "libdoc;fft"
midas "liblsp;" "libdoc;phase"

# More LIBLSP packages
complr {"liblsp;_libdoc;didl" "liblsp;_libdoc;getsyn" "liblsp;_libdoc;iter"
        "liblsp;_libdoc;hash" "liblsp;_libdoc;graph3" "liblsp;_libdoc;ledit*"}

complr {"liblsp;_libdoc;stacks"}

midas "liblsp;" "libdoc;dirsiz"
midas "liblsp;" "z;timer"

make_link "lisp;vsaid lisp" "nilcom;vsaid >"
complr {"lisp;_nilcom;vsaid"}
make_link "liblsp;vsaid fasl" "lisp;"

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

make_link "graphs;graph3 fasl" "liblsp"
make_link "graphs;plot3 fasl" "liblsp"
make_link "graphs;plot fasl" "liblsp"
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
make_link "lisp;lispt fasl" "liblsp;"
make_link "sys2;ts lispt" "sys2;ts edit"

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
make_link "math;defset fasl" "lisp;"
complr {"math;common" "math;kermit"}
respond "*" ":lisp math; kermit dumper\r"
respond "to dump.|" "(kermit-dump)"
expect ":KILL"
make_link "sys3;ts kermit" "math;"

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
make_link "sys1; ts llogo" " llogo; ts llogo"

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
make_link "cpm; ts lmodem" " eb;"
