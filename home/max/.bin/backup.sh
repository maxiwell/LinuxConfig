#!/bin/bash


SERVER="/backup/_BackupManual_/"

# load ~/.backup file
while read line
do
    [[ $line = \#* ]] && continue
    [[  -z $line   ]] && continue

    if [ -d "$line" ]; then
        rsync -CRravzp $line $SERVER
    else
        echo -e "ERROR: The path '$line' don't exists\n"
    fi

done < "$HOME/.backup"




## That is the old code. It must be moved to 
## the backup directory and executed from there.
#
#SrvDir="/files/"
#
#for Dir in $(find * -maxdepth 0 -type d ); 
#do
#    rsync -Cravzp $SrvDir/$Dir/ ./$Dir/
#done






