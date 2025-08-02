#!/bin/bash
set -e

USER=$(whoami)
STEAM_CONFIG_DIR="/home/$USER/.steam/steam/config"
STEAMVR_SETTINGS="$STEAM_CONFIG_DIR/steamvr.vrsettings"
STEAM_DIR="/home/$USER/.steam/steam"

# Check if Steam directory exists
if [ ! -d "$STEAM_DIR" ]; then
    exit 0
fi

# If config file does not exist, create it with minimal content
if [ ! -f "$STEAMVR_SETTINGS" ]; then
    mkdir -p "$STEAM_CONFIG_DIR"
    cat > "$STEAMVR_SETTINGS" <<EOF
{
    "steamvr" : {
        "enableLinuxVulkanAsync" : true
    }
}
EOF
    exit 0
fi

# If config file exists, update enableLinuxVulkanAsync using jq
if command -v jq >/dev/null 2>&1; then
    jq '.steamvr.enableLinuxVulkanAsync = true' "$STEAMVR_SETTINGS" > "$STEAMVR_SETTINGS.tmp" && mv "$STEAMVR_SETTINGS.tmp" "$STEAMVR_SETTINGS"
else
    echo "Error: jq is not installed. Please install jq to use this script." >&2
    exit 1
fi

echo -e "\e[1;32m[fixes] SteamVR settings updated successfully.\e[0m"