local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Ensure undo directory exists
vim.fn.mkdir(vim.fn.stdpath("state") .. "/undo", "p")

-- ══════════════════════════════════════════════════════════════════════════════
-- EXISTING AUTOCOMMANDS
-- ══════════════════════════════════════════════════════════════════════════════

autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({
      higroup = "IncSearch",
      timeout = 150,
    })
  end,
})

autocmd("BufReadPost", {
  group = augroup("restore_cursor", { clear = true }),
  callback = function()
    if vim.bo.filetype == "gitcommit" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- ══════════════════════════════════════════════════════════════════════════════
-- NEW AUTOCOMMANDS
-- ══════════════════════════════════════════════════════════════════════════════

-- Close certain filetypes with 'q'
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "qf",
    "lspinfo",
    "checkhealth",
    "fugitive",
    "git",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})

-- Disable features for large files (>500KB)
-- Sets vim.b.large_file so treesitter/conform can skip (see those files).
autocmd("BufReadPre", {
  group = augroup("large_file", { clear = true }),
  callback = function(args)
    local max_filesize = 500 * 1024
    local name = args.match or vim.api.nvim_buf_get_name(args.buf)
    if name == "" then
      return
    end
    local ok, stats = pcall(vim.uv.fs_stat, name)
    if ok and stats and stats.size > max_filesize then
      vim.notify("Large file detected, disabling features", vim.log.levels.WARN)
      vim.b[args.buf].large_file = 1
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.cursorline = false
      vim.opt_local.list = false
      vim.schedule(function()
        pcall(vim.cmd, "LspStop")
      end)
    end
  end,
})

-- Set wrapping for markdown and git commits
autocmd("FileType", {
  group = augroup("filetype_settings", { clear = true }),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 80
  end,
})
-- C# organize imports on save (async, BufWritePost)
local last_organize = 0
autocmd("BufWritePost", {
  group = augroup("csharp_organize_imports", { clear = true }),
  pattern = "*.cs",
  callback = function(args)
    local now = vim.uv.now()
    if now - last_organize < 2000 then
      return
    end
    last_organize = now
    local client = vim.lsp.get_clients({ bufnr = args.buf, name = "roslyn_ls" })[1]
    if not client then
      return
    end
    vim.lsp.buf.code_action({
      bufnr = args.buf,
      filter = function(action)
        return action.kind and action.kind:match("source%.organizeImports")
      end,
      apply = true,
    })
  end,
})
-- .csproj files as XML
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("csproj_filetype", { clear = true }),
  pattern = "*.csproj",
  callback = function()
    vim.bo.filetype = "xml"
  end,
})

-- Terminal settings
autocmd("TermOpen", {
  group = augroup("terminal_settings", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})

-- Refresh gitsigns on focus
autocmd("FocusGained", {
  group = augroup("git_refresh", { clear = true }),
  callback = function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
      gitsigns.refresh()
    end
  end,
})

-- Cursorline in active window only (single group so ReloadConfig can't duplicate)
local cursorline_group = augroup("cursorline", { clear = true })
autocmd({ "WinEnter", "BufEnter" }, {
  group = cursorline_group,
  callback = function()
    if vim.bo.buftype == "" then
      vim.opt_local.cursorline = true
    end
  end,
})

autocmd({ "WinLeave", "BufLeave" }, {
  group = cursorline_group,
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Auto-create missing directories on save (silent; was notifying on every save)
autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    local file = event.match
    if file:match("^%a+://") or vim.bo[event.buf].buftype ~= "" then
      return
    end
    local dir = vim.fn.fnamemodify(file, ":h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Update file when changed externally
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime", { clear = true }),
  callback = function(event)
    if vim.bo[event.buf].buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Razor file settings
autocmd("FileType", {
  group = augroup("razor_settings", { clear = true }),
  pattern = "razor",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.commentstring = "@* %s *@"
  end,
})

-- PHP settings (PSR-12: 4 spaces)
autocmd("FileType", {
  group = augroup("php_settings", { clear = true }),
  pattern = "php",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- Limit syntax highlighting to 500 columns (set once, no per-enter autocmd)
vim.o.synmaxcol = 500
