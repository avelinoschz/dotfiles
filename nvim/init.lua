-- leader key must be set before any keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- options
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.scrolloff      = 8
vim.opt.wrap           = false

vim.opt.tabstop    = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab  = true

vim.opt.ignorecase = true
vim.opt.smartcase  = true

vim.opt.undofile = true   -- persist undo history across sessions
vim.opt.swapfile = false
vim.opt.backup   = false

-- keymaps
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>")

-- navigate between splits with Ctrl+hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
