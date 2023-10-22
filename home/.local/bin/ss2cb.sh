#!/bin/bash

# Screenshot to Clipboard


scrot -s $HOME/screenshot/foo.png
xclip -t image/png -selection c -i $HOME/screenshot/foo.png


