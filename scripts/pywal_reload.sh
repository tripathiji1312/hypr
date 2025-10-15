#!/bin/bash

# --- The GTK Fixer & Application Reloader Script ---
# This script applies a STABLE dark theme to GTK applications
# while reloading other components to use the NEW Pywal colors.

echo "--- Fixing GTK theme and reloading Pywal-aware apps ---"

# --- 1. Define and Apply the Stable GTK Theme ---
STABLE_GTK_THEME="adw-gtk3-dark"
ICON_THEME="Papirus-Dark" # Or your preferred icon theme

# Forcefully set the theme for Wayland/GTK4 apps
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme "$STABLE_GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"

# Forcefully set the theme for XWayland apps
XSETTINGS_CONFIG="${HOME}/.config/xsettingsd/xsettingsd.conf"
if [ -f "$XSETTINGS_CONFIG" ]; then
    sed -i "s/Gtk\/ThemeName .*/Gtk\/ThemeName \"$STABLE_GTK_THEME\"/" "$XSETTINGS_CONFIG"
    pkill -HUP xsettingsd
fi

# Restart the portals to ensure they re-read the correct theme
systemctl --user restart xdg-desktop-portal-gtk.service
systemctl --user restart xdg-desktop-portal.service

# --- 2. Reload Apps to Apply New Pywal Colors ---
# These apps read the Pywal cache files, which were just updated.
pkill quickshell && quickshell & disown
# pkill dunst && dunst &
if pgrep -x kitty > /dev/null; then
    killall -SIGUSR1 kitty
fi

echo "--- Theme fix and reload complete. ---"