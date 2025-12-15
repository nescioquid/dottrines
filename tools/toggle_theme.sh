#!/bin/bash

LIGHT_THEME="Pop"
DARK_THEME="Pop-dark"

current_theme=$(gsettings get org.gnome.desktop.interface gtk-theme)

if [[ "$current_theme" == "'$DARK_THEME'" ]]; then
    gsettings set org.gnome.desktop.interface gtk-theme "$LIGHT_THEME"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    echo "Switched to LIGHT theme"
else
    gsettings set org.gnome.desktop.interface gtk-theme "$DARK_THEME"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    echo "Switched to DARK theme"
fi
