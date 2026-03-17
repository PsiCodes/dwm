#!/bin/bash

if ! command -v pacman >/dev/null 2>&1; then
    echo "Error: pacman not found in PATH."
    exit 1
fi

if [ "$(basename "$PWD")" != "dwm" ]; then
    echo "Warning: You are not inside the dwm directory."
    echo "Current directory: $PWD"
    exit 1
fi

packages=(
    clipmenu
    dmenu
    feh
    maim
    picom
    xclip
    xsel
    xorg-server
    xorg-xinit
    xorg-xinput
)

install() {
    echo "Installing dependencies..."
    sudo pacman -S "${packages[@]}"
    echo "Installing dwm..."
    make clean && make 
    sudo ln -s $(pwd)/dwm /usr/local/bin/dwm
    echo "Installing slstatus..."
    cd slstatus
    make clean && make 
    sudo ln -s $(pwd)/slstatus /usr/local/bin/slstatus
    cd ..
    echo "Copying config files..."
    cp "$(pwd)/.xinitrc" "$HOME/.xinitrc"
    chmod +x $HOME/.xinitrc # Required for some display managers like ly
    sudo cp "$(pwd)/40-touchpad.conf" /etc/X11/xorg.conf.d/

    echo "Install complete."
}

uninstall() {
    echo "Removing dependencies..."
    sudo pacman -Rns "${packages[@]}"
    sudo rm /usr/local/bin/slstatus
    sudo rm /usr/local/bin/dwm
    echo "Removing config files..."
    rm -f "$HOME/.xinitrc"
    sudo rm -f /etc/X11/xorg.conf.d/40-touchpad.conf
    echo "Uninstall complete."
}

case "$1" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    *)
        echo "Usage: $0 {install|uninstall}"
        exit 1
        ;;
esac
