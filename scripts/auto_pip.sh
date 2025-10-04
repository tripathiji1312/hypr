#!/bin/bash
// filepath: ~/.config/hypr/scripts/auto_pip.sh

# Auto-enable PiP when switching away from browser workspace
# Requires browser extension like "AutoPictureInPicture" for full automation

socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | \
while read -r line; do
    if echo "$line" | grep -q "workspace>>"; then
        WORKSPACE=$(echo "$line" | cut -d'>' -f3)
        
        # Check if there's a browser with video on workspace 2
        BROWSER_WS=$(hyprctl clients -j | jq -r '.[] | select(.class | test("firefox|brave|chrome|vivaldi")) | .workspace.id')
        
        if [ "$BROWSER_WS" != "$WORKSPACE" ]; then
            # Switched away from browser workspace
            # Browser extensions should handle PiP activation
            # This just ensures window rules apply
            sleep 0.5
            
            # Find and move PiP to current workspace
            PIP_ADDR=$(hyprctl clients -j | jq -r '.[] | select(.title | test("Picture-in-Picture")) | .address')
            if [ -n "$PIP_ADDR" ]; then
                hyprctl dispatch movetoworkspace "$WORKSPACE,address:$PIP_ADDR"
            fi
        fi
    fi
done