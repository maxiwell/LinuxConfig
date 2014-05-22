#!/bin/bash

allfil=`find ./home/ -type f`

base=$HOME

for k in $allfil; do
#	dir=`echo $k | sed -e "s/\/[^\/]*$/\//" | sed -e "s/^\.//"`
#	fil=`echo $k | sed -e "s/.*\///"`

	dir=`dirname $k | sed -e "s/^\.//" | sed -e "s/\/home//" | sed -e "s/$/\//"`
	fil=`basename $k`

	if [ $fil == ".gitconfig" ]; then
		continue
    fi
    if [ $fil == ".msmtprc" ]; then
		continue
	fi

#    if [ $fil == "inadyn" ]; then
#	if [ -f $dir$fil ] && [ $dir$fil -nt ./$dir$fil ]; then # f1 is newer than f2
#		echo "New inadyn config ($dir$fil). Check yourserlf"
#		continue
#	fi
#    fi
#
    if [ ! -f $base$dir$fil ]; then
		echo "$base$dir$fil does not exist"
    else   
	if [ ! -f ./home/$dir$fil ]; then
    		cp -p $base$dir$fil ./home/$dir$fil
		echo "cp $base$dir$fil"
	elif [ $base$dir$fil -nt ./home/$dir$fil ]; then # f1 is newer than f2
		cp -p $base$dir$fil ./home/$dir$fil
		echo "cp $base$dir$fil"
	fi
    fi
done

exit 0

