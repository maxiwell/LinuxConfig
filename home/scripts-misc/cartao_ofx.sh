#!/bin/bash

FILE=$1


echo "Type the conversion BRL->USD: "
read CONVERTION

cp $FILE ${FILE}_bkp
grep -n -B 1 USD $FILE | while read -r GREPLINE; do

    # Get the GREP output that contains the Currency Value
    if [[ $GREPLINE == *"TRNAMT"* ]]; then
       LINENUMBER=`echo $GREPLINE | cut -d- -f 1`
       VALUESTR=`echo $GREPLINE | cut -d\> -f 2 | cut -d\< -f 1`

       VALUECONV=`echo $VALUESTR*$CONVERTION | bc`

       sed -i "${LINENUMBER}s/${VALUESTR}/${VALUECONV}/" $FILE 
    fi
done

