
#!/usr/bin/env bash

# Create the ~/.cache/eww directory if it doesn't exist
if [ ! -d "$HOME/.cache/eww" ]; then
  mkdir -p $HOME/.cache/eww
fi

imgpath=$HOME/.cache/eww/art.jpg
titlepath=$HOME/.cache/eww/title.txt
input_title=$1  # Get the input title from the command line argument

artUrl=$(playerctl metadata | grep artUrl | awk '{ print $3 }')
status=$(playerctl status)
title=$(playerctl metadata --format '{{title}}')
artist=$(playerctl metadata --format '{{artist}}')

# Get the previous song title
if [ -f "$titlepath" ]; then
  prev_title=$(cat $titlepath)
else
  prev_title=""
fi

# Only write the image file if a new song is playing and it's not the same as the input title
if [ "$title" != "$prev_title" ]; then
  if [ -n "$artUrl" ]; then
    # Remove the metadata from the start of the data URL
    base64Data=${artUrl#*,}

    # Write the base64 image data to the specified path
    echo $base64Data | base64 --decode > $imgpath

    # Make the image darker
    convert $imgpath -brightness-contrast -30 $imgpath
  else
    # Create a 100x100 black image
    convert -size 100x100 xc:black $imgpath
  fi

  echo $title > $titlepath 
fi

artUrl="$imgpath"

json="{\"artUrl\":\"$artUrl\", \"status\":\"$status\", \"title\":\"$title\", \"artist\":\"$artist\"}"

echo $json

