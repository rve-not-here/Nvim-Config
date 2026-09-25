local opt = vim.opt

-- ── PATH ────────────────────────────────────────────────────
local dotnet_tools = vim.fn.expand("~/.dotnet/tools")
if not vim.env.PATH:find(dotnet_tools, 1, true) then
  vim.env.PATH = dotnet_tools .. ":" .. vim.env.PATH
end

-- composer global bins (pint) — same pattern as dotnet tools
local composer_bin = vim.fn.expand("~/.config/composer/vendor/bin")
if vim.fn.isdirectory(composer_bin) == 1 and not vim.env.PATH:find(composer_bin, 1, true) then
  vim.env.PATH = composer_bin .. ":" .. vim.env.PATH
end

-- ── Line numbers ────────────────────────────────────────────
opt.number = true
opt.relativenumber = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Indentation ─────────────────────────────────────────────
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- ── Search ──────────────────────────────────────────────────
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "nosplit" -- live preview of substitutions

-- ── Visual ──────────────────────────────────────────────────
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.winborder = "rounded"
opt.smoothscroll = true
opt.list = true
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }

-- ── Windows / files ─────────────────────────────────────────
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.undolevels = 10000
opt.undoreload = 10000

-- ── Behaviour ───────────────────────────────────────────────
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.updatetime = 250
opt.timeoutlen = 400
opt.ttimeoutlen = 50 -- faster <Esc> response
opt.startofline = false

-- ── Completion (0.12+) ──────────────────────────────────────
-- aligned with blink preselect+auto_insert (noselect contradicted it)
opt.completeopt = "menuone,noinsert,popup"
opt.showtabline = 2
vim.o.pumwidth = 40

-- ── Wildmenu ────────────────────────────────────────────────
opt.wildmenu = true
opt.wildmode = "full"
opt.wildignorecase = true
opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- ── Silence unused provider warnings ────────────────────────
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Fold: safe global default is manual; treesitter sets expr per-buffer
-- after start() succeeds (see plugins/treesitter.lua). Global expr
-- evaluates TS per line even without a parser and slows/errors startup.
vim.opt.foldmethod = "manual"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldminlines = 2

-- ── Ported from NvChad options.lua (2026-08) ────────────────────
vim.opt.numberwidth = 5
vim.o.scroll = 15
-- used by dotnet tooling / make integrations
vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false
