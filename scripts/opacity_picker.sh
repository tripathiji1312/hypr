#!/usr/bin/env bash
set -euo pipefail

# Minimal fallback picker: cycles active window opacity presets.
state_file="${XDG_RUNTIME_DIR:-/tmp}/hypr-opacity-state"
current="1"

if [[ -f "$state_file" ]]; then
  current="$(cat "$state_file" 2>/dev/null || echo 1)"
fi

case "$current" in
  1)
    next="2"
    active="0.95"
    inactive="0.85"
    ;;
  2)
    next="3"
    active="0.88"
    inactive="0.78"
    ;;
  *)
    next="1"
    active="1.0"
    inactive="1.0"
    ;;
esac

echo "$next" > "$state_file"
hyprctl setprop active alpha "$active"
hyprctl setprop active alphainactive "$inactive"
notify-send "Opacity" "Active: $active | Inactive: $inactive"
