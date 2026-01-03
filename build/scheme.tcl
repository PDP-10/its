log_progress "ENTERING BUILD SCRIPT: SCHEME"

# Old? Scheme interpreter
complr {"scheme;_nschsy"}
respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" {(load "scheme; nschsy fasl")}
respond "\n" "(schemedump)"
respond "==>" "(quit)"

# New Scheme interpreter
complr {"quux;_schint lsp" "quux;_schmac lsp" "quux;_schuuo lsp"}

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
complr {"scheme;_rabbit lisp"}
respond "*" ":scheme;scheme\r"
respond "==>" {(schload "scheme; rabbit fasl")}
respond "==>" "(dumpit)"
respond "Dump anyway" " "
respond "TS RABBIT" "\r"
}
