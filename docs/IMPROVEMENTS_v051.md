# Hyprland v0.51.1 Configuration Improvements
## Applied on: $(date '+%Y-%m-%d %H:%M:%S')

---

## ✅ **IMPROVEMENTS APPLIED**

### 🎯 **1. New Cursor Features (v0.51.1)**

Added comprehensive cursor configuration with modern features:

- **`inactive_timeout = 3`** - Hide cursor after 3 seconds of inactivity
- **`persistent_warps = true`** - Cursor returns to last position in window when refocusing
- **`warp_on_change_workspace = 1`** - Auto-warp cursor to focused window on workspace switch
- **`warp_on_toggle_special = 1`** - Cursor warps when toggling special workspaces
- **`hide_on_key_press = true`** - Hide cursor while typing (cleaner UX)
- **`hide_on_touch = true`** - Hide cursor after touch input
- **`enable_hyprcursor = true`** - Modern cursor theme support
- **`sync_gsettings_theme = true`** - Sync cursor with GTK apps
- **`no_hardware_cursors = 2`** - Auto-disable HW cursors when tearing
- **`no_break_fs_vrr = 2`** - Prevent cursor breaking VRR in fullscreen games
- **`min_refresh_rate = 60`** - Min refresh when VRR optimization active

**Impact**: Better cursor behavior, reduced distraction, gaming optimization

---

### ⚡ **2. Performance & Misc Optimization**

Enhanced `misc` section with v0.51.1 features:

- **`vrr = 2`** - VRR only for fullscreen (was `1` - always on)
  - Saves power when not gaming
  - `0`=off, `1`=always, `2`=fullscreen only, `3`=fullscreen+game content
- **`animate_mouse_windowdragging = false`** - Prevents weird curves behavior
- **`new_window_takes_over_fullscreen = 2`** - New windows unfullscreen existing ones
  - `0`=behind, `1`=takes over, `2`=unfullscreen/unmaxize (best UX)
- **`initial_workspace_tracking = 2`** - Persistent workspace tracking for all children
- **`middle_click_paste = true`** - Enable primary selection paste
- **`render_unfocused_fps = 15`** - Limit FPS for background windows (battery saver)
- **`close_special_on_empty = true`** - Auto-close empty special workspaces
- **`mouse_move_focuses_monitor = true`** - Mouse movement changes focused monitor

**Impact**: Better power efficiency, improved UX, modern Wayland features

---

### 🖱️ **3. Input Configuration Improvements**

Enhanced input settings with detailed touchpad/mouse configuration:

- **Touchpad enhancements**:
  - `tap-to-click = true` - Tap to click
  - `drag_lock = 0` - Disabled for intentional behavior
  - `tap-and-drag = true` - Drag after tap
  - `scroll_factor = 1.0` - Default scroll speed
  - `middle_button_emulation = false` - Precision over convenience
  - `clickfinger_behavior = false` - Location-based clicks
  
- **Mouse improvements**:
  - `mouse_refocus = true` - Only refocus on window boundary crossing
  - `focus_on_close = 0` - Focus next window candidate (not cursor position)
  - `accel_profile = ""` - Use libinput default
  - `scroll_factor = 1.0` - Standard scroll speed
  
- **Keyboard**:
  - `repeat_rate = 25` - 25 repeats/second
  - `repeat_delay = 600` - 600ms before repeat

**Impact**: More precise input control, better touchpad UX

---

### 🎮 **4. Render & Gaming Optimization**

Added new `render` and `xwayland` sections:

**Render settings**:
- **`direct_scanout = 2`** - Auto-enable for games (lower latency)
  - `0`=off, `1`=on, `2`=auto (on with content type 'game')
- **`new_render_scheduling = true`** - Auto triple buffering for better FPS

**XWayland settings**:
- **`enabled = true`** - Legacy X11 app support
- **`use_nearest_neighbor = true`** - Sharper XWayland rendering
- **`force_zero_scaling = false`** - No HiDPI forcing (prevents pixelation)

**Impact**: Better gaming performance, smoother rendering on lower-end devices

---

### ⌨️ **5. Keybind Behavior Tuning**

Added `binds` section with fine-grained control:

- **`scroll_event_delay = 300`** - 300ms between scroll events
- **`workspace_back_and_forth = false`** - Standard workspace behavior
- **`workspace_center_on = 0`** - Center on workspace, not last window
- **`focus_preferred_method = 0`** - History-based focus (recent priority)
- **`allow_workspace_cycles = false`** - No endless workspace loops
- **`movefocus_cycles_fullscreen = false`** - Move focus changes direction in fullscreen
- **`drag_threshold = 0`** - Grab on mousedown (instant response)

**Impact**: More predictable keybind behavior, better workspace navigation

---

### 🔋 **6. CRITICAL: Battery Drain Fix**

**Changed**: `borderangle` animation from `loop` to `once`

**Before**:
```conf
animation = borderangle, 1, 100, linear, loop
```

**After**:
```conf
animation = borderangle, 1, 100, linear, once
```

**Why this matters**:
- `loop` style forces Hyprland to render at **full screen refresh rate** (60fps) **constantly**
- This happens **even when animations are disabled or borders are invisible**
- Significant battery drain on laptops
- Using `once` plays the animation once, then stops rendering

**Impact**: ⚠️ **MAJOR BATTERY SAVINGS** on laptops

---

### 🎨 **7. Animation Enhancement**

Added `workspace_wraparound` setting:

```conf
workspace_wraparound = false  # Set to true for workspace 1 ↔ 10 connection
```

**Impact**: Optional seamless workspace cycling (currently disabled for standard behavior)

---

## �� **PERFORMANCE EXPECTATIONS**

| Area | Before | After | Impact |
|------|--------|-------|--------|
| **Battery Life** | ⚠️ Constant 60fps rendering | ✅ Render only when needed | 🔋🔋🔋 **High savings** |
| **Gaming** | Good | ✅ Direct scanout + VRR optimized | 🎮 **Lower latency** |
| **Cursor UX** | Basic | ✅ Smart warping + auto-hide | 👆 **Better workflow** |
| **Fullscreen VRR** | Could break on cursor move | ✅ Protected | 🎯 **Stable FPS** |
| **Unfocused Windows** | Full FPS | ✅ Limited to 15fps | 🔋 **Battery saver** |
| **Triple Buffering** | Manual | ✅ Auto when needed | 📈 **Better FPS** |

---

## 🔍 **TESTING COMMANDS**

Verify the changes:

```bash
# Check cursor settings
hyprctl getoption cursor:inactive_timeout
hyprctl getoption cursor:persistent_warps
hyprctl getoption cursor:no_break_fs_vrr

# Check misc optimizations
hyprctl getoption misc:vrr
hyprctl getoption misc:render_unfocused_fps
hyprctl getoption misc:new_window_takes_over_fullscreen

# Check render settings
hyprctl getoption render:direct_scanout
hyprctl getoption render:new_render_scheduling

# Check animation (should show 'once', not 'loop')
hyprctl getoption animations:borderangle

# Monitor battery usage (before/after comparison)
powerstat -d 0
```

---

## 💡 **OPTIONAL TWEAKS**

### For Even Better Battery Life:

```conf
# In hyprland.conf
misc {
    disable_autoreload = true  # Disable auto-reload on save (manual: hyprctl reload)
}

cursor {
    inactive_timeout = 1  # Hide cursor after 1 second instead of 3
}
```

### For Workspace Wraparound:

```conf
# In hyprland/animation.conf
animations {
    workspace_wraparound = true  # Workspace 1 connects to workspace 10
}
```

### For XMonad-Style Workspace Switching:

```conf
# In hyprland.conf
binds {
    workspace_back_and_forth = true  # Pressing current workspace goes to previous
}
```

---

## 📝 **COMPATIBILITY NOTES**

- ✅ All changes are **v0.51.1 specific** and verified against official docs
- ✅ No existing keybinds were modified (per design philosophy)
- ✅ All optimizations are **non-breaking** and reversible
- ✅ Changes follow your config's "stable over dynamic" principle

---

## 🚀 **WHAT'S NEW IN YOUR CONFIG**

You now have:

1. **Modern cursor behavior** with smart warping and auto-hide
2. **Better battery life** (borderangle fix + VRR optimization)
3. **Gaming optimizations** (direct scanout, VRR protection)
4. **Smoother rendering** (auto triple buffering)
5. **Finer input control** (detailed touchpad/mouse settings)
6. **Predictable keybinds** (configurable workspace behavior)

---

## ⚙️ **HYPRLAND VERSION**

These improvements are specifically for **Hyprland v0.51.1**.

Check your version:
```bash
hyprctl version
```

---

**Status**: ✅ **APPLIED** - All improvements have been written to config files.
**Next Step**: Reload Hyprland with `hyprctl reload` or restart your session.

---

*Generated by The Architect - Hyprland v0.51.1*
