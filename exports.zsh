join_by () {
  local IFS="${1}"
  shift
  print "${*}"
}

set-executable-env-flag () {
  local cmd="${1}"
  local key="${2}"
  local exec_path=$(whence "${cmd}")
  [[ ${exec_path} ]] && {
    set-env "${key}" "${exec_path}"
  }
}

set-env-flags () {
  [[ $(uname) == Darwin ]] && {
    set-env 'os' 'darwin'
  } || {
    set-env 'os' 'linux'
  }

  [[ $(get-env os) == darwin ]] && {
    set-executable-env-flag 'brew' 'homebrew'
  } || {
    set-executable-env-flag 'apt-get' 'debian'
    set-executable-env-flag 'systemctl' 'systemd'
  }

  # config if aws_cli is present
  set-executable-env-flag 'aws' 'aws'

  # github's hub cmd
  set-executable-env-flag 'hub' 'github'

  # config for go
  [[ -d ${HOME}/.go ]] && {
    set-env 'go' "${HOME}/.go"
    export PATH="${GOPATH}/bin:${PATH}"
  }

  # config if source-highlighter is present
  set-executable-env-flag 'src-hilite-lesspipe.sh' 'source-highlighter'
  [[ $(get-env source-highlighter) ]] && {
    export LESSOPEN="| /usr/bin/env src-hilite-lesspipe.sh %s 2>/dev/null"
    export LESS=" -R"
  }
}

export PATH="./node_modules/.bin:${HOME}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:${PATH}"

typeset -x -A BONESKULL

set-env-flags

# potentially overridden elsewhere
export ANTIGEN_HOME="${HOME}/.antigen"

# default is vim
export EDITOR="/usr/bin/env vim"

export PAGER=less
export MANPAGER="${PAGER}"
export MORE="${LESS}"

# Always enable colored `grep` output
export GREP_OPTIONS='--color=auto'

export DISABLE_UNTRACKED_FILES_DIRTY='true'
export ENABLE_CORRECTION='true'
export DISABLE_AUTO_UPDATE='true'
export HYPHEN_INSENSITIVE='true'
export COMPLETION_WAITING_DOTS='true'
export NVM_DIR="${HOME}/.nvm"

# load config for OS
trysource "${HOME}/.exports.$(get-env os).zsh"
