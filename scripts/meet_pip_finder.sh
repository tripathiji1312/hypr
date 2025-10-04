#!/bin/bash
# filepath: ~/.config/hypr/scripts/meet_pip_finder.sh

# Google Meet PiP Window Finder
# Run this WHILE your Meet PiP window is open

echo "=========================================="
echo "GOOGLE MEET PIP WINDOW FINDER"
echo "=========================================="
echo ""
echo "Searching for Meet-related windows..."
echo ""

# Find ALL windows with "meet" in title or class
hyprctl clients -j | jq -r '
    .[] | 
    select(
        (.title | ascii_downcase | contains("meet")) or 
        (.class | ascii_downcase | contains("meet")) or
        (.initialTitle | ascii_downcase | contains("meet"))
    ) | 
    "╔══════════════════════════════════════════════════════════════╗\n" +
    "║ MEET WINDOW FOUND                                            ║\n" +
    "╠══════════════════════════════════════════════════════════════╣\n" +
    "║ Class:        \(.class)\n" +
    "║ Title:        \(.title)\n" +
    "║ InitialTitle: \(.initialTitle)\n" +
    "║ Address:      \(.address)\n" +
    "║ Floating:     \(.floating)\n" +
    "║ Size:         \(.size[0])x\(.size[1])\n" +
    "║ Position:     \(.at[0]),\(.at[1])\n" +
    "║ Workspace:    \(.workspace.id)\n" +
    "╚══════════════════════════════════════════════════════════════╝\n"
'

echo ""
echo "=========================================="
echo "ALL SMALL FLOATING WINDOWS (potential PiP)"
echo "=========================================="
echo ""

# Show ALL small floating windows
hyprctl clients -j | jq -r '
    .[] | 
    select(.floating == true and (.size[0] < 1000 or .size[1] < 800)) | 
    "Class: \(.class)\n" +
    "Title: \(.title)\n" +
    "Size: \(.size[0])x\(.size[1])\n" +
    "Address: \(.address)\n" +
    "---"
'

echo ""
echo "Done! Copy the information above and share it."