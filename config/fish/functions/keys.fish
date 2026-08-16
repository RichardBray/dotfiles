function keys -d "Auto-detect and monitor keyboard changes"
    set config_dir /Users/robray/dotfiles/config/kanata
    set current_config ""
    set failures 0
    set max_failures 3

    function __keys_stop_kanata
        # Kill any existing kanata (including ones started via sudo)
        sudo -n /usr/bin/killall kanata 2>/dev/null
        /usr/bin/killall kanata 2>/dev/null
        sleep 1
    end

    function __keys_driver_ready
        # kanata talks to the Karabiner VirtualHIDDevice-Daemon; without it kanata
        # starts but spins forever on "connect_failed asio.system:61" (ECONNREFUSED).
        # The daemon is kept alive by /Library/LaunchDaemons/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist
        pgrep -qf Karabiner-VirtualHIDDevice-Daemon
    end

    if not __keys_driver_ready
        echo "❌ Karabiner-VirtualHIDDevice-Daemon is not running — kanata cannot reach the driver."
        echo "   Try: sudo launchctl kickstart -k system/org.pqrs.Karabiner-VirtualHIDDevice-Daemon"
        return 1
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
            set current_config $new_config
            set config_path "$config_dir/$current_config.kbd"

            if not test -f "$config_path"
                echo "❌ Config file not found: $config_path"
                set failures (math $failures + 1)
            else if not kanata --cfg "$config_path" --check
                # Validate before grabbing the keyboard: --check parses and exits
                # without touching input, so a broken config can never wedge typing.
                echo "❌ Config is invalid, refusing to start kanata: $config_path"
                set failures (math $failures + 1)
            else if not __keys_driver_ready
                echo "❌ VirtualHIDDevice-Daemon went away — not starting kanata."
                set failures (math $failures + 1)
            else
                __keys_stop_kanata

                if test "$current_config" = durgod
                    echo (date "+%H:%M:%S") "⌨️  DURGOD keyboard detected! Switching to durgod config 🎯"
                else
                    echo (date "+%H:%M:%S") "🖥️  No Durgod keyboard found! Switching to default config 📝"
                end

                sudo kanata --cfg "$config_path" --port 7070 &
                sleep 3
                sketchybar --reload
                set failures 0
            end

            if test $failures -ge $max_failures
                echo "❌ Giving up after $failures failed starts. Fix the above, then run keys again."
                __keys_stop_kanata
                return 1
            end
        end

        sleep 3 # Check every 3 seconds
    end
end
