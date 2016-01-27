#!/bin/bash
#安装、卸载rxvt的配置文件
# -i安装
# -r卸载
# -h帮助

#获取INSTALL_PATH和CURR_PATH的值
source ../vars.sh
RXVT_PATH=$INSTALL_PATH/rxvt
BACKUP_PATH=$INSTALL_PATH/backups/rxvt
STATES_PATH=$INSTALL_PATH/states/rxvt
Help() {
	echo "Usage: $0 [-i]|[-r]|[-h]"
	echo "\t-i install, 安装"
	echo "\t-r remove, 卸载"
	echo "\t-h 显示这个页面"
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
	echo "rxvt配置文件安装成功"
}
Remove() {
	if [ ! -e $STATES_PATH ]; then
		echo "没有安装rxvt的配置文件"
		exit 0
	fi
	rm -rf $RXVT_PATH
	#恢复备份文件
	mv $BACKUP_PATH/Xdefaults ~/.Xdefaults 2> /dev/null
	echo "rxvt配置文件卸载成功"
}
if [2 -ne $#]; then
	Help
	exit 1
fi
case "$1" in
	"-i") Install ;;
	"-r") Remove ;;
	"-h") Help ;;
	*) Help; exit 1;;
esac
