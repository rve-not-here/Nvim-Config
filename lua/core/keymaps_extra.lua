-- Extra keymaps ported from NvChad config (2026-08).
-- Deliberately non-conflicting: native Snacks picker keeps <leader>ff/fg/fb/fh/fr/fs/fd/fc/fk/fz/fw/ft/gt,
-- native LspAttach keeps gd/gD/gr/gi/K/<leader>rn/<leader>ca/<leader>e. See comments below.
local map = vim.keymap.set

-- ── general (from mappings.lua) ─────────────────────────────────────────────
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Go normal mode" })
map("i", "<C-h>", "<C-w>", { desc = "Delete word (CTRL+Backspace)" })
map("n", "<S-Tab>", ":b#<CR>", { desc = "Previous buffer" })

-- ── fzf-lua unique pickers (overlaps like <leader>ff/fz/fw/gt/gr/<leader>ca stay on native) ──
local ok_fzf, fzf = pcall(require, "fzf-lua")
if ok_fzf then
  map("n", "gm", fzf.marks, { desc = "FZF Marks" })
  map("n", "<leader>da", fzf.diagnostics_workspace, { desc = "FZF Diagnostics" })
  map("n", "<leader>ds", function()
    fzf.diagnostics_workspace({ severity_only = 1 })
  end, { desc = "FZF Diagnostics (errors)" })
  map("n", "gR", fzf.lsp_references, { desc = "FZF References" })
  map("n", "<leader>fO", function()
    -- Razor outline when in razor, else LSP document symbols
    if vim.bo.filetype == "razor" then
      local ok_r, razor = pcall(require, "fzf-lua-pickers-razor-outline")
      if ok_r and razor.pick then
        razor.pick()
        return
      end
    end
    fzf.lsp_document_symbols()
  end, { desc = "Symbols / Razor Outline" })
  map("n", "<leader>i", fzf.lsp_implementations, { desc = "FZF Implementations" })
  map("n", "T", fzf.buffers, { desc = "FZF Buffers" })
  map("n", "<leader>fo", fzf.oldfiles, { desc = "FZF Old files" })
  map("n", "<leader>qo", fzf.quickfix, { desc = "FZF Quickfix" })
  map("n", "<leader>qO", fzf.lgrep_quickfix, { desc = "FZF Grep → quickfix" })
  map("n", "<leader>?", fzf.builtin, { desc = "FZF Builtins" })
  -- git hunks of current buffer (native <leader>gh is Diffview history, so use <leader>gu)
  map("n", "<leader>gu", function()
    require("fzf-lua").git_hunks({
      cmd = "git --no-pager diff --color=always HEAD -- "
        .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
      ref = "HEAD",
      file_icons = true,
      color_icons = true,
      fzf_opts = {
        ["--multi"] = true,
        ["--delimiter"] = ":",
        ["--nth"] = "3..",
      },
    })
  end, { desc = "Git hunks current buffer" })
end

-- ── lsp workspace extras (from custom-mappings/mappings-lsp.lua) ────────────
-- (gd/gr/gi/K/<leader>ca stay on native LspAttach; these are additions only)
map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "LSP Workspace add" })
map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP Workspace remove" })
map("n", "<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "WS list" })
map("n", "<F12>", vim.lsp.buf.definition, { desc = "LSP Definition" })

-- ── misc: slugify + markdown checkbox (from custom-mappings/misc.lua) ───────
local ok_misc, misc = pcall(require, "tools.misc_helpers")
if ok_misc then
  map("v", "<leader>ys", misc.slugify_visual_selection, { desc = "Copy selection as slug" })
  vim.api.nvim_create_autocmd("FileType", {
    group = misc.augroup,
    pattern = "markdown",
    callback = function(event)
      vim.keymap.set("n", "<CR>", misc.toggle_markdown_checkbox, {
        buffer = event.buf,
        silent = true,
        desc = "Toggle Markdown checkbox",
      })
    end,
  })
end

-- ── ShowFileInTree (clemens-tree, from mappings.lua <leader>e) ──────────────
-- native <leader>e is diagnostic float, so expose tree on <leader>E instead
pcall(require, "tools.clemens_tree")
map("n", "<leader>E", "<cmd>ShowFileInTree<CR>", { desc = "Show file in tree" })
