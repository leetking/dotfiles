#!/bin/bash

#install.sh [-a{i|r}] [-b{i|r}] [-v{i|r}] [-fo{i|r}] [-fv{i|r}] [-t{|r}] [-r{i|r}]

#引入环境变量
source vars.sh

Help()
{
	echo "Usage: $0 [-a{i|r}] [-b{i|r}] [-v{i|r}]"
	echo "-a{i|r}    all:    all configures."
	echo "-b{i|r}    bashrc: i, install r, remove; -bi or -br."
	echo "-v{i|r}    vimrc:  i, install r, remove; -vi or -vr."
	echo "-fo{i|r}   fonts:  i, install r, remove; -foi or -for."
	echo "-fv{i|r}   fvwm:   i, install r, remove; -fvi or -fvr."
	echo "-t{i|r}    tmux:   i, install r, remove; -ti or -tr."
	echo "-r{i|r}    rxvt:   i, install r, remove; -ri or -rr."
}
Installall()
{
	install/bash.sh $1
	install/vim.sh $1
	install/fonts.sh $1
	install/fvwm.sh $1
	install/tmux.sh $1
	install/rxvt.sh $1
	if [ $1 == "r" ]; then
		rm -rf $INSTALL_PATH
		echo "全部卸载完成"
	fi
}

#目前只支持全部安装或卸载，或者某一个安装或卸载，不支持如bash或vim同时安装或卸载
#NOTE
if [ 1 >= $# ]; then
	help
	exit 1
fi

case "${1:1:(-1)}" in
	"a") Installall -${1:(-1):1} ;;
	"b") install/bash.sh -${1:(-1):1} ;;
	"v") install/vim.sh -${1:(-1):1} ;;
	"fo") install/fonts.sh -${1:(-1):1} ;;
	"fv") install/fvwm.sh -${1:(-1):1} ;;
	"t") install/tmux.sh -${1:(-1):1} ;;
	"r") install/rxvt.sh -${1:(-1):1} ;;
	*) Help ;;
esac
