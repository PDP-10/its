install_linux() {
    sudo apt-get update -myq
    sudo apt-get install -my expect
    if test "$EMULATOR" = simh; then
	sudo apt-get install simh
    fi
}

"$1"
