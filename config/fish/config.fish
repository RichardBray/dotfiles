if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Source sensitive API keys from separate file (not tracked in git)
if test -f ~/.config/fish/.secrets.fish
    source ~/.config/fish/.secrets.fish
end

set -x EDITOR nvim

# Set zoxide data directory to local storage
set -x _ZO_DATA_DIR "$HOME/.local/share/zoxide"
set -g fish_greeting ""

# Initialize Starship prompt
starship init fish | source
eval "$(/opt/homebrew/bin/brew shellenv)"
zoxide init fish | source

# Add Bun global bin directory to PATH for Gemini CLI
fish_add_path "/Users/richardoliverbray/.bun/bin"

# Add WezTerm to PATH
fish_add_path -a "/Applications/WezTerm.app/Contents/MacOS"

# Aliases
alias vim='nvim'
alias vi='nvim'
alias gpsup='git push --set-upstream origin main'
alias cld='claude --dangerously-skip-permissions'
alias op='opencode'
alias lg='lazygit'
alias cd='z'
alias ls='eza'

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

# Audio aliases
abbr cuca 'uv run --with "numpy,pyaudio" ~/content-tools/scripts/virtual_mic_delay.py'
abbr transcribe '~/whisper_app/index.js ~/Downloads/"$input_name"_ff.mp4'

# Kanata control aliases
abbr krestart 'sudo launchctl stop com.kanata.keyboard; and sudo launchctl start com.kanata.keyboard'
abbr kstop 'sudo launchctl bootout com.kanata.keyboard'
abbr kstart 'sudo launchctl start com.kanata.keyboard'



set -gx PATH /nix/var/nix/profiles/system/sw/bin $PATH
set -gx PATH /run/current-system/sw/bin $PATH
set -gx NIX_PATH darwin=$HOME/.nix-defexpr/channels/nixpkgs-darwin:darwin-config=$HOME/.nixpkgs/darwin-configuration.nix $NIX_PATH
set -gx NIX_PATH darwin=$HOME/.config/nix:$NIX_PATH
