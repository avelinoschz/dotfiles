#!/bin/bash

# init-secrets.sh — Initialize $HOME/.zsh_secrets from .env.example.
# This script is designed to be safe to run multiple times:
# - It never overwrites existing values in $HOME/.zsh_secrets.
# - It only appends missing variable exports with placeholder values.
#
# Usage:
#   ./scripts/init-secrets.sh
#   ./scripts/init-secrets.sh --dry-run

set -euo pipefail

# ─── flags ───────────────────────────────────────────────────────────────────

DRY_RUN=0
for arg in "$@"; do
    case "$arg" in
        --dry-run|-n) DRY_RUN=1 ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

# ─── paths ───────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# REPO_DIR is the parent directory of scripts/, where repo-tracked files live.
REPO_DIR="$(dirname "$SCRIPT_DIR")"
ENV_EXAMPLE="$REPO_DIR/.env.example"
SECRETS_FILE="$HOME/.zsh_secrets"

if [ ! -f "$ENV_EXAMPLE" ]; then
    echo "Error: $ENV_EXAMPLE not found."
    exit 1
fi

# ─── ensure secrets file exists ──────────────────────────────────────────────

if [ ! -f "$SECRETS_FILE" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "[dry-run] create $SECRETS_FILE"
        echo "[dry-run] chmod 600 $SECRETS_FILE"
    else
        touch "$SECRETS_FILE"
        chmod 600 "$SECRETS_FILE"
        echo "Created $SECRETS_FILE"
    fi
fi

# ─── append missing variables ────────────────────────────────────────────────

added=0
existing=0

while IFS= read -r raw_line || [ -n "$raw_line" ]; do
    line="${raw_line#${raw_line%%[![:space:]]*}}"

    case "$line" in
        ""|\#*)
            continue
            ;;
    esac

    entry="$line"
    if [[ "$entry" == export[[:space:]]* ]]; then
        entry="${entry#export }"
        entry="${entry#${entry%%[![:space:]]*}}"
    fi

    if [[ "$entry" != *=* ]]; then
        continue
    fi

    key="${entry%%=*}"
    value="${entry#*=}"

    if ! [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
        continue
    fi

    if [ -f "$SECRETS_FILE" ] && grep -Eq "^[[:space:]]*(export[[:space:]]+)?${key}=" "$SECRETS_FILE"; then
        existing=$((existing + 1))
        continue
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        echo "[dry-run] append ${key} to $SECRETS_FILE"
    else
        printf 'export %s=%s\n' "$key" "$value" >> "$SECRETS_FILE"
        echo "Added ${key} to $SECRETS_FILE"
    fi
    added=$((added + 1))
done < "$ENV_EXAMPLE"

echo "Done. Added: $added | Already present: $existing"
if [ "$DRY_RUN" -eq 0 ]; then
    echo "Next step: edit $SECRETS_FILE and replace placeholder values."
fi
