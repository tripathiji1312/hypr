#!/bin/bash

# --- Manual Wallpaper Change Script ---
# Changes wallpaper, generates new Pywal colors, and then fixes the GTK theme.

WALLPAPER_DIR="/home/tripathiji/.config/hypr/wallpaper"

# Find a new random wallpaper
CURRENT_WALLPAPER=$(cat ~/.cache/wal/wal 2>/dev/null)
NEW_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | grep -v "$CURRENT_WALLPAPER" | shuf -n 1)

# Fallback if no different wallpaper is found
if [ -z "$NEW_WALLPAPER" ]; then
    NEW_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
fi

if [ -n "$NEW_WALLPAPER" ]; then
    # Set the wallpaper visually
    swww img "$NEW_WALLPAPER" --transition-type any --transition-duration 1.5

    # Generate new Pywal colors for terminal, bars, etc.
    wal -i "$NEW_WALLPAPER" -q -n

    # CRITICAL: Immediately call the fixer script to override the GTK theme
    ~/.config/hypr/scripts/pywal_reload.sh
fi