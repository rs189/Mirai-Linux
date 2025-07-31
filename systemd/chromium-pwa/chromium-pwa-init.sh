#!/bin/bash
set -e

mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

sudo dnf install inotify-tools -y

cp systemd/chromium-pwa/.local/bin/chromium-pwa.sh ~/.local/bin/chromium-pwa.sh
chmod +x ~/.local/bin/chromium-pwa.sh
cp systemd/chromium-pwa/.config/systemd/user/chromium-pwa.service ~/.config/systemd/user/chromium-pwa.service

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now chromium-pwa.service
systemctl --user restart chromium-pwa.service

echo -e "\e[1;32m[systemd] Chromium PWA setup complete.\e[0m"
