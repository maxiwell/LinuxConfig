#!/bin/bash

DIR=`pwd`'/.tags'


collect_cscope() {
    cscope -b -q -i $DIR/files
    mv cscope.* $DIR
}


collect_ctags() {
    #CTAGS_EXTRA_ARGS="--c++-kinds=+p --fields=+iaS --language-force=C++"
    CTAGS_EXTRA_ARGS="--fields=+iaS"

    ctags --append=yes $CTAGS_EXTRA_ARGS -L $DIR/files -o $DIR/ctags
}


usage() {
    echo "$(basename $0) <option> ./path_1 ./path_N"
    echo ""
    echo "   options:"
    echo "      -c   : Find only .c and .h files"
    echo "      -c++ : Find only .cpp, .cc, and .h files"
    echo "      -py  : Find only .py files"
    echo "      -php : Find only .php files"
    echo ""
}

# -----
# MAIN
# -----

rm -rf ${DIR}
mkdir -p ${DIR}
ARGS=""

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

for i in $@; do

    case "$i" in
        -c)
            ARGS="${ARGS} c "
            shift
            ;;
        -c++)
            ARGS="${ARGS} cpp "
            shift
            ;;
        -py)
            ARGS="${ARGS} py "
            shift
            ;;
        -php)
            ARGS="${ARGS} php "
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
            if [[ $ARGS == "" ]]; then
                usage
                exit 1
            fi

            cd $i
            if [[ $ARGS == *" c "* ]]; then
                find `pwd` -iname '*.c' | grep -v build\/ >> $DIR/files
                find `pwd` -iname '*.h' | grep -v build\/ >> $DIR/files
            fi
            if [[ $ARGS == *" cpp "* ]]; then
                find `pwd` -iname '*.cpp' -o -iname '*.cc' | grep -v build\/ >> $DIR/files
                find `pwd` -iname '*.h' | grep -v build\/ >> $DIR/files
            fi
            if [[ $ARGS == *" py "* ]]; then
                find `pwd` -iname '*.py' | grep -v build\/ >> $DIR/files
            fi
            if [[ $ARGS == *" php "* ]]; then
                find `pwd` -iname '*.php' | grep -v build | grep -v vendor >> $DIR/files
            fi
            cd - &> /dev/null

            echo "Collecting tags..."
            collect_ctags
            collect_cscope
    esac
done


