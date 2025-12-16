function keys -d "Start kanata with specified config"
    set config $argv[1]
    
    if test -z "$config"
        echo "Usage: keys <config_name>"
        echo "Available configs: durgod, default"
        return 1
    end
    
    set config_path "/Users/richardoliverbray/.config/kanata/$config.kbd"
    
    if not test -f "$config_path"
        echo "Config file not found: $config_path"
        return 1
    end
    
    echo "Starting kanata with config: $config"
    sudo kanata --cfg "$config_path" --port 7070
end
