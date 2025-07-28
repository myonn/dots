#!/bin/bash

LOCKFILE="/tmp/hypr_toggle_mic.lock"
COOLDOWN_MS=500

# If lock exists and cooldown hasn't passed, exit
if [[ -f "$LOCKFILE" ]]; then
    last_time=$(cat "$LOCKFILE")
    now_time=$(date +%s%3N)
    diff=$((now_time - last_time))

    if (( diff < COOLDOWN_MS )); then
        exit 0
    fi
fi

# Save current time as last trigger time
date +%s%3N > "$LOCKFILE"

SOURCE="@DEFAULT_AUDIO_SOURCE@"

IS_MUTED=$(wpctl get-volume "$SOURCE" | grep -o "MUTED")

if [[ "$IS_MUTED" == "MUTED" ]]; then
    wpctl set-mute "$SOURCE" 0
    notify-send "🎤 Mic unmuted"
else
    wpctl set-mute "$SOURCE" 1
    notify-send "🎤 Mic muted"
fi
