#!/bin/bash

# Sleep needed because otherwise mouse can't be captures and it causes an error
sleep 0.4

options=""

if [[ "$1" == "--region" ]]; then
  options="--select capture"
fi

scrot $options -F "$HOME/Pictures/Screenshots/Screenshot_$(date +"%Y-%m-%dT%H:%M:%S").png"
