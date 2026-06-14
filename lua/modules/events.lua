local M = {}

M.name = "events"

M.lines = {
    "# =======================================================================================",
    "# | LUA EVENT HANDLERS - RUNTIME BEHAVIOR                                              |",
    "# =======================================================================================",
    "# These handlers provide dynamic workspace management using Hyprland 0.55+ Lua API",
    "",
    "exec-once = hyprctl eval 'hl.on(\"workspace.active\", function(ws) local special = hl.get_active_special_workspace(); if special ~= nil then hl.dispatch(hl.dsp.focus({ workspace = \"special:\" .. special.name })) end end)'",
    "exec-once = hyprctl eval 'hl.on(\"monitor.added\", function(m) hl.notification.create({ text = \"📺 Monitor connected: \" .. m.name, duration = 5000, icon = \"ok\" }); if m.name ~= \"eDP-1\" then hl.exec_cmd(\"hyprctl keyword monitor eDP-1,disabled\") end end)'",
    "exec-once = hyprctl eval 'hl.on(\"monitor.removed\", function(m) hl.notification.create({ text = \"📺 Monitor disconnected: \" .. m.name, duration = 5000, icon = \"warning\" }); if m.name ~= \"eDP-1\" then hl.exec_cmd(\"hyprctl keyword monitor eDP-1,preferred,auto,1\") end end)'",
    "exec-once = hyprctl eval 'local workspace_names = { [1] = \"🏠 Main\", [2] = \"💻 Code\", [3] = \"🌐 Browser\", [4] = \"💬 Chat\", [5] = \"🎵 Media\" }; hl.on(\"workspace.active\", function(ws) local name = workspace_names[ws.id] or (\"Workspace \" .. ws.id); hl.notification.create({ text = name, duration = 1500, icon = \"info\" }) end)'",
}

return M
