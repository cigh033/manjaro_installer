#!/bin/bash

echo manjaro > /etc/hostname
echo "127.0.0.1 localhost" >  /etc/hosts
echo "::1"                 >> /etc/hosts
echo "127.0.1.1 manjaro"   >> /etc/hosts
chsh -s /bin/zsh
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
systemctl enable NetworkManager
systemctl enable systemd-timesyncd
echo "en_US-UTF-8" > /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo "root passwd"
passwd
