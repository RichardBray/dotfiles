if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Source sensitive API keys from separate file (not tracked in git)
if test -f ~/.config/fish/.secrets.fish
    source ~/.config/fish/.secrets.fish
end

set -x EDITOR nvim


# Initialize Starship prompt
starship init fish | source
eval "$(/opt/homebrew/bin/brew shellenv)"
zoxide init fish | source

# Add Bun global bin directory to PATH for Gemini CLI
fish_add_path "/Users/richardoliverbray/.bun/bin"
alias vim='nvim'
alias vi='nvim'
alias claude-squad='cs'
alias gpsup='git push --set-upstream origin main'
alias t='tmux'
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias ts='tmux new-session'
alias tk='tmux kill-session'
alias cld='claude'
alias op='opencode'

# Git abbreviations
abbr gst 'git status'
abbr gaa 'git add --all'
abbr ga 'git add'
abbr gc 'git commit'
abbr gcm 'git commit -m'
abbr gco 'git checkout'
abbr gb 'git branch'
abbr gp 'git push'
abbr gl 'git pull'
abbr gd 'git diff'
abbr glog 'git log --oneline --decorate --graph'
abbr gls 'git log --oneline'
abbr gca 'git commit --amend'
abbr gcb 'git checkout -b'
abbr gbd 'git branch -d'
abbr gpo 'git push origin'
abbr gpf 'git push --force-with-lease'
abbr grh 'git reset --hard'
abbr grs 'git reset --soft'
abbr gsh 'git stash'
abbr gsp 'git stash pop'
