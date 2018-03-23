if test -n "$GITLAB_CI"; then
    sudo() {
        "$@"
    }
fi

install_linux() {
    sudo apt-get update -myq
    sudo apt-get install -my expect
    # For GitLab CI
    sudo apt-get install -my git make gcc libncurses-dev autoconf
    if test "$EMULATOR" = simh; then
	sudo apt-get install -y simh
    fi
}

"$1"
