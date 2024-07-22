log_progress "ENTERING BUILD SCRIPT: SHRDLU"

respond "*" ":cwd shrdlu\r"

respond "*" ":complr\r"
respond "_" "shrdlu; graphf\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" "(load 'loader)"
respond "T" "(loadshrdlu)"
respond "|CONSTRUCTION COMPLETED|" "(dump-it)"
respond "*" ":pdump shrdlu;ts shrdlu\r"
respond "*" ":kill\r"

respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" "(load 'loader)"
respond "T" "(load 'plnrfi)"
respond "T" "(loadplanner)"
respond "(THERT TOP LEVEL))" "(dump-planner)"
respond "*" ":pdump shrdlu;ts plnr\r"
respond "*" ":kill\r"

