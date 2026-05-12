# Hyprland Lua Migration Workspace

This folder starts a safe Lua migration without switching your live runtime config.

## What is implemented
- Modular Lua source files under `lua/modules/`.
- A Lua builder script `lua/build.lua` that generates a full modular config:
  - Migrated modules: settings, decorations, animations, autostart, window, keybinds.
  - No legacy source dependency in generated output.
- Generated output written to `lua/generated/hyprland.conf`.

## Why this approach
- Zero-disruption start.
- Easy rollback (your active `hyprland.conf` remains in control).
- Lets us migrate high-risk parts (window rules, keybinds) in controlled steps.

## Build generated config
```bash
cd ~/.config/hypr/lua
lua build.lua
```

## Optional dry-run test
```bash
hyprctl reload
hyprctl configerrors
```

## Next migration steps
1. Point main startup to generated config only after parity tests pass.
2. Keep rollback by toggling source lines in `hyprland.conf`.
3. Optionally refactor modules from raw-line format into richer Lua abstractions.
