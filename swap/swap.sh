#!/bin/bash
set -e

sh ./swap/earlyoom.sh
sh ./swap/zram.sh
sh ./swap/etc/swappiness.sh

echo -e "\e[1;32m[swap] Setup complete.\e[0m"
echo -e "\e[1;31mA system reboot is required to complete the swap setup.\e[0m"