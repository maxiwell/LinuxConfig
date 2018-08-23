#!/bin/bash

DEVICE="ETPS/2 Elantech Touchpad"

toggle_enable_disable_device() {
    if xinput list "$1" | grep "disabled" &> /dev/null; then
        xinput enable "$1"
    else
        xinput disable "$1"
        xset dpms force standby
    fi
}

toggle_enable_disable_device "Logitech USB Gaming Mouse"
toggle_enable_disable_device "ETPS/2 Elantech Touchpad"

