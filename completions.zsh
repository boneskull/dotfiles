autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# gt (Graphite) completions - generated via `gt completion zsh`
# Alternative: eval "$(gt completion zsh)" but that adds ~50ms startup time
(( $+commands[gt] )) && {
  #compdef gt
  _gt_yargs_completions() {
    local reply
    local si=$IFS
    IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT - 1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
    IFS=$si
    _describe 'values' reply
  }
  compdef _gt_yargs_completions gt
}
