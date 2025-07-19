#!/bin/bash
set -e

wineserver -k
killall -9 wineserver

sudo dnf remove -y wine winetricks || true
sudo dnf install -y vulkan vulkan-tools || true

# wine-10.4.r0.gc110178b ( TkG Staging Esync Fsync )
WINE_MIRAI_ARCHIVE="wine/opt/wine-mirai.tar.gz"
if [ -f "$WINE_MIRAI_ARCHIVE" ]; then
    echo "Extracting wine-mirai.tar.gz to /opt..."
    sudo tar -xzf "$WINE_MIRAI_ARCHIVE" -C /opt
else
    echo "Archive not found: $WINE_MIRAI_ARCHIVE"
    exit 1
fi

if [ -d "$HOME/.wine" ]; then
    echo "Backing up existing .wine folder..."
    mv "$HOME/.wine" "$HOME/.wine.bak"
fi

# Preconfigured prefix
ARCHIVE_PATH="wine/wine-env.tar.gz"
if [ -f "$ARCHIVE_PATH" ]; then
    echo "Extracting wine-env.tar.gz to home directory..."
    tar -xzf "$ARCHIVE_PATH" -C "$HOME"
else
    echo "Archive not found: $ARCHIVE_PATH"
    exit 1
fi

# Winetricks
sudo cp wine/usr/bin/winetricks /usr/bin/
sudo chmod +x /usr/bin/winetricks

# Libraries
winetricks -q dotnet452 vcrun2005 vcrun2008 vcrun2015 dotnet48 dxvk
wine regsvr32 wineasio.dll

# Fonts
winetricks -q corefonts allfonts cjkfonts

# Registry
wine reg add 'HKEY_CURRENT_USER\Software\Wine\X11 Driver' /t REG_SZ /v UseTakeFocus /d N /f 

winecfg -v win11

echo -e "\e[1;32m[Wine] setup complete.\e[0m"