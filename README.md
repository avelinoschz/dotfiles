# dotfiles

Personal configuration files and setup scripts for macOS.

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
| `setup.sh` | Fresh macOS setup: Homebrew, CLI tools, apps, oh-my-zsh, asdf |
| `setup-keys.sh` | SSH and GPG key generation |
| `sync.sh` | Sync `.zshrc` from dotfiles to home directory |

## Setup

```bash
# Fresh machine setup
./setup.sh

# Sync zshrc changes
./sync.sh
```
