#!/bin/bash


#(sleep 10 && feh --bg-tile Pictures/Emily_Blunt.jpg) &
sleep 1

#nm-applet & 
#/home/max/.dzenconky.sh &
hdmiclone &
conky -d -c /home/max/.conky/conkyrc_seamod &
tint2 &
gnome-sound-applet &

