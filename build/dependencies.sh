install_linux() {
    sudo add-apt-repository ppa:dns/gnu -y
    sudo apt-get update -myq
    sudo apt-get install -my expect
    sudo apt-get install --only-upgrade autoconf
    if test "$EMULATOR" = simh; then
	sudo apt-get install simh
    fi
}

"$1"
