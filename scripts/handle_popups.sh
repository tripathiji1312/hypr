#!/bin/bash

# The script needs the window address, which is passed by the socat listener
WINDOW_ADDRESS=$1

# Give the window a moment to update its title
sleep 0.5 

# Get the window's class and title using its address
WINDOW_INFO=$(hyprctl clients -j | jq --arg ADDRESS "0x${WINDOW_ADDRESS}" '.[] | select(.address == $ADDRESS)')
WINDOW_CLASS=$(echo "$WINDOW_INFO" | jq -r '.class')
WINDOW_TITLE=$(echo "$WINDOW_INFO" | jq -r '.title')

# Check if it's the specific window you want to float
if [[ "$WINDOW_CLASS" == "brave-browser" && "$WINDOW_TITLE" == "Sign in – Google accounts - Brave" ]]; then
  # If it matches, make it float
  hyprctl dispatch togglefloating address:"0x${WINDOW_ADDRESS}"
  # Optional: Center the new floating window
  hyprctl dispatch centerwindow address:"0x${WINDOW_ADDRESS}"
fi