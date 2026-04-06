# Neovim config

Minimal Neovim configuration. No plugins — built-in Neovim features only.

## Location

`~/.config/nvim/init.lua`

## Key bindings

Leader key: `Space`

| Key | Mode | Action |
| --- | ---- | ------ |
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Quit |
| `<C-h/j/k/l>` | Normal | Navigate between splits |

## Managed by

Tracked in `push.sh` — edit in the repo, apply with:

```bash
./push.sh .config/nvim/init.lua
```
