#!/bin/bash

FILE=$1


echo "Type the conversion BRL->USD: "
read CONVERSION

cp $FILE output_${FILE}
FILE="output_${FILE}"
grep -n -B 1 -A 2 USD ${FILE} | while read -r GREPLINE; do

    # Get the GREP output that contains the Currency Value
    if [[ $GREPLINE == *"TRNAMT"* ]]; then
       LINENUMBER=`echo $GREPLINE | cut -d- -f 1`
       VALUESTR=`echo $GREPLINE | cut -d\> -f 2 | cut -d\< -f 1`

       VALUECONV=`echo $VALUESTR*$CONVERSION | bc`

       sed -i "${LINENUMBER}s/${VALUESTR}/${VALUECONV}/" $FILE 
    fi
    # Get the GREP output that contains the MEMO information and 
    # annotates conversion
    if [[ $GREPLINE == *"MEMO"* ]]; then
        LINENUMBER=`echo $GREPLINE | cut -d- -f 1`

        sed -i "${LINENUMBER}s@<MEMO>@<MEMO>$VALUESTR*$CONVERSION | @" $FILE

    fi
done

