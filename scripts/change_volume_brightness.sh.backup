#!/bin/bash

# A unified script to control volume and brightness and send OSD notifications.
# This version uses multiple fallback icon names for maximum compatibility.

# Unique notification IDs for replacing
VOLUME_ID=2593
BRIGHTNESS_ID=2594

# Function to find the best available icon
find_icon() {
    local icon_names=("$@")
    
    # First try to find the icon by exact name
    for icon in "${icon_names[@]}"; do
        if find /usr/share/icons /usr/share/pixmaps -name "${icon}.svg" -o -name "${icon}.png" -o -name "${icon}.xpm" 2>/dev/null | head -1 | grep -q .; then
            echo "$icon"
            return 0
        fi
    done
    
    # Then try partial matches
    for icon in "${icon_names[@]}"; do
        if find /usr/share/icons /usr/share/pixmaps -name "*${icon}*" -type f 2>/dev/null | head -1 | grep -q .; then
            # Return the full path for partial matches
            found_icon=$(find /usr/share/icons /usr/share/pixmaps -name "*${icon}*" -type f 2>/dev/null | head -1)
            echo "$found_icon"
            return 0
        fi
    done
    
    # Final fallback - just use a simple name without icon
    echo ""
}

# Function to send a volume notification
send_volume_notification() {
    # Check if pamixer is available, otherwise use amixer
    if command -v pamixer >/dev/null; then
        volume=$(pamixer --get-volume 2>/dev/null || echo "50")
        is_muted=$(pamixer --get-mute 2>/dev/null || echo "false")
    elif command -v amixer >/dev/null; then
        # Fallback to amixer
        volume=$(amixer get Master | grep -oP '\[\K[0-9]+(?=%\])' | head -1)
        mute_status=$(amixer get Master | grep -o '\[on\]\|\[off\]' | head -1)
        is_muted="false"
        [ "$mute_status" = "[off]" ] && is_muted="true"
        [ -z "$volume" ] && volume="50"
    else
        # Last resort - fake values for testing
        volume="50"
        is_muted="false"
        dunstify -a "volume_osd" -u normal -r "$VOLUME_ID" "Volume" "⚠️ No audio control found (pamixer/amixer)"
        return
    fi

    if [ "$is_muted" = "true" ]; then
        # Use the icons we know exist
        icon=$(find_icon "audio-volume-muted" "player-volume-muted" "stock_volume")
        if [ -n "$icon" ]; then
            dunstify -a "volume_osd" -i "$icon" -u low -r "$VOLUME_ID" "Volume" "Muted"
        else
            dunstify -a "volume_osd" -u low -r "$VOLUME_ID" "Volume" "🔇 Muted"
        fi
    else
        # Choose appropriate volume icon based on level
        if [ "$volume" -ge 70 ]; then
            icon=$(find_icon "audio-volume-high" "multimedia-volume-control" "gnome-volume-control")
        elif [ "$volume" -ge 30 ]; then
            icon=$(find_icon "audio-volume-medium" "multimedia-volume-control" "gnome-volume-control")
        else
            icon=$(find_icon "audio-volume-low" "multimedia-volume-control" "gnome-volume-control")
        fi
        
        if [ -n "$icon" ] && [ "$volume" -ge 0 ] 2>/dev/null; then
            dunstify -a "volume_osd" -i "$icon" -u low -r "$VOLUME_ID" "Volume" "${volume}%" -h "int:value:$volume"
        else
            # Fallback with emoji if no icon found
            if [ "$volume" -ge 70 ]; then
                dunstify -a "volume_osd" -u low -r "$VOLUME_ID" "Volume" "🔊 ${volume}%"
            elif [ "$volume" -ge 30 ]; then
                dunstify -a "volume_osd" -u low -r "$VOLUME_ID" "Volume" "🔉 ${volume}%"
            else
                dunstify -a "volume_osd" -u low -r "$VOLUME_ID" "Volume" "🔈 ${volume}%"
            fi
        fi
    fi
}

# Function to send a brightness notification
send_brightness_notification() {
    # Get brightness percentage more reliably
    if command -v brightnessctl >/dev/null; then
        # Try different methods to get brightness
        brightness_output=$(brightnessctl 2>/dev/null)
        if [ $? -eq 0 ]; then
            percent=$(echo "$brightness_output" | grep -o "([0-9]*%)" | tr -d "()" | head -1)
            # Remove % sign for numeric value
            numeric_percent=$(echo "$percent" | tr -d '%')
            
            # Validate numeric_percent
            if ! [ "$numeric_percent" -eq "$numeric_percent" ] 2>/dev/null; then
                numeric_percent=50
                percent="50%"
            fi
        else
            percent="N/A"
            numeric_percent=50
        fi
    elif command -v xrandr >/dev/null; then
        # Fallback to xrandr brightness (usually 1.0 = 100%)
        brightness=$(xrandr --verbose | grep -i brightness | head -1 | awk '{print $2}')
        if [ -n "$brightness" ]; then
            numeric_percent=$(echo "$brightness * 100" | bc 2>/dev/null || echo "50")
            percent="${numeric_percent}%"
        else
            percent="N/A"
            numeric_percent=50
        fi
    else
        percent="N/A"
        numeric_percent=50
        dunstify -a "brightness_osd" -u normal -r "$BRIGHTNESS_ID" "Brightness" "⚠️ No brightness control found"
        return
    fi

    # Use the brightness icons we know exist
    icon=$(find_icon "xfpm-brightness-lcd" "gpm-brightness-lcd" "brightnesssettings" "video-display")
    
    if [ -n "$icon" ] && [ "$numeric_percent" -ge 0 ] 2>/dev/null; then
        dunstify -a "brightness_osd" -i "$icon" -u low -r "$BRIGHTNESS_ID" "Brightness" "${percent}" -h "int:value:$numeric_percent"
    else
        # Fallback with emoji if no icon found
        dunstify -a "brightness_osd" -u low -r "$BRIGHTNESS_ID" "Brightness" "💡 ${percent}"
    fi
}

# Function to show current status (useful for testing)
show_status() {
    echo "=== System Status ==="
    echo "Volume: $(pamixer --get-volume)% (Muted: $(pamixer --get-mute))"
    if command -v brightnessctl >/dev/null; then
        echo "Brightness: $(brightnessctl | grep -o "([0-9]*%)" | tr -d "()")"
    else
        echo "Brightness: brightnessctl not found"
    fi
    echo "Available icon themes:"
    find /usr/share/icons -maxdepth 1 -type d -name "*" | head -5
}

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
        send_volume_notification
        ;;
    volume_down)
        if command -v pamixer >/dev/null; then
            pamixer --unmute
            pamixer -d 5
        elif command -v amixer >/dev/null; then
            amixer set Master unmute
            amixer set Master 5%-
        fi
        send_volume_notification
        ;;
    volume_mute)
        if command -v pamixer >/dev/null; then
            pamixer -t
        elif command -v amixer >/dev/null; then
            amixer set Master toggle
        fi
        send_volume_notification
        ;;
    brightness_up)
        if command -v brightnessctl >/dev/null; then
            brightnessctl set 10%+
            send_brightness_notification
        else
            dunstify -a "brightness_osd" -i "dialog-error" -u normal "Error" "brightnessctl not found"
        fi
        ;;
    brightness_down)
        if command -v brightnessctl >/dev/null; then
            brightnessctl set 10%-
            send_brightness_notification
        else
            dunstify -a "brightness_osd" -i "dialog-error" -u normal "Error" "brightnessctl not found"
        fi
        ;;
    status)
        show_status
        ;;
    test_volume)
        send_volume_notification
        ;;
    test_brightness)
        send_brightness_notification
        ;;
    *)
        echo "Usage: $0 {volume_up|volume_down|volume_mute|brightness_up|brightness_down|status|test_volume|test_brightness}"
        echo ""
        echo "Available commands:"
        echo "  volume_up      - Increase volume by 5%"
        echo "  volume_down    - Decrease volume by 5%"
        echo "  volume_mute    - Toggle volume mute"
        echo "  brightness_up  - Increase brightness by 10%"
        echo "  brightness_down- Decrease brightness by 10%"
        echo "  status         - Show current system status"
        echo "  test_volume    - Test volume notification"
        echo "  test_brightness- Test brightness notification"
        exit 1
        ;;
esac