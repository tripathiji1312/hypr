# Quick Reference - New Features

## 🎯 Window Snapping (#2)
**What:** Windows snap to edges and each other when dragging
**How to Use:** Just drag floating windows near screen edges or other windows
**Distance:** 10px proximity triggers snap
**Disable if needed:** `hyprctl keyword general:snap:enabled false`

---

## 🖱️ Precise Mouse Move (#17)
**What:** Drop windows exactly where your cursor is when dragging
**How to Use:** Hold `Super + Left Mouse` and drag - release where you want
**Best For:** Complex tiled layouts, pixel-perfect positioning

---

## 📦 Persistent Workspaces (#5)
**Active Workspaces:**
- **1: main** - Always exists, never disappears
- **2: code** - Persistent coding workspace
- **3: browser** - Persistent browser workspace

**Benefit:** No workspace renumbering when closing all windows

---

## 🪟 Advanced Groups (#9)
**New Behavior:**
- **Auto-join:** New windows automatically join focused group
- **Insert after:** New windows appear after current (not at end)
- **Groupbar drag only:** Drag into groups via groupbar (mode = 2)

**Quick Actions:**
- `Super + G` - Toggle group
- `Super + N` - Next window in group
- `Super + P` - Previous window in group
- **Drag groupbar** - Merge groups together

---

## 🎨 Layer Blur (#16)
**Blurred Layers:**
- ✅ Waybar (if installed)
- ✅ Dunst notifications
- ✅ Wofi launcher (Super key)
- ✅ Hyprlock

**Performance:** If blur causes lag, disable:
```bash
layerrule = unset, waybar
```

---

## 🔧 Per-Device Configs (#3)
**How to Enable:**
1. Find devices: `hyprctl devices`
2. Edit `hyprland.conf` (search for "#3")
3. Uncomment and customize device blocks

**Example:**
```conf
device {
    name = your-mouse-name
    sensitivity = 0.5
    accel_profile = flat
}
```

---

## 🖥️ Monitor Workspaces (#8)
**How to Enable:**
1. Find monitors: `hyprctl monitors`
2. Edit `hyprland.conf` (search for "#8")
3. Uncomment and adjust workspace rules

**Example:**
```conf
workspace = 1, monitor:DP-1, default:true
workspace = 4, monitor:HDMI-A-1, default:true
```

---

## 🎮 Content Type Hints (#7) - TESTING ONLY
**Not Applied by Default** - Uncomment to test:

```conf
windowrulev2 = content game, class:^(steam_app_).*
windowrulev2 = content video, class:^(mpv)$
```

**Benefits:**
- Better direct scanout for games
- Optimized VRR for videos
- Improved rendering pipeline

---

## 📋 Useful Commands

**View all settings:**
```bash
hyprctl getoption general:snap:enabled
hyprctl getoption dwindle:precise_mouse_move
hyprctl getoption group:auto_group
```

**Check active layers:**
```bash
hyprctl layers
```

**List devices:**
```bash
hyprctl devices
```

**List monitors:**
```bash
hyprctl monitors
```

**Reload config:**
```bash
hyprctl reload
```

**Check for errors:**
```bash
hyprctl configerrors
```

---

## 🚀 Testing Checklist

- [ ] Drag floating window near screen edge - should snap
- [ ] Drag window near another window - should align
- [ ] Open new window in group - should auto-join
- [ ] Close all windows on workspace 2 - workspace should persist
- [ ] Open Wofi (Super) - should have blur and popin animation
- [ ] Check Waybar - should have blur
- [ ] Test precise mouse move - drag window to exact position

---

## ⚡ Performance Notes

**Good:**
- Layer blur is optimized (ignorezero, ignorealpha)
- Snapping only activates when dragging
- Group management has minimal overhead

**Watch Out For:**
- Too many persistent workspaces (3 is optimal)
- Layer blur on slower GPUs (can disable)
- Content type hints (test individually)

---

**Full documentation:** See `APPLIED_IMPROVEMENTS_v2.md`
