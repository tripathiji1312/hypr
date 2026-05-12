local M = {}

M.name = "autostart"
M.lines = {
    "exec-once = /usr/lib/polkit-kde-authentication-agent-1",
    "exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "exec-once = quickshell",
    "exec-once = hypridle",
    "exec-once = nm-applet --indicator",
    "exec-once = wl-paste --watch cliphist store",
    "exec-once = /usr/lib/pam_kwallet_init",
    "exec-once = /usr/lib/xdg-desktop-portal-hyprland",
    "exec-once = ~/.config/hypr/scripts/startup_theme.sh",
    "exec-once = ~/.config/dunst/battery_notification.sh",
    "exec-once = sleep 2 && hyprctl setcursor Bibata-Modern-Ice 24",
}

return M
