#!/bin/bash

(FNAME=$1; tmux switch -t $(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_tty}' \
    | grep $(ps -o tty= -p $(lsof -t $FNAME))$ | awk '{ print $1 }'))                

