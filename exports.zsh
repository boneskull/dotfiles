# Core PATH setup
export PATH="${HOME}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:${PATH}"

# Go setup
if [[ -d ${HOME}/.go ]]; then
  export GOPATH="${HOME}/.go"
  export PATH="${GOPATH}/bin:${PATH}"
elif [[ -d ${HOME}/go ]]; then
  export GOPATH="${HOME}/go"
  export PATH="${GOPATH}/bin:${PATH}"
fi

# Source highlighter for less
(( $+commands[src-hilite-lesspipe.sh] )) && {
  export LESSOPEN="| /usr/bin/env src-hilite-lesspipe.sh %s 2>/dev/null"
  export LESS=" -R"
}

# EDITOR - prefer cursor, fallback to vim
(( $+commands[cursor] )) && export EDITOR="cursor -w" || export EDITOR="vim"

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

# oh-my-zsh settings
export DISABLE_UNTRACKED_FILES_DIRTY="true"
export ENABLE_CORRECTION="true"
export DISABLE_AUTO_UPDATE="true"
export HYPHEN_INSENSITIVE="true"
export COMPLETION_WAITING_DOTS="true"

export GITHUB_USER=boneskull
