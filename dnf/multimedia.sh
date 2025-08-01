#!/bin/bash
set -e

sudo dnf4 group install -y Multimedia
sudo dnf install -y --allowerasing libheif-freeworld libheif-tools ffmpeg mpv vlc ffmpegthumbnailer akmod-v4l2loopback v4l2loopback-utils
sudo dnf install -y gstreamer1 gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-bad-free gstreamer1-plugins-ugly gstreamer1-libav

sudo dnf4 config-manager --enable fedora-cisco-openh264 -y || true
sudo dnf install -y openh264 mozilla-openh264 libavcodec-freeworld gstreamer1-plugins-bad-freeworld

sudo akmods --force
sudo modprobe v4l2loopback

echo -e "\e[1;32m[dnf] Multimedia setup complete.\e[0m"