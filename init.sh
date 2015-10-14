#!/usr/bin/env bash
# 在fvwm下的一些初始化设置
ip link set wlp3s0 up &
fcitx &
wpa_supplicant -Dwext  -i wlp3s0 -c /etc/wpa_supplicant/wpa_supplicant.conf &
dhcpcd &
mount -t vfat /dev/sdb1 LINUX -o iocharset=utf8
