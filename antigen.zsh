# antigen config

[[ ! -f ${ANTIGEN_HOME}/antigen.zsh ]] && {
  install-antigen
}

source "${ANTIGEN_HOME}/antigen.zsh"

antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-completions

# vcs related
antigen bundle git
antigen bundle smallhadroncollider/antigen-git-rebase
antigen bundle git-extras
antigen bundle gitignore
antigen bundle github
antigen bundle denolfe/zsh-travis
antigen bundle mollifier/cd-gitroot

# programming related
[[ $(get-env node) ]] && {
  antigen bundle node                       # provides node-docs cmd
  antigen bundle nvm                        # not sure anymore
  antigen bundle npm                        # npm completion
  antigen bundle tomsquest/nvm-auto-use.zsh # use .nvmrc automatically
}
antigen bundle pip     # pip completion
antigen bundle python  # python completion
antigen bundle vagrant # vagrant autocompletion

antigen bundle history

antigen bundle bundler
# mkdir + cd = mcd
antigen bundle Tarrasch/zsh-mcd

[[ $(get-env aws) ]] && {
  antigen bundle aws
}

trysource "${HOME}/.antigen.$(get-env os).zsh"

antigen theme bureau
antigen apply

unsetopt correct_all
