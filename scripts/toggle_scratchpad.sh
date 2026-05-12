#!/bin/bash
# Enhanced Scratchpad Control Script
# Provides functionality to move windows to/from scratchpad with smart workspace handling
# 
# Usage:
#   toggle_scratchpad.sh toggle              # Open/close scratchpad terminal
#   toggle_scratchpad.sh move <workspace>    # Move active window to workspace and close scratchpad
#   toggle_scratchpad.sh focus               # Focus scratchpad or fallback to workspace 1

set -e

ACTION="${1:-toggle}"
TARGET_WORKSPACE="${2:-1}"

case "$ACTION" in
  toggle)
    # Toggle scratchpad terminal visibility
    hyprctl dispatch togglespecialworkspace term
    ;;
    
  move)
    # Move active window to target workspace and close scratchpad if open
    
    # Get active workspace (to check if we're in scratchpad)
    ACTIVE_WS=$(hyprctl activewindow -j | jq -r '.workspace.id // 0')
    SPECIAL_WS=$(hyprctl activewindow -j | jq -r '.workspace.name // ""')
    
    # If we're in the special workspace, close it
    if [[ "$SPECIAL_WS" == *"special:"* ]]; then
      # Close the special workspace first
      hyprctl dispatch togglespecialworkspace "${SPECIAL_WS#special:}"
      
      # Brief pause to allow dispatch ordering
      sleep 0.1
    fi
    
    # Move active window to target workspace
    hyprctl dispatch movetoworkspace "$TARGET_WORKSPACE"
    
    # Optionally focus the target workspace
    hyprctl dispatch workspace "$TARGET_WORKSPACE"
    ;;
    
  focus)
    # Focus scratchpad, or fallback to workspace 1
    SPECIAL_WS=$(hyprctl activewindow -j | jq -r '.workspace.name // ""')
    
    if [[ "$SPECIAL_WS" == "special:term" ]]; then
      # Already in scratchpad, toggle to close
      hyprctl dispatch togglespecialworkspace term
    else
      # Open scratchpad
      hyprctl dispatch togglespecialworkspace term
    fi
    ;;
    
  *)
    echo "Usage: $0 {toggle|move <workspace>|focus}"
    echo "  toggle              - Open/close scratchpad terminal"
    echo "  move <workspace>    - Move active window to workspace and close scratchpad"
    echo "  focus               - Focus scratchpad or fallback"
    exit 1
    ;;
esac
