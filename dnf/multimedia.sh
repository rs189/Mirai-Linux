#!/bin/bash
set -e

sudo dnf4 group install -y Multimedia
sudo dnf install -y libheif-freeworld libheif-tools ffmpegthumbnailer akmod-v4l2loopback v4l2loopback-utils
sudo dnf install -y gstreamer1 gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-bad-free gstreamer1-plugins-ugly gstreamer1-libav

sudo akmods --force
sudo modprobe v4l2loopback

echo -e "\e[1;32m[dnf] Multimedia setup complete.\e[0m"