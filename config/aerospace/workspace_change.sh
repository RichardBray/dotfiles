#!/bin/bash

#BUG: This is used instead of the 'exec-on-workspace-changed' callback due to a bug in
# causing the callback to fire 3 times (focused -> target -> focused -> target) for single workspace change
# this cause desync due to race conditions
CURRENT_WORKSPACE="$(aerospace list-workspaces --focused)"
NEXT_WORKSPACE=$1

# Update sketchybar directly
/Users/richardoliverbray/.config/sketchybar/plugins/aerospace_update_all.sh "$NEXT_WORKSPACE"
aerospace workspace "$NEXT_WORKSPACE"
