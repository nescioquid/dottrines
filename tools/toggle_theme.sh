#!/bin/bash

current=$(gsettings get org.gnome.desktop.interface color-scheme)

if [[ "$current" == "'prefer-dark'" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    echo "switched to light theme"
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    echo "switched to dark theme"
fi
