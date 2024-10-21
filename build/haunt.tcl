log_progress "ENTERING BUILD SCRIPT: HAUNT"

respond "*" ":cwd haunt\r"

# build ops4
respond "*" "complr\013"
respond "_" "haunt;_haunt;ops4 lsp\r"
respond "_" "\032"
type ":kill\r"

# dump ops4
respond "*" "lisp\013"
respond "Alloc?" "n\r"
respond "*" "(load '((haunt) ops4 load))"
respond "T" "(dump-it)"
respond ":\$Job Suspended\$" ":pdump haunt;ts ops4\r"
type ":kill\r"
