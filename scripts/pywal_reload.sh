#!/bin/bash

# --- Pywal Reload Script (Definitive Version for Wayland + XWayland) ---

echo "--- Starting Full Theme Reload ---"

if [ ! -f "${HOME}/.cache/wal/colors.sh" ]; then
    echo "[ERROR] Pywal color cache not found. Exiting."
    exit 1
fi
source "${HOME}/.cache/wal/colors.sh"

# --- 1. Reload Core Applications ---
pkill dunst && dunst &
pkill waybar && waybar & disown
if pgrep -x kitty > /dev/null; then
    killall -SIGUSR1 kitty
fi

# --- 2. Apply Theme for Native Wayland Apps ---
echo "INFO: Applying theme for native Wayland applications..."
THEME_NAME="wal"
gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# --- 3. Apply Theme for XWayland Apps ---
echo "INFO: Applying theme for XWayland applications..."
XSETTINGS_CONFIG="${HOME}/.config/xsettingsd/xsettingsd.conf"
if [ -f "$XSETTINGS_CONFIG" ]; then
    # Use sed to replace the theme name in the config file
    sed -i "s/Gtk\/ThemeName .*/Gtk\/ThemeName \"$THEME_NAME\"/" "$XSETTINGS_CONFIG"
    # Signal the running xsettingsd daemon to reload its configuration
    pkill -HUP xsettingsd
fi

# --- 4. Restart XDG Portals ---
# This forces them to re-read the configuration from both sources
echo "INFO: Restarting XDG portals..."
systemctl --user restart xdg-desktop-portal-gtk.service
systemctl --user restart xdg-desktop-portal.service

# --- 5. Refresh Wlogout ---
if [ -f "${HOME}/.config/wlogout/style.css.tpl" ]; then
    sed -e "s/{background}/${background}/g" -e "s/{foreground}/${foreground}/g" \
        -e "s/{color1}/${color1}/g" -e "s/{color2}/${color2}/g" \
        -e "s/{color3}/${color3}/g" -e "s/{color4}/${color4}/g" \
        "${HOME}/.config/wlogout/style.css.tpl" > "${HOME}/.config/wlogout/style.css"
fi

echo "--- Theme Reload Finished Successfully ---"