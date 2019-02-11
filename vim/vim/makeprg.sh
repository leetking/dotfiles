#!/bin/bash

# 对任意文件进行编译的脚本，供给vim的make调用
# 调用形式:
# makeprg <filename> [<opts>]
# <filename>: 当前编辑文件的文件名
# <opts>: make时的选项，例如: make clean中的clean
# TODO 格式化quickfix的信息

FILENAME="$1"
OPTS="$2"
PRGARGS="${@:3}"

BROWSER=chromium
CC=gcc
CXX=g++
#which clang   > /dev/null 2>&1 && CC=clang
#which clang++ > /dev/null 2>&1 && CXX=clang++
COPTS_COM="-O0 -pedantic -Wall -Wformat -lm -g -DDEBUG -fsanitize=address"
CXXOPTS="$COPTS_COM -std=c++11"
COPTS="$COPTS_COM -std=gnu99"

# 编译c/c++
makeccpp() {
    local _cc=$1
    local _makefilelist=(Makefile makefile)
    local _make=make

    # 遍历可能的makefile文件，存在就进行处理
    for i in ${_makefilelist}; do
        if [ -e "$i" ]; then
            ${_make} -f "$i" ${OPTS}
            exit 0
        fi
    done

    if [ "${_cc}" == "$CC" ]; then
        local opts="$COPTS"
    else
        local opts="$CXXOPTS"
    fi

    # 对于简单程序的管理
    case "${OPTS}" in
        clean|c)
            echo "rm -rf ${FILENAME%.*}.o ${FILENAME%.*}"
            rm -rf "${FILENAME%.*}.o" "${FILENAME%.*}"
            ;;
        cleanall|ca)
            echo "rm -f *.o core"
            rm -f *.o core
            for i in `ls *.{c,C,cpp,cxx,cc} 2> /dev/null`; do
                echo "rm -f ${i%.*}"
                rm -f "${i%.*}"
            done
            ;;
        run|r)
            PATH="."
            echo "Run ${FILENAME%.*} ${PRGARGS}"
            ${FILENAME%.*} ${PRGARGS}
            ;;
        debug|d)
            PATH=".:$PATH"
            echo "gdb ${FILENAME%.*}"
            gdb ${FILENAME%.*}
            ;;
        *)
            echo "${_cc} -o ${FILENAME%.*} ${FILENAME} $opts"
            ${_cc} -o "${FILENAME%.*}" "${FILENAME}" $opts
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

    # 单个java文件
    package=$(grep -oP '(?<=package)\s+[\w\.]+' "${FILENAME}" | grep -oP '[\w\.]+')
    case "${OPTS}" in
        cleanall|ca)
            echo "rm -f *.class"
            rm -f *.class
            for i in `ls *.java 2> /dev/null`; do
                package=$(grep -oP '(?<=package)\s+[\w\.]+' "$i" | grep -oP '[\w\.]+')
                if [ -z "${package}" ]; then
                    echo "rm -f ${FILENAME%.*}.class"
                    rm -f ${FILENAME%.*}.class
                else
                    echo "rm -rf ${package%%.*}"
                    rm -rf ${package%%.*}
                fi
            done
            ;;
        clean|c)
            if [ -z "${package}" ]; then
                echo "rm -f ${FILENAME%.*}.class"
                rm -f ${FILENAME%.*}.class
            else
                echo "rm -rf ${package%%.*}"
                rm -rf ${package%%.*}
            fi
            ;;
        run|r)
            mainclass=${FILENAME%.*}
            if [ ! -z "$package" ]; then
                mainclass=${package}.${mainclass}
            fi
            echo "java ${mainclass}"
            java ${mainclass}
            ;;
        debug|d)
            mainclass=${FILENAME%.*}
            if [ ! -z "$package" ]; then
                mainclass=${package}.${mainclass}
            fi
            echo "jdb ${mainclass}"
            jdb ${mainclass}
            ;;
        *)
            echo "${_cc} -d . ${FILENAME}"
            ${_cc} -d . "${FILENAME}"
            ;;
    esac
    exit 0
}

case "${FILENAME##*.}" in
    c|h|s|asm)      makeccpp ${CC};;
    cpp|C|cxx|cc)   makeccpp ${CXX};;
    java|gradle)    makejava ;;
    *) ;;
esac
