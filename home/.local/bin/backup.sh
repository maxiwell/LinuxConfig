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

function print_header {
    echo -e "-------------------------------------------------------------------"
    echo -e " - Using $FILTER_FILE as default rsync exclude"
    echo -e " - Versioning isn't implemented"
    echo -e " - To details about your backup, see $LOG_FILE"
    echo -e "-------------------------------------------------------------------"
}

red='\033[0;31m'
yellow='\033[1;33m'
purple='\e[0;35m' 
NC='\033[0m' # No Color

if [ ! -f $1 ]; then
    echo -ne "ERROR: Backup config file don't found\n\n"
    usage
    exit 1
fi

rm -f $LOG_FILE

_PWD=$PWD
RSYNC_FILTER_STRING=$(cat .rsync-filter | sed 's/#.*$//g' | sed '/^$/d' | tr '\n' ' ')


print_header

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
       if [ $ARG == "-exclude" ]; then 
            rm -f /tmp/excluded.txt  # just in case
            for x in $EXCLUDE_LIST
            do
                echo $x >> /tmp/excluded.txt
            done
            if [ -e "$P1" ]; then
                echo -e "\n[RSYNC] $P1 -> $SERVER $yellow [$FILTER_FILE] $NC $red $RSYNC_FILTER_STRING $NC $yellow [$ARG] $NC $red  $EXCLUDE_LIST $NC"
                echo -e "\n[RSYNC] $P1 -> $SERVER [$FILTER_FILE] $RSYNC_FILTER_STRING [$ARG] $EXCLUDE_LIST" &>> $LOG_FILE
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
       else 
            echo "Argument $ARG dont implemented in $line"
            continue
        fi
    
    elif [ -e "$line" ]; then
        echo -e "\n[RSYNC] $line -> $SERVER $yellow [$FILTER_FILE] $NC $red $RSYNC_FILTER_STRING $NC"
        # -C : Ignore like CVS 
        $RSYNC --exclude-from="$FILTER_FILE" -e ssh $line $SERVER &>> $LOG_FILE
        if [ $? != 0 ]; then
            echo -e "Errors was found. See /tmp/backup.log"
        fi
    else
        echo -e "ERROR: The path '$line' don't exists\n"
    fi

done < "$HOME/.backup"


