#!/bin/bash

SAVE_FILE=/tmp/.xbacklight.old


toggle_enable_disable_monitor() {
    if (( $(echo $(xbacklight -get)'>'0 | bc -l) )); then
        xbacklight -get > $SAVE_FILE
        xbacklight = 0;
    else
        if [ -f $SAVE_FILE ]; then
            xbacklight = $(cat $SAVE_FILE);
        else
            xbacklight = 100;
        fi
    fi
}

toggle_enable_disable_monitor

