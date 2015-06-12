#!/bin/bash

FILE=$1


CONVERSION=`grep CURRATE $FILE | uniq | cut -d: -f2 | tr -d "[[:alpha:]]<>/\r"`
echo "Conversion: $CONVERSION"


cp $FILE ${FILE}.orig

sed -i '/^[[:space:]]$/d' $FILE
grep -n -B 3 USD ${FILE} | while read -r GREPLINE; do

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

