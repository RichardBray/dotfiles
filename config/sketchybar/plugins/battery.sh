#!/bin/bash

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# Set icon based on battery level
case "${PERCENTAGE}" in
  9[0-9]|100) ICON="󰁹"; COLOR=$GREEN ;;
  [7-8][0-9]) ICON="󰂂"; COLOR=$GREEN ;;
  [5-6][0-9]) ICON="󰂀"; COLOR=$YELLOW ;;
  [3-4][0-9]) ICON="󰁾"; COLOR=$ORANGE ;;
  [1-2][0-9]) ICON="󰁻"; COLOR=$RED ;;
  *) ICON="󰂃"; COLOR=$RED ;;
esac

# Override with charging icon if plugged in
if [[ "$CHARGING" != "" ]]; then
  ICON="󰂄"
  COLOR=$BLUE
fi

# Update the item with battery status
sketchybar --set "$NAME" icon="$ICON" \
                          icon.color="$COLOR" \
                          label="${PERCENTAGE}%"
