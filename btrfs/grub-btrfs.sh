#!/bin/bash
set -e

sudo dnf install -y git make inotify-tools

rm -rf grub-btrfs
git clone https://github.com/Antynea/grub-btrfs.git
cd grub-btrfs

sed -i 's|#GRUB_BTRFS_MKCONFIG=.*|GRUB_BTRFS_MKCONFIG=/sbin/grub2-mkconfig|' config
sed -i 's|#GRUB_BTRFS_GRUB_DIRNAME=.*|GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"|' config
sed -i 's|#GRUB_BTRFS_SCRIPT_CHECK=.*|GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check|' config

sudo make install

sudo systemctl enable --now grub-btrfsd

sudo grub2-mkconfig -o /boot/grub2/grub.cfg

cd ..
rm -rf grub-btrfs

echo -e "\e[1;32m[btrfs] GRUB btrfs setup complete.\e[0m"