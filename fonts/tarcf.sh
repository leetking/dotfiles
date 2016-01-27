#!/bin/bash
#打包这里的字体文件
POWER_LINE=power-line.tar.xz
CODE_FONTS=code-fonts.tar.xz

if [ 1 -eq $# ]; then
	echo "开始打包字体文件..."
	tar -Jcf $POWER_LINE power-line 2> /dev/null
	tar -Jcf $CODE_FONTS code-fonts 2> /dev/null
	rm -rf power-line code-fonts 2> /dev/null
	echo "字体文件打包完成"
	exit 0
fi
if [ "-r" == $1 ]; then
	rm -rf ~/.fonts/power-line ~/.fonts/code-fonts
	rm -rf ../fonts
fi
#其他错误使用
echo "Usage: $0 -r"
echo "\t-r    remove删除"
echo "\t默认是打包"
exit 1
