#!/usr/bin/env bash
set -euo pipefail

# Read the wallpaper chosen by the shared wallpaper helper.
CACHE_FILE="$HOME/.cache/hypr/last_wallpaper"
HYPRLOCK="$HOME/.config/hypr/hyprlock.conf"

# Check if a wallpaper has been recorded
if [[ -f "$CACHE_FILE" ]]; then
    WALLPAPER="$(<"$CACHE_FILE")"
fi

if [[ -n "${WALLPAPER:-}" && -f "$WALLPAPER" ]]; then

    sed -i "s|^\(\$wallpaper[[:space:]]*=[[:space:]]*\).*|\1$WALLPAPER # (screenshot or /path/to/your/wallpaper.jpg)|" "$HYPRLOCK"
    echo "Wallpaper path updated to $WALLPAPER"
    exit 0
fi

# Error
echo "Fehler: kein Wallpaper gefunden."
exit 1
