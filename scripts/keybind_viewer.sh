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
Super + V              → Toggle Floating
Super + F              → Toggle Fullscreen
Super + P              → Toggle Pseudo/Dwindle
Super + J              → Toggle Split Direction
Super + T              → Pin Window (Always on Top)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🖱️ WINDOW FOCUS & MOVEMENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + ← ↓ ↑ →        → Move Focus (Arrow Keys)
Super + H J K L        → Move Focus (Vim Keys)
Super + Shift + ← ↓ ↑ → → Move Window (Arrow Keys)
Super + Shift + H J K L → Move Window (Vim Keys)
Super + Mouse Left     → Move Window (Drag)
Super + Mouse Right    → Resize Window (Drag)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🔢 WORKSPACE NAVIGATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + 1-9            → Switch to Workspace 1-9
Super + 0              → Switch to Workspace 10
Super + Shift + 1-9    → Move Window to Workspace 1-9
Super + Shift + 0      → Move Window to Workspace 10
Super + N              → Next Workspace
Super + Tab            → Switch to Last Workspace
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
Super + I              → Move PiP to Next Corner
Super + Shift + I      → Resize PiP (Cycle Sizes)
Super + Ctrl + I       → Toggle PiP Always on Top

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
Super + Escape         → Power Menu (Lock/Logout/Shutdown)
Super + L              → Lock Screen
Super + Alt + R        → Reload Hyprland Config

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ℹ️ HELP & DEBUGGING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Super + K              → This Keybind Viewer
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
