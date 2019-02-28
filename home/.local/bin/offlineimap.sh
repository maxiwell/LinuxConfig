#!/bin/bash

if [ -f /tmp/offlineimap.lock ]; then
    echo "offlineimap.sh already in execution"
    exit 1;
fi

touch /tmp/offlineimap.lock

offlineimap -o
notmuch new

rm /tmp/offlineimap.lock
