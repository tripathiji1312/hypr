#!/usr/bin/env lua

local modules = {
  "settings",
  "decorations",
  "animations",
  "autostart",
  "window",
  "keybinds",
}

local function read_module(name)
  local path = "modules/" .. name .. ".lua"
  local chunk, err = loadfile(path)
  if not chunk then
    error("failed to load module " .. path .. ": " .. tostring(err))
  end

  local ok, result = pcall(chunk)
  if not ok then
    error("failed to execute module " .. path .. ": " .. tostring(result))
  end

  if type(result) ~= "table" or type(result.lines) ~= "table" then
    error("module " .. path .. " must return { lines = {...} }")
  end

  return result
end

local lines = {}

lines[#lines + 1] = "# ------------------------------------------------------------------"
lines[#lines + 1] = "# GENERATED FILE - DO NOT EDIT DIRECTLY"
lines[#lines + 1] = "# Source: ~/.config/hypr/lua/modules/*.lua"
lines[#lines + 1] = "# ------------------------------------------------------------------"
lines[#lines + 1] = ""

for _, name in ipairs(modules) do
  local mod = read_module(name)
  lines[#lines + 1] = "# --- module: " .. (mod.name or name) .. " ---"
  for _, line in ipairs(mod.lines) do
    lines[#lines + 1] = line
  end
  lines[#lines + 1] = ""
end

lines[#lines + 1] = "# --- no legacy source dependencies ---"

local out = "generated/hyprland.conf"
local fh, err = io.open(out, "w")
if not fh then
  error("failed to open output file " .. out .. ": " .. tostring(err))
end

for _, line in ipairs(lines) do
  fh:write(line)
  fh:write("\n")
end
fh:close()

print("wrote " .. out)
