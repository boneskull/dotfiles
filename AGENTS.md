# AGENTS.md

> Documentation for AI agents working with this dotfiles repository.

## Overview

This is an [rcm](https://github.com/thoughtbot/rcm)-managed dotfiles repository, portable across macOS and Debian-based Linux. The `.rcrc` file in `$HOME` controls installation behavior.

## rcm Symlink Mechanics

When `rcup` runs, it symlinks files from this repo into `$HOME`:

- **Default behavior**: Files get a `.` prefix (e.g., `zshrc` → `~/.zshrc`)
- **Directories**: Not symlinked wholesale—rcm recursively symlinks their contents, creating directories with `mkdir -p` as needed
- **`UNDOTTED`**: Items listed here are symlinked **without** the dot prefix
  - macOS: `bin`, `Library`
  - Linux: `bin`
- **`EXCLUDES`**: Items listed here are ignored entirely (e.g., `LICENSE`, `README.md`, `*.rcrc`)

### Platform Configuration

| Platform | Config File  | Tags                  |
| -------- | ------------ | --------------------- |
| macOS    | `osx.rcrc`   | `app`, `osx`, `git`   |
| Linux    | `linux.rcrc` | `app`, `linux`, `git` |

## Tag System

The `tag-*` directories contain content that's symlinked based on the `TAGS` setting in `.rcrc`. Contents are treated as if they were in the repository root.

| Tag             | Purpose                                            |
| --------------- | -------------------------------------------------- |
| `tag-app/`      | Application configs (curl, wget, vim)              |
| `tag-git/`      | Git configuration (shared across platforms)        |
| `tag-osx/`      | macOS-specific (Homebrew, Kaleidoscope, Übersicht) |
| `tag-linux/`    | Linux/WSL2-specific                                |
| `tag-hardware/` | Hardware-specific overrides (optional)             |

### Example: How Tags Work

With `TAGS="app osx git"`:

- `tag-osx/gitconfig` → `~/.gitconfig`
- `tag-osx/Library/...` → `~/Library/...` (undotted)
- `tag-git/base.gitconfig` → `~/.base.gitconfig`
- `tag-app/vimrc` → `~/.vimrc`

## Git Configuration

Uses Git's modular `[include]` feature for platform-specific configs that share a common base:

```text
~/.gitconfig          ← tag-{osx,linux}/gitconfig (platform-specific)
    └── [include]
        └── path = .base.gitconfig
                      ↑
~/.base.gitconfig     ← tag-git/base.gitconfig (shared aliases, settings)
```

- **`tag-git/base.gitconfig`**: Shared aliases, colors, core settings, user info
- **`tag-osx/gitconfig`**: macOS tools (Kaleidoscope, osxkeychain, gpg path)
- **`tag-linux/gitconfig`**: Linux tools (gpg path, credential helpers)

## Shell Environment

This setup is **zsh-only**. Scripts and functions use zsh-specific features liberally.

### Plugin Management

Uses [antidote](https://getantidote.github.io/) for zsh plugin management. Plugins are defined in `zsh-plugins.txt`.

Key plugins:

- oh-my-zsh modules (git, node, npm, brew, etc.)
- `zsh-autosuggestions`, `fast-syntax-highlighting`
- `atuin` for shell history
- `z` for directory jumping

### Key Files

| File            | Purpose                                        |
| --------------- | ---------------------------------------------- |
| `zshrc`         | Main shell config, sources other files         |
| `zshenv`        | Environment setup (runs for all zsh instances) |
| `exports.zsh`   | Environment variables                          |
| `aliases.zsh`   | Command aliases                                |
| `functions.zsh` | Sources files from `zshfunctions/`             |
| `zshfunctions/` | Individual function files                      |

## macOS Specifics

### Package Management

Uses Homebrew exclusively. The Brewfile is at `tag-osx/config/brewfile/Brewfile` and is managed via [Homebrew-file](https://homebrew-file.readthedocs.io/).

### Übersicht Widgets

Desktop widgets are in `tag-osx/Library/Application Support/Übersicht/widgets/`. These get symlinked to `~/Library/Application Support/Übersicht/widgets/`.

See [widgets/README.md](tag-osx/Library/Application%20Support/Übersicht/widgets/README.md) for widget documentation.

### Scripts

macOS-specific scripts in `tag-osx/bin/`:

- `upgrade-homebrew` - Homebrew upgrade with notifications
- `init-osx` - Initial macOS setup
- `imgls` - iTerm2 image display

## Linux Specifics

Linux-specific files are in `tag-linux/`. Notably simpler than macOS—no automatic package installation.

## Utility Scripts

Common scripts in `bin/` (shared across platforms):

- `git-cleanup` - Clean up merged branches
- `git-create-worktree` - Worktree helper
- `wtfport` - Find what's using a port

## Directory Structure

```text
.
├── AGENTS.md              # This file
├── README.md              # User-facing installation guide
├── *.zsh                  # Zsh config files → ~/.*.zsh
├── zshrc, zshenv          # Main zsh files → ~/.zshrc, ~/.zshenv
├── zshfunctions/          # Function files → ~/.zshfunctions/
├── bin/                   # Scripts → ~/bin/ (undotted)
├── config/                # XDG config → ~/.config/
├── git-hooks/             # Git hooks → ~/.git-hooks/
├── tag-app/               # App configs (curl, vim, wget)
├── tag-git/               # Git configuration
├── tag-osx/               # macOS-specific
│   ├── bin/               # macOS scripts → ~/bin/
│   ├── config/            # macOS XDG config
│   ├── Library/           # → ~/Library/ (undotted)
│   └── zshfunctions/      # macOS functions
├── tag-linux/             # Linux-specific
└── tag-hardware/          # Hardware overrides (optional)
```
