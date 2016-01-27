#!/bin/bash
#安装、卸载这几种字体
# -i安装
# -r卸载
# -h帮助

#获取INSTALL_PATH和CURR_PATH的值
source ../vars.sh
FONTS_PATH=$INSTALL_PATH/fonts
#BACKUP_PATH=$INSTALL_PATH/backups/fonts
STATES_PATH=$INSTALL_PATH/states/fonts
Help() {
	echo "Usage: $0 [-i]|[-r]|[-h]"
	echo "\t-i install, 安装"
	echo "\t-r remove, 卸载"
	echo "\t-h 显示这个页面"
}
Install() {
	echo "现在开始安装字体..."
	#检测一些工具
	hash mkfontscale || echo "WARN: 建议安装mkfontscale"
	hash mkfontdir || echo "WARN: 建议安装mkfontdir"
	hash fc-cache || echo "WARN: 建议安装fc-cache"
	if [ -f $STATES_PATH ]; then
		echo "字体已经安装好了"
		exit 0
	fi
	cp -rf $CURR_PATH/fonts $INSTALL_PATH/fonts
	#解压出来并设置好
	$INSTALL_PATH/fonts/tarxf.sh
	echo "字体安装完成"
}
Remove() {
	echo "开始卸载安装的字体..."
	if [ ! -e $STATES_PATH ]; then
		echo "没有安装过这种字体"
		exit 1
	fi
	$INSTALL_PATH/fonts/tarcf.sh -r
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
