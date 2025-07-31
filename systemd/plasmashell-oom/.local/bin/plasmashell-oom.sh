#!/bin/bash

# Max allowed memory in KB (5 GB)
MAX_KB=$((5 * 1024 * 1024))

echo "[Mirai] [plasmashell monitor] Starting plasmashell memory monitor..."

while true; do
    sleep 30

    # Get memory usage of plasmashell in KB
    MEM_KB=$(ps -C plasmashell -o rss= | awk '{sum+=$1} END {print sum+0}')
    
    if [ "$MEM_KB" -gt "$MAX_KB" ]; then
        echo "[Mirai] [plasmashell monitor] memory usage ${MEM_KB} KB > ${MAX_KB} KB. Restarting plasmashell."

        # Kill plasmashell
        kquitapp5 plasmashell || killall -9 plasmashell
        
        # Wait for it to die
        sleep 2
        
        # Start it again
        nohup plasmashell > /dev/null 2>&1 &
        
        echo "[Mirai] [plasmashell monitor] plasmashell restarted."

        sleep 3

        #MESSAGE="plasmashell is using too much memory (${MEM_KB} KB)."
        MESSAGE="KDE Plasma Desktop was using too much memory and has been restarted."
        kdialog --title "Mirai" --passivepopup "$MESSAGE" 5 &
        
    elif [ "$MEM_KB" -eq 0 ] || ! pgrep plasmashell >/dev/null 2>&1; then
        # plasmashell is not running, start it
        echo "[Mirai] [plasmashell monitor] plasmashell not running, starting it."
        nohup plasmashell > /dev/null 2>&1 &
    fi
done