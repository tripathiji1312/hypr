#!/bin/bash
# filepath: ~/.config/hypr/scripts/pip_resize.sh

# CUSTOM PiP Resize Script - Optimized for Vivaldi Meet

# Function to find PiP window (same as pip_move.sh)
find_pip_window() {
    local addr=$(hyprctl clients -j | jq -r '
        .[] | 
        select(
            (.class == "vivaldi-stable") and
            (.title | test("^Meet - [a-z]{3}-[a-z]{4}-[a-z]{3}$")) and
            .floating == true and
            (.size[0] < 500 and .size[1] < 500)
        ) | 
        .address
    ' | head -n 1)
    
    if [ -n "$addr" ]; then echo "$addr"; return; fi
    
    addr=$(hyprctl clients -j | jq -r '
        .[] | 
        select(
            (.class == "vivaldi-stable") and
            (.title | startswith("Meet -")) and
            .floating == true and
            (.size[0] < 600)
        ) | 
        .address
    ' | head -n 1)
    
    if [ -n "$addr" ]; then echo "$addr"; return; fi
    
    addr=$(hyprctl clients -j | jq -r '
        .[] | 
        select(.title | test("Picture-in-Picture|Picture in Picture|PiP"; "i")) | 
        .address
    ' | head -n 1)
    
    if [ -n "$addr" ]; then echo "$addr"; return; fi
    
    addr=$(hyprctl clients -j | jq -r '
        .[] | 
        select(
            (.class == "vivaldi-stable") and
            .floating == true and
            (.size[0] < 400 and .size[1] < 400)
        ) | 
        .address
    ' | head -n 1)
    
    echo "$addr"
}

# Find PiP window
PIP_ADDR=$(find_pip_window)

if [ -z "$PIP_ADDR" ]; then
    notify-send "❌ PiP Not Found" "No Meet PiP window detected" -t 2000 -u critical
    exit 1
fi

# Read current size state
STATE_FILE="$HOME/.config/hypr/.pip_size"
CURRENT_SIZE=$(cat "$STATE_FILE" 2>/dev/null || echo "15")

# Screen dimensions
SCREEN_WIDTH=$(hyprctl monitors -j | jq -r '.[0].width')
SCREEN_HEIGHT=$(hyprctl monitors -j | jq -r '.[0].height')

# Cycle through sizes (optimized for Meet's small default size)
case "$CURRENT_SIZE" in
    15) NEXT_SIZE=20 ;;
    20) NEXT_SIZE=25 ;;
    25) NEXT_SIZE=30 ;;
    30) NEXT_SIZE=35 ;;
    35) NEXT_SIZE=15 ;;
    *) NEXT_SIZE=20 ;;
esac

# Calculate new dimensions
NEW_WIDTH=$((SCREEN_WIDTH * NEXT_SIZE / 100))
NEW_HEIGHT=$((SCREEN_HEIGHT * NEXT_SIZE / 100))

# Resize window
hyprctl dispatch resizewindowpixel exact $NEW_WIDTH $NEW_HEIGHT,address:$PIP_ADDR

# Keep it in bottom-right corner
MARGIN=20
X=$((SCREEN_WIDTH - NEW_WIDTH - MARGIN))
Y=$((SCREEN_HEIGHT - NEW_HEIGHT - MARGIN))
hyprctl dispatch movewindowpixel exact $X $Y,address:$PIP_ADDR

# Pin it
hyprctl dispatch pin address:$PIP_ADDR

# Save state
echo "$NEXT_SIZE" > "$STATE_FILE"

# Notification
notify-send "✅ PiP Resized" "${NEXT_SIZE}% of screen\n${NEW_WIDTH}x${NEW_HEIGHT} pixels" -t 1500