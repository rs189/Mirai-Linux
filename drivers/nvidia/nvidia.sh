#!/bin/bash
set -e

source "$(dirname "$0")/../common.sh"

sudo dnf install -y akmod-nvidia # rhel/centos users can use kmod-nvidia instead
sudo dnf install -y xorg-x11-drv-nvidia-cuda #optional for cuda/nvdec/nvenc support

add_if_missing "blacklist nouveau" /etc/modprobe.d/blacklist-nouveau.conf
add_if_missing "options nouveau modeset=0" /etc/modprobe.d/blacklist-nouveau.conf

sudo dracut --regenerate-all --force

echo -e "\e[1;32m[NVIDIA] setup complete.\e[0m"