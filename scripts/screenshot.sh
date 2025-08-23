#!/bin/bash
# A unified screenshot script using grim, slurp, and swappy.

SCREENSHOT_DIR=~/Pictures/Screenshots
mkdir -p "$SCREENSHOT_DIR"
FILENAME="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"

# Wofi menu for options
chosen_option=$(echo -e "󰍹 Fullscreen\n󰆞 Region\n Window" | wofi --dmenu --prompt "Screenshot")

# Capture based on choice
case "$chosen_option" in
    "󰍹 Fullscreen")
        grim "$FILENAME"
        ;;
    "󰆞 Region")
        grim -g "$(slurp)" "$FILENAME"
        ;;
    " Window")
        grim -g "$(hyprctl -j clients | jq -r '.[] | select(.focused) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$FILENAME"
        ;;
    *)
        exit 1
        ;;
esac

# Check if the screenshot was created successfully
if [ -f "$FILENAME" ]; then
    # Ask what to do with the screenshot
    action=$(echo -e " Edit\n Copy\n💾 Save" | wofi --dmenu --prompt "Action")
    case "$action" in
        " Edit")
            swappy -f "$FILENAME"
            ;;
        " Copy")
            wl-copy < "$FILENAME"
            notify-send "Screenshot" "Copied to clipboard."
            ;;
        "💾 Save")
            notify-send "Screenshot" "Saved to file."
            ;;
    esac
else
    notify-send -u critical "Screenshot" "Failed to capture."
fi