# boneskull’s dotfiles

Based on [Mathias's Dotfiles](https://github.com/mathiasbynens/dotfiles.git).

## Installation

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/Projects/dotfiles`, with `~/dotfiles` as a symlink.) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/boneskull/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
source bootstrap.bash
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; source bootstrap.bash
```

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/mathiasbynens/dotfiles/blob/aff769fd75225d8f2e481185a71d5e05b76002dc/.aliases#L21-26)) takes place.

Here’s an example `~/.path` file that adds `~/utils` to the `$PATH`:

```bash
export PATH="$HOME/utils:$PATH"
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

### Sensible OS X defaults

When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
./.osx
```

### Function Glossary

To print a list of all functions, execute:

```bash
glossary
```

To show "groups" which functions belong to, execute

```bash
all-groups
```

Then, to show functions within a specific group:

```bash
glossary <group>
```

### Homebrew, Cask & NPM Packages

The functions `install-homebrew-packages`, `install-cask-packages`, and `install-npm-packages` will install global packages.

Manage the packages to be installed by editing the `.init/brew-packages.txt`, `./init/cask-packages.txt`, and `./init/npm-packages.txt`, respectively.

> To use any of these commands, you may need to execute `install-homebrew` first.  Package `homebrew-cask` comes down via `install-homebrew-packages`, and `npm` comes down via `node` from `install-cask-packages`.
