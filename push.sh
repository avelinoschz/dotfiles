#!/bin/bash

# push.sh — Apply dotfiles from this repo to $HOME (repo → home).
# Requires explicit scope: --all or one or more filenames.
#
# Usage:
#   ./push.sh --all
#   ./push.sh .zshrc .zprofile
#   ./push.sh --restore --all
#   ./push.sh --restore .zprofile
#   ./push.sh --clean --all
#   ./push.sh --clean .zprofile

# ─── tracked files ───────────────────────────────────────────────────────────

# SCRIPT_DIR resolves the absolute path of the directory where this script
# lives, regardless of where it is called from.
# - $0          : path to this script (e.g. ./push.sh or /some/path/push.sh)
# - dirname "$0": the directory part of that path
# - cd ... && pwd: enter that directory and print its absolute path
# The $(...) syntax runs a command and captures its output as a string.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# FILES is a bash array listing all dotfiles this repo manages.
# Each entry is a path relative to $HOME (and relative to this repo's root).
# Add or remove entries here to track more or fewer files.
# Parentheses define a bash array; each space-separated string is one element.
FILES=(
    ".zshrc"
    ".zsh_git_prompt"
    ".zprofile"
    ".tool-versions"
    ".config/ghostty/config"
    ".config/fastfetch/config.jsonc"
    "vscode-extensions.txt"
)

# ─── usage ───────────────────────────────────────────────────────────────────

# usage() is a function. In bash, functions are defined as: name() { ... }
# This one prints instructions and exits with code 1 (meaning "error").
# 'exit 1' signals to the caller (e.g. a CI system) that something went wrong.
usage() {
    echo "Usage: push.sh [--restore | --clean] (--all | <file> [<file>...])"
    echo ""
    echo "  --all              Target all tracked files: ${FILES[*]}"
    echo "  <file> [<file>...] Target specific file(s) by name"
    echo "  --restore          Restore most recent backup for the given scope"
    echo "  --clean            List and delete all backups for the given scope"
    exit 1
}

# ─── argument parsing ────────────────────────────────────────────────────────

# MODE controls which action to run. Default is "push" (apply files to $HOME).
MODE="push"

# SCOPE is the list of files this invocation will act on.
# It starts empty and gets filled based on the arguments passed.
SCOPE=()

# "$@" expands to all arguments passed to the script, each as a separate word.
# The for loop iterates over them one by one.
for arg in "$@"; do
    # 'case' is like a switch statement. It matches $arg against patterns.
    # Each pattern ends with ). Double semicolons ;; end each branch.
    case "$arg" in
        --restore) MODE="restore" ;;
        --clean)   MODE="clean" ;;
        # --all fills SCOPE with every entry in FILES.
        # "${FILES[@]}" expands the array to all its elements as separate words.
        --all)     SCOPE=("${FILES[@]}") ;;
        --*)       echo "Unknown flag: $arg"; usage ;;
        # Any non-flag argument is treated as a filename and appended to SCOPE.
        # += on an array appends elements to it.
        *)         SCOPE+=("$arg") ;;
    esac
done

# ${#SCOPE[@]} is the number of elements in the SCOPE array.
# If it's 0, no scope was given — print usage and exit.
if [ ${#SCOPE[@]} -eq 0 ]; then
    usage
fi

# ─── push ────────────────────────────────────────────────────────────────────

if [ "$MODE" = "push" ]; then

    # First pass: find which files actually differ between repo and $HOME.
    # We only show/ask about files that have real changes.
    PENDING=()
    for file in "${SCOPE[@]}"; do
        SOURCE="$SCRIPT_DIR/$file"  # path in this repo
        DEST="$HOME/$file"          # path in $HOME

        # -f checks if a path exists and is a regular file.
        if [ ! -f "$SOURCE" ]; then
            echo "Skipping $file: not found in repo."
            continue  # skip to next iteration of the loop
        fi

        # 'cmp -s' compares two files silently (no output).
        # It exits 0 if files are identical, non-zero if they differ.
        # '!' negates the exit code, so this branch runs when files differ.
        # Note: if DEST doesn't exist yet, cmp treats it as different — correct.
        if ! cmp -s "$SOURCE" "$DEST"; then
            PENDING+=("$file")
        fi
    done

    # If nothing differs, there is nothing to do.
    if [ ${#PENDING[@]} -eq 0 ]; then
        echo "All files are up to date."
        exit 0
    fi

    # Show a summary of what will change before asking anything.
    echo "Files with pending changes:"
    for file in "${PENDING[@]}"; do
        echo "  ~ $file"
    done
    echo ""

    # Global confirmation — lets the user abort before seeing any diffs.
    read -rp "Proceed? [y/N] " answer
    # The pattern [yY][eE][sS]|[yY] matches "yes", "YES", "y", "Y", etc.
    # The empty body ;; means "do nothing, continue" (effectively: accept).
    case "$answer" in
        [yY][eE][sS]|[yY]) ;;
        *) echo "Aborted."; exit 0 ;;
    esac
    echo ""

    # Second pass: show diff and apply each pending file individually.
    any_updated=0
    for file in "${PENDING[@]}"; do
        SOURCE="$SCRIPT_DIR/$file"
        DEST="$HOME/$file"
        # Timestamp format: YYYYMMDD_HHMMSS — makes backups sortable by name.
        BACKUP="${DEST}.bak.$(date +%Y%m%d_%H%M%S)"

        # If DEST doesn't exist yet (new file), diff against /dev/null so it
        # shows the entire file as added instead of erroring out.
        if [ -f "$DEST" ]; then
            diff_left="$DEST"
        else
            diff_left="/dev/null"
        fi
        echo "--- $DEST"
        echo "+++ $SOURCE"
        diff --color=always "$diff_left" "$SOURCE"
        echo ""

        read -rp "Apply ~/$file? [y/N] " answer
        case "$answer" in
            [yY][eE][sS]|[yY])
                # Back up the current file before overwriting it.
                if [ -f "$DEST" ]; then
                    cp "$DEST" "$BACKUP"
                    echo "Backup created at $BACKUP"
                fi
                # mkdir -p creates the destination directory (and any parents)
                # if it doesn't exist yet. 'dirname' extracts the directory
                # part of a path, e.g. dirname ~/.claude/settings.json → ~/.claude
                mkdir -p "$(dirname "$DEST")"
                cp "$SOURCE" "$DEST"
                echo "~/$file updated."
                any_updated=1
                ;;
            *)
                echo "Skipped $file."
                ;;
        esac
        echo ""
    done

    if [ $any_updated -eq 1 ]; then
        echo "Done. Reload shell: source ~/.zshrc"
    fi
fi

# ─── restore ─────────────────────────────────────────────────────────────────

if [ "$MODE" = "restore" ]; then

    # LATEST_MAP stores "filename:backup_path" pairs as plain strings.
    # We use this format because bash arrays can't hold key-value pairs natively.
    LATEST_MAP=()

    for file in "${SCOPE[@]}"; do
        DEST="$HOME/$file"
        # 'ls -t' lists files sorted by modification time (newest first).
        # 'head -1' takes only the first line (the most recent backup).
        # '2>/dev/null' discards error output if no backup files exist.
        LATEST=$(ls -t "${DEST}.bak."* 2>/dev/null | head -1)
        if [ -n "$LATEST" ]; then
            # -n checks that the string is non-empty.
            LATEST_MAP+=("$file:$LATEST")
        else
            echo "No backup found for $file."
        fi
    done

    if [ ${#LATEST_MAP[@]} -eq 0 ]; then
        echo "Nothing to restore."
        exit 0
    fi

    echo "Files to restore:"
    for entry in "${LATEST_MAP[@]}"; do
        # ${entry%%:*} removes everything from the first ':' to the end → filename.
        # ${entry#*:}  removes everything up to and including the first ':' → path.
        file="${entry%%:*}"
        backup="${entry#*:}"
        # 'basename' strips the directory, showing only the filename.
        echo "  ~ $file  ←  $(basename "$backup")"
    done
    echo ""

    read -rp "Proceed? [y/N] " answer
    case "$answer" in
        [yY][eE][sS]|[yY]) ;;
        *) echo "Aborted."; exit 0 ;;
    esac
    echo ""

    for entry in "${LATEST_MAP[@]}"; do
        file="${entry%%:*}"
        backup="${entry#*:}"
        mkdir -p "$(dirname "$HOME/$file")"
        cp "$backup" "$HOME/$file"
        echo "Restored ~/$file from $(basename "$backup")"
    done
fi

# ─── clean ───────────────────────────────────────────────────────────────────

if [ "$MODE" = "clean" ]; then
    ALL_BACKUPS=()
    for file in "${SCOPE[@]}"; do
        DEST="$HOME/$file"
        # Process substitution <(...) runs a command and presents its output
        # as if it were a file. Here we feed 'ls' output line by line into
        # the while loop, safely handling filenames with spaces.
        while IFS= read -r f; do
            ALL_BACKUPS+=("$f")
        done < <(ls -t "${DEST}.bak."* 2>/dev/null)
    done

    if [ ${#ALL_BACKUPS[@]} -eq 0 ]; then
        echo "No backups found."
        exit 0
    fi

    echo "Backups to delete:"
    for f in "${ALL_BACKUPS[@]}"; do
        echo "  $f"
    done
    echo ""

    read -rp "Delete all backups listed above? [y/N] " answer
    case "$answer" in
        [yY][eE][sS]|[yY])
            for f in "${ALL_BACKUPS[@]}"; do
                rm "$f"
            done
            echo "All backups deleted."
            ;;
        *)
            echo "Aborted. No backups deleted."
            ;;
    esac
fi
