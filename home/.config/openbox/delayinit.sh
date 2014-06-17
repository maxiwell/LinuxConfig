#!/bin/bash


hdmi clone &
tint2 &
gnome-sound-applet &
volumeicon &

#feh --bg-tile Pictures/Emily_Blunt.jpg &

sleep 1
conky  -c $HOME/.conky/conkyrc_seamod &

killall ssh-agent

