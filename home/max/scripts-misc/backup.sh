#!/bin/bash


SrvDir="/files/"

for Dir in $(find * -maxdepth 0 -type d ); 
do
    rsync -Cravzp $SrvDir/$Dir/ ./$Dir/
done






