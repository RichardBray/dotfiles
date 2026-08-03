
# bun completions
[ -s "/Users/robray/.bun/_bun" ] && source "/Users/robray/.bun/_bun"


# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
