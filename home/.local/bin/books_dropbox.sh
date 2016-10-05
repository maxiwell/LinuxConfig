#!/bin/bash

ebooks=/home/max/Dropbox/eBooks/
pdfs=/home/max/Dropbox/Livros/

pushd $ebooks 
for i in *; do if test $( find /media/files/livros/ -iname "$i" | wc -l) -eq 0 ; then echo $i; fi ; done
popd

pushd $pdfs
for i in *; do if test $( find /media/files/livros/ -iname "$i" | wc -l) -eq 0 ; then echo $i; fi ; done
popd




