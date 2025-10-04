#!/bin/bash
# Popup Debug Script
# Run this, then open a popup/context menu within 3 seconds

echo "Waiting 3 seconds... Open a popup NOW!"
sleep 3

echo -e "\n=== All floating windows with empty titles ==="
hyprctl clients -j | jq '.[] | select(.floating == true and .title == "") | {class, title, size, at, floating, xwayland, borderSize, decorate}'

echo -e "\n=== All windows (last 5) ==="
hyprctl clients | tail -100 | head -80

echo -e "\n=== Current window rules for empty titles ==="
hyprctl getoption windowrule -j | jq '.custom | .[] | select(.rule | contains("title:^$"))'
