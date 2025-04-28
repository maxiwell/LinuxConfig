#!/bin/bash

# Screenshot to Clipboard

DIR=$HOME/screenshot

#mkdir -p $DIR
#scrot -s $DIR/foo.png
#xclip -t image/png -selection c -i $DIR/`ls -t $DIR | head -n1`

flameshot gui --path $DIR -c
