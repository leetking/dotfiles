#!/bin/bash
#安装 、卸载tmux的配置文件
# -i安装
# -r卸载
# -h帮助

#获取INSTALL_PATH和CURR_PATH的值
source ../vars.sh
TMUX_PATH=$INSTALL_PATH/tmux
BACKUP_PATH=$INSTALL_PATH/backups/tmux
STATES_PATH=$INSTALL_PATH/states/tmux
Help() {
	echo "Usage: $0 [-i]|[-r]|[-h]"
	echo "\t-i install, 安装"
	echo "\t-r remove, 卸载"
	echo "\t-h 显示这个页面"
}
Install() {
	echo "现在开始安装tmux的配置文件"
	if [ -f $STATES_PATH ]; then
		echo "tmux配置文件已经安装好了"
		exit 0
	fi
	#备份
	mkdir -P $BACKUP_PATH 2> /dev/null
	cp -rf ~/.tmux.conf $BACKUP_PATH/tmux.conf 2> /dev/null
	cp -rf $CURR_PATH/tmux $INSTALL_PATH/tmux
	ln -sf $TMUX_PATH/tmux.conf ~/.tmux.conf
	touch $STATES_PATH
	echo "tmux配置文件安装完成"
}
Remove() {
	echo "开始卸载tmux配置文件"
	if [ ! -e $STATES_PATH ]; then
		echo "没有安装过tmux配置文件"
		exit 1
	fi
	rm -rf $TMUX_PATH
	rm -rf ~/.tmux.conf
	mv $BACKUP_PATH/tmux.conf ~/.tmux.conf
	rm $STATES_PATH
	echo "tmux配置文件卸载完成"
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
