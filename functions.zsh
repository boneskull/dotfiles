autoload \
  get-env \
  install-antigen \
  install-vundle \
  set-env \
  trysource \
  update-antigen

local OS=$(uname)
trysource "${HOME}/.functions.${OS:l}.zsh"
