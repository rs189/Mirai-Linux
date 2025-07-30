#!/bin/bash
set -e

sudo dnf install -y flatpak || true

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak update -y

echo -e "\e[1;32m[Flatpak] setup complete.\e[0m"