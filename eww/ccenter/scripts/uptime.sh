#!/usr/bin/env bash

# Get the system boot time
boot_time=$(who -b | awk '{print $3 " " $4}')

# Convert the boot time to seconds since the epoch
boot_time_seconds=$(date -d"$boot_time" +%s)

# Get the current time in seconds since the epoch
current_time_seconds=$(date +%s)

# Calculate the uptime in seconds
uptime_seconds=$((current_time_seconds - boot_time_seconds))

# Calculate the number of days, hours, and minutes
days=$((uptime_seconds / 60 / 60 / 24))
hours=$((uptime_seconds / 60 / 60 % 24))
minutes=$((uptime_seconds / 60 % 60))

# Print the uptime in the format {number}d {number}h {number}m
echo "${days}d ${hours}h ${minutes}m"

