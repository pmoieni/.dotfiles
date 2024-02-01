#!/usr/bin/env bash

workspaces=$(swaymsg -rt get_workspaces)

get_workspaces() {
    echo -n "(box :orientation 'vertical' :class 'bar-box bar-desktop' :space-evenly false :tooltip 'workspaces' "
    echo -n $workspaces | jq -r -j '.[] | "(button  :class \"bar-workspace" + (if .urgent then " bar-workspace-urgent" elif .focused then " bar-workspace-focused" else "" end) + "\"  :tooltip \"" + (.representation | split("[")[1] | rtrimstr("]")) + "\"  :onclick \"" + ("swaymsg workspace " + .name) + "\"  (label :text \"" + (if .urgent then "󰀨" else (if .focused then "󰺕" else "" end) end) + "\"))"'
    echo -n ")"
}

get_workspaces
#swaymsg -m -t subscribe '["workspace"]' | while read -r _ ; do
#get_workspaces
#done

