#!/bin/bash
set -e

#sudo dnf install -y policycoreutils policycoreutils-python-utils firewall-config

if command -v setenforce &>/dev/null; then
  sudo setenforce 0 || echo "[SELinux] Could not setenforce."
fi

SELINUX_CONFIG="/etc/selinux/config"
if [ -f "$SELINUX_CONFIG" ]; then
  sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/' "$SELINUX_CONFIG"
  echo "Updated $SELINUX_CONFIG to set SELINUX=permissive"
else
  echo "Error: $SELINUX_CONFIG not found"
  exit 1
fi

echo -e "\e[1;32m[SELinux] setup complete.\e[0m"
echo -e "\e[1;31mA system reboot is required to complete the SELinux setup.\e[0m"