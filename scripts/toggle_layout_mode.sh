#!/usr/bin/env bash
set -euo pipefail

current="$(hyprctl getoption general:layout -j | jq -r '.str // empty')"

if [[ "$current" == "scrolling" ]]; then
    next="dwindle"
else
    next="scrolling"
fi

hyprctl keyword general:layout "$next"

if [[ "$next" == "scrolling" ]]; then
    hyprctl dispatch layoutmsg fit active
    message="Scrolling layout enabled"
else
    message="Dwindle layout restored"
fi

hyprctl notify -1 2200 "rgb(33ccffee)" "$message"
