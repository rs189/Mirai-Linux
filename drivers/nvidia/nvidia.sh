#!/bin/bash
set -e

source "$(dirname "$0")/../../common.sh"

sudo dnf install -y akmod-nvidia # rhel/centos users can use kmod-nvidia instead
sudo dnf install -y xorg-x11-drv-nvidia-cuda #optional for cuda/nvdec/nvenc support
sudo dnf install -y vulkan || true

sudo dnf install -y xorg-x11-drv-nvidia-cuda-libs nvidia-vaapi-driver libva-utils vdpauinfo || true

add_if_missing "blacklist nouveau" /etc/modprobe.d/blacklist-nouveau.conf
add_if_missing "options nouveau modeset=0" /etc/modprobe.d/blacklist-nouveau.conf

if grep -q '^options nvidia_drm modeset=' /etc/modprobe.d/nvidia.conf 2>/dev/null; then
    if ! grep -q '^options nvidia_drm modeset=1$' /etc/modprobe.d/nvidia.conf; then
        if [ -w /etc/modprobe.d/nvidia.conf ]; then
            sed -i 's/^options nvidia_drm modeset=.*/options nvidia_drm modeset=1/' /etc/modprobe.d/nvidia.conf
        else
            sudo sed -i 's/^options nvidia_drm modeset=.*/options nvidia_drm modeset=1/' /etc/modprobe.d/nvidia.conf
        fi
    fi
else
    add_if_missing "options nvidia_drm modeset=1" /etc/modprobe.d/nvidia.conf
fi

sudo dracut --regenerate-all --force

echo -e "\e[1;32m[NVIDIA] setup complete.\e[0m"