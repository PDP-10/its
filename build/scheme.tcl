log_progress "ENTERING BUILD SCRIPT: SCHEME"

# Old? Scheme interpreter
respond "*" "complr\013"
respond "_" "scheme;_nschsy\r"
respond "_" "\032"
type ":kill\r"
respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" {(load "scheme; nschsy fasl")}
respond "\n" "(schemedump)"
respond "==>" "(quit)"

# New Scheme interpreter
respond "*" "complr\013"
respond "_" "quux;_schint lsp\r"
respond "_" "quux;_schmac lsp\r"
respond "_" "quux;_schuuo lsp\r"
respond "_" "\032"
type ":kill\r"

respond "*" ":link quux;scheme interp, schint fasl\r"
respond "*" ":link quux;scheme macros, schmac fasl\r"
respond "*" ":link quux;scheme uuohan, schuuo fasl\r"
respond "*" ":lisp quux;scheme (dump)\r"

# Fails the build, disabled for now.
if 0 {
# Rabbit Scheme compiler
respond "*" ":scheme;scheme\r"
respond "==>" {(schload "scheme; rabbit")}
respond "==>" {(comfile "scheme; rabbit")}
expect -timeout 3600 "COMPILE TIME:"
respond "==>" "(quit)"
respond "*" ":complr\r"
respond "_" "scheme;_rabbit lisp\r"
respond "_" "\032"
type ":kill\r"
respond "*" ":scheme;scheme\r"
respond "==>" {(schload "scheme; rabbit fasl")}
respond "==>" "(dumpit)"
respond "Dump anyway" " "
respond "TS RABBIT" "\r"
}
