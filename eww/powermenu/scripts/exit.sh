#!/usr/bin/env bash

DESKTOP_SESSION=$(echo $XDG_CURRENT_DESKTOP)

if [ "$DESKTOP_SESSION" == "sway" ]; then
    swaymsg exit
elif [ "$DESKTOP_SESSION" == "hyprland" ]; then
    hyprctl dispatch exit 0
    sleep 2
    if pgrep -x Hyprland >/dev/null; then
        killall -9 Hyprland
    fi
fi
