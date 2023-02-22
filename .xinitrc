#!/bin/sh

xrandr --output eDP --mode 1920x1080 &
light -S 40 &

setxkbmap -option grp:alt_space_toggle \
    -option caps:escape_shifted_capslock \
    -option ctrl:swap_lwin_lctl &
xset r rate 180 60 &

# picom &

PATH="$HOME/bin/statusbar:$PATH"
PATH="$HOME/bin:$PATH"
dwmblocks &
exec dbus-run-session dwm
