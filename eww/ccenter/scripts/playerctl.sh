#!/usr/bin/env bash

artUrl=$(playerctl metadata | grep artUrl | awk '{ print $3 }')
status=$(playerctl status)
title=$(playerctl metadata --format '{{title}}')
artist=$(playerctl metadata --format '{{artist}}')

json="{\"artUrl\":\"$artUrl\", \"status\":\"$status\", \"title\":\"$title\", \"artist\":\"$artist\"}"

echo $json
