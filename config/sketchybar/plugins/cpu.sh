#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get CPU usage percentage
CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')

# Handle case where CPU_USAGE might be empty
if [ -z "$CPU_USAGE" ]; then
    CPU_USAGE="0"
fi

# Remove any decimal points for comparison and round to integer
CPU_INT=$(echo "$CPU_USAGE" | cut -d'.' -f1)
CPU_USAGE=$(printf "%.0f" "$CPU_USAGE")

# Set color based on CPU usage
if [ "$CPU_INT" -ge 80 ]; then
    COLOR=$RED
elif [ "$CPU_INT" -ge 60 ]; then
    COLOR=$ORANGE
elif [ "$CPU_INT" -ge 40 ]; then
    COLOR=$YELLOW
else
    COLOR=$GREEN
fi

# Update the CPU item
sketchybar --set "$NAME" icon="" \
                        icon.color="$COLOR" \
                        label="CPU ${CPU_USAGE}%" \
                        background.color=$ITEM_BG_COLOR \
                        background.border_color=$BORDER_COLOR \
                        background.drawing=on
