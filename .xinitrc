#!/bin/sh

# xrandr --output eDP --mode 1920x1080 &

setxkbmap -option caps:swapescape
setxkbmap -option ctrl:swap_lwin_lctl &
xset r rate 200 50 &

# xinput --set-prop 'pointer:''Logitech G305' 'libinput Accel Speed' 0
# xinput --set-prop 'pointer:''Logitech G305' 'libinput Accel Profile Enabled' 0, 1


picom &

exec dwm
