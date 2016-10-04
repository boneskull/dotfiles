[[ -f ~/.exports.zsh ]] && source ~/.exports.zsh
[[ ${DARWIN} ]] && {
  [[ -f ~/.exports.darwin.zsh ]] && source ~/.exports.darwin.zsh
  whence brew >/dev/null && {
    [[ -f `brew --prefix`/etc/brew-wrap ]] && source $(brew --prefix)/etc/brew-wrap
    source $(brew --prefix)/share/antigen/antigen.zsh
  }
}

antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions

# vcs related
antigen bundle supercrabtree/k
antigen bundle git
antigen bundle smallhadroncollider/antigen-git-rebase
antigen bundle git-extras
antigen bundle gitignore
antigen bundle github
antigen bundle denolfe/zsh-travis
antigen bundle mollifier/cd-gitroot

# programming related
antigen bundle nvm
antigen bundle pip
antigen bundle npm
antigen bundle tomsquest/nvm-auto-use.zsh

antigen bundle heroku
antigen bundle command-not-found
antigen bundle history
antigen bundle jsontools
antigen bundle vagrant
antigen bundle wd

[[ ${DARWIN} ]] && {
  antigen bundle osx
  antigen bundle vasyharan/zsh-brew-services
  antigen bundle unixorn/tumult.plugin.zsh
}

#antigen theme caiogondim/bullet-train-oh-my-zsh-theme bullet-train
antigen theme bureau
antigen apply

[[ -f ~/.aliases.zsh ]] && source ~/.aliases.zsh

[[ ${DARWIN} ]] && {
  [[ -f ~/.aliases.darwin.zsh ]] && source ~/.aliases.darwin.zsh
  [[ -f ~/.iterm2_shell_integration ]] && source ~/.iterm2_shell_integration.zsh
}

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# fix word traversal. portable? don't know.
bindkey '^[[1;9D' backward-word
bindkey '^[[1;9C' forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        echoti smkx
    }
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

[[ -f ~/.extra.zsh ]] && source ~/.extra.zsh
