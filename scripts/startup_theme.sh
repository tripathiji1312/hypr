# ~/.config/hypr/scripts/startup_theme.sh

#!/bin/bash

# This script sets a random wallpaper and theme on startup.

# --- Configuration ---
WALLPAPER_DIR="/home/tripathiji/.config/hypr/wallpaper"

# --- Script Logic ---

# Start the swww daemon if it's not running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1 # Give the daemon a moment to start
fi

# Find a random wallpaper
NEW_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Check if a wallpaper was found
if [ -n "$NEW_WALLPAPER" ]; then
    # Set wallpaper with swww
    swww img "$NEW_WALLPAPER" --transition-type any

    # Generate and apply color scheme with Pywal (quietly)
    wal -i "$NEW_WALLPAPER" -q -n

    # Reload themed applications by calling the central reload script
    ~/.config/hypr/scripts/pywal_reload.sh
fi