#!/bin/bash

source "$(dirname "$0")/../../common.sh"

command -v wineserver >/dev/null 2>&1 && wineserver -k >/dev/null 2>&1 || true
killall -9 wineserver

sudo dnf remove -y wine winetricks || true
sudo dnf install -y vulkan vulkan-tools || true
sudo dnf install -y cabextract || true

# wine-10.4.r0.gc110178b ( TkG Staging Esync Fsync )
WINE_MIRAI_ARCHIVE="runtimes/wine/opt/wine-mirai.tar.gz"
if [ -f "$WINE_MIRAI_ARCHIVE" ]; then
    echo "Extracting wine-mirai.tar.gz to /opt..."
    sudo tar -xzf "$WINE_MIRAI_ARCHIVE" -C /opt
else
    echo "Archive not found: $WINE_MIRAI_ARCHIVE"
    exit 1
fi

if [ -d "$HOME/.wine" ]; then
    echo "Backing up existing .wine folder..."
    if [ -d "$HOME/.wine.bak" ]; then
        echo "Removing previous backup ~/.wine.bak..."
        rm -rf "$HOME/.wine.bak"
    fi
    mv "$HOME/.wine" "$HOME/.wine.bak"
fi

# Preconfigured prefix
ARCHIVE_PATH="runtimes/wine/wine-env.tar.gz"
if [ -f "$ARCHIVE_PATH" ]; then
    echo "Extracting wine-env.tar.gz to home directory..."
    tar -xzf "$ARCHIVE_PATH" -C "$HOME"
else
    echo "Archive not found: $ARCHIVE_PATH"
    exit 1
fi

export WINEPREFIX="$HOME/.wine"

# Add wine-mirai to PATH if missing
add_if_missing 'export PATH=/opt/wine-mirai/bin:$PATH' "$HOME/.bashrc"
source "$HOME/.bashrc"

# Winetricks
sudo cp runtimes/wine/usr/bin/winetricks /usr/bin/
sudo chmod +x /usr/bin/winetricks

# Clear ~/.cache/wine
rm -rf "$HOME/.cache/wine"

# Libraries
#winetricks -q dxvk
winetricks -q dotnet452 vcrun2005 vcrun2008 vcrun2015 dotnet48
#winetricks -q dotnet452 vcrun2005 vcrun2008 vcrun2015 dotnet48 dxvk
#wine regsvr32 wineasio.dll

# Fonts
winetricks -q corefonts allfonts cjkfonts

# Registry
wine reg add 'HKEY_CURRENT_USER\Software\Wine\X11 Driver' /t REG_SZ /v UseTakeFocus /d N /f 

# DOTNET_ROOT
wine reg add "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment" \
    /v DOTNET_ROOT \
    /t REG_SZ \
    /d "C:\\Program Files\\dotnet" \
    /f

# DOTNET_ROOT(x86)
wine reg add "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment" \
    /v "DOTNET_ROOT(x86)" \
    /t REG_SZ \
    /d "C:\\Program Files\\dotnet" \
    /f

# Prepend Wine’s dotnet folder to the Windows PATH
wine reg add "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment" \
    /v Path \
    /t REG_EXPAND_SZ \
    /d "%SystemRoot%\\system32;%SystemRoot%;%SystemRoot%\\System32\\Wbem;C:\\Program Files\\dotnet;%Path%" \
    /f

winecfg -v win11

sudo winetricks --self-update

cp runtimes/wine/.local/share/applications/* "$HOME/.local/share/applications/"

echo -e "\e[1;32m[Wine] setup complete.\e[0m"