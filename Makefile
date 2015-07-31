#! /bin/bash
CURR_PATH=`pwd -P`
INSTALL_PATH=~/.myconfigures
BACKUP_PATH=$(INSTALL_PATH)/backups
#OS=`lsb_release -d | cut `
#INSTALLED_PATH标记哪些配置文件被安装了
INSTALLED_PATH=$(INSTALL_PATH)/installed
FIREFOX_SEARCHPLUGINS_PATH=~/.mozllia/firefox/*.default/searchplugins

#全部安装
install: Vim Tmux Bash

#全部卸载
uninstall: $(BACKUP_PATH)

####Vim/Gvim
Vim: vim
	mkdir -p $(BACKUP_PATH)/vim
	mkdir -p $(INSTALL_PATH)/vim
	mkdir -p $(INSTALLED_PATH)/
	# 备份文件
	if [ ! -L ~/.vim ] ; then \
		mv -r ~/.vim $(BACKUP_PATH)/vim/vim.backup; \
	fi
	if [ ! -L ~/.vimrc ]; then \
		mv -r ~/.vimrc $(BACKUP_PATH)/vim/vimrc.backup; \
	fi
	if [ ! -L ~/.gvimrc ]; then \
		mv -r ~/.gvimrc $(BACKUP_PATH)/vim/gvimrc.backup; \
	fi
	# 检查有没有安装ctags
	# 根据系统来安装ctags
	# 安装
	-cp -r $(CURR_PATH)/vim	$(INSTALL_PATH)/
	ln -sf $(INSTALL_PATH)/vim/vim ~/.vim
	ln -sf $(INSTALL_PATH)/vim/gvimrc ~/.gvimrc
	ln -sf $(INSTALL_PATH)/vim/vimrc ~/.vimrc
	# 生成安装了的状态
	date > $(INSTALLED_PATH)/Vim
UnVim: $(BAKUP_PATH)/vim
	# 删除安装的插件和配置文件
	-rm -r ~/.vim ~/.gvimrc ~/.vimrc
	# 恢复原来的状态
	for i in `ls $(BACKUP_PATH)/vim`; do \
		mv "$i" ~/."${i%%.backup}"
	# 卸载ctags
	# 标记删除
	-rm $(INSTALLED_PATH)/Vim

####Tmux
Tmux: tmux
	mkdir -p $(BACKUP_PATH)/tmux
	mkdir -p $(INSTALL_PATH)/tmux
	mkdir -p $(INSTALLED_PATH)/
	# 备份
	if [ ! -L ~/.tmux.conf ]; then \
		mv -r ~/.tmux.conf $(BACKUP_PATH)/tmux/tmux.conf.backup; \
	fi
	# 安装
	-cp -r $(CURR_PATH)/tmux $(INSTALL_PATH)/tmux
	ln -sf $(INSTALL_PATH)/tmux/tmux.conf ~/.tmux.conf
	# 生成安装了的状态
	date > $(INSTALLED_PATH)/Tmux
UnTmux: $(BACKUP_PATH)/tmux
	-rm -r ~/.tmux.conf
	-mv $(BACKUP_PATH)/tmux/tmux.conf.backup ~/.tmux.conf
	# 标记删除
	-rm $(INSTALLED_PATH)/Tmux

####Bash
Bash: bash
	mkdir -p $(BACKUP_PATH)/bash
	mkdir -p $(INSTALL_PATH)/bash
	mkdir -p $(INSTALLED_PATH)/
	if [ ! -L ~/.inputrc ]; then \
		mv ~/.inputrc $(BACKUP_PATH)/bash/inputrc.backup; \
	fi
	echo "bash_profile要在登录模式下才有效果，不然不会读取" >> ~/.bash_profile
	echo ". $(INSTALL_PATH)/bash/bashrc	#my" >> ~/.bash_profile
	ln -sf $(INSTALL_PATH)/bash/inputrc ~/.inputrc
	date > $(INSTALLED_PATH)/Bash
UnBash: $(BACKUP_PATH)/bash
	-rm ~/.inputrc
	-mv $(BACKUP_PATH)/bash/inputrc.backup ~/.inputrc
	-rm $(INSTALLED_PATH)/Bash
	# 使用流处理程序来处理.bash_profile
	# ...
####firefox的一个搜索引擎安装
Firefox: firefox
	if [ ! -d $(FIREFOX_SEARCHPLUGINS_PATH) ]; then \
		mkdir -p $(FIREFOX_SEARCHPLUGINS_PATH) \
	fi
	-cp $(CURR_PATH)/firefox/guge.xml $(FIREFOX_SEARCHPLUGINS_PATH)/
