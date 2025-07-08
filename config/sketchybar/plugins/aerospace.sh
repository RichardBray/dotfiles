#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

# Source colors
source "$CONFIG_DIR/colors.sh"

# The workspace ID passed as argument
WORKSPACE_ID="$1"

# Get the current focused workspace either from environment variable or command
if [ -n "$FOCUSED_WORKSPACE" ]; then
    CURRENT_WORKSPACE="$FOCUSED_WORKSPACE"
else
    CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
fi

if [ "$WORKSPACE_ID" = "$CURRENT_WORKSPACE" ]; then
    sketchybar --set $NAME \
      background.drawing=on \
      background.color=$FOCUSED_COLOR \
      label.color=$WHITE
else
    sketchybar --set $NAME \
      background.drawing=off \
      label.color=$LABEL_COLOR
fi
