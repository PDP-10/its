log_progress "ENTERING BUILD SCRIPT: SHRDLU"

respond "*" ":cwd shrdlu\r"

# first, compile all the sources that should be compiled

respond "*" ":complr\r"
respond "_" "shrdlu; graphf\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; macros\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; proggo\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; plnr\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; thtrac\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; syscom\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; morpho\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; show\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; progmr\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; ginter\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; gramar\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; dictio\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; smspec\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; smass\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; smutil\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; newans\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; blockp\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":complr\r"
respond "_" "shrdlu; blockl\r"
respond "_" "\032"
type ":kill\r"

# now load up a compiled version of SHRDLU
respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" "(load 'loader)"
respond "T" "(shrdlu-compiled)"
respond "COMPLETED" "(dump-shrdlu)"

# dump it as SHRDLU;TS SHRDLU
respond "*" ":pdump shrdlu;ts shrdlu\r"
respond "*" ":kill\r"

# load up a compiled version of PLNR
respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" "(load 'loader)"
respond "T" "(load 'plnrfi)"
respond "T" "(planner-compiled)"
respond "(THERT TOP LEVEL))" "(dump-planner)"

# dump it as SHRDLU;TS PLNR
respond "*" ":pdump shrdlu;ts plnr\r"
respond "*" ":kill\r"
