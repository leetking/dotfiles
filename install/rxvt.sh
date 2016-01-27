#!/bin/bash

#安装、卸载rxvt的配置文件
# -i安装
# -r卸载
# -h帮助

hash dirname || { echo "ERROR: 需要安装dirname"; exit 1; }
INSTALL_PATH=~/.myconfigures
CURR_PATH=`dirname $0`/..
RXVT_PATH=$INSTALL_PATH/rxvt
BACKUP_PATH=$INSTALL_PATH/backups/rxvt
STATES_PATH=$INSTALL_PATH/states/rxvt
INSTALL_SCRIPT=$INSTALL_PATH/install/rxvt.sh
Help() {
	echo "Usage: $0 [-i]|[-r]|[-h]"
	echo -e "\t-i install, 安装"
	echo -e "\t-r remove, 卸载"
	echo -e "\t-h 显示这个页面"
}
Install() {
	echo "开始安装rxvt的配置文件..."
	if [ -f $STATES_PATH ]; then
		echo "rxvt的配置文件已经安装好了"
		exit 0
	fi
	mkdir -P $BACKUP_PATH 2> /dev/null
	mv ~/.Xdefaults $BACKUP_PATH/Xdefaults 2> /dev/null
	cp -rf $CURR_PATH/rxvt $INSTALL_PATH/rxvt
	ln -sf $RXVT_PATH/Xdefaults ~/.Xdefaults
	mkdir -P $INSTALL_PATH/install 2> /dev/null
	cp $CURR_PATH/install/rxvt.sh $INSTALL_SCRIPT
	cp -f $CURR_PATH/install.sh $INSTALL_PATH/install.sh
	mkdir -p $INSTALL_PATH/states 2> /dev/null
	touch $STATES_PATH
	echo "rxvt配置文件安装成功"
}
Remove() {
	echo "开始卸载rxvt的配置文件..."
	if [ -e $STATES_PATH ]; then
		rm -rf $RXVT_PATH
		#恢复备份文件
		mv $BACKUP_PATH/Xdefaults ~/.Xdefaults 2> /dev/null
		rm $INSTALL_SCRIPT
		rm $STATES_PATH
	fi
	echo "rxvt配置文件卸载成功"
}
if [ 1 -ne $# ]; then
	Help
	exit 1
fi
case "$1" in
	"-i") Install ;;
	"-r") Remove ;;
	"-h") Help ;;
	*) Help; exit 1;;
esac
