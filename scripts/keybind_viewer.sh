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
Super + B              → Browser (Zen)
Super + C              → VS Code
Super + D              → Discord

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
Super + P              → Restart Waybar
Super + G              → Toggle Window Group
Super + [ / ]          → Navigate Group Windows

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🖱️ WINDOW FOCUS & MOVEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + ← ↓ ↑ →        → Move Focus (Arrow Keys)
Super + H J K L        → Move Focus (Vim Keys)
Super + Shift + ← ↓ ↑ → → Swap Windows (Arrow Keys)
Super + Shift + H J K L → Swap Windows (Vim Keys)
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
Super + Shift + M      → Toggle Music Player (special:music)
Super + Shift + E      → Toggle Email Client (special:email)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    📸 SCREENSHOTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Print                  → Screenshot (Select Area)
Shift + Print          → Screenshot (Full Screen)
Ctrl + Print           → Screenshot (Active Window)
Alt + Print            → Screenshot with OCR (Text Extract)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    📋 CLIPBOARD & HISTORY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + H              → Show Clipboard History (Wofi)
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
Super + Alt + R        → Reload Hyprland Config
Super + Escape         → Exit Hyprland

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ℹ️ HELP & DEBUGGING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + K              → This Keybind Viewer
Super + Shift + D      → Inspect Window (Class/Title)
Super + Ctrl + D       → Show All Window Classes
Super + Shift + X      → Find Window Class (Debug Tool)
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
