-- recorded first for the dashboard startup readout
vim.g.start_hrtime = vim.uv.hrtime()

vim.g.mapleader = " "

vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
    caddy = "caddy",
  },
  filename = {
    Caddyfile = "caddy",
  },
})

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/Saghen/blink.cmp",
  "https://github.com/Saghen/blink.lib",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/SmiteshP/nvim-navic",
  "https://github.com/echasnovski/mini.surround",
  "https://github.com/echasnovski/mini.ai",
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/rebelot/heirline.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/Issafalcon/neotest-dotnet",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  -- ported from NvChad config (2026-08)
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/shortcuts/no-neck-pain.nvim",
  "https://github.com/akinsho/git-conflict.nvim",
  "https://github.com/HakonHarnes/img-clip.nvim",
  "https://github.com/brianhuster/live-preview.nvim",
  "https://github.com/ramboe/ramboe-dotnet-utils",
  -- undo tree (lua, lazy-loaded on toggle) + idle-LSP garbage collection
  "https://github.com/jiaoshijie/undotree",
  "https://github.com/zeioth/garbage-day.nvim",
})

require("core")
require("plugins")
require("lsp")
require("tools")
require("ui")
