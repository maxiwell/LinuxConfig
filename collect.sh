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
				echo "$base$fil does not exist"
			else   
				if [ ! -f ./home/$fil-$computer ]; then
					cp -p $base$fil ./home/$fil-$computer
					echo "cp $base$fil as $line-$computer"
				elif [ $base$fil -nt ./home/$fil-$computer ]; then # f1 is newer than f2
					cp -p $base$fil ./home/$fil-$computer
					echo "cp $base$fil as $line-$computer"
				fi
			fi
			;;
	esac
done < $config

for k in $allfil; do
	dir=`dirname $k | sed -e "s/^\.//" | sed -e "s/\/home//" | sed -e "s/$/\//"`
	fil=`basename $k`

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

