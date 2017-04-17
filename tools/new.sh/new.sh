#!/usr/bin/env bash

# Crate project or file from template.
# (C) leetking <li_Tking@163.com>
# License: GPL v3

INSTALL_PATH=$(dirname $(realpath `which new`))
WORK_PATH=$(pwd -P)
# Import some tools
PATH=$PATH:$INSTALL_PATH/parts

PROJECT_LOCATION=https://github.com/leetking/dotfiles/tools/new.sh/README.md

Usage() {
    echo "Usage: new [<category>] [<type>] | filename.type"
    echo "           <category>: p  --project."
    echo "           type: c/cpp/acm"
    echo ""
    echo "More details please see "
    echo " > ${PROJECT_LOCATION}."
    echo "Create project or file from template."
    echo "(C) leetking <li_Tking@163.com>"
}

CheckExist() {
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
        cpp)
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
                CheckExist "$1"
                # echo "cp $INSTALL_PATH/template/c.c $WORK_PATH/\"$1\""
                cp $INSTALL_PATH/template/c.c $WORK_PATH/"$1"
                ;;
            cpp)
                # echo "cp $INSTALL_PATH/template/cpp.cpp $WORK_PATH/\"$1\""
                CheckExist "$1"
                cp $INSTALL_PATH/template/cpp.cpp $WORK_PATH/"$1"
                ;;
            acm)
                # echo "cp $INSTALL_PATH/template/acm.cpp $WORK_PATH/\"${1%%.acm}.cpp\""
                CheckExist "${1%%.acm}.cpp"
                cp $INSTALL_PATH/template/acm.cpp $WORK_PATH/"${1%%.acm}.cpp"
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
