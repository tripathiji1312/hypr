#!/bin/bash
// filepath: ~/.config/hypr/scripts/find_window_class.sh

# Window Class Inspector
# Click on any window to see its class, title, and properties

echo "Click on a window to inspect it..."
echo ""

# Wait for window selection
sleep 1

# Get active window info
WINDOW_INFO=$(hyprctl activewindow -j)

# Extract information
CLASS=$(echo "$WINDOW_INFO" | jq -r '.class')
TITLE=$(echo "$WINDOW_INFO" | jq -r '.title')
WORKSPACE=$(echo "$WINDOW_INFO" | jq -r '.workspace.id')
FLOATING=$(echo "$WINDOW_INFO" | jq -r '.floating')
FULLSCREEN=$(echo "$WINDOW_INFO" | jq -r '.fullscreen')
MONITOR=$(echo "$WINDOW_INFO" | jq -r '.monitor')
PID=$(echo "$WINDOW_INFO" | jq -r '.pid')

# Display results
clear
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║               WINDOW INFORMATION INSPECTOR                    ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║ Class:      $CLASS"
echo "║ Title:      $TITLE"
echo "║ Workspace:  $WORKSPACE"
echo "║ Floating:   $FLOATING"
echo "║ Fullscreen: $FULLSCREEN"
echo "║ Monitor:    $MONITOR"
echo "║ PID:        $PID"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Example window rules for this window:"
echo ""
echo "windowrulev2 = float, class:^($CLASS)$"
echo "windowrulev2 = float, title:^($TITLE)$"
echo "windowrulev2 = workspace $WORKSPACE, class:^($CLASS)$"
echo ""

# Copy class to clipboard
echo -n "$CLASS" | wl-copy
notify-send "Window Inspector" "Class '$CLASS' copied to clipboard"

# Also show all clients for reference
echo "Press 'a' to see all windows, or any other key to exit..."
read -n 1 -s key

if [ "$key" = "a" ]; then
    clear
    echo "All active windows:"
    echo ""
    hyprctl clients -j | jq -r '.[] | "Class: \(.class)\nTitle: \(.title)\nWorkspace: \(.workspace.id)\n---"'
fi