# Neovim config

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — a minimal,
single-file starting point maintained by the Neovim core team. The goal is to have
a readable config where every line can be understood and modified.

## Location

`~/.config/nvim/init.lua`

## Plugin manager

[lazy.nvim](https://github.com/folke/lazy.nvim) — the community standard. It
self-bootstraps on first launch: if lazy.nvim is not installed, the config
downloads it automatically via git before loading any plugins.

## Plugins

| Plugin | Purpose |
| ------ | ------- |
| `folke/tokyonight.nvim` | Color scheme (tokyonight-night) |
| `folke/which-key.nvim` | Shows available keymaps as you type the leader |
| `folke/todo-comments.nvim` | Highlights `TODO`, `NOTE`, `FIXME` in comments |
| `nvim-telescope/telescope.nvim` | Fuzzy finder for files, text, help, and more |
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting based on language grammars |
| `nvim-mini/mini.nvim` | Collection: statusline, text objects, surround |
| `neovim/nvim-lspconfig` + mason | LSP support — autocompletion, go-to-definition, errors |
| `saghen/blink.cmp` | Completion menu |
| `stevearc/conform.nvim` | Auto-format on save |
| `lewis6991/gitsigns.nvim` | Git change indicators in the gutter |
| `NMAC427/guess-indent.nvim` | Auto-detect indentation style per file |

## First launch

On the first `nvim` open after applying this config:

1. lazy.nvim downloads itself
2. All plugins are installed
3. Treesitter parsers for common languages are downloaded

This requires an internet connection and takes ~1 minute. Subsequent launches are fast.

## Managed by

Tracked in `push.sh` — edit in the repo, apply with:

```bash
./push.sh .config/nvim/init.lua
```
