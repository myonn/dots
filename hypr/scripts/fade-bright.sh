#!/bin/bash

savefile="/tmp/last-brightness"
target=100  # fallback in case file is missing

if [[ -f "$savefile" ]]; then
    target=$(cat "$savefile")
fi

# Get current brightness
current=$(brightnessctl g)
max=$(brightnessctl m)
current_pct=$(( current * 100 / max ))

duration=2
steps=20
sleep_time=$(echo "$duration / $steps" | bc -l)

for ((i=current_pct; i<=target; i+=((target - current_pct)/steps))); do
    brightnessctl set "${i}%"
    sleep "$sleep_time"
done

brightnessctl set "${target}%"
