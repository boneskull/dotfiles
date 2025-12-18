# macOS-specific exports

export PATH="${HOME}/.local/bin:${PATH}"

# Find and initialize Homebrew (not in default PATH on Apple Silicon)
function _init_homebrew {
  local brew_path
  if [[ -x /opt/homebrew/bin/brew ]]; then
    brew_path="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_path="/usr/local/bin/brew"
  else
    return 1
  fi

  # This sets HOMEBREW_PREFIX, HOMEBREW_CELLAR, etc. and updates PATH
  eval "$("${brew_path}" shellenv)"

  # Zsh help files from homebrew
  [[ -d "${HOMEBREW_PREFIX}/share/zsh/help" ]] && export HELPDIR="${HOMEBREW_PREFIX}/share/zsh/help"

  # Leaving this enabled makes everything slow af
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  export HOMEBREW_NO_AUTO_UPDATE=1

  # NVM via homebrew (oh-my-zsh nvm plugin handles lazy loading)
  # Check for directory, not command - nvm is a function loaded later
  [[ -d "${HOMEBREW_PREFIX}/opt/nvm" ]] && export NVM_DIR="${HOMEBREW_PREFIX}/opt/nvm"
}

_init_homebrew

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

# Use vivid for LS_COLORS if installed
(( $+commands[vivid] )) && export LS_COLORS="$(vivid generate retro-synth-matrix)"

[[ -d "${HOMEBREW_PREFIX}/opt/ruby" ]] && {
  export PATH="${HOMEBREW_PREFIX}/opt/ruby/bin:${PATH}"
}
