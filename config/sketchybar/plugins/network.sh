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

# Commented out data transfer stats - may use later
# STATS=$(netstat -ibn | grep "$INTERFACE" | head -1)
# if [ -n "$STATS" ]; then
#     # Extract bytes in and out (columns 7 and 10)
#     BYTES_IN=$(echo "$STATS" | awk '{print $7}')
#     BYTES_OUT=$(echo "$STATS" | awk '{print $10}')
#     
#     # Convert to MB
#     MB_IN=$((BYTES_IN / 1024 / 1024))
#     MB_OUT=$((BYTES_OUT / 1024 / 1024))
#     
#     # Format for display
#     if [ "$MB_IN" -gt 1024 ]; then
#         IN_DISPLAY="$(echo "scale=1; $MB_IN/1024" | bc)GB"
#     else
#         IN_DISPLAY="${MB_IN}MB"
#     fi
#     
#     if [ "$MB_OUT" -gt 1024 ]; then
#         OUT_DISPLAY="$(echo "scale=1; $MB_OUT/1024" | bc)GB"
#     else
#         OUT_DISPLAY="${MB_OUT}MB"
#     fi
#     
#     LABEL="↓${IN_DISPLAY} ↑${OUT_DISPLAY}"
# else
#     LABEL="No Data"
# fi

# Get connection speed/info
if [ "$INTERFACE" = "en0" ]; then
    # Check if it's WiFi first using system_profiler
    WIFI_NAME=$(system_profiler SPAirPortDataType | awk '/Current Network Information:/,/PHY Mode:/ {if ($0 ~ /:$/ && $0 !~ /Current Network Information:/ && $0 !~ /PHY Mode:/) print $1}' | sed 's/:$//' | head -1)

    if [ -z "$WIFI_NAME" ]; then
        # Not WiFi, check if en0 is active for other connection types
        if ifconfig en0 | grep -q "status: active"; then
            # en0 is active but not WiFi - likely Ethernet or Thunderbolt
            LABEL="Wired"
        else
            LABEL="Disconnected"
        fi
    else
        # WiFi connection - use detected network name
        LABEL="$WIFI_NAME"

        # Get signal strength if airport utility is available
        if command -v airport > /dev/null 2>&1; then
            SIGNAL=$(airport -I | grep agrCtlRSSI | awk '{print $2}' | sed 's/-//')
            if [ -n "$SIGNAL" ] && [ "$SIGNAL" -le 100 ]; then
                # Convert RSSI to approximate signal percentage
                if [ "$SIGNAL" -le 30 ]; then
                    SIGNAL_PERCENT="Excellent"
                elif [ "$SIGNAL" -le 50 ]; then
                    SIGNAL_PERCENT="Good"
                elif [ "$SIGNAL" -le 70 ]; then
                    SIGNAL_PERCENT="Fair"
                else
                    SIGNAL_PERCENT="Poor"
                fi
                LABEL="$WIFI_NAME ($SIGNAL_PERCENT)"
            fi
        fi

        # Truncate long network names
        if [ ${#LABEL} -gt 20 ]; then
            LABEL="${LABEL:0:17}..."
        fi
    fi
elif [ "$INTERFACE" = "en1" ] || [[ "$INTERFACE" == en* ]]; then
    # Other Ethernet interfaces
    LABEL="Ethernet"
else
    # Unknown interface type
    LABEL="Connected"
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
