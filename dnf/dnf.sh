#!/bin/bash
set -e

sudo dnf4 upgrade -y --skip-broken || true
sudo dnf install -y \
https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sh ./dnf/language.sh
sh ./dnf/multimedia.sh
sh ./dnf/develop.sh

echo -e "\e[1;32m[dnf] Setup complete.\e[0m"