#!/bin/bash

# 在线安装sdcv的字典库

CURR_PATH=$(cd `dirname $0`; pwd -P)

MIRROR=http://download.huzheng.org
readonly zh_CN_DICTS=(stardict-langdao-ec-gb-2.4.2.tar.bz2
    stardict-langdao-ce-gb-2.4.2.tar.bz2
    stardict-CET4-2.4.2.tar.bz2
    stardict-jilin_jc-2.4.2.tar.bz2
    stardict-chengyuda-2.4.2.tar.bz2
)
readonly ja_DICTS=(stardict-kanjidic2-2.4.2.tar.bz2
)

Tarfile() {
    local args=
    case ${1##*.} in
        gz)  args=z ;;
        bz2) args=j ;;
        xz)  args=J ;;
        *) ;;
    esac
    echo "tar -x${args}f ${CURR_PATH}/$1 -C ${CURR_PATH} ..."
    tar -x${args}f "${CURR_PATH}/$1" -C ${CURR_PATH}
}
Download() {
    if [ `which aria2c` ]; then
        echo "aria2c -c -x 5 -j 5 $1 -d ${CURR_PATH} -o $2"
        aria2c -c -x 5 -j 5 $1 -d "${CURR_PATH}" -o "$2"
    else
        echo "wget -c -v $1 -O $2"
        wget -c -v "$1" -O "${CURR_PATH}/$2"
    fi
}

InstallDict() {
    local url=
    for i in ${zh_CN_DICTS[@]}; do
        url="${MIRROR}/zh_CN/$i"
        Download "$url" "$i"
        Tarfile "$i"
    done
    for i in ${ja_DICTS[@]}; do
        url="${MIRROR}/ja/$i"
        Download "$url" "$i"
        Tarfile "$i"
    done
}

# 开始安装!
[ `which sdcv` ] && InstallDict
