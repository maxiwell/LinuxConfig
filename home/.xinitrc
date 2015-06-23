#!/bin/bash

# Executed by startx (run your window manager from here)

which xrdb       &>/dev/null  &&  xrdb -merge ~/.Xresources


