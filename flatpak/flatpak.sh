#!/bin/bash

sudo dnf install -y flatpak || true

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
flatpak update -y || true

echo -e "\e[1;32m[Flatpak] Setup complete.\e[0m"