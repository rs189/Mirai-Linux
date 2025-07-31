#!/bin/bash
set -e

sudo mkdir -p /etc/systemd/zram-generator.conf.d
sudo cp ./swap/etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf

sudo systemctl daemon-reexec
sudo systemctl restart systemd-zram-setup@zram0.service

echo -e "\e[1;32m[swap] zram setup complete.\e[0m"