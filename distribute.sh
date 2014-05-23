#!/bin/bash

allfil=`find ./home/ -type f`

base=$HOME

for k in $allfil; do
	dir=`dirname $k | sed -e "s/^\.//" | sed -e "s/\/home//" | sed -e "s/$/\//"`
	fil=`basename $k`

	if [ $fil == ".gitconfig" ]; then
		echo "skipping .gitconfig"
		continue
	fi
	if [ ! -d $base$dir ]; then
		mkdir -p $base$dir
	fi

	if [ ./home/$dir$fil -nt $base$dir$fil ]; then # f1 is newer than f2
		cp -p ./home/$dir$fil $base$dir$fil
		echo "cp $base$dir$fil"
	fi
done

exit 0
