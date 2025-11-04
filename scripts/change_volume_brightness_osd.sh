#!/bin/bash

# Volume/Brightness control script that writes to /tmp for OSD monitoring

case $1 in
    volume_up)
        pamixer -i 5
        pamixer --get-volume > /tmp/volume_osd
        ;;
    volume_down)
        pamixer -d 5
        pamixer --get-volume > /tmp/volume_osd
        ;;
    volume_mute)
        pamixer -t
        pamixer --get-volume > /tmp/volume_osd
        ;;
    brightness_up)
        brightnessctl set +5%
        # Get current and max brightness, calculate percentage
        current=$(brightnessctl get)
        max=$(brightnessctl max)
        percentage=$((current * 100 / max))
        echo "$percentage" > /tmp/brightness_osd
        ;;
    brightness_down)
        brightnessctl set 5%-
        # Get current and max brightness, calculate percentage
        current=$(brightnessctl get)
        max=$(brightnessctl max)
        percentage=$((current * 100 / max))
        echo "$percentage" > /tmp/brightness_osd
        ;;
esac
