#!/usr/bin/env bash
set -euo pipefail

# --- Manual Wallpaper Change Script ---
# Changes wallpaper, generates new Pywal colors, and then fixes the GTK theme.

WALLPAPER_DIR="/home/tripathiji/.config/hypr/wallpaper"
WALLPAPER_HELPER="$HOME/.config/hypr/scripts/wallpaper_sync.sh"

# Find a new random wallpaper different from the currently cached one.
CURRENT_WALLPAPER="$(cat ~/.cache/wal/wal 2>/dev/null || true)"
if [[ -n "$CURRENT_WALLPAPER" ]]; then
    NEW_WALLPAPER="$(find "$WALLPAPER_DIR" -type f | grep -vxF "$CURRENT_WALLPAPER" | shuf -n 1)"
else
    NEW_WALLPAPER="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"
fi

# Fallback if no different wallpaper is found.
if [[ -z "$NEW_WALLPAPER" ]]; then
    NEW_WALLPAPER="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"
fi

if [[ -n "$NEW_WALLPAPER" ]]; then
    NEW_WALLPAPER="$($WALLPAPER_HELPER "$NEW_WALLPAPER")"

    # Generate new Pywal colors for terminal, bars, etc.
    wal -i "$NEW_WALLPAPER" -q -n

    # CRITICAL: Immediately call the fixer script to override the GTK theme
    ~/.config/hypr/scripts/pywal_reload.sh
fi