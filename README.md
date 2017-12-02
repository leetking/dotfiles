# 个人的 dotfile

仅供我个人配置新环境时使用，所以安装时没有备份原来的数据。

## 重要
1. _这个**不**支持windows!!_
2. _如果想要使用，请确保你**明白**脚本在干什么。_

## 使用说明

### 依赖

1. `python3`
2. `lua`
3. `git`
4. `wget` or `aria2`

### 准备工作

1. 调整呼吸，大喊三声`Linux大法好!`，可保一次就安装成功
2. 保证电脑**能**接入网络
3. 电脑已经安装好了`git`和`wget`（有`aria2`更好:b）
4. 没有后悔药，如果安装后不想要自己看情况卸载吧XD

### 开始安装！

```shell
$ git clone --depth=1 https://github.com/leetking/dotfiles.git
$ mv dotfiles .dotfiles
$ cd .dotfiles
$ ./install.sh
```
