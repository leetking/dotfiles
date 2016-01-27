#!/bin/bash
#安装、卸载bashrc、inputrc的配置
# -i安装
# -r卸载
# -h帮助

hash dirname || { echo "ERROR: 需要安装dirname"; exit 1; }
INSTALL_PATH=~/.myconfigures
CURR_PATH=`dirname $0`/..
BASH_PATH=$INSTALL_PATH/bash
BACKUP_PATH=$INSTALL_PATH/backups/bash
STATES_PATH=$INSTALL_PATH/states/bash
INSTALL_SCRIPT=$INSTALL_PATH/install/bash.sh
Help() {
	echo "Usage: $0 [-i]|[-r]|[-h]"
	echo -e "\t-i install, 安装"
	echo -e "\t-r remove, 卸载"
	echo -e "\t-h 显示这个页面"
}
Install() {
	echo "开始配置bash..."
	if [ -f $STATES_PATH ]; then
		echo "bash已经配置好了"
		exit 0
	fi
	#备份
	mkdir -p $BACKUP_PATH 2> /dev/null
	mv ~/.inputrc $BACKUP_PATH/inputrc 2> /dev/null
	#复制配置文件 TODO 了解bashrc和bash_profile的读取顺序
	cp -r $CURR_PATH/bash $INSTALL_PATH/bash
	echo ". $BASH_PATH/bashrc #own" >> ~/.bashrc
	ln -sf $BASH_PATH/inputrc ~/.inputrc
	#复制安装脚本
	mkdir -p $INSTALL_PATH/install 2> /dev/null
	cp $CURR_PATH/install/bash.sh $INSTALL_SCRIPT
	cp -f $CURR_PATH/install.sh $INSTALL_PATH/install.sh
	#生成安装信息
	mkdir -p $INSTALL_PATH/states 2> /dev/null
	touch $STATES_PATH
	echo "bash完成"
}
Remove() {
	echo "开始卸载bash配置文件..."
	hash sed || { echo "ERROR: 没有找到sed"; exit 1; }
	if [ -e $STATES_PATH ]; then
		rm -r $BASH_PATH
		rm ~/.inputrc 2> /dev/null
		mv $BACKUP_PATH/inputrc ~/.inputrc 2> /dev/null
		sed -i '/#own/d' ~/.bashrc
		rm $STATES_PATH
		rm $INSTALL_SCRIPT
	fi
	echo "bash配置文件卸载完成"
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
