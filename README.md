# boneskull's dotfiles

> _My precious dotfiles_

## Requirements

macOS or Debian-based Linux distro

## Installation

### macOS

1. Install Homebrew: Execute `./tag-osx/bin/install-homebrew`
2. Copy & paste whatever command it says to setup the _current_ session for `brew`.
3. Install [Homebrew-file](https://homebrew-file.readthedocs.io/en/latest/usage.html): `brew tap rcmdnk/file && brew brew-file`
4. Install everything: `brew file update`.
5. Go eat some meatballs because this will take awhile.
6. **Copy** `./osx.rcrc` to `$HOME/.rcrc`
7. Symlink dotfiles: execute `rcup`
8. Tweak a bunch of settings: execute `init-osx <machine-name>`
9. Relogin

### Linux / WSL2 (Debian-based)

1. Sorry, you don't get apps automatically installed.
2. Install `rcm`: `./tag-linux/bin/install-rcm`
3. **Copy** `./linux.rcrc` to `$HOME/.rcrc`
4. Symlink dotfiles: execute `rcup`
5. Relogin

## Extras

Put sensitive env vars in `${HOME}/.extras.zsh`.

## Prior Art

Based on [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles), but subsequently modified beyond recognition.

## License

Copyright (c) 2014 [Christopher Hiller](https://boneskull.com). Licensed MIT
