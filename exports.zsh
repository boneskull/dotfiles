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

  # XXX this is bonkers
  [[ $(get-env os) == darwin ]] && {
    set-env-flag-if-executable "brew" "homebrew"
  } || {
    set-env-flag-if-executable "apt-get" "debian"
    set-env-flag-if-executable "systemd"
  }

  # config if aws_cli is present
  set-env-flag-if-executable "aws"

  # github"s hub cmd
  set-env-flag-if-executable "hub" "github"

  # we have node
  set-env-flag-if-executable "node"

  # we have nnn
  set-env-flag-if-executable "nnn"

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
}

export PATH="./node_modules/.bin:${HOME}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:${PATH}"

set-env-flags

# potentially overridden elsewhere
export ANTIGEN_HOME="${HOME}/.antigen"

# default is vim)
[[ $(get-env code) ]] && {
  export EDITOR="code -w"
} || {
  export EDITOR="vim -xR"
}

export PAGER="less"
export MANPAGER="${PAGER}"

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

export DISABLE_UNTRACKED_FILES_DIRTY="true"
export ENABLE_CORRECTION="true"
export DISABLE_AUTO_UPDATE="true"
export HYPHEN_INSENSITIVE="true"
export COMPLETION_WAITING_DOTS="true"

export NVM_DIR="${HOME}/.nvm"

[[ $(get-env nnn) ]] && {
  export NNN_USE_EDITOR=1
}

# load config for OS
trysource "${HOME}/.exports.$(get-env os).zsh"

export GITHUB_USER=boneskull

[[ $(get-env bat) ]] && {
  export BAT_STYLE="changes,header"
}
