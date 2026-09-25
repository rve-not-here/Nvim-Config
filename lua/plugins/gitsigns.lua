local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
  return
end

gitsigns.setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "▁" },
    topdelete = { text = "▔" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "▁" },
    topdelete = { text = "▔" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 500,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = "    <author>, <author_time:%Y-%m-%d> • <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  max_file_length = 40000,
  preview_config = {
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Navigation (without helper due to expr option)
    -- nav_hunk() is the current API (next_hunk/prev_hunk are deprecated)
    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.nav_hunk("next")
      end)
      return "<Ignore>"
    end, { buffer = bufnr, expr = true, desc = "Next hunk" })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.nav_hunk("prev")
      end)
      return "<Ignore>"
    end, { buffer = bufnr, expr = true, desc = "Previous hunk" })
    -- Actions
    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
    map("v", "<leader>hs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Stage selected hunk")
    map("v", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset selected hunk")
    map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
    map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end, "Blame line")
    map("n", "<leader>ha", gs.toggle_current_line_blame, "Toggle blame")
    map("n", "<leader>hd", gs.diffthis, "Diff this")
    map("n", "<leader>hD", function()
      gs.diffthis("~")
    end, "Diff this ~")
    map("n", "<leader>ht", gs.toggle_deleted, "Toggle deleted")
  end,
})
