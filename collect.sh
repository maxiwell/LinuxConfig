#!/bin/bash

allfil=`find ./home/*/ -type f`

for k in $allfil; do
	dir=`echo $k | sed -e "s/\/[^\/]*$/\//" | sed -e "s/^\.//"`
	fil=`echo $k | sed -e "s/.*\///"`

    if [ $fil == ".gitconfig" ]; then
		continue
    fi
    if [ $fil == ".msmtprc" ]; then
	if [ -f $dir$fil ] && [ $dir$fil -nt ./$dir$fil ]; then # f1 is newer than f2
		echo "New .msmtprc config ($dir$fil). Check yourserlf"
		continue
	fi
    fi

    if [ $fil == "inadyn" ]; then
	if [ -f $dir$fil ] && [ $dir$fil -nt ./$dir$fil ]; then # f1 is newer than f2
		echo "New inadyn config ($dir$fil). Check yourserlf"
		continue
	fi
    fi

    if [ ! -f $dir$fil ]; then
		echo "$dir$fil does not exist"
    else   
	if [ ! -f ./$dir$fil ]; then
    		cp $dir$fil ./$dir$fil
		echo "cp $dir$fil"
	elif [ $dir$fil -nt ./$dir$fil ]; then # f1 is newer than f2
		cp $dir$fil ./$dir$fil
		echo "cp $dir$fil"
	fi

	
    fi
done

exit 0

