#!/usr/bin/env zsh
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/opt/X11/bin:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:/usr/local/git/bin:${PATH}"

[[ `uname` == Darwin ]] && export DARWIN=1
export EDITOR="/usr/bin/env vim"

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8"
export LC_ALL="${LANG}"

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
