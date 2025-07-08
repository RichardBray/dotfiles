#!/bin/bash

# Color Scheme for SketchyBar
# Based on popular developer configurations

# Define color variables
export BLACK=0xff181926
export WHITE=0xffcad3f5
export RED=0xffed8796
export GREEN=0xffa6da95
export BLUE=0xff8aadf4
export YELLOW=0xffeed49f
export ORANGE=0xfff5a97f
export MAGENTA=0xffc6a0f6
export GREY=0xff939ab7
export TRANSPARENT=0x00000000

# Bar colors
export BAR_COLOR=0x00000000          # Fully transparent
export BORDER_COLOR=0x80c0c0c0       # Light border

# Item colors
export ITEM_BG_COLOR=0x44000000      # Semi-transparent for items
export ACCENT_COLOR=$BLUE            # Blue accent
export ICON_COLOR=$WHITE             # White icons
export LABEL_COLOR=$WHITE            # White labels
export SEPARATOR_COLOR=$GREY         # Grey separators

# Special states
export FOCUSED_COLOR=$ORANGE         # Orange for focused items
export ACTIVE_COLOR=$GREEN           # Green for active items
export INACTIVE_COLOR=$GREY          # Grey for inactive items
