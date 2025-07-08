#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get current date and time with day of week
DATE=$(date '+%a %b %d')
TIME=$(date '+%H:%M')

# Update the clock item
sketchybar --set "$NAME" icon="" \
                          label="$DATE $TIME"

