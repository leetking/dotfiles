#!/bin/bash

#install.sh [-a{i|r}] [-b{i|r}] [-v{i|r}] [-fo{i|r}] [-fv{i|r}] [-t{|r}] [-r{i|r}]

#引入环境变量
hash dirname || { echo "ERROR: 需要安装dirname"; exit 1; }
INSTALL_PATH=~/.myconfigures
CURR_PATH=`dirname $0`

Help()
{
	#echo "Usage: $0 [-a{i|r}] [-b{i|r}] [-v{i|r}] [-fo{i|r}] [-fv{i|r}] [-t{|r}] [-r{i|r}]"
	echo "Usage: $0 [-a{i|r}] [-b{i|r}] [-v{i|r}] [-fv{i|r}] [-t{|r}] [-r{i|r}]"
	echo -e "\t-a{i|r}    all:    all configures."
	echo -e "\t-b{i|r}    bashrc: i, install r, remove; -bi or -br."
	echo -e "\t-v{i|r}    vimrc:  i, install r, remove; -vi or -vr."
	#echo -e "\t-fo{i|r}   fonts:  i, install r, remove; -foi or -for."
	echo -e "\t-fv{i|r}   fvwm:   i, install r, remove; -fvi or -fvr."
	echo -e "\t-t{i|r}    tmux:   i, install r, remove; -ti or -tr."
	echo -e "\t-r{i|r}    rxvt:   i, install r, remove; -ri or -rr."
}
Installall()
{
	if [ -e $CURR_PATH/install/bash.sh ]; then
		$CURR_PATH/install/bash.sh $1
	fi
	if [ -e $CURR_PATH/install/vim.sh ]; then
		$CURR_PATH/install/vim.sh $1
	fi
	if [ -e $CURR_PATH/install/fonts.sh ]; then
		$CURR_PATH/install/fonts.sh $1
	fi
	if [ -e $CURR_PATH/install/fvwm.sh ]; then
		$CURR_PATH/install/fvwm.sh $1
	fi
	if [ -e $CURR_PATH/install/tmux.sh ]; then
		$CURR_PATH/install/tmux.sh $1
	fi
	if [ -e $CURR_PATH/install/rxvt.sh ]; then
		$CURR_PATH/install/rxvt.sh $1
	fi
	if [ $1 == "-r" ]; then
		rm -rf $INSTALL_PATH
		echo "全部卸载完成"
	fi
}

#目前只支持全部安装或卸载，或者某一个安装或卸载，不支持选项合并写法
if [ 2 -lt $# ]; then
	Help
	exit 1
fi

case "${1:1:(-1)}" in
	"a") Installall -${1:(-1):1} ;;
	"b") $CURR_PATH/install/bash.sh -${1:(-1):1} ;;
	"v") $CURR_PATH/install/vim.sh -${1:(-1):1} ;;
	"fo") $CURR_PATH/install/fonts.sh -${1:(-1):1} ;;
	"fv") $CURR_PATH/install/fvwm.sh -${1:(-1):1} ;;
	"t") $CURR_PATH/install/tmux.sh -${1:(-1):1} ;;
	"r") $CURR_PATH/install/rxvt.sh -${1:(-1):1} ;;
	*) Help; exit 1 ;;
esac
