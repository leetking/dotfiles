#!/bin/bash
#安装、卸载bashrc、inputrc的配置
# -i安装
# -r卸载
# -h帮助

#获取INSTALL_PATH和CURR_PATH的值
source ../vars.sh
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
	mkdir -P $BACKUP_PATH 2> /dev/null
	mv ~/.inputrc $BACKUP_PATH/inputrc 2> /dev/null
	#复制配置文件 TODO 了解bashrc和bash_profile的读取顺序
	cp -r $CURR_PATH/bash $INSTALL_PATH/bash
	echo ". $BASH_PATH/bashrc #own" >> ~/.bashrc
	ln -sf $BASH_PATH/inputrc ~/.inputrc
	#生成安装信息
	touch $STATES_PATH
	#复制安装脚本
	mkdir -P $INSTALL_PATH/install 2> /dev/null
	cp $CURR_PATH/install/bash.sh $INSTALL_SCRIPT
	cp -f $CURR_PATH/install.sh $INSTALL_PATH/install.sh
	echo "bash完成"
}
Remove() {
	echo "开始卸载bash配置文件..."
	hash ed || echo "ERROR: 没有找到ed"; exit 1
	if [ ! -e $STATES_PATH ]; then
		echo "没有安装过bash配置文件"
		exit 1
	fi
	rm -rf $BASH_PATH
	mv -f $BACKUP_PATH/inputrc ~/.inputrc
	(echo '/#own/d'; echo 'wq') | ed -s ~/.bashrc
	rm $STATES_PATH
	rm $INSTALL_SCRIPT
	echo "bash配置文件卸载完成"
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
