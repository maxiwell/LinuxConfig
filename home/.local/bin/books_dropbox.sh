#!/bin/bash

ebooks=/home/max/Dropbox/eBooks/
pdfs=/home/max/Dropbox/pdfs/

allbooks=/files/backup/powernote/media/files/livros/

cd $ebooks 
for i in *; 
    do 
        if test $( find $allbooks -iname "$i" | wc -l) -eq 0 ; then 
            echo $i; 
        fi; 
    done
cd - &> /dev/null

cd $pdfs
for i in *; 
    do 
        if test $( find $allbooks -iname "$i" | wc -l) -eq 0 ; then 
            echo $i; 
        fi ; 
    done
cd - &> /dev/null




