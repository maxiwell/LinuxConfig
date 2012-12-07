#!/bin/bash

allfil=`find $HOME/.{_,[a-zA-Z0-9]}* -iname ._file_* | sed -e "s@\._file_@@g"`
alllnk=`find $HOME/.{_,[a-zA-Z0-9]}* -iname ._link_* | sed -e "s@\._link_@@g"`

for k in $allfil; do
	dir=`echo $k | sed -e "s/\/[^\/]*$/\//"`
	fil=`echo $k | sed -e "s/.*\///"`
	mkdir -p ./$dir
	cp /$dir/$fil ./$dir/$fil
	if [ "$1" == "-v" ]; then
		echo "cp /$dir/$fil ./$dir/$fil"
	fi
done

for k in $alllnk; do
	dir=`echo $k | sed -e "s/\/[^\/]*$/\//"`
	lnk=`echo $k | sed -e "s/.*\///"`
	mkdir -p ./$dir
	cp /$dir/$lnk ./$dir/$lnk
	if [ "$1" == "-v" ]; then
		echo "cp /$dir/$fil ./$dir/$fil"
	fi
done

allfil=`find ./home/*/ -type f`
alllnk=`find ./home/*/ -type l`

for k in $allfil; do
	dir=`echo $k | sed -e "s/\/[^\/]*$/\//" | sed -e "s/^\.//"`
	fil=`echo $k | sed -e "s/.*\///"`
	imm="._file_"
	if [ ! -f $dir$imm$fil ]; then
		echo "$dir$imm$fil does not exist"
	fi
done

for k in $alllnk; do
	pat=`echo $k | sed -e "s/\/[^\/]*$/\//" | sed -e "s/^\.//"`
	lnk=`echo $k | sed -e "s/.*\///"`
	imm="._link_"
	if [ ! -f $pat$imm$lnk ]; then
		echo "$pat$imm$lnk does not exist"
	fi
done

exit 0

