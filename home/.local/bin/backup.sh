#!/bin/bash
# crontab 7 a.m. everyday
# 0 7 * * * backup.sh

# Working with Local Server or SSH Server

FILTER_FILE="$HOME/.rsync-filter"

LOG_FILE="/tmp/backup.log"

RSYNC="rsync -Rrazpt -v  --delete"

function usage {
    echo -ne "usage:\n\t$0 /path/to/config.bkp\n\n"
}

if [ ! -f $1 ]; then
    echo -ne "ERROR: Backup config file don't found\n\n"
    usage
    exit 1
fi

rm -f $LOG_FILE
_PWD=$PWD
while read line
do
    [[ $line == \#* ]] && continue
    [[  -z $line   ]] && continue
    [[ $line == \[* ]] && SERVER=`echo $line | cut -d "[" -f2 | cut -d "]" -f1` && continue

    [[ $SERVER == "" ]] && echo "[Server] not found in ~/.backup to $line" && continue
    if [ `echo $line | wc -w` -gt 1 ]; then
       P1=`echo $line | cut -d\  -f1`
       cd $P1 
       ARG=`echo $line | cut -d\  -f2`
       EXCLUDE_LIST=`echo $line | cut -d\  -f3-`
       if [ $ARG != "-exclude" ]; then 
            echo "Argument $ARG dont implemented in $line"
            continue
       fi
       rm -f /tmp/excluded.txt  # just in case
       for x in $EXCLUDE_LIST
       do
           echo $x >> /tmp/excluded.txt
       done
       if [ -e "$P1" ]; then
           echo -e "\n[RSYNC] $P1 -> $SERVER [EXCLUDE] $EXCLUDE_LIST"
           # -C : Ignore like CVS
           $RSYNC --exclude-from /tmp/excluded.txt --exclude-from="$FILTER_FILE" -e ssh $P1 $SERVER &>> $LOG_FILE
           if [ $? != 0 ]; then
               echo -e "Errors was found. See /tmp/backup.log"
           fi
       else
           echo -e "ERROR: The path '$line' don't exists\n"
       fi
       rm -f /tmp/excluded.txt
       cd $_PWD
    elif [ -e "$line" ]; then
        echo -e "\n[RSYNC] $line -> $SERVER"
        # -C : Ignore like CVS 
        $RSYNC --exclude-from="$FILTER_FILE" -e ssh $line $SERVER &>> $LOG_FILE
        if [ $? != 0 ]; then
            echo -e "Errors was found. See /tmp/backup.log"
        fi
    else
        echo -e "ERROR: The path '$line' don't exists\n"
    fi

done < "$HOME/.backup"


