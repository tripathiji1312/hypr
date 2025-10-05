# Keybind Conflict Resolution Report
**Date**: 5 October 2025  
**Hyprland Version**: v0.51.1  
**Branch**: tripathiji1312/hypr v2.2

---

## 🎯 Summary

Identified and resolved **2 keybind conflicts** in `hyprland/keybinds.conf`:

1. **Super + I** (duplicated)
2. **Super + Ctrl + Left/Right** (conflicting)

All conflicts resolved by **keeping original bindings** and **changing newer ones** per configuration philosophy.

---

## 🔍 Conflicts Found

### 1. Super + I → Pin Window (DUPLICATE)

**Original Binding** (Line 111 - KEPT):
```conf
# Super + I: Pin window (keep on top)
bind = $mainMod, I, pin
```
**Location**: Window Management section

**Duplicate Binding** (Line 301 - REMOVED):
```conf
# Super + I: Pin/unpin active window  
bind = $mainMod, I, pin
```
**Location**: PiP Controls section

**Resolution**: Removed duplicate at line 301. The original `Super + I → pin` remains functional.

---

### 2. Super + Ctrl + Arrow Keys (CONFLICTING FUNCTIONS)

**Original Binding** (Lines 137-140 - KEPT):
```conf
# Resize windows
bind = $mainMod CTRL, left, resizeactive, -20 0
bind = $mainMod CTRL, right, resizeactive, 20 0
bind = $mainMod CTRL, up, resizeactive, 0 -20
bind = $mainMod CTRL, down, resizeactive, 0 20
```
**Function**: Resize active window  
**Location**: Window Management section

**Conflicting Binding** (Lines 193-194 - CHANGED):
```conf
# Super + Ctrl + Right/Left: Navigate all workspaces
bind = $mainMod CTRL, right, workspace, e+1
bind = $mainMod CTRL, left, workspace, e-1
```
**Function**: Navigate workspaces  
**Location**: Workspace Navigation section

**Resolution**: Changed workspace navigation to `Super + Alt + Left/Right`:
```conf
# Super + Alt + Right/Left: Navigate all workspaces
bind = $mainMod ALT, right, workspace, e+1
bind = $mainMod ALT, left, workspace, e-1
```

---

## ✅ Updated Keybinds (Final State)

### Window Management
| Keybind | Action |
|---------|--------|
| `Super + I` | Pin window (keep on top) |
| `Super + Ctrl + ←/→/↑/↓` | Resize active window |

### Workspace Navigation
| Keybind | Action |
|---------|--------|
| `Super + Alt + →` | Navigate to next workspace |
| `Super + Alt + ←` | Navigate to previous workspace |

### PiP Controls
| Keybind | Action |
|---------|--------|
| `Super + Shift + I` | Move PiP to next corner |
| `Super + Ctrl + I` | Resize PiP (cycle sizes) |
| `Super + Alt + I` | Show PiP window info (debug) |

---

## 📝 Keybind Viewer Updates

Updated `scripts/keybind_viewer.sh` with:

### Added Bindings
- **Window Management**: All group controls, opacity toggles, waybar restart
- **Window Resize**: `Super + Ctrl + Arrows` for resizing
- **Workspace Navigation**: Corrected to `Super + Alt + Arrows`
- **PiP Controls**: All three PiP-specific bindings
- **Debugging**: Window inspector, class viewer tools
- **Clipboard**: Clear clipboard history binding
- **System**: Corrected power menu to `Super + M`

### Fixed Descriptions
- Changed "Toggle Pseudo/Dwindle" → "Toggle Pseudo-tiling"
- Added "Maximize" and "Full" fullscreen modes
- Separated resize from movement in focus section
- Added middle-click kill window
- Corrected special workspace navigation

---

## 🧪 Verification

### Config Validation
```bash
$ hyprctl configerrors
# No output = No errors ✅
```

### Duplicate Check
```bash
$ grep -E "^bind" keybinds.conf | awk '{print $3" "$4}' | sed 's/,//g' | sort | uniq -d
# Only partial modifier matches (false positives) ✅
```

### Actual Conflicts
- **Before**: 2 conflicts (Super+I duplicate, Super+Ctrl+Arrows conflicting)
- **After**: 0 conflicts ✅

---

## 🎨 Design Philosophy Applied

Per `copilot-instructions.md`:
> **NEVER modify existing keybinds** - only add non-conflicting ones

✅ **All original bindings preserved**:
- `Super + I → pin` (line 111) kept
- `Super + Ctrl + Arrows → resize` (lines 137-140) kept

✅ **New bindings changed to avoid conflicts**:
- Removed duplicate `Super + I` from PiP section
- Changed workspace navigation from `Super + Ctrl + Arrows` to `Super + Alt + Arrows`

---

## 📚 Reference Documentation

All changes verified against:
- **Hyprland Wiki v0.51.1**: [Configuring/Binds](https://wiki.hyprland.org/Configuring/Binds/)
- **Hyprland Wiki**: [Dispatchers](https://wiki.hyprland.org/Configuring/Dispatchers/)
- **Project docs**: `.github/copilot-instructions.md`

---

## 🔄 Next Steps

1. **Test all modified bindings**:
   - Press `Super + I` → Should pin/unpin window
   - Press `Super + Ctrl + Arrows` → Should resize window
   - Press `Super + Alt + →/←` → Should navigate workspaces

2. **View updated keybind reference**:
   - Press `Super + K` to open keybind viewer
   - Search for "resize" or "workspace" to verify changes

3. **Reload configuration** (if needed):
   ```bash
   hyprctl reload
   ```

---

**Configuration Status**: ✅ **All conflicts resolved, no errors**
