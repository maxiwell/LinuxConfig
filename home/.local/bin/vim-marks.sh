#!/bin/bash

cat ~/.viminfo \
    | awk -v RS="History of marks" '{ print $0 NR }' \
    | grep -e '^>.*$' -e '^[[:space:]][a-Z][[:space:]][0-9].*$' \
    | grep -Pzo '(>.*\n[[:space:]].*\n)|([[:space:]][a-zA-Z][[:space:]].*\n)' 

