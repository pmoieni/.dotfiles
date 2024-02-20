#!/usr/bin/env bash

hyprctl dispatch exit 0
sleep 2
if pgrep -x Hyprland >/dev/null; then
    killall -9 Hyprland
fi
