#!/bin/bash

# setup.sh — Bootstrap a new machine with all tools, languages, and applications.
# Run this script once on a fresh macOS install.
#
# Usage:
#   ./setup.sh
#   ./setup.sh --dry-run    Print all commands without executing them.

set -euo pipefail
# set -e: exit immediately if any command returns non-zero exit code.
# set -u: treat references to unset variables as errors.
# set -o pipefail: if any command in a pipeline fails, the whole pipeline fails.

# ─── flags and helpers ───────────────────────────────────────────────────────

DRY_RUN=0
for arg in "$@"; do
    case "$arg" in
        --dry-run|-n) DRY_RUN=1 ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

# run_cmd wraps every installation command.
# In normal mode: executes the command as-is.
# In dry-run mode: prints the command prefixed with [dry-run] without executing.
run_cmd() {
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "[dry-run] $*"
    else
        "$@"
    fi
}

# trap fires on any command that exits with a non-zero code (set -e).
# It prints the line number so failures are easy to locate.
trap 'echo "Error: setup.sh failed at line $LINENO. See output above." >&2' ERR

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── homebrew ────────────────────────────────────────────────────────────────

echo ""
echo "==> Homebrew"

# Install Homebrew only if not already present.
if ! command -v brew &>/dev/null; then
    run_cmd /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# After installing, Homebrew asks you to add brew to PATH via ~/.zprofile.
# The grep -qF guard makes this idempotent: the line is only written once even
# if setup.sh is run multiple times.
if ! grep -qF 'brew shellenv' ~/.zprofile 2>/dev/null; then
    run_cmd bash -c 'echo '\''eval "$(/opt/homebrew/bin/brew shellenv)"'\'' >> ~/.zprofile'
fi

# Make brew available in the current shell session immediately.
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ─── brew formulae ───────────────────────────────────────────────────────────

echo ""
echo "==> Brew formulae"

# cli tools
run_cmd brew install bat
run_cmd brew install fastfetch
run_cmd brew install git
run_cmd brew install gnupg
run_cmd brew install mole
run_cmd brew install neovim
run_cmd brew install pinentry-mac
run_cmd brew install tmux
run_cmd brew install tree
run_cmd brew install zsh-autosuggestions
run_cmd brew install zsh-syntax-highlighting

# version manager
run_cmd brew install asdf

# dev and ai cli tools
run_cmd brew install gh
run_cmd brew install gemini-cli
run_cmd brew install opencode

# ─── brew casks ──────────────────────────────────────────────────────────────

echo ""
echo "==> Brew casks"

# terminal and editors
run_cmd brew install --cask ghostty
run_cmd brew install --cask visual-studio-code
run_cmd brew install --cask sublime-text
run_cmd brew install --cask cursor

# ides
run_cmd brew install --cask goland
run_cmd brew install --cask pycharm
run_cmd brew install --cask clion

# dev tools
run_cmd brew install --cask tableplus
run_cmd brew install --cask bruno
run_cmd brew install --cask docker-desktop
run_cmd brew install --cask github

# ai
run_cmd brew install --cask claude
run_cmd brew install --cask chatgpt
run_cmd brew install --cask codex
run_cmd brew install --cask copilot-cli

# ─── asdf ────────────────────────────────────────────────────────────────────

echo ""
echo "==> asdf"

# asdf plugins: skip if already registered to avoid an error on duplicate add.
# 'asdf plugin list' prints installed plugin names, one per line.
# In dry-run mode the guards are skipped — all commands are shown unconditionally
# to reflect what would run on a fresh machine.
if [ "$DRY_RUN" -eq 1 ] || ! asdf plugin list 2>/dev/null | grep -q "^python$"; then
    run_cmd asdf plugin add python
fi
if [ "$DRY_RUN" -eq 1 ] || ! asdf plugin list 2>/dev/null | grep -q "^nodejs$"; then
    run_cmd asdf plugin add nodejs
fi
if [ "$DRY_RUN" -eq 1 ] || ! asdf plugin list 2>/dev/null | grep -q "^golang$"; then
    run_cmd asdf plugin add golang
fi

# asdf language runtimes: skip if the pinned version is already installed.
# 'asdf list <lang>' prints installed versions for that language.
# In dry-run mode the guards are skipped — same rationale as above.
if [ "$DRY_RUN" -eq 1 ] || ! asdf list python 2>/dev/null | grep -q "3.14.2"; then
    run_cmd asdf install python 3.14.2
fi
if [ "$DRY_RUN" -eq 1 ] || ! asdf list nodejs 2>/dev/null | grep -q "24.13.0"; then
    run_cmd asdf install nodejs 24.13.0
fi
if [ "$DRY_RUN" -eq 1 ] || ! asdf list golang 2>/dev/null | grep -q "1.25.5"; then
    run_cmd asdf install go 1.25.5
fi

# ─── claude code ─────────────────────────────────────────────────────────────

echo ""
echo "==> Claude Code"

# Install via the native installer instead of the Homebrew cask — the native
# installer always provides the latest version, while the cask is often outdated.
# After install, the binary is placed at ~/.local/bin/claude.
# Ensure ~/.local/bin is in your PATH (the installer normally adds it to ~/.zshrc).
#
# To uninstall:
#   rm -f ~/.local/bin/claude
#   rm -rf ~/.local/share/claude
# To also remove all settings, history, and MCP configs:
#   rm -rf ~/.claude && rm -f ~/.claude.json
# The curl expansion must be deferred — wrapping in run_cmd would download the
# script before run_cmd even runs, printing the entire installer source in dry-run.
# Instead, dry-run prints a descriptive placeholder and skips the download.
if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] curl -fsSL https://claude.ai/install.sh | bash"
elif ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

# ─── vscode extensions ───────────────────────────────────────────────────────

echo ""
echo "==> VS Code extensions"

# Install VS Code extensions from the tracked list.
# Each line in vscode-extensions.txt is one extension ID (e.g. golang.go).
# --force ensures the latest version is installed even if already present.
if command -v code &>/dev/null && [ -f "$SCRIPT_DIR/vscode-extensions.txt" ]; then
    while IFS= read -r ext; do
        # Skip blank lines and comments (lines starting with #)
        [[ -z "$ext" || "$ext" == \#* ]] && continue
        run_cmd code --install-extension "$ext" --force
    done < "$SCRIPT_DIR/vscode-extensions.txt"
fi
