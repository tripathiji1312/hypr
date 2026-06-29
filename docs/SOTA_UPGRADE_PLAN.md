# 🚀 State-of-the-Art Hyprland Upgrade Plan
## From Good to Professional OS-Level Experience

**Based on:** Your current Hyprland v0.55 setup (Ryzen 5 5500U, Radeon iGPU, Arch Linux)
**Target:** macOS/Windows 11 level polish — beautiful, smooth, native-feeling
**Date:** June 2026

---

## Table of Contents
1. [Shell Overhaul — Quickshell → Production Quality](#1-shell-overhaul)
2. [Hyprland 0.55 Native Features You Should Use](#2-hyprland-055-features)
3. [Animation & Micro-Interaction Polish](#3-animation-polish)
4. [Performance Tuning for AMD iGPU](#4-performance-tuning)
5. [Desktop Integration Features](#5-desktop-integration)
6. [Unified Theming System](#6-unified-theming)
7. [Workflow & UX Refinements](#7-ux-refinements)
8. [Screenshots & Visual Previews](#8-visuals)
9. [Implementation Roadmap](#9-roadmap)

---

## 1. Shell Overhaul — Quickshell → Production Quality <a id="1-shell-overhaul"></a>

You're already running Quickshell — that's the right foundation. The SOTA Quickshell configs in 2026 are approaching Caelestia Shell quality. Here's what you should build:

### 1A. Control Center (Dashboard)
Build a slide-out control center panel with:
- **Quick toggles**: Wi-Fi, Bluetooth, DND, mic mute, game mode
- **System monitors**: CPU/GPU/RAM/network gauges
- **Media player**: MPRIS integration with album art
- **Weather**: via wttr.in or OpenWeatherMap
- **Volume & brightness sliders**

**Reference:** [doannc2212/quickshell-config](https://github.com/doannc2212/quickshell-config) has a clean modular layout. [Caelestia Shell](https://github.com/caelestia-dots/shell) sets the bar for polish.

### 1B. Notification Center
Replace dunst with an in-shell notification center:
- Grouping by app
- Urgency-based styling (subtle/medium/critical)
- Do Not Disturb toggle
- History view
- Expand/collapse per notification
- Action buttons (reply, open, dismiss)

### 1C. Bar Enhancements
Your current Quickshell bar should have:
- Per-monitor workspaces with window icons
- Active window title (truncated to ~40 chars)
- System tray with proper icon substitution
- Now-playing indicator (MPRIS)
- CPU/RAM/network on secondary monitor
- Clock with calendar popout on click
- Power menu indicator

### 1D. OSD (On-Screen Display)
Replace your current volume/brightness OSD scripts with a proper QML overlay:
- Vertical pill or horizontal bar
- Auto-hides after 1.5s
- Shows device icon (speaker/mic/monitor)
- Animated with spring curve

### 1E. Launcher
Build a QML launcher to replace wofi:
- Grid of apps with recent-first ordering
- Calculator (powered by Qalc)
- Color scheme switcher
- Wallpaper picker
- System actions (lock, sleep, shutdown)

**Why:** wofi is GTK and will never look native next to a Qt/QML shell. A QML launcher matches Quickshell visually.

### 1F. Session Screen
Replace your bash powermenu with a QML session dialog:
- Buttons: Lock, Logout, Suspend, Hibernate, Reboot, Shutdown
- Blurred background (your current wallpaper)
- Smooth fade-in/fade-out
- Confirmation for destructive actions

---

## 2. Hyprland 0.55 Native Features You Should Use <a id="2-hyprland-055-features"></a>

You're on v0.55.0 — you have access to these new/exclusive features:

### 2A. Native Lua Configuration (Already Using ✓)
You're already generating Lua configs, but you can go deeper:
- Use `hl.config()` for runtime reconfiguration (already doing this for gaps/blur toggles)
- Use `hl.notification.create()` for in-compositor notifications
- Use `hl.animation()` to define and preview animations live

### 2B. User-Defined Layouts
The biggest game-changer in 0.55. Register a custom layout:

```lua
-- Example: Register a "master-stack" layout
hl.layout.register("master_stack", {
    recalculate = function(ws, monitors)
        -- Your custom layout logic here
        -- Arrange windows: master on left, stack on right
    end
})

-- Then use it:
hl.config({
    general = { layout = "lua:master_stack" }
})
```

- Can be set per-workspace, per-monitor, or globally
- Paired with `layout_msg` for live layout modifications
- **Replace `dwindle` on workspace 1** (main) with a `lua:master` layout for a cleaner look
- **Keep `scrolling`** on workspace 2 (code) and 3 (browser)

**Source:** [Hyprland Custom Layouts Wiki](https://wiki.hypr.land/Configuring/Layouts/Custom-Layouts/)

### 2C. ICC Profile Support
Add per-output ICC profiles for color accuracy:
```lua
hl.config({
    monitor = {
        name = "eDP-1",
        icc = "/usr/share/color/icc/colord/edid-*.icc"
    }
})
```
**Why:** Your Ryzen 5500U's display likely has an sRGB panel — proper ICC makes photos/video look correct.

### 2D. FP16 Render Pipeline
Enabled by default on 0.55 for color-managed displays. Keep `cm_auto_hdr` enabled if your panel supports it.

### 2E. New Window Rules
```
windowrule = confine_pointer on         -- Lock pointer to window (games)
windowrule = move_into_or_create_group  -- Auto-group during move dispatcher
```

### 2F. `scroll_move` Native Trackpad Support
Use in Lua for 1:1 trackpad scrolling of window tape:
```lua
-- Native scroll_move vs the old gesture workaround
gestures {
    gesture = 3, horizontal, scroll_move
}
```
This gives **smoother** workspace scrolling than the `workspace` dispatcher.

### 2G. Live Pinch Cursor Zoom Gesture
You already have cursor zoom via `gesture = 2, pinchout, cursorZoom`. v0.55 improves this with **live** zoom — the zoom follows your cursor in real-time rather than jumping.

---

## 3. Animation & Micro-Interaction Polish <a id="3-animation-polish"></a>

Your spring-based animations are already excellent. Here's the next level:

### 3A. Refined Bezier Curves
```lua
-- macOS Sonoma-style curves (more natural than what you have)
bezier = macos_fluid,    0.25, 0.1, 0.25, 1.0    -- Standard ease-in-out
bezier = macos_snappy,   0.15, 0.85, 0.35, 1.05   -- Slight overshoot
bezier = macos_bouncy,   0.34, 1.56, 0.64, 1.0    -- Playful bounce
bezier = macos_smooth,   0.42, 0.0, 0.58, 1.0     -- Cinematic ease

-- Apply to specific animations:
animation = windowsIn, 1, 4, macos_snappy, popin 85%
animation = windowsMove, 1, 4, macos_smooth
animation = workspaces, 1, 5, macos_fluid, slidefade 25%
```

### 3B. Multi-Stage Window Open
Instead of a single popin, use **two-stage** animations:
- Stage 1: Scale from 90% → 100% (100ms, fast)
- Stage 2: Slight overshoot bounce to settle (200ms, spring)

Achieve this by chaining `bezier` curves in your animation style (pick styles that naturally do this — `slide` and `popin` have built-in multi-stage behavior when combined with spring bezier curves).

### 3C. Gradient Border Animation Refinement
You already have animated gradient borders (cyan↔purple). Stabilize it:
```lua
-- Faster gradient rotation for active windows (feels alive)
animation = borderangle, 1, 90, linear, once
-- But only for focused windows (saves GPU)
windowrule = match:float false, borderangle 0  -- static gradient on inactive
```

### 3D. Layer Animation Timings
Fine-tune your layer animations for a native feel:
```lua
-- Menus: ultra-fast with spring tease
animation = layersIn, 1, 2, spring_menu, popin
animation = layersOut, 1, 1.5, fluent_accel, slide  -- faster out than in

-- Notifications: slide in from right with spring
animation = fadeLayersIn, 1, 3, spring_snappy
```

### 3E. Window Swipe Gesture Feedback
Add subtle feedback animations for gesture triggers:
```lua
-- When 3-finger swipe starts, window slightly shrinks
gesture = 3, horizontal, workspace, 10  -- 10% threshold for activation feedback
```

### 3F. Focus Animations
You have hyprfocus with flash. Consider:
```lua
plugin {
    hyprfocus {
        flash {
            flash_opacity = 0.80      -- Slightly lower (less jarring)
            in_speed = 0.3            -- Faster flash-in
            out_speed = 4             -- Faster fade-out
            flash_color = rgba(33ccffee)  -- Match your border color
        }
    }
}
```

---

## 4. Performance Tuning for AMD iGPU <a id="4-performance-tuning"></a>

Your Ryzen 5 5500U has a Radeon RX Vega 7 (7 CUs, ~1.8 GHz). Here's how to get the smoothest experience:

### 4A. Current Config Tuning
You already have some of these right. Verify/add:
```lua
render {
    direct_scanout = 2      -- ✅ Already set — bypasses compositor for fullscreen
    new_render_scheduling = true  -- ✅ Already set — reduces latency
    explicit_sync = 0       -- NOT SET — set to 0 on AMD iGPU (1 is for NVIDIA)
}

cursor {
    no_break_fs_vrr = 2     -- ✅ Already set — maintains VRR in fullscreen
    no_hardware_cursors = 2 -- ✅ Already set — use software cursors (AMD iGPU workaround)
}

misc {
    vrr = 2                 -- ✅ Already set — Adaptive sync (fullscreen only)
    disable_hyprland_logo = true  -- ✅ Already set
}
```

### 4B. AMD-specific Kernel Parameters
Add to `/etc/default/grub`:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="... amdgpu.sg_display=0 amdgpu.dcdebugmask=0x10"
```
- `amdgpu.sg_display=0` — Fixes stutter on some Ryzen mobile SKUs
- `amdgpu.dcdebugmask=0x10` — Enables PSR (Panel Self Refresh) for power saving

### 4C. Reduce Blur Cost
Your blur settings (passes=3, size=8) are reasonable but costly on iGPU:
```lua
decoration {
    blur {
        passes = 2           -- Drop from 3 to 2 (almost no visual difference)
        size = 6             -- Drop from 8 to 6
        new_optimizations = true  -- ✅ Already set
        xray = true          -- ✅ Already set — big perf win
    }
}
```
**Better approach:** Use per-window overrides. Disable blur on:
- Fullscreen windows (`no_blur on` via windowrule — you already do this for dim)
- Games (via class match)
- Terminals that don't need it

### 4D. Reduce Shadow Cost
```lua
shadow {
    range = 24              -- Drop from 30 to 24 (saves GPU fill rate)
    render_power = 2        -- Drop from 3 to 2
    scale = 0.95            -- Drop from 0.97 [already a tiny perf win]
}
```

### 4E. TLP/Power Profile
Your 5500U laptop benefits from:
```bash
# Install and configure TLP
sudo pacman -S tlp
sudo systemctl enable tlp

# Or for more modern control, use power-profiles-daemon
sudo pacman -S power-profiles-daemon
powerprofilesctl set balanced  # or performance when plugged in
```

### 4F. Compositor Scheduling
```lua
misc {
    disable_autoreload = false    -- Default, fine
    vfr = true                     -- Variable frame rate (saves battery)
    -- Note: vfr moved to debug: in v0.55
}
debug {
    vfr = true                     -- v0.55 moved here
    damage_tracking = 2            -- Full damage tracking (best balance)
}
```

### 4G. Monitor Refresh
Ensure your display runs at its native refresh:
```lua
monitor = eDP-1, preferred, auto, 1, 60  -- Force 60Hz if preferred picks wrong
env = AQ_NO_MODIFIERS,1  -- Avoid display pipeline issues on AMD
```

---

## 5. Desktop Integration Features <a id="5-desktop-integration"></a>

### 5A. Hyprexpo — Workspace Overview (Mission Control)
Install and configure for macOS-style Mission Control:
```bash
hyprpm add https://github.com/sandwichfarm/hyprexpo
hyprpm enable hyprexpo
hyprpm reload
```

Then bind:
```lua
bind = $mainMod, grave, hyprexpo:expo, toggle
```

**Source:** [sandwichfarm/hyprexpo](https://github.com/sandwichfarm/hyprexpo)

### 5B. Dock
Options for a macOS-style dock:

**Option A: nwg-dock-hyprland** (GTK, lightweight)
```bash
sudo pacman -S nwg-dock-hyprland
```
Auto-hides, shows open windows, hardware-accelerated.

**Source:** [nwg-piotr/nwg-dock-hyprland](https://github.com/nwg-piotr/nwg-dock-hyprland)

**Option B: Build a QML dock in Quickshell** (recommended for visual consistency)
- Matches your bar's look exactly
- Spring animations for hover magnification
- Auto-hide with configurable delay
- Show only current workspace windows (macOS style)
- Drag-to-rearrange

### 5C. Hot Corners
Add macOS-style hot corners:
```lua
# Top-left: Workspace overview
bind = , mouse:288, hyprexpo:expo, toggle  # 288 = corner event

# Top-right: Notification center
bind = , mouse:289, exec, quickshell-notif-center-toggle

# Bottom-left: Show desktop
bind = , mouse:290, exec, hyprctl dispatch workspace, special:desktop

# Bottom-right: Quick note / scratchpad
bind = , mouse:291, exec, togglespecialworkspace, term
```

**Better approach:** Use a daemon like `hyprland-hot-corners` or implement in Quickshell (QML has native cursor tracking).

### 5D. Dynamic Wallpaper
```bash
# Option 1: mpvpaper (video wallpapers)
sudo pacman -S mpvpaper
mpvpaper eDP-1 ~/Videos/wallpaper.mp4

# Option 2: Day/night wallpaper cycle
# Use your pywal infrastructure + cron/sunset timer
```

### 5E. System Tray Improvements
```lua
-- Move system tray to Quickshell (full native rendering)
-- Enable proper tray icon substitution for missing icons
layerrule = match:namespace ^(tray.*)$, blur on
```

### 5F. Quickshell Calendar Popout
Build a QML calendar that pops out of your bar's clock:
- Shows current month
- Click days for quick notes
- Integrates with `calcurse` or `khal` for events

---

## 6. Unified Theming System <a id="6-unified-theming"></a>

### 6A. wallust — The Modern pywal
Replace pywal with [wallust](https://github.com/explosion-mental/wallust) (actively maintained fork):
```bash
sudo pacman -S wallust
```
- Generates 16-color palettes from wallpaper
- Supports templates for: kitty, waybar, dunst, rofi, GTK, Qt, spotify, VS Code
- Sequences commands on wallpaper change (no race conditions)

### 6B. Themify Every Layer
Your current pywal setup only themes kitty and some scripts. Go full-uniform:

| App | Theming Method | Status |
|-----|---------------|--------|
| **Kitty** | Pywal/wallust `theme.conf` include | ✅ Done |
| **Quickshell** | QML properties from wallust JSON | 🔲 Add |
| **Dunst** | wallust template → `dunstrc` | 🔲 Add |
| **GTK** | `oomox` or `nwg-look` with generated palette | 🔲 Add |
| **Qt (Kvantum)** | `qt5ct` + Kvantum with pywal palette | 🔲 Add |
| **VS Code** | `.vscode/settings.json` `workbench.colorCustomizations` | 🔲 Add |
| **Firefox/Chrome** | Sidebery / pywal theme extension | 🔲 Add |
| **Wofi** | wallust template → `style.css` | 🔲 Add |
| **Rofi** | wallust template → `config.rasi` | 🔲 Add |
| **Hyprland borders** | wallust template → Lua module | 🔲 Add |
| **Hyprlock** | wallust template → `hyprlock.conf` | 🔲 Add |

### 6C. Smart Theme Switching
Your `startup_theme.sh` and `change_wallpaper_once.sh` scripts already do some of this. Supercharge:

```bash
# Each wallpaper change should:
# 1. wallust run ~/path/to/wallpaper
# 2. hyprctl hyprpaper wallpaper ",~path"
# 3. sleep 0.5
# 4. nwg-look -a (apply GTK theme from generated palette)
# 5. kill -USR1 kitty (reload kitty colors)
# 6. pkill dunst (reload with new theme)
# 7. quickshell reload (update bar with new accent colors)
# 8. hyprctl reload (update borders from generated Lua)
```

### 6D. Font Consistency
You're using SF Pro Display (Apple) in hyprlock but FiraCode Nerd Font in terminal and Segoe UI Variable Display in groupbar. For professional uniformity:

- **UI:** SF Pro Display (or Inter / Cantarell) consistently across bar, notifications, launcher
- **Monospace:** JetBrains Mono Nerd Font (most complete Nerd Font patching)
- **Bar icons:** Use the same icon font everywhere (e.g., Material Symbols or Font Awesome 6)

```ini
# Unified font system:
env = FONT_UI,SF Pro Display,12
env = FONT_MONO,JetBrainsMono Nerd Font Mono,12
env = FONT_ICONS,Font Awesome 6 Free Solid,12
```

---

## 7. Workflow & UX Refinements <a id="7-ux-refinements"></a>

### 7A. Window Swallowing
Prevent terminal-within-terminal clutter (e.g., when you open `nvim` from kitty):
```lua
misc {
    swallow_regex = ^(kitty|alacritty|foot)$
    swallow_exception_regex = ^(btm|htop|nvim)$  -- Don't swallow these
}
```

### 7B. Smart Workspace Rules
Use the new v0.55 scrolling features:
```lua
scrolling {
    consume = true           -- Opening new window on same workspace moves tape
    consume_or_expel = true  -- Smart window positioning
    auto_consuming = true    -- Auto-consume on bind

    fullscreen_on_one_column = true    -- ✅ Already set
    focus_fit_method = 1               -- ✅ Already set
}
```

### 7C. Per-Workspace Layouts
Different layouts per workspace context:
```lua
# Worskpace 1 (main): master-stack (left pane + right stack)
workspace = 1, layout:lua:master_stack

# Workspace 2 (code): scrolling layout (infinite horizontal tape)
workspace = 2, layout:scrolling

# Workspace 3 (browser): dwindle (traditional tiling)
workspace = 3, layout:dwindle
```

### 7D. Keybind Ergonomics Audit
Your keybinds are extensive. Professional OS feel requires:
- **Consistent modifiers**: All workspace moves use $mainMod SHIFT, all window ops use $mainMod CTRL — you already have this ✓
- **Easy reach**: Most-used bindings on home row (you have this ✓)
- **Discovery**: Your `keybind_viewer.sh` is excellent — consider making it searchable

### 7E. Submap Indicators
Add visual feedback for submaps (resize mode):
```lua
# In your Quickshell bar, show current submap
# Have hyprctl dispatch sends a notification:
bind = $mainMod, R, submap, resize
# => Bar shows "⌨ Resize Mode [h/j/k/l or arrows]"
```

### 7F. Minimalist Boot & Session Experience
- **Greeter**: Use `ly` or `sddm` with a themed config that matches your desktop
- **Auto-start ordering**: Your `autostart.lua` is well-organized. Add `sleep 0.5` between critical services (polkit → portal → hyprpaper → quickshell → hypridle)
- **Session restore**: Add `hyprctl dispatch workspace 1` as last autostart item

---

## 8. Screenshots & Visual Previews <a id="8-visuals"></a>

*No screenshots available from research — consider sharing your own r/unixporn post once implemented!*

---

## 9. Implementation Roadmap <a id="9-roadmap"></a>

### Phase 1 — Foundation (Week 1) ⚡ Quick Wins
| # | Task | Est. Time | Impact |
|---|------|-----------|--------|
| 1 | **wallust** → replace pywal | 30 min | 🔥🔥🔥 |
| 2 | **wallust templates** for kitty, dunst, borders, hyprlock | 1 hr | 🔥🔥🔥 |
| 3 | **Hyprexpo** install + bind | 15 min | 🔥🔥 |
| 4 | Verify all v0.55 settings (render, misc, debug) | 30 min | 🔥🔥 |
| 5 | AMD kernel params + TLP | 30 min | 🔥🔥 |
| 6 | Font unification (SF Pro + JetBrains Mono) | 15 min | 🔥🔥 |

### Phase 2 — Shell Depth (Week 2) 🎯 Deep Polish
| # | Task | Est. Time | Impact |
|---|------|-----------|--------|
| 7 | Quickshell control center (QML panel) | 3-4 hrs | 🔥🔥🔥 |
| 8 | In-shell notification center | 2-3 hrs | 🔥🔥🔥 |
| 9 | Custom QML OSD (replace scripts) | 1 hr | 🔥🔥 |
| 10 | Refined spring animations + bezier curves | 45 min | 🔥🔥🔥 |
| 11 | Per-workspace custom layouts (Lua API) | 2 hrs | 🔥🔥 |

### Phase 3 — Pro Features (Week 3) ✨ Professional OS Feel
| # | Task | Est. Time | Impact |
|---|------|-----------|--------|
| 12 | QML dock (or nwg-dock-hyprland) | 2 hrs | 🔥🔥🔥 |
| 13 | Hot corners daemon | 1 hr | 🔥🔥 |
| 14 | Window swallowing | 5 min | 🔥 |
| 15 | Session screen (QML powermenu replacement) | 1 hr | 🔥🔥 |
| 16 | QML launcher (replace wofi) | 2-3 hrs | 🔥🔥🔥 |

### Phase 4 — Perfection (Ongoing) 🎨 Never Settle
| # | Task | Est. Time | Impact |
|---|------|-----------|--------|
| 17 | System tray in Quickshell | 1 hr | 🔥🔥 |
| 18 | Unify all app themes (GTK/Qt/Electron) | 2 hrs | 🔥🔥🔥 |
| 19 | Dynamic wallpapers (day/night or video) | 30 min | 🔥 |
| 20 | Calendar popout | 1 hr | 🔥 |
| 21 | r/unixporn post with your dotfiles! | — | 🏆 |

---

## Key References

- [Hyprland 0.55 Release Notes](https://hypr.land/news/update55/) — Official changelog
- [Hyprland Performance Wiki](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Performance/) — Performance tuning
- [Hyprland Custom Layouts](https://wiki.hypr.land/Configuring/Layouts/Custom-Layouts/) — Lua layout API
- [Hyprland Animation Wiki](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/) — Animation docs
- [Hyprexpo Plugin](https://github.com/sandwichfarm/hyprexpo/) — Workspace overview
- [Quickshell Config Reference](https://github.com/doannc2212/quickshell-config) — Modular QML shell
- [Caelestia Shell](https://github.com/caelestia-dots/shell) — SOTA shell reference
- [nwg-dock-hyprland](https://github.com/nwg-piotr/nwg-dock-hyprland) — GTK dock for Hyprland
- [wallust](https://github.com/explosion-mental/wallust) — Modern pywal fork
- [fancypantalons/hyprland-config](https://github.com/fancypantalons/hyprland-config) — Lua-maximalist 0.55 config reference

---

*Generated via deep research — specific recommendations based on your hardware (Ryzen 5 5500U, Radeon iGPU, Hyprland v0.55) and existing config analysis.*
