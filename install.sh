#!/bin/bash

systemctl start systemd-timesyncd
pacman-mirrors -aU https://manjaro.moson.eu -Sstable
pacman -Syy --noconfirm
pacman -S manjaro-keyring --noconfirm
parted --script --align optimal /dev/sda \
    mklabel gpt \
    mkpart primary fat32 1MiB 512MiB set 1 esp on \
    mkpart primary btrfs 513MiB 100%
cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 luks
mkfs.vfat -F32 /dev/sda1
mkfs.btrfs /dev/mapper/luks
mount /dev/mapper/luks /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
umount /mnt
mount -o subvol=@,ssd,compress=zstd,noatime,nodiratime /dev/mapper/luks /mnt
mkdir /mnt/{boot,home,var}
mount -o subvol=@home,ssd,compress=zstd,noatime,nodiratime /dev/mapper/luks /mnt/home
mount -o subvol=@var,ssd,compress=zstd,noatime,nodiratime /dev/mapper/luks /mnt/var
mount /dev/sda1 /mnt/boot

basestrap /mnt aerc autoconf automake base bison bluez btrfs-progs chezmoi dosfstools dunst feh flex fzf gcc git gnome-keyring groff gvfs-smb highlight htop i3-gaps i3exit i3lock intel-ucode khal lib32-libva-vdpau-driver lib32-mesa-vdpau lib32-vulkan-intel lib32-vulkan-radeon libgnome-keyring libtool libva-mesa-driver libva-vdpau-driver linux414 m4 make manjaro-bluetooth manjaro-pulse manjaro-tools-base-git mate-power-manager mesa-vdpau mhwd mkinitcpio neofetch neovim network-manager-applet networkmanager nm-connection-editor pass patch picom pkgconf polkit-gnome polybar pulseaudio python-keyring python-pip qutebrowser ranger rofi enpass rustup rxvt-unicode seahorse smbclient sudo systemd-boot-manager texinfo tree ttf-fira-code unclutter unzip vdirsyncer vulkan-intel vulkan-radeon which xf86-video-amdgpu xf86-video-ati xf86-video-intel xf86-video-nouveau xf86-video-vesa xorg-bdftopcf xorg-docs xorg-font-util xorg-fonts-100dpi xorg-fonts-75dpi xorg-fonts-encodings xorg-iceauth xorg-mkfontscale xorg-server xorg-server-common xorg-server-devel xorg-server-xephyr xorg-server-xnest xorg-server-xvfb xorg-sessreg xorg-setxkbmap xorg-smproxy xorg-x11perf xorg-xbacklight xorg-xcmsdb xorg-xcursorgen xorg-xdpyinfo xorg-xdriinfo xorg-xev xorg-xgamma xorg-xhost xorg-xinput xorg-xkbcomp xorg-xkbevd xorg-xkbutils xorg-xkill xorg-xlsatoms xorg-xlsclients xorg-xmodmap xorg-xpr xorg-xprop xorg-xrandr xorg-xrdb xorg-xrefresh xorg-xset xorg-xsetroot xorg-xvinfo xorg-xwayland xorg-xwd xorg-xwininfo xorg-xwud xss-lock xterm yay zsh
fstabgen -U /mnt >> /mnt/etc/fstab
cp install.chroot.sh /mnt/root/test.sh
manjaro-chroot /mnt /root/test.sh
