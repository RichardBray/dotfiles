function gpa --description "Fetch + fast-forward every git repo in the current dir"
    for dir in */
        test -d $dir/.git; or continue
        set_color --bold; echo (string trim -r -c / $dir); set_color normal
        git -C $dir fetch --all --prune --quiet
        if test -n "$(git -C $dir status --porcelain)"
            set_color yellow; echo "  dirty, fetched only"; set_color normal
            continue
        end
        if not git -C $dir rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1
            set_color yellow; echo "  no upstream, fetched only"; set_color normal
            continue
        end
        git -C $dir pull --ff-only 2>&1 | tail -1 | sed 's/^/  /'
    end
end
