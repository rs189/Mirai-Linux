#!/bin/bash
set -e

mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

cp systemd/plasmashell-oom/.local/bin/plasmashell-oom.sh ~/.local/bin/plasmashell-oom.sh
chmod +x ~/.local/bin/plasmashell-oom.sh
cp systemd/plasmashell-oom/.config/systemd/user/plasmashell-oom.service ~/.config/systemd/user/plasmashell-oom.service

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now plasmashell-oom.service
systemctl --user restart plasmashell-oom.service

echo -e "\e[1;32m[systemd] Plasmashell OOM setup complete.\e[0m"