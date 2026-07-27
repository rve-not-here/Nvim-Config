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

autocmd("BufWritePre", {
  group = augroup("trim_whitespace", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.bo.modifiable == false or vim.bo.binary then
      return
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
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
    "notify",
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
autocmd("BufReadPre", {
  group = augroup("large_file", { clear = true }),
  callback = function()
    local max_filesize = 500 * 1024
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      vim.notify("Large file detected, disabling features", vim.log.levels.WARN)
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.foldmethod = "manual"
      vim.defer_fn(function()
        vim.cmd("LspStop")
      end, 100)
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
-- C# organize imports on save
autocmd("BufWritePre", {
  group = augroup("csharp_organize_imports", { clear = true }),
  pattern = "*.cs",
  callback = function()
    local client = vim.lsp.get_clients({ bufnr = 0, name = "roslyn_ls" })[1]
    if not client then
      return
    end
    local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    if not result or vim.tbl_isempty(result) then
      return
    end
    for _, res in pairs(result) do
      for _, action in pairs(res.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
        end
      end
    end
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

-- Cursorline in active window only
autocmd({ "WinEnter", "BufEnter" }, {
  group = augroup("cursorline", { clear = true }),
  callback = function()
    if vim.bo.buftype == "" then
      vim.opt_local.cursorline = true
    end
  end,
})

autocmd({ "WinLeave", "BufLeave" }, {
  group = augroup("cursorline", { clear = false }),
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Auto-create missing directories on save
autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
      vim.notify("Created directory: " .. dir, vim.log.levels.INFO)
    end
  end,
})

-- Update file when changed externally
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
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

-- Notify on appsettings.json changes
autocmd("BufWritePost", {
  group = augroup("dotnet_reload", { clear = true }),
  pattern = "appsettings*.json",
  callback = function()
    vim.notify("appsettings.json changed - restart app to apply", vim.log.levels.INFO)
  end,
})

-- Limit syntax highlighting to 500 columns
autocmd("BufEnter", {
  group = augroup("syntax_limit", { clear = true }),
  callback = function()
    vim.opt_local.synmaxcol = 500
  end,
})
