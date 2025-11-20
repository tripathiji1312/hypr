#!/usr/bin/env bash
# ============================================================================
# Cursor Theme Restoration Script for Hyprland
# ============================================================================
# This script fixes cursor theme issues after system updates
# Run this script and then reload Hyprland (SUPER + SHIFT + R)

CURSOR_THEME="Bibata-Modern-Ice"
CURSOR_SIZE="24"

echo "🔧 Fixing cursor theme..."

# 1. Set environment variables
echo "📝 Setting environment variables..."
export XCURSOR_THEME="$CURSOR_THEME"
export XCURSOR_SIZE="$CURSOR_SIZE"
export HYPRCURSOR_THEME="$CURSOR_THEME"
export HYPRCURSOR_SIZE="$CURSOR_SIZE"

# 2. Apply to GTK settings
echo "🎨 Applying GTK settings..."
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
gsettings set org.gnome.desktop.interface cursor-size "$CURSOR_SIZE"

# 3. Update Qt settings if qt5ct/qt6ct config exists
if [ -f "$HOME/.config/qt5ct/qt5ct.conf" ]; then
    echo "🔧 Updating Qt5 settings..."
    sed -i "s/^cursor_theme=.*/cursor_theme=$CURSOR_THEME/" "$HOME/.config/qt5ct/qt5ct.conf" 2>/dev/null || true
fi

if [ -f "$HOME/.config/qt6ct/qt6ct.conf" ]; then
    echo "🔧 Updating Qt6 settings..."
    sed -i "s/^cursor_theme=.*/cursor_theme=$CURSOR_THEME/" "$HOME/.config/qt6ct/qt6ct.conf" 2>/dev/null || true
fi

# 4. Rebuild cursor cache
echo "♻️  Rebuilding cursor cache..."
rm -rf ~/.cache/icon-cache.kcache 2>/dev/null
rm -rf ~/.icons/default 2>/dev/null

# Create cursor theme symlink
mkdir -p ~/.icons
if [ -d "/usr/share/icons/$CURSOR_THEME" ]; then
    ln -sf "/usr/share/icons/$CURSOR_THEME" ~/.icons/default
    echo "✓ Created symlink to system cursor theme"
elif [ -d "$HOME/.local/share/icons/$CURSOR_THEME" ]; then
    ln -sf "$HOME/.local/share/icons/$CURSOR_THEME" ~/.icons/default
    echo "✓ Created symlink to user cursor theme"
fi

# 5. Update index.theme for default cursor
mkdir -p ~/.icons/default
cat > ~/.icons/default/index.theme << EOF
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=$CURSOR_THEME
EOF

echo "✓ Created default cursor index.theme"

# 6. Force reload cursor in Hyprland
echo "🔄 Reloading cursor in Hyprland..."
hyprctl setcursor "$CURSOR_THEME" "$CURSOR_SIZE" 2>/dev/null || echo "⚠️  Note: Hyprland setcursor command requires restart for hyprcursor themes"

# 7. Restart xsettingsd if running (propagates to X11 apps)
if pgrep -x xsettingsd >/dev/null; then
    echo "🔄 Restarting xsettingsd..."
    killall xsettingsd
    xsettingsd &
fi

# 8. Notify user
notify-send -u normal "Cursor Theme Fixed" "Applied $CURSOR_THEME cursor theme\nReload Hyprland (SUPER+SHIFT+R) if needed" -t 5000

echo ""
echo "✅ Done! Your cursor theme has been restored."
echo "🔄 If the cursor still looks wrong, reload Hyprland: SUPER + SHIFT + R"
echo ""
