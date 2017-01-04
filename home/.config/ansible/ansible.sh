#!/bin/bash

sudo ansible-playbook -i "localhost," -c local  playbook.yml --extra-vars "local_user=$USER local_home=$HOME" $1
