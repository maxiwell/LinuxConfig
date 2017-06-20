#!/bin/bash

DIR=`pwd`'/.tags'
mkdir -p $DIR


collecting_ctags() {
    cd $1

    # Only c/cpp/cc is important for ctags. The YouCompleteMe/CSCOPE will take care of the rest =)
    find `pwd` -iname '*.c' | grep -v build\/ > $DIR/ctags.files
    CTAGS_EXTRA_ARGS="--fields=+iaS --extra=+q"
    ctags $CTAGS_EXTRA_ARGS -L $DIR/ctags.files -o $DIR/ctags
    
    find `pwd` -iname '*.cpp' -o -iname '*.cc' | grep -v build\/ > $DIR/ctags.files
    CTAGS_EXTRA_ARGS="--c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++"
    ctags --append=yes $CTAGS_EXTRA_ARGS -L $DIR/ctags.files -o $DIR/ctags

    cd - &> /dev/null
}


collecting_cscope() {
    cd $1

    find `pwd` -iname '*.c' -o -iname '*.h' | grep -v build\/ > $DIR/cscope.files
    find `pwd` -iname '*.cpp' -o -iname '*.cc' -o -iname '*.h' | grep -v build\/ >> $DIR/cscope.files
    cscope -b -q -i $DIR/cscope.files
    mv cscope.* $DIR

    cd - &> /dev/null
}


for i in `pwd` $@; do
    echo "Collecting from $i..."
    collecting_ctags $i
    collecting_cscope $i
done


