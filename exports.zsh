#!/usr/bin/env zsh

[[ `uname` == Darwin ]] && export DARWIN=1
export EDITOR="/usr/bin/env vim"

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8"
export LC_ALL="${LANG}"

# Highlight section titles in manual pages
export LESS_TERMCAP_md="${yellow}"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

[[ -d /usr/local/share/zsh/help ]] && export HELPDIR=/usr/local/share/zsh/help

export DISABLE_UNTRACKED_FILES_DIRTY="true"
export ENABLE_CORRECTION="true"
export DISABLE_AUTO_UPDATE="true"
export HYPHEN_INSENSITIVE="true"
export COMPLETION_WAITING_DOTS="true"
export TERM="xterm-256color"
