function toggle_aerospace_padding --description "Toggle AeroSpace outer.top padding between 40 and 110"
    set config_file (realpath ~/.aerospace.toml)

    # Get current padding value more precisely
    set current_padding (grep "^outer\.top" $config_file | grep -o "[0-9]\+")

    echo "Current outer.top padding: $current_padding"

    if test "$current_padding" = 40
        # Change to 110
        sed -i '' 's/^outer\.top.*$/outer.top =        110/' $config_file
        echo "Switched outer.top padding to 110"
    else
        # Change to 40 (default for any other value)
        sed -i '' 's/^outer\.top.*$/outer.top =        40/' $config_file
        echo "Switched outer.top padding to 40"
    end

    # Reload AeroSpace config to apply changes
    aerospace reload-config
    echo "AeroSpace config reloaded"
end
