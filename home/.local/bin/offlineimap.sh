#!/bin/bash

# =================================
# Add in the crontab -e

# minutes hour dom month dow program
# */10 * * * * $HOME/.local/bin/offlineimap.sh &>> /tmp/offlineimap.log
# =================================

if [ -f /tmp/offlineimap.lock ]; then
    echo "offlineimap.sh already in execution"
    exit 1;
fi

touch /tmp/offlineimap.lock

offlineimap -o
notmuch new

rm /tmp/offlineimap.lock
