#!/bin/bash
set -e

sudo systemctl enable --now firewalld
sudo firewall-cmd --set-default-zone=home

INTERFACES=$(nmcli device status | awk '/connected/ {print $1}')
for IFACE in $INTERFACES; do
  sudo firewall-cmd --zone=home --change-interface=$IFACE --permanent
done

sudo firewall-cmd --reload

echo -e "\e[1;32m[firewalld] setup complete.\e[0m"