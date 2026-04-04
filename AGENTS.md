# AGENTS.md

Guidelines for AI agents working in this repo.

## Repo Overview

Personal dotfiles for a single user. The goal is simplicity and portability — configs should work on a fresh machine with minimal dependencies.

## Conventions

### Commit Messages

Use **conventional commits** format:

```text
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

- Git prompt uses **pure zsh functions** defined in `.zsh_git_prompt` (sourced from `.zshrc`): `_git_prompt_info` and `_git_prompt_status`.
- Do not introduce Nerd Fonts or special Unicode that requires font installation. The current symbols (`⬆ ⬇ ? + ! » ✗ = $`) render in any terminal.
- All `ZSH_THEME_GIT_PROMPT_*` variables are defined in `.zshrc` directly — `.zsh_git_prompt` only defines the functions that consume them.

### Sourced zsh files

- Any `.zsh_*` file that is sourced (not executed directly) must start with `#!/bin/zsh`. When sourced, zsh ignores the shebang (it's just a comment), but editors like VSCode rely on it for syntax highlighting.

### `push.sh` — repo → `$HOME`

- One-way sync: dotfiles repo → `$HOME`.
- Creates a timestamped backup (`~/<file>.bak.YYYYMMDD_HHMMSS`) before every apply.
- Flags: `--restore` (apply most recent backup), `--clean` (list and delete all backups).
- Files tracked here are **manually maintained by the owner** — large config files (e.g. `.zshrc`) that are easier to edit visually in the repo rather than directly in `$HOME`.
- If a new dotfile fits this profile (owner edits it by hand, wants a repo-side copy as the source of truth), extend the `FILES=()` array in `push.sh`.

### `pull.sh` — `$HOME` → repo

- Reverse direction: captures current state from `$HOME` into the dotfiles repo.
- Operates on a list defined in `FILES=()` — add entries there to pull more files.
- Currently pulls: `.gitconfig`, `.zprofile`, `.claude/settings.json`, `.claude/statusline-command.sh`.
- No backup needed on the repo side — git history is the safety net.
- Files tracked here are **managed automatically by their respective tools** (e.g. git, Claude) — the owner does not edit them by hand. The repo copy exists only to preserve them across machines.
- If a new dotfile fits this profile (a tool writes/updates it, not the owner directly), extend the `FILES=()` array in `pull.sh`.
- **Do not add the same file to both scripts.** Choose based on who controls the file: owner → `push.sh`, tool → `pull.sh`.

### Machine-specific config

- Keep machine-specific paths (e.g. tool installer PATH exports) in the tracked `.zshrc` so they survive syncs.
- Avoid hardcoding paths that would differ across machines — prefer `$HOME` over `/Users/username`.

## What to Avoid

- Don't add a Makefile as the primary interface for scripts.
- Don't add dependencies that require installation before `setup.sh` runs.
- Don't make `push.sh` or any script apply changes silently without user confirmation.
- Don't add oh-my-zsh themes that require external font packages.
- Don't add git aliases — the owner uses plain git commands directly.
