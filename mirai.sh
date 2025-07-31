#!/bin/bash

sh ./dnf/dnf.sh
sh ./flatpak/flatpak.sh

sh ./runtimes/wine/wine.sh
sh ./runtimes/proton/proton.sh
sh ./runtimes/java/java.sh
sh ./runtimes/dotnet/dotnet.sh

sh ./security/firewalld/firewalld.sh
sh ./security/selinux/selinux.sh

sh ./kde/x11/x11.sh || true

sh ./systemd/systemd.sh

sh ./btrfs/btrfs.sh

echo -e "\e[1;32mMirai Linux setup complete.\e[0m"
echo -e "\e[1;31mA system reboot is required to complete the setup.\e[0m"