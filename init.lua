vim.g.mapleader = " "

vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
  },
})

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/echasnovski/mini.clue",
  "https://github.com/Saghen/blink.cmp",
  "https://github.com/Saghen/blink.lib",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/SmiteshP/nvim-navic",
  "https://github.com/echasnovski/mini.surround",
  "https://github.com/echasnovski/mini.ai",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/rebelot/heirline.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/stevearc/aerial.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/Issafalcon/neotest-dotnet",
  "https://github.com/folke/snacks.nvim"
})

require("core")
require("plugins")
require("lsp")
require("tools")
require("ui")
