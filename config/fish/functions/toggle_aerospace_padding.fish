function toggle_aerospace_padding --description "Toggle AeroSpace outer.top padding between 20 and 40"
    set config_file ~/dotfiles/aerospace.toml
    
    # Get current padding value more precisely
    set current_padding (grep "^outer\.top" $config_file | grep -o "[0-9]\+")
    
    echo "Current outer.top padding: $current_padding"
    
    if test "$current_padding" = "20"
        # Change to 40
        sed -i '' 's/^outer\.top.*$/outer.top =        40/' $config_file
        echo "Switched outer.top padding to 40"
    else
        # Change to 20 (default for any other value)
        sed -i '' 's/^outer\.top.*$/outer.top =        20/' $config_file
        echo "Switched outer.top padding to 20"
    end
    
    # Reload AeroSpace config to apply changes
    aerospace reload-config
    echo "AeroSpace config reloaded"
end
