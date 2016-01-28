#!/bin/bash
#打包这里的字体文件
POWER_LINE=power-line.tar.xz
CODE_FONTS=code-fonts.tar.xz

hash tar || { echo "ERROR: 没有找到tar"; exit 1; }
hash dirname || { echo "ERROR: 没有找到dirname"; exit 1; }
CURR_PATH=`dirname $0`
if [ 0 -eq $# ]; then
	echo "开始打包字体文件..."
	tar -Jcf $CURR_PATH/$POWER_LINE $CURR_PATH/power-line 2> /dev/null
	tar -Jcf $CURR_PATH/$CODE_FONTS $CURR_PATH/code-fonts 2> /dev/null
	rm -r $CURR_PATH/power-line $CURR_PATH/code-fonts 2> /dev/null
	echo "字体文件打包完成"
	exit 0
fi
if [ "-r" == $1 ]; then
	rm -rf ~/.fonts/power-line ~/.fonts/code-fonts
	rm -rf $CURR_PATH/../fonts
fi
#其他错误使用
echo "Usage: $0 -r"
echo "\t-r    remove删除"
echo "\t默认是打包"
exit 1
