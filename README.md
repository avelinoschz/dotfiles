# dotfiles

Personal configuration files and setup scripts.

## Contents

| File/Directory | Description |
| -------------- | ----------- |
| `.zshrc` | Zsh configuration with Oh-My-Zsh, git prompt styling |
| `.vimrc` | Vim settings (syntax, line numbers, dark theme) |
| `.tool-versions` | asdf runtime versions (Python, Node.js, Go) |
| `.config/` | XDG config directory (bat theme) |
| `.gnupg/` | GPG agent configuration |
| `.ssh/` | SSH client configuration |
| `cheatsheets/` | Quick reference guides for CLI tools |

## Scripts

| Script | Description |
| ------ | ----------- |
| `setup.sh` | Fresh setup: Homebrew, CLI tools, apps, oh-my-zsh, asdf |
| `setup-keys.sh` | SSH and GPG key generation |
| `sync.sh` | Sync `.zshrc` from dotfiles to home directory (shows diff, asks confirmation) |
| `pull.sh` | Pull updated dotfiles from `$HOME` into the repo (currently: `.tool-versions`) |

## Git Prompt

The zsh prompt displays git status indicators using oh-my-zsh's built-in functions. No special fonts required.

| Symbol | Color | Meaning |
| ------ | ----- | ------- |
| `(main)` | green | Current branch |
| `⬆` | cyan | Unpushed commits (ahead of remote) |
| `⬇` | magenta | Behind remote (need to pull) |
| `⬆⬇` | red | Diverged from remote |
| `?` | red | Untracked files |
| `+` | green | Staged new files |
| `!` | yellow | Modified files (staged or unstaged) |
| `»` | yellow | Renamed files |
| `✗` | red | Deleted files |
| `=` | red | Unmerged conflicts |
| `$` | blue | Stash exists |

Example: `dotfiles (main)⬆!? %`

## Setup

```bash
# Fresh machine setup
./setup.sh

# Sync zshrc changes (shows diff and asks for confirmation)
./sync.sh

# Restore ~/.zshrc from the most recent timestamped backup
./sync.sh --restore

# List and delete all backups
./sync.sh --clean

# Pull updated dotfiles from $HOME into the repo
./pull.sh
```

Backups are saved as `~/.zshrc.bak.YYYYMMDD_HHMMSS` on every apply, so all previous versions are preserved.
