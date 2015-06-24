#!/bin/bash


hdmi clone &
tint2 &

#feh --bg-tile Pictures/Emily_Blunt.jpg &

gsettings set org.nemo.desktop show-desktop-icons

killall ssh-agent

setxkbmap -layout us -variant intl

xrdb -merge $HOME/.Xresources

# Map to urxvt works with END/HOME in VIM 
xmodmap ~/.Xmodmap

sleep 1
conky  -c $HOME/.conky/conkyrc_seamod &

ENC=`df -t ecryptfs | wc -l` 
if [ $ENC -gt 0 ]; then
    gksu /home/max/.local/bin/umountall-ecryptfs.sh
fi


