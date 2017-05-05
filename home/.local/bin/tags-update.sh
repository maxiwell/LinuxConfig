#!/bin/bash

# Only cpp/cc is important here. The YouCompleteMe will take care of the rest =)
find `pwd` -iname *.cpp -o -iname *.cc | grep -v build\/ > tags.files
ctags --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ -L tags.files -o ctags
cscope -b -q -i tags.files
rm tags.files

