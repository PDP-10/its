log_progress "ENTERING BUILD SCRIPT: SHRDLU"

cwd "shrdlu"

# first, compile all the sources that should be compiled

complr {"graphf"}
complr {"macros"}
complr {"proggo"}
complr {"plnr"}
complr {"thtrac"}
complr {"syscom"}
complr {"morpho"}
complr {"show"}
complr {"progmr"}
complr {"ginter"}
complr {"gramar"}
complr {"dictio"}
complr {"smspec"}
complr {"smass"}
complr {"smutil"}
complr {"newans"}
complr {"blockp"}
complr {"blockl"}

# now load up a compiled version of SHRDLU
respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" "(load 'loader)"
respond "T" "(load-shrdlu-compiled)"
respond "COMPLETED" "(dump-shrdlu)"

# dump it as SHRDLU;TS SHRDLU
respond "*" ":pdump shrdlu;ts shrdlu\r"
respond "*" ":kill\r"

# load up a compiled version of PLNR
respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" "(load 'loader)"
respond "T" "(load-planner-compiled)"
respond "(THERT TOP LEVEL))" "(dump-planner)"

# dump it as SHRDLU;TS PLNR
respond "*" ":pdump shrdlu;ts plnr\r"
respond "*" ":kill\r"
