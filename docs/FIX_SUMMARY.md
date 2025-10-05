# Black Border Fix Summary - v2.2 Branch
**Date:** October 5, 2025  
**Issue:** Black borders around all browser popups and context menus

## 🔍 Root Cause Analysis

The `v2.2` branch had **146 extra lines** of aggressive window rules in `window.conf` that were causing black borders around ALL browser popups and menus.

### Problematic Rules (Now Removed):
```conf
# ❌ These matched ALL empty-title windows (including popups!)
windowrulev2 = noblur, class:^(vivaldi-stable)$, title:^()$
windowrulev2 = noborder, class:^(vivaldi-stable)$, title:^()$
windowrulev2 = noshadow, class:^(vivaldi-stable)$, title:^()$
windowrulev2 = noanim, class:^(vivaldi-stable)$, title:^()$

# ❌ Force effects on ALL small floating windows
windowrulev2 = forcergbx, floating:1, size:[0-800] [0-800]
windowrulev2 = noblur, floating:1, size:[0-800] [0-800]
windowrulev2 = noshadow, floating:1, size:[0-800] [0-800]
```

### Why This Broke Popups:
- Browser popups/menus are **subsurfaces** with `title:^()$` (empty title)
- Rules with `noborder, noshadow, noblur` on empty-title windows matched them
- Forcing `forcergbx` disabled alpha channel rendering
- Result: **Black borders** appeared instead of native transparent popups

## ✅ Solution Applied

### 1. Restored `window.conf` to Main Branch (86 lines)
```bash
cp main:hyprland/window.conf → ~/.config/hypr/hyprland/window.conf
```
- **Removed:** 146 lines of aggressive popup rules
- **Kept:** Only essential window rules (PiP, floating dialogs, smart gaps)

### 2. Removed Experimental Config Files
```bash
rm ~/.config/hypr/hyprland/popup-fix.conf
rm ~/.config/hypr/hyprland/meet-pip-fix.conf
```
- These files don't exist in the working `main` branch
- They contained duplicate/conflicting rules

### 3. Cleaned hyprland.conf
```bash
# Removed this line:
source = ~/.config/hypr/hyprland/meet-pip-fix.conf
```

## 🎯 Expected Behavior Now

### ✅ What Should Work:
- **Right-click menus** in all browsers → No black borders, native rendering
- **Browser dropdown menus** → Proper transparency and shadows
- **Context menus everywhere** → Native system look

### ⚠️ Known Remaining Issue:
- **Google Meet PiP** wallpaper bleed (original issue from `main` branch)
- This is expected - it existed in `main` too
- Will require targeted Meet-specific rules (NOT aggressive global rules)

## 📊 File Comparison

| File | Main (Working) | v2.2 (Broken) | Now |
|------|----------------|---------------|-----|
| `window.conf` | 86 lines | 230 lines (+144) | 86 ✅ |
| `popup-fix.conf` | Doesn't exist | 7KB file | Removed ✅ |
| `meet-pip-fix.conf` | Doesn't exist | 2.5KB file | Removed ✅ |
| `decorations.conf` | `xray = true` | Same | Same ✅ |

## 🔧 Key Takeaways

### ❌ What NOT To Do:
1. **Don't use `title:^()$` rules globally** - they match ALL popups
2. **Don't use `forcergbx` on floating windows** - breaks transparency
3. **Don't disable blur/shadow on all small windows** - kills native look
4. **Don't use `noborder` on browser windows** - causes black borders

### ✅ What TO Do:
1. **Use specific title patterns** - e.g., `title:^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$`
2. **Test rules in `main` first** - don't add experimental rules to v2.2
3. **Keep window.conf minimal** - only essential rules
4. **Let compositor handle popups** - they render correctly by default

## 🧪 Testing Commands

```bash
# Verify config is clean
wc -l ~/.config/hypr/hyprland/window.conf  # Should be 86

# Check for removed files
ls ~/.config/hypr/hyprland/*.conf          # No popup-fix or meet-pip-fix

# Test right-click menus
# → Should render natively without black borders

# Reload config
hyprctl reload
```

## 📝 Next Steps for Google Meet Fix

If you want to fix the Google Meet PiP wallpaper bleed:

1. **Don't add global rules** - only target Meet windows specifically
2. **Use exact title pattern:** `title:^(Meet - [a-z]{3}-[a-z]{4}-[a-z]{3})$`
3. **Only apply opacity override:** `opacity 1.0 override`
4. **Test in isolation** - add one rule at a time
5. **Keep it in separate file** - easier to debug

---

**Status:** ✅ Black borders fixed by restoring to `main` branch state  
**Remaining:** Google Meet PiP wallpaper bleed (separate issue, needs targeted fix)
