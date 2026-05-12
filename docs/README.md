# Hyprland Configuration Documentation

**Author**: tripathiji  
**Version**: Hyprland v0.51.1  
**Branch**: tripathiji1312/hypr v2.1  
**Date**: 5 October 2025

---

## 📁 Repository Structure

```
~/.config/hypr/
├── 📝 Core Configurations (Root Level)
│   ├── hyprland.conf          # Main Hyprland config (sources all modules)
│   ├── hypridle.conf          # Idle management & screen timeout
│   ├── hyprlock.conf          # Lock screen configuration
│   └── hyprpaper.conf         # Wallpaper daemon config
│
├── ⚙️ hyprland/               # Modular Hyprland Configs
│   ├── animation.conf         # Bezier curves & animations
│   ├── autostart.conf         # Startup programs & services
│   ├── decorations.conf       # Borders, gaps, blur, shadows, snap
│   ├── keybinds.conf          # All keyboard shortcuts
│   └── window.conf            # Window rules & layer rules
│
├── 🔧 scripts/                # Automation Scripts
│   ├── auto_pip.sh            # Auto PiP workspace tracking
│   ├── change_wallpaper_once.sh  # Manual wallpaper change
│   ├── change_volume_brightness.sh  # Media controls
│   ├── check_updates.sh       # System update checker
│   ├── find_window_class.sh   # Window debugging tool
│   ├── keybind_viewer.sh      # Searchable keybind reference
│   ├── pip_move.sh            # Move PiP to corners
│   ├── pip_resize.sh          # Resize PiP windows
│   ├── powermenu.sh           # Logout/shutdown menu
│   ├── pywal_reload.sh        # Theme fixer (CRITICAL!)
│   ├── screenshot.sh          # Screenshot utility
│   ├── startup_theme.sh       # Boot theme initialization
│   ├── wofi_clipboard.sh      # Clipboard manager
│   └── wofi_network.sh        # Network manager GUI
│
├── 🔒 hyprlock/               # Lock Screen Assets
│   ├── assets/                # Images (profile picture)
│   ├── battery.sh             # Battery info for lock screen
│   ├── bluetooth.sh           # Bluetooth status
│   ├── greeting.sh            # Time-based greeting
│   ├── network.sh             # WiFi SSID display
│   ├── playerctl.sh           # Media info
│   └── weatherinfo.sh         # Weather from IP location
│
├── 🖼️ wallpaper/              # Wallpaper Collection
│   └── *.jpg, *.png, *.jpeg   # All wallpaper images
│
├── 📚 docs/                   # Documentation Hub (YOU ARE HERE)
│   ├── README.md              # This file - Repository guide
│   ├── APPLIED_IMPROVEMENTS_v2.md  # Applied features log
│   ├── FIX_SUMMARY.md         # Bug fixes & solutions
│   ├── IMPROVEMENTS_v051.md   # Hyprland 0.51.1 improvements
│   ├── KEYBIND_CONFLICT_RESOLUTION.md  # Keybind audit
│   ├── PIP_FIX_SUMMARY.md     # PiP optimization guide
│   └── QUICK_REFERENCE.md     # Quick command reference
│
├── 🎨 assets/                 # Static Assets
│   ├── foreground.png         # UI elements
│   └── hypr.png               # Hyprland logo
│
├── 🗄️ backups/                # Historical Backups
│   └── hyprlock-backup-20250809185120/  # Old lock configs
│
├── 💾 cache/                  # Runtime Cache
│   └── .pip_position          # PiP window position state
│
├── 📜 logs/                   # Debug Logs
│   └── *.log                  # Hyprland runtime logs
│
└── 🤖 .github/                # AI & Development
    ├── copilot-instructions.md  # AI agent instructions
    └── chatmodes/             # Chat mode presets

```

---

## 🎯 Design Philosophy

This configuration follows three core principles:

### 1. **Minimalism & Aesthetics**
- Clean, visually pleasing UI with purposeful elements
- Gaps: `gaps_in = 4`, `gaps_out = 8`
- Rounding: `12px` with smooth bezier curves
- Active borders: Gradient cyan/green at 45°
- **No unnecessary decorations** - every element serves a purpose

### 2. **Absolute Functionality**
- **Pywal + GTK Hybrid Theming** - Dynamic colors with stable GTK
- **Window snapping** at 10px proximity
- **Group management** for tabbed workflows
- **PiP optimization** - Smooth, jank-free video windows
- **Scratchpad terminals** - Toggle with `Super + S`

### 3. **Native Experience**
- Seamless integration across all components
- Modular configuration for easy maintenance
- **NEVER modify existing keybinds** - only add new ones
- Extensive documentation & debugging tools

---

## 🚀 Quick Start Guide

### First Time Setup

1. **Clone the repository** (if not already):
   ```bash
   git clone https://github.com/tripathiji1312/hypr.git ~/.config/hypr
   ```

2. **Install dependencies**:
   ```bash
   # Arch Linux
   sudo pacman -S hyprland kitty thunar waybar dunst wofi cliphist \
                  grim slurp hyprpaper python-pywal jq socat playerctl
   ```

3. **Apply theme on startup**:
   ```bash
   ~/.config/hypr/scripts/startup_theme.sh
   ```

4. **Reload Hyprland**:
   ```bash
   hyprctl reload
   ```

### Essential Keybinds

Press **`Super + K`** to open the interactive keybind viewer!

| Keybind | Action |
|---------|--------|
| `Super` | Wofi launcher |
| `Super + Return` | Terminal (Kitty) |
| `Super + E` | File manager (Thunar) |
| `Super + W` | Change wallpaper & theme |
| `Super + S` | Toggle scratchpad terminal |
| `Super + Q` | Close window |
| `Super + V` | Toggle floating |
| `Super + F` | Toggle fullscreen |
| `Super + I` | Pin window (always on top) |
| `Super + K` | **Keybind viewer** |
| `Super + Ctrl + .` | Toggle `dwindle` / `scrolling` layout |
| `Super + Ctrl + P` | Promote active window to a new scrolling column |
| `Super + Ctrl + G / Shift + G` | Stack active window left / right in scrolling layout |
| `Super + Ctrl + = / - / 0` | Cursor zoom controls |

---

## 📖 Documentation Index

### 🔧 Configuration Guides
- **[APPLIED_IMPROVEMENTS_v2.md](./APPLIED_IMPROVEMENTS_v2.md)** - All applied improvements from Phase 1-3
- **[IMPROVEMENTS_v051.md](./IMPROVEMENTS_v051.md)** - Hyprland 0.51.1 specific features
- **[QUICK_REFERENCE.md](./QUICK_REFERENCE.md)** - Fast command lookup

### 🐛 Troubleshooting
- **[docs/FIX_SUMMARY.md](./FIX_SUMMARY.md)** - Common issues & solutions
- **[docs/PIP_FIX_SUMMARY.md](./PIP_FIX_SUMMARY.md)** - PiP optimization guide
- **[docs/PIP_RESIZE_CYCLE_FIX.md](./PIP_RESIZE_CYCLE_FIX.md)** - PiP resize cycling fix
- **[docs/KEYBIND_CONFLICT_RESOLUTION.md](./KEYBIND_CONFLICT_RESOLUTION.md)** - Keybind audit

### 🎨 Theming & Customization
See `scripts/pywal_reload.sh` for the **critical GTK theme fixer**.

The Pywal + GTK hybrid system:
1. Wallpaper changes via `change_wallpaper_once.sh`
2. Pywal generates colors from wallpaper
3. `pywal_reload.sh` **forces** `adw-gtk3-dark` GTK theme
4. Waybar/Dunst/Kitty use Pywal colors
5. **Why?** Pywal breaks GTK portals - this fixes it!

---

## 🔑 Critical Files

### Must-Read Before Editing

1. **`../.github/copilot-instructions.md`**
   - Complete AI agent instructions
   - Design patterns & troubleshooting
   - Official Hyprland Wiki v0.51.1 reference

2. **`../hyprland/keybinds.conf`**
   - **NEVER modify existing keybinds!**
   - Only add non-conflicting new binds
   - See KEYBIND_CONFLICT_RESOLUTION.md for audit

3. **`../scripts/pywal_reload.sh`**
   - ⚠️ **CRITICAL** - GTK theme fixer
   - Called after every wallpaper change
   - Do NOT remove or modify without understanding!

4. **`../hyprland/window.conf`**
   - Window rules for browsers, PiP, portals
   - Layer rules for blur on Waybar/Dunst
   - Defense-in-depth against buggy popups

---

## 🧪 Testing & Debugging

### Check Configuration Health
```bash
# Check for errors
hyprctl configerrors

# List all windows
hyprctl clients

# Find window class/title
~/.config/hypr/scripts/find_window_class.sh

# Show current keybinds
hyprctl binds

# Monitor logs
tail -f ~/.config/hypr/logs/*.log
```

### Theme Debugging
```bash
# Check Pywal colors
cat ~/.cache/wal/colors

# Verify GTK theme
gsettings get org.gnome.desktop.interface gtk-theme
# Should output: 'adw-gtk3-dark'

# Force theme reload
~/.config/hypr/scripts/pywal_reload.sh
```

### Keybind Testing
```bash
# Open keybind viewer
Super + K

# Or check all binds via terminal
hyprctl binds | less
```

---

## 📦 Backup Strategy

### Manual Backup
```bash
# Full config backup
tar -czf ~/hypr-backup-$(date +%Y%m%d).tar.gz ~/.config/hypr

# Backup to backups/ folder
cp -r ~/.config/hypr ~/.config/hypr/backups/hypr-backup-$(date +%Y%m%d-%H%M%S)
```

### Restore from Backup
```bash
# From archive
tar -xzf ~/hypr-backup-20251005.tar.gz -C ~/

# From backups/ folder
cp -r ~/.config/hypr/backups/hypr-backup-YYYYMMDD-HHMMSS/* ~/.config/hypr/
```

---

## 🤝 Contributing

### Before Making Changes

1. **Read** `../.github/copilot-instructions.md` - Understand design philosophy
2. **Test** in nested Hyprland session (`make debug` in Hyprland source)
3. **Document** changes in appropriate docs/ file
4. **Commit** with descriptive messages referencing Hyprland Wiki

### Coding Standards

- **Comments**: Explain WHY, not WHAT
- **Syntax**: Follow Hyprland Wiki v0.51.1
- **Testing**: Use `hyprctl` to verify before committing
- **Modular**: Add to appropriate `.conf`, not main config
- **Keybinds**: NEVER modify existing ones

---

## 🔗 External Resources

- **Hyprland Wiki**: https://wiki.hyprland.org/
- **Hyprland GitHub**: https://github.com/hyprwm/Hyprland
- **Hyprland Discord**: https://discord.gg/hQ9XvMUjjr
- **This Repository**: https://github.com/tripathiji1312/hypr

---

## 📄 License

Personal configuration - Use at your own risk.  
Some scripts adapted from Hyprland community examples.

---

**Last Updated**: 5 October 2025  
**Maintainer**: tripathiji  
**Hyprland Version**: v0.51.1
