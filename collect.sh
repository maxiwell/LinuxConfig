#!/bin/bash

#allfil=`find $HOME/.{_,[a-zA-Z0-9]}* -iname ._file_* | sed -e "s@\._file_@@g"`
#alllnk=`find $HOME/.{_,[a-zA-Z0-9]}* -iname ._link_* | sed -e "s@\._link_@@g"`
#
#for k in $allfil; do
#	dir=`echo $k | sed -e "s/\/[^\/]*$/\//"`
#	fil=`echo $k | sed -e "s/.*\///"`
#	mkdir -p ./$dir
#	cp /$dir/$fil ./$dir/$fil
#	if [ "$1" == "-v" ]; then
#		echo "cp /$dir/$fil ./$dir/$fil"
#	fi
#done
#
#for k in $alllnk; do
#	dir=`echo $k | sed -e "s/\/[^\/]*$/\//"`
#	lnk=`echo $k | sed -e "s/.*\///"`
#	mkdir -p ./$dir
#	cp /$dir/$lnk ./$dir/$lnk
#	if [ "$1" == "-v" ]; then
#		echo "cp /$dir/$fil ./$dir/$fil"
#	fi
#done
#
allfil=`find ./home/*/ -type f`
alllnk=`find ./home/*/ -type l`

for k in $allfil; do
	dir=`echo $k | sed -e "s/\/[^\/]*$/\//" | sed -e "s/^\.//"`
	fil=`echo $k | sed -e "s/.*\///"`
	imm="._file_"

    if [ $fil == ".gitconfig" ]; then
		echo "skipping .gitconfig"
		continue
	fi
    if [ $fil == ".msmtprc" ]; then
		echo "skipping .msmtprc"
		continue
	fi
    if [ $fil == "inadyn" ]; then
		echo "skipping inadyn"
		continue
	fi



	if [ ! -f $dir$fil ]; then
		echo "$dir$fil does not exist"
    else
            cp $dir$fil ./$dir$fil
    fi
done

for k in $alllnk; do
	pat=`echo $k | sed -e "s/\/[^\/]*$/\//" | sed -e "s/^\.//"`
	lnk=`echo $k | sed -e "s/.*\///"`
	imm="._link_"
	if [ ! -f $pat$lnk ]; then
		echo "$pat$lnk does not exist"
	else
            cp $dir$fil ./$dir$fil
    fi
done

exit 0

