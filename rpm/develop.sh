#!/bin/bash
set -e

sudo dnf install -y cmake hidapi-devel g++ gcc

echo -e "\e[1;32m[RPM] Develop setup complete.\e[0m"