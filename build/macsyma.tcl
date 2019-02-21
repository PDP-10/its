log_progress "ENTERING BUILD SCRIPT: MACSYMA"

# libmax

# all libmax components (well almost all) require libmax;module fasl
# at compile time.  Build it first.

respond "*" "complr\013"
respond "_" "libmax;module\r"
respond "_" "\032"
type ":kill\r"

# libmax;maxmac can't be compiled unless libmax;mforma is (first) compiled.
# However, libmax;mforma uses libmax;macmac.  Hence you end up having to
# compile libmax;mforma first, then libmax;maxmac, and then compiling these
# both a second time.  Otherwise, there are not incorrectly generated FASL
# files for each, but anything that depends on these two packages will also
# have errors during compilation.

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(maklap)"
respond "_" "libmax;mforma\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(maklap)"
respond "_" "libmax;maxmac\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(maklap)"
respond "_" "libmax;mforma\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(maklap)"
respond "_" "libmax;maxmac\r"
respond "_" "\032"
type ":kill\r"

# the following are required to compile some of the libmax;
# FASL files
#
respond "*" ":midas rwk;lfsdef fasl_rwk;lfsdef\r"
expect ":KILL"
respond "*" ":midas rat;ratlap fasl_rat;ratlap\r"
expect ":KILL"
mkdir "maxdmp"
respond "*" ":link maxdmp;ratlap fasl,rat;ratlap fasl\r"
respond "*" ":link libmax;lusets fasl,liblsp;\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(maklap)"
respond "_" "libmax;ermsgx\r"
respond "_" "libmax;ermsgc\r"
respond "_" "z;fildir\r"
respond "_" "libmax;lmmac\r"
respond "_" "libmax;meta\r"
respond "_" "libmax;lmrund\r"
respond "_" "libmax;lmrun\r"
respond "_" "libmax;displm\r"
respond "_" "libmax;defopt\r"
respond "_" "libmax;mopers\r"
respond "_" "libmax;mrgmac\r"
respond "_" "libmax;nummac\r"
respond "_" "libmax;opshin\r"
respond "_" "libmax;edmac_emaxim;\r"
respond "_" "libmax;procs\r"
respond "_" "libmax;readm\r"
respond "_" "libmax;strmac\r"
respond "_" "libmax;transm\r"
respond "_" "libmax;rzmac_rz;macros\r"
respond "_" "libmax;transq\r"
respond "_" "libmax;mdefun\r"
respond "_" "\032"
type ":kill\r"

# build MAXTUL FASL files

mkdir "maxerr"
mkdir "maxer1"

respond "*" "complr\013"
respond "_" "maxtul;strmrg\r"
respond "_" "maxtul;defile\r"
respond "_" "maxtul;docgen\r"
respond "_" "maxtul;query\r"
respond "_" "maxtul;maxtul\r"
respond "_" "maxtul;toolm\r"
respond "_" "maxtul;dclmak\r"
respond "_" "maxtul;mailer\r"
respond "_" "maxtul;mcl\r"
respond "_" "maxtul;timepn\r"
respond "_" "maxtul;expand\r"
respond "_" "maxtul;fsubr!\r"
respond "_" "maxtul;error!\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "maxtul;fasmap\r"
respond "_" "\032"
type ":kill\r"

# define needs (for some reason) to be compiled separately.
# not doing this results in errors compiling macsyma sources,
# such as ELL; HYP >
#
respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(maklap)"
respond "_" "libmax;define\r"
respond "_" "\032"
type ":kill\r"

# build macsyma

mkdir "macsym"

respond "*" ":link macsym;mdefun fasl,libmax;\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(maklap)"
respond "_" "macsym;ermsgm_maxsrc;ermsgm\r"
respond "_" "maxdoc;tdcl\r"
respond "_" "rlb;bitmac\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "rlb;faslre\r"
respond "_" "rlb;faslro\r"
respond "_" "\032"
type ":kill\r"

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

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(maklap)"
respond "_" "libmax;mhayat_rat;mhayat\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(maklap)"
respond "_" "libmax;ratmac_rat;ratmac\r"
respond "_" "\032"
type ":kill\r"

# mforma needs to get recompiled (not sure exactly which
# dependency yet causes the version we've built so far
# not to work, but if recompiled at this point, we're
# able to build macsyma
respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(maklap)"
respond "_" "libmax;mforma\r"
respond "_" "\032"
type ":kill\r"

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(setq pure t)"
respond "T" "(load \"liblsp;sharab\")"
respond_load "(load \"maxtul;mcldmp (init)\")"
respond "T" "\007"
respond "*" "(dump-mcl 32. t)"
respond "File name->" "\002"
respond ";BKPT" "(quit)"

respond "*" ":midas maxtul;ts mcl_mcldmp midas\r"
respond "*" ":link maxtul;.good. complr,sys;ts complr\r"

respond "*" ":link maxtul;ts utmcl,maxtul;ts mcl\r"

respond "*" "complr\013"
respond "_" "mrg;macros\r"
respond "_" "\032"
type ":kill\r"

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
respond "T" "(loader 1000)"
respond "(C1)" "quit();"

respond "*" ":copy aljabr;user profil,macsym;\r"
respond "*" ":link macsym;check fasl,ellen;\r"
respond "*" ":link sys3;ts macsym,maxdmp;loser >\r"
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

### build share;array fasl and ellen; check fasl for macsyma
respond "*" ":maxtul;mcl\r"
respond "_" "share;_maxsrc;array\r"
respond "_" "ellen;check\r"
respond "_" "\032"
type ":kill\r"

### rebuild float because version built the first time gives
### arithmetic overflows.  See ticket #1211.

respond "*" "complr\013"
respond "_" "\007"
respond "*" "(load '((libmax) module))"
respond_load "(load '((libmax) maxmac))"
respond_load "(maklap)"
respond "_" "macsym;_rat;float\r"
respond "_" "\032"
type ":kill\r"

# this is not technically part of macsyma, but requires a bunch
# of macsyma macros and libraries in order to compile
respond "*" ":complr\r"
respond "_" "liblsp;_libdoc;lchstr\r"
respond "_" "\032"
type ":kill\r"
respond "*" ":delete liblsp;lchstr unfasl\r"
