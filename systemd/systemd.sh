#!/bin/bash
set -e

sudo dnf install -y systemd-oomd || true

sh ./systemd/plasmashell-oom/plasmashell-oom-init.sh
sh ./systemd/chromium-pwa/chromium-pwa-init.sh

echo -e "\e[1;32m[systemd] Setup complete.\e[0m"