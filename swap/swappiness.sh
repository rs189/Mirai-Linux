#!/bin/bash
set -e

sudo mkdir -p /etc/sysctl.d
sudo cp ./swap/etc/sysctl.d/99-swappiness.conf /etc/sysctl.d/99-swappiness.conf
sudo sysctl vm.swappiness=35
sudo sysctl --system

echo -e "\e[1;32m[swap] Swappiness configuration applied.\e[0m"