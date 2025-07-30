#!/bin/bash
set -e

sh ./x11/x11.sh || true
sh ./rpm/rpm.sh
sh ./wine/wine.sh
sh ./runtimes/java/java.sh
sh ./runtimes/dotnet/dotnet.sh

sh ./security/firewalld/firewalld.sh
sh ./security/selinux/selinux.sh

sh ./btrfs/btrfs.sh

sh ./systemd/chromium-pwa/chromium-pwa-init.sh

echo -e "\e[1;32mMirai Linux setup complete.\e[0m"
echo -e "\e[1;31mA system reboot is required to complete the setup.\e[0m"