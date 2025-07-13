#!/bin/bash

add_if_missing() {
    local LINE="$1"
    local FILE="$2"
    if ! grep -Fxq "$LINE" "$FILE" 2>/dev/null; then
        if [ -w "$FILE" ]; then
            echo "$LINE" >> "$FILE"
        else
            echo "$LINE" | sudo tee -a "$FILE" > /dev/null
        fi
    fi
}