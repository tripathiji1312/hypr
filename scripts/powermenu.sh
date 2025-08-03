#!/bin/bash

# A wofi-based power menu script for Hyprland

# --- Options ---
# You can customize the options here. The icon is optional.
# For icons, you need a Nerd Font installed.
lock=" Lock"
logout="󰗼 Logout"
suspend="󰒲 Suspend"
reboot=" Reboot"
shutdown=" Shutdown"

# --- Wofi Command ---
# The chosen option is captured into the 'selected' variable.
# We use dmenu mode for a simple list.
selected=$(echo -e "$lock\n$logout\n$suspend\n$reboot\n$shutdown" | wofi --dmenu --prompt "Power Menu")

# --- Action Execution ---
# A case statement checks the 'selected' variable and runs the corresponding command.
case $selected in
  "$lock")
    hyprlock
    ;;
  "$logout")
    # Exit the Hyprland session
    hyprctl dispatch exit
    ;;
  "$suspend")
    # Suspend the system
    systemctl suspend
    ;;
  "$reboot")
    # Reboot the system
    systemctl reboot
    ;;
  "$shutdown")
    # Shut down the system
    systemctl poweroff
    ;;
esac