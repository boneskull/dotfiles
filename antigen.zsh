# antidote config - faster than antigen!

# Set antidote home
export ANTIDOTE_HOME=${ANTIDOTE_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/antidote}

# Install antidote if not present
[[ ! -d $ANTIDOTE_HOME ]] && {
  echo "Installing antidote..." >&2
  git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME
}

# Source antidote
source $ANTIDOTE_HOME/antidote.zsh

# Initialize plugins from zsh-plugins.txt
# This caches the plugins for faster loading
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins.zsh
if [[ ! ${zsh_plugins}.zsh -nt ${ZDOTDIR:-$HOME}/.zsh-plugins.txt ]]; then
  antidote bundle <${ZDOTDIR:-$HOME}/.zsh-plugins.txt >|$zsh_plugins
fi
source $zsh_plugins

# use starship theme, if it is present
(( $+commands[starship] )) && {
  eval "$(starship init zsh)"
} || {
  # fallback to basic prompt
  autoload -Uz promptinit && promptinit
  prompt walters  # simple built-in prompt
}

# disable "correcting" valid commands to nonsense
unsetopt correct_all
