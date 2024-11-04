#!/bin/bash

xsetroot -solid "#000000"

#xautolock -time 1 -locker "gnome-screensaver-command --lock" &

tint2 &
xscreensaver &
xscreensaverstopper.sh & > /tmp/xscreensaverstopper.log

#feh --bg-tile Pictures/Emily_Blunt.jpg &

# Disable nemo desktop
gsettings set org.nemo.desktop show-desktop-icons

killall ssh-agent

# keyboard to USA with dead keys
setxkbmap -layout us -variant intl

sh ~/.xinitrc

# Map to urxvt works with END/HOME in VIM 
xmodmap ~/.Xmodmap

sleep 2

conky  -c $HOME/.conky/seamod/conkyrc_seamod &
copyq &
