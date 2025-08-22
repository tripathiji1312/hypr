#!/bin/bash

# --- The Final, Forceful Pywal Reload Script ---
# This version includes a more robust Waybar reload and a forceful
# restart of the GTK portal to ensure themes are applied.

echo "--- Pywal Reload Script Starting ---"

if ! [ -e "${HOME}/.cache/wal/colors.sh" ]; then
    echo "[FATAL] Pywal color file not found. Exiting."
    exit 1
fi
source "${HOME}/.cache/wal/colors.sh"

# --- 1. Reload Core Applications ---
echo "INFO: Reloading Kitty terminal..."
ln -sf "${HOME}/.cache/wal/colors-kitty.conf" "${HOME}/.config/kitty/theme.conf"
if pgrep -x kitty > /dev/null; then
    killall -SIGUSR1 kitty
fi

echo "INFO: Reloading Dunst..."
pkill dunst
sleep 0.3  # Critical delay to ensure color variables are fully loaded
dunst &

# --- 2. Forceful GTK Theme Application ---
echo "INFO: Attempting to generate and apply GTK theme..."
THEME_NAME="pywal-oomox-dark"
BASE_THEME_PATH="$HOME/.config/oomox/colors/pywal-base"

# Run the theme generation
oomox-cli -o "$THEME_NAME" "$BASE_THEME_PATH"
if [ $? -eq 0 ]; then
    echo "[OK] Oomox theme generated successfully."

    # Apply the theme setting
    gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME"
    echo "[OK] Gsettings theme key has been set."

    # THE CRITICAL FIX: Forcefully restart the GTK portal
    echo "INFO: Forcefully restarting GTK portal service..."
    systemctl --user restart xdg-desktop-portal-gtk.service &
    echo "[OK] GTK portal has been restarted."
else
    echo "------------------------------------------------------------"
    echo "[ERROR] GTK theme generation with oomox-cli FAILED."
    echo "------------------------------------------------------------"
fi

# --- 3. Reload Waybar (Last and most robustly) ---
echo "INFO: Reloading Waybar..."
pkill waybar
# A small delay can help Waybar restart correctly after other processes.
sleep 0.2
# Run Waybar in the background and disown it from the script's process.
waybar & disown

echo "--- Pywal Reload Script Finished ---"