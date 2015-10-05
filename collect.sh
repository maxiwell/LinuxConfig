#!/bin/bash


config="./special.conf"
base=$HOME
computer=$HOSTNAME

_pwd=$PWD

# -----------------

submodules=`cat .gitmodules | grep submodule | cut -d\" -f2`

# Removing submodules folder from 'allfill' list 
for i in $submodules; do
    extract_folders+="-not -path \"./$i/*\" "
done
find_command="find ./home/ -type f $extract_folders"

allfil=$(eval $find_command)

# filter="$HOME/.rsync-filter"

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
			# remove the unique files
			allfil=`echo $allfil | sed -e 's|\.\/home\/'$line'--[^ ]* ||g'`

			# for first run after inserting a new file in [unique] case
			# remove the name without $HOSTNAME termination
			if [ -f ./home/$line ]; then
				rm -f ./home/$line
				allfil=`echo $allfil | sed -e "s@./home/$line@@g"`
			fi

			fil="/$line"
			if [ ! -f $base$fil ]; then
				echo "$base$fil does not exist"
            else
				cp -p $base$fil ./home/$fil--$computer
#				echo "cp $base$fil as $line--$computer"	
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
		#rsync -razp  --delete --exclude-from="$filter" $base$dir$fil ./home/$dir
		cp -p $base$dir$fil ./home/$dir$fil
		# echo "rsync $base$dir$fil"
	fi
done

exit 0

