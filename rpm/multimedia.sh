#!/bin/bash
set -e

sudo dnf4 group install -y Multimedia
sudo dnf install -y libheif-freeworld libheif-tools ffmpegthumbnailer

echo -e "\e[1;32m[RPM] Multimedia setup complete.\e[0m"