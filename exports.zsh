# Core PATH setup
export PATH="${HOME}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:${PATH}"

# Homebrew setup (must come early to populate $commands)
# Note: brew shellenv sets HOMEBREW_PREFIX, HOMEBREW_CELLAR, HOMEBREW_REPOSITORY
if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_NO_AUTO_UPDATE=1
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Go setup
if [[ -d ${HOME}/.go ]]; then
  export GOPATH="${HOME}/.go"
  export PATH="${GOPATH}/bin:${PATH}"
elif [[ -d ${HOME}/go ]]; then
  export GOPATH="${HOME}/go"
  export PATH="${GOPATH}/bin:${PATH}"
fi

# NVM setup (let oh-my-zsh nvm plugin handle lazy loading)
[[ -d ${HOME}/.nvm ]] && export NVM_DIR="${HOME}/.nvm"

# Source highlighter for less
(( $+commands[src-hilite-lesspipe.sh] )) && {
  export LESSOPEN="| /usr/bin/env src-hilite-lesspipe.sh %s 2>/dev/null"
  export LESS=" -R"
}

# EDITOR - prefer vscode, fallback to vim
(( $+commands[code] )) && export EDITOR="code -w" || export EDITOR="vim"

# Pager - prefer bat
(( $+commands[bat] )) && {
  export BAT_STYLE="changes,header"
  export PAGER="bat"
} || {
  export PAGER="less"
}
export MANPAGER="${PAGER}"

# Cargo/Rust
(( $+commands[rustup] )) && [[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

# Corepack (node package manager manager)
(( $+commands[corepack] )) && export COREPACK_ENABLE_AUTO_PIN=0

# Console Ninja (VS Code extension)
[[ -d ${HOME}/.console-ninja ]] && export PATH="${PATH}:${HOME}/.console-ninja/.bin"

# oh-my-zsh settings
export DISABLE_UNTRACKED_FILES_DIRTY="true"
export ENABLE_CORRECTION="true"
export DISABLE_AUTO_UPDATE="true"
export HYPHEN_INSENSITIVE="true"
export COMPLETION_WAITING_DOTS="true"

export GITHUB_USER=boneskull
