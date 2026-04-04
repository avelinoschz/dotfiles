#!/bin/bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# After installing, Homebrew prints this exact command and asks you to run it.
# It adds brew to PATH by writing a line to ~/.zprofile.
# The grep -qF guard makes this idempotent: if the line is already there
# (e.g. running setup.sh a second time), it won't be added again.
grep -qF 'brew shellenv' ~/.zprofile 2>/dev/null || \
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Core CLI tools
brew install bat
brew install tree
brew install gnupg
brew install git
brew install tmux
brew install pinentry-mac
brew install mole

# Terminal and editors
brew install neovim
brew install --cask ghostty
brew install --cask visual-studio-code
brew install --cask sublime-text
brew install --cask cursor

# IDEs (JetBrains)
brew install --cask goland
brew install --cask pycharm
brew install --cask clion

# Database and API tools
brew install --cask tableplus
brew install --cask bruno

# Containers
brew install --cask docker

# GitHub
brew install gh
brew install --cask github

# AI assistants
brew install --cask claude
brew install --cask chatgpt

# AI CLI tools
brew install codex
brew install gemini-cli
brew install opencode
brew install copilot-cli

# Native installer for Claude to have always the latest version, as the Homebrew version is often outdated.
curl -fsSL https://claude.ai/install.sh | bash

# Uninstall Claude Code (native installer)
# rm -f ~/.local/bin/claude
# rm -rf ~/.local/share/claude

# Optional: remove all settings, history, MCP configs
# rm -rf ~/.claude
# rm -f ~/.claude.json

# Un detalle: asegurate de que ~/.local/bin este en tu $PATH despues de la instalacion. El
# instalador normalmente lo agrega automaticamente a tu shell config (~/.zshrc), pero vale la pena
# verificarlo.

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Runtime version manager
brew install asdf

# Clone asdf for Oh My Zsh plugin
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

# If not using asdf through Oh My Zsh plugin, the following is needed
# echo >> ~/.zshrc
# echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.zshrc

# asdf plugins and language runtimes
asdf plugin add python
asdf plugin add nodejs
asdf plugin add golang

asdf install python 3.14.2
asdf install nodejs 24.13.0
asdf install go 1.25.5
