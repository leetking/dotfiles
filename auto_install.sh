#!/bin/bash
THE_PATH=$(pwd -P)
INSTALL_PATH=~
BACKUP_PATH=~/.configues_backups

# backups
mkdir -p $BACKUP_PATH
mv -f $INSTALL_PATH/.bashrc $BACKUP_PATH
mv -f $INSTALL_PATH/.vimrc $BACKUP_PATH
mv -f $INSTALL_PATH/.tmux.conf $BACKUP_PATH

# setup
ln -sf $THE_PATH/bash

# 有空再
