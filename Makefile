#! /usr/bin/env bash
CURR_PATH=`pwd -P`
INSTALL_PATH=~/.myconfigures
BACKUP_PATH=$(INSTALL_PATH)/backups
OS=`lsb_release -ds | cut -d' ' -f1,1`
#INSTALLED_PATH标记哪些配置文件被安装了
INSTALLED_PATH=$(INSTALL_PATH)/installed
#FIREFOX_SEARCHPLUGINS_PATH=~/.mozilla/firefox/*.default/searchplugins

# 定义安装卸载vim，bash，tmux等的函数
define install_vim
	@mkdir -p $(BACKUP_PATH)/vim
	@mkdir -p $(INSTALL_PATH)/vim
	@mkdir -p $(INSTALLED_PATH)
	@# 备份文件
	@-if [ ! -L ~/.vim ] ; then \
		mv ~/.vim $(BACKUP_PATH)/vim/vim.backup 2> /dev/null ;\
		fi
	@-if [ ! -L ~/.vimrc ]; then \
		mv ~/.vimrc $(BACKUP_PATH)/vim/vimrc.backup 2> /dev/null ;\
		fi
	@-if [ ! -L ~/.gvimrc ]; then \
		mv ~/.gvimrc $(BACKUP_PATH)/vim/gvimrc.backup 2> /dev/null ;\
		fi
	@# 检查有没有安装ctags
	@# 下面根据不同系统调整 
	@if [ -z `which ctags` ]; then \
		echo "\033[1m请输入用户密码去安装ctags\033[0m"; \
		case $(OS) in \
			Ubuntu | Debain) \
				sudo apt-get install exuberant-ctags ;; \
			Fedora) \
				sudo yum install ctags ;; \
			*) \
				echo "\033[31m不能确定您的系统\033[0m" ; \
				echo "\033[31m未能安装ctags,请您手动安装\033[0m" ;; \
		esac \
	fi
	@# 安装
	@-cp -r $(CURR_PATH)/vim/*vimrc	$(INSTALL_PATH)/vim/
	@-tar -Jxf $(CURR_PATH)/vim/vim.tar.xz -C $(INSTALL_PATH)/vim/
	@ln -sf $(INSTALL_PATH)/vim/vim ~/.vim
	@ln -sf $(INSTALL_PATH)/vim/gvimrc ~/.gvimrc
	@ln -sf $(INSTALL_PATH)/vim/vimrc ~/.vimrc
	@# 生成安装了的状态
	@date > $(INSTALLED_PATH)/Vim
	@echo "\033[32mvim配置成功\033[0m"
endef
define uninstall_vim 
	@# 删除安装的插件和配置文件
	@-rm -r ~/.vim ~/.gvimrc ~/.vimrc
	@# 恢复原来的状态
	@-for i in `ls $(BACKUP_PATH)/vim`; do \
		mv "$i" "~/.${i%%.backup}"; \
	done
	@# 卸载ctags
	@# 标记删除
	@-rm $(INSTALLED_PATH)/Vim
	@echo "\033[32mvim配置卸载\033[0m"
endef
define install_bash
	@mkdir -p $(BACKUP_PATH)/bash
	@mkdir -p $(INSTALLED_PATH)
	@-if [ ! -L ~/.inputrc ]; then \
		mv ~/.inputrc $(BACKUP_PATH)/bash/inputrc.backup 2> /dev/null ;\
	fi
	@-cp -r $(CURR_PATH)/bash $(INSTALL_PATH)/
	@echo ". ~/.bashrc #my" >> ~/.bash_profile
	@echo ". $(INSTALL_PATH)/bash/bashrc #my" >> ~/.bashrc
	@ln -sf $(INSTALL_PATH)/bash/inputrc ~/.inputrc
	@date > $(INSTALLED_PATH)/Bash
	@echo "\033[32mbash配置成功\033[0m"
endef
define uninstall_bash
	@-rm ~/.inputrc
	@-mv $(BACKUP_PATH)/bash/inputrc.backup ~/.inputrc 2> /dev/null
	@# 使用流处理程序来处理.bash_profile
	@-(echo '/#my/d'; echo 'wq') | ed -s ~/.bash_profile
	@-(echo '/#my/d'; echo 'wq') | ed -s ~/.bashrc
	@-rm $(INSTALLED_PATH)/Bash
	@echo "\033[32mbash配置卸载\033[0m"
endef
define install_tmux
	@mkdir -p $(BACKUP_PATH)/tmux
	@mkdir -p $(INSTALLED_PATH)
	@# 备份
	@-if [ ! -L ~/.tmux.conf ]; then \
		mv ~/.tmux.conf $(BACKUP_PATH)/tmux/tmux.conf.backup 2> /dev/null ;\
	fi
	@# 安装
	@-cp -r $(CURR_PATH)/tmux $(INSTALL_PATH)/
	@ln -sf $(INSTALL_PATH)/tmux/tmux.conf ~/.tmux.conf
	@# 生成安装了的状态
	@date > $(INSTALLED_PATH)/Tmux
	@echo "\033[32mtmux配置成功\033[0m"
endef
define uninstall_tmux
	@-rm -r ~/.tmux.conf
	@-mv $(BACKUP_PATH)/tmux/tmux.conf.backup ~/.tmux.conf 2> /dev/null
	@# 标记删除
	@-rm $(INSTALLED_PATH)/Tmux
	@echo "\033[32mtmux配置卸载\033[0m"
endef

#全部安装
install: Vim Tmux Bash

#全部卸载
uninstall: ~/.myconfigures/installed
	$(uninstall_vim)
	$(uninstall_tmux)
	$(uninstall_bash)
	@-rm -rf $(INSTALL_PATH)

####Vim/Gvim
Vim: vim
	$(install_vim)
UnVim: ~/.myconfigures/backups/vim
	$(uninstall_vim)

####Tmux
Tmux: tmux
	$(install_tmux)
UnTmux: $(BACKUP_PATH)/tmux
	$(uninstall_tmux)

####Bash
Bash: bash
	$(install_bash)
UnBash: $(BACKUP_PATH)/bash
	$(uninstall_bash)
####firefox的一个搜索引擎安装
#由于某个目录的特殊性，这里就不这样安装了,请手动安装
#Firefox: firefox
#	-if [ ! -d $(FIREFOX_SEARCHPLUGINS_PATH) ]; then \
#		mkdir -p $(FIREFOX_SEARCHPLUGINS_PATH); \
#	fi
#	-cp $(CURR_PATH)/firefox/guge.xml $(FIREFOX_SEARCHPLUGINS_PATH)/
