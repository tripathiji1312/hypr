#!/usr/bin/env bash
set -euo pipefail

# --- Startup Script ---
# Restores the last wallpaper if available, otherwise picks a random one,
# then generates Pywal colors and fixes the GTK theme.

WALLPAPER_HELPER="$HOME/.config/hypr/scripts/wallpaper_sync.sh"

NEW_WALLPAPER="$($WALLPAPER_HELPER)"

if [[ -n "$NEW_WALLPAPER" ]]; then
    # Generate Pywal colors for terminal, bars, etc.
    # The -n flag skips an internal wallpaper set, -q makes it quiet.
    wal -i "$NEW_WALLPAPER" -q -n

    # CRITICAL: Immediately call the fixer script to override the GTK theme
    ~/.config/hypr/scripts/pywal_reload.sh
fi