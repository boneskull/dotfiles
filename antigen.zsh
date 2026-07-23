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
# This caches the plugins for faster loading. Only regenerate when the source
# list is newer than the cache; write atomically via a temp file + mv so a
# concurrent shell (e.g. Cursor's shell-env resolver racing the interactive
# terminal at startup) never sources a half-written file.
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins.zsh
zsh_plugins_txt=${ZDOTDIR:-$HOME}/.zsh-plugins.txt
if [[ ! $zsh_plugins -nt $zsh_plugins_txt ]]; then
  antidote bundle <$zsh_plugins_txt >|$zsh_plugins.tmp.$$ && mv -f $zsh_plugins.tmp.$$ $zsh_plugins
fi
# The oh-my-zsh nvm plugin sources nvm eagerly here, and nvm's alias parsing
# uses POSIX `${x%%#*}` comment-stripping that zsh's `extendedglob` mis-reads as
# a glob ("bad pattern: #*"). That silently breaks `nvm_alias` and thus
# default-Node activation. Load plugins with extendedglob off, then restore.
_had_extendedglob=0
[[ -o extendedglob ]] && _had_extendedglob=1
unsetopt extendedglob
source $zsh_plugins
(( _had_extendedglob )) && setopt extendedglob
unset _had_extendedglob

# The same bug bites interactive `nvm` calls, so wrap the function to run with
# extendedglob disabled. Guard against double-wrapping on `source ~/.zshrc`.
if (( $+functions[nvm] )) && (( ! $+functions[_nvm_impl] )); then
  functions -c nvm _nvm_impl
  nvm() {
    setopt local_options no_extended_glob
    _nvm_impl "$@"
  }
fi

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
