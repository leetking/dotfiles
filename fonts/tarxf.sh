#!/bin/bash
#解压这里的文件
POWER_LINE=power-line.tar.xz
CODE_FONTS=code-fonts.tar.xz

echo "开始解压字体文件..."
tar -Jxf $POWER_LINE 2> /dev/null
tar -Jxf $CODE_FONTS 2> /dev/null
rm -r $POWER_LINE $CODE_FONTS 2> /dev/null
echo "字体文件解压完成"
if [ ! -e ~/.fonts ]; then
	mkdir ~/.fonts
fi
ln -sf power-line ~/.fonts/power-line
ln -sf code-fonts ~/.fonts/code-fonts
echo "字体链接安装成功"
