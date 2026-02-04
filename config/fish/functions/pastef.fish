function pastef
    if test (count $argv) -eq 0
        echo "Usage: pastef <file>"
        return 1
    end

    pbpaste > $argv[1]
    echo "Clipboard contents pasted to: $argv[1]"
end
