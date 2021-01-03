#!/usr/bin/env bash

# Crate project or file from template.
# (C) leetking <li_Tking@163.com>
# License: GPL v3

INSTALL_PATH=$(dirname $(realpath `which new`))
WORK_PATH=$(pwd -P)
# Import some tools
PATH=$PATH:$INSTALL_PATH/parts

PROJECT_LOCATION=https://github.com/leetking/dotfiles/tree/master/tools/new.sh

Usage() {
    echo "Usage: new [<category>] [<type>] | filename.type"
    echo "           <category>: p  --project."
    echo "           type: c/cc/acm"
    echo ""
    echo "More details please see "
    echo " > ${PROJECT_LOCATION} ."
    echo "Create project or file from template."
    echo "(C) leetking <li_Tking@163.com>"
}

ExistOrQuit() {
    if [ -e "$1" ]; then
        echo "There are \"$1\", I cant create!"
        exit 1
    fi
}

NewProject() {
    case "$1" in
        c)
            new-c-project "${WORK_PATH}"
            ;;
        cc)
            new-cpp-project "${WORK_PATH}"
            ;;
        java)
            new-java-project "${WORK_PATH}"
            ;;
        *)
            echo "NewProject: Type of project \"$1\" is not supported."
            Usage
            ;;
    esac
}

if [ 0 -eq $# -o "-h" == "$1" ]; then
    Usage
    exit 0
fi

if [ "p" == "$1" ]; then
    NewProject "$2"
    exit 0
else
    while [ 0 -ne $# ]; do
        case "${1##*.}" in
            c)
                ExistOrQuit "$1"
                # echo "cp $INSTALL_PATH/template/c.c $WORK_PATH/\"$1\""
                cp $INSTALL_PATH/template/c.c $WORK_PATH/"$1"
                ;;
            cc)
                # echo "cp $INSTALL_PATH/template/cpp.cc $WORK_PATH/\"$1\""
                ExistOrQuit "$1"
                cp $INSTALL_PATH/template/cpp.cc $WORK_PATH/"$1"
                ;;
            acm)
                # echo "cp $INSTALL_PATH/template/acm.cc $WORK_PATH/\"${1%%.acm}.cc\""
                ExistOrQuit "${1%%.acm}.cc"
                cp $INSTALL_PATH/template/acm.cc $WORK_PATH/"${1%%.acm}.cc"
                ;;
            ltc)
                ExistOrQuit "${1%%.ltc}.cc"
                cp $INSTALL_PATH/template/ltc.cc $WORK_PATH/"${1%%.ltc}.cc"
                ;;
            *)
                echo "NewFile: Cant support template of \"${1##*.}\"."
                Usage
                exit 0
                ;;
        esac
        shift
    done
fi
