set-env-flag-if-executable() {
  local cmd="${1}"
  local key="${2:-$1}"
  local exec_path=$(whence "${cmd}")
  [[ ${exec_path} ]] && {
    set-env "${key}" "${exec_path}"
  }
}

set-env-flags() {
  typeset -x -A BONESKULL

  local os=$(uname)
  set-env "os" "${os:l}"

  # config if aws_cli is present
  set-env-flag-if-executable "aws"

  # github"s hub cmd
  set-env-flag-if-executable "hub" "github"

  # we have node
  set-env-flag-if-executable "node"

  # VSCode
  set-env-flag-if-executable "code"

  # starship
  set-env-flag-if-executable "starship"

  # config for go
  [[ -d ${HOME}/.go ]] && {
    set-env "go" "${HOME}/.go"
    export PATH="${GOPATH}/bin:${PATH}"
  }

  # config if source-highlighter is present
  set-env-flag-if-executable "src-hilite-lesspipe.sh" "source-highlighter"
  [[ $(get-env source-highlighter) ]] && {
    export LESSOPEN="| /usr/bin/env src-hilite-lesspipe.sh %s 2>/dev/null"
    export LESS=" -R"
  }

  set-env-flag-if-executable "bat" "bat"

  [[ -d ${HOME}/.nvm ]] && {
    export NVM_DIR="${HOME}/.nvm"
    set-env "nvm" "${NVM_DIR}"
  }

  set-env-flag-if-executable "rust"
}

export PATH="./node_modules/.bin:${HOME}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:${PATH}"

[[ -d /opt/homebrew ]] && {
  set-env "/opt/homebrew" "homebrew"
  export HOMEBREW_NO_AUTO_UPDATE=1
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

set-env-flags

[[ $(get-env nvm) ]] && {
  trysource "$(get-env nvm)/nvm.sh"
}

# potentially overridden elsewhere
export ANTIGEN_HOME="${HOME}/.antigen"

# EDITOR
[[ $(get-env code) ]] && {
  export EDITOR="code -w"
} || {
  export EDITOR="vim -xR"
}


export DISABLE_UNTRACKED_FILES_DIRTY="true"

export ENABLE_CORRECTION="true"
export DISABLE_AUTO_UPDATE="true"
export HYPHEN_INSENSITIVE="true"
export COMPLETION_WAITING_DOTS="true"

export GITHUB_USER=boneskull

[[ $(get-env bat) ]] && {
  export BAT_STYLE="changes,header"
  export PAGER="bat"
} || {
  export PAGER="less"
}
export MANPAGER="${PAGER}"

# cargo defaults
[[ $(get-env rust) ]] && {
  trysource "${HOME}/.cargo/env"
}

