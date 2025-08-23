#!/bin/bash

# --- Startup Script ---
# Sets wallpaper, generates Pywal colors, and then fixes the GTK theme.

WALLPAPER_DIR="/home/tripathiji/.config/hypr/wallpaper"

# Start the swww daemon if it's not running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 1
fi

# Find and set a random wallpaper
NEW_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

if [ -n "$NEW_WALLPAPER" ]; then
    # Set the wallpaper visually
    swww img "$NEW_WALLPAPER" --transition-type any

    # Generate Pywal colors for terminal, bars, etc.
    # The -n flag skips an internal wallpaper set, -q makes it quiet.
    wal -i "$NEW_WALLPAPER" -q -n

    # CRITICAL: Immediately call the fixer script to override the GTK theme
    ~/.config/hypr/scripts/pywal_reload.sh
fi