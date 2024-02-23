if test -n "$GITLAB_CI" -o -n "$CIRCLECI"; then
    sudo() {
        "$@"
    }
fi

install_Linux() {
    sudo apt-get update -myq
    sudo apt-get install -my expect
    # For GitLab CI
    sudo apt-get install -my git make gcc libncurses-dev autoconf
    case "$EMULATOR" in
        simh*) sudo apt-get install -y libegl1-mesa-dev libgles2-mesa-dev
              sudo apt-get install -y libsdl2-dev;;
        pdp10-k?) sudo apt-get install -y libegl1-mesa-dev libgles2-mesa-dev
              sudo apt-get install -y libx11-dev libxt-dev libsdl2-dev
              sudo apt-get install -y libsdl2-image-dev libpcap-dev
              sudo apt-get install -y libgtk-3-dev libsdl2-net-dev;;
        klh10) sudo apt-get install -y libusb-1.0-0-dev;;
    esac
}

install_FreeBSD() {
    pkg upgrade -y
    pkg install -y gmake git expect
    case "$EMULATOR" in
        pdp10-ka) pkg install -y sdl2 sdl2_image sdl2_net pkgconf gtk3;;
        pdp10-kl) pkg install -y sdl2 pkgconf gtk3 autoconf;;
        klh10) pkg install -y pkgconf autotools;;
    esac
}

install_Darwin() {
    if [ -x /opt/local/bin/port ]; then
        echo "Using macports under sudo - your password may be required"
        case "$EMULATOR" in
            simh*) sudo port install vde2 automake libsdl2 libsdl2_image libsdl2_net pkgconfig;;
            pdp10-*) sudo port install vde2 automake libsdl2 libsdl2_image libsdl2_net pkgconfig;;
            klh10) sudo port install vde2 automake libsdl2 libsdl2_image libsdl2_net pkgconfig;;
        esac
    elif [ -x /opt/homebrew/bin/homebrew ]; then
        brew update
        case "$EMULATOR" in
            simh*) brew install automake sdl2 sdl2_image sdl2_net pkg-config;;
            pdp10-*) brew install automake sdl2 sdl2_image sdl2_net pkg-config;;
            klh10) brew install automake sdl2 sdl2_image sdl2_net pkg-config;;
        esac
    else
        echo "Either MacPorts or Homebrew must be installed to /opt first"
        exit 1
    fi
}

"$1"
