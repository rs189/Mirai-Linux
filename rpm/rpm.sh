#!/bin/bash
set -e

sudo dnf upgrade -y
sudo dnf install -y \
https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sh ./rpm/language.sh
sh ./rpm/multimedia.sh
sh ./rpm/develop.sh

echo -e "\e[1;32m[RPM] Setup complete.\e[0m"