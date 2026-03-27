#!/bin/bash

# Pull files from $HOME into the dotfiles repo.
# Add more entries to FILES to pull additional dotfiles.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

FILES=(
    ".tool-versions"
    # ".vimrc"
    # ".claude/settings.json"
    # ".claude/statusline-command.sh"
)

any_updated=0

for file in "${FILES[@]}"; do
    src="$HOME/$file"
    dest="$SCRIPT_DIR/$file"

    if [ ! -f "$src" ]; then
        echo "Skipping $file: not found at $src"
        continue
    fi

    if cmp -s "$src" "$dest"; then
        echo "$file is already up to date."
        continue
    fi

    echo "--- $dest"
    echo "+++ $src"
    diff --color=always "$dest" "$src"
    echo ""

    read -rp "Pull $file into repo? [y/N] " answer
    case "$answer" in
        [yY][eE][sS]|[yY])
            cp "$src" "$dest"
            echo "$file updated in repo."
            any_updated=1
            ;;
        *)
            echo "Skipped $file."
            ;;
    esac
    echo ""
done

if [ $any_updated -eq 1 ]; then
    echo "Done. Review changes with: git diff"
fi
