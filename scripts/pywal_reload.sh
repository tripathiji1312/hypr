#!/bin/bash

# This script reloads applications to apply the new Pywal theme.

# Source the generated colors
# This is necessary for scripts that need to access the colors directly
source "${HOME}/.cache/wal/colors.sh"

# Reload Waybar
# Kill and restart Waybar to apply the new theme from its CSS
pkill waybar
waybar &

# Reload Dunst
# Kill and restart Dunst to apply the new theme from its config
pkill dunst
dunst &

# Reload Kitty Terminal
# In your kitty.conf, you must have the line: include ./theme.conf
# This command creates a symlink to the pywal-generated theme,
# and the SIGUSR1 signal tells Kitty to reload its config.
ln -sf "${HOME}/.cache/wal/colors-kitty.conf" "${HOME}/.config/kitty/theme.conf"
killall -SIGUSR1 kitty

# Reload Wofi's CSS
# This ensures Wofi uses the new theme on its next launch
killall -SIGUSR1 wofi
# Optional: Reload GTK theme (if you use nwg-look or similar)
# gsettings set org.gnome.desktop.interface gtk-theme "YourThemeName"
# gsettings set org.gnome.desktop.interface icon-theme "YourIconThemeName"