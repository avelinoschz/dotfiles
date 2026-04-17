#!/bin/bash

# pull.sh — Capture dotfiles from $HOME into this repo (home → repo).
# Requires explicit scope: --all or one or more filenames.
#
# Usage:
#   ./scripts/pull.sh --all
#   ./scripts/pull.sh .zprofile
#   ./scripts/pull.sh .zprofile .tool-versions
#   ./scripts/pull.sh --dry-run --all
#   ./scripts/pull.sh --dry-run .zprofile

# ─── tracked files ───────────────────────────────────────────────────────────

# SCRIPT_DIR resolves the absolute path of the directory where this script
# lives, regardless of where it is called from.
# - $0          : path to this script (e.g. ./scripts/pull.sh or /some/path/pull.sh)
# - dirname "$0": the directory part of that path
# - cd ... && pwd: enter that directory and print its absolute path
# The $(...) syntax runs a command and captures its output as a string.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# REPO_DIR is the parent directory of scripts/, where repo-tracked files live.
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# FILES is a bash array listing all dotfiles this repo tracks.
# Each entry is a path relative to $HOME (and relative to this repo's root).
# Add or remove entries here to track more or fewer files.
# Parentheses define a bash array; each space-separated string is one element.
FILES=(
    ".gitconfig"
    ".zprofile"
    ".tool-versions"
    ".config/opencode/opencode.json"
    ".config/opencode/AGENTS.md"
    ".agents/skills/context7-mcp/SKILL.md"
    ".claude/settings.json"
    ".claude/statusline-command.sh"
)

# ─── usage ───────────────────────────────────────────────────────────────────

# usage() is a function. In bash, functions are defined as: name() { ... }
# This one prints instructions and exits with code 1 (meaning "error").
usage() {
    echo "Usage: pull.sh [--dry-run] (--all | <file> [<file>...])"
    echo ""
    echo "  --all              Target all tracked files: ${FILES[*]}"
    echo "  <file> [<file>...] Target specific file(s) by name"
    echo "  --dry-run          Show diffs for pending files without pulling any changes."
    exit 1
}

# ─── argument parsing ────────────────────────────────────────────────────────

# DRY_RUN controls whether changes are applied or only previewed.
DRY_RUN=0

# SCOPE is the list of files this invocation will act on.
# It starts empty and gets filled based on the arguments passed.
SCOPE=()

# "$@" expands to all arguments passed to the script, each as a separate word.
# The for loop iterates over them one by one.
for arg in "$@"; do
    # 'case' is like a switch statement. It matches $arg against patterns.
    # Each pattern ends with ). Double semicolons ;; end each branch.
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
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

# ─── detect changes ──────────────────────────────────────────────────────────

# First pass: find which files actually differ between $HOME and the repo.
# We only show/ask about files that have real changes.
PENDING=()
for file in "${SCOPE[@]}"; do
    src="$HOME/$file"        # source: the live file in $HOME
    dest="$REPO_DIR/$file"   # destination: the copy tracked in this repo

    # -f checks if a path exists and is a regular file.
    if [ ! -f "$src" ]; then
        echo "Skipping $file: not found at $src"
        continue  # skip to next iteration of the loop
    fi

    # 'cmp -s' compares two files silently (no output).
    # It exits 0 if files are identical, non-zero if they differ.
    # '!' negates the exit code, so this branch runs when files differ.
    # Note: if dest doesn't exist yet in the repo, cmp treats it as different.
    if ! cmp -s "$src" "$dest"; then
        PENDING+=("$file")
    else
        echo "$file is already up to date."
    fi
done

# If nothing differs, there is nothing to do.
if [ ${#PENDING[@]} -eq 0 ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "Nothing to pull. All files are up to date."
    else
        echo "All files are up to date."
    fi
    exit 0
fi

# ─── summary ─────────────────────────────────────────────────────────────────

# Show a summary of what will change before asking anything.
echo ""
echo "Files with pending changes:"
for file in "${PENDING[@]}"; do
    echo "  ~ $file"
done
echo ""

# ─── dry-run path ────────────────────────────────────────────────────────────

# Show diffs for all pending files without prompting or applying anything.
if [ "$DRY_RUN" -eq 1 ]; then
    for file in "${PENDING[@]}"; do
        src="$HOME/$file"
        dest="$REPO_DIR/$file"

        if [ -f "$dest" ]; then
            diff_left="$dest"
        else
            diff_left="/dev/null"
        fi
        echo "--- $dest"
        echo "+++ $src"
        diff --color=always "$diff_left" "$src" || true
        echo ""
    done
    echo "Dry run complete — no files were modified."
    exit 0
fi

# ─── global confirmation ─────────────────────────────────────────────────────

# Global confirmation — lets the user abort before seeing any diffs.
read -rp "Proceed? [y/N] " answer
# The pattern [yY][eE][sS]|[yY] matches "yes", "YES", "y", "Y", etc.
# The empty body ;; means "do nothing, continue" (effectively: accept).
case "$answer" in
    [yY][eE][sS]|[yY]) ;;
    *) echo "Aborted."; exit 0 ;;
esac
echo ""

# ─── apply per file ──────────────────────────────────────────────────────────

any_updated=0
UPDATED_FILES=()

for file in "${PENDING[@]}"; do
    src="$HOME/$file"
    dest="$REPO_DIR/$file"

    # If dest doesn't exist yet in the repo (new file being tracked for the
    # first time), diff against /dev/null so it shows the full file as added
    # instead of erroring out.
    if [ -f "$dest" ]; then
        diff_left="$dest"
    else
        diff_left="/dev/null"
    fi
    echo "--- $dest"
    echo "+++ $src"
    diff --color=always "$diff_left" "$src" || true
    echo ""

    read -rp "Pull $file into repo? [y/N] " answer
    case "$answer" in
        [yY][eE][sS]|[yY])
            # mkdir -p creates the destination directory (and any parents)
            # if it doesn't exist yet. 'dirname' extracts the directory
            # part of a path, e.g. dirname .claude/settings.json → .claude
            mkdir -p "$(dirname "$dest")"
            cp "$src" "$dest"
            echo "$file updated in repo."
            any_updated=1
            UPDATED_FILES+=("$file")
            ;;
        *)
            echo "Skipped $file."
            ;;
    esac
    echo ""
done

if [ $any_updated -eq 1 ]; then
    echo "Done. Files pulled into repo:"
    for f in "${UPDATED_FILES[@]}"; do
        echo "  ✓ $f"
    done
    echo "Review changes with: git diff"
fi
