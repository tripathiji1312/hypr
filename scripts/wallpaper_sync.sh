#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/.config/hypr/wallpaper}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr"
STATE_FILE="$CACHE_DIR/last_wallpaper"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

mkdir -p "$CACHE_DIR"

start_hyprpaper_daemon() {
    if pgrep -x hyprpaper >/dev/null 2>&1; then
        pkill -x hyprpaper
    fi

    hyprpaper >/dev/null 2>&1 &

    for _ in $(seq 1 100); do
        if pgrep -x hyprpaper >/dev/null 2>&1; then
            return 0
        fi
        sleep 0.1
    done

    return 1
}

update_hyprpaper_config() {
    local wallpaper_path="$1"

    if [[ -f "$HYPRPAPER_CONF" ]]; then
        sed -i "s|^\([[:space:]]*path = \).*|\1$wallpaper_path|" "$HYPRPAPER_CONF"
    fi
}

pick_wallpaper() {
    local requested_path="${1:-}"

    if [[ -n "$requested_path" && -f "$requested_path" ]]; then
        printf '%s\n' "$requested_path"
        return 0
    fi

    if [[ -f "$STATE_FILE" ]]; then
        local cached_path
        cached_path="$(<"$STATE_FILE")"
        if [[ -f "$cached_path" ]]; then
            printf '%s\n' "$cached_path"
            return 0
        fi
    fi

    find "$WALLPAPER_DIR" -type f | shuf -n 1
}

main() {
    local wallpaper_path
    wallpaper_path="$(pick_wallpaper "${1:-}")"

    if [[ -z "$wallpaper_path" || ! -f "$wallpaper_path" ]]; then
        echo "No wallpaper found in $WALLPAPER_DIR" >&2
        exit 1
    fi

    update_hyprpaper_config "$wallpaper_path"
    start_hyprpaper_daemon || true

    printf '%s\n' "$wallpaper_path" > "$STATE_FILE"
    printf '%s\n' "$wallpaper_path"
}

main "${1:-}"