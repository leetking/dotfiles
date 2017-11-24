#!/usr/bin/env bash

DEBUG=1

INSTALL_PATH=$(dirname $(realpath `which search`))
WORK_PATH=$(pwd -P)
PATH=$PATH:$INSTALL_PATH/

# default configuretion
USE_BROWSER=0
SEARCH_ENGINE="duckduckgo"

# import configuretion
. $INSTALL_PATH/configrc

Usage() {
    cat << EOF
$0 keyword
EOF
}

# DISPLAY

D() {
    if [ "1" == "$DEBUG" ]; then
        echo $1
    fi
}


if [ $# -lt 1 ]; then
    Usage
    exit 0
fi

if [ "1" == "$USE_BROWSER" ]; then
    D "browser"
    ./search.brw.sh "$BROWSER" "$SEARCH_ENGINE" "$1"
else
    D "command line"
    ./search.cli.py "$SEARCH_ENGINE" "$1"
fi
