#!/bin/bash

python -m pip install konsave || true

sudo cp -r ./kde/usr/share/wallpapers/* /usr/share/wallpapers/

echo -e "\e[1;32m[KDE] Setup complete.\e[0m"