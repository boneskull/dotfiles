# finder integration
# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/osx
antigen bundle osx
antigen bundle brew

[[ -d ${HOME}/.fonts ]] && {
  source ${HOME}/.fonts/*.sh
}
