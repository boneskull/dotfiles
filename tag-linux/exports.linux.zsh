# Linux-specific exports
# (debian/apt and systemd detection now handled by antidote plugins)

# setup linuxbrew
[[ -d /home/linuxbrew/.linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
