#!/bin/bash

sudo dnf install -y plasma-workspace-x11 xorg-x11-server-Xorg || true

echo -e "\e[1;32m[X11] Setup complete.\e[0m"