#!/bin/bash

SOURCE=".zshrc"
DEST="$HOME/.zshrc"
BACKUP="${DEST}.bak"

if [ -f "$SOURCE" ]; then
    # Check if files are already identical
    if cmp -s "$SOURCE" "$DEST"; then
        echo ".zshrc is already up to date."
    else
        # Validation for backup
        if [ -f "$DEST" ]; then
            cp "$DEST" "$BACKUP"
            echo "Backup created at $BACKUP"
        fi
        
        # Copy file from dotfiles to HOME
        cp "$SOURCE" "$DEST"
        echo "$HOME/.zshrc updated from dotfiles."
    fi
else
    echo "Error: $SOURCE not found."
fi