# macOS-specific exports

[[ -d /opt/X11/ ]] && export PATH="/opt/X11/bin:${PATH}"

export PATH="${HOME}/.local/bin:${PATH}"

# Homebrew-specific setup (HOMEBREW_PREFIX set by brew shellenv in exports.zsh)
[[ -n "${HOMEBREW_PREFIX}" ]] && {
  # Zsh help files from homebrew
  [[ -d "${HOMEBREW_PREFIX}/share/zsh/help" ]] && export HELPDIR="${HOMEBREW_PREFIX}/share/zsh/help"

  # leaving this enabled makes everything slow af
  export HOMEBREW_NO_INSTALL_CLEANUP=1

  # NVM via homebrew (oh-my-zsh nvm plugin handles lazy loading)
  [[ -z "${NVM_DIR}" && -d "${HOMEBREW_PREFIX}/opt/nvm" ]] && export NVM_DIR="${HOMEBREW_PREFIX}/opt/nvm"
}

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

# Android SDK
[[ -d "${HOME}/Library/Android" ]] && export ANDROID_HOME="${HOME}/Library/Android/sdk"

# Use vivid for LS_COLORS if installed
(( $+commands[vivid] )) && export LS_COLORS="$(vivid generate lava)"
