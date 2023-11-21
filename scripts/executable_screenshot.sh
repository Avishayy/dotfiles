#!/bin/bash

# Sleep needed because otherwise mouse can't be captures and it causes an error
sleep 0.4

options=""
clipoard=false

for arg in "$@"
do
    case "$arg" in
        --window)  options="-window root" ;;
        --clipboard) clipboard=true ;;
    esac
done

# Move the mouse just a bit to show it so we'll see the capture cursor,
# as unclutter hides it
xdotool mousemove_relative --sync 1 1;

FILENAME=$HOME/Pictures/Screenshots/Screenshot_$(date +"%Y-%m-%dT%H:%M:%S").png
import $options $FILENAME

if [[ $clipboard ]]; then
    xclip -selection clipboard -t image/png -i $FILENAME
fi
