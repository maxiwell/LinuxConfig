#!/bin/bash

# Only c/cpp/cc is important here. The YouCompleteMe will take care of the rest =)
if [[ "$1" == "c" ]]; then
    find `pwd` -iname '*.c' | grep -v build\/ > tags.files
    CTAGS_EXTRA_ARGS=
else
    find `pwd` -iname *.cpp -o -iname *.cc | grep -v build\/ > tags.files
    CTAGS_EXTRA_ARGS="--language-force=C++"
fi

ctags --c++-kinds=+p --fields=+iaS --extra=+q $CTAGS_EXTRA_ARGS -L tags.files -o ctags
cscope -b -q -i tags.files

