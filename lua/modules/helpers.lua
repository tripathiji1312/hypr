local M = {}

M.name = "helpers"

-- Comment-only module that documents audio feedback capability
-- This module is primarily for documentation; beep functionality is handled via keybinds
-- that call shell commands directly

M.lines = {
    "# =======================================================================================",
    "# | AUDIO FEEDBACK HELPERS                                                             |",
    "# =======================================================================================",
    "# Audio feedback provides immediate sensory confirmation of keybind actions",
    "# Requires: canberra-gtk-play (usually pre-installed on Linux desktops)",
    "# ",
    "# To add beep feedback to any keybind, append to the bind command:",
    "# Example: bind = $mainMod, X, exec, ~/.config/hypr/scripts/action.sh && canberra-gtk-play -i system-ready",
    "# ",
    "# Available system sounds (canberra names):",
    "#   system-shutdown  - Logout/shutdown sound",
    "#   system-ready     - System ready/startup sound",
    "#   dialog-warning   - Warning notification",
    "#   dialog-error     - Error notification",
    "#   dialog-information - Information notification",
    "#   complete-action  - Task complete sound",
    "# ",
    "# Note: For workspace changes, add beep to keybinds like this:",
    "# bind = $mainMod, 1, workspace, 1; exec, canberra-gtk-play -i system-ready",
    "#",
}

return M
