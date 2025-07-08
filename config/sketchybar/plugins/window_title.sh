#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get the window title - optimized for AeroSpace
if command -v aerospace >/dev/null 2>&1; then
    # Use AeroSpace to get the focused window title
    WINDOW_TITLE=$(aerospace list-windows --focused --format '%{window-title}' 2>/dev/null)
else
    # Fallback: try to get frontmost application window title
    WINDOW_TITLE=$(osascript -e '
        try
            tell application "System Events"
                set frontApp to name of first application process whose frontmost is true
                tell process frontApp
                    set windowTitle to name of front window
                end tell
                return windowTitle
            end tell
        on error
            return ""
        end try
    ' 2>/dev/null)
fi

# Clean up and limit the title length
if [ -n "$WINDOW_TITLE" ] && [ "$WINDOW_TITLE" != "null" ] && [ "$WINDOW_TITLE" != "" ]; then
    # Remove common prefixes and suffixes
    CLEAN_TITLE=$(echo "$WINDOW_TITLE" | sed -E 's/ - [^-]*$//g' | sed -E 's/^[^-]* - //g')
    
    # Limit length
    if [ ${#CLEAN_TITLE} -gt 50 ]; then
        DISPLAY_TITLE="${CLEAN_TITLE:0:47}..."
    else
        DISPLAY_TITLE="$CLEAN_TITLE"
    fi
else
    DISPLAY_TITLE=""
fi

# Update the window title item
if [ -n "$DISPLAY_TITLE" ]; then
    sketchybar --set "$NAME" label="$DISPLAY_TITLE" \
                            label.color="$LABEL_COLOR"
else
    sketchybar --set "$NAME" label="" 
fi
