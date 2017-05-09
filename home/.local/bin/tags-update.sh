#!/bin/bash

DIR='.tags'
mkdir -p $DIR

# Only c/cpp/cc is important for ctags. The YouCompleteMe/CSCOPE will take care of the rest =)
if [[ "$1" == "c" ]]; then
    find `pwd` -iname '*.c' | grep -v build\/ > $DIR/ctags.files
    find `pwd` -iname '*.c' -o -iname '*.h' | grep -v build\/ > $DIR/cscope.files
    CTAGS_EXTRA_ARGS=
else
    find `pwd` -iname '*.cpp' -o -iname '*.cc' | grep -v build\/ > $DIR/ctags.files
    find `pwd` -iname '*.cpp' -o -iname '*.cc' -o -iname '*.h' | grep -v build\/ > $DIR/cscope.files
    CTAGS_EXTRA_ARGS="--language-force=C++"
fi

ctags --c++-kinds=+p --fields=+iaS --extra=+q $CTAGS_EXTRA_ARGS -L $DIR/ctags.files -o $DIR/ctags
cscope -b -q -i $DIR/cscope.files
mv cscope.* $DIR

