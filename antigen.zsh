# antigen config

[[ ! -f ${ANTIGEN_HOME}/antigen.zsh ]] && {
  install-antigen
}

source "${ANTIGEN_HOME}/antigen.zsh"

antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

# vcs related
antigen bundle git
antigen bundle smallhadroncollider/antigen-git-rebase
antigen bundle gh
antigen bundle git-extras
antigen bundle gitignore
antigen bundle git-autofetch
antigen bundle mollifier/cd-gitroot

# programming related

antigen bundle node                       # provides node-docs cmd
antigen bundle nvm                        # completions
antigen bundle npm                        # npm completion
antigen bundle tomsquest/nvm-auto-use.zsh # use .nvmrc automatically
antigen bundle pip                        # pip completion
antigen bundle python                     # python completion
antigen bundle vscode
antigen bundle bundler
antigen bundle yarn

# more shell utils
[[ $(get-env atuin) ]] && {
  antigen bundle ellie/atuin@main
}
antigen bundle Tarrasch/zsh-mcd # mkdir + cd = mcd
antigen bundle z
antigen bundle ripgrep
antigen bundle rust

# use starship theme, if it is present
[[ $(get-env starship) ]] && {
  antigen apply
  eval "$(starship init zsh)"
} || {
  antigen theme bureau
  antigen apply
}

# can't remember what this is for
unsetopt correct_all
