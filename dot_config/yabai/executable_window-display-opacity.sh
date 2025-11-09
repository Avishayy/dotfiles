#!/usr/bin/env bash
focused_window=$(yabai -m query --windows --window | jq -r '.id')
windows=$(yabai -m query --windows)

echo "$windows" | jq -c '.[]' | while read -r w; do
  id=$(echo "$w" | jq -r '.id')

  if [ "$id" -eq "$focused_window" ]; then
    yabai -m window "$id" --opacity 1.0
  else
    yabai -m window "$id" --opacity 0.9
  fi
done
