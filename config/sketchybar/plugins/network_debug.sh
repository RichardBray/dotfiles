#!/bin/bash

# Ensure CONFIG_DIR is set
if [ -z "$CONFIG_DIR" ]; then
    CONFIG_DIR="$(dirname "$0")/.."
fi

source "$CONFIG_DIR/colors.sh"

LOG_FILE="$CONFIG_DIR/network_debug.log"
echo "Running network check at $(date)" >> "$LOG_FILE"
echo "Colors loaded: GREEN=$GREEN, RED=$RED" >> "$LOG_FILE"

# Get network interface statistics
# Try to find the main network interface (usually en0 for WiFi or en1 for Ethernet)
INTERFACE=$(route get default | grep interface | awk '{print $2}')
echo "Detected interface: $INTERFACE" >> "$LOG_FILE"

if [ -z "$INTERFACE" ]; then
    INTERFACE="en0"  # Fallback to en0
    echo "Falling back to default interface: $INTERFACE" >> "$LOG_FILE"
fi

# Get network stats
STATS=$(netstat -ibn | grep "$INTERFACE" | head -1)
echo "Network stats: $STATS" >> "$LOG_FILE"

if [ -n "$STATS" ]; then
    # Extract bytes in and out (columns 7 and 10)
    BYTES_IN=$(echo "$STATS" | awk '{print $7}')
    BYTES_OUT=$(echo "$STATS" | awk '{print $10}')
    
    # Convert to MB
    MB_IN=$((BYTES_IN / 1024 / 1024))
    MB_OUT=$((BYTES_OUT / 1024 / 1024))
    
    # Format for display
    if [ "$MB_IN" -gt 1024 ]; then
        IN_DISPLAY="$(echo "scale=1; $MB_IN/1024" | bc)G"
    else
        IN_DISPLAY="${MB_IN}M"
    fi
    
    if [ "$MB_OUT" -gt 1024 ]; then
        OUT_DISPLAY="$(echo "scale=1; $MB_OUT/1024" | bc)G"
    else
        OUT_DISPLAY="${MB_OUT}M"
    fi
    
    echo "Bytes: IN=$BYTES_IN, OUT=$BYTES_OUT" >> "$LOG_FILE"
    echo "MB: IN=$MB_IN, OUT=$MB_OUT" >> "$LOG_FILE"
    echo "Display: IN=$IN_DISPLAY, OUT=$OUT_DISPLAY" >> "$LOG_FILE"
    
    LABEL="↓${IN_DISPLAY} ↑${OUT_DISPLAY}"
else
    LABEL="No Data"
    echo "No network statistics available." >> "$LOG_FILE"
fi

# Check if we have an active connection
if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    COLOR=$GREEN
    ICON="󰖩"
    echo "Connection active. Color: $COLOR" >> "$LOG_FILE"
else
    COLOR=$RED
    ICON="󰖪"
    echo "No active connection. Color: $COLOR" >> "$LOG_FILE"
fi

# Update the network item
echo "Updating SketchyBar: ICON=$ICON, COLOR=$COLOR, LABEL=$LABEL" >> "$LOG_FILE"

# Use $NAME if set, otherwise default to 'network'
ITEM_NAME="${NAME:-network}"
echo "Setting item: $ITEM_NAME" >> "$LOG_FILE"
RESULT=$(sketchybar --set "$ITEM_NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL" 2>&1)
echo "SketchyBar result: $RESULT" >> "$LOG_FILE"

# End of script log
echo "Network check completed at $(date)" >> "$LOG_FILE"




