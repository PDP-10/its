log_progress "ENTERING BUILD SCRIPT: SHRDLU"

respond "*" ":cwd shrdlu\r"

# first, compile all the sources that should be compiled

respond "*" ":complr graphf\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr macros\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr proggo\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr plnr\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr thtrac\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr syscom\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr morpho\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr show\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr progmr\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr ginter\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr gramar\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr dictio\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr smspec\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr smass\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr smutil\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr newans\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr blockp\r"
respond "Job COMPLR finished" ":kill\r"

respond "*" ":complr blockl\r"
respond "Job COMPLR finished" ":kill\r"

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
