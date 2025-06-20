#!/bin/bash

# This script will randomly select a wallpaper from the specified directory
# and set it using hyprpaper. It will also unload the previous wallpaper
# to free up memory.

# Directory containing your wallpapers
WALLPAPER_DIR="/home/tripathiji/.config/hypr/wallpaper"

# Time in seconds to wait before changing the wallpaper
SLEEP_INTERVAL=300 # 300 seconds = 5 minutes

# The currently set wallpaper, initially empty
CURRENT_WALLPAPER=""

# Start hyprpaper if it's not already running
# This is a safety measure
if ! pgrep -x hyprpaper > /dev/null; then
    hyprpaper &
    sleep 1 # Give it a moment to start
fi

while true; do
    # Find a random wallpaper file in the directory
    # -type f ensures we only get files
    # shuf -n 1 picks one random line
    NEW_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

    # Check if a new wallpaper was found and it's different from the current one
    if [ -n "$NEW_WALLPAPER" ] && [ "$NEW_WALLPAPER" != "$CURRENT_WALLPAPER" ]; then
        # Tell hyprpaper to preload the new wallpaper
        hyprctl hyprpaper preload "$NEW_WALLPAPER"

        # Tell hyprpaper to set the new wallpaper
        # The comma at the beginning means it applies to all monitors
        hyprctl hyprpaper wallpaper ",$NEW_WALLPAPER"

        # If there was a previously set wallpaper, tell hyprpaper to unload it
        if [ -n "$CURRENT_WALLPAPER" ]; then
            hyprctl hyprpaper unload "$CURRENT_WALLPAPER"
        fi

        # Update the current wallpaper variable
        CURRENT_WALLPAPER="$NEW_WALLPAPER"
    fi

    # Wait for the specified interval before the next change
    sleep $SLEEP_INTERVAL
done
