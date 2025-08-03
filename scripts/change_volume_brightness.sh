#!/bin/bash

# A script to handle volume and brightness changes and send a notification.

# Function to send a notification with a progress bar
send_notification() {
    # The first argument ($1) is the icon
    # The second argument ($2) is the notification text (e.g., "Volume: 50%")
    # The third argument ($3) is the progress bar value (0-100)
    dunstify -i "$1" -h "int:value:$3" -h "string:x-dunst-stack-tag:media" "$2" -t 1500
}

# Main logic
case $1 in
    volume_up)
        # Unmute the sink and increase the volume
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
        # Get the new volume and send notification
        VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
        send_notification "audio-volume-high" "Volume: ${VOLUME}%" "$VOLUME"
        ;;
    volume_down)
        # Decrease the volume and send notification
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
        send_notification "audio-volume-low" "Volume: ${VOLUME}%" "$VOLUME"
        ;;
    volume_mute)
        # Toggle mute and send notification
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        IS_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; echo $?)
        if [ "$IS_MUTED" -eq 0 ]; then
            send_notification "audio-volume-muted" "Muted" "0"
        else
            VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
            send_notification "audio-volume-high" "Volume: ${VOLUME}%" "$VOLUME"
        fi
        ;;
    brightness_up)
        # Increase brightness and send notification
        brightnessctl set 5%+
        BRIGHTNESS=$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')
        send_notification "display-brightness-high" "Brightness: ${BRIGHTNESS}%" "$BRIGHTNESS"
        ;;
    brightness_down)
        # Decrease brightness and send notification
        brightnessctl set 5%-
        BRIGHTNESS=$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')
        send_notification "display-brightness-low" "Brightness: ${BRIGHTNESS}%" "$BRIGHTNESS"
        ;;
esac