#!/bin/bash
#安装、卸载这几种字体
# -i安装
# -r卸载
# -h帮助

hash dirname || { echo "ERROR: 需要安装dirname"; exit 1; }
INSTALL_PATH=~/.myconfigures
CURR_PATH=`dirname $0`/..
FONTS_PATH=$INSTALL_PATH/fonts
#BACKUP_PATH=$INSTALL_PATH/backups/fonts
STATES_PATH=$INSTALL_PATH/states/fonts
INSTALL_SCRIPT=$INSTALL_PATH/install/fonts.sh
Help() {
	echo "Usage: $0 [-i]|[-r]|[-h]"
	echo -e "\t-i install, 安装"
	echo -e "\t-r remove, 卸载"
	echo -e "\t-h 显示这个页面"
}
Install() {
	echo "现在开始安装字体..."
	#检测一些工具
	hash mkfontscale || echo "WARN: 建议安装mkfontscale"
	hash mkfontdir || echo "WARN: 建议安装mkfontdir"
	hash fc-cache || echo "WARN: 建议安装fc-cache"
	if [ ! -f $STATES_PATH ]; then
		cp -rf $CURR_PATH/fonts $INSTALL_PATH/fonts
		#解压出来并设置好
		$INSTALL_PATH/fonts/tarxf.sh
		mkdir -P $INSTALL_PATH/install 2> /dev/null
		cp $CURR_PATH/install/fonts.sh $INSTALL_SCRIPT
		cp -f $CURR_PATH/install.sh $INSTALL_PATH/install.sh
		mkdir -p $INSTALL_PATH/states 2> /dev/null
		touch $STATES_PATH
	fi
	echo "字体安装完成"
}
Remove() {
	echo "开始卸载安装的字体..."
	if [ -e $STATES_PATH ]; then
		$INSTALL_PATH/fonts/tarcf.sh -r
		rm $STATES_PATH
		rm $INSTALL_SCRIPT
	fi
	echo "字体卸载成功"
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
