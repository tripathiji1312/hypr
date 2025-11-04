#!/bin/bash

# Simplified volume/brightness control without notifications
# QuickShell OSD will handle the visual feedback

# Main logic: determines which action to take
case $1 in
    volume_up)
        if command -v pamixer >/dev/null; then
            pamixer --unmute
            pamixer -i 5
        elif command -v amixer >/dev/null; then
            amixer set Master unmute
            amixer set Master 5%+
        fi
        ;;
    volume_down)
        if command -v pamixer >/dev/null; then
            pamixer --unmute
            pamixer -d 5
        elif command -v amixer >/dev/null; then
            amixer set Master unmute
            amixer set Master 5%-
        fi
        ;;
    volume_mute)
        if command -v pamixer >/dev/null; then
            pamixer -t
        elif command -v amixer >/dev/null; then
            amixer set Master toggle
        fi
        ;;
    brightness_up)
        if command -v brightnessctl >/dev/null; then
            brightnessctl set 10%+
        fi
        ;;
    brightness_down)
        if command -v brightnessctl >/dev/null; then
            brightnessctl set 10%-
        fi
        ;;
    *)
        echo "Usage: $0 {volume_up|volume_down|volume_mute|brightness_up|brightness_down}"
        exit 1
        ;;
esac
