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
			allfil=`echo $allfil | sed -e "s@./home/$line-$computer@@g"`

			fil="/$line"
			
			if [ ! -f $base$fil ]; then
				cp -p ./home/$fil-$computer $base$fil
				echo "cp $base$fil from $line-$computer"
			elif [ ./home/$fil-$computer -nt $base$fil ]; then # f1 is newer than f2
				cp -p ./home/$fil-$computer $base$fil
				echo "cp $base$fil from $line-$computer"
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

	if [ ./home/$dir$fil -nt $base$dir$fil ]; then # f1 is newer than f2
		cp -p ./home/$dir$fil $base$dir$fil
		echo "cp $base$dir$fil"
	fi
done

exit 0
