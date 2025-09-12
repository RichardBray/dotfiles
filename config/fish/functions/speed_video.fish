function speed_video --description "Speed up video by 10% and process with whisper"
    # Check if argument is provided
    if test (count $argv) -lt 1
        echo "Usage: speed_video <input_filename>"
        echo "Example: speed_video myvideo"
        return 1
    end

    set input_name $argv[1]

    echo "Processing video: $input_name"
    ffmpeg -i ~/Downloads/"$input_name" -filter_complex "[0:v]setpts=0.909090*PTS[v];[0:a]atempo=1.1[a]" -map "[v]" -map "[a]" -crf 18 -preset medium -b:a 320k ~/Downloads/"$input_name"_ff.mp4 && ~/whisper_app/index.js ~/Downloads/"$input_name"_ff.mp4

    echo "Video processing complete"
end
