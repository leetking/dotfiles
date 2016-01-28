#!/bin/bash
#安装、卸载vim的配置文件
# -i安装
# -r卸载
# -h帮助

hash dirname || { echo "ERROR: 需要安装dirname"; exit 1; }
INSTALL_PATH=~/.myconfigures
CURR_PATH=`dirname $0`/..
VIM_PATH=$INSTALL_PATH/vim
VUNDLE_PATH=$INSTALL_PATH/vim/vim/bundle/vundle
BACKUP_PATH=$INSTALL_PATH/backups/vim
STATES_PATH=$INSTALL_PATH/states/vim
INSTALL_SCRIPT=$INSTALL_PATH/install/vim.sh
Help() {
	echo "Usage: $0 [-i]|[-r]|[-h]"
	echo -e "\t-i install, 安装"
	echo -e "\t-r remove, 卸载"
	echo -e "\t-h 显示这个页面"
}
Install() {
	echo "开始安装vim配置文件..."
	if [ -f $STATES_PATH ]; then
		echo "安装vim配置文件成功!"
		exit 0
	fi
	#检测工具
	hash git ||{ echo "ERROR: 没有安装git,请手动安装"; exit 1; }
	hash ctags || echo "WARN: 推荐安装ctags"
	hash cscope || echo "WARN: 推荐安装cscope"
	#备份
	mkdir -P $BACKUP_PATH 2> /dev/null
	mv ~/.vimrc $BACKUP_PATH/vimrc 2> /dev/null
	mv ~/.gvimrc $BACKUP_PATH/gvimrc 2> /dev/null
	mv ~/.vim $BACKUP_PATH/vim 2> /dev/null
	#复制配置文件
	cp -r $CURR_PATH/vim $INSTALL_PATH/vim
	#链接到正确的位置
	ln -s $VIM_PATH/vimrc ~/.vimrc
	ln -s $VIM_PATH/gvimrc ~/.gvimrc
	ln -s $VIM_PATH/vim ~/.vim
	#安装vundle
	mkdir -p $VUNDLE_PATH 2> /dev/null
	echo "clone vundle..."
	git clone https://github.com/gmarik/vundle $VUNDLE_PATH 2> /dev/null || echo "WARN: 没能clone vundle，请手动安装"
	mkdir -p $INSTALL_PATH/install 2> /dev/null
	cp $CURR_PATH/install/vim.sh $INSTALL_SCRIPT
	cp -f $CURR_PATH/install.sh $INSTALL_PATH/install.sh
	#生成安装信息
	mkdir -p $INSTALL_PATH/states 2> /dev/null
	touch $STATES_PATH
	echo "安装vim配置文件成功!"
}
Remove() {
	echo "开始卸载vim配置文件..."
	if [ -e $STATES_PATH ]; then
		#删除
		rm -rf $VIM_PATH
		rm -rf ~/.vimrc ~/.gvimrc ~/.vim 2> /dev/null
		#恢复配置文件
		mv $BACKUP_PATH/vimrc ~/.vimrc 2> /dev/null
		mv $BACKUP_PATH/gvimrc ~/.gvimrc 2> /dev/null
		mv $BACKUP_PATH/vim ~/.vim 2> /dev/null
		rm -f $INSTALL_SCRIPT
		#删除安装状态
		rm -r $STATES_PATH
	fi
	echo "vim配置文件卸载成功!"
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
