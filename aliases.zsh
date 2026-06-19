if (( $+commands[bat] )); then
  alias cat="bat --paging=never"
  alias more="bat"
else
  alias more="less -X"
fi

(( $+commands[dig] )) && {
  alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
}

(( $+commands[eza] )) && {
  alias ls="eza --icons --git"
  alias ltr="ls -l --sort=modified"
}

# for killing scripts that refuse to die, such as AVA in a debug session or a sync benchmark
alias kn='killall -9 node'

# rebase -i but auto-accept the todo list (relies on autoSquash to do the work)
# intentionally shadows any 'rebase' function from plugins (aliases win in zsh)
alias rebase='GIT_SEQUENCE_EDITOR=true git rebase -i'

(( $+commands[claude] )) && {
  alias claude="claude --dangerously-skip-permissions"
}

# VS Code shortcut
# (( $+commands[code] )) && {
#   alias c=code
# }


# Cursor shortcut
(( $+commands[cursor] )) && {
  alias c=cursor
}
