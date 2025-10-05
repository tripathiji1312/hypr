# PiP Resize Cycling Fix

**Date**: 5 October 2025  
**Issue**: PiP resize reaches limit and shows error instead of cycling  
**Status**: ✅ **RESOLVED**

---

## Problem Description

When using the PiP resize keybind (`Super + Ctrl + I`), the window would resize from 15% → 20% → 25% → 30% → 35%, but when trying to resize again, it would show an error:

```
❌ PiP Not Found
No Meet PiP window detected
```

Instead of cycling back to 15% to create an infinite loop.

---

## Root Cause

The script had **strict size constraints** in the window detection logic:

```bash
# OLD CODE (BROKEN):
select(
    (.class == "vivaldi-stable") and
    (.title | test("^Meet - [a-z]{3}-[a-z]{4}-[a-z]{3}$")) and
    .floating == true and
    (.size[0] < 500 and .size[1] < 500)  # ← THIS WAS THE PROBLEM!
) |
```

When the window was resized to 35% on a typical monitor (e.g., 1920x1080):
- Window size: ~672x378 pixels
- Detection constraint: Only finds windows < 500px wide
- **Result**: Window not detected → Error shown ❌

---

## Solution Applied

### 1. **Removed Size Constraints from Detection**

```bash
# NEW CODE (FIXED):
select(
    (.class == "vivaldi-stable") and
    (.title | test("^Meet - [a-z]{3}-[a-z]{4}-[a-z]{3}$")) and
    .floating == true
    # ← No size constraint! Can find window at ANY size
) |
```

### 2. **Added Relaxed Fallback Detection**

Four-tier detection system:
1. **Strict**: Exact Meet PiP pattern (e.g., "Meet - abc-defg-hij")
2. **Relaxed**: Any Meet window that's floating
3. **Generic**: Any window with "Picture-in-Picture" in title
4. **Emergency**: Any small floating Vivaldi window

### 3. **Enhanced Error Handling**

```bash
if [ -z "$PIP_ADDR" ]; then
    notify-send "❌ PiP Not Found" "..." -t 2500 -u critical
    # Reset state on error so next resize starts fresh
    echo "20" > "$STATE_FILE"  # ← Prevents stuck state
    exit 1
fi
```

### 4. **State File Validation**

```bash
# Validate CURRENT_SIZE is a number, reset if corrupted
if ! [[ "$CURRENT_SIZE" =~ ^[0-9]+$ ]]; then
    CURRENT_SIZE=15
fi
```

### 5. **Minimum Size Constraints**

```bash
MIN_WIDTH=300
MIN_HEIGHT=200
if [ $NEW_WIDTH -lt $MIN_WIDTH ]; then NEW_WIDTH=$MIN_WIDTH; fi
if [ $NEW_HEIGHT -lt $MIN_HEIGHT ]; then NEW_HEIGHT=$MIN_HEIGHT; fi
```

### 6. **Organized Cache File**

- **Old**: `~/.config/hypr/.pip_size` (cluttered root)
- **New**: `~/.config/hypr/cache/.pip_size` (organized)
- Automatically migrated existing file ✅

---

## Testing Instructions

### Setup
1. Open a Google Meet window in Vivaldi (or any Picture-in-Picture window)
2. Ensure it's floating (should be by default)

### Test Cycle
Press `Super + Ctrl + I` repeatedly and observe:

| Press | Expected Size | Notification |
|-------|---------------|--------------|
| 1st | 20% | ✅ PiP Resized - 20% |
| 2nd | 25% | ✅ PiP Resized - 25% |
| 3rd | 30% | ✅ PiP Resized - 30% |
| 4th | 35% | ✅ PiP Resized - 35% |
| **5th** | **15%** | **🔄 PiP Resized - 15% (Cycled back to smallest)** |
| 6th | 20% | ✅ PiP Resized - 20% |
| ... | ... | *Infinite cycle* |

### Expected Behavior
- ✅ Smooth cycling with no errors
- ✅ Window stays pinned and in bottom-right corner
- ✅ Notifications show percentage + pixel dimensions
- ✅ Special notification when cycling back from 35% → 15%

---

## Technical Details

### File Locations
- **Script**: `~/.config/hypr/scripts/pip_resize.sh`
- **State File**: `~/.config/hypr/cache/.pip_size`
- **Backup**: `~/.config/hypr/backups/pip_resize.sh.backup`

### Keybind
```conf
bind = $mainMod CTRL, I, exec, ~/.config/hypr/scripts/pip_resize.sh
```

### Size Cycle
```
15% → 20% → 25% → 30% → 35% → 15% (infinite loop)
 ↑                               ↓
 └───────────────────────────────┘
```

### Detection Logic Flow
```
Try 1: Exact Meet pattern with regex
  ↓ fail
Try 2: Any Meet window (floating)
  ↓ fail
Try 3: Generic PiP title
  ↓ fail
Try 4: Small floating Vivaldi window
  ↓ fail
Error: PiP not found → Reset state → Exit
```

---

## Related Scripts

| Script | Purpose | Keybind |
|--------|---------|---------|
| `pip_resize.sh` | Cycle PiP size | `Super + Ctrl + I` |
| `pip_move.sh` | Move PiP to corners | `Super + Shift + I` |
| `auto_pip.sh` | Auto-move PiP on workspace switch | (autostart) |

---

## Debugging

### Check Current State
```bash
cat ~/.config/hypr/cache/.pip_size
# Should show: 15, 20, 25, 30, or 35
```

### Find PiP Window Manually
```bash
hyprctl clients -j | jq '.[] | select(.title | test("Meet|Picture"; "i"))'
```

### Reset State
```bash
echo "15" > ~/.config/hypr/cache/.pip_size
```

### Test Script Directly
```bash
~/.config/hypr/scripts/pip_resize.sh
```

---

## Changelog

### v2.0 (5 October 2025)
- ✅ **Fixed**: Size cycling now wraps from 35% → 15% (infinite loop)
- ✅ **Fixed**: Removed size constraints from window detection
- ✅ **Added**: State file validation and corruption recovery
- ✅ **Added**: Minimum size constraints (300x200px)
- ✅ **Changed**: Moved state file to `cache/.pip_size`
- ✅ **Improved**: Better error handling with state reset
- ✅ **Improved**: Enhanced notifications with cycle indicator

### v1.0 (Initial)
- Basic resize functionality
- Size cycle: 15% → 20% → 25% → 30% → 35% → **ERROR** ❌

---

## Notes

- The script automatically creates the `cache/` directory if it doesn't exist
- State persists across Hyprland restarts
- Works with any browser that supports Meet PiP (Vivaldi, Chrome, Brave, Firefox)
- Compatible with generic Picture-in-Picture windows from any app

---

**Author**: tripathiji  
**Hyprland Version**: v0.51.1  
**Platform**: Arch Linux
