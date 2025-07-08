#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get WiFi information
WIFI_INFO=$(networksetup -getairportnetwork en0)

if [[ "$WIFI_INFO" == *"You are not associated with an AirPort network"* ]]; then
    # Not connected to WiFi
    ICON="󰖪"
    LABEL="Disconnected"
    COLOR=$RED
else
    # Connected to WiFi - extract network name
    NETWORK_NAME=$(echo "$WIFI_INFO" | sed 's/Current Wi-Fi Network: //')
    
    # Get signal strength (requires airport utility)
    if command -v airport >/dev/null 2>&1; then
        SIGNAL=$(airport -I | grep agrCtlRSSI | awk '{print $2}' | sed 's/-//')
        
        # Convert RSSI to percentage approximation
        if [ -n "$SIGNAL" ]; then
            if [ "$SIGNAL" -le 30 ]; then
                ICON="󰤨"  # Excellent
                COLOR=$GREEN
            elif [ "$SIGNAL" -le 50 ]; then
                ICON="󰤥"  # Good
                COLOR=$GREEN
            elif [ "$SIGNAL" -le 70 ]; then
                ICON="󰤢"  # Fair
                COLOR=$YELLOW
            else
                ICON="󰤟"  # Poor
                COLOR=$ORANGE
            fi
        else
            ICON="󰖩"
            COLOR=$BLUE
        fi
    else
        # Fallback if airport command not available
        ICON="󰖩"
        COLOR=$BLUE
    fi
    
    # Truncate long network names
    if [ ${#NETWORK_NAME} -gt 15 ]; then
        LABEL="${NETWORK_NAME:0:12}..."
    else
        LABEL="$NETWORK_NAME"
    fi
fi

# Update the WiFi item
sketchybar --set "$NAME" icon="$ICON" \
                        icon.color="$COLOR" \
                        label="$LABEL"
