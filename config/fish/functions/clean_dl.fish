# clean-dl                           # Clean files older than 30 days
# clean-dl --days 7                  # Clean files older than 7 days
# clean-dl --days 90                 # Clean files older than 90 days

function clean_dl
    set downloads_dir "$HOME/Downloads"
    set days 30

    # Parse arguments
    argparse 'd/days=' -- $argv

    if set -q _flag_days
        set days $_flag_days
    end

    # Clean files and folders older than N days (top-level only to avoid app bundle issues)
    set -l files (find "$downloads_dir" -mindepth 1 -maxdepth 1 -not -path "$downloads_dir/keep" -mtime "+$days")
    set -l count (count $files)

    if test $count -gt 0
        trash $files
        echo "Cleaned Downloads folder - moved $count file(s) older than $days days to Trash"
    else
        echo "No files older than $days days found in Downloads folder"
    end
end
