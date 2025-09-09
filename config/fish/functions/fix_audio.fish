
function fix_audio --description "Fix audio processing with clean_audio.py script"
    # Check if arguments are provided
    if test (count $argv) -lt 2
        echo "Usage: fix_audio <audio_file> <preset>"
        echo "Example: fix_audio waterm Usual-2"
        return 1
    end

    set audio_file $argv[1]

    # Set default preset if not provided
    if test (count $argv) -lt 2
        set preset "Usual-2"
    else
        set preset $argv[2]
    end

    echo "Processing audio with audio file: $audio_file, preset: $preset"
    uv run --with requests ~/content-tools/scripts/clean_audio.py ~/Downloads/"$audio_file" --preset "$preset"

    say "Audio processing complete"
end
