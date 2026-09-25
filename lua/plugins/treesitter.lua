local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
  return
end

ts.setup()

local ensure_installed = {
  "lua",
  "vim",
  "vimdoc",
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
  "bash",
  "regex",
  "c_sharp",
  "razor",
  "html",
  "css",
  -- ported from NvChad (2026-08)
  "typescript",
  "tsx",
  "hyprlang",
  "caddy",
  -- web + php (2026-09)
  "javascript",
  "jsdoc",
  "php",
  "phpdoc",
}

-- Install any parsers not already present. `nvim-treesitter`'s post-rewrite
-- API no longer has an `ensure_installed` setup option, so this is done
-- explicitly instead.
local config_ok, ts_config = pcall(require, "nvim-treesitter.config")
local installed = {}
if config_ok and ts_config.installed_parsers then
  installed = ts_config.installed_parsers()
end

local to_install = vim.tbl_filter(function(lang)
  return not vim.tbl_contains(installed, lang)
end, ensure_installed)

if #to_install > 0 then
  ts.install(to_install)
end

-- Highlighting/indent are no longer enabled via `.setup()` — start them
-- per-buffer on FileType instead.
-- NOTE: pattern is filetypes, not parser names (c_sharp->cs, tsx->typescriptreact).
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
  pattern = {
    "lua",
    "vim",
    "help",
    "json",
    "yaml",
    "markdown",
    "bash",
    "regex",
    "cs",
    "razor",
    "html",
    "css",
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "jsdoc",
    "php",
    "phpdoc",
    "caddy",
    "hyprlang",
  },
  callback = function(args)
    if vim.b[args.buf].large_file then
      return
    end
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    local ok = pcall(vim.treesitter.start, args.buf)
    if ok then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

-- Autotag
pcall(function()
  require("nvim-ts-autotag").setup({
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
  })
end)
