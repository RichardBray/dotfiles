function keys -d "Auto-detect and monitor keyboard changes"
    set config_dir /Users/robray/dotfiles/config/kanata
    set current_config ""

    echo "Starting kanata with keyboard monitoring (Ctrl+C to stop)"

    while true
        # Detect current keyboard
        set new_config default
        if ioreg -p IOUSB | grep -q "DURGOD Taurus K320"
            set new_config durgod
        end

        # Restart kanata if config changed
        if test "$new_config" != "$current_config"
            # Kill existing kanata process
            pkill -f "kanata.*port 7070" 2>/dev/null
            sleep 1

            set current_config $new_config
            set config_path "$config_dir/$current_config.kbd"

            if test -f "$config_path"
            if test "$current_config" = durgod
                echo (date "+%H:%M:%S") "⌨️  DURGOD keyboard detected! Switching to durgod config 🎯"
            else
                echo (date "+%H:%M:%S") "🖥️  No Durgod keyboard found! Switching to default config 📝"
            end
            sudo -v 2>/dev/null || true
            sudo kanata --cfg "$config_path" --port 7070 &
            sleep 3
            sketchybar --reload
            else
                echo "Config file not found: $config_path"
            end
        end

        sleep 3 # Check every 3 seconds
    end
end
