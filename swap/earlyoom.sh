#!/bin/bash

sudo dnf install -y earlyoom || true
sudo systemctl enable --now earlyoom.service || true
sudo systemctl daemon-reexec
sudo systemctl restart earlyoom

echo -e "\e[1;32m[swap] earlyoom setup complete.\e[0m"