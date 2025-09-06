
function delay_audio --description "Delay audio processing with clean_audio.py script"
    # Check if arguments are provided
    if test (count $argv) -lt 2
        echo "Usage: delay_audio <watermark> <preset>"
        echo "Example: delay_audio waterm Usual-2"
        return 1
    end

    set watermark $argv[1]

    # Set default preset if not provided
    if test (count $argv) -lt 2
        set preset "Usual-2"
    else
        set preset $argv[2]
    end

    echo "Processing audio with watermark: $watermark, preset: $preset"
    uv run --with requests ~/content-tools/scripts/clean_audio.py ~/Downloads/wezterm.m4a --preset "$preset"

    say "Audio processing complete"
end
