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

antigen theme caiogondim/bullet-train-oh-my-zsh-theme bullet-train
antigen apply

[[ -f ~/.aliases.zsh ]] && source ~/.aliases.zsh

[[ ${DARWIN} ]] && {
  [[ -f ~/.aliases.darwin.zsh ]] && source ~/.aliases.darwin.zsh
  [[ -f ~/.iterm2_shell_integration ]] && source ~/.iterm2_shell_integration.zsh
}

[[ -f ~/.extra.zsh ]] && source ~/.extra.zsh
