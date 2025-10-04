#!/bin/bash
# filepath: ~/.config/hypr/scripts/hybrid_theme.sh

# Hybrid Theme System - Pywal base + Catppuccin Mocha accents

# Generate Pywal colors
wal -i ~/Wallpapers/ -n -q

# Static accent colors (Catppuccin Mocha)
ACCENT_TEAL="rgba(94e2d5ff)"
ACCENT_MAUVE="rgba(cba6f7ff)"
ACCENT_RED="rgba(f38ba8ff)"
ACCENT_GREEN="rgba(a6e3a1ff)"
ACCENT_YELLOW="rgba(f9e2afff)"
ACCENT_BLUE="rgba(89b4faff)"

# Get Pywal's background/foreground
source ~/.cache/wal/colors.sh

# Apply to Hyprland
hyprctl keyword general:col.active_border "$ACCENT_TEAL $ACCENT_MAUVE 45deg"
hyprctl keyword general:col.inactive_border "rgba(585b70aa)"

# Update Waybar
killall -SIGUSR2 waybar

# Update terminal colors
cat ~/.cache/wal/sequences

# Notification
notify-send "🎨 Hybrid Theme" "Wallpaper: $(basename $(cat ~/.cache/wal/wal))" -t 3000