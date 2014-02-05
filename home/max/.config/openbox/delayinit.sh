#!/bin/bash


hdmiclone &
tint2 &
gnome-sound-applet &

#feh --bg-tile Pictures/Emily_Blunt.jpg &

sleep 2
conky  -c $HOME/.conky/conkyrc_seamod &

killall ssh-agent

#conky  -c $HOME/.conky/conkyrc_conn &

# I mounted with etc/fstab because samba doesn't works with udisks 
#if [[ `uname -n` == "max-p150hm" ]]; then
#    udisks --mount /dev/sdc1 --mount-options umask=0007
#    udisks --mount /dev/sdd1 --mount-options umask=0007
#    udisks --mount /dev/sde1 --mount-options umask=0007
#fi

