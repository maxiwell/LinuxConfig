#!/bin/bash


# Working with Local Server or SSH Server
# 'ayarrr' is a SSH host in ~/.ssh/config file

#SERVER="/backup/_BackupManual_/"
#SERVER="ayarrr:/home/max/"

SERVER=""

FILTER_FILE="$HOME/.rsync-filter"

# load ~/.backup file
while read line
do
    [[ $line == \#* ]] && continue
    [[  -z $line   ]] && continue
    [[ $line == \[* ]] && SERVER=`echo $line | cut -d "[" -f2 | cut -d "]" -f1` && continue

    [[ $SERVER == "" ]] && echo "[Server] not found in ~/.backup to $line" && continue
    if [ `echo $line | wc -w` -gt 1 ]; then
       P1=`echo $line | cut -d\  -f1`
       ARG=`echo $line | cut -d\  -f2`
       EXCLUDE_LIST=`echo $line | cut -d\  -f3-`
       if [ $ARG != "-exclude" ]; then 
            echo "Argument $ARG dont implemented in $line"
            continue
       fi
       rm -f excluded.txt  # just in case
       for x in $EXCLUDE_LIST
       do
           echo $x >> /tmp/excluded.txt
       done
       if [ -e "$P1" ]; then
           echo -e "\n[RSYNC] $P1 -> $SERVER [EXCLUDE] $EXCLUDE_LIST"
           # -C : Ignore like CVS
           rsync -Rrazp -v  --delete --exclude-from /tmp/excluded.txt --exclude-from="$FILTER_FILE" -e ssh $P1 $SERVER
       else
           echo -e "ERROR: The path '$line' don't exists\n"
       fi
       rm -f excluded.txt
    elif [ -e "$line" ]; then
        echo -e "\n[RSYNC] $line -> $SERVER"
        # -C : Ignore like CVS 
        rsync -Rrazp -v  --delete --exclude-from="$FILTER_FILE" -e ssh $line $SERVER
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






