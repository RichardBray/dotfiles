#!/bin/bash

#BUG: This is used instead of the 'exec-on-workspace-changed' callback due to a bug in
# causing the callback to fire 3 times (focused -> target -> focused -> target) for single workspace change
# this cause desync due to race conditions
CURRENT_WORKSPACE="$(aerospace list-workspaces --focused)"
NEXT_WORKSPACE=$1

aerospace move-node-to-workspace "$NEXT_WORKSPACE"
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$NEXT_WORKSPACE" PREV_WORKSPACE="$CURRENT_WORKSPACE"
~/.config/aerospace/workspace_change.sh "$NEXT_WORKSPACE"
