#!/bin/bash


hdmiclone &
tint2 &
gnome-sound-applet &

#feh --bg-tile Pictures/Emily_Blunt.jpg &

sleep 2
conky  -c $HOME/.conky/conkyrc_seamod &
