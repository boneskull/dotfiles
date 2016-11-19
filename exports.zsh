#!/usr/bin/env zsh
join_by () {
  local IFS="${1}"
  shift
  print "${*}"
}

set_env () {
  BONESKULL+=("${1}" "${2}")
}

get_env () {
  print "${BONESKULL[$1]}"
}

set_executable_env_flag () {
  local cmd="${1}"
  local key="${2}"
  local exec_path=$(whence "${cmd}")
  [[ ${exec_path} ]] && {
    set_env "${key}" "${exec_path}"
  }
}

set_env_flags () {
  [[ $(uname) == Darwin ]] && {
    set_env 'os' 'darwin'
  } || {
    set_env 'os' 'linux'
  }

  [[ $(get_env os) == darwin ]] && {
    set_executable_env_flag 'brew' 'homebrew'
  } || {
    set_executable_env_flag 'apt-get' 'debian'
    set_executable_env_flag 'systemctl' 'systemd'
  }

  # config if aws_cli is present
  set_executable_env_flag 'aws' 'aws'

  # github's hub cmd
  set_executable_env_flag 'hub' 'github'

  # config if atom is present
  set_executable_env_flag 'atom' 'atom'
  [[ $(get_env atom) ]] && {
    export EDITOR="/usr/bin/env atom -w"
  }

  # config for go
  [[ -d ${HOME}/.go ]] && {
    set_env 'go' "${HOME}/.go"
    export PATH="${GOPATH}/bin:${PATH}"
  }
}

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:${PATH}"

typeset -x -A BONESKULL

set_env_flags

# overridden elsewhere
export ANTIGEN_HOME="${HOME}/.antigen/"

# default is vim
export EDITOR='/usr/bin/env vim'

# Prefer US English and use UTF_8
export LANG='en_US.UTF_8'
export LC_ALL="${LANG}"

# Don’t clear the screen after quitting a manual page
export MANPAGER='less -X'

# Always enable colored `grep` output
export GREP_OPTIONS='--color=auto'

export DISABLE_UNTRACKED_FILES_DIRTY='true'
export ENABLE_CORRECTION='true'
export DISABLE_AUTO_UPDATE='true'
export HYPHEN_INSENSITIVE='true'
export COMPLETION_WAITING_DOTS='true'

whence pygmentize >/dev/null && {
  export LESSOPEN="| pygmentize -g -f terminal256 %s"
}

# load config for OS
[[ -f ${HOME}/.exports.$(get_env os).zsh ]] && {
  source "${HOME}/.exports.$(get_env os).zsh"
} || {
  print "%{$fg[yellow]%} Warning: exports not found for OS \"$(get_env os)\"%{$reset_color%}"
}
