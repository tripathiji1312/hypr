# 🎨 Hyprland Configuration - tripathiji

**A minimalistic, functional, and beautifully crafted Hyprland rice for Arch Linux**

![Hyprland Version](https://img.shields.io/badge/Hyprland-v0.51.1-blue)
![Platform](https://img.shields.io/badge/Platform-Arch%20Linux-informational)
![License](https://img.shields.io/badge/License-Personal-green)

---

## ✨ Features

🎯 **Modular Configuration** - Clean separation of concerns  
🎨 **Pywal + GTK Theming** - Dynamic colors with stable portals  
🪟 **Advanced Window Rules** - Optimized PiP & popup handling  
⌨️ **Extensive Keybinds** - Intuitive shortcuts with viewer (Super + K)  
📦 **Scratchpad Workspaces** - Quick access terminals  
🔧 **Smart Snapping** - Windows snap at 10px proximity  
👥 **Group Management** - Tabbed window workflows  
�� **Screenshot Tools** - Region/window/fullscreen capture  
🔍 **Debugging Tools** - Window inspector & class finder  

---

## 📁 Repository Structure

```
~/.config/hypr/
├── 📝 hyprland.conf          # Main configuration
├── 📝 hypridle.conf          # Idle management
├── 📝 hyprlock.conf          # Lock screen
├── 📝 hyprpaper.conf         # Wallpaper daemon
│
├── ⚙️ hyprland/              # Modular configs
├── 🔧 scripts/               # Automation scripts
├── 🔒 hyprlock/              # Lock screen assets
├── 🖼️ wallpaper/             # Wallpaper collection
│
├── 📚 docs/                  # 📖 DOCUMENTATION HUB
├── 🎨 assets/                # Static images
├── 🗄️ backups/               # Old backups
├── 💾 cache/                 # Runtime cache
├── 📜 logs/                  # Debug logs
└── 🤖 .github/               # AI instructions
```

**📖 Full documentation**: See [`docs/README.md`](./docs/README.md)

---

## 🚀 Quick Start

### Installation

```bash
# Clone repository
git clone https://github.com/tripathiji1312/hypr.git ~/.config/hypr

# Install dependencies (Arch Linux)
sudo pacman -S hyprland kitty thunar waybar dunst wofi cliphist \
               grim slurp swww python-pywal jq socat playerctl

# Apply theme
~/.config/hypr/scripts/startup_theme.sh

# Reload Hyprland
hyprctl reload
```

### Essential Keybinds

| Key | Action |
|-----|--------|
| `Super` | Wofi launcher |
| `Super + K` | **Keybind viewer** 📖 |
| `Super + Return` | Terminal |
| `Super + W` | Change wallpaper |
| `Super + S` | Scratchpad terminal |
| `Super + Q` | Close window |
| `Super + Ctrl + .` | Toggle scrolling layout |
| `Super + Ctrl + = / - / 0` | Cursor zoom in / out / reset |

**Full keybind list**: Press `Super + K` or see [`docs/KEYBIND_CONFLICT_RESOLUTION.md`](./docs/KEYBIND_CONFLICT_RESOLUTION.md)

---

## 📚 Documentation

All documentation is organized in the **`docs/`** folder:

### 📖 Getting Started
- **[docs/README.md](./docs/README.md)** - Complete configuration guide
- **[docs/QUICK_REFERENCE.md](./docs/QUICK_REFERENCE.md)** - Fast command lookup

### 🔧 Features & Improvements
- **[docs/APPLIED_IMPROVEMENTS_v2.md](./docs/APPLIED_IMPROVEMENTS_v2.md)** - All applied features
- **[docs/IMPROVEMENTS_v051.md](./docs/IMPROVEMENTS_v051.md)** - Hyprland 0.51.1 features

### 🐛 Troubleshooting
- **[docs/FIX_SUMMARY.md](./docs/FIX_SUMMARY.md)** - Common issues & solutions
- **[docs/PIP_FIX_SUMMARY.md](./docs/PIP_FIX_SUMMARY.md)** - PiP optimization guide
- **[docs/KEYBIND_CONFLICT_RESOLUTION.md](./docs/KEYBIND_CONFLICT_RESOLUTION.md)** - Keybind audit

### 🤖 For Developers
- **[.github/copilot-instructions.md](./.github/copilot-instructions.md)** - AI agent instructions
- **[.github/chatmodes/](./.github/chatmodes/)** - Chat mode presets

---

## 🎨 Theming System

This config uses a **Pywal + GTK hybrid system**:

1. **Change wallpaper**: `Super + W`
2. **Pywal generates colors** from wallpaper
3. **GTK theme is forced** to `adw-gtk3-dark` (prevents portal bugs)
4. **Waybar/Dunst/Kitty** use Pywal colors

**Critical script**: `scripts/pywal_reload.sh` - The GTK theme fixer!

---

## 🧪 Testing & Debugging

```bash
# Check for config errors
hyprctl configerrors

# Find window class/title
~/.config/hypr/scripts/find_window_class.sh

# View all keybinds
Super + K  # or: hyprctl binds

# Monitor logs
tail -f ~/.config/hypr/logs/*.log

# Theme debugging
~/.config/hypr/scripts/pywal_reload.sh
```

---

## 🛠️ Core Applications

- **Terminal**: Kitty (with Pywal integration)
- **File Manager**: Thunar
- **Browsers**: Zen, Vivaldi, Brave, Chrome
- **Bar**: Waybar (custom modules)
- **Notifications**: Dunst (Pywal themed)
- **Launcher**: Wofi
- **Clipboard**: cliphist + wofi
- **Wallpaper**: swww (smooth transitions)

---

## 📦 Backup & Restore

### Create Backup
```bash
# Full backup
tar -czf ~/hypr-backup-$(date +%Y%m%d).tar.gz ~/.config/hypr

# Quick backup to backups/
cp -r ~/.config/hypr ~/.config/hypr/backups/hypr-backup-$(date +%Y%m%d-%H%M%S)
```

### Restore Backup
```bash
# From archive
tar -xzf ~/hypr-backup-20251005.tar.gz -C ~/

# From backups/ folder
cp -r ~/.config/hypr/backups/hypr-backup-YYYYMMDD-HHMMSS/* ~/.config/hypr/
```

---

## 🎯 Design Philosophy

1. **Minimalism & Aesthetics**
   - Every element has a purpose
   - Clean, modern, easy on the eyes
   - Gaps: 4px in, 8px out | Rounding: 12px

2. **Absolute Functionality**
   - Everything must work flawlessly
   - No half-broken features
   - Extensive error handling

3. **Native Experience**
   - Seamless integration
   - Intuitive workflows
   - Modular & maintainable

**Golden Rule**: **NEVER modify existing keybinds** - only add new non-conflicting ones!

---

## 🔗 Resources

- **Hyprland Wiki**: https://wiki.hyprland.org/
- **Hyprland GitHub**: https://github.com/hyprwm/Hyprland
- **This Repository**: https://github.com/tripathiji1312/hypr
- **Arch Wiki - Hyprland**: https://wiki.archlinux.org/title/Hyprland

---

## 🤝 Contributing

1. Read `.github/copilot-instructions.md` first
2. Test changes in nested session
3. Document in appropriate `docs/` file
4. Follow Hyprland Wiki v0.51.1 syntax
5. Never modify existing keybinds

---

## 📄 License

Personal configuration - Use at your own risk.  
Some scripts adapted from Hyprland community.

---

**Author**: tripathiji  
**Date**: 5 October 2025  
**Hyprland**: v0.51.1  
**Platform**: Arch Linux

**⭐ Star this repo if you find it useful!**
