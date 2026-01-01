# Hyprland Configuration - AI Agent Instructions

## Architecture Overview

This is a **modular Hyprland configuration** for user `tripathiji` running on Arch Linux (v0.53). The config prioritizes minimalism, aesthetic polish, and functional reliability.

### Core Structure
- **Main Entry**: `hyprland.conf` - Sets monitors, environment, sources all modules
- **Modular Configs**: `hyprland/*.conf` - Isolated concerns (animations, decorations, keybinds, window rules, autostart)
- **Scripts**: `scripts/*.sh` - Automation for wallpapers, themes, PiP, screenshots, popups
- **Hypr Ecosystem**: Separate configs for `hypridle.conf`, `hyprlock.conf`, `hyprpaper.conf`

### Critical Design Patterns

#### 1. **Pywal + GTK Theme Hybrid System**
The setup uses **Pywal for dynamic theming** BUT forces a **stable GTK theme** to prevent portal glitches:
```bash
# Change wallpaper → Generate Pywal colors → Override GTK
~/.config/hypr/scripts/change_wallpaper_once.sh  # Manual change
~/.config/hypr/scripts/startup_theme.sh           # On boot
~/.config/hypr/scripts/pywal_reload.sh            # The GTK fixer
```
**Why**: Pywal colors GTK portals incorrectly causing visual artifacts. The fixer forces `adw-gtk3-dark` while letting Waybar/Dunst/Kitty use Pywal colors.

#### 2. **Window Rules Architecture** (`hyprland/window.conf`)
Rules are **defense-in-depth** to prevent buggy floating behavior:
- Match by `class:` + `title:` patterns (never class alone for dialogs)
- GTK portal rules include `noblur, noshadow, opaque, noborder` fixes
- **Never use `stayfocused`** on popups/menus (blocks main window interaction)
- PiP rules: `float, pin, noborder, size 25%, move 72% 72%`


#### 3. **Scratchpad Workspaces** (`special:` workspaces)
- `special:term` - Scratchpad terminal (auto-launched on boot)
- `special:music`, `special:files` - Optional scratchpads
- Toggle with `Super + S`, move with `Super + Shift + S`

#### 4. **Animation System** (`hyprland/animation.conf`)
Uses **custom bezier curves** for polished feel:
```conf
bezier = wind, 0.05, 0.9, 0.1, 1.05          # Window movement
bezier = winIn, 0.1, 1.1, 0.1, 1.1           # Window open (overshoot)
bezier = overshot, 0.05, 0.9, 0.1, 1.1       # Smooth with bounce
```
Apply with `animation = windowsIn, 1, 5, winIn, popin 80%`

### User-Specific Rules

**Core Applications**:
- Browsers: Vivaldi (primary), Brave, Zen, Chrome - all forced `opacity 1.0`
- Terminal: Kitty (with Pywal auto-reload via `SIGUSR1`)
- File Manager: Thunar

**Aesthetic Requirements**:
- Minimalistic: `gaps_in = 4`, `gaps_out = 8`, `rounding = 12`
- Clean borders: Active `rgba(33ccffee) rgba(00ff99ee) 45deg`, Inactive `rgba(595959aa)`
- Blur disabled on popups/portals to prevent glitches

**Keybind Philosophy**: 
- **NEVER modify existing keybinds** - only add non-conflicting ones
- Super (SUPER_L) key opens Wofi launcher
- Super + W changes wallpaper/theme instantly

### Development Workflows

#### Testing Window Rules
```bash
# Find window class/title
hyprctl clients | grep -A5 "class\|title"
# OR use the helper script
~/.config/hypr/scripts/find_window_class.sh
```

#### Reloading Config
Hyprland auto-reloads on save, but for scripts/autostart:
```bash
hyprctl reload  # Full reload
# Or test scripts individually
~/.config/hypr/scripts/pywal_reload.sh
```

#### Debugging Theme Issues
1. Check if Pywal generated colors: `cat ~/.cache/wal/colors`
2. Verify GTK theme applied: `gsettings get org.gnome.desktop.interface gtk-theme`
3. Check portal logs: `journalctl --user -u xdg-desktop-portal-gtk.service`

### Common Gotchas

1. **Blur on XDG Portals** → Always disable: `noblur, noshadow, opaque, noborder`
2. **Popup Focus Stealing** → Never use `stayfocused` on menus/dropdowns
3. **Pywal + GTK Conflict** → Always run `pywal_reload.sh` after color generation
4. **PiP Windows** → Must be `float, pin, noborder` + positioned `move 72% 72%`
5. **XWayland Apps** → Set in `env = QT_QPA_PLATFORM,wayland;xcb` for compatibility

### Key File Reference

| File | Purpose |
|------|---------|
| `hyprland.conf` | Main entry, monitor setup, sources all modules |
| `hyprland/keybinds.conf` | All keybinds (DO NOT MODIFY existing ones) |
| `hyprland/window.conf` | Window rules (floating, PiP, browser-specific) |
| `hyprland/decorations.conf` | Gaps, borders, blur, shadows |
| `hyprland/animation.conf` | Bezier curves and animation config |
| `hyprland/autostart.conf` | Exec-once programs and services |
| `scripts/pywal_reload.sh` | Critical GTK theme fixer |
| `scripts/change_wallpaper_once.sh` | Manual wallpaper change |
| `scripts/auto_pip.sh` | Auto PiP workspace tracking |

### When Adding New Features

1. **Check existing patterns** in `hyprland/window.conf` for similar window rules
2. **Test window behavior** with `hyprctl clients` before writing rules
3. **Use modular approach** - add to appropriate `.conf` file, not main config
4. **Comment extensively** - explain WHY, not just WHAT
5. **Verify against docs** - Reference Hyprland Wiki for syntax validation

---

## Official Hyprland Documentation Reference (v0.53+)

**Primary Source**: [Hyprland Wiki](https://wiki.hyprland.org/) - Always verify syntax and features here.

### Essential Documentation Pages

#### Configuration Core
- **[Start](https://wiki.hyprland.org/Configuring/Start/)** - Config file basics, syntax, sourcing
- **[Variables](https://wiki.hyprland.org/Configuring/Variables/)** - All config variables (general, decoration, input, etc.)
- **[Keywords](https://wiki.hyprland.org/Configuring/Keywords/)** - `exec`, `source`, `env`, gestures, per-device configs

#### Window & Workspace Management
- **[Window Rules](https://wiki.hyprland.org/Configuring/Window-Rules/)** - `windowrule` syntax (`match:*` + effects), opacity, floating, PiP
  - Critical: Prefer precise `match:class` + `match:title` rules
  - Regex engine is **RE2** (no lookbehinds/lookaheads); use `negative:` for negation
- **[Workspace Rules](https://wiki.hyprland.org/Configuring/Workspace-Rules/)** - Per-workspace gaps, rounding, persistent workspaces
- **[Monitors](https://wiki.hyprland.org/Configuring/Monitors/)** - Resolution, position, scale, VRR, transform

#### Input & Interaction
- **[Binds](https://wiki.hyprland.org/Configuring/Binds/)** - Keybind syntax, flags (`l`, `r`, `e`, `m`), submaps
- **[Dispatchers](https://wiki.hyprland.org/Configuring/Dispatchers/)** - All available actions (`exec`, `movewindow`, `workspace`, etc.)
- **[Gestures](https://wiki.hyprland.org/Configuring/Gestures/)** - Touchpad gestures, workspace swipes

#### Visual Polish
- **[Animations](https://wiki.hyprland.org/Configuring/Animations/)** - Bezier curves, animation tree, per-element timing
- **[Dwindle Layout](https://wiki.hyprland.org/Configuring/Dwindle-Layout/)** - Split ratios, pseudotile, layout messages
- **[Master Layout](https://wiki.hyprland.org/Configuring/Master-Layout/)** - Alternative tiling layout

#### Advanced Features
- **[XWayland](https://wiki.hyprland.org/Configuring/XWayland/)** - HiDPI scaling, `force_zero_scaling`
- **[Environment Variables](https://wiki.hyprland.org/Configuring/Environment-variables/)** - `XCURSOR_THEME`, `QT_QPA_PLATFORM`, Nvidia vars
- **[Tearing](https://wiki.hyprland.org/Configuring/Tearing/)** - Low-latency gaming mode
- **[Using hyprctl](https://wiki.hyprland.org/Configuring/Using-hyprctl/)** - Runtime control, `dispatch`, `keyword`, `reload`

#### Hypr Ecosystem
- **[xdg-desktop-portal-hyprland](https://wiki.hyprland.org/Hypr-Ecosystem/xdg-desktop-portal-hyprland/)** - Screen sharing, file pickers
- **[hypridle](https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/)** - Idle management, DPMS, lock triggers
- **[hyprlock](https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/)** - Screen locker configuration
- **[hyprpaper](https://wiki.hyprland.org/Hypr-Ecosystem/hyprpaper/)** - Wallpaper daemon (note: we use `swww` instead)

### Quick Syntax References

**Window Rule Matching** (v0.53+):
```conf
windowrule = match:class ^(regex)$, match:title ^(regex)$, float on
windowrule = match:initialClass ^(regex)$, float on
windowrule = match:float true, no_shadow on
windowrule = match:fullscreen true, no_dim on
windowrule = match:workspace 2, opacity 1.0 override
```

**Animation Tree** (from Wiki):
```
global
  ↳ windows - styles: slide, popin, gnomed
    ↳ windowsIn, windowsOut, windowsMove
  ↳ fade - fadeIn, fadeOut, fadeSwitch, fadeShadow, fadeDim
  ↳ border, borderangle
  ↳ workspaces - styles: slide, slidevert, fade, slidefade
```

**Keybind Flags** (from Wiki):
- `l` - locked (works when screen is locked)
- `r` - release (trigger on key release)
- `e` - repeat (hold to repeat)
- `m` - mouse bind
- `n` - non-consuming (pass to window)

**Environment Variables** (from Wiki - we use these):
```bash
env = XCURSOR_THEME,Bibata-Modern-Ice
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORM,wayland;xcb
env = XDG_CURRENT_DESKTOP,Hyprland
```

### Documentation Best Practices

1. **Always check Wiki first** before suggesting config changes
2. **Verify RegEx syntax** - Hyprland uses Google RE2 (no lookbehinds)
3. **Test incrementally** - Add one rule at a time, verify with `hyprctl clients`
4. **Comment with Wiki references** - e.g., `# See: wiki.hyprland.org/Configuring/Window-Rules/`
5. **Cross-reference versions** - This config is for v0.51.1, syntax may change

---

### Configuration Philosophy (Derived from Wiki + User Preferences)

**From Hyprland Wiki**:
- Rules are evaluated **top to bottom** - last match wins
- Window rules are **case-sensitive**
- Use `hyprctl` for runtime debugging: `hyprctl clients`, `hyprctl monitors`, `hyprctl layers`

**Our Implementation**:
- **Modular over monolithic** - Split configs for maintainability
- **Precise over broad** - Match with `class:` + `title:` to avoid side effects
- **Stable over dynamic** - Force GTK theme despite Pywal to prevent portal bugs
- **Functional over flashy** - Disable blur on popups for stability

---

## Core Rules (Unbreakable)

1. **NEVER modify existing keybinds** - User workflow depends on them
2. **Always verify against Hyprland Wiki v0.51.1** - Syntax changes between versions
3. **Test with `hyprctl`** before committing - `hyprctl clients`, `hyprctl reload`
4. **Preserve modular structure** - Changes go in appropriate `hyprland/*.conf` files
5. **Comment with WHY** - Future maintainers (including AI) need context

---

## Known Issues & Troubleshooting

### Critical Issue: PiP & Popup Windows

**Problem**: Picture-in-Picture and popup windows feel janky, not smooth, and visually unpleasant.

**Root Causes**:
1. **Animations on small windows** - PiP windows with animations feel sluggish
2. **Blur effects** - Blur on popups causes lag and visual artifacts
3. **Wrong positioning** - PiP windows not pinned to corner consistently
4. **Focus stealing** - Popups grabbing focus from main windows
5. **Shadow rendering** - Unnecessary shadows on tiny windows

**Solutions** (Apply to `hyprland/window.conf`):

```conf
# === OPTIMIZED PiP RULES (Browser-Agnostic) ===
# Disable animations for smoother experience
windowrule = match:title ^(Picture-in-Picture)$, no_anim on
windowrule = match:title ^(Picture-in-Picture)$, float on
windowrule = match:title ^(Picture-in-Picture)$, pin on
windowrule = match:title ^(Picture-in-Picture)$, border_size 0
windowrule = match:title ^(Picture-in-Picture)$, no_shadow on
windowrule = match:title ^(Picture-in-Picture)$, no_blur on
windowrule = match:title ^(Picture-in-Picture)$, opacity 1.0 override
windowrule = match:title ^(Picture-in-Picture)$, size (monitor_w*0.25) (monitor_h*0.25)
windowrule = match:title ^(Picture-in-Picture)$, move (monitor_w*0.74) (monitor_h*0.73)  # Bottom-right corner
windowrule = match:title ^(Picture-in-Picture)$, keep_aspect_ratio on

# === OPTIMIZED POPUP RULES ===
# Fix for dropdown menus, context menus, tooltips
windowrule = match:float true, match:title ^$, no_anim on
windowrule = match:float true, match:title ^$, border_size 0
windowrule = match:float true, match:title ^$, no_blur on
windowrule = match:float true, match:title ^$, no_shadow on
windowrule = match:float true, match:title ^$, opacity 1.0 override

# Browser-specific popup optimization
windowrule = match:class ^(vivaldi-stable|brave-browser|Google-chrome|firefox)$, match:title ^$, no_anim on
windowrule = match:class ^(vivaldi-stable|brave-browser|Google-chrome|firefox)$, match:title ^$, no_blur on
windowrule = match:class ^(vivaldi-stable|brave-browser|Google-chrome|firefox)$, match:title ^$, no_shadow on
```

**Testing Commands**:
```bash
# Find PiP window properties
hyprctl clients | grep -A10 "Picture-in-Picture"

# Watch window creation in real-time
watch -n 0.5 'hyprctl clients | tail -20'

# Test rule matching
hyprctl clients -j | jq '.[] | select(.title | test("Picture-in-Picture"))'
```

**Why This Works**:
- `noanim` - Removes janky animation delays on small windows
- `noblur` - Prevents compositor overhead and visual glitches
- `noshadow` - Reduces rendering complexity
- `opacity 1.0 override` - Ensures solid, crisp rendering
- `keepaspectratio` - Prevents squishing of video content

### Critical Issue: Wallpaper Bleeding Through Popups/Context Menus ⚠️ **SOLVED**

**Problem**: Right-click context menus and app popups (especially Google Meet) show wallpaper bleeding through/around them. Looks forced, ugly, and unpleasant.

**Root Cause Analysis** (Solved by comparing `main` vs `v2.2` branches):

1. **`GTK_CSD=0` environment variable** → Forces GTK to use server-side decorations instead of client-side → Creates **BLACK BORDERS** around all popups/menus
2. **Aggressive window rules** on `title:^$` → Disabled blur/shadows/borders on ALL unnamed windows → Broke popup rendering
3. **Over-configured blur settings** → `ignore_opacity`, `popups = false` etc. caused conflicts

**Solution - The Minimal Working Config**:

```conf
# hyprland.conf - CRITICAL: DO NOT set GTK_CSD=0!
env = GTK_THEME,adw-gtk3-dark
# env = GTK_CSD,0  # ❌ NEVER SET THIS - causes black borders!

# decorations.conf - Keep it simple
blur {
    enabled = true
    new_optimizations = true
    xray = true  # ✅ CRITICAL: Prevents wallpaper bleed
    size = 6
    passes = 2
    vibrancy = 0.1696
    # DON'T add: ignore_opacity, popups, popups_ignorealpha
}

shadow {
    enabled = true  # ✅ Native shadows are good
    range = 20
    render_power = 4
}

# window.conf - NO aggressive popup rules needed!
# ❌ DON'T add: noborder, noblur, noshadow on title:^$
# Browser popups are subsurfaces - they render correctly by default
```

**Google Meet PiP Wallpaper Bleed** (Original Issue):

Created dedicated `hyprland/meet-pip-fix.conf`:
```conf
# Target ONLY Google Meet PiP windows (title pattern: "Meet - xxx-xxxx-xxx")
windowrule = match:class ^(vivaldi-stable)$, match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, opacity 1.0 override
windowrule = match:class ^(vivaldi-stable)$, match:title ^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$, no_shadow on
# Repeat for brave-browser, Google-chrome, firefox, zen
```

**Testing Commands**:
```bash
# Compare configs between branches
git diff main v2.2 hyprland.conf
git diff main v2.2 hyprland/decorations.conf

# Check what's causing issues
env | grep GTK_CSD  # Should be empty!
hyprctl getoption decoration:blur:xray  # Should be: int: 1
```

**Key Lessons**:
- ✅ `xray = true` is CRITICAL for preventing wallpaper bleed
- ❌ `GTK_CSD=0` causes black borders on all GTK popups
- ❌ Aggressive `title:^$` rules break browser popup rendering
- ✅ Browser popups/menus work perfectly with **default compositor settings**
- ✅ Only Google Meet PiP needs targeted opacity fixes

### Issue: GTK Portal Rendering Glitches

**Symptoms**: File pickers, screenshot tools show double shadows, borders, or blur artifacts.

**Solution**:
```conf
windowrule = match:class ^(xdg-desktop-portal-gtk)$, no_blur on
windowrule = match:class ^(xdg-desktop-portal-gtk)$, no_shadow on
windowrule = match:class ^(xdg-desktop-portal-gtk)$, opaque on
windowrule = match:class ^(xdg-desktop-portal-gtk)$, border_size 0
```

### Issue: Theme Changes Breaking Apps

**Symptoms**: After wallpaper change (`Super + W`), GTK apps look wrong.

**Debug Steps**:
```bash
# 1. Check if Pywal generated colors
cat ~/.cache/wal/colors

# 2. Verify GTK theme is correct
gsettings get org.gnome.desktop.interface gtk-theme
# Should output: 'adw-gtk3-dark'

# 3. Check portal status
systemctl --user status xdg-desktop-portal-gtk.service

# 4. Force theme reload
~/.config/hypr/scripts/pywal_reload.sh
```

### Issue: Scratchpad Terminal Not Working

**Symptoms**: `Super + S` doesn't show terminal.

**Debug Steps**:
```bash
# Check if scratchpad workspace exists
hyprctl workspaces | grep "special:term"

# Check if kitty is running in scratchpad
hyprctl clients | grep -A5 "class: scratchpad"

# Manually toggle scratchpad
hyprctl dispatch togglespecialworkspace term

# Re-launch scratchpad terminal
[workspace special:term silent] kitty --class scratchpad
```

---

## Script Documentation

### Core Scripts (`scripts/`)

#### `pywal_reload.sh` ⚠️ CRITICAL
**Purpose**: Fixes GTK theme after Pywal color generation
**When to use**: Automatically called by wallpaper scripts, or manually after theme breaks

**What it does**:
1. Forces GTK theme to `adw-gtk3-dark` (prevents Pywal GTK bugs)
2. Restarts desktop portals (file pickers, screenshot tools)
3. Reloads Waybar with new Pywal colors
4. Reloads Dunst with new Pywal colors
5. Signals Kitty to reload colors (`SIGUSR1`)

**Manual trigger**:
```bash
~/.config/hypr/scripts/pywal_reload.sh
```

#### `change_wallpaper_once.sh`
**Purpose**: Change wallpaper and regenerate theme
**Keybind**: `Super + W`

**Workflow**:
1. Find random wallpaper from `~/.config/hypr/wallpaper/`
2. Set wallpaper via `swww` (smooth transition)
3. Generate Pywal colors from wallpaper
4. **Immediately call `pywal_reload.sh`** to fix GTK theme

#### `startup_theme.sh`
**Purpose**: Initialize theme on Hyprland startup
**When**: `exec-once` in `autostart.conf`

**Workflow**:
1. Start `swww-daemon` if not running
2. Pick random wallpaper
3. Generate Pywal colors
4. Call `pywal_reload.sh` to stabilize GTK

#### `auto_pip.sh`
**Purpose**: Track PiP windows across workspace switches
**Status**: Experimental - may cause PiP jank

**How it works**:
1. Listens to workspace switch events via `socket2`
2. Detects if browser is on different workspace
3. Moves PiP window to active workspace

**Known Issues**:
- May conflict with browser PiP positioning
- Can cause focus stealing
- **Recommendation**: Disable if PiP feels janky

#### `screenshot.sh`
**Purpose**: Interactive screenshot menu
**Keybind**: `Print`

**Features**:
- Full screen capture
- Region selection
- Window capture
- Delayed capture (5s)
- Auto-copy to clipboard

#### `wofi_clipboard.sh`
**Purpose**: Clipboard history manager
**Keybind**: `Super + H`
**Backend**: `cliphist` + `wl-clipboard`

#### `wofi_network.sh`
**Purpose**: Network manager GUI
**Keybind**: `Super + N`
**Backend**: `nmcli` + `wofi`

### Hyprlock Scripts (`hyprlock/`)

These scripts provide dynamic info for the lock screen:

- `battery.sh` - Battery percentage and status
- `bluetooth.sh` - Bluetooth device info
- `network.sh` - WiFi SSID or connection status
- `playerctl.sh` - Current playing media
- `weatherinfo.sh` - Weather from IP geolocation
- `greeting.sh` - Time-based greeting

**Note**: These only run when `hyprlock` is active.

---

## Performance Optimization

### For Smooth PiP & Popups

Add to `hyprland/decorations.conf`:
```conf
decoration {
    blur {
        enabled = true
        popups = false          # CRITICAL: Disable blur on popups
        special = false         # Don't blur special workspaces
        xray = false            # CRITICAL: Prevent blur artifacts
        ignore_opacity = false  # CRITICAL: Respect window opacity
    }
}
```

Add to `hyprland/animation.conf`:
```conf
# Disable animations for PiP windows (targeted)
windowrule = match:title ^(Picture-in-Picture)$, no_anim on
```

### For Low-End Systems

```conf
misc {
    vfr = true               # Only render when needed
    render_unfocused_fps = 15  # Limit background rendering
}

decoration {
    blur {
        enabled = false      # Disable blur entirely
    }
    shadow {
        enabled = false      # Disable shadows
    }
}

animations {
    enabled = false          # Disable all animations
}
```

---

## Quick Diagnostic Commands

```bash
# Window debugging
hyprctl clients                           # List all windows
hyprctl clients -j | jq '.[] | {class, title, floating, pinned}'  # Filter key props
hyprctl activewindow                      # Current window details

# Monitor info
hyprctl monitors                          # All monitors
hyprctl monitors -j | jq '.[0].activeWorkspace'  # Active workspace

# Workspace debugging
hyprctl workspaces                        # List workspaces
hyprctl workspaces -j | jq '.[] | select(.name | startswith("special"))'  # Special workspaces

# Layer surfaces (bars, notifications)
hyprctl layers                            # Waybar, Dunst, etc.

# Real-time event monitoring
socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock -  # Watch all events

# Config reload
hyprctl reload                            # Reload configuration
hyprctl keyword <category:variable> <value>  # Change value at runtime

# Theme debugging
cat ~/.cache/wal/colors                   # Pywal colors
gsettings get org.gnome.desktop.interface gtk-theme  # Current GTK theme
systemctl --user status xdg-desktop-portal-gtk.service  # Portal status
```
# And here is the documentation official for refrencing, always make sure everything is correct and declutter it when u parse it because it is very big and unnnessory reptations.
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Language style and syntax
Basic configuring
Advanced configuring
Edit this page on GitHub →
Scroll to top 
Configuring
Start
Start
The config is located in $XDG_CONFIG_HOME/hypr/hyprland.conf. In most cases, that maps to ~/.config/hypr/hyprland.conf.

You can tell Hyprland to use a specific configuration file by using the --config (or -c) argument.

Hyprland will automatically generate an example config for you if you don’t have one. You can find an example config here.

By removing the line containing autogenerated=1 you’ll remove the yellow warning.

The config is reloaded the moment you save it. However, you can use hyprctl reload to reload the config manually.

Start a section with name { and end in } in separate lines!

The default config is not complete and does not list all the options / features of Hyprland. Please refer to this wiki page and the pages linked further down here for full configuration instructions.

Make sure to read the Variables page as well. It covers all the toggleable / numerical options.

Language style and syntax 
See the hyprlang page.

Basic configuring 
To configure Hyprland’s options, animations, styling, etc. see Variables.

Advanced configuring 
Some keywords (binds, curves, execs, monitors, etc.) are not variables but define special behavior.

See all of them in Keywords and the sidebar.

Last updated on October 4, 2025
Variables
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Variable types
Sections
General
Snap
Decoration
Blur
Shadow
Animations
Input
Touchpad
Touchdevice
Virtualkeyboard
Tablet
Per-device input config
Gestures
Group
Groupbar
Misc
Binds
XWayland
OpenGL
Render
Cursor
Ecosystem
Experimental
Debug
More
Edit this page on GitHub →
Scroll to top 
Configuring
Variables
Variables
For basic syntax info, see Configuring Hyprland.

This page documents all the “options” of Hyprland. For binds, monitors, animations, etc. see the sidebar. For anything else, see Keywords.

Please keep in mind some options that are layout-specific will be documented in the layout pages and not here. (See the Sidebar for Dwindle and Master layouts)

Variable types 
type	description
int	integer
bool	boolean, true or false (yes or no, on or off, 0 or 1) - any numerical value that is not 0 or 1 will cause undefined behavior.
float	floating point number
color	color (see hint below for color info)
vec2	vector with 2 float values, separated by a space (e.g. 0 0 or -10.9 99.1)
MOD	a string modmask (e.g. SUPER or SUPERSHIFT or SUPER + SHIFT or SUPER and SHIFT or CTRL_SHIFT or empty for none. You are allowed to put any separators you please except for a ,)
str	a string
gradient	a gradient, in the form of color color ... [angle] where color is a color (see above) and angle is an angle in degrees, in the format of 123deg e.g. 45deg (e.g. rgba(11ee11ff) rgba(1111eeff) 45deg) Angle is optional and will default to 0deg
font_weight	an integer between 100 and 1000, or one of the following presets: thin ultralight light semilight book normal medium semibold bold ultrabold heavy ultraheavy
Colors:

You have 3 options:

rgba(), e.g. rgba(b3ff1aee), or the decimal equivalent rgba(179,255,26,0.933)

(decimal rgba/rgb values should have no spaces between numbers)

rgb(), e.g. rgb(b3ff1a), or the decimal equivalent rgb(179,255,26)

legacy, e.g. 0xeeb3ff1a -> ARGB order

Mod list:

SHIFT CAPS CTRL/CONTROL ALT MOD2 MOD3 SUPER/WIN/LOGO/MOD4 MOD5

Sections 
General 
name	description	type	default
border_size	size of the border around windows	int	1
no_border_on_floating	disable borders for floating windows	bool	false
gaps_in	gaps between windows, also supports css style gaps (top, right, bottom, left -> 5,10,15,20)	int	5
gaps_out	gaps between windows and monitor edges, also supports css style gaps (top, right, bottom, left -> 5,10,15,20)	int	20
float_gaps	gaps between windows and monitor edges for floating windows, also supports css style gaps (top, right, bottom, left -> 5 10 15 20). -1 means default	int	0
gaps_workspaces	gaps between workspaces. Stacks with gaps_out.	int	0
col.inactive_border	border color for inactive windows	gradient	0xff444444
col.active_border	border color for the active window	gradient	0xffffffff
col.nogroup_border	inactive border color for window that cannot be added to a group (see denywindowfromgroup dispatcher)	gradient	0xffffaaff
col.nogroup_border_active	active border color for window that cannot be added to a group	gradient	0xffff00ff
layout	which layout to use. [dwindle/master]	str	dwindle
no_focus_fallback	if true, will not fall back to the next available window when moving focus in a direction where no window was found	bool	false
resize_on_border	enables resizing windows by clicking and dragging on borders and gaps	bool	false
extend_border_grab_area	extends the area around the border where you can click and drag on, only used when general:resize_on_border is on.	int	15
hover_icon_on_border	show a cursor icon when hovering over borders, only used when general:resize_on_border is on.	bool	true
allow_tearing	master switch for allowing tearing to occur. See the Tearing page.	bool	false
resize_corner	force floating windows to use a specific corner when being resized (1-4 going clockwise from top left, 0 to disable)	int	0
Snap 
Subcategory general:snap:

name	description	type	default
enabled	enable snapping for floating windows	bool	false
window_gap	minimum gap in pixels between windows before snapping	int	10
monitor_gap	minimum gap in pixels between window and monitor edges before snapping	int	10
border_overlap	if true, windows snap such that only one border’s worth of space is between them	bool	false
respect_gaps	if true, snapping will respect gaps between windows(set in general:gaps_in)	bool	false
A subcategory is a nested category:

general {
    # ...
    # ...

    snap {
        # ...
        # ...
    }
}

Doing general:snap { is invalid!

Decoration 
name	description	type	default
rounding	rounded corners’ radius (in layout px)	int	0
rounding_power	adjusts the curve used for rounding corners, larger is smoother, 2.0 is a circle, 4.0 is a squircle, 1.0 is a triangular corner. [1.0 - 10.0]	float	2.0
active_opacity	opacity of active windows. [0.0 - 1.0]	float	1.0
inactive_opacity	opacity of inactive windows. [0.0 - 1.0]	float	1.0
fullscreen_opacity	opacity of fullscreen windows. [0.0 - 1.0]	float	1.0
dim_modal	enables dimming of parents of modal windows	bool	true
dim_inactive	enables dimming of inactive windows	bool	false
dim_strength	how much inactive windows should be dimmed [0.0 - 1.0]	float	0.5
dim_special	how much to dim the rest of the screen by when a special workspace is open. [0.0 - 1.0]	float	0.2
dim_around	how much the dimaround window rule should dim by. [0.0 - 1.0]	float	0.4
screen_shader	a path to a custom shader to be applied at the end of rendering. See examples/screenShader.frag for an example.	str	[[Empty]]
border_part_of_window	whether the window border should be a part of the window	bool	true
Blur 
Subcategory decoration:blur:

name	description	type	default
enabled	enable kawase window background blur	bool	true
size	blur size (distance)	int	8
passes	the amount of passes to perform	int	1
ignore_opacity	make the blur layer ignore the opacity of the window	bool	true
new_optimizations	whether to enable further optimizations to the blur. Recommended to leave on, as it will massively improve performance.	bool	true
xray	if enabled, floating windows will ignore tiled windows in their blur. Only available if new_optimizations is true. Will reduce overhead on floating blur significantly.	bool	false
noise	how much noise to apply. [0.0 - 1.0]	float	0.0117
contrast	contrast modulation for blur. [0.0 - 2.0]	float	0.8916
brightness	brightness modulation for blur. [0.0 - 2.0]	float	0.8172
vibrancy	Increase saturation of blurred colors. [0.0 - 1.0]	float	0.1696
vibrancy_darkness	How strong the effect of vibrancy is on dark areas . [0.0 - 1.0]	float	0.0
special	whether to blur behind the special workspace (note: expensive)	bool	false
popups	whether to blur popups (e.g. right-click menus)	bool	false
popups_ignorealpha	works like ignorealpha in layer rules. If pixel opacity is below set value, will not blur. [0.0 - 1.0]	float	0.2
input_methods	whether to blur input methods (e.g. fcitx5)	bool	false
input_methods_ignorealpha	works like ignorealpha in layer rules. If pixel opacity is below set value, will not blur. [0.0 - 1.0]	float	0.2
blur:size and blur:passes have to be at least 1.

Increasing blur:passes is necessary to prevent blur looking wrong on higher blur:size values, but remember that higher blur:passes will require more strain on the GPU.

Shadow 
Subcategory decoration:shadow:

name	description	type	default
enabled	enable drop shadows on windows	bool	true
range	Shadow range (“size”) in layout px	int	4
render_power	in what power to render the falloff (more power, the faster the falloff) [1 - 4]	int	3
sharp	if enabled, will make the shadows sharp, akin to an infinite render power	bool	false
ignore_window	if true, the shadow will not be rendered behind the window itself, only around it.	bool	true
color	shadow’s color. Alpha dictates shadow’s opacity.	color	0xee1a1a1a
color_inactive	inactive shadow color. (if not set, will fall back to color)	color	unset
offset	shadow’s rendering offset.	vec2	[0, 0]
scale	shadow’s scale. [0.0 - 1.0]	float	1.0
Animations 
name	description	type	default
enabled	enable animations	bool	true
workspace_wraparound	enable workspace wraparound, causing directional workspace animations to animate as if the first and last workspaces were adjacent	bool	false
More about Animations.
Input 
name	description	type	default
kb_model	Appropriate XKB keymap parameter. See the note below.	str	[[Empty]]
kb_layout	Appropriate XKB keymap parameter	str	us
kb_variant	Appropriate XKB keymap parameter	str	[[Empty]]
kb_options	Appropriate XKB keymap parameter	str	[[Empty]]
kb_rules	Appropriate XKB keymap parameter	str	[[Empty]]
kb_file	If you prefer, you can use a path to your custom .xkb file.	str	[[Empty]]
numlock_by_default	Engage numlock by default.	bool	false
resolve_binds_by_sym	Determines how keybinds act when multiple layouts are used. If false, keybinds will always act as if the first specified layout is active. If true, keybinds specified by symbols are activated when you type the respective symbol with the current layout.	bool	false
repeat_rate	The repeat rate for held-down keys, in repeats per second.	int	25
repeat_delay	Delay before a held-down key is repeated, in milliseconds.	int	600
sensitivity	Sets the mouse input sensitivity. Value is clamped to the range -1.0 to 1.0. libinput#pointer-acceleration	float	0.0
accel_profile	Sets the cursor acceleration profile. Can be one of adaptive, flat. Can also be custom, see below. Leave empty to use libinput’s default mode for your input device. libinput#pointer-acceleration [adaptive/flat/custom]	str	[[Empty]]
force_no_accel	Force no cursor acceleration. This bypasses most of your pointer settings to get as raw of a signal as possible. Enabling this is not recommended due to potential cursor desynchronization.	bool	false
left_handed	Switches RMB and LMB	bool	false
scroll_points	Sets the scroll acceleration profile, when accel_profile is set to custom. Has to be in the form <step> <points>. Leave empty to have a flat scroll curve.	str	[[Empty]]
scroll_method	Sets the scroll method. Can be one of 2fg (2 fingers), edge, on_button_down, no_scroll. libinput#scrolling [2fg/edge/on_button_down/no_scroll]	str	[[Empty]]
scroll_button	Sets the scroll button. Has to be an int, cannot be a string. Check wev if you have any doubts regarding the ID. 0 means default.	int	0
scroll_button_lock	If the scroll button lock is enabled, the button does not need to be held down. Pressing and releasing the button toggles the button lock, which logically holds the button down or releases it. While the button is logically held down, motion events are converted to scroll events.	bool	false
scroll_factor	Multiplier added to scroll movement for external mice. Note that there is a separate setting for touchpad scroll_factor.	float	1.0
natural_scroll	Inverts scrolling direction. When enabled, scrolling moves content directly, rather than manipulating a scrollbar.	bool	false
follow_mouse	Specify if and how cursor movement should affect window focus. See the note below. [0/1/2/3]	int	1
follow_mouse_threshold	The smallest distance in logical pixels the mouse needs to travel for the window under it to get focused. Works only with follow_mouse = 1.	float	0.0
focus_on_close	Controls the window focus behavior when a window is closed. When set to 0, focus will shift to the next window candidate. When set to 1, focus will shift to the window under the cursor. [0/1]	int	0
mouse_refocus	If disabled, mouse focus won’t switch to the hovered window unless the mouse crosses a window boundary when follow_mouse=1.	bool	true
float_switch_override_focus	If enabled (1 or 2), focus will change to the window under the cursor when changing from tiled-to-floating and vice versa. If 2, focus will also follow mouse on float-to-float switches.	int	1
special_fallthrough	if enabled, having only floating windows in the special workspace will not block focusing windows in the regular workspace.	bool	false
off_window_axis_events	Handles axis events around (gaps/border for tiled, dragarea/border for floated) a focused window. 0 ignores axis events 1 sends out-of-bound coordinates 2 fakes pointer coordinates to the closest point inside the window 3 warps the cursor to the closest point inside the window	int	1
emulate_discrete_scroll	Emulates discrete scrolling from high resolution scrolling events. 0 disables it, 1 enables handling of non-standard events only, and 2 force enables all scroll wheel events to be handled	int	1
XKB Settings 
You can find a list of models, layouts, variants and options in /usr/share/X11/xkb/rules/base.lst. Alternatively, you can use the localectl command to discover what is available on your system.

For switchable keyboard configurations, take a look at the uncommon tips & tricks page entry.

Follow Mouse Cursor 
0 - Cursor movement will not change focus.
1 - Cursor movement will always change focus to the window under the cursor.
2 - Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
3 - Cursor focus will be completely separate from keyboard focus. Clicking on a window will not change keyboard focus.
Custom accel profiles 
accel_profile 
custom <step> <points...>

Example: custom 200 0.0 0.5

scroll_points 
NOTE: Only works when accel_profile is set to custom.

<step> <points...>

Example: 0.2 0.0 0.5 1 1.2 1.5

To mimic the Windows acceleration curves, take a look at this script.

See the libinput doc for more insights on how it works.

Touchpad 
Subcategory input:touchpad:

name	description	type	default
disable_while_typing	Disable the touchpad while typing.	bool	true
natural_scroll	Inverts scrolling direction. When enabled, scrolling moves content directly, rather than manipulating a scrollbar.	bool	false
scroll_factor	Multiplier applied to the amount of scroll movement.	float	1.0
middle_button_emulation	Sending LMB and RMB simultaneously will be interpreted as a middle click. This disables any touchpad area that would normally send a middle click based on location. libinput#middle-button-emulation	bool	false
tap_button_map	Sets the tap button mapping for touchpad button emulation. Can be one of lrm (default) or lmr (Left, Middle, Right Buttons). [lrm/lmr]	str	[[Empty]]
clickfinger_behavior	Button presses with 1, 2, or 3 fingers will be mapped to LMB, RMB, and MMB respectively. This disables interpretation of clicks based on location on the touchpad. libinput#clickfinger-behavior	bool	false
tap-to-click	Tapping on the touchpad with 1, 2, or 3 fingers will send LMB, RMB, and MMB respectively.	bool	true
drag_lock	When enabled, lifting the finger off while dragging will not drop the dragged item. 0 -> disabled, 1 -> enabled with timeout, 2 -> enabled sticky. libinput#tap-and-drag	int	0
tap-and-drag	Sets the tap and drag mode for the touchpad	bool	true
flip_x	inverts the horizontal movement of the touchpad	bool	false
flip_y	inverts the vertical movement of the touchpad	bool	false
drag_3fg	enables three finger drag, 0 -> disabled, 1 -> 3 fingers, 2 -> 4 fingers libinput#drag-3fg	int	0
Touchdevice 
Subcategory input:touchdevice:

name	description	type	default
transform	Transform the input from touchdevices. The possible transformations are the same as those of the monitors. -1 means it’s unset.	int	-1
output	The monitor to bind touch devices. The default is auto-detection. To stop auto-detection, use an empty string or the “[[Empty]]” value.	string	[[Auto]]
enabled	Whether input is enabled for touch devices.	bool	true
Virtualkeyboard 
Subcategory input:virtualkeyboard:

name	description	type	default
share_states	Unify key down states and modifier states with other keyboards. 0 -> no, 1 -> yes, 2 -> yes unless IME client	int	2
release_pressed_on_close	Release all pressed keys by virtual keyboard on close.	bool	false
Tablet 
Subcategory input:tablet:

name	description	type	default
transform	transform the input from tablets. The possible transformations are the same as those of the monitors. -1 means it’s unset.	int	-1
output	the monitor to bind tablets. Can be current or a monitor name. Leave empty to map across all monitors.	string	[[Empty]]
region_position	position of the mapped region in monitor layout relative to the top left corner of the bound monitor or all monitors.	vec2	[0, 0]
absolute_region_position	whether to treat the region_position as an absolute position in monitor layout. Only applies when output is empty.	bool	false
region_size	size of the mapped region. When this variable is set, tablet input will be mapped to the region. [0, 0] or invalid size means unset.	vec2	[0, 0]
relative_input	whether the input should be relative	bool	false
left_handed	if enabled, the tablet will be rotated 180 degrees	bool	false
active_area_size	size of tablet’s active area in mm	vec2	[0, 0]
active_area_position	position of the active area in mm	vec2	[0, 0]
Per-device input config 
Described here.

Gestures 
Subcategory gestures:

name	description	type	default
workspace_swipe_distance	in px, the distance of the touchpad gesture	int	300
workspace_swipe_touch	enable workspace swiping from the edge of a touchscreen	bool	false
workspace_swipe_invert	invert the direction (touchpad only)	bool	true
workspace_swipe_touch_invert	invert the direction (touchscreen only)	bool	false
workspace_swipe_min_speed_to_force	minimum speed in px per timepoint to force the change ignoring cancel_ratio. Setting to 0 will disable this mechanic.	int	30
workspace_swipe_cancel_ratio	how much the swipe has to proceed in order to commence it. (0.7 -> if > 0.7 * distance, switch, if less, revert) [0.0 - 1.0]	float	0.5
workspace_swipe_create_new	whether a swipe right on the last workspace should create a new one.	bool	true
workspace_swipe_direction_lock	if enabled, switching direction will be locked when you swipe past the direction_lock_threshold (touchpad only).	bool	true
workspace_swipe_direction_lock_threshold	in px, the distance to swipe before direction lock activates (touchpad only).	int	10
workspace_swipe_forever	if enabled, swiping will not clamp at the neighboring workspaces but continue to the further ones.	bool	false
workspace_swipe_use_r	if enabled, swiping will use the r prefix instead of the m prefix for finding workspaces.	bool	false
close_max_timeout	the timeout for a window to close when using a 1:1 gesture, in ms	int	1000
workspace_swipe, workspace_swipe_fingers and workspace_swipe_min_fingers were removed in favor of the new gestures system.

You can add this gesture config to replicate the swiping functionality with 3 fingers. See the gestures page for more info.

gesture = 3, horizontal, workspace

Group 
Subcategory group:

name	description	type	default
auto_group	whether new windows will be automatically grouped into the focused unlocked group. Note: if you want to disable auto_group only for specific windows, use the “group barred” window rule instead.	bool	true
insert_after_current	whether new windows in a group spawn after current or at group tail	bool	true
focus_removed_window	whether Hyprland should focus on the window that has just been moved out of the group	bool	true
drag_into_group	whether dragging a window into a unlocked group will merge them. Options: 0 (disabled), 1 (enabled), 2 (only when dragging into the groupbar)	int	1
merge_groups_on_drag	whether window groups can be dragged into other groups	bool	true
merge_groups_on_groupbar	whether one group will be merged with another when dragged into its groupbar	bool	true
merge_floated_into_tiled_on_groupbar	whether dragging a floating window into a tiled window groupbar will merge them	bool	false
group_on_movetoworkspace	whether using movetoworkspace[silent] will merge the window into the workspace’s solitary unlocked group	bool	false
col.border_active	active group border color	gradient	0x66ffff00
col.border_inactive	inactive (out of focus) group border color	gradient	0x66777700
col.border_locked_active	active locked group border color	gradient	0x66ff5500
col.border_locked_inactive	inactive locked group border color	gradient	0x66775500
Groupbar 
Subcategory group:groupbar:

name	description	type	default
enabled	enables groupbars	bool	true
font_family	font used to display groupbar titles, use misc:font_family if not specified	string	[[Empty]]
font_size	font size of groupbar title	int	8
font_weight_active	font weight of active groupbar title	font_weight	normal
font_weight_inactive	font weight of inactive groupbar title	font_weight	normal
gradients	enables gradients	bool	false
height	height of the groupbar	int	14
indicator_gap	height of gap between groupbar indicator and title	int	0
indicator_height	height of the groupbar indicator	int	3
stacked	render the groupbar as a vertical stack	bool	false
priority	sets the decoration priority for groupbars	int	3
render_titles	whether to render titles in the group bar decoration	bool	true
text_offset	adjust vertical position for titles	int	0
scrolling	whether scrolling in the groupbar changes group active window	bool	true
rounding	how much to round the indicator	int	1
rounding_power	adjusts the curve used for rounding broupbar corners, larger is smoother, 2.0 is a circle, 4.0 is a squircle, 1.0 is a triangular corner. [1.0 - 10.0]	float	2.0
gradient_rounding	how much to round the gradients	int	2
gradient_rounding_power	adjusts the curve used for rounding gradient corners, larger is smoother, 2.0 is a circle, 4.0 is a squircle, 1.0 is a triangular corner. [1.0 - 10.0]	float	2.0
round_only_edges	round only the indicator edges of the entire groupbar	bool	true
gradient_round_only_edges	round only the gradient edges of the entire groupbar	bool	true
text_color	color for window titles in the groupbar	color	0xffffffff
text_color_inactive	color for inactive windows’ titles in the groupbar (if unset, defaults to text_color)	color	unset
text_color_locked_active	color for the active window’s title in a locked group (if unset, defaults to text_color)	color	unset
text_color_locked_inactive	color for inactive windows’ titles in locked groups (if unset, defaults to text_color_inactive)	color	unset
col.active	active group bar background color	gradient	0x66ffff00
col.inactive	inactive (out of focus) group bar background color	gradient	0x66777700
col.locked_active	active locked group bar background color	gradient	0x66ff5500
col.locked_inactive	inactive locked group bar background color	gradient	0x66775500
gaps_in	gap size between gradients	int	2
gaps_out	gap size between gradients and window	int	2
keep_upper_gap	add or remove upper gap	bool	true
Misc 
Subcategory misc:

name	description	type	default
disable_hyprland_logo	disables the random Hyprland logo / anime girl background. :(	bool	false
disable_splash_rendering	disables the Hyprland splash rendering. (requires a monitor reload to take effect)	bool	false
disable_scale_notification	disables notification popup when a monitor fails to set a suitable scale	bool	false
col.splash	Changes the color of the splash text (requires a monitor reload to take effect).	color	0xffffffff
font_family	Set the global default font to render the text including debug fps/notification, config error messages and etc., selected from system fonts.	string	Sans
splash_font_family	Changes the font used to render the splash text, selected from system fonts (requires a monitor reload to take effect).	string	[[Empty]]
force_default_wallpaper	Enforce any of the 3 default wallpapers. Setting this to 0 or 1 disables the anime background. -1 means “random”. [-1/0/1/2]	int	-1
vfr	controls the VFR status of Hyprland. Heavily recommended to leave enabled to conserve resources.	bool	true
vrr	controls the VRR (Adaptive Sync) of your monitors. 0 - off, 1 - on, 2 - fullscreen only, 3 - fullscreen with video or game content type [0/1/2/3]	int	0
mouse_move_enables_dpms	If DPMS is set to off, wake up the monitors if the mouse moves.	bool	false
key_press_enables_dpms	If DPMS is set to off, wake up the monitors if a key is pressed.	bool	false
name_vk_after_proc	Name virtual keyboards after the processes that create them. E.g. /usr/bin/fcitx5 will have hl-virtual-keyboard-fcitx5.	bool	true
always_follow_on_dnd	Will make mouse focus follow the mouse when drag and dropping. Recommended to leave it enabled, especially for people using focus follows mouse at 0.	bool	true
layers_hog_keyboard_focus	If true, will make keyboard-interactive layers keep their focus on mouse move (e.g. wofi, bemenu)	bool	true
animate_manual_resizes	If true, will animate manual window resizes/moves	bool	false
animate_mouse_windowdragging	If true, will animate windows being dragged by mouse, note that this can cause weird behavior on some curves	bool	false
disable_autoreload	If true, the config will not reload automatically on save, and instead needs to be reloaded with hyprctl reload. Might save on battery.	bool	false
enable_swallow	Enable window swallowing	bool	false
swallow_regex	The class regex to be used for windows that should be swallowed (usually, a terminal). To know more about the list of regex which can be used use this cheatsheet.	str	[[Empty]]
swallow_exception_regex	The title regex to be used for windows that should not be swallowed by the windows specified in swallow_regex (e.g. wev). The regex is matched against the parent (e.g. Kitty) window’s title on the assumption that it changes to whatever process it’s running.	str	[[Empty]]
focus_on_activate	Whether Hyprland should focus an app that requests to be focused (an activate request)	bool	false
mouse_move_focuses_monitor	Whether mouse moving into a different monitor should focus it	bool	true
allow_session_lock_restore	if true, will allow you to restart a lockscreen app in case it crashes	bool	false
session_lock_xray	if true, keep rendering workspaces below your lockscreen	bool	false
background_color	change the background color. (requires enabled disable_hyprland_logo)	color	0x111111
close_special_on_empty	close the special workspace if the last window is removed	bool	true
new_window_takes_over_fullscreen	if there is a fullscreen or maximized window, decide whether a new tiled window opened should replace it, stay behind or disable the fullscreen/maximized state. 0 - behind, 1 - takes over, 2 - unfullscreen/unmaxize [0/1/2]	int	0
exit_window_retains_fullscreen	if true, closing a fullscreen window makes the next focused window fullscreen	bool	false
initial_workspace_tracking	if enabled, windows will open on the workspace they were invoked on. 0 - disabled, 1 - single-shot, 2 - persistent (all children too)	int	1
middle_click_paste	whether to enable middle-click-paste (aka primary selection)	bool	true
render_unfocused_fps	the maximum limit for renderunfocused windows’ fps in the background (see also Window-Rules - renderunfocused)	int	15
disable_xdg_env_checks	disable the warning if XDG environment is externally managed	bool	false
disable_hyprland_qtutils_check	disable the warning if hyprland-qtutils is not installed	bool	false
lockdead_screen_delay	delay after which the “lockdead” screen will appear in case a lockscreen app fails to cover all the outputs (5 seconds max)	int	1000
enable_anr_dialog	whether to enable the ANR (app not responding) dialog when your apps hang	bool	true
anr_missed_pings	number of missed pings before showing the ANR dialog	int	5
Binds 
Subcategory binds:

name	description	type	default
pass_mouse_when_bound	if disabled, will not pass the mouse events to apps / dragging windows around if a keybind has been triggered.	bool	false
scroll_event_delay	in ms, how many ms to wait after a scroll event to allow passing another one for the binds.	int	300
workspace_back_and_forth	If enabled, an attempt to switch to the currently focused workspace will instead switch to the previous workspace. Akin to i3’s auto_back_and_forth.	bool	false
hide_special_on_workspace_change	If enabled, changing the active workspace (including to itself) will hide the special workspace on the monitor where the newly active workspace resides.	bool	false
allow_workspace_cycles	If enabled, workspaces don’t forget their previous workspace, so cycles can be created by switching to the first workspace in a sequence, then endlessly going to the previous workspace.	bool	false
workspace_center_on	Whether switching workspaces should center the cursor on the workspace (0) or on the last active window for that workspace (1)	int	0
focus_preferred_method	sets the preferred focus finding method when using focuswindow/movewindow/etc with a direction. 0 - history (recent have priority), 1 - length (longer shared edges have priority)	int	0
ignore_group_lock	If enabled, dispatchers like moveintogroup, moveoutofgroup and movewindoworgroup will ignore lock per group.	bool	false
movefocus_cycles_fullscreen	If enabled, when on a fullscreen window, movefocus will cycle fullscreen, if not, it will move the focus in a direction.	bool	false
movefocus_cycles_groupfirst	If enabled, when in a grouped window, movefocus will cycle windows in the groups first, then at each ends of tabs, it’ll move on to other windows/groups	bool	false
disable_keybind_grabbing	If enabled, apps that request keybinds to be disabled (e.g. VMs) will not be able to do so.	bool	false
window_direction_monitor_fallback	If enabled, moving a window or focus over the edge of a monitor with a direction will move it to the next monitor in that direction.	bool	true
allow_pin_fullscreen	If enabled, Allow fullscreen to pinned windows, and restore their pinned status afterwards	bool	false
drag_threshold	Movement threshold in pixels for window dragging and c/g bind flags. 0 to disable and grab on mousedown.	int	0
XWayland 
Subcategory xwayland:

name	description	type	default
enabled	allow running applications using X11	bool	true
use_nearest_neighbor	uses the nearest neighbor filtering for xwayland apps, making them pixelated rather than blurry	bool	true
force_zero_scaling	forces a scale of 1 on xwayland windows on scaled displays.	bool	false
create_abstract_socket	Create the abstract Unix domain socket for XWayland connections. (XWayland restart is required for changes to take effect; Linux only)	bool	false
OpenGL 
Subcategory opengl:

name	description	type	default
nvidia_anti_flicker	reduces flickering on nvidia at the cost of possible frame drops on lower-end GPUs. On non-nvidia, this is ignored.	bool	true
Render 
Subcategory render:

name	description	type	default
direct_scanout	Enables direct scanout. Direct scanout attempts to reduce lag when there is only one fullscreen application on a screen (e.g. game). It is also recommended to set this to false if the fullscreen application shows graphical glitches. 0 - off, 1 - on, 2 - auto (on with content type ‘game’)	int	0
expand_undersized_textures	Whether to expand undersized textures along the edge, or rather stretch the entire texture.	bool	true
xp_mode	Disables back buffer and bottom layer rendering.	bool	false
ctm_animation	Whether to enable a fade animation for CTM changes (hyprsunset). 2 means “auto” which disables them on Nvidia.	int	2
cm_fs_passthrough	Passthrough color settings for fullscreen apps when possible. 0 - off, 1 - always, 2 - hdr only	int	2
cm_enabled	Whether the color management pipeline should be enabled or not (requires a restart of Hyprland to fully take effect)	bool	true
send_content_type	Report content type to allow monitor profile autoswitch (may result in a black screen during the switch)	bool	true
cm_auto_hdr	Auto-switch to HDR in fullscreen when needed. 0 - off, 1 - switch to cm, hdr, 2 - switch to cm, hdredid	int	1
new_render_scheduling	Automatically uses triple buffering when needed, improves FPS on underpowered devices.	bool	false
non_shader_cm	Enable CM without shader. 0 - disable, 1 - whenever possible, 2 - DS and passthrough only, 3 - don’t block DS when non-shader CM isn’t available	int	2
cm_auto_hdr requires --target-colorspace-hint-mode=source mpv option to work with mpv versions greater than v0.40.0

Cursor 
Subcategory cursor:

name	description	type	default
invisible	don’t render cursors	bool	false
sync_gsettings_theme	sync xcursor theme with gsettings, it applies cursor-theme and cursor-size on theme load to gsettings making most CSD gtk based clients use same xcursor theme and size.	bool	true
no_hardware_cursors	disables hardware cursors. 0 - use hw cursors if possible, 1 - don’t use hw cursors, 2 - auto (disable when tearing)	int	2
no_break_fs_vrr	disables scheduling new frames on cursor movement for fullscreen apps with VRR enabled to avoid framerate spikes (may require no_hardware_cursors = true) 0 - off, 1 - on, 2 - auto (on with content type ‘game’)	int	2
min_refresh_rate	minimum refresh rate for cursor movement when no_break_fs_vrr is active. Set to minimum supported refresh rate or higher	int	24
hotspot_padding	the padding, in logical px, between screen edges and the cursor	int	1
inactive_timeout	in seconds, after how many seconds of cursor’s inactivity to hide it. Set to 0 for never.	float	0
no_warps	if true, will not warp the cursor in many cases (focusing, keybinds, etc)	bool	false
persistent_warps	When a window is refocused, the cursor returns to its last position relative to that window, rather than to the centre.	bool	false
warp_on_change_workspace	Move the cursor to the last focused window after changing the workspace. Options: 0 (Disabled), 1 (Enabled), 2 (Force - ignores cursor:no_warps option)	int	0
warp_on_toggle_special	Move the cursor to the last focused window when toggling a special workspace. Options: 0 (Disabled), 1 (Enabled), 2 (Force - ignores cursor:no_warps option)	int	0
default_monitor	the name of a default monitor for the cursor to be set to on startup (see hyprctl monitors for names)	str	[[EMPTY]]
zoom_factor	the factor to zoom by around the cursor. Like a magnifying glass. Minimum 1.0 (meaning no zoom)	float	1.0
zoom_rigid	whether the zoom should follow the cursor rigidly (cursor is always centered if it can be) or loosely	bool	false
enable_hyprcursor	whether to enable hyprcursor support	bool	true
hide_on_key_press	Hides the cursor when you press any key until the mouse is moved.	bool	false
hide_on_touch	Hides the cursor when the last input was a touch input until a mouse input is done.	bool	true
use_cpu_buffer	Makes HW cursors use a CPU buffer. Required on Nvidia to have HW cursors. 0 - off, 1 - on, 2 - auto (nvidia only)	int	2
warp_back_after_non_mouse_input	Warp the cursor back to where it was after using a non-mouse input to move it, and then returning back to mouse.	bool	false
Ecosystem 
Subcategory ecosystem:

name	description	type	default
no_update_news	disable the popup that shows up when you update hyprland to a new version.	bool	false
no_donation_nag	disable the popup that shows up twice a year encouraging to donate.	bool	false
enforce_permissions	whether to enable permission control.	bool	false
Experimental 
Subcategory experimental:

name	description	type	default
xx_color_management_v4	enable color management protocol	bool	false
Since The release of Mesa 25.1.1 settings below are no longer required, so just skip.

Requires a client with frog-color-management-v1 or xx-color-management-v4 support like gamescope or https://github.com/Zamundaaa/VK_hdr_layer

Steam:

DXVK_HDR=1 gamescope -f --hdr-enabled -- %command%

ENABLE_HDR_WSI=1 DXVK_HDR=1 DISPLAY= %command% (requires wayland-enabled proton version)

Non-steam:

ENABLE_HDR_WSI=1 DXVK_HDR=1 DISPLAY= wine executable.exe

Video:

ENABLE_HDR_WSI=1 mpv --vo=gpu-next --target-colorspace-hint --gpu-api=vulkan --gpu-context=waylandvk "filename"

Debug 
Subcategory debug:

Only for developers.
name	description	type	default
overlay	print the debug performance overlay. Disable VFR for accurate results.	bool	false
damage_blink	(epilepsy warning!) flash areas updated with damage tracking	bool	false
disable_logs	disable logging to a file	bool	true
disable_time	disables time logging	bool	true
damage_tracking	redraw only the needed bits of the display. Do not change. (default: full - 2) monitor - 1, none - 0	int	2
enable_stdout_logs	enables logging to stdout	bool	false
manual_crash	set to 1 and then back to 0 to crash Hyprland.	int	0
suppress_errors	if true, do not display config file parsing errors.	bool	false
watchdog_timeout	sets the timeout in seconds for watchdog to abort processing of a signal of the main thread. Set to 0 to disable.	int	5
disable_scale_checks	disables verification of the scale factors. Will result in pixel alignment and rounding errors.	bool	false
error_limit	limits the number of displayed config file parsing errors.	int	5
error_position	sets the position of the error bar. top - 0, bottom - 1	int	0
colored_stdout_logs	enables colors in the stdout logs.	bool	true
pass	enables render pass debugging.	bool	false
full_cm_proto	claims support for all cm proto features (requires restart)	bool	false
More 
There are more config options described in other pages, which are layout- or circumstance-specific. See the sidebar for more pages.

Last updated on October 4, 2025
Start
Keywords
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Executing
Sourcing (multi-file)
Gestures
Per-device input configs
Wallpapers
Blurring layerSurfaces
Setting the environment
Edit this page on GitHub →
Scroll to top 
Configuring
Keywords
Keywords
Keywords are not variables, but “commands” for more advanced configuring. On this page, you will be presented with some that do not deserve their own page.

See the sidebar for more keywords to control binds, animations, monitors, et cetera.

Please remember, that for ALL arguments separated by a comma, if you want to leave one of them empty, you cannot reduce the number of commas, unless told otherwise in a specific section:

three_param_keyword = A, B, C # OK
three_param_keyword = A, C    # NOT OK
three_param_keyword = A, , C  # OK
three_param_keyword = A, B,   # OK

Executing 
You can execute a shell script on:

startup of the compositor
every time the config is reloaded.
shutdown of the compositor
exec-once = command will execute only on launch (support rules)

execr-once = command will execute only on launch

exec = command will execute on each reload (support rules)

execr = command will execute on each reload

exec-shutdown = command will execute only on shutdown

Sourcing (multi-file) 
Use the source keyword to source another file. Globbing is supported

For example, in your hyprland.conf you can:

source = ~/.config/hypr/myColors.conf
source = ~/.config/hypr/custom/*

And Hyprland will enter that file and parse it like a Hyprland config.

Please note it’s LINEAR. Meaning lines above the source = will be parsed first, then lines inside ~/.config/hypr/myColors.conf, then lines below.

Gestures 
Use libinput-gestures with hyprctl if you want to expand Hyprland’s gestures beyond what’s offered in Variables.

Per-device input configs 
Per-device config options will overwrite your options set in the input section. It’s worth noting that ONLY values explicitly changed will be overwritten.

In order to apply per-device config options, add a new category like this:

device {
    name = ...
    # options ...
}

The name can be easily obtained by checking the output of hyprctl devices.

Inside of it, put your config options. All options from the input category (and all subcategories, e.g. input:touchpad) can be put inside, EXCEPT:

force_no_accel
follow_mouse
float_switch_override_focus
Properties that change names:

touchdevice:transform -> transform
touchdevice:output -> output

You can also use the output setting for tablets to bind them to outputs. Remember to use the name of the Tablet and not Tablet Pad or Tablet tool.

Additional properties only present in per-device configs:

enabled -> (only for mice / touchpads / touchdevices / keyboards)
enables / disables the device (connects / disconnects from the on-screen cursor)
default: Enabled
keybinds -> (only for devices that send key events)
enables / disables keybinds for the device
default: Enabled
Example config section:

device {
    name = royuan-akko-multi-modes-keyboard-b
    repeat_rate = 50
    repeat_delay = 500
    middle_button_emulation = 0
}

Example modifying per-device config values using hyprctl:

hyprctl -r -- keyword device[my-device]:sensitivity -1

Per-device layouts will by default not alter the keybind keymap, so for example with a global keymap of us and a per-device one of fr, the keybinds will still act as if you were on us.

You can change this behavior by setting resolve_binds_by_sym = 1. In that case you’ll need to type the symbol specified in the bind to activate it.

Wallpapers 
The “Hyprland” background you see when you first start Hyprland is NOT A WALLPAPER, it’s the default image rendered at the bottom of the render stack.

To set a wallpaper, use a wallpaper utility like hyprpaper or swaybg.

More can be found in Useful Utilities.

Blurring layerSurfaces 
Layer surfaces are not windows. These are, for example: wallpapers, notification overlays, bars, etc.

If you want to blur them, use a layer rule:

layerrule = match:namespace NAMESPACE, blur on
# or
layerrule = match:address address:0x<ADDRESS>, blur on

You can get the namespace / address from hyprctl layers.

To remove a layer rule (useful in dynamic situations) use:

layerrule = match:namespace <whatever you used before>, unset

For example:

layerrule = match:namespace NAMESPACE, unset

Setting the environment 
A new environment cannot be passed to already running processes. If you change / add / remove an env = entry when Hyprland is running, only newly spawned apps will pick up the changes.
You can use the env keyword to set environment variables, e.g:

env = XCURSOR_SIZE,24

You can also add a d flag if you want the env var to be exported to D-Bus (systemd only):

envd = XCURSOR_SIZE,24

Hyprland puts the raw string to the env var. You should not add quotes around the values.

e.g.:

env = QT_QPA_PLATFORM,wayland

and NOT

env = QT_QPA_PLATFORM,"wayland"

Last updated on October 4, 2025
Variables
Monitors
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

General
Custom modelines
Disabling a monitor
Custom reserved area
Extra args
Mirrored displays
10 bit support
Color management presets
VRR
Rotating
Monitor v2
Default workspace
Binding workspaces to a monitor
Edit this page on GitHub →
Scroll to top 
Configuring
Monitors
Monitors
General 
The general config of a monitor looks like this:

monitor = name, resolution, position, scale

A common example:

monitor = DP-1, 1920x1080@144, 0x0, 1

This will make the monitor on DP-1 a 1920x1080 display, at 144Hz, 0x0 off from the top left corner, with a scale of 1 (unscaled).

To list all available monitors (active and inactive):

hyprctl monitors all

Monitors are positioned on a virtual “layout”. The position is the position, in pixels, of said display in the layout. (calculated from the top-left corner)

For example:

monitor = DP-1, 1920x1080, 0x0, 1
monitor = DP-2, 1920x1080, 1920x0, 1

will tell Hyprland to put DP-1 on the left of DP-2, while

monitor = DP-1, 1920x1080, 1920x0, 1
monitor = DP-2, 1920x1080, 0x0, 1

will tell Hyprland to put DP-1 on the right.

The position may contain negative values, so the above example could also be written as

monitor = DP-1, 1920x1080, 0x0, 1
monitor = DP-2, 1920x1080, -1920x0, 1

Hyprland uses an inverse Y cartesian system. Thus, a negative y coordinate places a monitor higher, and a positive y coordinate will place it lower.

For example:

monitor = DP-1, 1920x1080, 0x0, 1
monitor = DP-2, 1920x1080, 0x-1080, 1

will tell Hyprland to put DP-2 above DP-1, while

monitor = DP-1, 1920x1080, 0x0, 1
monitor = DP-2, 1920x1080, 0x1080, 1

will tell Hyprland to put DP-2 below.

The position is calculated with the scaled (and transformed) resolution, meaning if you want your 4K monitor with scale 2 to the left of your 1080p one, you’d use the position 1920x0 for the second screen (3840 / 2). If the monitor is also rotated 90 degrees (vertical), you’d use 1080x0.
Leaving the name empty will define a fallback rule to use when no other rules match.

There are a few special values for the resolutions:

preferred - use the display’s preferred size and refresh rate.
highres - use the highest supported resolution.
highrr - use the highest supported refresh rate.
maxwidth - use the widest supported resolution.
Position also has a few special values:

auto - let Hyprland decide on a position. By default, it places each new monitor to the right of existing ones, using the monitor’s top left corner as the root point.
auto-right/left/up/down - place the monitor to the right/left, above or below other monitors, also based on each monitor’s top left corner as the root.
auto-center-right/left/up/down - place the monitor to the right/left, above or below other monitors, but calculate placement from each monitor’s center rather than its top left corner.
Please Note: While specifying a monitor direction for your first monitor is allowed, this does nothing and it will be positioned at (0,0). Also, the direction is always from the center out, so you can specify auto-up then auto-left, but the left monitors will just be left of the origin and above the origin. You can also specify duplicate directions and monitors will continue to go in that direction.

You can also use auto as a scale to let Hyprland decide on a scale for you. These depend on the PPI of the monitor.

Recommended rule for quickly plugging in random monitors:

monitor = , preferred, auto, 1

This will make any monitor that was not specified with an explicit rule automatically placed on the right of the other(s), with its preferred resolution.

For more specific rules, you can also use the output’s description (see hyprctl monitors for more details). If the output of hyprctl monitors looks like the following:

Monitor eDP-1 (ID 0):
        1920x1080@60.00100 at 0x0
        description: Chimei Innolux Corporation 0x150C (eDP-1)
        make: Chimei Innolux Corporation
        model: 0x150C
        [...]

then the description value up to, but not including the portname (eDP-1) can be used to specify the monitor:

monitor = desc:Chimei Innolux Corporation 0x150C, preferred, auto, 1.5

Remember to remove the (portname)!

Custom modelines 
You can set up a custom modeline by changing the resolution field to a modeline, for example:

monitor = DP-1, modeline 1071.101 3840 3848 3880 3920 2160 2263 2271 2277 +hsync -vsync, 0x0, 1

Disabling a monitor 
To disable a monitor, use

monitor = name, disable

Disabling a monitor will literally remove it from the layout, moving all windows and workspaces to any remaining ones. If you want to disable your monitor in a screensaver style (just turn off the monitor) use the dpms dispatcher.
Custom reserved area 
A reserved area is an area that remains unoccupied by tiled windows. If your workflow requires a custom reserved area, you can add it with:

monitor = name, addreserved, TOP, BOTTOM, LEFT, RIGHT

Where TOP BOTTOM LEFT RIGHT are integers, i.e the number in pixels of the reserved area to add. This does stack on top of the calculated reserved area (e.g. bars), but you may only use one of these rules per monitor in the config.

Extra args 
You can combine extra arguments at the end of the monitor rule, examples:

monitor = eDP-1, 2880x1800@90, 0x0, 1, transform, 1, mirror, DP-2, bitdepth, 10

See below for more details about each argument.

Mirrored displays 
If you want to mirror a display, add a , mirror, <NAME> at the end of the monitor rule, examples:

monitor = DP-3, 1920x1080@60, 0x0, 1, mirror, DP-2
monitor = , preferred, auto, 1, mirror, DP-1

Please remember that mirroring displays will not “re-render” everything for your second monitor, so if mirroring a 1080p screen onto a 4K one, the resolution will still be 1080p on the 4K display. This also means squishing and stretching will occur on aspect ratios that differ (e.g 16:9 and 16:10).

10 bit support 
If you want to enable 10 bit support for your display, add a , bitdepth, 10 at the end of the monitor rule, e.g:

monitor = eDP-1, 2880x1800@90, 0x0, 1, bitdepth, 10

Colors registered in Hyprland (e.g. the border color) do not support 10 bit.

Some applications do not support screen capture with 10 bit enabled.

Color management presets 
Add a , cm, X to change default sRGB output preset

monitor = eDP-1, 2880x1800@90, 0x0, 1, bitdepth, 10, cm, wide

auto    - srgb for 8bpc, wide for 10bpc if supported (recommended)
srgb    - sRGB primaries (default)
dcip3   - DCI P3 primaries
dp3     - Apple P3 primaries
adobe   - Adobe RGB primaries
wide    - wide color gamut, BT2020 primaries
edid    - primaries from edid (known to be inaccurate)
hdr     - wide color gamut and HDR PQ transfer function (experimental)
hdredid - same as hdr with edid primaries (experimental)

Fullscreen HDR is possible without hdr cm setting if render:cm_fs_passthrough is enabled.

Use sdrbrightness, B and sdrsaturation, S to control SDR brightness and saturation in HDR mode. The default for both values is 1.0. Typical brightness value should be in 1.0 ... 2.0 range.

monitor = eDP-1, 2880x1800@90, 0x0, 1, bitdepth, 10, cm, hdr, sdrbrightness, 1.2, sdrsaturation, 0.98

VRR 
Per-display VRR can be done by adding , vrr, X where X is the mode from the variables page.

Rotating 
If you want to rotate a monitor, add a , transform, X at the end of the monitor rule, where X corresponds to a transform number, e.g.:

monitor = eDP-1, 2880x1800@90, 0x0, 1, transform, 1

Transform list:

0 -> normal (no transforms)
1 -> 90 degrees
2 -> 180 degrees
3 -> 270 degrees
4 -> flipped
5 -> flipped + 90 degrees
6 -> flipped + 180 degrees
7 -> flipped + 270 degrees

Monitor v2 
Alternative syntax. monitor = DP-1,1920x1080@144,0x0,1,transform,2 is the same as

monitorv2 {
  output = DP-1
  mode = 1920x1080@144
  position = 0x0
  scale = 1
  transform = 2
}

Other named settings keep their names: name, value → name = value (e.g. bitdepth,10 → bitdepth = 10)

EDID overrides and SDR → HDR settings:

name	description	type
supports_wide_color	Force wide color gamut support (1 - force on, 0 - does nothing)	bool
supports_hdr	Force HDR support. Requires wide color gamut (1 - force on, 0 - does nothing)	bool
sdr_min_luminance	SDR minimum lumninace used for SDR → HDR mapping. Set to 0.005 for true black matching HDR black	float
sdr_max_luminance	SDR maximum luminance. Can be used to adjust overall SDR → HDR brightness. 80 - 400 is a reasonable range. The desired value is likely between 200 and 250	int
min_luminance	Monitor’s minimum luminance	float
max_luminance	Monitor’s maximum possible luminance	int
max_avg_luminance	Monitor’s maximum luminance on average for a typical frame	int
Note: those values might get passed to the monitor itself and cause increased burn-in or other damage if it’s firmware lacks some safety checks.

Default workspace 
See Workspace Rules.

Binding workspaces to a monitor 
See Workspace Rules.

Last updated on October 4, 2025
Keywords
Binds
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Basic
Uncommon syms / binding with a keycode
Misc
Workspace bindings on non-QWERTY layouts
Unbind
Bind flags
Mouse buttons
Binding modkeys only
Keysym combos
Mouse wheel
Switches
Multiple binds to one key
Description
Mouse Binds
Touchpad
Global Keybinds
Classic
DBus Global Shortcuts
Submaps
Nesting
Catch-All
Example Binds
Media
Edit this page on GitHub →
Scroll to top 
Configuring
Binds
Binds
Basic 
bind = MODS, key, dispatcher, params

for example,

bind = SUPER_SHIFT, Q, exec, firefox

will bind opening Firefox to SUPER + SHIFT + Q

For binding keys without a modkey, leave it empty:

bind = , Print, exec, grim

For a complete mod list, see Variables.

The dispatcher list can be found in Dispatchers.

Uncommon syms / binding with a keycode 
See the xkbcommon-keysyms.h header for all the keysyms. The name you should use is the segment after XKB_KEY_.

If you want to bind by a keycode, you can put it in the KEY position with a code: prefix, e.g.:

bind = SUPER, code:28, exec, amongus

This will bind SUPER + t since t is keycode 28.

If you are unsure of what your key’s name or keycode is, you can use wev to find out.
Misc 
Workspace bindings on non-QWERTY layouts 
Keys used for keybinds need to be accessible without any modifiers in your layout.
For instance, the French AZERTY layout uses SHIFT + unmodified key to write 0-9 numbers. As such, the workspace keybinds for this layout need to use the names of the unmodified keys , and will not work when using the 0-9 numbers.

To get the correct name for an unmodified_key, refer to the section on uncommon syms
# On a French layout, instead of:
# bind = $mainMod, 1, workspace,  1

# Use
bind = $mainMod, ampersand, workspace,  1

For help configuring the French AZERTY layout, see this article.

Unbind 
You can also unbind a key with the unbind keyword, e.g.:

unbind = SUPER, O

This may be useful for dynamic keybindings with hyprctl, e.g.:

hyprctl keyword unbind SUPER, O

In unbind, key is case-sensitive It must exactly match the case of the bind you are unbinding.

bind = SUPER, TAB, workspace, e+1
unbind = SUPER, Tab # this will NOT unbind
unbind = SUPER, TAB # this will unbind

Bind flags 
bind supports flags in this format:

bind[flags] = ...

e.g.:

bindrl = MOD, KEY, exec, amongus

Available flags:

Flag	Name	Description
l	locked	Will also work when an input inhibitor (e.g. a lockscreen) is active.
r	release	Will trigger on release of a key.
c	click	Will trigger on release of a key or button as long as the mouse cursor stays inside binds:drag_threshold.
g	drag	Will trigger on release of a key or button as long as the mouse cursor moves outside binds:drag_threshold.
o	long press	Will trigger on long press of a key.
e	repeat	Will repeat when held.
n	non-consuming	Key/mouse events will be passed to the active window in addition to triggering the dispatcher.
m	mouse	See the dedicated Mouse Binds section.
t	transparent	Cannot be shadowed by other binds.
i	ignore mods	Will ignore modifiers.
s	separate	Will arbitrarily combine keys between each mod/key, see Keysym combos.
d	has description	Will allow you to write a description for your bind.
p	bypass	Bypasses the app’s requests to inhibit keybinds.
Example Usage:

# Example volume button that allows press and hold, volume limited to 150%
binde = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+

# Example volume button that will activate even while an input inhibitor is active
bindl = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

# Open wofi on first press, closes it on second
bindr = SUPER, SUPER_L, exec, pkill wofi || wofi

# Describe a bind
bindd = SUPER, Q, Open my favourite terminal, exec, kitty

# Skip player on long press and only skip 5s on normal press
bindo = SUPER, XF86AudioNext, exec, playerctl next
bind = SUPER, XF86AudioNext, exec, playerctl position +5

Mouse buttons 
You can also bind or unbind mouse buttons by prefacing the mouse keycode with mouse:, e.g.:

bind = SUPER, mouse:272, exec, amongus  # bind `exec amogus` to SUPER + LMB.

Binding modkeys only 
To only bind modkeys, you need to use the TARGET modmask (with the activating mod) and the r flag, e.g.:

bindr = SUPER ALT, Alt_L, exec, amongus  # bind `exec amongus` to SUPER + ALT.

Keysym combos 
For an arbitrary combination of multiple keys, separate keysyms with & between each mod/key, and use the s flag, e.g.:

# You can use a single mod with multiple keys.
binds = Control_L, A&Z, exec, kitty
# You can also specify multiple specific mods.
binds = Control_L&Shift_L, K, exec, kitty
# You can also do both!
binds = Control_R&Super_R&Alt_L, J&K&L, exec, kitty
# If you are feeling a little wild... you can use other keys for binds...
binds = Escape&Apostrophe&F7, T&O&A&D, exec, battletoads 2: retoaded

Please note that this is only valid for keysyms and it makes all mods keysyms.
If you don’t know what a keysym is use wev and press the key you want to use.
Mouse wheel 
You can also bind mouse wheel events with mouse_up and mouse_down (or mouse_left and mouse_right if your mouse supports horizontal scrolling):

bind = SUPER, mouse_down, workspace, e-1

You can control the reset time with binds:scroll_event_delay.
Switches 
Switches are useful for binding events like closing and opening a laptop’s lid:

# Trigger when the switch is toggled.
bindl = , switch:[switch name], exec, swaylock
# Trigger when the switch is turning on.
bindl = , switch:on:[switch name], exec, hyprctl keyword monitor "eDP-1, disable"
# Trigger when the switch is turning off.
bindl = , switch:off:[switch name], exec, hyprctl keyword monitor "eDP-1, 2560x1600, 0x0, 1"

Systemd HandleLidSwitch settings in logind.conf may conflict with Hyprland’s laptop lid switch configurations.
You can view your switches with hyprctl devices.
Multiple binds to one key 
You can trigger multiple actions with the same keybind by assigning it multiple times, with different disapatchers and params:

# To switch between windows in a floating workspace:
bind = SUPER, Tab, cyclenext         # Change focus to another window
bind = SUPER, Tab, bringactivetotop  # Bring it to the top

The keybinds will be executed top to bottom, in the order they were written in.
Description 
You can describe your keybind with the d flag.
Your description always goes in front of the dispatcher, and must not include commas (,)!

bindd = MODS, key, description, dispatcher, params

For example:

bindd = SUPER, Q, Open my favourite terminal, exec, kitty

If you want to access your description you can use hyprctl binds.
For more information have a look at Using Hyprctl.

Mouse Binds 
These are binds that rely on mouse movement. They will have one less arg.
binds:drag_threshold can be used to differentiate between clicks and drags with the same button:

binds {
    drag_threshold = 10  # Fire a drag event only after dragging for more than 10px
}
bindm = ALT, mouse:272, movewindow      # ALT + LMB: Move a window by dragging more than 10px.
bindc = ALT, mouse:272, togglefloating  # ALT + LMB: Floats a window by clicking

Available mouse binds:

Name	Description	Params
movewindow	moves the active window	None
resizewindow	resizes the active window	1 -> Resize and keep window aspect ratio.
2 -> Resize and ignore keepaspectratio window rule/prop.
None or anything else for normal resize
Common mouse button key codes (check wev for other buttons):

LMB -> 272
RMB -> 273
MMB -> 274

Mouse binds, despite their name, behave like normal binds.
You are free to use whatever keys / mods you please. When held, the mouse function will be activated.
Touchpad 
As clicking and moving the mouse on a touchpad is unergonomic, you can also use keyboard keys instead of mouse clicks.

bindm = SUPER, mouse:272, movewindow
bindm = SUPER, Control_L, movewindow
bindm = SUPER, mouse:273, resizewindow
bindm = SUPER, ALT_L, resizewindow

Global Keybinds 
Classic 
Yes, you heard this right, Hyprland does support global keybinds for ALL apps, including OBS, Discord, Firefox, etc.

See the pass and sendshortcut dispatchers for keybinds.

Let’s take OBS as an example: the “Start/Stop Recording” keybind is set to SUPER + F10, to make it work globally, simply add:

bind = SUPER, F10, pass, class:^(com\.obsproject\.Studio)$

to your config and you’re done.

pass will pass the PRESS and RELEASE events by itself, no need for a bindr.
This also means that push-to-talk will work flawlessly with one pass, e.g.:

bind = , mouse:276, pass, class:^(TeamSpeak 3)$  # Pass MOUSE5 to TeamSpeak3.

You may also add shortcuts, where other keys are passed to the window.

bind = SUPER, F10, sendshortcut, SUPER, F4, class:^(com\.obsproject\.Studio)$  # Send SUPER + F4 to OBS when SUPER + F10 is pressed.

This works flawlessly with all native Wayland applications, however, XWayland is a bit wonky.
Make sure that what you’re passing is a “global Xorg keybind”, otherwise passing from a different XWayland app may not work.
DBus Global Shortcuts 
Some applications may already support the GlobalShortcuts portal in xdg-desktop-portal.
If that’s the case, it’s recommended to use the following method instead of pass:

Open your desired app and run hyprctl globalshortcuts in a terminal.
This will give you a list of currently registered shortcuts with their description(s).

Choose whichever you like, for example coolApp:myToggle, and bind it to whatever you want with the global dispatcher:

bind = SUPERSHIFT, A, global, coolApp:myToggle

Please note that this function will only work with XDPH.
Submaps 
Keybind submaps, also known as modes or groups, allow you to activate a separate set of keybinds.
For example, if you want to enter a resize mode that allows you to resize windows with the arrow keys, you can do it like this:

# Switch to a submap called `resize`.
bind = ALT, R, submap, resize

# Start a submap called "resize".
submap = resize

# Set repeatable binds for resizing the active window.
binde = , right, resizeactive, 10 0
binde = , left, resizeactive, -10 0
binde = , up, resizeactive, 0 -10
binde = , down, resizeactive, 0 10

# Use `reset` to go back to the global submap
bind = , escape, submap, reset

# Reset the submap, which will return to the global submap
submap = reset

# Keybinds further down will be global again...

Do not forget a keybind (escape, in this case) to reset the keymap while inside it!

If you get stuck inside a keymap, you can use hyprctl dispatch submap reset to go back.
If you do not have a terminal open, tough luck buddy. You have been warned.

You can also set the same keybind to perform multiple actions, such as resize and close the submap, like so:

bind = ALT, R, submap, resize

submap = resize

bind = , right, resizeactive, 10 0
bind = , right, submap, reset
# ...

submap = reset

This works because the binds are executed in the order they appear, and assigning multiple actions per bind is possible.

Nesting 
Submaps can be nested, see the following example:

bind = $mainMod, M, submap, main_submap
submap = main_submap

# ...

# nested_one
bind = , 1, submap, nested_one
submap = nested_one

# ...

bind = SHIFT, escape, submap, reset
bind =      , escape, submap, main_submap
submap = main_submap
# /nested_one

# nested_two
bind = , 2, submap, nested_two
submap = nested_two

# ...

bind = SHIFT, escape, submap, reset
bind =      , escape, submap, main_submap
submap = main_submap
# /nested_two

bind = , escape, submap, reset
submap = reset

Catch-All 
You can also define a keybind via the special catchall keyword, which activates no matter which key is pressed.
This can be used to prevent any keys from passing to your active application while in a submap or to exit it immediately when any unknown key is pressed:

bind = , catchall, submap, reset

Example Binds 
Media 
These binds set the expected behavior for regular keyboard media volume keys, including when the screen is locked:

bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
# Requires playerctl
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous
bindl = , XF86AudioNext, exec, playerctl next

Last updated on October 4, 2025
Monitors
Dispatchers
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Parameter explanation
List of Dispatchers
Grouped (tabbed) windows
Workspaces
Special Workspace
Executing with rules
setprop
Fullscreenstate
Edit this page on GitHub →
Scroll to top 
Configuring
Dispatchers
Dispatchers
Please keep in mind some layout-specific dispatchers will be listed in the layout pages (See the sidebar).

Parameter explanation 
Param type	Description
window	a window. Any of the following: class regex (by default, optionally class:), initialclass: initial class regex, title: title regex, initialtitle initial title regex, tag: window tag regex, pid: the pid, address: the address, activewindow an active window, floating the first floating window on the current workspace, tiled the first tiled window on the current workspace
workspace	see below.
direction	l r u d left right up down
monitor	One of: direction, ID, name, current, relative (e.g. +1 or -1)
resizeparams	relative pixel delta vec2 (e.g. 10 -10), optionally a percentage of the window size (e.g. 20 25%) or exact followed by an exact vec2 (e.g. exact 1280 720), optionally a percentage of the screen size (e.g. exact 50% 50%)
floatvalue	a relative float delta (e.g -0.2 or +0.2) or exact followed by a the exact float value (e.g. exact 0.5)
zheight	top or bottom
mod	SUPER, SUPER_ALT, etc.
key	g, code:42, 42 or mouse clicks (mouse:272)
List of Dispatchers 
Dispatcher	Description	Params
exec	executes a shell command	command (supports rules, see below)
execr	executes a raw shell command (does not support rules)	command
pass	passes the key (with mods) to a specified window. Can be used as a workaround to global keybinds not working on Wayland.	window
sendshortcut	sends specified keys (with mods) to an optionally specified window. Can be used like pass	mod, key[, window]
sendkeystate	Send a key with specific state (down/repeat/up) to a specified window (window must keep focus for events to continue).	mod, key, state, window
killactive	closes (not kills) the active window	none
forcekillactive	kills the active window	none
closewindow	closes a specified window	window
killwindow	kills a specified window	window
signal	sends a signal to the active window	signal
signalwindow	sends a signal to a specified window	window,signal, e.g.class:Alacritty,9
workspace	changes the workspace	workspace
movetoworkspace	moves the focused window to a workspace	workspace OR workspace,window for a specific window
movetoworkspacesilent	same as above, but doesn’t switch to the workspace	workspace OR workspace,window for a specific window
togglefloating	toggles the current window’s floating state	left empty / active for current, or window for a specific window
setfloating	sets the current window’s floating state to true	left empty / active for current, or window for a specific window
settiled	sets the current window’s floating state to false	left empty / active for current, or window for a specific window
fullscreen	toggles the focused window’s fullscreen mode	0 - fullscreen (takes your entire screen), 1 - maximize (keeps gaps and bar(s))
fullscreenstate	sets the focused window’s fullscreen mode and the one sent to the client	internal client, where internal (the hyprland window) and client (the application) can be -1 - current, 0 - none, 1 - maximize, 2 - fullscreen, 3 - maximize and fullscreen.
dpms	sets all monitors’ DPMS status. Do not use with a keybind directly.	on, off, or toggle. For specific monitor add monitor name after a space
pin	pins a window (i.e. show it on all workspaces) note: floating only	left empty / active for current, or window for a specific window
movefocus	moves the focus in a direction	direction
movewindow	moves the active window in a direction or to a monitor. For floating windows, moves the window to the screen edge in that direction	direction or mon: and a monitor, optionally followed by a space and silent to prevent the focus from moving with the window
swapwindow	swaps the active window with another window in the given direction or with a specific window	direction or window
centerwindow	center the active window note: floating only	none (for monitor center) or 1 (to respect monitor reserved area)
resizeactive	resizes the active window	resizeparams
moveactive	moves the active window	resizeparams
resizewindowpixel	resizes a selected window	resizeparams,window, e.g. 100 100,^(kitty)$
movewindowpixel	moves a selected window	resizeparams,window
cyclenext	focuses the next window (on a workspace, if visible is not provided)	none (for next) or prev (for previous) additionally tiled for only tiled, floating for only floating. prev tiled is ok. visible for all monitors cycling. visible prev floating is ok. if hist arg provided - focus order will depends on focus history. All other modifiers is also working for it, visible next floating hist is ok.
swapnext	swaps the focused window with the next window on a workspace	none (for next) or prev (for previous)
tagwindow	apply tag to current or the first window matching	tag [window], e.g. +code ^(foot)$, music
focuswindow	focuses the first window matching	window
focusmonitor	focuses a monitor	monitor
splitratio	changes the split ratio	floatvalue
movecursortocorner	moves the cursor to the corner of the active window	direction, 0 - 3, bottom left - 0, bottom right - 1, top right - 2, top left - 3
movecursor	moves the cursor to a specified position	x y
renameworkspace	rename a workspace	id name, e.g. 2 work
exit	exits the compositor with no questions asked.	none
forcerendererreload	forces the renderer to reload all resources and outputs	none
movecurrentworkspacetomonitor	Moves the active workspace to a monitor	monitor
focusworkspaceoncurrentmonitor	Focuses the requested workspace on the current monitor, swapping the current workspace to a different monitor if necessary. If you want XMonad/Qtile-style workspace switching, replace workspace in your config with this.	workspace
moveworkspacetomonitor	Moves a workspace to a monitor	workspace and a monitor separated by a space
swapactiveworkspaces	Swaps the active workspaces between two monitors	two monitors separated by a space
bringactivetotop	Deprecated in favor of alterzorder. Brings the current window to the top of the stack	none
alterzorder	Modify the window stack order of the active or specified window. Note: this cannot be used to move a floating window behind a tiled one.	zheight[,window]
togglespecialworkspace	toggles a special workspace on/off	none (for the first) or name for named (name has to be a special workspace’s name)
focusurgentorlast	Focuses the urgent window or the last window	none
togglegroup	toggles the current active window into a group	none
changegroupactive	switches to the next window in a group.	b - back, f - forward, or index start at 1
focuscurrentorlast	Switch focus from current to previously focused window	none
lockgroups	Locks the groups (all groups will not accept new windows)	lock for locking, unlock for unlocking, toggle for toggle
lockactivegroup	Lock the focused group (the current group will not accept new windows or be moved to other groups)	lock for locking, unlock for unlocking, toggle for toggle
moveintogroup	Moves the active window into a group in a specified direction. No-op if there is no group in the specified direction.	direction
moveoutofgroup	Moves the active window out of a group. No-op if not in a group	left empty / active for current, or window for a specific window
movewindoworgroup	Behaves as moveintogroup if there is a group in the given direction. Behaves as moveoutofgroup if there is no group in the given direction relative to the active group. Otherwise behaves like movewindow.	direction
movegroupwindow	Swaps the active window with the next or previous in a group	b for back, anything else for forward
denywindowfromgroup	Prohibit the active window from becoming or being inserted into group	on, off or, toggle
setignoregrouplock	Temporarily enable or disable binds:ignore_group_lock	on, off, or toggle
global	Executes a Global Shortcut using the GlobalShortcuts portal. See here	name
submap	Change the current mapping group. See Submaps	reset or name
event	Emits a custom event to socket2 in the form of custom>>yourdata	the data to send
setprop	Sets a window property	window property value
toggleswallow	If a window is swallowed by the focused window, unswallows it. Execute again to swallow it back	none
uwsm users should avoid using exit dispatcher, or terminating Hyprland process directly, as exiting Hyprland this way removes it from under its clients and interferes with ordered shutdown sequence. Use exec, uwsm stop (or other variants) which will gracefully bring down graphical session (and login session bound to it, if any). If you experience problems with units entering inconsistent states, affecting subsequent sessions, use exec, loginctl terminate-user "" instead (terminates all units of the user).

It’s also strongly advised to replace the exit dispatcher inside hyprland.conf keybinds section accordingly.

It is NOT recommended to set DPMS with a keybind directly, as it might cause undefined behavior. Instead, consider something like

bind = MOD, KEY, exec, sleep 1 && hyprctl dispatch dpms off

Grouped (tabbed) windows 
Hyprland allows you to make a group from the current active window with the togglegroup bind dispatcher.

A group is like i3wm’s “tabbed” container. It takes the space of one window, and you can change the window to the next one in the tabbed “group” with the changegroupactive bind dispatcher.

The new group’s border colors are configurable with the appropriate col. settings in the group config section.

You can lock a group with the lockactivegroup dispatcher in order to stop new windows from entering this group. In addition, the lockgroups dispatcher can be used to toggle an independent global group lock that will prevent new windows from entering any groups, regardless of their local group lock stat.

You can prevent a window from being added to a group or becoming a group with the denywindowfromgroup dispatcher. movewindoworgroup will behave like movewindow if the current active window or window in direction has this property set.

Workspaces 
You have nine choices:

ID: e.g. 1, 2, or 3

Relative ID: e.g. +1, -3 or +100

workspace on monitor, relative with + or -, absolute with ~: e.g. m+1, m-2 or m~3

workspace on monitor including empty workspaces, relative with + or -, absolute with ~: e.g. r+1 or r~3

open workspace, relative with + or -, absolute with ~: e.g. e+1, e-10, or e~2

Name: e.g. name:Web, name:Anime or name:Better anime

Previous workspace: previous, or previous_per_monitor

First available empty workspace: empty, suffix with m to only search on monitor. and/or n to make it the next available empty workspace. e.g. emptynm

Special Workspace: special or special:name for named special workspaces.

special is supported ONLY on movetoworkspace and movetoworkspacesilent. Any other dispatcher will result in undocumented behavior.
Numerical workspaces (e.g. 1, 2, 13371337) are allowed ONLY between 1 and 2147483647 (inclusive)

Neither 0 nor negative numbers are allowed.

Special Workspace 
A special workspace is what is called a “scratchpad” in some other places. A workspace that you can toggle on/off on any monitor.

You can define multiple named special workspaces, but the amount of those is limited to 97 at a time.
For example, to move a window/application to a special workspace you can use the following syntax:

bind = SUPER, C, movetoworkspace, special
#The above syntax will move the window to a special workspace upon pressing 'SUPER'+'C'.
#To see the hidden window you can use the togglespecialworkspace dispatcher mentioned above.

Executing with rules 
The exec dispatcher supports adding rules. Please note some windows might work better, some worse. It records the PID of the spawned process and uses that. For example, if your process forks and then the fork opens a window, this will not work.

The syntax is:

bind = mod, key, exec, [rules...] command

For example:

bind = SUPER, E, exec, [workspace 2 silent; float; move 0 0] kitty

setprop 
Prop List:

prop	comment
alpha	float 0.0 - 1.0
alphaoverride	0/1, makes the next setting be override instead of multiply
alphainactive	float 0.0 - 1.0
alphainactiveoverride	0/1, makes the next setting be override instead of multiply
alphafullscreen	float 0.0 - 1.0
alphafullscreenoverride	0/1, makes the next setting be override instead of multiply
animationstyle	string, cannot be locked
activebordercolor	gradient, -1 means not set
inactivebordercolor	gradient, -1 means not set
maxsize	vec2 (x y)
minsize	vec2 (x y)
Additional properties can be found in the Window Rules section.

For example:

address:0x13371337 noanim 1
address:0x13371337 nomaxsize 0
address:0x13371337 opaque toggle
address:0x13371337 immediate unset
address:0x13371337 bordersize relative -2
address:0x13371337 roundingpower relative 0.1

Fullscreenstate 
fullscreenstate internal client

The fullscreenstate dispatcher decouples the state that Hyprland maintains for a window from the fullscreen state that is communicated to the client.

internal is a reference to the state maintained by Hyprland.

client is a reference to the state that the application receives.

Value	State	Description
-1	Current	Maintains the current fullscreen state.
0	None	Window allocates the space defined by the current layout.
1	Maximize	Window takes up the entire working space, keeping the margins.
2	Fullscreen	Window takes up the entire screen.
3	Maximize and Fullscreen	The state of a fullscreened maximized window. Works the same as fullscreen.
For example:

fullscreenstate 2 0 Fullscreens the application and keeps the client in non-fullscreen mode.

This can be used to prevent Chromium-based browsers from going into presentation mode when they detect they have been fullscreened.

fullscreenstate 0 2 Keeps the window non-fullscreen, but the client goes into fullscreen mode within the window.

Last updated on October 4, 2025
Binds
Window Rules
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Window Rules
Syntax
RegEx writing
Rules
Static rules
Dynamic rules
group window rule options
Tags
Example Rules
Notes
Layer Rules
Rules
Edit this page on GitHub →
Scroll to top 
Configuring
Window Rules
Window Rules
Window rules are case sensitive. (e.g. firefox ≠ Firefox)

As of Hyprland v0.46.0, RegExes need to fully match the window values. For example, in the case of kitty:

kitty/(kitty)/^(kitty)$: Matches.
tty: Used to match, now won’t. Use .*tty.* to make it act like before, or consider using a more specific RegEx.
Rules are evaluated top to bottom, so the order they’re written in does matter! More info in Notes
Window Rules 
You can set window rules to achieve different window behaviors based on their properties.

Syntax 
windowrule=RULE,PARAMETERS

RULE is a rule (and a param if applicable)
PARAMETERS is a comma-separated list of various window attributes you can match by. See the fields further down.
Example rule:

windowrule = float, class:kitty, title:kitty

Several rules can be specified in a single line, separated by commas. But have to be followed by at least one parameter.

Example:

windowrule = float, pin, size 400 400, move 0 0, class:kitty, initialTitle:kitty

Where float pin size and move are RULES and class and initialTitle are PARAMETERS.

In the case of dynamic window titles such as browser windows, keep in mind how powerful RegEx is.

For example, a window rule of: windowrule = opacity 0.3 override 0.3 override,title:(.*)(- Youtube) will match any window that contains a string of “- Youtube” after any other text. This could be multiple browser windows or other applications that contain the string for any reason.

For the windowrule = float,class:kitty,title:kitty example, the class:(kitty) WINDOW field is what keeps the window rule specific to kitty terminals.

The supported fields for parameters are:

Field	Description
class:[RegEx]	Windows with class matching RegEx.
title:[RegEx]	Windows with title matching RegEx.
initialClass:[RegEx]	Windows with initialClass matching RegEx.
initialTitle:[RegEx]	Windows with initialTitle matching RegEx.
tag:[name]	Windows with matching tag.
xwayland:[0/1]	Xwayland windows.
floating:[0/1]	Floating windows.
fullscreen:[0/1]	Fullscreen windows.
pinned:[0/1]	Pinned windows.
focus:[0/1]	Currently focused window.
group:[0/1]	Grouped windows.
fullscreenstate:[internal] [client]	Windows with matching fullscreenstate. internal and client can be * - any, 0 - none, 1 - maximize, 2 - fullscreen, 3 - maximize and fullscreen.
workspace:[w]	Windows on matching workspace. w can be id or name:string.
onworkspace:[w]	Windows on matching workspace. w can be id, name:string or workspace selector.
content:[none|photo|video|game]	Windows with specified content type
xdgtag:[string]	Match a window by its xdgTag (see hyprctl clients to check if it has one)
Keep in mind that you have to declare at least one field, but not all.

To get more information about a window’s class, title, XWayland status or its size, you can use hyprctl clients.
In the output of the hyprctl clients command: fullscreen refers to fullscreenstate.internal and fullscreenClient refers to fullscreenstate.client
RegEx writing 
Please note Hyprland uses Google’s RE2 for parsing RegEx. This means that all operations requiring polynomial time to compute will not work. See the RE2 wiki for supported extensions.

If you want to negate a ReGex, as in pass only when the RegEx fails, you can prefix it with negative:, e.g.: negative:kitty.

Rules 
Static rules 
Static rules are evaluated once when the window is opened and never again. This essentially means that it is always the initialTitle and initialClass which will be found when matching on title and class, respectively.

It is not possible to float (or any other static rule) a window based on a change in the title after the window has been created. This applies to all static rules listed here.
Rule	Description
float	Floats a window.
tile	Tiles a window.
fullscreen	Fullscreens a window.
maximize	Maximizes a window.
persistentsize	Allows size persistence between application launches for floating windows.
fullscreenstate [internal] [client]	Sets the focused window’s fullscreen mode and the one sent to the client, where internal and client can be 0 - none, 1 - maximize, 2 - fullscreen, 3 - maximize and fullscreen.
move [x] [y]	Moves a floating window (x, y -> int or %, e.g. 100 or 20%.
You are also allowed to do 100%- for the right/bottom anchor, e.g. 100%-20. In addition, the option supports the subtraction of the window’s size with 100%-w-, e.g. 100%-w-20. This results in a gap at the right/bottom edge of the screen to the window with the defined subtracted size).
Additionally, you can also do cursor [x] [y] where x and y are either pixels or percent. Percent is calculated from the window’s size. Specify onscreen before other parameters to force the window into the screen (e.g. move onscreen cursor 50% 50%)
size [w] [h]	Resizes a floating window (w, h -> int or %, e.g. 1280, 720 or 50%, 50%.
< and > may also be prefixed in conjunction, to specify respectively the maximum or minimum allowed size. (e.g. <1280 or <40% -> maximum size, >300 or >10% -> minimum size).
Note that int values in pixels will be scaled by your monitor’s scaling factor.
center ([opt])	If the window is floating, will center it on the monitor. Set opt to 1 to respect monitor reserved area.
pseudo	Pseudotiles a window.
monitor [id]	Sets the monitor on which a window should open. id can be either the id number or the name (e.g. 1 or DP-1).
workspace [w]	Sets the workspace on which a window should open (for workspace syntax, see dispatchers->workspaces).
You can also set [w] to unset. This will unset all previous workspace rules applied to this window. Additionally you can add silent after the workspace to make the window open silently.
noinitialfocus	Disables the initial focus to the window
pin	Pins the window (i.e. show it on all workspaces). Note: floating only.
unset [rule]	Unset rules for the matching PARAMETERS (exact match required) or a specific RULE. No rule defaults to all.
nomaxsize	Removes max size limitations. Especially useful with windows that report invalid max sizes (e.g. winecfg).
stayfocused	Forces focus on the window as long as it’s visible.
group [options]	Sets window group properties. See the note below.
suppressevent [types…]	Ignores specific events from the window. Events are space separated, and can be: fullscreen, maximize, activate, activatefocus, fullscreenoutput.
content [none|photo|video|game]	Sets content type.
noclosefor [ms]	Makes the window uncloseable with the killactive dispatcher for a given amount of ms on open.
Dynamic rules 
Dynamic rules are re-evaluated every time a property changes.

Rule	Description
animation [style] ([opt])	Forces an animation onto a window, with a selected opt. Opt is optional.
bordercolor [c]	Force the bordercolor of the window.
Options for c: color/color ... color angle -> sets the active border color/gradient OR color color/color ... color angle color ... color [angle] -> sets the active and inactive border color/gradient of the window. See variables->colors for color definition.
idleinhibit [mode]	Sets an idle inhibit rule for the window. If active, apps like hypridle will not fire. Modes: none, always, focus, fullscreen.
opacity [a]	Additional opacity multiplier. Options for a: float -> sets an overall opacity, float float -> sets activeopacity and inactiveopacity respectively, float float float -> sets activeopacity, inactiveopacity and fullscreenopacity respectively.
tag [name]	Applies the tag name to the window, use prefix +/- to set/unset flag, or no prefix to toggle the flag.
maxsize [w] [h]	Sets the maximum size (x,y -> int).
minsize [w] [h]	Sets the minimum size (x,y -> int).
The following rules can also be set with setprop:

Rule	Description
bordersize [int]	Sets the border size.
rounding [int]	Forces the application to have X pixels of rounding, ignoring the set default (in decoration:rounding). Has to be an int.
roundingpower [float]	Overrides the rounding power for the window (see decoration:rounding_power).
allowsinput [on]	Forces an XWayland window to receive input, even if it requests not to do so. (Might fix issues like Game Launchers not receiving focus for some reason)
dimaround [on]	Dims everything around the window. Please note that this rule is meant for floating windows and using it on tiled ones may result in strange behavior.
decorate [on]	Whether to draw window decorations or not
focusonactivate [on]	Whether Hyprland should focus an app that requests to be focused (an activate request).
keepaspectratio [on]	Forces aspect ratio when resizing window with the mouse.
nearestneighbor [on]	Forces the window to use nearest neighbor filtering.
noanim [on]	Disables the animations for the window.
noblur [on]	Disables blur for the window.
noborder [on]	Disables borders for the window.
nodim [on]	Disables window dimming for the window.
nofocus [on]	Disables focus to the window.
nofollowmouse [on]	Prevents the window from being focused when the mouse moves over it when input:follow_mouse=1 is set.
nomaxsize [on]	Disables max size for the window.
norounding [on]	Disables rounding for the window.
noshadow [on]	Disables shadows for the window.
noshortcutsinhibit [on]	Disallows the app from inhibiting your shortcuts.
opaque [on]	Forces the window to be opaque.
forcergbx [on]	Forces Hyprland to ignore the alpha channel on the whole window’s surfaces, effectively making it actually, fully 100% opaque.
syncfullscreen [on]	Whether the fullscreen mode should always be the same as the one sent to the window (will only take effect on the next fullscreen mode change).
immediate [on]	Forces the window to allow tearing. See the Tearing page.
xray [on]	Sets blur xray mode for the window.
renderunfocused	Forces the window to think it’s being rendered when it’s not visible. See also Variables - Misc for setting render_unfocused_fps.
scrollmouse [float]	Forces the window to override the variable input:scroll_factor.
scrolltouchpad [float]	Forces the window to override the variable input:touchpad:scroll_factor.
noscreenshare [on]	Hides the window and its popups from screen sharing by drawing black rectangles in their place. The rectangles are drawn even if other windows are above.
novrr [on]	Disables VRR for the window. Only works when misc:vrr is set to 2 or 3.
When using window rules, [on] can be set to 0 for disabled, 1 for enabled, or left blank to use the default value.

When using setprop, [on] can be set to 0 for disabled, 1 for enabled, toggle to toggle the state or unset to unset previous values.

When using setprop, [int] can also be unset to unset previous values.

group window rule options 
set [always] - Open window as a group.
new - Shorthand for barred set.
lock [always] - Lock the group that added this window. Use with set or new (e.g. new lock) to create a new locked group.
barred - Do not automatically group the window into the focused unlocked group.
deny - Do not allow the window to be toggled as or added to group (see denywindowfromgroup dispatcher).
invade - Force open window in the locked group.
override [other options] - Override other group rules, e.g. You can make all windows in a particular workspace open as a group, and use group override barred to make windows with specific titles open as normal windows.
unset - Clear all group rules.
The group rule without options is a shorthand for group set.

By default, set and lock only affect new windows once. The always qualifier makes them always effective.

Tags 
Window may have several tags, either static or dynamic. Dynamic tags will have a suffix of *. You may check window tags with hyprctl clients.

Use the tagwindow dispatcher to add a static tag to a window:

hyprctl dispatch tagwindow +code     # Add tag to current window.
hyprctl dispatch tagwindow -- -code  # Remove tag from current window (use `--` to protect the leading `-`).
hyprctl dispatch tagwindow code      # Toggle the tag of current window.

# Or you can tag windows matched with a window RegEx:
hyprctl dispatch tagwindow +music deadbeef
hyprctl dispatch tagwindow +media title:Celluloid

Use the tag rule to add a dynamic tag to a window:

windowrule = tag +term, class:footclient  # Add dynamic tag `term*` to window footclient.
windowrule = tag term, class:footclient   # Toggle dynamic tag `term*` for window footclient.
windowrule = tag +code, tag:cpp           # Add dynamic tag `code*` to window with tag `cpp`.

windowrule = opacity 0.8, tag:code        # Set opacity for window with tag `code` or `code*`.
windowrule = opacity 0.7, tag:cpp         # Window with tag `cpp` will match both `code` and `cpp`, the last one will override prior match.
windowrule = opacity 0.6, tag:term*       # Set opacity for window with tag `term*` only, `term` will not be matched.

windowrule = tag -code, tag:term          # Remove dynamic tag `code*` for window with tag `term` or `term*`.

Or with a keybind for convenience:

bind = $mod Ctrl, 2, tagwindow, alpha_0.2
bind = $mod Ctrl, 4, tagwindow, alpha_0.4

windowrule = opacity 0.2 override, tag:alpha_0.2
windowrule = opacity 0.4 override, tag:alpha_0.4

The tag rule can only manipulate dynamic tags, and the tagwindow dispatcher only works with static tags (i.e. once the dispatcher is called, dynamic tags will be cleared).

Example Rules 
windowrule = move 100 100, class:kitty                                    # Move kitty to 100 100
windowrule = animation popin, class:kitty                                 # Set the animation style for kitty
windowrule = noblur, class:firefox                                        # Disable blur for firefox
windowrule = move cursor -50% -50%, class:kitty                           # Move kitty to the center of the cursor
windowrule = bordercolor rgb(FF0000) rgb(880808), fullscreen:1            # Set bordercolor to red if window is fullscreen
windowrule = bordercolor rgb(00FF00), fullscreenstate:* 1                 # Set bordercolor to green if window's client fullscreen state is 1(maximize) (internal state can be anything)
windowrule = bordercolor rgb(FFFF00), title:.*Hyprland.*                  # Set bordercolor to yellow when title contains Hyprland
windowrule = opacity 1.0 override 0.5 override 0.8 override, class:kitty  # Set opacity to 1.0 active, 0.5 inactive and 0.8 fullscreen for kitty
windowrule = rounding 10, class:kitty                                     # Set rounding to 10 for kitty
windowrule = stayfocused,  class:(pinentry-)(.*)                          # Fix pinentry losing focus

Notes 
Rules that are marked as Dynamic will be reevaluated if the matching property of the window changes.
For instance, if a rule is defined that changes the bordercolor of a window when it is floating, then the bordercolor will change to the requested color when it is set to floating, and revert to the default color when it is tiled again.

Rules will be processed from top to bottom, where the last match will take precedence. i.e.

windowrule = opacity 0.8 0.8, class:kitty
windowrule = opacity 0.5 0.5, floating:1

Here, all non-fullscreen kitty windows will have opacity 0.8, except if they are floating. Otherwise, they will have opacity 0.5. The rest of the non-fullscreen floating windows will have opacity 0.5.

windowrule = opacity 0.5 0.5,floating:1
windowrule = opacity 0.8 0.8,class:kitty

Here, all kitty windows will have opacity 0.8, even if they are floating. The rest of the floating windows will have opacity 0.5.

Opacity is a PRODUCT of all opacities by default. For example, setting activeopacity to 0.5 and opacity to 0.5 will result in a total opacity of 0.25.
You are allowed to set opacities over 1.0, but any opacity product over 1.0 will cause graphical glitches.
For example, using 0.5 * 2 = 1 is fine, but 0.5 * 4 = 2 will cause graphical glitches.
You can put override after an opacity value to override it to an exact value rather than a multiplier. For example, to set active and inactive opacity to 0.8, and make fullscreen windows fully opaque regardless of other opacity rules:

windowrule = opacity 0.8 override 0.8 override 1.0 override, class:kitty

Layer Rules 
Some things in Wayland are not windows, but layers. That includes, for example: app launchers, status bars, or wallpapers.

Those have specific rules, separate from windows:

layerrule = rule, namespace
# or
layerrule = rule, address

where rule is the rule and namespace is the namespace RegEx (find namespaces in hyprctl layers) or address is an address in the form of address:0x[hex].

Rules 
rule	description
unset	Removes all layerRules previously set for a select namespace RegEx. Please note it has to match exactly.
noanim	Disables animations.
blur	Enables blur for the layer.
blurpopups	Enables blur for the popups.
ignorealpha [a]	Makes blur ignore pixels with opacity of a or lower. a is float value from 0 to 1. a = 0 if unspecified.
ignorezero	Makes blur ignore fully transparent pixels. Same as ignorealpha 0.
dimaround	Dims everything behind the layer.
xray [on]	Sets the blur xray mode for a layer. 0 for off, 1 for on, unset for default.
animation [style]	Allows you to set a specific animation style for this layer.
order [n]	Sets the order relative to other layers. A higher n means closer to the edge of the monitor. Can be negative. n = 0 if unspecified.
abovelock [interactable]	Renders the layer above the lockscreen when the session is locked. If set to true, you can interact with the layer on the lockscreen, otherwise it will only be rendered above it.
noscreenshare [on]	Hides the layer from screen sharing by drawing a black rectangle over it.
Last updated on October 4, 2025
Dispatchers
Workspace Rules
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Workspace selectors
Syntax
Examples
Smart gaps
Smart gaps (ignoring special workspaces)
Rules
Example Rules
Edit this page on GitHub →
Scroll to top 
Configuring
Workspace Rules
Workspace Rules
You can set workspace rules to achieve workspace-specific behaviors. For instance, you can define a workspace where all windows are drawn without borders or gaps.

For layout-specific rules, see the specific layout page. For example: Master Layout->Workspace Rules.

Workspace selectors 
Workspaces that have already been created can be targeted by workspace selectors, e.g. r[2-4] w[t1].

Selectors have props separated by a space. No spaces are allowed inside props themselves.

Props:

r[A-B] - ID range from A to B inclusive
s[bool] - Whether the workspace is special or not
n[bool], n[s:string], n[e:string] - named actions. n[bool] -> whether a workspace is a named workspace, s and e are starts and ends with respectively
m[monitor] - Monitor selector
w[(flags)A-B], w[(flags)X] - Prop for window counts on the workspace. A-B is an inclusive range, X is a specific number. Flags can be omitted. It can be t for tiled-only, f for floating-only, g to count groups instead of windows, v to count only visible windows, and p to count only pinned windows.
f[-1], f[0], f[1], f[2] - fullscreen state of the workspace. -1: no fullscreen, 0: fullscreen, 1: maximized, 2, fullscreen without fullscreen state sent to the window.
Syntax 
workspace = WORKSPACE, RULES

WORKSPACE is a valid workspace identifier (see Dispatchers->Workspaces). This field is mandatory. This can be a workspace selector, but please note workspace selectors can only match existing workspaces.
RULES is one (or more) rule(s) as described here in rules.
Examples 
workspace = name:myworkspace, gapsin:0, gapsout:0
workspace = 3, rounding:false, bordersize:0
workspace = w[tg1-4], shadow:false

Smart gaps 
To replicate “smart gaps” / “no gaps when only” from other WMs/Compositors, use this bad boy:

workspace = w[tv1], gapsout:0, gapsin:0
workspace = f[1], gapsout:0, gapsin:0
windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
windowrule = rounding 0, floating:0, onworkspace:w[tv1]
windowrule = bordersize 0, floating:0, onworkspace:f[1]
windowrule = rounding 0, floating:0, onworkspace:f[1]

Smart gaps (ignoring special workspaces) 
You can combine workspace selectors for more fine-grained control, for example, to ignore special workspaces:

workspace = w[tv1]s[false], gapsout:0, gapsin:0
workspace = f[1]s[false], gapsout:0, gapsin:0
windowrule = bordersize 0, floating:0, onworkspace:w[tv1]s[false]
windowrule = rounding 0, floating:0, onworkspace:w[tv1]s[false]
windowrule = bordersize 0, floating:0, onworkspace:f[1]s[false]
windowrule = rounding 0, floating:0, onworkspace:f[1]s[false]

Rules 
Rule	Description	type
monitor:[m]	Binds a workspace to a monitor. See syntax and Monitors.	string
default:[b]	Whether this workspace should be the default workspace for the given monitor	bool
gapsin:[x]	Set the gaps between windows (equivalent to General->gaps_in)	int
gapsout:[x]	Set the gaps between windows and monitor edges (equivalent to General->gaps_out)	int
bordersize:[x]	Set the border size around windows (equivalent to General->border_size)	int
border:[b]	Whether to draw borders or not	bool
shadow:[b]	Whether to draw shadows or not	bool
rounding:[b]	Whether to draw rounded windows or not	bool
decorate:[b]	Whether to draw window decorations or not	bool
persistent:[b]	Keep this workspace alive even if empty and inactive	bool
on-created-empty:[c]	A command to be executed once a workspace is created empty (i.e. not created by moving a window to it). See the command syntax	string
defaultName:[s]	A default name for the workspace.	string
Example Rules 
workspace = 3, rounding:false, decorate:false
workspace = name:coding, rounding:false, decorate:false, gapsin:0, gapsout:0, border:false, monitor:DP-1
workspace = 8,bordersize:8
workspace = name:Hello, monitor:DP-1, default:true
workspace = name:gaming, monitor:desc:Chimei Innolux Corporation 0x150C, default:true
workspace = 5, on-created-empty:[float] firefox
workspace = special:scratchpad, on-created-empty:foot

Last updated on October 4, 2025
Window Rules
Animations
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

General
Examples
Animation tree
Curves
Example
Extras
Edit this page on GitHub →
Scroll to top 
Configuring
Animations
Animations
General 
Animations are declared with the animation keyword.

animation = NAME, ONOFF, SPEED, CURVE [,STYLE]

ONOFF use 0 to disable, 1 to enable. Note: if it’s 0, you can omit further args.

SPEED is the amount of ds (1ds = 100ms) the animation will take.

CURVE is the bezier curve name, see curves.

STYLE (optional) is the animation style.

The animations are a tree. If an animation is unset, it will inherit its parent’s values. See the animation tree.

Examples 
animation = workspaces, 1, 8, default
animation = windows, 1, 10, myepiccurve, slide
animation = fade, 0

Animation tree 
global
  ↳ windows - styles: slide, popin, gnomed
    ↳ windowsIn - window open - styles: same as windows
    ↳ windowsOut - window close - styles: same as windows
    ↳ windowsMove - everything in between, moving, dragging, resizing.
  ↳ layers - styles: slide, popin, fade
    ↳ layersIn - layer open
    ↳ layersOut - layer close
  ↳ fade
    ↳ fadeIn - fade in for window open
    ↳ fadeOut - fade out for window close
    ↳ fadeSwitch - fade on changing activewindow and its opacity
    ↳ fadeShadow - fade on changing activewindow for shadows
    ↳ fadeDim - the easing of the dimming of inactive windows
    ↳ fadeLayers - for controlling fade on layers
      ↳ fadeLayersIn - fade in for layer open
      ↳ fadeLayersOut - fade out for layer close
    ↳ fadePopups - for controlling fade on wayland popups
      ↳ fadePopupsIn - fade in for wayland popup open
      ↳ fadePopupsOut - fade out for wayland popup close
    ↳ fadeDpms - for controlling fade when dpms is toggled
  ↳ border - for animating the border's color switch speed
  ↳ borderangle - for animating the border's gradient angle - styles: once (default), loop
  ↳ workspaces - styles: slide, slidevert, fade, slidefade, slidefadevert
    ↳ workspacesIn - styles: same as workspaces
    ↳ workspacesOut - styles: same as workspaces
    ↳ specialWorkspace - styles: same as workspaces
      ↳ specialWorkspaceIn - styles: same as workspaces
      ↳ specialWorkspaceOut - styles: same as workspaces
  ↳ zoomFactor - animates the screen zoom
  ↳ monitorAdded - monitor added zoom animation

Using the loop style for borderangle requires Hyprland to constantly render new frames at a frequency equal to your screen’s refresh rate (e.g. 60 times per second for a 60hz monitor), which might stress your CPU/GPU and will impact battery life.
This will apply even if animations are disabled or borders are not visible.
Curves 
Defining your own Bézier curve can be done with the bezier keyword:

bezier = NAME, X0, Y0, X1, Y1

where NAME is a name of your choice and X0, Y0, X1, Y1 are the the two control points for a Cubic Bézier curve.
A good website to design your own Bézier can be cssportal.com.
If you want to instead choose from a list of pre-made Béziers, you can check out easings.net.

Example 
bezier = overshoot, 0.05, 0.9, 0.1, 1.1

Extras 
For animation style popin in windows, you can specify a minimum percentage to start from. For example, the following will make the animation 80% -> 100% of the size:

animation = windows, 1, 8, default, popin 80%

For animation styles slide, slidevert, slidefade and slidefadevert in workspaces, you can specify a movement percentage. For example, the following will make windows move 20% of the screen width:

animation = workspaces, 1, 8, default, slidefade 20%

For animation style slide in windows and layers you can specify a forced side.
You can choose between top, bottom, left or right.

animation = windows, 1, 8, default, slide left

Last updated on October 4, 2025
Workspace Rules
Gestures
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

General
Directions
Available gestures
Edit this page on GitHub →
Scroll to top 
Configuring
Gestures
Gestures
General 
Hyprland supports 1:1 gestures for the trackpad for some operations. The basic syntax looks like this:

gesture = fingers, direction, action, options

Various actions may have their own options, or none. You can drop the options altogether and end on the action arg if the action takes none.

You can also restrict gestures to a modifier by adding , mod: [MODMASK] after direction, or scale the animation’s speed by a float by adding scale: [SCALE].

Examples:

gesture = 3, horizontal, workspace
gesture = 3, down, mod: ALT, close
gesture = 3, up, mod: SUPER, scale: 1.5, fullscreen
gesture = 3, left, scale: 1.5, float

Directions 
The following directions are supported:

swipe -> any swipe
horizontal -> horizontal swipe
vertical -> vertical swipe
left, right, up, down -> swipe directions
pinch -> any pinch
pinchin, pinchout -> directional pinch
Available gestures 
Specifying unset as the gesture will unset a specific gesture that was previously set. Please note it needs to exactly match everything from the original gesture including direction, mods, fingers and scale.

gesture	description	arguments
dispatcher	the most basic, executes a dispatcher once the gesture ends	dispatcher, params
workspace	workspace swipe gesture, for switching workspaces	
move	moves the active window	none
resize	resizes the active window	none
special	toggles a special workspace	special workspace without the special:, e.g. mySpecialWorkspace
close	closes the active window	none
fullscreen	fullscreens the active window	none for fullscreen, maximize for maximize
float	floats the active window	none for toggle, float or tile for one-way
Last updated on October 4, 2025
Animations
Tearing
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Enabling tearing
Common issues
No tearing at all
Apps that should tear, freeze
Graphical artifacts (random colorful pixels, etc)
Edit this page on GitHub →
Scroll to top 
Configuring
Tearing
Tearing
Screen tearing is used to reduce latency and/or jitter in games.

Enabling tearing 
To enable tearing:

Set general:allow_tearing to true. This is a “master toggle”
Add an immediate windowrule to your game of choice. This makes sure that Hyprland will tear it.
Please note that tearing will only be in effect when the game is in fullscreen and the only thing visible on the screen.
Example snippet:

general {
    allow_tearing = true
}

windowrule = immediate, class:^(cs2)$

If you experience graphical issues, you may be out of luck. Tearing support is experimental.

See the likely culprits below.

Common issues 
No tearing at all 
Make sure your window rules are matching and you have the master toggle enabled.

Also make sure nothing except for your game is showing on your monitor. No notifications, overlays, lockscreens, bars, other windows, etc. (on a different monitor is fine)

Apps that should tear, freeze 
Almost definitely means your GPU driver does not support tearing.

Please do not report issues if this is the culprit.

Graphical artifacts (random colorful pixels, etc) 
Likely issue with your graphics driver.

Please do not report issues if this is the culprit. Unfortunately, it’s most likely your GPU driver’s fault.

Last updated on October 4, 2025
Gestures
Dwindle Layout
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Quirks
Config
Bind Dispatchers
Layout messages
Edit this page on GitHub →
Scroll to top 
Configuring
Dwindle Layout
Dwindle Layout
Dwindle is a BSPWM-like layout, where every window on a workspace is a member of a binary tree.

Quirks 
Dwindle splits are NOT PERMANENT. The split is determined dynamically with the W/H ratio of the parent node. If W > H, it’s side-by-side. If H > W, it’s top-and-bottom. You can make them permanent by enabling preserve_split.

Config 
category name: dwindle

name	description	type	default
pseudotile	enable pseudotiling. Pseudotiled windows retain their floating size when tiled.	bool	false
force_split	0 -> split follows mouse, 1 -> always split to the left (new = left or top) 2 -> always split to the right (new = right or bottom)	int	0
preserve_split	if enabled, the split (side/top) will not change regardless of what happens to the container.	bool	false
smart_split	if enabled, allows a more precise control over the window split direction based on the cursor’s position. The window is conceptually divided into four triangles, and cursor’s triangle determines the split direction. This feature also turns on preserve_split.	bool	false
smart_resizing	if enabled, resizing direction will be determined by the mouse’s position on the window (nearest to which corner). Else, it is based on the window’s tiling position.	bool	true
permanent_direction_override	if enabled, makes the preselect direction persist until either this mode is turned off, another direction is specified, or a non-direction is specified (anything other than l,r,u/t,d/b)	bool	false
special_scale_factor	specifies the scale factor of windows on the special workspace [0 - 1]	float	1
split_width_multiplier	specifies the auto-split width multiplier. Multiplying window size is useful on widescreen monitors where window W > H even after several splits.	float	1.0
use_active_for_splits	whether to prefer the active window or the mouse position for splits	bool	true
default_split_ratio	the default split ratio on window open. 1 means even 50/50 split. [0.1 - 1.9]	float	1.0
split_bias	specifies which window will receive the split ratio. 0 -> directional (the top or left window), 1 -> the current window	int	0
precise_mouse_move	bindm movewindow will drop the window more precisely depending on where your mouse is.	bool	false
single_window_aspect_ratio	whenever only a single window is shown on a screen, add padding so that it conforms to the specified aspect ratio. A value like 4 3 on a 16:9 screen will make it a 4:3 window in the middle with padding to the sides.	Vec2D	0 0
single_window_aspect_ratio_tolerance	sets a tolerance for single_window_aspect_ratio, so that if the padding that would have been added is smaller than the specified fraction of the height or width of the screen, it will not attempt to adjust the window size [0 - 1]	int	0.1
Bind Dispatchers 
dispatcher	description	params
pseudo	toggles the given window’s pseudo mode	left empty / active for current, or window for a specific window
Layout messages 
Dispatcher layoutmsg params:

param	description	args
togglesplit	toggles the split (top/side) of the current window. preserve_split must be enabled for toggling to work.	none
swapsplit	swaps the two halves of the split of the current window.	none
preselect	A one-time override for the split direction. (valid for the next window to be opened, only works on tiled windows)	direction
movetoroot	moves the selected window (active window if unspecified) to the root of its workspace tree. The default behavior maximizes the window in its current subtree. If unstable is provided as the second argument, the window will be swapped with the other subtree instead. It is not possible to only provide the second argument, but movetoroot active unstable will achieve the same result.	[window, [ string ]]
e.g.:

bind = SUPER, A, layoutmsg, preselect l

Last updated on October 4, 2025
Tearing
Master Layout
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Config
Dispatchers
Workspace Rules
Edit this page on GitHub →
Scroll to top 
Configuring
Master Layout
Master Layout
The master layout makes one (or more) window(s) be the “master”, taking (by default) the left part of the screen, and tiles the rest on the right. You can change the orientation on a per-workspace basis if you want to use anything other than the default left/right split.

master1

Config 
category name master

name	description	type	default
allow_small_split	enable adding additional master windows in a horizontal split style	bool	false
special_scale_factor	the scale of the special workspace windows. [0.0 - 1.0]	float	1
mfact	the size as a percentage of the master window, for example mfact = 0.70 would mean 70% of the screen will be the master window, and 30% the slave [0.0 - 1.0]	floatvalue	0.55
new_status	master: new window becomes master; slave: new windows are added to slave stack; inherit: inherit from focused window	string	slave
new_on_top	whether a newly open window should be on the top of the stack	bool	false
new_on_active	before, after: place new window relative to the focused window; none: place new window according to the value of new_on_top.	string	none
orientation	default placement of the master area, can be left, right, top, bottom or center	string	left
inherit_fullscreen	inherit fullscreen status when cycling/swapping to another window (e.g. monocle layout)	bool	true
slave_count_for_center_master	when using orientation=center, make the master window centered only when at least this many slave windows are open. (Set 0 to always_center_master)	int	2
center_master_fallback	Set fallback for center master when slaves are less than slave_count_for_center_master, can be left ,right ,top ,bottom	string	left
smart_resizing	if enabled, resizing direction will be determined by the mouse’s position on the window (nearest to which corner). Else, it is based on the window’s tiling position.	bool	true
drop_at_cursor	when enabled, dragging and dropping windows will put them at the cursor position. Otherwise, when dropped at the stack side, they will go to the top/bottom of the stack depending on new_on_top.	bool	true
always_keep_position	whether to keep the master window in its configured position when there are no slave windows	bool	false
Dispatchers 
layoutmsg commands:

command	description	params
swapwithmaster	swaps the current window with master. If the current window is the master, swaps it with the first child.	either master (new focus is the new master window), child (new focus is the new child) or auto (which is the default, keeps the focus of the previously focused window). Adding ignoremaster will ignore this dispatcher if master is already focused.
focusmaster	focuses the master window.	either master (focus stays on master), auto (default; focus first non-master window if already on master) or previous (remember current window when focusing master, if already on master, focus previous or fallback to auto).
cyclenext	focuses the next window respecting the layout	either loop (allow looping from the bottom of the pile back to master) or noloop (force stop at the bottom of the pile, like in DWM). loop is the default if left blank.
cycleprev	focuses the previous window respecting the layout	either loop (allow looping from master to the bottom of the pile) or noloop (force stop at master, like in DWM). loop is the default if left blank.
swapnext	swaps the focused window with the next window respecting the layout	either loop (allow swapping the bottom of the pile and master) or noloop (do not allow it, like in DWM). loop is the default if left blank.
swapprev	swaps the focused window with the previous window respecting the layout	either loop (allow swapping master and the bottom of the pile) or noloop (do not allow it, like in DWM). loop is the default if left blank.
addmaster	adds a master to the master side. That will be the active window, if it’s not a master, or the first non-master window.	none
removemaster	removes a master from the master side. That will be the active window, if it’s a master, or the last master window.	none
orientationleft	sets the orientation for the current workspace to left (master area left, slave windows to the right, vertically stacked)	none
orientationright	sets the orientation for the current workspace to right (master area right, slave windows to the left, vertically stacked)	none
orientationtop	sets the orientation for the current workspace to top (master area top, slave windows to the bottom, horizontally stacked)	none
orientationbottom	sets the orientation for the current workspace to bottom (master area bottom, slave windows to the top, horizontally stacked)	none
orientationcenter	sets the orientation for the current workspace to center (master area center, slave windows alternate to the left and right, vertically stacked)	none
orientationnext	cycle to the next orientation for the current workspace (clockwise)	none
orientationprev	cycle to the previous orientation for the current workspace (counter-clockwise)	none
orientationcycle	cycle to the next orientation from the provided list, for the current workspace	allowed values: left, top, right, bottom, or center. The values have to be separated by a space. If left empty, it will work like orientationnext
mfact	change mfact, the master split ratio	the new split ratio, a relative float delta (e.g -0.2 or +0.2) or exact followed by a the exact float value between 0.0 and 1.0
rollnext	rotate the next window in stack to be the master, while keeping the focus on master	none
rollprev	rotate the previous window in stack to be the master, while keeping the focus on master	none
Parameters for the commands are separated by a single space.

Example usage:

bind = MOD, KEY, layoutmsg, cyclenext
# behaves like xmonads promote feature (https://hackage.haskell.org/package/xmonad-contrib-0.17.1/docs/XMonad-Actions-Promote.html)
bind = MOD, KEY, layoutmsg, swapwithmaster master

Workspace Rules 
layoutopt rules:

rule	description	type
orientation:[o]	Sets the orientation of a workspace. For available orientations, see Config->orientation	string
Example usage:

workspace = 2, layoutopt:orientation:top

Last updated on October 4, 2025
Dwindle Layout
Permissions
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Permissions
Configuring permissions
Permission modes
Permission list
Notes
Edit this page on GitHub →
Scroll to top 
Configuring
Permissions
Permissions
If you have hyprland-qtutils installed, you can make use of Hyprland’s built-in permission system.

For now, it only has a few permissions, but it might include more in the future.

Permissions 
Permissions work a bit like Android ones. If an app tries to do something sensitive with the compositor (Hyprland), Hyprland will pop up a notification asking you if you want to let it do that.

Before setting up permissions, make sure you enable them by setting ecosystem:enforce_permissions = true, as it’s disabled by default.
Configuring permissions 
Permissions set up in the config are not reloaded on-the-fly and require a Hyprland restart for security reasons.
Configuring them is simple:

permission = regex, permission, mode

for example:

permission = /usr/bin/grim, screencopy, allow

Will allow /usr/bin/grim to always capture your screen without asking.

permission = /usr/bin/appsuite-.*, screencopy, allow

Will allow any app whose path starts with /usr/bin/appsuite- to capture your screen without asking.

Permission modes 
There are 3 modes:

allow: Don’t ask, just allow the app to proceed.
ask: Pop up a notification every time the app tries to do something sensitive. These popups allow you to Deny, Allow until the app exits, or Allow until Hyprland exits.
deny: Don’t ask, always deny the application access.
Permission list 
screencopy:

Default: ASK
Access to your screen without going through xdg-desktop-portal-hyprland. Examples include: grim, wl-screenrec, wf-recorder.
If denied, will render a black screen with a “permission denied” text.
Why deny? For apps / scripts that might maliciously try to capture your screen without your knowledge by using wayland protocols directly.
plugin:

Default: ASK
Access to load a plugin. Can be either a regex for the app binary, or plugin path.
Do not allow hyprctl to load your plugins by default (attacker could issue hyprctl plugin load /tmp/my-malicious-plugin.so) - use either deny to disable or ask to be prompted.
keyboard:

Default: ALLOW
Access to connecting a new keyboard. Regex of the device name.
If you want to disable all keyboards not matching a regex, make a rule that sets DENY for .* as the last keyboard permission rule.
Why deny? Rubber duckies, malicious virtual / usb keyboards.
Notes 
xdg-desktop-portal implementations (including xdph) are just regular applications. They will go through permissions too. You might want to consider adding a rule like this:

permission = /usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow

if you are not allowing screencopy for all apps.


NixOS does not have static paths for the binaries, so regex has to be used. These example rules allow grim and xdg-desktop-portal-hyprland to copy the screen:

permission = /nix/store/[a-z0-9]{32}-grim-[0-9.]*/bin/grim, screencopy, allow
permission = /nix/store/[a-z0-9]{32}-xdg-desktop-portal-hyprland-[0-9.]*/libexec/.xdg-desktop-portal-hyprland-wrapped, screencopy, allow

When rendering the configuration with Nix itself, string interpolation can also be used (be aware that if the path contains special regex characters (e.g. +) they need to be escaped):

permission = ${lib.getExe pkgs.grim}, screencopy, allow
permission = ${lib.escapeRegex (lib.getExe config.programs.hyprlock.package)}, screencopy, allow
permission = ${pkgs.xdg-desktop-portal-hyprland}/libexec/.xdg-desktop-portal-hyprland-wrapped, screencopy, allow


On some BSD systems paths might not work. In such cases, you might want to disable permissions altogether, by setting

ecosystem {
  enforce_permissions = false
}

otherwise, you have no config control over permissions (popups will still work, although will not show paths, and “remember” will not be available).

Last updated on October 4, 2025
Master Layout
Using hyprctl
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Commands
dispatch
keyword
reload
kill
setcursor
output
switchxkblayout
seterror
getprop
Notes
notify
dismissnotify
Info
Batch
Flags
Edit this page on GitHub →
Scroll to top 
Configuring
Using hyprctl
Using hyprctl
hyprctl is a utility for controlling some parts of the compositor from a CLI or a script. It should automatically be installed along with Hyprland.

hyprctl calls will be dispatched by the compositor synchronously, meaning any spam of the utility will cause slowdowns. It’s recommended to use --batch for many control calls, and limiting the amount of info calls.

For live event handling, see the socket2.

Commands 
dispatch 
Issue a dispatch to call a keybind dispatcher with an argument.

An argument has to be present, for dispatchers without parameters it can be anything.

To pass an argument starting with - or --, such as command line options to exec programs, pass -- as an option. This will disable any subsequent parsing of options by hyprctl.

Examples:

hyprctl dispatch exec kitty

hyprctl dispatch -- exec kitty --single-instance

hyprctl dispatch pseudo x

Returns: ok on success, an error message on fail.

See Dispatchers for a list of dispatchers.

keyword 
issue a keyword to call a config keyword dynamically.

Examples:

hyprctl keyword bind SUPER,O,pseudo

hyprctl keyword general:border_size 10

hyprctl keyword monitor DP-3,1920x1080@144,0x0,1

Returns: ok on success, an error message on fail.

reload 
Issue a reload to force reload the config.

kill 
Issue a kill to get into a kill mode, where you can kill an app by clicking on it. You can exit it with ESCAPE.

Kind of like xkill.

setcursor 
Sets the cursor theme and reloads the cursor manager. Will set the theme for everything except GTK, because GTK.

Please note that since 0.37.0, this only accepts hyprcursor themes. For legacy xcursor themes, use the XCURSOR_THEME and XCURSOR_SIZE env vars.

params: theme and size

e.g.:

hyprctl setcursor Bibata-Modern-Classic 24

output 
Allows you to add and remove fake outputs to your preferred backend.

Usage:

hyprctl output create [backend] (name)

or

hyprctl output remove [name]

Where [backend] is the name of the backend and (name) is an optional name for the output. If (name) is not specified, the default naming scheme will be used (HEADLESS-2, WL-1, etc.)

create and remove can also be add or destroy, respectively.
Available backends:

wayland: Creates an output as a Wayland window. This will only work if you’re already running Hyprland with the Wayland backend.
headless: Creates a headless monitor output. If you’re running a VNC/RDP/ Sunshine server, you should use this.
auto: Picks a backend for you. For example, if you’re running Hyprland from the TTY, headless will be chosen.
For example, to create a headless output named “test”:

hyprctl output create headless test

And to remove it:

hyprctl output remove test

switchxkblayout 
Sets the xkb layout index for a keyboard.

For example, if you set:

device {
    name = my-epic-keyboard-v1
    kb_layout = us,pl,de
}

You can use this command to switch between them.

hyprctl switchxkblayout [DEVICE] [CMD]

where CMD is either next for next, prev for previous, or ID for a specific one (in the above case, us: 0, pl: 1, de: 2). You can find the DEVICE using hyprctl devices command.

DEVICE can also be current or all, self-explanatory. Current is the main keyboard from devices.

Example command for a typical keyboard:

hyprctl switchxkblayout at-translated-set-2-keyboard next

If you want a single variant i.e. pl/dvorak on one layout but us/qwerty on the other, xkb parameters can still be blank, however the amount of comma-separated parameters have to match. Alternatively, a single parameter can be specified for it to apply to all three.

input {
    kb_layout = pl,us,ru
    kb_variant = dvorak,,
    kb_options = caps:ctrl_modifier
}

seterror 
Sets the hyprctl error string. Will reset when Hyprland’s config is reloaded.

hyprctl seterror 'rgba(66ee66ff)' hello world this is my problem

To disable:

hyprctl seterror disable

getprop 
Gets a property value of a window.

hyprctl getprop [window] [property]

Where window is as described here, and property is any which can be set with setprop.

Notes 
If animationstyle is unset, (unset) is returned.
minsize defaults to 20 20.
maxsize defaults to inf inf or [null,null] in JSON.
notify 
Sends a notification using the built-in Hyprland notification system.

hyprctl notify [ICON] [TIME_MS] [COLOR] [MESSAGE]

For example:

hyprctl notify -1 10000 "rgb(ff1ea3)" "Hello everyone!"

Icon of -1 means “No icon”

Color of 0 means “Default color for icon”

Icon list:

WARNING = 0
INFO = 1
HINT = 2
ERROR = 3
CONFUSED = 4
OK = 5

Optionally, you can specify a font size of the notification like so:

hyprctl notify -1 10000 "rgb(ff0000)" "fontsize:35 This text is big"

The default font-size is 13.

dismissnotify 
Dismisses all or up to AMOUNT notifications.

hyprctl dismissnotify # dismiss all notifications
hyprctl dismissnotify 2 # dismiss the oldest 2 notifications
hyprctl dismissnotify -1 # dismiss all notifications (same as no arguments)

Info 
version - prints the Hyprland version along with flags, commit and branch of build.
monitors - lists active outputs with their properties, 'monitors all' lists active and inactive outputs
workspaces - lists all workspaces with their properties
activeworkspace - gets the active workspace and its properties
workspacerules - gets the list of defined workspace rules
clients - lists all windows with their properties
devices - lists all connected keyboards and mice
decorations [window] - lists all decorations and their info
binds - lists all registered binds
activewindow - gets the active window name and its properties
layers - lists all the layers
splash - prints the current random splash
getoption [option] - gets the config option status (values)
cursorpos - gets the current cursor position in global layout coordinates
animations - gets the currently configured info about animations and beziers
instances - lists all running instances of Hyprland with their info
layouts - lists all layouts available (including from plugins)
configerrors - lists all current config parsing errors
rollinglog - prints tail of the log. Also supports -f/--follow option
locked - prints whether the current session is locked.
descriptions - returns a JSON with all config options, their descriptions and types.
submap - prints the current submap the keybinds are in

For the getoption command, the option name should be written as section:option, e.g.:

hyprctl getoption general:border_size

# For nested sections:
hyprctl getoption input:touchpad:disable_while_typing

See Variables for sections and options you can use.

Batch 
You can also use --batch to specify a batch of commands to execute.

e.g.

hyprctl --batch "keyword general:border_size 2 ; keyword general:gaps_out 20"

; separates the commands

Flags 
You can specify flags for the request like this:

hyprctl -j monitors

flag list:

j -> output in JSON
i -> select instance (id or index in hyprctl instances)

Last updated on October 4, 2025
Permissions
Expanding functionality
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Example script
Edit this page on GitHub →
Scroll to top 
Configuring
Expanding functionality
Expanding functionality
Hyprland exposes two powerful sockets for you to use.

The first, socket1, can be fully controlled with hyprctl, see its usage here.

The second, socket2, sends events for certain changes / actions and can be used to react to different events. See its description here.

Example script 
This bash script will change the outer gaps to 20 if the currently focused monitor is DP-1, and 30 otherwise.

#!/usr/bin/env bash

function handle {
  if [[ ${1:0:10} == "focusedmon" ]]; then
    if [[ ${1:12:4} == "DP-1" ]]; then
      hyprctl keyword general:gaps_out 20
    else
      hyprctl keyword general:gaps_out 30
    fi
  fi
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done

Last updated on October 4, 2025
Using hyprctl
XWayland
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

HiDPI XWayland
Abstract Unix domain socket
Edit this page on GitHub →
Scroll to top 
Configuring
XWayland
XWayland
XWayland is the bridging mechanism between legacy Xorg programs and Wayland compositors.

HiDPI XWayland 
XWayland currently looks pixelated on HiDPI screens, due to Xorg’s inability to scale.

This problem is mitigated by the xwayland:force_zero_scaling option, which forces XWayland windows not to be scaled.

This will get rid of the pixelated look, but will not scale applications properly. To do this, each toolkit has its own mechanism.

# change monitor to high resolution, the last argument is the scale factor
monitor = , highres, auto, 2

# unscale XWayland
xwayland {
  force_zero_scaling = true
}

# toolkit-specific scale
env = GDK_SCALE,2
env = XCURSOR_SIZE,32

The GDK_SCALE variable won’t conflict with Wayland-native GTK programs.

XWayland HiDPI patches are no longer supported. Do not use them.
Abstract Unix domain socket 
X11 applications use Unix domain sockets to communicate with XWayland. On Linux, libX11 prefers to use the abstract Unix domain socket. This type of socket uses a separate, abstract namespace that is independent of the host filesystem. This makes abstract sockets more flexible but harder to isolate for some kinds of sandboxes like Flatpak. However, removing the abstract socket has potential security and compatibility issues.

Keeping that in mind, we add the xwayland:create_abstract_socket option. When the abstract socket is disabled, only the regular Unix domain socket will be created.

* Abstract Unix domain sockets are available only on Linux-based systems

Last updated on October 4, 2025
Expanding functionality
Environment variables
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Hyprland Environment Variables
Aquamarine Environment Variables
Toolkit Backend Variables
XDG Specifications
Qt Variables
NVIDIA Specific
Theming Related Variables
Edit this page on GitHub →
Scroll to top 
Configuring
Environment variables
Environment variables
uwsm users should avoid placing environment variables in the hyprland.conf file.
Instead, use ~/.config/uwsm/env for theming, xcursor, Nvidia and toolkit variables, and ~/.config/uwsm/env-hyprland for HYPR* and AQ_* variables.
The format is export KEY=VAL.

export XCURSOR_SIZE=24

See uwsm readme for additional information.

You can use the env keyword to set environment variables prior to the initialization of the Display Server, e.g.:

env = GTK_THEME,Nord

Note that when using the env keyword, Hyprland reads the value of the variable as a raw string and puts it into the environment as is.
You should NOT add quotes "" around the values.

Some examples with differently formatted values:

✗ DON’T:

env = QT_AUTO_SCREEN_SCALE_FACTOR,"1"
env = QT_QPA_PLATFORM,"wayland"
env = QT_QPA_PLATFORM,"wayland;xcb"
env = AQ_DRM_DEVICES=,"/dev/dri/card1:/dev/dri/card0"

✓ Instead, DO:

env = QT_AUTO_SCREEN_SCALE_FACTOR,1
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORM,wayland;xcb
env = AQ_DRM_DEVICES=,/dev/dri/card1:/dev/dri/card0

Please avoid putting those environment variables in /etc/environment.
That will cause all sessions (including Xorg ones) to pick up your Wayland-specific environment on traditional Linux distros.
Hyprland Environment Variables 
HYPRLAND_TRACE=1 - Enables more verbose logging.
HYPRLAND_NO_RT=1 - Disables realtime priority setting by Hyprland.
HYPRLAND_NO_SD_NOTIFY=1 - If systemd, disables the sd_notify calls.
HYPRLAND_NO_SD_VARS=1 - Disables management of variables in systemd and dbus activation environments.
HYPRLAND_CONFIG - Specifies where you want your Hyprland configuration.
Aquamarine Environment Variables 
AQ_TRACE=1 - Enables more verbose logging.
AQ_DRM_DEVICES= - Set an explicit list of DRM devices (GPUs) to use. It’s a colon-separated list of paths, with the first being the primary. E.g.: /dev/dri/card1:/dev/dri/card0
AQ_FORCE_LINEAR_BLIT=0 - Disables forcing linear explicit modifiers on Multi-GPU buffers to potentially workaround Nvidia issues.
AQ_MGPU_NO_EXPLICIT=1 - Disables explicit syncing on mgpu buffers.
AQ_NO_MODIFIERS=1 - Disables modifiers for DRM buffers.
Toolkit Backend Variables 
env = GDK_BACKEND,wayland,x11,* - GTK: Use Wayland if available; if not, try X11 and then any other GDK backend.
env = QT_QPA_PLATFORM,wayland;xcb - Qt: Use Wayland if available, fall back to X11 if not.
env = SDL_VIDEODRIVER,wayland - Run SDL2 applications on Wayland. Remove or set to x11 if games that provide older versions of SDL cause compatibility issues
env = CLUTTER_BACKEND,wayland - Clutter package already has Wayland enabled, this variable will force Clutter applications to try and use the Wayland backend
XDG Specifications 
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
XDG specific environment variables are often detected through portals and applications that may set those for you, however it is not a bad idea to set them explicitly.

If your desktop portal is malfunctioning for seemingly no reason (no errors), it’s likely your XDG env isn’t set correctly.

uwsm users don’t need to explicitly set XDG environment variables, as uwsm sets them automatically.
Qt Variables 
env = QT_AUTO_SCREEN_SCALE_FACTOR,1 - (From the Qt documentation) enables automatic scaling, based on the monitor’s pixel density
env = QT_QPA_PLATFORM,wayland;xcb - Tell Qt applications to use the Wayland backend, and fall back to X11 if Wayland is unavailable
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1 - Disables window decorations on Qt applications
env = QT_QPA_PLATFORMTHEME,qt5ct - Tells Qt based applications to pick your theme from qt5ct, use with Kvantum.
NVIDIA Specific 
To force GBM as a backend, set the following environment variables:

env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
See Archwiki Wayland Page for more details on those variables.

env = LIBVA_DRIVER_NAME,nvidia - Hardware acceleration on NVIDIA GPUs
See Archwiki Hardware Acceleration Page for details and necessary values before setting this variable.

__GL_GSYNC_ALLOWED - Controls if G-Sync capable monitors should use Variable Refresh Rate (VRR)
See Nvidia Documentation for details.

__GL_VRR_ALLOWED - Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid having problems on some games.

env = AQ_NO_ATOMIC,1 - use legacy DRM interface instead of atomic mode setting. NOT recommended.

Theming Related Variables 
GTK_THEME - Set a GTK theme manually, for those who want to avoid appearance tools such as lxappearance or nwg-look.
XCURSOR_THEME - Set your cursor theme. The theme needs to be installed and readable by your user.
XCURSOR_SIZE - Set cursor size. See here for why you might want this variable set.
Last updated on October 4, 2025
XWayland
Multi-GPU
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

General
Detecting GPUs
Telling Hyprland which GPU to use
Creating consistent device paths for specific cards
Edit this page on GitHub →
Scroll to top 
Configuring
Multi-GPU
Multi-GPU
General 
If your host machine uses multiple GPUs, you may want to use one GPU for rendering all the elements for Hyprland including windows, animations, and another for hardware acceleration for certain applications, etc.

This setup is very common in the likes of gaming laptops, GPU-passthrough (without VFIO) capable hosts, and if you have multiple GPUs in general.

Detecting GPUs 
For this case, the writer is taking the example of their laptop.

Upon running lspci -d ::03xx, one can list all the PCI display controllers available.

01:00.0 VGA compatible controller: NVIDIA Corporation TU117M [GeForce GTX 1650 Mobile / Max-Q] (rev a1)
06:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Cezanne [Radeon Vega Series / Radeon Vega Mobile Series] (rev c6)

Here it is clear that 2 GPUs are available, the dedicated NVIDIA GTX 1650 Mobile / Max-Q and the integrated AMD Cezanne Radeon Vega Series GPU.

Now, run ls -l /dev/dri/by-path

 total 0
lrwxrwxrwx 1 root root  8 Jul 14 15:45 pci-0000:01:00.0-card -> ../card0
lrwxrwxrwx 1 root root 13 Jul 14 15:45 pci-0000:01:00.0-render -> ../renderD128
lrwxrwxrwx 1 root root  8 Jul 14 15:45 pci-0000:06:00.0-card -> ../card1
lrwxrwxrwx 1 root root 13 Jul 14 15:45 pci-0000:06:00.0-render -> ../renderD129

So from the above outputs, we can see that the path for the AMD card is pci-0000:06:00.0-card, due to the matching 06:00.0 from the first command. Do not use the card1 symlink indicated here. It is dynamically assigned at boot and is subject to frequent change, making it unsuitable as a marker for GPU selection.

Telling Hyprland which GPU to use 
After determining which “card” belongs to which GPU, we can now tell Hyprland which GPUs to use by setting the AQ_DRM_DEVICES environment variable.

It is generally a good idea for laptops to use the integrated GPU as the primary renderer as this preserves battery life and is practically indistinguishable from using the dedicated GPU on modern systems in most cases. Hyprland can be run on integrated GPUs just fine. The same principle applies for desktop setups with lower and higher power rating GPUs respectively.
If you would like to use another GPU, or the wrong GPU is picked by default, set AQ_DRM_DEVICES to a :-separated list of card paths, e.g.

env = AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1

Here, we tell Hyprland which GPUs it’s allowed to use, in order of priority. For example, card0 will be the primary renderer, but if it isn’t available for whatever reason, then card1 is primary.

Do note that if you have an external monitor connected to, for example card1, that card must be included in AQ_DRM_DEVICES for the monitor to work, though it doesn’t have to be the primary renderer.

You should now be able to use an integrated GPU for lighter GPU loads, including Hyprland, or default to your dGPU if you prefer.

uwsm users are advised to export the AQ_DRM_DEVICES variable inside ~/.config/uwsm/env-hyprland, instead. This method ensures that the variable is properly exported to the systemd environment without conflicting with other compositors or desktop environments.

export AQ_DRM_DEVICES="/dev/dri/card0:/dev/dri/card1"

Creating consistent device paths for specific cards 
As mentioned above, it’s not recommended to use the /dev/dri/card* device paths since they periodically change which device they are symlinked to. Furthermore, the colons in the actual card device paths are not usable in the AQ_DRM_DEVICES environment variable since colons : are used as a separator for multiple paths.

It’s possible to use udev rules to create reliable symlinks to particular device cards. For example, to create a symlink to an AMD card at the path /dev/dri/amd-igpu, we can create a udev rule at /etc/udev/rules.d/amd-igpu-dev-path.rules programmatically like so:

SYMLINK_NAME="amd-igpu"
RULE_PATH="/etc/udev/rules.d/amd-igpu-dev-path.rules"
AMD_IGPU_ID=$(lspci -d ::03xx | grep 'AMD' | cut -f1 -d' ')
UDEV_RULE="$(cat <<EOF
KERNEL=="card*", \
KERNELS=="0000:$AMD_IGPU_ID", \
SUBSYSTEM=="drm", \
SUBSYSTEMS=="pci", \
SYMLINK+="dri/$SYMLINK_NAME"
EOF
)"

echo "$UDEV_RULE" | sudo tee "$RULE_PATH"

Then reloading the udev rules with:

sudo udevadm control --reload
sudo udevadm trigger

There should now be a symlink at /dev/dri/amd-igpu that points to your respective card file:

$ ls -l /dev/dri/amd-igpu
lrwxrwxrwx 1 root root 5 /dev/dri/amd-igpu -> card1

This symlink will automatically update to point to correct card file if it ever changes.

Now it is possible to use the new symlink in the AQ_DRM_DEVICES environment variable:

env = AQ_DRM_DEVICES, /dev/dri/amd-igpu

Last updated on October 4, 2025
Environment variables
Uncommon tips & tricks
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Switchable keyboard layouts
Disabling keybinds with one master keybind
Remapping Caps Lock
Set F13-F24 as usual function keys
Minimize windows using special workspaces
Show desktop
Minimize Steam instead of killing
Shimeji
Toggle animations/blur/etc hotkey
Zoom
Alt tab behaviour
Edit this page on GitHub →
Scroll to top 
Configuring
Uncommon tips & tricks
Uncommon tips & tricks
Switchable keyboard layouts 
The easiest way to accomplish this is to set this using XKB settings, for example:

input {
    kb_layout = us,cz
    kb_variant = ,qwerty
    kb_options = grp:alt_shift_toggle
}

Variants are set per layout.

The first layout defined in the input section will be the one used for binds by default.

For example: us,ua -> config binds would be e.g. SUPER, A, while on ua,us -> SUPER, Cyrillic_ef

You can change this behavior globally or per-device by setting resolve_binds_by_sym = 1. In that case, binds will activate when the symbol typed matches the symbol specified in the bind.

For example: if your layouts are us,fr and have a bind for SUPER, A you’d need to press the first letter on the second row while the us layout is active and the first letter on the first row while the fr layout is active.

You can also bind a key to execute hyprctl switchxkblayout for more keybind freedom. See Using hyprctl.

To find the valid layouts and kb_options, you can check out the /usr/share/X11/xkb/rules/base.lst. For example:

To get the layout name of a language:

grep -i 'persian' /usr/share/X11/xkb/rules/base.lst

To get the list of keyboard shortcuts you can put in the kb_options to toggle keyboard layouts:

grep 'grp:.*toggle' /usr/share/X11/xkb/rules/base.lst

Disabling keybinds with one master keybind 
If you want to disable all keybinds with another keybind (make a keybind toggle of sorts) you can just use a submap with only a keybind to exit it.

bind = MOD, KEY, submap, clean
submap = clean
bind = MOD, KEY, submap, reset
submap = reset

Remapping Caps Lock 
You can customize the behavior of the Caps Lock key using kb_options.

To view all available options related to Caps Lock, run:

grep 'caps' /usr/share/X11/xkb/rules/base.lst

For example, to remap Caps lock to Ctrl:

input {
    kb_options = ctrl:nocaps
}

To swap Caps Lock and Escape:

input {
    kb_options = caps:swapescape
}

You can also find additional kb_options unrelated to Caps Lock in /usr/share/X11/xkb/rules/base.lst.

Set F13-F24 as usual function keys 
By default, F13-F24 are mapped by xkb as various “XF86” keysyms. These cause binding issues in many programs. One example is OBS Studio, which does not detect the XF86 keysyms as usable keybindings, making you unable to use them for binds. This option simply maps them back to the expected F13-F24 values, which are bindable as normal.

This option was only added recently to xkeyboard-config. Please ensure you are on version 2.43 or greater for this option to do anything.
input {
    kb_options = fkeys:basic_13-24
}

Minimize windows using special workspaces 
This approach uses special workspaces to mimic the “minimize window” function, by using a single keybind to toggle the minimized state. Note that one keybind can only handle one window.

bind = $mod, S, togglespecialworkspace, magic
bind = $mod, S, movetoworkspace, +0
bind = $mod, S, togglespecialworkspace, magic
bind = $mod, S, movetoworkspace, special:magic
bind = $mod, S, togglespecialworkspace, magic

Show desktop 
This approach uses same principle as the Minimize windows using special workspaces section. It moves all windows from current workspace to a special workspace named desktop. Showing desktop state is remembered per workspace.

Create a script:

#!/bin/env sh

TMP_FILE="$XDG_RUNTIME_DIR/hyprland-show-desktop"

CURRENT_WORKSPACE=$(hyprctl monitors -j | jq '.[] | .activeWorkspace | .name' | sed 's/"//g')

if [ -s "$TMP_FILE-$CURRENT_WORKSPACE" ]; then
  readarray -d $'\n' -t ADDRESS_ARRAY <<< $(< "$TMP_FILE-$CURRENT_WORKSPACE")

  for address in "${ADDRESS_ARRAY[@]}"
  do
    CMDS+="dispatch movetoworkspacesilent name:$CURRENT_WORKSPACE,address:$address;"
  done

  hyprctl --batch "$CMDS"

  rm "$TMP_FILE-$CURRENT_WORKSPACE"
else
  HIDDEN_WINDOWS=$(hyprctl clients -j | jq --arg CW "$CURRENT_WORKSPACE" '.[] | select (.workspace .name == $CW) | .address')

  readarray -d $'\n' -t ADDRESS_ARRAY <<< $HIDDEN_WINDOWS

  for address in "${ADDRESS_ARRAY[@]}"
  do
    address=$(sed 's/"//g' <<< $address )

    if [[ -n address ]]; then
      TMP_ADDRESS+="$address\n"
    fi

    CMDS+="dispatch movetoworkspacesilent special:desktop,address:$address;"
  done

  hyprctl --batch "$CMDS"

  echo -e "$TMP_ADDRESS" | sed -e '/^$/d' > "$TMP_FILE-$CURRENT_WORKSPACE"
fi

then bind it:

  bind = $mainMod , D, exec, <PATH TO SCRIPT>

Minimize Steam instead of killing 
Steam will exit entirely when its last window is closed using the killactive dispatcher. To minimize Steam to tray, use the following script to close applications:

if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Steam" ]; then
    xdotool getactivewindow windowunmap
else
    hyprctl dispatch killactive ""
fi

Shimeji 
To use Shimeji programs like this, set the following rules:

windowrule = float, class:com-group_finity-mascot-Main
windowrule = noblur, class:com-group_finity-mascot-Main
windowrule = nofocus, class:com-group_finity-mascot-Main
windowrule = noshadow, class:com-group_finity-mascot-Main
windowrule = noborder, class:com-group_finity-mascot-Main

The app indicator probably won’t show, so you’ll have to killall -9 java to kill them.
Demo GIF of Spamton Shimeji

Toggle animations/blur/etc hotkey 
For increased performance in games, or for less distractions at a keypress

create file ~/.config/hypr/gamemode.sh && chmod +x ~/.config/hypr/gamemode.sh and add:
#!/usr/bin/env sh
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword animation borderangle,0; \
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
	    keyword decoration:fullscreen_opacity 1;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    hyprctl notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
    exit
else
    hyprctl notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
    hyprctl reload
    exit 0
fi
exit 1

Edit to your liking of course. If animations are enabled, it disables all the pretty stuff. Otherwise, the script reloads your config to grab your defaults.

Add this to your hyprland.conf:
bind = WIN, F1, exec, ~/.config/hypr/gamemode.sh

The hotkey toggle will be WIN+F1, but you can change this to whatever you want.

Zoom 
To zoom using Hyprland’s built-in zoom utility

If mouse wheel bindings work only for the first time, you should probably reduce reset time with binds:scroll_event_delay
bind = $mod, mouse_down, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')
bind = $mod, mouse_up, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')

binde = $mod, equal, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')
binde = $mod, minus, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')
binde = $mod, KP_ADD, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')
binde = $mod, KP_SUBTRACT, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')

bind = $mod SHIFT, mouse_up, exec, hyprctl -q keyword cursor:zoom_factor 1
bind = $mod SHIFT, mouse_down, exec, hyprctl -q keyword cursor:zoom_factor 1
bind = $mod SHIFT, minus, exec, hyprctl -q keyword cursor:zoom_factor 1
bind = $mod SHIFT, KP_SUBTRACT, exec, hyprctl -q keyword cursor:zoom_factor 1
bind = $mod SHIFT, 0, exec, hyprctl -q keyword cursor:zoom_factor 1

Alt tab behaviour 
To mimic DE’s alt-tab behaviour. Here is an example that uses foot, fzf, grim-hyprland and chafa to the screenshot in the terminal.

alttab

Dependencies :

foot
fzf
grim-hyprland
chafa
jq
add this to your config
exec-once = foot --server

bind = ALT, TAB, exec, $HOME/.config/hypr/scripts/alttab/enable.sh 'down'
bind = ALT SHIFT, TAB, exec, $HOME/.config/hypr/scripts/alttab/enable.sh 'up'

submap=alttab
bind = ALT, tab, sendshortcut, , tab, class:alttab
bind = ALT SHIFT, tab, sendshortcut, shift, tab, class:alttab

bindrt = ALT, ALT_L, exec, $XDG_CONFIG_HOME/hypr/scripts/alttab/disable.sh ; hyprctl -q dispatch sendshortcut , return,class:alttab
bindrt = ALT SHIFT, ALT_L, exec, $XDG_CONFIG_HOME/hypr/scripts/alttab/disable.sh ; hyprctl -q dispatch sendshortcut , return,class:alttab
bind = ALT, Return, exec, $XDG_CONFIG_HOME/hypr/scripts/alttab/disable.sh ; hyprctl -q dispatch sendshortcut , return, class:alttab
bind = ALT SHIFT, Return, exec, $XDG_CONFIG_HOME/hypr/scripts/alttab/disable.sh ; hyprctl -q dispatch sendshortcut , return, class:alttab
bind = ALT, escape, exec, $XDG_CONFIG_HOME/hypr/scripts/alttab/disable.sh ; hyprctl -q dispatch sendshortcut , escape,class:alttab
bind = ALT SHIFT, escape, exec, $XDG_CONFIG_HOME/hypr/scripts/alttab/disable.sh ; hyprctl -q dispatch sendshortcut , escape,class:alttab
submap = reset

workspace = special:alttab, gapsout:0, gapsin:0, bordersize:0
windowrule = noanim, class:alttab
windowrule = stayfocused, class:alttab
windowrule = workspace special:alttab, class:alttab
windowrule = bordersize 0, class:alttab

create file touch $XDG_CONFIG_HOME/hypr/scripts/alttab/alttab.sh && chmod +x $XDG_CONFIG_HOME/hypr/scripts/alttab/alttab.sh and add:
alttab.sh
#!/usr/bin/env bash
start=$1
address=$(hyprctl -j clients | jq -r 'sort_by(.focusHistoryID) | .[] | select(.workspace.id >= 0) | "\(.address)\t\(.title)"' |
	      fzf --color prompt:green,pointer:green,current-bg:-1,current-fg:green,gutter:-1,border:bright-black,current-hl:red,hl:red \
		  --cycle \
		  --sync \
		  --bind tab:down,shift-tab:up,start:$start,double-click:ignore \
		  --wrap \
		  --delimiter=$'\t' \
		  --with-nth=2 \
		  --preview "$XDG_CONFIG_HOME/hypr/scripts/alttab/preview.sh {}" \
		  --preview-window=down:80% \
		  --layout=reverse |
	      awk -F"\t" '{print $1}')

if [ -n "$address" ] ; then
    hyprctl --batch -q "dispatch focuswindow address:$address ; dispatch alterzorder top"
fi

hyprctl -q dispatch submap reset

I chose to exclude windows that are in special workspaces but it can be modified by removing select(.workspace.id >= 0)

create file touch $XDG_CONFIG_HOME/hypr/scripts/alttab/preview.sh && chmod +x $XDG_CONFIG_HOME/hypr/scripts/alttab/preview.sh and add:
preview.sh
#!/usr/bin/env bash
line="$1"

IFS=$'\t' read -r addr _ <<< "$line"
dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}

grim -t png -l 0 -w "$addr" ~/.config/hypr/scripts/alttab/preview.png
chafa --animate false -s "$dim" "$XDG_CONFIG_HOME/hypr/scripts/alttab/preview.png"

create file touch $XDG_CONFIG_HOME/hypr/scripts/alttab/disable.sh && chmod +x $XDG_CONFIG_HOME/hypr/scripts/alttab/disable.sh and add:
disable.sh
#!/usr/bin/env bash
hyprctl -q keyword animations:enabled true

hyprctl -q --batch "keyword unbind ALT, TAB ; keyword unbind ALT SHIFT, TAB ; keyword bind ALT, TAB, exec, $HOME/.config/hypr/scripts/alttab/enable.sh 'down' ; keyword bind ALT SHIFT, TAB, exec, $HOME/.config/hypr/scripts/alttab/enable.sh 'up'"

create file touch $XDG_CONFIG_HOME/hypr/scripts/alttab/enable.sh && chmod +x $XDG_CONFIG_HOME/hypr/scripts/alttab/enable.sh and add:
enable.sh
#!/usr/bin/env bash
hyprctl -q --batch "keyword animations:enabled false ; dispatch exec footclient -a alttab ~/.config/hypr/scripts/alttab/alttab.sh $1 ; keyword unbind ALT, TAB ; keyword unbind ALT SHIFT, TAB ; dispatch submap alttab"

Last updated on October 4, 2025
Multi-GPU
Example configurations
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Start
Variables
Keywords
Monitors
Binds
Dispatchers
Window Rules
Workspace Rules
Animations
Gestures
Tearing
Dwindle Layout
Master Layout
Permissions
Using hyprctl
Expanding functionality
XWayland
Environment variables
Multi-GPU
Uncommon tips & tricks
Example configurations
Performance
Hypr Ecosystem
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Fractional scaling
Low FPS/stutter/FPS drops on Intel iGPU with TLP (mainly laptops)
How do I make Hyprland draw as little power as possible on my laptop?
My games work poorly, especially proton ones
Edit this page on GitHub →
Scroll to top 
Configuring
Performance
Performance
This page documents known tricks and fixes to boost performance if by any chance you stumble upon problems or you do not care that much about animations.

Fractional scaling 
Wayland fractional scaling is a lot better than before, but it is not perfect. Some applications do not support it yet or the support is experimental at best. If you have problems with your graphics card having high usage or Hyprland feeling laggy, try setting the scaling to integer numbers such as 1 or 2 like in this example monitor=,preferred,auto,2.

Low FPS/stutter/FPS drops on Intel iGPU with TLP (mainly laptops) 
The TLP defaults are rather aggressive, setting INTEL_GPU_MIN_FREQ_ON_AC and/or INTEL_GPU_MIN_FREQ_ON_BAT in /etc/tlp.conf to something slightly higher (e.g. to 500 from 300) will reduce stutter significantly or, in the best case, remove it completely.

How do I make Hyprland draw as little power as possible on my laptop? 
Useful Optimizations:

decoration:blur:enabled = false and decoration:shadow:enabled = false to disable fancy but battery hungry effects.

misc:vfr = true, since it’ll lower the amount of sent frames when nothing is happening on-screen.

My games work poorly, especially proton ones 
Using gamescope tends to fix any and all issues with Wayland/Hyprland.

Last updated on October 4, 2025
Example configurations
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Hypr Ecosystem
hyprpaper
hyprpicker
hypridle
hyprlock
xdg-desktop-portal-hyprland
hyprsunset
hyprpolkitagent
hyprsysteminfo
hyprland-qt-support
hyprqt6engine
hyprtoolkit
hyprcursor
hyprutils
hyprlang
hyprwayland-scanner
aquamarine
hyprgraphics
hyprland-qtutils
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Installing
Usage
Share picker doesn’t use the system theme
Using the KDE file picker with XDPH
Debugging
Configuration
category screencopy
Edit this page on GitHub →
Scroll to top 
Hypr Ecosystem
xdg-desktop-portal-hyprland
xdg-desktop-portal-hyprland
An XDG Desktop Portal is a program that lets other applications communicate with the compositor through D-Bus.

A portal implements certain functionalities, such as opening file pickers or screen sharing.

xdg-desktop-portal-hyprland is Hyprland’s xdg-desktop-portal implementation. It allows for screensharing, global shortcuts, etc.

Throughout this document, xdg-desktop-portal-hyprland will be referred to as XDPH.
XDPH doesn’t implement a file picker. For that, it is recommended to install xdg-desktop-portal-gtk alongside XDPH.
Installing 
pacman -S xdg-desktop-portal-hyprland

or, for -git:

yay -S xdg-desktop-portal-hyprland-git

Usage 
XDPH is automatically started by D-Bus, once Hyprland starts.

To check if everything is OK is, try to screenshare anything, or opening OBS and select the PipeWire source. If XDPH is running, a Qt menu will pop up asking you what to share.

XDPH will work on other wlroots compositors, but features available only on Hyprland will not work (e.g. window sharing).

For a nuclear option, you can use this script and exec-once it:

#!/bin/sh
sleep 1
killall -e xdg-desktop-portal-hyprland
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &

Adjust the paths if they’re incorrect.

Share picker doesn’t use the system theme 
Try one or both:

dbus-update-activation-environment --systemd --all
systemctl --user import-environment QT_QPA_PLATFORMTHEME

If it works, add it to your config in exec-once.

Using the KDE file picker with XDPH 
XDPH does not implement a file picker and uses the GTK one as a fallback by default (see /usr/share/xdg-desktop-portal/hyprland-portals.conf). If you want to use the KDE file picker but let XDPH handle everything else, create a file ~/.config/xdg-desktop-portal/hyprland-portals.conf with the following content:

~/.config/xdg-desktop-portal/hyprland-portals.conf
[preferred]
default = hyprland;gtk
org.freedesktop.impl.portal.FileChooser = kde

You can read more about this in the xdg-desktop-portal documentation in the Arch Wiki. Note that some applications like Firefox may require additional configuration to use the KDE file picker.

Debugging 
If you get long app launch times, or screensharing does not work, consult the logs.

systemctl --user status xdg-desktop-portal-hyprland

If you see a crash, it’s likely you are missing either qt6-wayland or qt5-wayland.

If the portal does not autostart, does not function when manually started, and does not produce any error logs, it’s very likely your XDG env variables are messed up

Configuration 
Example:

screencopy {
    max_fps = 60
}

Config file ~/.config/hypr/xdph.conf allows for these variables:

category screencopy 
variable	description	type	default value
max_fps	Maximum fps of a screensharing session. 0 means no limit.	int	120
allow_token_by_default	If enabled, will tick the “Allow restore token” box by default	bool	false
custom_picker_binary	If non-empty, will use that binary as your share picker. Please note that it has to conform to the stdout selection layout of hyprland-share-picker.	string	“hyprland-share-picker”
Last updated on October 4, 2025
hyprlock
hyprsunset
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Hypr Ecosystem
hyprpaper
hyprpicker
hypridle
hyprlock
xdg-desktop-portal-hyprland
hyprsunset
hyprpolkitagent
hyprsysteminfo
hyprland-qt-support
hyprqt6engine
hyprtoolkit
hyprcursor
hyprutils
hyprlang
hyprwayland-scanner
aquamarine
hyprgraphics
hyprland-qtutils
Useful Utilities
Plugins
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Usage
Edit this page on GitHub →
Scroll to top 
Hypr Ecosystem
hyprpolkitagent
hyprpolkitagent
hyprpolkitagent is a polkit authentication daemon. It is required for GUI applications to be able to request elevated privileges.

If it’s not available in your distro’s repositories, you can either build it from source or use a different agent, e.g. KDE’s one.

Usage 
Add exec-once = systemctl --user start hyprpolkitagent to your Hyprland config and restart hyprland. (obviously change that to whatever you are using if you are not using the hypr one)

If Hyprland is started with uwsm, you can autostart the polkit agent with the command systemctl --user enable --now hyprpolkitagent.service.

On distributions that use a different init system, such as Gentoo, it may be necessary to use exec-once=/usr/lib64/libexec/hyprpolkitagent instead.

Other possible paths include /usr/lib/hyprpolkitagent and /usr/libexec/hyprpolkitagent.

Last updated on October 4, 2025
hyprsunset
hyprsysteminfo
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Hypr Ecosystem
Useful Utilities
Plugins
Using plugins
Development
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Disclaimers
Getting plugins
Installing / Using plugins
hyprpm
Manual
FAQ About Plugins
My Hyprland crashes!
How do I list my loaded plugins?
How do I make my own plugin?
Where do I find plugins?
Are plugins safe?
Do plugins decrease Hyprland’s stability?
Edit this page on GitHub →
Scroll to top 
Plugins
Using plugins
Using plugins
This page will tell you how to use plugins.

Disclaimers 
Plugins are written in C++ and will run as a part of Hyprland.

Make sure to always read the source code of the plugins you are going to use and to trust the source.

Writing a plugin to wipe your computer is easy.

Never trust random .so files you receive from other people.

Getting plugins 
Plugins come as shared objects, aka. .so files.

Hyprland does not have any “default” plugins, so any plugin you may want to use you will have to find yourself.

Installing / Using plugins 
It is highly recommended you use the Hyprland Plugin Manager, hyprpm. For manual instructions, see here.

hyprpm 
If you are using permission management, you should allow hyprpm to load plugins by adding this to your config:

permission = /usr/(bin|local/bin)/hyprpm, plugin, allow

otherwise you’ll get a popup asking for permission every time hyprpm tries to load a plugin.

Make sure you have the required dependencies: cpio, cmake, git, meson and gcc. You might also need -dev packages of Hyprland’s dependencies if your distro splits binaries and headers (e.g. Fedora or Debian).

Find a repository you want to install plugins from. As an example, we will use hyprland-plugins.

hyprpm add https://github.com/hyprwm/hyprland-plugins

Once it finishes, you can list your installed plugins with:

hyprpm list

Then, enable or disable them via hyprpm enable name and hyprpm disable name.

In order for the plugins to be loaded into Hyprland, run hyprpm reload.

You can add exec-once = hyprpm reload -n to your Hyprland config to have plugins loaded at startup. -n will make hyprpm send a notification for good and bad events (e.g. update needed, plugin loaded successfully) or use -nn to get notified only on failed events.

To update your plugins, run hyprpm update.

For all options of hyprpm, run hyprpm -h.

Manual 
Different plugins may have different build methods, refer to their instructions.

If you don’t have Hyprland headers installed, clone Hyprland, checkout to your version, build Hyprland, and run sudo make installheaders. Then build your plugin(s).

To load plugins manually, use hyprctl plugin load path.

You can unload plugins with hyprctl plugin unload path.

Path has to be absolute!
FAQ About Plugins 
My Hyprland crashes! 
Oh no. Oopsie. Usually means a plugin is broken. hyprpm disable it.

How do I list my loaded plugins? 
hyprctl plugin list

How do I make my own plugin? 
See here.

Where do I find plugins? 
You can find our featured plugins at hypr.land/plugins. You can also see a list at awesome-hyprland. Note that it may not be complete. Lastly, you can try searching around github for the "hyprland plugin" keyword.

Are plugins safe? 
As long as you read the source code of your plugin(s) and can see there’s nothing bad going on, they will be safe.

Do plugins decrease Hyprland’s stability? 
Hyprland employs a few tactics to unload plugins that crash. However, those tactics may not always work. In general, as long as the plugin is well-designed, it should not affect the stability of Hyprland.

Last updated on October 4, 2025
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Hypr Ecosystem
Useful Utilities
Plugins
Using plugins
Development
Getting started
Plugin guidelines
Event list
Advanced
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

How do plugins work?
Prerequisites
Making your first plugin
The basic parts of the plugin
Setting up a development environment
More advanced stuff
Edit this page on GitHub →
Scroll to top 
Plugins
Development
Getting started
Getting started
This page documents the basics of making your own Hyprland plugin from scratch.

How do plugins work? 
Plugins are basically dynamic objects loaded by Hyprland. They have (almost) full access to every part of Hyprland’s internal process, and as such, can modify and change way more than a script.

Prerequisites 
In order to write a Hyprland plugin, you will need:

Knowledge of C++
The ability to read
A rough understanding of the Hyprland internals (you can learn this alongside your development work)
Making your first plugin 
Open your favorite code editor.

Make a new directory, in this example we will use MyPlugin.

→ If you have the Hyprland headers

If you install with make install, you should have the headers. In that case, no further action is required.

→ If you don’t have the Hyprland source cloned

Clone the Hyprland source code to a subdirectory, in our example MyPlugin/Hyprland. Run cd Hyprland && make all && sudo make installheaders && cd ...

Now that you have the Hyprland sources set up, you can either start from scratch if you know how, or take a look at some simple plugins in the official plugins repo like for example csgo-vulkan-fix or hyprwinwrap.

The basic parts of the plugin 
Starting from the top, you will have to include the plugin API:

#include <hyprland/src/plugins/PluginAPI.hpp>

Feel free to take a look at the header. It contains a bunch of useful comments.

We also create a global pointer for our handle:

inline HANDLE PHANDLE = nullptr;

We will initialize it in our plugin init function later. It serves as an internal “ID” of our plugin.

Then, there is the API version method:

// Do NOT change this function.
APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

This method will tell Hyprland what API version was used to compile this plugin. Do NOT change it. It will be set to the correct value when compiling.

Skipping over some example handlers, we have two important functions:

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;

    const std::string HASH = __hyprland_api_get_hash();

    // ALWAYS add this to your plugins. It will prevent random crashes coming from
    // mismatched header versions.
    if (HASH != GIT_COMMIT_HASH) {
        HyprlandAPI::addNotification(PHANDLE, "[MyPlugin] Mismatched headers! Can't proceed.",
                                     CHyprColor{1.0, 0.2, 0.2, 1.0}, 5000);
        throw std::runtime_error("[MyPlugin] Version mismatch");
    }

    // ...

    return {"MyPlugin", "An amazing plugin that is going to change the world!", "Me", "1.0"};
}

APICALL EXPORT void PLUGIN_EXIT() {
    // ...
}

The first method will be called when your plugin gets initialized (loaded).

You can, and probably should, initialize everything you may want to use in there.

It’s worth noting that adding config variables is only allowed in this function.

The plugin init function is required.

The return value should be the PLUGIN_DESCRIPTION_INFO struct which lets Hyprland know about your plugin’s name, description, author and version.

Make sure to store your HANDLE as it’s going to be required for API calls.

The second method is not required, and will be called when your plugin is being unloaded by the user.

If your plugin is being unloaded because it committed a fault, this function will not be called.

You do not have to unload layouts, remove config options, remove dispatchers, window decorations or unregister hooks in the exit method. Hyprland will do that for you.

Setting up a development environment 
In order to make your life easier, it’s a good idea to work on a nested debug Hyprland session.

Enter your Hyprland directory and run make debug.

Make a copy of your config in ~/.config/hypr called hyprlandd.conf.

Remove all exec= or exec-once= directives from your config.

recommended: Change the modifier for your keybinds (e.g. SUPER -> ALT).

Launch the output Hyprland binary in ./build/ when logged into a Hyprland session.

A new window should open with Hyprland running inside of it. You can now run your plugin in the nested session without worrying about nuking your actual session, and also being able to debug it easily.

See more info in the Contributing Section

More advanced stuff 
Take a look at the src/plugins/PluginAPI.hpp header. It has comments to every method to let you know what it is.

For more explanation on a few concepts, see Advanced and Plugin Guidelines

Last updated on October 4, 2025
Plugin guidelines
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Hypr Ecosystem
Useful Utilities
Plugins
Using plugins
Development
Getting started
Plugin guidelines
Event list
Advanced
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Making your plugin compatible with hyprpm
Repository metadata
Plugins
Commit pins
Formatting
Usage of the API
Function Hooks
Threads
Edit this page on GitHub →
Scroll to top 
Plugins
Development
Plugin guidelines
Plugin guidelines
This page documents the recommended guidelines for making a stable and neat plugin.

Making your plugin compatible with hyprpm 
In order for your plugin to be installable by hyprpm, you need a manifest.

hyprpm will parse hyprload manifests just fine, but it’s recommended to use the more powerful hyprpm manifest.

Make a file in the root of your repository called hyprpm.toml.

Repository metadata 
At the beginning, put some metadata about your plugin:

hyprpm.toml
[repository]
name = "MyPlugin"
authors = ["Me"]
commit_pins = [
    ["3bb9c7c5cf4f2ee30bf821501499f2308d616f94", "efee74a7404495dbda70205824d6e9fc923ccdae"],
    ["d74607e414dcd16911089a6d4b6aeb661c880923", "efee74a7404495dbda70205824d6e9fc923ccdae"]
]

name and authors are required. commit_pins are optional. See commit pins for more info.

Plugins 
For each plugin, make a category like this:

hyprpm.toml
[plugin-name]
description = "An epic plugin that will change the world!"
authors = ["Me"]
output = "plugin.so"
build = [
    "make all"
]

description, authors are optional. output and build are required.

build are the commands that hyprpm will run in the root of the repo to build the plugin. Every command will reset the cwd to the repo root.

output is the path to the output .so file from the root of the repo.

Commit pins 
Commit pins allow you to manage versioning of your plugin. they are pairs of hash,hash, where the first hash is the Hyprland commit hash, and the second is your plugin’s corresponding commit hash.

For example, in the manifest above, d74607e414dcd16911089a6d4b6aeb661c880923 corresponds to Hyprland’s 0.33.1 release, which means that if someone is running 0.33.1, hyprpm will reset your plugin to commit hash efee74a7404495dbda70205824d6e9fc923ccdae.

It’s recommended you add a pin for each Hyprland release. If no pin matches, latest git will be used.

Formatting 
Although Hyprland plugins obviously are not required to follow Hyprland’s formatting, naming conventions, etc. it might be a good idea to keep your code consistent. See .clang-format in the Hyprland repo.

Usage of the API 
It’s always advised to use the API entries whenever possible, as they are guaranteed stability as long as the version matches.

It is, of course, possible to use the internal methods by just including the proper headers, but it should not be treated as the default way of doing things.

Hyprland’s internal methods may be changed, removed or added without any prior notice. It is worth nothing though that methods that “seem” fundamental, like e.g. focusWindow or mouseMoveUnified probably are, and are unlikely to change their general method of functioning.

Function Hooks 
Function hooks allow your plugin to intercept all calls to a function of your choice. They are to be treated as a last resort, as they are the easiest thing to break between updates.

Always prefer using Event Hooks.

Threads 
The Wayland event loop is strictly single-threaded. It is not recommended to create threads in your code, unless they are fully detached from the Hyprland process. (e.g. saving a file)

Last updated on October 4, 2025
Getting started
Event list
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Hypr Ecosystem
Useful Utilities
Plugins
Using plugins
Development
Getting started
Plugin guidelines
Event list
Advanced
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Complete list
Edit this page on GitHub →
Scroll to top 
Plugins
Development
Event list
Event list
These are all the events that can be listened to using Event Hooks.

Complete list 
M: means std::unordered_map<std::string, std::any> following props are members.
name	description	argument(s)	cancellable
tick	fired on a tick, meaning once per (1000 / highestMonitorHz) ms	nullptr	✕
activeWindow	fired on active window change	PHLWINDOW	✕
keyboardFocus	fired on keyboard focus change. Contains the newly focused surface	SP<CWLSurfaceResource>	✕
moveWorkspace	fired when a workspace changes its monitor	std::vector<std::any>{PHLWORKSPACE, PHLMONITOR}	✕
focusedMon	fired on monitor focus change	PHLMONITOR	✕
moveWindow	fired when a window changes workspace	std::vector<std::any>{PHLWINDOW, PHLWORKSPACE}	✕
openLayer	fired when a LS is mapped	PHLLS	✕
closeLayer	fired when a LS is unmapped	PHLLS	✕
openWindow	fired when a window is mapped	PHLWINDOW	✕
closeWindow	fired when a window is unmapped	PHLWINDOW	✕
windowUpdateRules	fired when a window’s rules are updated	PHLWINDOW	✕
urgent	fired when a window requests urgent	PHLWINDOW	✕
preMonitorAdded	fired when a monitor is plugged in, before Hyprland handles it	PHLMONITOR	✕
monitorAdded	fired when a monitor is plugged in, after Hyprland has handled it	PHLMONITOR	✕
preMonitorRemoved	fired when a monitor is unplugged, before Hyprland handles it	PHLMONITOR	✕
monitorRemoved	fired when a monitor is unplugged, after Hypralnd has handled it	PHLMONITOR	✕
createWorkspace	fired when a workspace is created	PHLWORKSPACE	✕
destroyWorkspace	fired when a workspace is destroyed	PHLWORKSPACE	✕
fullscreen	fired when a window changes fullscreen state	PHLWINDOW	✕
changeFloatingMode	fired when a window changes float state	PHLWINDOW	✕
workspace	fired on a workspace change (only ones explicitly requested by a user)	PHLWORKSPACE	✕
submap	fired on a submap change	std::string	✕
mouseMove	fired when the cursor moves. Param is coords.	const Vector2D	✔
mouseButton	fired on a mouse button press	IPointer::SButtonEvent	✔
mouseAxis	fired on a mouse axis event	M: event:IPointer::SAxisEvent	✔
touchDown	fired on a touch down event	ITouch::SDownEvent	✔
touchUp	fired on a touch up event	ITouch::SUpEvent	✔
touchMove	fired on a touch motion event	ITouch::SMotionEvent	✔
activeLayout	fired on a keyboard layout change. String pointer temporary, not guaranteed after execution of the handler finishes.	std::vector<std::any>{SP<IKeyboard>, std::string}	✕
preRender	fired before a frame for a monitor is about to be rendered	PHLMONITOR	✕
screencast	fired when the screencopy state of a client changes. Keep in mind there might be multiple separate clients.	std::vector<uint64_t>{state, framesInHalfSecond, owner}	✕
render	fired at various stages of rendering to allow your plugin to render stuff. See src/SharedDefs.hpp for a list with explanations	eRenderStage	✕
windowtitle	emitted when a window title changes.	PHLWINDOW	✕
configReloaded	emitted after the config is reloaded	nullptr	✕
preConfigReload	emitted before a config reload	nullptr	✕
keyPress	emitted on a key press	M: event:IKeyboard::SButtonEvent, keyboard:SP<IKeyboard>	✔
pin	emitted when a window is pinned or unpinned	PHLWINDOW	✕
swipeBegin	emitted when a touchpad swipe is commenced	IPointer::SSwipeBeginEvent	✔
swipeUpdate	emitted when a touchpad swipe is updated	IPointer::SSwipeUpdateEvent	✔
swipeEnd	emitted when a touchpad swipe is ended	IPointer::SSwipeEndEvent	✔
Last updated on October 4, 2025
Plugin guidelines
Advanced
Hyprland Wiki
Latest git
Home
Showcase
News
Search...
GitHub
Version selector ⚙️
Getting Started
Configuring
Hypr Ecosystem
Useful Utilities
Plugins
Using plugins
Development
Getting started
Plugin guidelines
Event list
Advanced
Nix
NVidia
IPC
Crashes and Bugs
FAQ
Connect
Contributing and Debugging

Light
On this page

Accessing private members
Using Function Hooks
Member functions
Why use findFunctionsByName?
Using the config
Further
Edit this page on GitHub →
Scroll to top 
Plugins
Development
Advanced
Advanced
This page documents a few advanced things about the Hyprland Plugin API.

Accessing private members 
If you need access to a private member of a Hyprland class, you can surround includes with a macro which will change the visibility to public. Note that some Hyprland files include the STL which may end up breaking if you attempt this. If you encounter this issue, make sure to include the offending STL import before the section where you include the Hyprland file.

#define private public
#include <hyprland/src/plugins/PluginAPI.hpp>
#include <hyprland/src/render/OpenGL.hpp>
#include <hyprland/src/desktop/Window.hpp>
#include <hyprland/src/layout/IHyprLayout.hpp>
#undef private

Using Function Hooks 
Function hooks are only available on AMD64 (x86_64). Attempting to hook on any other arch will make Hyprland simply ignore your hooking attempt.
Function hooks are intimidating at first, but when used properly can be extremely powerful.

Function hooks allow you to intercept any call to the function you hook.

Let’s look at a simple example:

void Events::listener_monitorFrame(void* owner, void* data)

This will be the function we want to hook. Events:: is a namespace, not a class, so this is just a plain function.

// make a global instance of a hook class for this hook
inline CFunctionHook* g_pMonitorFrameHook = nullptr;
// create a pointer typedef for the function we are hooking.
typedef void (*origMonitorFrame)(void*, void*);

// our hook
void hkMonitorFrame(void* owner, void* data) {
    (*(origMonitorFrame)g_pMonitorFrameHook->m_pOriginal)(owner, data);
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    // stuff...

    // create the hook
    static const auto METHODS = HyprlandAPI::findFunctionsByName(PHANDLE, "listener_monitorFrame");
    g_pMonitorFrameHook = HyprlandAPI::createFunctionHook(handle, METHODS[0].address, (void*)&hkMonitorFrame);

    // init the hook
    g_pMonitorFrameHook->hook();

    // further stuff...
}

We have just made a hook. Now, whenever Hyprland calls Events::listener_monitorFrame, our hook will be called instead!

This way, you can run code before / after the function, modify the inputs or results, or even block the function from executing.

CFunctionHook can also be unhooked whenever you please. Just run unhook(). It can be rehooked later by calling hook() again.

Member functions 
For members, e.g. CCompositor::focusWindow(CWindow*, wlr_surface*) you will also need to add the thisptr argument to your hook:

typedef void (*origFocusWindow)(void*, CWindow*, wlr_surface*);

void hkFocusWindow(void* thisptr, CWindow* pWindow, wlr_surface* pSurface) {
    // stuff...

    // and if you want to call the original...
    (*(origFocusWindow)g_pFocusWindowHook->m_pOriginal)(thisptr, pWindow, pSurface);
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    // stuff...

    static const auto METHODS = HyprlandAPI::findFunctionsByName(PHANDLE, "focusWindow");
    g_pFocusWindowHook = HyprlandAPI::createFunctionHook(handle, METHODS[0].address, (void*)&hkFocusWindow);
    g_pFocusWindowHook->hook();

    // further stuff...
}

Please note method lookups are slow and should not be used often. The entries will not change during runtime, so it’s a good idea to make the lookups static.
Why use findFunctionsByName? 
Why use that instead of e.g. &CCompositor::focusWindow? Two reasons:

Less breakage. Whenever someone updates Hyprland, that address might become invalid. findFunctionsByName is more resilient. As long as the function exists, it will be found.

Error handling. The method array contains, besides the address, the signatures. You can verify those to make 100% sure you got the right function, or throw an error if it was not found.

Using the config 
You can register config values in the PLUGIN_INIT function:

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    // stuff...
    
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:example:exampleInt", SConfigValue{.intValue = 1});

    // further stuff...
}

Plugin variables must be in the plugins: category. Further categories are up to you. It’s generally a good idea to group all variables from your plugin in a subcategory with the plugin name, e.g. plugins:myPlugin:variable1.

For retrieving the values, call HyprlandAPI::getConfigValue.

Please remember that the pointer to your config value will never change after PLUGIN_INIT, so to greatly optimize performance, make it static:

static auto* const MYVAR = &HyprlandAPI::getConfigValue(PHANDLE, "plugin:myPlugin:variable1")->intValue;

Further 
Read the API at src/plugins/PluginAPI.hpp, check out the official plugins.

And, most importantly, have fun!

Last updated on October 4, 2025
Event list