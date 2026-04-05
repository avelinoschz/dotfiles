#!/bin/bash

# setup-keys.sh — Deploy SSH and GPG config files from this repo to $HOME.
# Only copies if the destination doesn't exist yet, to avoid overwriting
# an existing config on a machine that's already set up.
#
# Usage:
#   ./setup-keys.sh
#   ./setup-keys.sh --dry-run    Print all commands without deploying any files.

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

# run_cmd wraps every deployment command.
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
trap 'echo "Error: setup-keys.sh failed at line $LINENO. See output above." >&2' ERR

# ─── paths ───────────────────────────────────────────────────────────────────

# SCRIPT_DIR resolves the absolute path of the directory where this script
# lives, regardless of where it is called from. This makes the script
# portable — it works from any working directory.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source paths: files as they live in this repo.
SSH_SOURCE="$SCRIPT_DIR/.ssh/config"
GPG_SOURCE="$SCRIPT_DIR/.gnupg/gpg-agent.conf"

# Destination paths: where the files need to go in $HOME.
SSH_DEST="$HOME/.ssh/config"
GPG_DEST="$HOME/.gnupg/gpg-agent.conf"

DEPLOYED=()

# ─── SSH config ──────────────────────────────────────────────────────────────

echo ""
echo "==> SSH config"

# -f checks if the path exists and is a regular file.
if [ -f "$SSH_SOURCE" ]; then
    # mkdir -p creates ~/.ssh and any missing parent directories.
    # chmod 700 sets permissions to rwx------ (owner only).
    # SSH requires strict permissions on the ~/.ssh directory — it refuses
    # to use keys if the directory is readable by others.
    run_cmd mkdir -p ~/.ssh
    run_cmd chmod 700 ~/.ssh

    # Only copy if the destination doesn't exist yet.
    # '!' negates the condition: "if the file does NOT exist".
    # This avoids silently overwriting a config the user may have customized.
    if [ ! -f "$SSH_DEST" ]; then
        run_cmd cp "$SSH_SOURCE" "$SSH_DEST"
        # chmod 600 sets permissions to rw------- (owner read/write only).
        # SSH also requires strict permissions on config files themselves.
        run_cmd chmod 600 "$SSH_DEST"
        echo "SSH config deployed to $SSH_DEST"
        DEPLOYED+=("SSH config")
    else
        echo "SSH config already exists at $SSH_DEST — skipping."
    fi
else
    echo "Warning: $SSH_SOURCE not found in dotfiles."
fi

# ─── GPG agent config ────────────────────────────────────────────────────────

echo ""
echo "==> GPG agent config"

if [ -f "$GPG_SOURCE" ]; then
    # Same pattern as SSH: create directory with strict permissions first.
    # chmod 700 on ~/.gnupg is required by GPG — it will warn or fail otherwise.
    run_cmd mkdir -p ~/.gnupg
    run_cmd chmod 700 ~/.gnupg

    if [ ! -f "$GPG_DEST" ]; then
        run_cmd cp "$GPG_SOURCE" "$GPG_DEST"
        run_cmd chmod 600 "$GPG_DEST"
        # gpg-agent is a background daemon that caches your GPG key passphrase.
        # After changing its config file, we need to restart it so it picks up
        # the new settings. --kill stops the running agent; it will be restarted
        # automatically on the next GPG operation.
        run_cmd gpgconf --kill gpg-agent
        echo "GPG agent config deployed to $GPG_DEST"
        DEPLOYED+=("GPG agent config")
    else
        echo "GPG agent config already exists at $GPG_DEST — skipping."
    fi
else
    echo "Warning: $GPG_SOURCE not found in dotfiles."
fi

# ─── summary ─────────────────────────────────────────────────────────────────

echo ""
if [ ${#DEPLOYED[@]} -gt 0 ]; then
    echo "Keys deployed: ${DEPLOYED[*]}"
else
    echo "No keys deployed — all already present."
fi
