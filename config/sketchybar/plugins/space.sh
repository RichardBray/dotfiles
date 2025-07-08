#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.drawing=on \
                            background.color=$ACCENT_COLOR \
                            icon.color=$BLACK \
                            label.color=$BLACK
else
  sketchybar --set "$NAME" background.drawing=off \
                            icon.color=$ICON_COLOR \
                            label.color=$LABEL_COLOR
fi
