# macOS-specific exports

export PATH="${HOME}/.local/bin:${PATH}"

function homebrew_exports {
  local HOMEBREW_PREFIX="${1}"
  # Homebrew-specific setup (HOMEBREW_PREFIX set by brew shellenv in exports.zsh)
  if [[ -n "${HOMEBREW_PREFIX}" ]]; then
    # Zsh help files from homebrew
    [[ -d "${HOMEBREW_PREFIX}/share/zsh/help" ]] && export HELPDIR="${HOMEBREW_PREFIX}/share/zsh/help"

    # leaving this enabled makes everything slow af
    export HOMEBREW_NO_INSTALL_CLEANUP=1
    export HOMEBREW_NO_AUTO_UPDATE=1

    # NVM via homebrew (oh-my-zsh nvm plugin handles lazy loading)
    (( $+commands[nvm] )) && : ${NVM_DIR:="${HOMEBREW_PREFIX}/opt/nvm"}
  else
    echo "HOMEBREW_PREFIX is not set! Skipping Homebrew exports." >&2
  fi
}

(( $+commands[brew] )) && homebrew_exports "$(brew --prefix)"

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

# Use vivid for LS_COLORS if installed
(( $+commands[vivid] )) && export LS_COLORS="$(vivid generate lava)"
