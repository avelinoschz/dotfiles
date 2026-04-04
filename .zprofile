# Added by Homebrew on install. Sets HOMEBREW_PREFIX, HOMEBREW_CELLAR and adds
# /opt/homebrew/bin to PATH so all brew-installed tools (git, bat, tmux, etc.) are available.
# Lives in .zprofile (not .zshrc) because it only needs to run once at login, not on every
# new shell window or tab.
eval "$(/opt/homebrew/bin/brew shellenv)"
