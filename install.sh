#!/usr/bin/env bash

# IMPORTANT 本脚本仅供个人环境迁移时使用，所以不会备份原来的文件

CURR_PATH=$(cd `dirname $0`; pwd -P)

# bash
InstallBash() {
    ln -sf ${CURR_PATH}/bash/bashrc  ~/.bashrc
    ln -sf ${CURR_PATH}/bash/inputrc ~/.inputrc
}

# vim
InstallVim() {
    ln -sf ${CURR_PATH}/vim/vimrc   ~/.vimrc
    ln -sf ${CURR_PATH}/vim/gvimrc  ~/.gvimrc
    # NOTE 不能写成rm -r ~/.vim/这样会把原始文件一起删除掉，这是软链接的坑
    rm -r ~/.vim
    ln -sf ${CURR_PATH}/vim/vim     ~/.vim
    # clone Vundle.vim
    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ${CURR_PATH}/vim/vim/bundle/Vundle.vim
    # 通过Vundle安装插件
    vim +PluginInstall +qall
}

# sdcv dictionaries
InstallSdcv() {
    # 先下载文件
    ${CURR_PATH}/sdcv/download_dicts.sh
    # 安装
    rm -rf ~/.stardict
    mkdir -p ~/.stardict/dic/
    for i in `ls ${CURR_PATH}/sdcv/`; do
        [ -d "${CURR_PATH}/sdcv/$i" ] && ln -sf "${CURR_PATH}/sdcv/$i" ~/.stardict/dic/
    done
}

# urxvt configuration
InstallUrxvt() {
    ln -sf ${CURR_PATH}/urxvt/Xdefaults ~/.Xdefaults
    # TODO xradr 使其生效
}

InstallConfig() {
    rm -r ~/.config
    ln -s ${CURR_PATH}/config ~/.config
}

InstallTools() {
    sed --follow-symlinks -i '/#tools-tag/d' ~/.bashrc
    echo "# Own shell scripts. #tools-tag" >> ~/.bashrc
    echo "add-path \"${CURR_PATH}/tools/bin\" #tools-tag" >> ~/.bashrc
}

Install() {
    InstallBash
    InstallVim
    InstallSdcv
    InstallUrxvt
    InstallConfig
    InstallTools
    echo "Done."
}

Help() {
    echo "Usage: $0 [vim|bash|sdcv|config|tools|-h]"
    echo "     vim:  install vimrc."
    echo "     bash: install bashrc."
    echo "     sdcv: install sdcv dictionary."
    echo "     config: install \`.config' directory."
    echo "     tools: install my shell scripts."
    echo "     -h:   show this page."
}

# I install the all by default
if [ 0 -eq $# ]; then
    Install
    exit 0
fi

while [ 0 -ne $# ]; do
    case "$1" in
        vim)   InstallVim ;;
        bash)  InstallBash ;;
        sdcv)  InstallSdcv ;;
        config)InstallConfig ;;
        tools) InstallTools ;;
        *)     echo "No options \"$1\"."; Help; exit 1 ;;
    esac
    shift
done
echo "Done."
