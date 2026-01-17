# tmux

A terminal multiplexer that lets you switch between several programs in one terminal.

## Sessions

```bash
# Create new session
tmux

# Create named session
tmux new -s dev

# List sessions
tmux ls

# Attach to last session
tmux attach

# Attach to specific session
tmux attach -t dev

# Kill session
tmux kill-session -t dev
```

## Exit / Detach

```bash
# Detach without closing (prefix: Ctrl+b)
Ctrl+b d

# Close pane/window
exit
```
