-- Colorscheme management. All listed themes are installed and available
-- via :Telescope colorscheme.
--
-- To switch themes: set lazy = false and add the vim.cmd.colorscheme call
-- to the desired theme, and set lazy = true on the current active one.
return {
  { 'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = { flavour = 'mocha' },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  { 'rose-pine/neovim',      name = 'rose-pine',  lazy = true },
  { 'rebelot/kanagawa.nvim',                       lazy = true },
}
