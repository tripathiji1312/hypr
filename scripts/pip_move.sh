#!/bin/bash
# filepath: ~/.config/hypr/scripts/pip_move.sh

# CUSTOM PiP Move Script - Optimized for Vivaldi Meet

# Function to find PiP window with YOUR exact pattern
find_pip_window() {
    # Method 1: Vivaldi Meet PiP (EXACT match for your setup)
    # Matches: "Meet - xxx-xxx-xxx" title, vivaldi-stable class, small floating window
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
    
    if [ -n "$addr" ]; then
        echo "$addr"
        return
    fi
    
    # Method 2: ANY Vivaldi window starting with "Meet -" (more flexible)
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
    
    if [ -n "$addr" ]; then
        echo "$addr"
        return
    fi
    
    # Method 3: Traditional PiP title
    addr=$(hyprctl clients -j | jq -r '
        .[] | 
        select(.title | test("Picture-in-Picture|Picture in Picture|PiP"; "i")) | 
        .address
    ' | head -n 1)
    
    if [ -n "$addr" ]; then
        echo "$addr"
        return
    fi
    
    # Method 4: ANY small Vivaldi floating window (fallback)
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

# Find the PiP window
PIP_ADDR=$(find_pip_window)

if [ -z "$PIP_ADDR" ]; then
    notify-send "❌ PiP Not Found" "No Meet PiP window detected\n\nMake sure:\n• Meet PiP is open\n• Window is floating (not tiled)" -t 4000 -u critical
    exit 1
fi

# Get window info for debugging
WINDOW_INFO=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$PIP_ADDR\")")
WINDOW_TITLE=$(echo "$WINDOW_INFO" | jq -r '.title')
WINDOW_CLASS=$(echo "$WINDOW_INFO" | jq -r '.class')
PIP_WIDTH=$(echo "$WINDOW_INFO" | jq -r '.size[0]')
PIP_HEIGHT=$(echo "$WINDOW_INFO" | jq -r '.size[1]')

# Read current position state
STATE_FILE="$HOME/.config/hypr/.pip_position"
CURRENT_POS=$(cat "$STATE_FILE" 2>/dev/null || echo "0")

# Screen dimensions
SCREEN_WIDTH=$(hyprctl monitors -j | jq -r '.[0].width')
SCREEN_HEIGHT=$(hyprctl monitors -j | jq -r '.[0].height')

# Calculate positions (with 20px margin)
MARGIN=20

case "$CURRENT_POS" in
    0)
        # Bottom right (default)
        X=$((SCREEN_WIDTH - PIP_WIDTH - MARGIN))
        Y=$((SCREEN_HEIGHT - PIP_HEIGHT - MARGIN))
        NEXT_POS=1
        LOCATION="Bottom Right ↘"
        ;;
    1)
        # Bottom left
        X=$MARGIN
        Y=$((SCREEN_HEIGHT - PIP_HEIGHT - MARGIN))
        NEXT_POS=2
        LOCATION="Bottom Left ↙"
        ;;
    2)
        # Top right
        X=$((SCREEN_WIDTH - PIP_WIDTH - MARGIN))
        Y=$MARGIN
        NEXT_POS=3
        LOCATION="Top Right ↗"
        ;;
    3)
        # Top left
        X=$MARGIN
        Y=$MARGIN
        NEXT_POS=0
        LOCATION="Top Left ↖"
        ;;
esac

# Move window
hyprctl dispatch movewindowpixel exact $X $Y,address:$PIP_ADDR

# Also pin it to stay on top
hyprctl dispatch pin address:$PIP_ADDR

# Save state
echo "$NEXT_POS" > "$STATE_FILE"

# Notification with window info
notify-send "✅ PiP Moved: $LOCATION" "Window: $WINDOW_CLASS\nTitle: ${WINDOW_TITLE:0:30}\nSize: ${PIP_WIDTH}x${PIP_HEIGHT}" -t 1500