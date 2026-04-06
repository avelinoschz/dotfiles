-- Colorscheme management. All listed themes are installed and available
-- via :Telescope colorscheme.
--
-- To switch themes: set lazy = false and add the vim.cmd.colorscheme call
-- to the desired theme, and set lazy = true on the current active one.
return {
  { 'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    opts = { flavour = 'mocha' },
    config = function(_, opts)
      require('catppuccin').setup(opts)
    end,
  },
  { 'olimorris/onedarkpro.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        cursorline = true,
      },
    },
    config = function(_, opts)
      require('onedarkpro').setup(opts)
      vim.cmd.colorscheme 'onedark'
    end,
  },
  { 'rose-pine/neovim',      name = 'rose-pine',  lazy = true },
  { 'rebelot/kanagawa.nvim',                       lazy = true },
}
