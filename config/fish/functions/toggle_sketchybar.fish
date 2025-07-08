function toggle_sketchybar --description "Toggle SketchyBar visibility on/off"
    if pgrep -x "sketchybar" > /dev/null
        set -l current_state (sketchybar --query bar | jq -r '.hidden')
        if test "$current_state" = "on"
            sketchybar --bar hidden=off
            echo "SketchyBar shown"
        else
            sketchybar --bar hidden=on
            echo "SketchyBar hidden"
        end
    else
        echo "SketchyBar is not running. Starting it..."
        brew services start sketchybar
        echo "SketchyBar started"
    end
end
