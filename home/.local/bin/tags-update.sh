#!/bin/bash

DIR='.tags'
mkdir -p $DIR

# Only c/cpp/cc is important here. The YouCompleteMe will take care of the rest =)
if [[ "$1" == "c" ]]; then
    find `pwd` -iname '*.c' | grep -v build\/ > $DIR/tags.files
    CTAGS_EXTRA_ARGS=
else
    find `pwd` -iname *.cpp -o -iname *.cc | grep -v build\/ > $DIR/tags.files
    CTAGS_EXTRA_ARGS="--language-force=C++"
fi

ctags --c++-kinds=+p --fields=+iaS --extra=+q $CTAGS_EXTRA_ARGS -L $DIR/tags.files -o $DIR/ctags
cscope -b -q -i $DIR/tags.files
mv cscope.* $DIR

