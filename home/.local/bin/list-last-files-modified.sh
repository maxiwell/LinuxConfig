#!/bin/bash


N=$1
if [ "$N" == "" ]; then
    N=10
fi


find . -type f -printf '%T@ %p\n' | sort -n | tail -n$N | sort -r | awk '{x=$1;sub(/.*/,strftime("%Y-%m-%d %H:%M:%S",$1),x);$1=x;}1'
#find . -type f -printf '%T@ %p\n' | sort -n | tail -n$N | sort -r 
