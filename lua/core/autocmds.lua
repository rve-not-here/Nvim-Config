local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Ensure undo directory exists
vim.fn.mkdir(vim.fn.stdpath("state") .. "/undo", "p")

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
    -- Skip if buffer is read-only or no filetype
    if vim.bo.modifiable == false or vim.bo.binary then return end
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

autocmd("BufReadPost", {
  group = augroup("restore_cursor", { clear = true }),
  callback = function()
    -- Skip git commit messages
    if vim.bo.filetype == "gitcommit" then return end
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
