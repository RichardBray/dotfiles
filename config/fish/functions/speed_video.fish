function speed_video --description "Speed up video and process with whisper"
    # Check for help flag first
    for arg in $argv
        if test "$arg" = "--help" -o "$arg" = "-h"
            echo "speed_video - Speed up video with quality control"
            echo ""
            echo "Usage: speed_video <input_filename> [--speed SPEED] [--near-lossless] [--help]"
            echo ""
            echo "Arguments:"
            echo "  input_filename    Video file in ~/Downloads (without path or extension)"
            echo ""
            echo "Options:"
            echo "  --speed SPEED     Playback speed multiplier (default: 1.2, meaning 20% faster)"
            echo "  --near-lossless   Use CRF 18 + 320k audio (smaller files, excellent quality)"
            echo "  --help, -h        Show this help message"
            echo ""
            echo "Examples:"
            echo "  speed_video myvideo                      # Lossless, 1.2x speed"
            echo "  speed_video myvideo --speed 1.5          # Lossless, 1.5x speed"
            echo "  speed_video myvideo --speed 1.2 --near-lossless # Near-lossless, 1.2x speed"
            echo ""
            echo "Quality Settings:"
            echo "  Lossless (default):   crf 0 + uncompressed PCM audio (largest files)"
            echo "  Near-lossless:         crf 18 + 320k bitrate audio (smaller files)"
            return 0
        end
    end

    # Check if argument is provided
    if test (count $argv) -lt 1
        echo "Usage: speed_video <input_filename> [--speed SPEED] [--near-lossless] [--help]"
        echo "Use --help for detailed information"
        return 1
    end

    set input_name $argv[1]
    set speed 1.2
    # Default to lossless: CRF 0 means mathematically lossless, PCM audio is uncompressed
    set video_args -crf 0
    set audio_args -c:a pcm_s16le
    
    # Parse flags: check for --speed and --near-lossless
    set i 1
    while test $i -le (count $argv)
        set arg $argv[$i]
        
        if test "$arg" = "--speed"
            set i (math $i + 1)
            if test $i -le (count $argv)
                set speed $argv[$i]
            end
        else if test "$arg" = "--near-lossless"
            # Check for near-lossless flag: CRF 18 is visually lossless, 320k audio is high quality
            set video_args -crf 18 -preset medium
            set audio_args -b:a 320k
        end
        
        set i (math $i + 1)
    end

    # Calculate setpts value (1/speed) for video frame timing
    set setpts_value (math "1 / $speed")

    # && ~/whisper_app/index.js ~/Downloads/"$name_ff.mp4

    echo "Processing video: $input_name with speed: $speed"
    # setpts adjusts video playback rate, atempo adjusts audio playback rate
    set filter (printf "[0:v]setpts=%s*PTS[v];[0:a]atempo=%s[a]" $setpts_value $speed)
    ffmpeg -i ~/Downloads/"$input_name" -filter_complex "$filter" -map "[v]" -map "[a]" $video_args $audio_args ~/Downloads/"$input_name"_ff.mp4
    echo "Video processing complete"
    say "Video processing complete"
end
