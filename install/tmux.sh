#!/bin/bash
#安装 、卸载tmux的配置文件
# -i安装
# -r卸载
# -h帮助

hash dirname || { echo "ERROR: 需要安装dirname"; exit 1; }
INSTALL_PATH=~/.myconfigures
CURR_PATH=`dirname $0`/..
TMUX_PATH=$INSTALL_PATH/tmux
BACKUP_PATH=$INSTALL_PATH/backups/tmux
STATES_PATH=$INSTALL_PATH/states/tmux
INSTALL_SCRIPT=$INSTALL_PATH/install/tmux.sh
Help() {
	echo "Usage: $0 [-i]|[-r]|[-h]"
	echo -e "\t-i install, 安装"
	echo -e "\t-r remove, 卸载"
	echo -e "\t-h 显示这个页面"
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
	mkdir -P $INSTALL_PATH/install 2> /dev/null
	cp $CURR_PATH/install/tmux.sh $INSTALL_SCRIPT
	cp -f $CURR_PATH/install.sh $INSTALL_PATH/install.sh
	mkdir -p $INSTALL_PATH/states 2> /dev/null
	touch $STATES_PATH
	echo "tmux配置文件安装完成"
}
Remove() {
	echo "开始卸载tmux配置文件"
	if [ -e $STATES_PATH ]; then
		rm -r $TMUX_PATH
		rm ~/.tmux.conf
		mv $BACKUP_PATH/tmux.conf ~/.tmux.conf
		rm $INSTALL_SCRIPT
		rm $STATES_PATH
	fi
	echo "tmux配置文件卸载完成"
}
if [1 -ne $#]; then
	Help
	exit 1
fi
case "$1" in
	"-i") Install ;;
	"-r") Remove ;;
	"-h") Help ;;
	*) Help; exit 1;;
esac
