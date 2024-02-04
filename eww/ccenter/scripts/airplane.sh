#!/usr/bin/env bash

# Get the output of 'rfkill list all'
output=$(rfkill list all)

# Check if 'Soft blocked: yes' or 'Hard blocked: yes' is in the output
if echo "$output" | grep -q "Soft blocked: yes\|Hard blocked: yes"; then
    echo true
else
    echo false
fi
