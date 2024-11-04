#!/bin/bash

# Screenshot to Clipboard

mkdir -p $HOME/screenshot
scrot -s $HOME/screenshot/foo.png
xclip -t image/png -selection c -i $HOME/screenshot/foo.png


