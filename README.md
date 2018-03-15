# boneskull’s dotfiles

> My precious dotfiles

## Requirements

macOS or Debian-based Linux distro

## Installation

1. Install `git`, `vim`, `zsh`, and `curl` via package manager (`apt`, `brew`, etc.)
1. `chsh` to `zsh` if you haven't already
1. Execute `./install-rcm.sh` to install [rcm](https://github.com/thoughtbot/rcm)
1. Copy `linux.rcrc` or `osx.rcrc` (as appropriate) to `$HOME/.rcrc`
1. Execute `rcup`
1. Re-login

## Extras

Put sensitive env vars in `${HOME}/.extras.zsh`.

## Prior Art

Based on [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles), but subsequently modified beyond recognition.

## License

Copyright (c) 2014-2018 [Christopher Hiller](https://boneskull.com).  Licensed MIT
