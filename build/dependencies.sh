if test -n "$GITLAB_CI" -o -n "$CIRCLECI"; then
    sudo() {
        "$@"
    }
fi

install_linux() {
    sudo apt-get update -myq
    sudo apt-get install -my expect
    # For GitLab CI
    sudo apt-get install -my git make gcc libncurses-dev autoconf
    case "$EMULATOR" in
        simh) sudo apt-get install -y simh;;
        sims) sudo apt-get install -y libx11-dev libxt-dev;;
    esac
}

"$1"
