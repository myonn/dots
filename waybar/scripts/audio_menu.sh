#!/bin/bash

# Get current volume
vol=$(pamixer --get-volume)

# Get sinks list
mapfile -t sinks < <(pactl list short sinks | cut -f2)

# Format sink list into menu options
sink_entries=""
for sink in "${sinks[@]}"; do
    sink_entries+="--field=\"$sink\":fbtn "
done

yad --form \
    --title="Audio Menu" \
    --undecorated \
    --geometry=300x200+0+0 \
    --skip-taskbar \
    --mouse \
    --on-top \
    --no-buttons \
    --separator="," \
    --field="Volume:":scale "$vol" \
    $sink_entries \
    | while IFS=',' read -r new_vol "${sinks[@]}"; do
        pamixer --set-volume "$new_vol"
        for sink in "${sinks[@]}"; do
            [[ -n $sink ]] && pactl set-default-sink "$sink"
        done
    done
