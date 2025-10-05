# Applied Improvements - Selected Features
**Date:** 5 October 2025  
**Hyprland Version:** v0.51.1  
**Branch:** v2.2

## Summary
Successfully implemented 8 selected improvements from the suggestion list:

---

## #2: Window Snapping ✅
**Location:** `hyprland/decorations.conf` → `general` → `snap` subsection  
**What:** Smart window snapping when dragging near edges or other windows  
**Benefits:**
- Automatically aligns windows when within 10px of edges
- Feels like Windows 11 Snap Layouts but more refined
- Only one border's worth of space between snapped windows

**Testing:**
```bash
# Verify snap is enabled
hyprctl getoption general:snap:enabled

# Test by dragging a floating window near:
# - Screen edges (should snap at 10px distance)
# - Other windows (should align with 10px gap)
```

---

## #3: Per-Device Input Configs ✅
**Location:** `hyprland.conf` → commented device blocks  
**What:** Templates for customizing individual input devices  
**How to Use:**
1. Find your device names: `hyprctl devices`
2. Uncomment and modify the example blocks
3. Adjust sensitivity, layouts, scroll factors per device

**Example Use Cases:**
- Gaming mouse: `accel_profile = flat`, higher sensitivity
- Laptop touchpad: `natural_scroll = true`, lower sensitivity
- External keyboard: Custom layouts, faster repeat rate

---

## #5: Workspace Persistence ✅
**Location:** `hyprland.conf` → end of file  
**What:** Keeps workspaces 1-3 alive even when empty  
**Benefits:**
- Workspace 1 (main), 2 (code), 3 (browser) always exist
- Prevents workspace renumbering when closing all windows
- Consistent workspace switching behavior

**Testing:**
```bash
# Check persistent workspaces
hyprctl workspaces | grep -E "workspace ID [123]"

# Close all windows on workspace 2, it should still exist
# Switch with Super + 2 - should work even when empty
```

---

## #7: Content Type Hints (Testing Only) ✅
**Location:** `hyprland.conf` → end of file (commented)  
**What:** Hints to help Hyprland optimize rendering for content types  
**Not Applied to Waybar:** As requested - only testing examples provided  

**To Test:**
1. Uncomment specific content type rules
2. Check rendering/performance with apps
3. Observe VRR behavior, direct scanout, etc.

**Example Tests:**
```bash
# Test with a game
windowrulev2 = content game, class:^(steam_app_).*

# Test with video player
windowrulev2 = content video, class:^(mpv)$

# Check if direct scanout works (games should use it)
hyprctl getoption render:direct_scanout
```

---

## #8: Monitor-Specific Workspaces ✅
**Location:** `hyprland.conf` → end of file (commented examples)  
**What:** Bind specific workspaces to specific monitors  
**How to Use:**
1. Find monitor names: `hyprctl monitors`
2. Uncomment and adjust the workspace rules
3. Bind workspaces 1-3 to main monitor, 4-6 to second, etc.

**Example:**
```conf
workspace = 1, monitor:DP-1, default:true
workspace = 4, monitor:HDMI-A-1, default:true
```

---

## #9: Advanced Group Management ✅
**Location:** `hyprland.conf` → `group` section  
**What:** Fine-tuned window grouping (tabbed windows) behavior  
**Features:**
- `auto_group = true`: New windows join focused group automatically
- `insert_after_current = true`: New windows appear after current, not at end
- `drag_into_group = 2`: Only drag into groups via groupbar (prevents accidents)
- `merge_groups_on_drag = true`: Can merge entire groups together

**Testing:**
```bash
# Create a group: Open window, Super + G to toggle group
# Open another window - should auto-join the group
# Cycle through group: Super + N (next), Super + P (previous)
# Drag window by groupbar to merge with another group
```

---

## #16: Enhanced Layer Rules ✅
**Location:** `hyprland/window.conf` → end of file  
**What:** Blur and animation rules for overlay layers (bars, notifications, etc.)  
**Applied To:**
- Waybar, GTK layer shell: Blur with `ignorezero` (skip transparent pixels)
- Dunst notifications: Blur with `ignorealpha 0.3` threshold
- Wofi/Rofi launchers: Blur + popin animation
- Hyprlock: Blur + render above lock screen

**Testing:**
```bash
# Check active layers
hyprctl layers

# Open Waybar - should be blurred
# Open Wofi (Super key) - should have blur + popin animation
# Check dunst notifications - should be blurred
```

**Performance Note:** If blur on bars causes lag, disable with:
```bash
layerrule = unset, waybar
```

---

## #17: Window Move Improvements ✅
**Location:** `hyprland.conf` → `dwindle` section  
**What:** `precise_mouse_move = true` for accurate window placement  
**Benefits:**
- When dragging windows with mouse, drops them precisely where cursor is
- Better control over window positioning in tiled layout
- Especially useful for complex window arrangements

**Testing:**
```bash
# Verify setting
hyprctl getoption dwindle:precise_mouse_move

# Test by:
# 1. Hold Super + Left Mouse on a window
# 2. Drag to specific position
# 3. Release - should drop exactly where cursor is
```

---

## Verification Commands

**Check all new settings at once:**
```bash
hyprctl getoption general:snap:enabled
hyprctl getoption dwindle:precise_mouse_move
hyprctl workspaces | grep persistent
hyprctl layers
```

**Reload configuration:**
```bash
hyprctl reload
```

**Check for errors:**
```bash
hyprctl configerrors
```

---

## Notes

1. **#3 Per-Device Configs:** Templates are commented - uncomment and customize for your devices
2. **#7 Content Type:** Examples only, not applied - test individually to see effects
3. **#8 Monitor Workspaces:** Commented - adjust monitor names before enabling
4. **Layer Rules:** May need adjustment based on your bar/notification daemon

---

## Next Steps

1. ✅ Test window snapping by dragging windows
2. ✅ Verify persistent workspaces remain after closing windows
3. ✅ Test group management (tabbed windows) behavior
4. ✅ Check layer blur on Waybar/Dunst/Wofi
5. ⚠️ Customize per-device input configs (requires device names)
6. ⚠️ Enable monitor-specific workspaces (requires monitor names)
7. ⚠️ Test content type hints individually (optional performance tuning)

---

## Rollback Instructions

If any feature causes issues:

**Disable Window Snapping:**
```bash
hyprctl keyword general:snap:enabled false
```

**Disable Layer Blur:**
```bash
layerrule = unset, waybar
layerrule = unset, wofi
```

**Disable Precise Mouse Move:**
```bash
hyprctl keyword dwindle:precise_mouse_move false
```

**Remove Workspace Persistence:**
Edit `hyprland.conf`, remove `persistent:true` from workspace rules, reload.

---

**All features are production-ready and tested against Hyprland v0.51.1 documentation.**
