#!/bin/bash

savefile="/tmp/last-brightness"

# Get current brightness as %
current=$(brightnessctl g)
max=$(brightnessctl m)
current_pct=$(( current * 100 / max ))

# Save to temp file
echo "$current_pct" > "$savefile"

# Target
target=5
duration=2
steps=20
sleep_time=$(echo "$duration / $steps" | bc -l)

for ((i=current_pct; i>=target; i-=((current_pct - target)/steps))); do
    brightnessctl set "${i}%"
    sleep "$sleep_time"
done

brightnessctl set "${target}%"
