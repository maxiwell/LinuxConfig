#!/bin/bash

allfil=`find ./home/*/ -type f`
alllnk=`find ./home/*/ -type l`

for k in $allfil; do
	dir=`echo $k | sed -e "s/\/[^\/]*$/\//" | sed -e "s/^\.//"`
	fil=`echo $k | sed -e "s/.*\///"`
	if [ $fil == ".gitconfig" ]; then
		echo "skipping .gitconfig"
		continue
	fi
	if [ ! -d $dir ]; then
		mkdir -p $dir
	fi

	if [ ./$dir$fil -nt $dir$fil ]; then # f1 is newer than f2
		cp ./$dir$fil $dir$fil
		echo "cp $dir$fil"
	fi
done

for k in $alllnk; do
	pat=`echo $k | sed -e "s/\/[^\/]*$/\//" | sed -e "s/^\.//"`
	lnk=`echo $k | sed -e "s/.*\///"`
	if [ "$1" != "-p" ]; then
		cp -d ./$pat$lnk $pat$lnk
	fi
	if [ "$1" == "-v" ]; then
		echo "cp -d ./$pat$lnk $pat$lnk"
	fi
done

exit 0
