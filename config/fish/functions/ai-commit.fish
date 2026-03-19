function ai-commit --description "Auto-stage, commit with AI message (haiku), and push"
    # Guard: must be in a git repo
    if not git rev-parse --is-inside-work-tree &>/dev/null
        echo "Not a git repository."
        return 1
    end

    git add -A

    # Guard: nothing to commit
    if test -z "$(git diff --staged --name-only)"
        echo "Nothing to commit."
        return 0
    end

    set -l msg (git diff --staged | claude -p --model haiku "Generate a single-line conventional commit message for this diff. Output ONLY the commit message, nothing else.")

    if test -z "$msg"
        echo "Failed to generate commit message."
        return 1
    end

    echo "Committing: $msg"
    git commit -m "$msg"

    # Push to upstream, setting it if needed
    if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' &>/dev/null
        git push
    else
        git push -u origin HEAD
    end
end
