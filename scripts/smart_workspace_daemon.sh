#!/usr/bin/env bash
set -euo pipefail

SOCKET="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/smart-workspaces"

mkdir -p "$CACHE_DIR"

current_workspace_id() {
    hyprctl activeworkspace -j | jq -r '.id // empty'
}

current_window_address() {
    hyprctl activewindow -j | jq -r '.address // empty'
}

workspace_client_count() {
    local workspace_id="$1"

    hyprctl clients -j | jq -r --argjson ws "$workspace_id" '
        [ .[] | select(.workspace.id == $ws and (.floating | not)) ] | length
    '
}

remember_focused_window() {
    local workspace_id window_address

    workspace_id="$(current_workspace_id)"
    window_address="$(current_window_address)"

    [[ "$workspace_id" =~ ^[0-9]+$ ]] || return 0
    [[ -n "$window_address" ]] || return 0

    printf '%s\n' "$window_address" > "$CACHE_DIR/ws-$workspace_id.last"
}

apply_workspace_style() {
    local workspace_id count current_mode next_mode mode_file

    workspace_id="$(current_workspace_id)"
    [[ "$workspace_id" =~ ^[0-9]+$ ]] || return 0

    count="$(workspace_client_count "$workspace_id")"
    next_mode="spacious"
    if [[ "$count" -le 1 ]]; then
        next_mode="minimal"
    fi

    mode_file="$CACHE_DIR/ws-$workspace_id.mode"
    current_mode=""
    if [[ -f "$mode_file" ]]; then
        current_mode="$(<"$mode_file")"
    fi

    if [[ "$next_mode" == "$current_mode" ]]; then
        return 0
    fi

    if [[ "$next_mode" == "minimal" ]]; then
        hyprctl keyword workspace "$workspace_id, gapsin:0, gapsout:0, border:false, rounding:false, shadow:false" >/dev/null
    else
        hyprctl keyword workspace "$workspace_id, gapsin:4, gapsout:8, border:true, rounding:true, shadow:true" >/dev/null
    fi

    printf '%s\n' "$next_mode" > "$mode_file"
}

restore_focused_window() {
    local workspace_id memory_file remembered_address current_address

    workspace_id="$(current_workspace_id)"
    [[ "$workspace_id" =~ ^[0-9]+$ ]] || return 0

    memory_file="$CACHE_DIR/ws-$workspace_id.last"
    [[ -f "$memory_file" ]] || return 0

    remembered_address="$(<"$memory_file")"
    [[ -n "$remembered_address" ]] || return 0

    current_address="$(current_window_address)"
    [[ "$remembered_address" != "$current_address" ]] || return 0

    if hyprctl clients -j | jq -e --arg addr "$remembered_address" --argjson ws "$workspace_id" '
        any(.[]; .address == $addr and .workspace.id == $ws)
    ' >/dev/null; then
        hyprctl dispatch focuswindow "address:$remembered_address" >/dev/null 2>&1 || true
        return 0
    fi

    rm -f "$memory_file"
}

notify_empty_workspace() {
    local workspace_id count

    workspace_id="$(current_workspace_id)"
    [[ "$workspace_id" =~ ^[0-9]+$ ]] || return 0

    count="$(workspace_client_count "$workspace_id")"
    if [[ "$count" -eq 0 ]]; then
        hyprctl notify -1 1800 "rgb(33ccffee)" "Workspace $workspace_id is empty"
    fi
}

handle_event() {
    local event_name="$1"

    case "$event_name" in
        activewindow)
            remember_focused_window
            ;;
        workspace)
            sleep 0.08
            apply_workspace_style
            restore_focused_window
            notify_empty_workspace
            ;;
        openwindow|closewindow|movewindow|createworkspace|destroyworkspace)
            apply_workspace_style
            ;;
    esac
}

while IFS= read -r line; do
    event_name="${line%%>>*}"
    handle_event "$event_name"
done < <(socat -u "UNIX-CONNECT:$SOCKET" -)