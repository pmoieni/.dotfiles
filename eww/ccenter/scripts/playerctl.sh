
#!/usr/bin/env bash

# Create the $HOME/.cache/eww directory if it doesn't exist
if [ ! -d "$HOME/.cache/eww" ]; then
  mkdir -p $HOME/.cache/eww
fi

artUrl=$(playerctl metadata | grep artUrl | awk '{ print $3 }')
status=$(playerctl status)
title=$(playerctl metadata --format '{{title}}')
artist=$(playerctl metadata --format '{{artist}}')

# Hash the song title
hash=$(echo -n "$title" | md5sum | awk '{ print $1 }')
imgpath=$HOME/.cache/eww/$hash.png

# Only write the image file if the hash doesn't already exist
if [ ! -f "$imgpath" ]; then
  if [ -n "$artUrl" ]; then
    # Remove the metadata from the start of the data URL
    base64Data=${artUrl#*,}

    # Write the base64 image data to the specified path
    echo $base64Data | base64 --decode > $imgpath
  else
    # Create a 100x100 black image
    convert -size 100x100 xc:black $imgpath
  fi
fi

artUrl="$imgpath"

json="{\"artUrl\":\"$artUrl\", \"status\":\"$status\", \"title\":\"$title\", \"artist\":\"$artist\"}"

echo $json
