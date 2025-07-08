#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
    [6-9][0-9]|100) ICON="󰕾"; COLOR=$ACCENT_COLOR ;;
    [3-5][0-9]) ICON="󰖀"; COLOR=$YELLOW ;;
    [1-9]|[1-2][0-9]) ICON="󰕿"; COLOR=$ORANGE ;;
    *) ICON="󰖁"; COLOR=$RED ;;
  esac

  sketchybar --set "$NAME" icon="$ICON" \
                            icon.color="$COLOR" \
                            label="$VOLUME%"
fi
