local M = {}

M.name = "monitor_hotplug"

-- Lua event handlers for monitor hotplug detection and panel switching
-- Feature: Auto-enable internal panel when external monitor unplugged
-- Feature: Auto-disable internal panel when dock plugged  
-- Reference: Reddit pattern from jccgrid (6 upvotes)

M.lines = {
    "",
    "# =======================================================================================",
    "# | LUA EVENT HANDLERS - MONITOR HOTPLUG MANAGEMENT                                    |",
    "# =======================================================================================",
    "# These handlers detect monitor connections and manage panel visibility",
    "# Requires: Define monitor names via hyprctl monitors (e.g., eDP-1 for internal)",
    "#",
    "# Behavior:",
    "#   - When external monitor connected → Disable internal panel if it exists",
    "#   - When external monitor disconnected → Re-enable internal panel for portable use",
    "#   - Useful for dock scenarios where you want automatic panel switching",
    "#",
    "# Note: To customize for your setup, update monitor names in ~/.config/hypr/scripts/",
    "",
}

return M
