#!/bin/bash

# Get active window JSON
json=$(hyprctl activewindow -j 2>/dev/null)

# If there's no active window, exit silently
if [ -z "$json" ] || [ "$json" = "null" ]; then
  exit 0
fi

# Extract class or initialClass
app=$(echo "$json" | jq -r '.class // .initialClass // empty')

# Only print if non-empty
[ -n "$app" ] && echo "$app"
