#!/bin/bash
set -e

URL="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton10-10/GE-Proton10-10.tar.gz"
FILENAME="$(basename "$URL")"

STEAM_COMPAT_DIR="$HOME/.steam/root/compatibilitytools.d"
ALT_STEAM_DIR="$HOME/.local/share/Steam/compatibilitytools.d"

if [[ -d "$STEAM_COMPAT_DIR" ]]; then
    TARGET_DIR="$STEAM_COMPAT_DIR"
elif [[ -d "$ALT_STEAM_DIR" ]]; then
    TARGET_DIR="$ALT_STEAM_DIR"
else
    # Prefer .steam structure but fallback to .local
    TARGET_DIR="$STEAM_COMPAT_DIR"
    mkdir -p "$TARGET_DIR"
    echo "Created compatibilitytools.d directory at $TARGET_DIR"
fi

cd /tmp
echo "Downloading $FILENAME ..."
curl --http1.1 -C - -LO "$URL"

if tar -tzf "$FILENAME" > /dev/null 2>&1; then
    echo "Extracting to $TARGET_DIR ..."
    tar -xvf "$FILENAME" -C "$TARGET_DIR"
    echo "Installed $FILENAME to $TARGET_DIR"
    if [[ -f "$FILENAME" ]]; then
        rm "$FILENAME"
    fi
else
    echo "Download appears to be corrupt. Removing file."
    rm -f "$FILENAME"
    exit 1
fi

echo "Installed GE-Proton10-10 to $TARGET_DIR"

echo -e "\e[1;32m[Proton] setup complete.\e[0m"