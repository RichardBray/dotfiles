#!/bin/bash

# Ensure CONFIG_DIR is set
if [ -z "$CONFIG_DIR" ]; then
    CONFIG_DIR="$(dirname "$0")/.."
fi

source "$CONFIG_DIR/colors.sh"

# Get network interface statistics
# Try to find the main network interface (usually en0 for WiFi or en1 for Ethernet)
INTERFACE=$(route get default | grep interface | awk '{print $2}')

if [ -z "$INTERFACE" ]; then
    INTERFACE="en0"  # Fallback to en0
fi

# Get network stats
STATS=$(netstat -ibn | grep "$INTERFACE" | head -1)

if [ -n "$STATS" ]; then
    # Extract bytes in and out (columns 7 and 10)
    BYTES_IN=$(echo "$STATS" | awk '{print $7}')
    BYTES_OUT=$(echo "$STATS" | awk '{print $10}')
    
    # Convert to MB
    MB_IN=$((BYTES_IN / 1024 / 1024))
    MB_OUT=$((BYTES_OUT / 1024 / 1024))
    
    # Format for display
    if [ "$MB_IN" -gt 1024 ]; then
        IN_DISPLAY="$(echo "scale=1; $MB_IN/1024" | bc)GB"
    else
        IN_DISPLAY="${MB_IN}MB"
    fi
    
    if [ "$MB_OUT" -gt 1024 ]; then
        OUT_DISPLAY="$(echo "scale=1; $MB_OUT/1024" | bc)GB"
    else
        OUT_DISPLAY="${MB_OUT}MB"
    fi
    
    LABEL="↓${IN_DISPLAY} ↑${OUT_DISPLAY}"
else
    LABEL="No Data"
fi

# Check if we have an active connection
if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    COLOR=$GREEN
    ICON="󰖩"
else
    COLOR=$RED
    ICON="󰖪"
fi

# Update the network item
# Use $NAME if set, otherwise default to 'network'
ITEM_NAME="${NAME:-network}"
sketchybar --set "$ITEM_NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL"
