#!/bin/bash

# 对任意文件进行编译的脚本，供给vim的make调用
# 调用形式:
# makeprg <workspace> <filename> [<opts>]
# <workspace>: 当前工作空间
# <filename>: 当前编辑文件的文件名
# <opts>: make时的选项，例如: make clean中的clean
# TODO 格式化quickfix的信息

WORKSPACE="$1"
FILENAME="$2"
OPTS="$3"
PRGARGS="${@:4}"

# 编译c/c++
makeccpp() {
    local _cc="$1"
    local _makefilelist=(Makefile makefile)
    local _make=make

    # 遍历可能的makefile文件，存在就进行处理
    for i in ${_makefilelist}; do
        if [ -e "$i" ]; then
            ${_make} -f "$i" ${OPTS}
            exit 0
        fi
    done

    # 对于简单程序的管理
    case "${OPTS}" in
        clean|c)
            echo "rm -rf ${FILENAME%.*}.o ${FILENAME%.*}"
            rm -rf "${FILENAME%.*}.o" "${FILENAME%.*}"
            ;;
        cleanall|ca)
            echo "rm -rf *.o core"
            rm -rf *.o core
            for i in `ls *.c *.C *.cpp *.cxx 2> /dev/null`; do
                echo "rm -rf ${i%.*}"
                rm -rf "${i%.*}"
            done
            ;;
        run|r)
            echo "./${FILENAME%.*} ${PRGARGS}"
            ./${FILENAME%.*} ${PRGARGS}
            ;;
        debug|d)
            echo "gdb ./${FILENAME%.*}"
            gdb ./${FILENAME%.*}
            ;;
        *)
            echo "${_cc} -o ${FILENAME%.*} ${FILENAME} -Wall -Wformat -lm -g -DDEBUG"
            ${_cc} -o "${FILENAME%.*}" "${FILENAME}" -Wall -Wformat -lm -g -DDEBUG
            ;;
    esac
    exit 0
}

# 编译java，目前就采用gradle
makejava() {
    local _cc=javac
    local _builds=(build.gradle build.xml)
    local _gradle=gradle
    for i in ${_builds}; do
        if [ -e "$i" ]; then
            ${_gradle} ${OPTS}
            exit 0
        fi
    done

    ${_cc} -d . "${FILENAME}"
    exit 0
}

CC=gcc
CXX=g++
which clang   > /dev/null 2>&1 && CC=clang
which clang++ > /dev/null 2>&1 && CXX=clang++

case "${2##*.}" in
    c|h|s|asm)      makeccpp ${CC};;
    cpp|C|cxx)      makeccpp ${CXX};;
    java|gradle)    makejava ;;
    *) ;;
esac
