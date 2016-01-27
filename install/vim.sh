#!/bin/bash
#安装、卸载vim的配置文件
# -i安装
# -r卸载
# -h帮助

#获取INSTALL_PATH和CURR_PATH的值
source ../vars.sh
VIM_PATH=$INSTALL_PATH/vim
VUNDLE_PATH=$INSTALL_PATH/vim/vim/bundle
BACKUP_PATH=$INSTALL_PATH/backups/vim
STATES_PATH=$INSTALL_PATH/states/vim
INSTALL_SCRIPT=$INSTALL_PATH/install/vim.sh
Help() {
	echo "Usage: $0 [-i]|[-r]|[-h]"
	echo "\t-i install, 安装"
	echo "\t-r remove, 卸载"
	echo "\t-h 显示这个页面"
}
Install() {
	echo "开始安装vim配置文件..."
	if [ -f $STATES_PATH ]; then
		echo "vim的配置文件已经安置好了"
		exit 0
	fi
	#检测工具
	hash git || echo "ERROR: 没有安装git,请手动安装"; exit 1
	hash ctags || echo "WARN: 推荐安装ctags"
	hash cscope || echo "WARN: 推荐安装cscope"
	#备份
	mkdir -P $BACKUP_PATH 2> /dev/null
	mv ~/.vimrc $BACKUP_PATH/vimrc 2> /dev/null
	mv ~/.gvimrc $BACKUP_PATH/gvimrc 2> /dev/null
	mv ~/.vim $BACKUP_PATH/vim 2> /dev/null
	#复制配置文件
	cp -rf $CURR_PATH/vim $INSTALL_PATH/vim
	#链接到正确的位置
	ln -sf $VIM_PATH/vimrc ~/.vimrc
	ln -sf $VIM_PATH/gvimrc ~/.gvimrc
	ln -sf $VIM_PATH/vim ~/.vim
	#安装vundle
	mkdir -P $VUNDLE_PATH 2> /dev/null
	echo "clone vundle..."
	git clone https://github.com/gmarik/vundle -C $VUNDLE_PATH || echo "没能clone vundle，请手动安装"
	mkdir -P $INSTALL_PATH/install 2> /dev/null
	cp $CURR_PATH/install/vim.sh $INSTALL_SCRIPT
	cp -f $CURR_PATH/install.sh $INSTALL_PATH/install.sh
	#生成安装信息
	touch $STATES_PATH
	echo "安装vim配置文件成功!"
}
Remove() {
	echo "开始卸载vim配置文件..."
	if [ ! -e $STATES_PATH ]; then
		echo "没有安装过vim配置文件"
		exit 1
	fi
	#删除
	rm -rf $VIM_PATH
	#恢复配置文件
	mv $BACKUP_PATH/vimrc ~/.vimrc 2> /dev/null
	mv $BACKUP_PATH/gvimrc ~/.gvimrc 2> /dev/null
	mv $BACKUP_PATH/vim ~/.vim 2> /dev/null
	rm -f $INSTALL_SCRIPT
	#删除安装状态
	rm -r $STATES_PATH
	echo "vim配置文件卸载成功"
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
