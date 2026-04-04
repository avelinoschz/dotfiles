# .claude

Claude Code configuration directory.

## Contents

### settings.json

Claude Code settings applied to this repo.

- `permissions.allow` - Pre-authorized commands (e.g. `go mod *`)
- `statusLine` - Enables a custom status bar command via `statusline-command.sh`

### statusline-command.sh

Shell script that renders the Claude Code status bar. Reads JSON from stdin and displays:

- Active model name
- Context window usage (progress bar + percentage, color-coded green/yellow/red)
- Session cost duration
- Rate limit usage (5-hour and 7-day windows)
- Active worktree name (when applicable)
