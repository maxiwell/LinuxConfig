#!/bin/bash


hdmi clone &
tint2 &

#feh --bg-tile Pictures/Emily_Blunt.jpg &

gsettings set org.nemo.desktop show-desktop-icons

sleep 1
conky  -c $HOME/.conky/conkyrc_seamod &

killall ssh-agent

setxkbmap -layout us -variant intl

