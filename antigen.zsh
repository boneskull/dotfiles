# antigen config

boneskull_install_antigen () {
  [[ ! -d ${ANTIGEN_HOME} ]] && {
    local ANTIGEN_REMOTE="https://github.com/zsh-users/antigen"
    echo "Installing antigen via ${ANTIGEN_REMOTE} into ${ANTIGEN_HOME}"
    git clone https://github.com/zsh-users/antigen "${ANTIGEN_HOME}"
  }
}

# updates antigen if ANTIGEN_HOME is a working copy
boneskull_update_antigen () {
  [[ -d ${ANTIGEN_HOME}/.git/ ]] && {
    GIT_WORK_TREE="${ANTIGEN_HOME}" git pull --rebase
  }
}

[[ ! -f ${ANTIGEN_HOME}/antigen.zsh ]] && {
  boneskull_install_antigen
}
  
source "${ANTIGEN_HOME}/antigen.zsh"

antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

# vcs related
antigen bundle git
antigen bundle smallhadroncollider/antigen-git-rebase
antigen bundle git-extras
antigen bundle gitignore
antigen bundle github
antigen bundle denolfe/zsh-travis
antigen bundle mollifier/cd-gitroot

# programming related
antigen bundle node # provides node-docs cmd
antigen bundle nvm # auto nvm behavior
antigen bundle pip # pip completion
antigen bundle python # python completion
antigen bundle npm # npm autocompletion
antigen bundle tomsquest/nvm-auto-use.zsh # use .nvmrc automatically
antigen bundle sudo # ESC 2x: prefix w sudo
antigen bundle vagrant # vagrant autocompletion

antigen bundle history
antigen bundle jsontools

# warp directory
# https://github.com/mfaerevaag/wd
antigen bundle wd

antigen bundle bundler

[[ $(get_env aws) ]] && {
  antigen bundle aws
}

[[ -f ${HOME}/.antigen.$(get_env os).zsh ]] && {
  source "${HOME}/.antigen.$(get_env os).zsh"
} || {
  print "%{$fg[yellow]%} Warning: antigen config not found for OS \"$(get_env os)\"%{$reset_color%}"
}


antigen theme bureau
antigen apply
