log_progress "ENTERING BUILD SCRIPT: MACSYMA"

# libmax

# all libmax components (well almost all) require libmax;module fasl
# at compile time.  Build it first.

complr {"libmax;module"}

# libmax;maxmac can't be compiled unless libmax;mforma is (first) compiled.
# However, libmax;mforma uses libmax;macmac.  Hence you end up having to
# compile libmax;mforma first, then libmax;maxmac, and then compiling these
# both a second time.  Otherwise, there are not incorrectly generated FASL
# files for each, but anything that depends on these two packages will also
# have errors during compilation.

complr_load {"((libmax) module)"} {"libmax;mforma"}
complr_load {"((libmax) module)"} {"libmax;maxmac"}
complr_load {"((libmax) module)"} {"libmax;mforma"}
complr_load {"((libmax) module)"} {"libmax;maxmac"}

# the following are required to compile some of the libmax;
# FASL files
#
midas "rwk;lfsdef fasl" "rwk;lfsdef"
midas "rat;ratlap fasl" "rat;ratlap"
mkdir "maxdmp"
respond "*" ":link maxdmp;ratlap fasl,rat;ratlap fasl\r"
respond "*" ":link libmax;lusets fasl,liblsp;\r"

complr_load {"((libmax) module)"} \
    {"libmax;ermsgx" "libmax;ermsgc" "z;fildir" "libmax;lmmac"
     "libmax;meta" "libmax;lmrund" "libmax;lmrun" "libmax;displm"
     "libmax;defopt" "libmax;mopers" "libmax;mrgmac" "libmax;nummac"
     "libmax;opshin" "libmax;edmac_emaxim;" "libmax;procs" "libmax;readm"
     "libmax;strmac" "libmax;transm" "libmax;rzmac_rz;macros"
     "libmax;transq" "libmax;mdefun"}

# build MAXTUL FASL files

mkdir "maxerr"
mkdir "maxer1"

complr {"maxtul;strmrg" "maxtul;defile" "maxtul;docgen" "maxtul;query"
        "maxtul;maxtul" "maxtul;toolm" "maxtul;dclmak" "maxtul;mailer"
        "maxtul;mcl" "maxtul;timepn" "maxtul;expand" "maxtul;fsubr!"
        "maxtul;error!"}

complr {"maxtul;fasmap"}

# define needs (for some reason) to be compiled separately.
# not doing this results in errors compiling macsyma sources,
# such as ELL; HYP >
#
complr_load {"((libmax) module)"} {"libmax;define"}

# build macsyma

mkdir "macsym"

respond "*" ":link macsym;mdefun fasl,libmax;\r"

complr_load {"((libmax) module)"} \
    {"macsym;ermsgm_maxsrc;ermsgm" "maxdoc;tdcl" "rlb;bitmac"}

complr {"rlb;faslre" "rlb;faslro"}

respond "*" ":link rlb%;faslre fasl,rlb;\r"
respond "*" ":copy rlb;faslre fasl,liblsp;\r"
respond "*" "l\013"
respond "Alloc?" "n"
respond "*" "(setq pure t)"
type "(load \"liblsp;sharab\")"
type "(load \"liblsp;comrd\")"
type "(load \"liblsp;time\")"
type "(load \"alan;ljob\")"
type "(load \"libmax;define\")"
type "(sstatus gcmax 'fixnum 30000)"
type "(sstatus gcmax 'list 60000)"
type "(load \"maxtul;strmrg\")"
type "(load \"maxtul;docgen\")"
type "(load \"maxtul;query\")"
type "(load \"maxtul;maxtul\")"
type "(load \"maxtul;dclmak\")"
type "(sstatus gcmax 'hunk32 6000)"
respond "T" "(sstatus gcmax 'symbol 12000)"
respond "T" "(sstatus gcmax 'list 60000)"
respond "T" "(sstatus gcmax 'fixnum 20000)"
respond "T" "(dump-it)"
respond "MAXIMUM TOOLAGE>" "load-info\r"
respond "MAXIMUM TOOLAGE>" "gen-mcl-check\r"
respond "MAXIMUM TOOLAGE>" "declare-file-make\r"
respond "MAXIMUM TOOLAGE>" "quit\r"
respond "*" "(quit)"

complr_load {"((libmax) module)"} {"libmax;mhayat_rat;mhayat"}
complr_load {"((libmax) module)"} {"libmax;ratmac_rat;ratmac"}

# mforma needs to get recompiled (not sure exactly which
# dependency yet causes the version we've built so far
# not to work, but if recompiled at this point, we're
# able to build macsyma
complr_load {"((libmax) module)"} {"libmax;mforma"}

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(setq pure t)"
respond "T" "(load \"liblsp;sharab\")"
respond_load "(load \"maxtul;mcldmp (init)\")"
respond "T" "\007"
respond "*" "(dump-mcl 32. t)"
respond "File name->" "\002"
respond ";BKPT" "(quit)"

midas "maxtul;ts mcl" "mcldmp midas"
respond "*" ":link maxtul;.good. complr,maxtul;mcldmp 32\r"

# build UTMCL -- the compiler invoked by compile_lisp_file in Macsyma
complr {"maxtul;utmcl"}

# dump out UTMCL
respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load \"maxtul;utmcl fasl\")"
respond_load "\007"
respond "*" "(dump-utmcl)"
respond "_" "\032"
type ":kill\r"

complr {"mrg;macros"}

mkdir "maxout"
mkdir "share2"

# Here we actually perform the compilation of Macsyma sources
# For some unknown reason, compilation fails in the same place
# every time (as though COMPLR gets corrupted or its state is
# inconsistent with the ability to compile the next source).  
# A random error is raised and a break level entered.  Simply
# quitting and restarting the process causes it to pick up 
# where it left off and the previously failing source compiles
# fine. The only way I've been able to get past this is by 
# exiting COMPLR and restarting it.  The number of invocations,
# below, appears to get through the whole list of sources. The
# failures appear at the same places each time, so the number
# of COMPLR invocations needed to make it through all the 
# compilations appears to be constant.
# 
# We should investigate whether there is a better way to do this,
# but I (EJS) have not found one that works so far.
#
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion
build_macsyma_portion

respond "*" ":maxtul;maxtul\r"
respond "MAXIMUM TOOLAGE>" "load-info\r"
respond "MAXIMUM TOOLAGE>" "merge-incore-system\r"
respond "MAXIMUM TOOLAGE>" "gen-tags\r"
respond "MAXIMUM TOOLAGE>" "quit\r"
respond "*" "(quit)"

respond "*" ":move macsym;macsym ntags,macsym tags\r"

respond "*" "aljabr\033\023"
respond "*" ":lisp\r"
type "(load \"lisp;mlsub\")"
respond_load "(load \"libmax;module\")"
respond_load "(load \"libmax;define\")"
respond_load "(load \"libmax;maxmac\")"
respond_load "(load \"libmax;displm\")"
respond_load "(load \"aljabr;loader\")"
respond "T" "(loader 1001)"
respond "(C1)" "quit();"

respond "*" ":copy aljabr;user profil,macsym;\r"
respond "*" ":link macsym;check fasl,ellen;\r"
respond "*" ":link sys3;ts macsym,maxdmp;loser >\r"
respond "*" ":link sys;ts a,sys3; ts macsym\r"
respond "*" ":link demo;manual demo,demo;manual >\r"
respond "*" ":link manual;manual demo,demo;manual demo\r"

### build ctensr for macsyma
respond "*" "macsym\013"
respond "(C1)" "compile_lisp_file(translate_file(\"sharem\\;packg >\")\[2\]);"
respond "(C2)" "compile_lisp_file(translate_file(\"tensor\\;ctensr funcs\")\[2\]);"
respond "Type ALL;" "all;"
respond "Type ALL;" "all;"
respond "(C3)" "quit();"
respond "*" ":link share;ctensr fasl,tensor;\r"

### build eigen for macsyma
respond "*" "macsym\013"
respond "(C1)" "compile_lisp_file(translate_file(\"share\\;eigen >\")\[2\]);"
respond "Type ALL;" "all;"
respond "Type ALL;" "all;"
respond "(C2)" "quit();"

### build share;array fasl and ellen;check fasl for macsyma
complr_load {"((libmax) module)" "((libmax) maxmac)"} \
    {"share;_maxsrc;array" "ellen;check"}

### rebuild float because version built the first time gives
### arithmetic overflows.  See ticket #1211.
complr_load {"((libmax) module)" "((libmax) maxmac)"} \
    {"macsym;_rat;float"}

# this is not technically part of macsyma, but requires a bunch
# of macsyma macros and libraries in order to compile
complr {"liblsp;_libdoc;lchstr"}
respond "*" ":delete liblsp;lchstr unfasl\r"
