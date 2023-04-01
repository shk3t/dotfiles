#!/bin/bash

# dwm or plasma
session="plasma"

if [[ $session == "plasma" ]]; then
    export DESKTOP_SESSION=plasma
    exec startplasma-x11
else # dwm
    xrandr --output eDP --mode 1920x1080 &
    light -S 40 &

    export QT_STYLE_OVERRIDE=kvantum
    # export QT_QPA_PLATFORMTHEME=qt5ct

    setxkbmap -option grp:alt_space_toggle \
        -option caps:escape_shifted_capslock \
        -option ctrl:swap_lwin_lctl &
    xset r rate 180 60 &

    # picom &

    PATH="$HOME/bin/statusbar:$PATH"
    PATH="$HOME/bin:$PATH"
    dwmblocks &

    exec dbus-run-session dwm
fi
