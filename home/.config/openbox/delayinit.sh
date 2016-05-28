#!/bin/bash

xsetroot -solid "#000000"

#xautolock -time 1 -locker "gnome-screensaver-command --lock" &

hdmi clone &
tint2 &

#feh --bg-tile Pictures/Emily_Blunt.jpg &

# Disable nemo desktop
gsettings set org.nemo.desktop show-desktop-icons

killall ssh-agent

# keyboard to USA with dead keys
setxkbmap -layout us -variant intl

sh ~/.xinitrc

# Map to urxvt works with END/HOME in VIM 
xmodmap ~/.Xmodmap

# Stop xscreensaver if a full-screen display is found
~/.local/opt/lightsOn/lightsOn.sh 120 &

sleep 2

conky  -c $HOME/.conky/seamod/conkyrc_seamod &


