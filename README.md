# dotfiles

Personal configuration files and setup scripts.

## Contents

| File/Directory | Description |
| -------------- | ----------- |
| `.zshrc` | Zsh configuration with Oh-My-Zsh, git prompt styling |
| `.zprofile` | Login shell config: Homebrew PATH setup |
| `.vimrc` | Vim settings (syntax, line numbers, dark theme) |
| `.tool-versions` | asdf runtime versions (Python, Node.js, Go) |
| `.claude/` | Claude Code settings and statusline script |
| `.config/` | XDG config directory (bat theme) |
| `.gnupg/` | GPG agent configuration |
| `.ssh/` | SSH client configuration |
| `cheatsheets/` | Quick reference guides for CLI tools |

## Scripts

| Script | Description |
| ------ | ----------- |
| `setup.sh` | Fresh setup: Homebrew, CLI tools, apps, oh-my-zsh, asdf |
| `setup-keys.sh` | SSH and GPG key generation |
| `push.sh` | Apply dotfiles from repo to `$HOME` (shows diff, asks confirmation per file) |
| `pull.sh` | Capture dotfiles from `$HOME` into the repo |

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

# Apply dotfiles to $HOME (shows diff and asks for confirmation)
./push.sh --all

# Apply a single file
./push.sh .zshrc

# Restore from the most recent backup
./push.sh --restore --all
./push.sh --restore .zshrc

# List and delete all backups
./push.sh --clean --all
./push.sh --clean .zshrc

# Capture current dotfiles from $HOME into the repo
./pull.sh --all

# Capture a single file
./pull.sh .zprofile
```

Backups are saved as `~/<file>.bak.YYYYMMDD_HHMMSS` on every apply, so all previous versions are preserved.
