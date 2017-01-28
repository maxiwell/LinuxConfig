#!/bin/bash

command -v ansible &>/dev/null || { echo -e "ERROR: Install 'ansible' package and try again: 
                                            \n\tsudo apt-get install ansible\n"; exit 1; }


for i in *.yml; do
    # FIXME: I use 'sudo' because 'pip' module fails  with 'become' privilege escalation
    sudo ansible-playbook -i "localhost," -c local  $i --extra-vars "local_user=$USER local_home=$HOME" $1
done

