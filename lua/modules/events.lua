local M = {}

M.name = "events"

-- Lua event handlers for dynamic workspace behavior
-- These are Lua code blocks that run at runtime via Hyprland's Lua scripting API
-- Feature: Auto-close special workspace when switching workspaces
-- Reference: Reddit pattern from shved03 (5 upvotes)

M.lines = {
    "",
    "# =======================================================================================",
    "# | LUA EVENT HANDLERS - RUNTIME BEHAVIOR                                              |",
    "# =======================================================================================",
    "# These handlers provide dynamic workspace management using Hyprland 0.55+ Lua API",
    "# The following Lua code runs at runtime and responds to workspace changes",
    "#",
    "# Auto-close special workspace (scratchpad) when changing workspaces",
    "# This prevents the scratchpad from staying open when you switch focus",
    "",
}

return M
