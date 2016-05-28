#!/bin/bash

# Executed by startx (run your window manager from here)

which xrdb &>/dev/null  &&  xrdb -merge ~/.Xresources
xscreensaver -no-splash &

#xautolock -time 1 -locker "gnome-screensaver-command --lock" &

