function toggle_display --description "Toggle display resolution"
    # Get current resolution of external display (first one with current mode)
    set current_res (displayplacer list | grep "res:" | grep "current mode" | head -1 | grep -o "res:[0-9]*x[0-9]*")
    
    echo "Current external display resolution: $current_res"
    
    if test "$current_res" = "res:3008x1692"
        echo "Switching to 1504x846..."
        displayplacer "id:FFEAEF52-90B7-5EB7-0857-D6964E3302DB res:1504x846 hz:60 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1440x900 hz:60 color_depth:8 enabled:true scaling:on origin:(-1440,382) degree:0"
        echo "Display switched to 1504x846"
    else
        echo "Switching to 3008x1692..."
        displayplacer "id:FFEAEF52-90B7-5EB7-0857-D6964E3302DB res:3008x1692 hz:60 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1440x900 hz:60 color_depth:8 enabled:true scaling:on origin:(-1440,382) degree:0"
        echo "Display switched to 3008x1692"
    end
end

