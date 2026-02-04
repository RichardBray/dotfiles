function keys -d "Auto-detect and monitor keyboard changes"
    set config_dir /Users/robray/dotfiles/config/kanata
    set current_config ""

    function __keys_stop_kanata
        # Kill any existing kanata (including ones started via sudo)
        sudo -n /usr/bin/killall kanata 2>/dev/null
        /usr/bin/killall kanata 2>/dev/null
        sleep 1
    end

    function __keys_stop_karabiner_grabbers
        # Keep Karabiner's VirtualHIDDevice daemon; stop only the parts that can
        # seize/grab physical keyboards and block IOHIDDeviceOpen.
        set -l labels \
            org.pqrs.service.agent.Karabiner-Core-Service \
            org.pqrs.service.agent.Karabiner-Menu \
            org.pqrs.service.agent.Karabiner-NotificationWindow \
            org.pqrs.service.agent.karabiner_console_user_server \
            org.pqrs.service.agent.karabiner_session_monitor

        for lbl in $labels
            launchctl stop $lbl 2>/dev/null
        end

        pkill -f '[K]arabiner-Core-Service' 2>/dev/null
        pkill -f '[K]arabiner-Menu' 2>/dev/null
        pkill -f '[K]arabiner-NotificationWindow' 2>/dev/null
        pkill -f '[k]arabiner_console_user_server' 2>/dev/null
        pkill -f '[k]arabiner_session_monitor' 2>/dev/null
        sleep 1
    end

    echo "Starting kanata with keyboard monitoring (Ctrl+C to stop)"

    while true
        # Detect current keyboard
        set new_config default
        if ioreg -p IOUSB | grep -q "DURGOD Taurus K320"
            set new_config durgod
        end

        # Restart kanata if config changed
        if test "$new_config" != "$current_config"
            __keys_stop_kanata
            __keys_stop_karabiner_grabbers

            set current_config $new_config
            set config_path "$config_dir/$current_config.kbd"

            if test -f "$config_path"
            if test "$current_config" = durgod
                echo (date "+%H:%M:%S") "⌨️  DURGOD keyboard detected! Switching to durgod config 🎯"
            else
                echo (date "+%H:%M:%S") "🖥️  No Durgod keyboard found! Switching to default config 📝"
            end
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
