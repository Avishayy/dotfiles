#!/bin/bash

DEVICE_ID=$(xinput | grep -oP "Touchpad\s+id=\K\d+")
IS_ENABLED=$(xinput list-props $DEVICE_ID | grep -oP "Device Enabled.*:\s+\K\d")

if [ $IS_ENABLED -eq "1" ]; then
    xinput disable $DEVICE_ID
else
    xinput enable $DEVICE_ID
fi
