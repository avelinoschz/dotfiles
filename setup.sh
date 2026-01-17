#!/bin/bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Core CLI tools
brew install bat
brew install tree
brew install gnupg
brew install git
brew install tmux
brew install pinentry-mac

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
brew install --cask claude-code
brew install --cask chatgpt

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
