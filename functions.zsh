autoload trysource get-env set-env install-antigen update-antigen install-vundle

local OS=$(uname)
trysource "${HOME}/.functions.$(OS:l).zsh"
