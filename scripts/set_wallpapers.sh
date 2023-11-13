#!/bin/bash

# Define your wallpapers
LAPTOP_WALLPAPER="$HOME/assets/laptop_wallpaper.webp"
DUAL_MONITOR_WALLPAPER="$HOME/assets/long_wallpaper.webp"

# Get the names of the monitors and their respective resolutions
MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)
LAPTOP_MONITOR=$(echo "$MONITORS" | head -n 1) # assuming the first one is the laptop
EXTERNAL_MONITORS=$(echo "$MONITORS" | tail -n +2) # all others are considered external

# Check if two external monitors are connected
if [ $(echo "$EXTERNAL_MONITORS" | wc -l) -eq 2 ]; then
  # Set the dual monitor wallpaper
  feh --no-fehbg --bg-scale --no-xinerama "$DUAL_MONITOR_WALLPAPER"
else
  # Only the laptop monitor is in use, set the laptop wallpaper
  feh --no-fehbg --bg-scale "$LAPTOP_WALLPAPER"
fi
