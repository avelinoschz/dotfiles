# AGENTS.md

Guidelines for AI agents working in this repo.

## Repo Overview

Personal dotfiles for a single user. The goal is simplicity and portability — configs should work on a fresh machine with minimal dependencies.

## Conventions

### Commit Messages

Use **conventional commits** format:

```
<type>: <short summary (imperative, present tense)>
```

Allowed types: `feat` | `fix` | `chore` | `docs` | `refactor` | `style`

Examples:
- `feat: add ghostty terminal config`
- `fix: correct zsh PATH export order`
- `chore: update tool versions in .tool-versions`
- `docs: update README setup instructions`

The `.gitmessage` file in this repo serves as a `git commit` template. Enable it with:
```bash
git config commit.template .gitmessage
```

### Scripts

- **Use bash scripts, not a Makefile.** `setup.sh` runs on a fresh machine before Homebrew or Xcode CLI tools are installed. Bash is the only guaranteed runtime.
- All scripts must be runnable from any directory (use `SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"` for relative file references).
- Destructive operations must always ask for confirmation with `[y/N]` defaulting to No.
- Show a diff before overwriting any file.
- Comments in scripts and tracked config files must always be written in English.

### `.zshrc` / Shell Prompt

- Git prompt uses **oh-my-zsh built-in functions only**: `git_prompt_info` and `git_prompt_status`.
- Do not introduce Nerd Fonts or special Unicode that requires font installation. The current symbols (`⬆ ⬇ ? + ! » ✗ = $`) render in any terminal.
- All `ZSH_THEME_GIT_PROMPT_*` variables are defined in `.zshrc` directly — no theme file.
- `ZSH_THEME_GIT_PROMPT_ADDED` (`+`) only fires for staged *new* files (`git add` on a new file). Staged modifications to existing files share `MODIFIED` (`!`) with unstaged mods — this is a limitation of oh-my-zsh's `git_prompt_status`. A custom function would be needed to distinguish them.

### `sync.sh` — repo → `$HOME`

- One-way sync: dotfiles repo → `$HOME`.
- Creates a timestamped backup (`~/.zshrc.bak.YYYYMMDD_HHMMSS`) before every apply.
- Flags: `--restore` (apply most recent backup), `--clean` (list and delete all backups).
- If new dotfiles are added to the repo and need syncing, extend `sync.sh` to handle them.

### `pull.sh` — `$HOME` → repo

- Reverse direction: captures current state from `$HOME` into the dotfiles repo.
- Operates on a list defined in `FILES=()` — add entries there to pull more files.
- Currently pulls: `.tool-versions`.
- No backup needed on the repo side — git history is the safety net.

### Machine-specific config

- Keep machine-specific paths (e.g. tool installer PATH exports) in the tracked `.zshrc` so they survive syncs.
- Avoid hardcoding paths that would differ across machines — prefer `$HOME` over `/Users/username`.

## What to Avoid

- Don't add a Makefile as the primary interface for scripts.
- Don't add dependencies that require installation before `setup.sh` runs.
- Don't make `sync.sh` or any script apply changes silently without user confirmation.
- Don't add oh-my-zsh themes that require external font packages.
