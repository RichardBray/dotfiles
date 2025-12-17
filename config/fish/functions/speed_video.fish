function speed_video --description "Speed up video and process with whisper"
    # Check if argument is provided
    if test (count $argv) -lt 1
        echo "Usage: speed_video <input_filename> [speed]"
        echo "Example: speed_video myvideo 1.2"
        echo "Default speed: 1.2 (20% faster)"
        return 1
    end

    set input_name $argv[1]
    set speed 1.2
    
    # Check if speed argument is provided
    if test (count $argv) -gt 1
        set speed $argv[2]
    end

    # Calculate setpts value (1/speed)
    set setpts_value (math "1 / $speed")

    # && ~/whisper_app/index.js ~/Downloads/"$input_name"_ff.mp4

    echo "Processing video: $input_name with speed: $speed"
    set filter (printf "[0:v]setpts=%s*PTS[v];[0:a]atempo=%s[a]" $setpts_value $speed)
    ffmpeg -i ~/Downloads/"$input_name" -filter_complex "$filter" -map "[v]" -map "[a]" -crf 18 -preset medium -b:a 320k ~/Downloads/"$input_name"_ff.mp4
    echo "Video processing complete"
    say "Video processing complete"
end
