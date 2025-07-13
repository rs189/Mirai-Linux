#!/bin/bash
set -e

sh ./x11/x11.sh
sh ./rpm/rpm.sh
sh ./wine/wine.sh
sh ./java/java.sh

sh ./firewalld/firewalld.sh
sh ./selinux/selinux.sh

sh ./btrfs/btrfs.sh

echo -e "\e[1;32mMirai Linux setup complete.\e[0m"
echo -e "\e[1;31mA system reboot is required to complete the setup.\e[0m"