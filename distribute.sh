#!/bin/bash

allfil=`find ./home/ -type f`

base=$HOME
computer=$HOSTNAME
config="./special.conf"

while read line
do
	[[ $line == \#* ]] && continue
	[[ -z $line ]] && continue
	[[ $line == \[* ]] && cond=`echo $line | cut -d[ -f 2 | cut -d] -f 1` && continue

	case $cond in
		ignore)
			# simply remove the file from find list 
			allfil=`echo $allfil | sed -e "s@./home/$line@@g"`		
			;;
		unique)
			# remove the unique files2
			allfil=`echo $allfil | sed -e "s/\.\/home\/${line}--[^ ]* //g"`

			fil="/$line"

			if [ ! -f ./home/$fil--$computer ]; then
				echo "$line without specific version for the machine $computer."
				continue
			fi

			if [ ! -f $base$fil ] || [ ./home/$fil--$computer -nt $base$fil ]; then
				cp -p ./home/$fil--$computer $base$fil
				echo "cp $base$fil from $line--$computer"
			fi
			;;
	esac
done < $config


for k in $allfil; do
	dir=`dirname $k | sed -e "s/^\.//" | sed -e "s/\/home//" | sed -e "s/$/\//"`
	fil=`basename $k`

	if [ ! -d $base$dir ]; then
		mkdir -p $base$dir
	fi

	if [[ $fil == *$computer* ]]; then
		echo "$dir$fil was in the [unique] case. Now, it is not. Fix it manually."
		continue
	fi

	if [ ./home/$dir$fil -nt $base$dir$fil ]; then # f1 is newer than f2
		cp -p ./home/$dir$fil $base$dir$fil
		echo "cp $base$dir$fil"
	fi
done

exit 0
