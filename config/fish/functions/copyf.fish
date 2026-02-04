function copyf
    if test (count $argv) -eq 0
        echo "Usage: copyf <file>"
        return 1
    end

    if not test -f $argv[1]
        echo "Error: '$argv[1]' is not a valid file"
        return 1
    end

    pbcopy < $argv[1]
    echo "File contents copied to clipboard: $argv[1]"
end
