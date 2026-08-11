function toggle_aerospace_right --description "Toggle AeroSpace outer.right padding between 20 and 350"
    set config_file (realpath ~/.aerospace.toml)

    set current_padding (grep "^outer\.right" $config_file | grep -o "[0-9]\+")

    echo "Current outer.right padding: $current_padding"

    if test "$current_padding" = 20
        sed -i '' 's/^outer\.right.*$/outer.right =      350/' $config_file
        echo "Switched outer.right padding to 350"
    else
        sed -i '' 's/^outer\.right.*$/outer.right =      20/' $config_file
        echo "Switched outer.right padding to 20"
    end

    aerospace reload-config
    echo "AeroSpace config reloaded"
end
