#!/bin/bash

# This script changes the wallpaper once and applies the theme.
# It is designed to be called by a keybind.

# --- Configuration ---
WALLPAPER_DIR="/home/tripathiji/.config/hypr/wallpaper"

# --- Script Logic ---

# Find a new random wallpaper
# We add a check to ensure it's not the same as the current one, if possible.
CURRENT_WALLPAPER=$(cat ~/.cache/wal/wal)
NEW_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | grep -v "$CURRENT_WALLPAPER" | shuf -n 1)

# If no different wallpaper is found (e.g., only one wallpaper in the folder),
# just pick any random one.
if [ -z "$NEW_WALLPAPER" ]; then
    NEW_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
fi

# Check if a wallpaper was found
if [ -n "$NEW_WALLPAPER" ]; then
    # Set wallpaper with swww for smooth transitions
    # We redirect output to /dev/null to prevent messages in the terminal
    swww img "$NEW_WALLPAPER" --transition-type any --transition-duration 1.5 > /dev/null 2>&1

    # Generate and apply color scheme with Pywal
    wal -i "$NEW_WALLPAPER" -q -n

    # Reload themed applications by calling the central reload script
    ~/.config/hypr/scripts/pywal_reload.sh
fi