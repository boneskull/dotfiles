for file in ${HOME}/.zshfunctions/^*.zwc; do
  autoload ${file}
done;

local os=$(uname)
trysource "${HOME}/.functions.${os:l}.zsh"
