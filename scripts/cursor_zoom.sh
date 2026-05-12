#!/usr/bin/env bash
set -euo pipefail

action="${1:-toggle}"
current="$(hyprctl getoption cursor:zoom_factor -j | jq -r '.float // 1')"
next="$current"
message="Cursor zoom unchanged"

case "$action" in
    in)
        next="$(jq -n --argjson value "$current" '($value * 1.1)')"
        message="Cursor zoom: in"
        ;;
    out)
        next="$(jq -n --argjson value "$current" '($value * 0.9) | if . < 1 then 1 else . end')"
        message="Cursor zoom: out"
        ;;
    reset)
        next="1"
        message="Cursor zoom reset"
        ;;
    toggle)
        next="$(jq -n --argjson value "$current" 'if $value > 1 then 1 else 1.5 end')"
        message="Cursor zoom toggled"
        ;;
    *)
        echo "Usage: $0 {in|out|reset|toggle}" >&2
        exit 2
        ;;
esac

hyprctl keyword cursor:zoom_factor "$next" >/dev/null
hyprctl notify -1 1500 "rgb(33ccffee)" "$message ($next)x" >/dev/null 2>&1 || true
