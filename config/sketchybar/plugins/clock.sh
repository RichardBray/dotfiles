#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get current date and time with day of week
DAY_OF_WEEK=$(date '+%a')
MONTH=$(date '+%b')
DAY=$(date '+%d')
TIME=$(date '+%H:%M')

# Update the clock items - date in bold, time in regular
if [[ "$NAME" == "clock.date" ]]; then
    # Date portion with bold font
    sketchybar --set "$NAME" label="$DAY_OF_WEEK $MONTH $DAY" \
                              label.font="SF Pro:Bold:15.0"
elif [[ "$NAME" == "clock.time" ]]; then
    # Time portion with regular font
    sketchybar --set "$NAME" icon="" \
                              label="$TIME" \
                              label.font="SF Pro:Regular:15.0"
else
    # Fallback for original single item
    sketchybar --set "$NAME" icon="" \
                              label="$DAY_OF_WEEK $MONTH $DAY $TIME" \
                              label.font="SF Pro:Bold:15.0"
fi

