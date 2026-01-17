#!/bin/bash

DOTFILES_DIR="dotfiles"
SSH_SOURCE="$DOTFILES_DIR/.ssh/config"
GPG_SOURCE="$DOTFILES_DIR/.gnupg/gpg-agent.conf"

SSH_DEST="$HOME/.ssh/config"
GPG_DEST="$HOME/.gnupg/gpg-agent.conf"

if [ -f "$SSH_SOURCE" ]; then
    mkdir -p ~/.ssh && chmod 700 ~/.ssh
    if [ ! -f "$SSH_DEST" ]; then
        cp "$SSH_SOURCE" "$SSH_DEST"
        chmod 600 "$SSH_DEST"
        echo "SSH config deployed."
    fi
else
    echo "Warning: $SSH_SOURCE not found in dotfiles."
fi

if [ -f "$GPG_SOURCE" ]; then
    mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
    if [ ! -f "$GPG_DEST" ]; then
        cp "$GPG_SOURCE" "$GPG_DEST"
        chmod 600 "$GPG_DEST"
        gpgconf --kill gpg-agent
        echo "GPG agent config deployed."
    fi
else
    echo "Warning: $GPG_SOURCE not found in dotfiles."
fi