#!/bin/bash

# Screenshot to Clipboard


scrot -s /tmp/foo.png
xclip -t image/png -selection c -i /tmp/foo.png


