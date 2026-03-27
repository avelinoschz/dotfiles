#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/.zshrc"
DEST="$HOME/.zshrc"
BACKUP="${DEST}.bak.$(date +%Y%m%d_%H%M%S)"
BACKUP_PATTERN="${DEST}.bak.*"

# Restore from backup
if [ "${1}" = "--restore" ]; then
    # Find the most recent backup
    LATEST=$(ls -t ${BACKUP_PATTERN} 2>/dev/null | head -1)
    if [ -z "$LATEST" ]; then
        echo "Error: No backup found matching ${BACKUP_PATTERN}"
        exit 1
    fi
    cp "$LATEST" "$DEST"
    echo "Restored $DEST from $LATEST"
    exit 0
fi

# Clean all backups
if [ "${1}" = "--clean" ]; then
    BACKUPS=$(ls ${BACKUP_PATTERN} 2>/dev/null)
    if [ -z "$BACKUPS" ]; then
        echo "No backups found."
        exit 0
    fi
    echo "$BACKUPS"
    echo ""
    read -rp "Delete all backups listed above? [y/N] " answer
    case "$answer" in
        [yY][eE][sS]|[yY])
            rm ${BACKUP_PATTERN}
            echo "All backups deleted."
            ;;
        *)
            echo "Aborted. No backups deleted."
            ;;
    esac
    exit 0
fi

if [ ! -f "$SOURCE" ]; then
    echo "Error: $SOURCE not found."
    exit 1
fi

# Already up to date
if cmp -s "$SOURCE" "$DEST"; then
    echo ".zshrc is already up to date."
    exit 0
fi

# Show diff
echo "--- $DEST"
echo "+++ $SOURCE"
diff --color=always "$DEST" "$SOURCE"
echo ""

# Ask for confirmation
read -rp "Apply changes? [y/N] " answer
case "$answer" in
    [yY][eE][sS]|[yY])
        if [ -f "$DEST" ]; then
            cp "$DEST" "$BACKUP"
            echo "Backup created at $BACKUP"
        fi
        cp "$SOURCE" "$DEST"
        echo "$HOME/.zshrc updated from dotfiles."
        ;;
    *)
        echo "Aborted. No changes made."
        ;;
esac