#!/bin/bash

DIR=`pwd`'/.tags'

collecting_ctags() {
    cd $1

    if [[ "$2" != "c++" ]]; then
        # Only c/cpp/cc is important for ctags. The YouCompleteMe/CSCOPE will take care of headers
        find `pwd` -iname '*.c' | grep -v build\/ >> $DIR/ctags.files
        CTAGS_EXTRA_ARGS="--fields=+iaS"
    fi

    if [[ "$2" != "c" ]]; then
        find `pwd` -iname '*.cpp' -o -iname '*.cc' | grep -v build\/ >> $DIR/ctags.files
        CTAGS_EXTRA_ARGS="--c++-kinds=+p --fields=+iaS --language-force=C++"
    fi

    ctags --append=yes $CTAGS_EXTRA_ARGS -L $DIR/ctags.files -o $DIR/ctags

    cd - &> /dev/null
}


collecting_cscope() {
    cd $1

    if [[ "$2" != "c++" ]]; then
        find `pwd` -iname '*.c' | grep -v build\/ >> $DIR/cscope.files
    fi

    if [[ "$2" != "c" ]]; then
        find `pwd` -iname '*.cpp' -o -iname '*.cc' | grep -v build\/ >> $DIR/cscope.files
    fi

    find `pwd` -iname '*.h' | grep -v build\/ >> $DIR/cscope.files

    cscope -b -q -i $DIR/cscope.files
    mv cscope.* $DIR

    cd - &> /dev/null
}


usage() {
    echo "$(basename $0) <option> ./path_1 ./path_N"
    echo ""
    echo "   options:"
    echo "      --only-c   : Find only .c and .h files"
    echo "      --only-c++ : Find only .cpp, .cc, and .h files"
    echo "      --all      : Find c and c++ files (default)"
    echo ""
}

# -----
# MAIN
# -----

ARGS="all"

rm -rf ${DIR}
mkdir -p ${DIR}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

for i in $@; do

    case "$i" in
        --only-c)
            ARGS="c"
            shift
            ;;
        --only-c++)
            ARGS="c++"
            shift
            ;;
        --all)
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        -*)
            echo "ERROR: option $i not found"
            usage
            exit 2
            ;;
        *)
            echo "Collecting $ARGS files from $i"
            collecting_ctags $i $ARGS
            collecting_cscope $i $ARGS
    esac
done


