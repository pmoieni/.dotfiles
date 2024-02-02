#!/usr/bin/env bash

function get_workspaces() {
    output=$(swaymsg -rt get_workspaces)

    workspaces=$(echo "$output" | jq -c '[.[] | {focused: .focused, urgent: .urgent, onclick: ("swaymsg workspace " + (.num|tostring)), tooltip: .representation}]')

    echo "$workspaces"
}

get_workspaces

swaymsg -t subscribe '["workspace"]' --monitor | {
    while read -r event; do
        get_workspaces
    done
}
