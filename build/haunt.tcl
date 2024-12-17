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

# build compile haunt lisp code
respond "*" "complr\013"
respond "_" "haunt;_haunt;comman lsp\r"
respond "_" "haunt;_haunt;haunt lsp\r"
respond "_" "haunt;_haunt;slurp lsp\r"
respond "_" "haunt;_haunt;tlist lsp\r"
respond "_" "haunt;_haunt;user lsp\r"
respond "_" "\032"
type ":kill\r"

# dump haunt
respond "*" ":haunt;ops4\r"
respond "(CREATED" "(load '((haunt) haunt load))"
respond ":\$Job Suspended\$" ":sl sys;purqio >\r"
respond "*" ":pdump haunt;ts haunt\r"
type ":kill\r"

# make available in SYS:
respond "*" ":link sys3;ts haunt,haunt;ts haunt\r"
respond "*" ":link sys3;ts ops4,haunt;ts ops4\r"
