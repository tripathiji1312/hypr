#!/bin/bash
# hotcorners.sh — macOS-style hot corners for Hyprland
# Lightweight daemon that polls cursor position and triggers actions.
#
# Corner actions (configurable):
#   TL = Top-Left     → Session Screen
#   TR = Top-Right    → Notification Center (sidebar)
#   BL = Bottom-Left  → Show Desktop (minimize all)
#   BR = Bottom-Right → Scratchpad Terminal
#
# Requirements: hyprctl, jq (optional but recommended)
# Usage: Add to autostart: exec-once = ~/.config/hypr/scripts/hotcorners.sh

# ─── Configuration ────────────────────────────────────────────
CORNER_SIZE=5       # Corner trigger zone size in percentage of screen
TRIGGER_DELAY=0.3   # Seconds cursor must stay in corner before trigger
COOLDOWN=1.5        # Seconds before corner can trigger again
# ──────────────────────────────────────────────────────────────

# Cache monitor geometry
get_monitor_geo() {
    hyprctl monitors -j | jq -r '.[0] | "\(.x) \(.y) \(.width) \(.height)"'
}

trigger_corner() {
    local corner="$1"
    case "$corner" in
        TL) ~/.config/quickshell/toggle-session-screen.sh ;;
        TR) ~/.config/quickshell/toggle-control-center.sh ;;
        BL) hyprctl dispatch workspace, special:desktop ;;
        BR) hyprctl dispatch togglespecialworkspace, term ;;
    esac
}

# State tracking
declare -A corner_timer
declare -A corner_triggered
for corner in TL TR BL BR; do
    corner_timer[$corner]=0
    corner_triggered[$corner]=0
done

# Main loop — check cursor position every 100ms
while true; do
    # Read monitor geometry
    read -r mx my mw mh <<< "$(get_monitor_geo)"
    [ -z "$mw" ] && { sleep 0.5; continue; }

    # Read cursor position
    read -r cx cy <<< "$(hyprctl cursorpos -j | jq -r '.x, .y')"
    [ -z "$cx" ] && { sleep 0.1; continue; }

    # Calculate screen-relative percentage
    rel_x=$(echo "scale=2; ($cx - $mx) / $mw * 100" | bc)
    rel_y=$(echo "scale=2; ($cy - $my) / $mh * 100" | bc)

    now=$(date +%s.%N)

    for corner in TL TR BL BR; do
        in_corner=false

        case "$corner" in
            TL) [ "$(echo "$rel_x < $CORNER_SIZE" | bc)" -eq 1 ] && [ "$(echo "$rel_y < $CORNER_SIZE" | bc)" -eq 1 ] && in_corner=true ;;
            TR) [ "$(echo "$rel_x > 100 - $CORNER_SIZE" | bc)" -eq 1 ] && [ "$(echo "$rel_y < $CORNER_SIZE" | bc)" -eq 1 ] && in_corner=true ;;
            BL) [ "$(echo "$rel_x < $CORNER_SIZE" | bc)" -eq 1 ] && [ "$(echo "$rel_y > 100 - $CORNER_SIZE" | bc)" -eq 1 ] && in_corner=true ;;
            BR) [ "$(echo "$rel_x > 100 - $CORNER_SIZE" | bc)" -eq 1 ] && [ "$(echo "$rel_y > 100 - $CORNER_SIZE" | bc)" -eq 1 ] && in_corner=true ;;
        esac

        cooldown_remaining=$(echo "$now - ${corner_triggered[$corner]} < $COOLDOWN" | bc)

        if $in_corner && [ "$cooldown_remaining" -eq 0 ]; then
            # Start or update timer
            if [ "${corner_timer[$corner]}" = "0" ]; then
                corner_timer[$corner]=$now
            else
                elapsed=$(echo "$now - ${corner_timer[$corner]} >= $TRIGGER_DELAY" | bc)
                if [ "$elapsed" -eq 1 ]; then
                    trigger_corner "$corner"
                    corner_triggered[$corner]=$now
                    corner_timer[$corner]=0
                    # Small sleep after trigger to prevent double-fire
                    sleep 0.2
                fi
            fi
        else
            corner_timer[$corner]=0
        fi
    done

    sleep 0.1
done
