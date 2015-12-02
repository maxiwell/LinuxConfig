#!/bin/bash

xsetroot -solid "#000000"

#xautolock -time 1 -locker "gnome-screensaver-command --lock" &

hdmi clone &
tint2 &

#feh --bg-tile Pictures/Emily_Blunt.jpg &

gsettings set org.nemo.desktop show-desktop-icons

killall ssh-agent

setxkbmap -layout us -variant intl

xrdb -merge $HOME/.Xresources

# Map to urxvt works with END/HOME in VIM 
xmodmap ~/.Xmodmap

sleep 2

conky  -c $HOME/.conky/conkyrc_seamod &


