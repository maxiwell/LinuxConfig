#!/bin/bash


# Working with Local Server or SSH Server
# 'ayarrr' is a SSH host in ~/.ssh/config file

#SERVER="/backup/_BackupManual_/"
#SERVER="ayarrr:/home/max/"

SERVER=""

# load ~/.backup file
while read line
do
    [[ $line == \#* ]] && continue
    [[  -z $line   ]] && continue
    [[ $line == \[* ]] && SERVER=`echo $line | cut -d "[" -f2 | cut -d "]" -f1` && continue

    [[ $SERVER == "" ]] && echo "[Server] not found in ~/.backup to $line" && continue
    if [ -d "$line" ]; then
        echo $line $SERVER
#        rsync -CRravzp -e ssh $line $SERVER
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






