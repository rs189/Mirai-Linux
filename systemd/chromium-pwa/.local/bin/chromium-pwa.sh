#!/bin/bash

WATCH_DIR="$HOME/.local/share/applications"

inotifywait -m -e create --format '%f' "$WATCH_DIR" | while read -r FILENAME; do
    echo "[Mirai] [chromium pwa] Detected new file $FILENAME at $(date)"

    FILEPATH="$WATCH_DIR/$FILENAME"

    if [[ "$FILENAME" =~ ^(vivaldi|msedge|chrome|google-chrome|chromium|opera)-.*\.desktop$ ]]; then
        sleep 1.0

        if grep -q "^\[Desktop Entry\]" "$FILEPATH" && ! grep -q "^Categories=" "$FILEPATH"; then
            echo "[Mirai] [chromium pwa] Updating $FILENAME at $(date)"
            echo 'Categories=Utility;LostFound;' >> "$FILEPATH"
            update-desktop-database "$WATCH_DIR"
            kbuildsycoca5
        fi
    fi
done
