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

# Handling config file (special.conf)
while read line
do
	[[ $line == \#* ]] && continue
	[[ -z $line ]] && continue
	[[ $line == \[* ]] && cond=`echo $line | cut -d[ -f 2 | cut -d] -f 1` && continue

	case $cond in
		ignore)
            # simply remove the file from find list if exist 
            if [ -a $base/$line ]; then
			    allfil=`echo "$allfil" | sed -e "s@./home/$line@@g"`		
            fi

			;;
		unique)
			# remove the unique files2
			allfil=`echo "$allfil" | sed -e 's|\.\/home\/'$line'--[^$ ]*||g'`

			fil="/$line"

			if [ ! -f ./home/$fil--$computer ]; then
				echo "$line without specific version for the machine $computer."
				continue
			fi

		    cp -p ./home/$fil--$computer $base$fil
            echo "cp $base$fil from $line--$computer"
			;;
	esac
done < $config

# Handling submodule cases
for k in $submodules; do
	dir=`dirname $k | sed -e "s/^\.//" | sed -e "s/home//" | sed -e "s/$/\//"`
    fil=`basename $k`
    if [ ! -s $base$dir$fil ]; then
        mkdir -p $bash$dir
        ln -s $_pwd/$k $base$dir$fil
        echo "[submodules] Link created: $_pwd/$k -> $base$dir$fil"
    else
        if [ ! -L $base$dir$fil ]; then
            echo "[submodules] Conflict: The folder $base$dir$fil should be a link to  $_pwd/$k"
        fi
    fi
done

IFS=$'\n'
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

#	if [ ./home/$dir$fil -nt $base$dir$fil ]; then # f1 is newer than f2
		cp -p ./home/$dir$fil $base$dir$fil
		echo "cp $base$dir$fil"
#	fi
done

exit 0
