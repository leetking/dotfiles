#!/bin/bash

# 对任意文件进行编译的脚本，供给vim的make调用
# 调用形式:
# makeprg <workspace> <filename> [<makeopt>]
# <workspace>: 当前工作空间
# <filename>: 当前编辑文件的文件名
# <makeopt>: make时的选项，例如: make clean中的clean

WORKSPACE="$1"
FILENAME="$2"
MAKEOPT="$3"

# 编译c/c++
makeccpp() {
    _cc="$1"
    _makefilelist=(Makefile makefile)
    _make=make

    # 遍历可能的makefile文件，存在就进行处理
    for i in ${_makefilelist}; do
        if [ -e "$i" ]; then
            ${_make} -f "$i" ${MAKEOPT}
            exit 0
        fi
    done
    # OK,没有makefile文件，最简单的gcc编译
    ${_cc} -o "${FILENAME%%.c}" "${FILENAME}" -Wall -lm -g -DDEBUG
    exit 0
}

# 编译java，目前就采用gradle
makejava() {
    _cc=javac
    _builds=(build.gradle build.xml)
    _gradle=gradle
    for i in ${_builds}; do
        if [ -e "$i" ]; then
            ${_gradle} ${MAKEOPT}
            exit 0
        fi
    done

    ${_cc} -d . "${FILENAME}"
    exit 0
}

case "${2##*.}" in
    c|h)            makeccpp gcc ;;
    cpp|C|cxx)      makeccpp g++ ;;
    java|gradle)    makejava ;;
    *) ;;
esac
