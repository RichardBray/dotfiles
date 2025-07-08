#!/usr/bin/env bash

# Update all aerospace workspace indicators
# This script is called by aerospace's exec-on-workspace-change

# Source colors
source "$CONFIG_DIR/colors.sh"

# Get the current focused workspace
CURRENT_WORKSPACE="$1"

# If no argument provided, get it from aerospace
if [ -z "$CURRENT_WORKSPACE" ]; then
    CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
fi

# Update all workspace indicators
for workspace in 1 2 3 4 5 6 7; do
    if [ "$workspace" = "$CURRENT_WORKSPACE" ]; then
        # Highlight the focused workspace
        sketchybar --set space.$workspace \
          background.drawing=on \
          background.color=$FOCUSED_COLOR \
          label.color=$WHITE
    else
        # Unhighlight other workspaces
        sketchybar --set space.$workspace \
          background.drawing=off \
          label.color=$LABEL_COLOR
    fi
done

