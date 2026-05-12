#!/bin/bash
# Beautiful Keybind Reference Viewer
# Shows all Hyprland keybinds in a searchable wofi menu

# Define keybinds with categories and descriptions
KEYBINDS=$(cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 APPLICATION LAUNCHERS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super (alone)          → Wofi App Launcher
Super + Return         → Terminal (Kitty)
Super + E              → File Manager (Thunar)
Super + B              → Browser (Vivaldi)
Super + C              → VS Code
Super + D              → Control Center (Quickshell)
Super + N              → Network Menu
Super + H              → Clipboard History

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🪟 WINDOW MANAGEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + Q              → Close Window
Super + Shift + Q      → Force Kill Window
Super + V              → Toggle Floating
Super + F              → Toggle Fullscreen (Maximize)
Super + Shift + F      → Toggle Fullscreen (Full)
Super + Shift + P      → Toggle Pseudo/Dwindle
Super + J              → Toggle Split Direction
Super + T              → Center Floating Window
Super + I              → Pin Window (Always on Top)
Super + O              → Toggle Window Opacity
Super + Shift + O      → Open Opacity Picker
Super + P              → Restart Quickshell
Super + G              → Toggle Window Group
Super + [ / ]          → Navigate Group Windows

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🖱️ WINDOW FOCUS & MOVEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + ← ↓ ↑ →        → Move Focus
Super + Shift + ← ↓ ↑ → Swap Windows
Super + Ctrl + ← ↓ ↑ → → Resize Windows (Arrow Keys)
Super + Mouse Left     → Move Window (Drag)
Super + Mouse Right    → Resize Window (Drag)
Super + Middle Click   → Kill Window

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🔢 WORKSPACE NAVIGATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + 1-9            → Switch to Workspace 1-9
Super + 0              → Switch to Workspace 10
Super + Shift + 1-9    → Move Window to Workspace 1-9
Super + Shift + 0      → Move Window to Workspace 10
Super + Alt + 1-9      → Move Window Silently (No Follow)
Super + Tab            → Next Occupied Workspace
Super + Shift + Tab    → Previous Occupied Workspace
Super + Alt + →/←      → Navigate All Workspaces
Super + Mouse Scroll   → Cycle Through Workspaces

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    📦 SCRATCHPAD & SPECIAL WORKSPACES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + S              → Toggle Scratchpad Terminal
Super + Shift + S      → Send Window to Scratchpad Terminal
Super + Shift + M      → Toggle Music Scratchpad
Super + Ctrl + Shift + M → Send Window to Music Scratchpad
Super + Shift + E      → Toggle Files Scratchpad
Super + Ctrl + Shift + E → Send Window to Files Scratchpad

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    📸 SCREENSHOTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Print                  → Screenshot Menu
Shift + Print          → Capture Region to Clipboard
Ctrl + Print           → Capture Active Window to Clipboard
Alt + Print            → Delayed Screenshot (5s)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    📋 CLIPBOARD & HISTORY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + H              → Show Clipboard History
Super + Shift + H      → Clear Clipboard History

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🔊 VOLUME & BRIGHTNESS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Volume Up Key          → Increase Volume (+5%)
Volume Down Key        → Decrease Volume (-5%)
Volume Mute Key        → Toggle Mute
Brightness Up Key      → Increase Brightness (+5%)
Brightness Down Key    → Decrease Brightness (-5%)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🎮 PICTURE-IN-PICTURE (PiP)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + Shift + I      → Move PiP to Next Corner
Super + Ctrl + I       → Resize PiP (Cycle Sizes)
Super + Alt + I        → PiP Window Info (Debug)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🎨 THEME & WALLPAPER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + W              → Change Wallpaper (Random)
Super + Shift + C      → Fix Cursor Theme

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🆕 HYPRLAND 0.54 FEATURES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + Ctrl + .       → Toggle Dwindle / Scrolling Layout
Super + Alt + , / .    → Scroll Layout Left / Right Column
Super + Alt + Shift + , / . → Swap Column Left / Right
Super + Alt + - / =    → Resize Active Scroll Column
Super + Alt + /        → Toggle Scroll Fit Mode
Super + Ctrl + P       → Promote Window to Its Own Scroll Column
Super + Ctrl + G       → Stack Window into Column on the Left
Super + Ctrl + Shift + G → Stack Window into Column on the Right
Super + Alt + Shift + Return → Promote Window to New Column
Super + Ctrl + Alt + / → Fit Scrolling Layout to Active Column
Super + Ctrl + Alt + \ → Fit Scrolling Layout to All Columns
Super + Ctrl + =       → Cursor Zoom In
Super + Ctrl + -       → Cursor Zoom Out
Super + Ctrl + 0       → Reset Cursor Zoom
4-Finger Pinch         → Cursor Zoom Gesture In / Out
Note                   → Native scrolling centers on focus/click, not hover-only

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🔧 RESIZE MODE (Super + R to Enter)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + R              → Enter Resize Mode
  → ← ↓ ↑ →            → Resize Window (Arrow Keys)
  → H J K L            → Resize Window (Vim Keys)
  → Escape / Return    → Exit Resize Mode

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🔌 SYSTEM CONTROL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + M              → Power Menu (Lock/Logout/Shutdown)
Super + L              → Lock Screen
Super + Escape         → Reload Hyprland Config

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ℹ️ HELP & DEBUGGING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + K              → This Keybind Viewer
Super + Shift + D      → Inspect Window (Class/Title)
Super + Ctrl + D       → Show All Window Classes
EOF
)

# Show keybinds in wofi with custom styling
echo "$KEYBINDS" | wofi \
    --dmenu \
    --insensitive \
    --cache-file=/dev/null \
    --prompt "🔍 Search Keybinds" \
    --width 700 \
    --height 500 \
    --style ~/.config/wofi/keybinds.css \
    --normal-window
