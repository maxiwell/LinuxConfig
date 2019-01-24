#!/bin/bash

command -v ansible &>/dev/null || { echo -e "ERROR: Install 'ansible' package\n"; exit 1; }

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo -e "ERROR: It's not possible identify the linux distribution"
    exit 2;
fi

for i in *-$OS.yml; do
    # FIXME: I use 'sudo' because 'pip' module fails  with 'become' privilege escalation
    sudo ansible-playbook -i "localhost," -c local  $i --extra-vars "local_user=$USER local_home=$HOME"
done

