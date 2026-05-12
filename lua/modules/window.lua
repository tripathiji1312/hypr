local M = {}

M.name = "window"

local raw = [=[
# #######################################################################################
# #                      MODERN & CLEAN HYPRLAND WINDOW RULES (v0.51.1)                #
# #######################################################################################
#
# This file uses clear, logical rules to manage window behavior, focusing on stability
# and preventing common rendering issues like wallpaper bleed in pop-ups.
#
# To find a window's class or title, run `hyprctl clients` in a terminal.
#
# Architecture: Rules are evaluated top-to-bottom (last match wins). Organized by
# function for easy maintenance and troubleshooting.
#
# #######################################################################################

# =======================================================================================
# | I. GLOBAL BASELINE RULES                                                           |
# =======================================================================================
# These rules apply broadly to create a clean aesthetic foundation.
# More specific rules below will override these where needed.

# --- Shadows: Disabled for tiled windows (cleaner, flatter aesthetic)
windowrule = match:float false, no_shadow on

# --- Dimming: Prevent background dim when floating dialogs are open
windowrule = match:float true, no_dim on

# --- Floating Windows: Subtle opacity to distinguish from tiled (use override to avoid stacking)
windowrule = match:float true, opacity 0.92 override 0.86 override

# --- Browser Opacity Override: Prevent transparency glitches in browsers
# CRITICAL: Chromium-based browsers can render with unintended transparency
windowrule = match:class ^(vivaldi-stable|brave-browser|Google-chrome|firefox|zen-browser)$, opacity 1.0 override

# --- Centering: Auto-center floating windows, except JetBrains (PyCharm/IntelliJ)
# JetBrains XWayland uses transient "winNNN" popups (context menus, right-click menus).
# Forcing center on all floating windows moves those menus to screen center.
windowrule = match:float true, match:class negative:^(jetbrains-.*)$, center on


# =======================================================================================
# | II. FLOATING WINDOWS & DIALOGS                                                     |
# =======================================================================================
# Specific applications and window types that should float with custom sizing.

# --- File & Dialog Pop-ups (Title-based matching for reliability)
# FIX: Added no_blur/no_shadow to prevent "thick border" wallpaper bleed on transparent CSD windows
windowrule = match:title ^(Open File|Select a File|Choose wallpaper|Open Folder|Save As|File Upload)(.*)$, float on
windowrule = match:title ^(Open File|Select a File|Choose wallpaper|Open Folder|Save As|File Upload)(.*)$, no_blur on
windowrule = match:title ^(Open File|Select a File|Choose wallpaper|Open Folder|Save As|File Upload)(.*)$, no_shadow on

windowrule = match:title ^(.*)(wants to save|wants to open)$, float on
windowrule = match:title ^(.*)(wants to save|wants to open)$, no_blur on
windowrule = match:title ^(.*)(wants to save|wants to open)$, no_shadow on

# --- Windows 11 Style: Settings & Properties
# Ensure "Properties", "Preferences", "Settings" always float and center
windowrule = match:title ^(.*)(Properties|Preferences|Settings)$, float on
windowrule = match:title ^(.*)(Properties|Preferences|Settings)$, center on
windowrule = match:title ^(.*)(Properties|Preferences|Settings)$, size 600 450
windowrule = match:title ^(.*)(Properties|Preferences|Settings)$, no_blur on
windowrule = match:title ^(.*)(Properties|Preferences|Settings)$, no_shadow on

# --- System & Utility Dialogs
windowrule = match:class ^(pavucontrol|blueman-manager|nm-connection-editor|org.gnome.Calculator|gnome-system-monitor)$, float on
windowrule = match:class ^(pavucontrol|blueman-manager|nm-connection-editor|org.gnome.Calculator|gnome-system-monitor)$, size (monitor_w*0.45) (monitor_h*0.45)
windowrule = match:class ^(pavucontrol|blueman-manager|nm-connection-editor|org.gnome.Calculator|gnome-system-monitor)$, no_blur on
windowrule = match:class ^(pavucontrol|blueman-manager|nm-connection-editor|org.gnome.Calculator|gnome-system-monitor)$, no_shadow on

# --- File Manager Context/Progress Windows
windowrule = match:class ^(dolphin|nautilus|thunar)$, match:title ^(Copying|Moving|Deleting Files|Properties)$, float on
windowrule = match:class ^(dolphin|nautilus|thunar)$, match:title ^(Copying|Moving|Deleting Files|Properties)$, size (monitor_w*0.60) (monitor_h*0.60)

# --- XDG Desktop Portals: GTK-specific fix (primary file picker)
# CRITICAL: Prevents wallpaper bleed and rendering artifacts
windowrule = match:class ^(xdg-desktop-portal-gtk)$, float on
windowrule = match:class ^(xdg-desktop-portal-gtk)$, no_blur on
windowrule = match:class ^(xdg-desktop-portal-gtk)$, no_shadow on
windowrule = match:class ^(xdg-desktop-portal-gtk)$, opaque on
windowrule = match:class ^(xdg-desktop-portal-gtk)$, border_size 0
windowrule = match:class ^(xdg-desktop-portal-gtk)$, size (monitor_w*0.55) (monitor_h*0.70)
windowrule = match:class ^(xdg-desktop-portal-gtk)$, center on

# Fix for capitalized class names (common issue)
windowrule = match:class ^(Xdg-desktop-portal-gtk)$, float on
windowrule = match:class ^(Xdg-desktop-portal-gtk)$, no_blur on
windowrule = match:class ^(Xdg-desktop-portal-gtk)$, no_shadow on
windowrule = match:class ^(Xdg-desktop-portal-gtk)$, opaque on
windowrule = match:class ^(Xdg-desktop-portal-gtk)$, border_size 0
windowrule = match:class ^(Xdg-desktop-portal-gtk)$, size (monitor_w*0.55) (monitor_h*0.70)
windowrule = match:class ^(Xdg-desktop-portal-gtk)$, center on

# --- XDG Desktop Portals: Generic fallback (other implementations)
windowrule = match:class ^(xdg-desktop-portal-.*)$, float on
windowrule = match:class ^(xdg-desktop-portal-.*)$, no_blur on
windowrule = match:class ^(xdg-desktop-portal-.*)$, no_shadow on
windowrule = match:class ^(xdg-desktop-portal-.*)$, border_size 0

# --- Authentication Dialogs: Keep focused (security)
windowrule = match:class ^(pinentry-.*)$, float on
windowrule = match:class ^(pinentry-.*)$, stay_focused on

# --- IDE/Editor Pop-ups (VS Code, Cursor)
# Floats settings/dialogs but not editor windows (which have file names in title)
windowrule = match:class ^(Code|cursor)$, match:title negative:.*(—|\[).*, float on
windowrule = match:class ^(Code|cursor)$, match:title negative:.*(—|\[).*, size (monitor_w*0.70) (monitor_h*0.80)

# --- JetBrains IDEs (PyCharm, IntelliJ, WebStorm, etc.) - XWayland Apps
# CRITICAL FIX: Remove ALL compositor effects to fix popup positioning bug.
# JetBrains popups appear in center instead of correct position due to XWayland issues.
# Solution: Make Hyprland completely ignore these windows for effects.
windowrule = match:class ^(jetbrains-.*)$, no_blur on
windowrule = match:class ^(jetbrains-.*)$, no_shadow on
windowrule = match:class ^(jetbrains-.*)$, no_dim on
windowrule = match:class ^(jetbrains-.*)$, no_anim on
windowrule = match:class ^(jetbrains-.*)$, rounding 0
windowrule = match:class ^(jetbrains-.*)$, border_size 0
windowrule = match:class ^(jetbrains-.*)$, opaque on
windowrule = match:class ^(jetbrains-.*)$, force_rgbx on
windowrule = match:class ^(jetbrains-.*)$, suppress_event activate
windowrule = match:class ^(jetbrains-.*)$, suppress_event fullscreen


# =======================================================================================
# | III. PICTURE-IN-PICTURE (PiP) - UNIVERSAL FIX                                      |
# =======================================================================================
# Clean, borderless PiP windows for all browsers and media apps.
# Works with: Vivaldi, Brave, Chrome, Firefox, MPV, VLC, etc.

# --- Universal PiP Pattern (case-insensitive)
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, float on
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, pin on
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, size (monitor_w*0.25) (monitor_h*0.25)
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, move (monitor_w*0.74) (monitor_h*0.73)
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, border_size 0
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, rounding 0
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, no_shadow on
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, no_blur on
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, no_anim on
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, keep_aspect_ratio on
windowrule = match:title ^([Pp]icture-in-[Pp]icture)$, no_dim on

# --- Google Meet PiP (pattern: "Meet - xxx-xxxx-xxx")
# Special handling for Chromium's Meet PiP rendering pipeline
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, float on
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, pin on
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, size (monitor_w*0.25) (monitor_h*0.25)
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, move (monitor_w*0.74) (monitor_h*0.73)
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, border_size 0
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, rounding 0
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, no_shadow on
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, no_blur on
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, opacity 1.0 override
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, keep_aspect_ratio on
windowrule = match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, no_anim on


# =======================================================================================
# | IV. SPECIFIC APPLICATION BEHAVIOR                                                  |
# =======================================================================================
# Rules for specific application behaviors and optimizations.

# --- Terminal: Kitty (subtle transparency, use override for consistency)
windowrule = match:class ^(kitty)$, opacity 0.95 override 0.88 override

# --- Scratchpad Terminal (unified approach using class only)
# Launch with: kitty --class scratchpad
windowrule = match:class ^(scratchpad)$, workspace special:term
windowrule = match:class ^(scratchpad)$, float on
windowrule = match:class ^(scratchpad)$, size (monitor_w*0.60) (monitor_h*0.60)
windowrule = match:class ^(scratchpad)$, center on

# --- Special scratchpad workspaces: keep them "utility-like" (consistent size/placement)
workspace = special:term, gapsout:0, gapsin:0
workspace = special:files, gapsout:0, gapsin:0
workspace = special:music, gapsout:0, gapsin:0

workspace = special:term, on-created-empty:[workspace special:term silent; float; size 60% 60%; center] kitty --class scratchpad
workspace = special:files, on-created-empty:[workspace special:files silent; float; size 70% 75%; center] thunar

windowrule = match:workspace special:term, float on
windowrule = match:workspace special:term, size (monitor_w*0.60) (monitor_h*0.60)
windowrule = match:workspace special:term, center on

windowrule = match:workspace special:files, float on
windowrule = match:workspace special:files, size (monitor_w*0.70) (monitor_h*0.75)
windowrule = match:workspace special:files, center on

windowrule = match:workspace special:music, float on
windowrule = match:workspace special:music, size (monitor_w*0.60) (monitor_h*0.60)
windowrule = match:workspace special:music, center on

windowrule = match:workspace special:term, no_dim on
windowrule = match:workspace special:files, no_dim on
windowrule = match:workspace special:music, no_dim on

# --- Media & Image Viewers
windowrule = match:class ^(gwenview|loupe|sxiv|imv|feh|eog|mpv|vlc)$, float on
windowrule = match:class ^(gwenview|loupe|sxiv|imv|feh|eog|mpv|vlc)$, center on
windowrule = match:class ^(gwenview|loupe|sxiv|imv|feh|eog|mpv|vlc|celluloid)$, keep_aspect_ratio on
windowrule = match:class ^(mpv|vlc|celluloid)$, idle_inhibit focus  # Prevent sleep during playback


# =======================================================================================
# | V. SMART GAPS - NO GAPS/BORDERS WHEN ONLY ONE WINDOW                               |
# =======================================================================================
# Creates a cleaner experience when focusing on a single window.
# Note: The 's[false]' excludes special workspaces from this behavior.

# --- Workspace-level: Remove gaps and disable borders/rounding
workspace = w[tv1]s[false], gapsout:0, gapsin:0, border:false, rounding:false
workspace = f[1]s[false], gapsout:0, gapsin:0, border:false, rounding:false

# --- Window-level: Remove borders and rounding for tiled windows
windowrule = match:float false, match:workspace w[tv1]s[false], border_size 0
windowrule = match:float false, match:workspace w[tv1]s[false], rounding 0
windowrule = match:float false, match:workspace f[1]s[false], border_size 0
windowrule = match:float false, match:workspace f[1]s[false], rounding 0


# =======================================================================================
# | VI. LAYER RULES - BARS, NOTIFICATIONS, LAUNCHERS                                   |
# =======================================================================================
# Control blur and behavior for overlay surfaces (status bars, notifications, etc.)
# Find layer namespaces with: hyprctl layers

# --- Status Bar (Waybar)
layerrule = match:namespace waybar, blur on
layerrule = match:namespace gtk-layer-shell, blur on
layerrule = match:namespace waybar, ignore_alpha 0  # Ignore fully transparent pixels in blur
layerrule = match:namespace waybar, xray 1          # Modern blur-through effect

# --- Notification Daemon
layerrule = match:namespace notifications, blur on
layerrule = match:namespace notifications, ignore_alpha 0.3  # Don't blur if opacity < 0.3

# --- App Launchers
layerrule = match:namespace wofi, blur on
layerrule = match:namespace rofi, blur on
layerrule = match:namespace wofi, ignore_alpha 0.5
layerrule = match:namespace wofi, animation popin
layerrule = match:namespace rofi, animation popin

# --- Lock Screen
layerrule = match:namespace hyprlock, blur on
layerrule = match:namespace hyprlock, no_anim on
layerrule = match:namespace hyprlock, above_lock 1

# --- Quickshell Components (Enhanced Blur)
# Blur specific QuickShell panels (more precise control than global popups blur)
layerrule = match:namespace quickshell-controlcenter, blur on
layerrule = match:namespace quickshell-bar, blur on
layerrule = match:namespace quickshell-notifications, blur on
layerrule = match:namespace quickshell-controlcenter, ignore_alpha 0.6  # Don't blur if opacity < 60%
layerrule = match:namespace quickshell-bar, ignore_alpha 0.6
layerrule = match:namespace quickshell-notifications, ignore_alpha 0.6
# Generic fallback for any QuickShell layer
layerrule = match:namespace ^(quickshell.*)$, no_anim on
]=]

M.lines = {}
for line in (raw .. "\n"):gmatch("(.-)\n") do
    table.insert(M.lines, line)
end

return M
