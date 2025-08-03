#!/bin/bash

# --- Configuration ---
WALLPAPER_DIR="/home/tripathiji/.config/hypr/wallpaper"
SLEEP_INTERVAL=300

# --- Script Logic ---

# Check if swww-daemon is running. If not, start it.
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi

while true; do
    NEW_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

    if [ -n "$NEW_WALLPAPER" ]; then
        # Set wallpaper with swww for smooth transitions
        swww img "$NEW_WALLPAPER" --transition-type any --transition-duration 1.5

        # Generate and apply color scheme with Pywal
        wal -i "$NEW_WALLPAPER" -q -n

        # Reload themed applications
        ~/.config/hypr/scripts/pywal_reload.sh
    fi

    sleep $SLEEP_INTERVAL
done