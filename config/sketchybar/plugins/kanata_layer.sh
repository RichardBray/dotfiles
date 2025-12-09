#!/bin/bash
# ~/.config/sketchybar/plugins/kanata_layer.sh
# Listens for Kanata layer changes and updates SketchyBar item

ITEM="kanata_layer"

# Define your layers (add as many as you like)
# Format: "layer_name:color:label:icon"
LAYERS="base:0xff8aadf4:BASE:󰌌 editor:0xffa6da95:EDITOR:󰏒"

# Function to update the item
update_item() {
  local layer="$1"
  local layer_config
  
  # Find the layer configuration
  for config in $LAYERS; do
    if [[ "$config" == "$layer:"* ]]; then
      layer_config="$config"
      break
    fi
  done
  
  if [[ -n "$layer_config" ]]; then
    IFS=':' read -r layer_name color label icon <<< "$layer_config"
    sketchybar --set "$ITEM" \
               icon.color="$color" \
               label.color="$color" \
               label="$label" \
               icon="$icon" >/dev/null 2>&1
  fi
}

# Function to get layer from Kanata with timeout
get_kanata_layer() {
  # Use gtimeout if available, otherwise use a simple approach
  if command -v gtimeout >/dev/null 2>&1; then
    gtimeout 1 nc localhost 7070 2>/dev/null | head -1 | jq -r '.LayerChange.new // empty' 2>/dev/null
  else
    # Simple timeout using background process
    nc localhost 7070 2>/dev/null | head -1 | jq -r '.LayerChange.new // empty' 2>/dev/null &
    local pid=$!
    sleep 1
    kill $pid 2>/dev/null || true
    wait $pid 2>/dev/null || true
  fi
}

# Try to get initial layer from Kanata
initial_layer=$(get_kanata_layer)
if [[ -n "$initial_layer" ]]; then
  update_item "$initial_layer"
fi

# Keep reconnecting forever to listen for layer changes
while true; do
  nc localhost 7070 2>/dev/null | while IFS= read -r line; do
    [[ -z "$line" ]] && continue

    # Extract only the .LayerChange.new field
    layer=$(echo "$line" | jq -r '.LayerChange.new // empty' 2>/dev/null)

    # If we got a valid layer name → update SketchyBar
    [[ -n "$layer" ]] && update_item "$layer"
  done

  echo "Kanata disconnected – reconnecting in 2 seconds…" >&2
  sleep 2
done
