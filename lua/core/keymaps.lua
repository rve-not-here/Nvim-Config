-- lua/core/keymaps.lua
local map = vim.keymap.set

-- ── window navigation ─────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Move left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move right window" })

-- ── scrolling ─────────────────────────────────────────────────────────────────
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- ── splits ────────────────────────────────────────────────────────────────────
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close split" })

-- ── buffers ───────────────────────────────────────────────────────────────────
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprev<CR>", { desc = "Previous buffer" })
map("n", "<leader>bf", "<cmd>bfirst<CR>", { desc = "First buffer" })
map("n", "<leader>bl", "<cmd>blast<CR>", { desc = "Last buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bc", "<cmd>enew<CR>", { desc = "Create Empty buffer" })

map({ "n", "v" }, "j", "j^", { noremap = true, silent = true, desc = "Move down (to first non-blank)" })
map({ "n", "v" }, "k", "k^", { noremap = true, silent = true, desc = "Move up (to first non-blank)" })
-- ── DAP (Debugger) ──────────────────────────────────────────────────────────
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Conditional breakpoint" })
map("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Start / Continue" })
map("n", "<leader>do", function()
  require("dap").step_over()
end, { desc = "Step over" })
map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Step into" })
map("n", "<leader>dO", function()
  require("dap").step_out()
end, { desc = "Step out" })
map("n", "<leader>dt", function()
  require("dap").terminate()
end, { desc = "Stop debugging" })
map("n", "<leader>dr", function()
  require("dap").repl.open()
end, { desc = "Open REPL" })
map("n", "<leader>dl", function()
  require("dap").run_last()
end, { desc = "Run last" })
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle DAP UI" })

-- ── explorer ──────────────────────────────────────────────────────────────────
map("n", "<leader>-", "<cmd>Oil<CR>", { desc = "Open file explorer" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ── plugins ───────────────────────────────────────────────────────────────────
local function pack_clean()
  local unused = vim
    .iter(vim.pack.get())
    :filter(function(x)
      return not x.active
    end)
    :map(function(x)
      return x.spec.name
    end)
    :totable()
  if #unused == 0 then
    vim.notify("No unused plugins.", vim.log.levels.INFO)
    return
  end
  if vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2) == 1 then
    vim.pack.del(unused)
  end
end

map("n", "<leader>pc", pack_clean, { desc = "Clean plugins" })
map("n", "<leader>pu", vim.pack.update, { desc = "Update plugins" })

-- ── undo breakpoints on punctuation ───────────────────────────────────────────
map("i", ",", ",<C-g>u", { desc = "Undo break on comma" })
map("i", ".", ".<C-g>u", { desc = "Undo break on period" })
map("i", "!", "!<C-g>u", { desc = "Undo break on exclamation" })
map("i", "?", "?<C-g>u", { desc = "Undo break on question mark" })

-- ── misc ──────────────────────────────────────────────────────────────────────
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true, desc = "Clear search" })
map("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
map("n", "<leader>Dv", [["_d]], { desc = "Delete to void" })
map("v", "<leader>Dv", [["_d]], { desc = "Delete selection void" })

-- ── git (fugitive) ────────────────────────────────────────────────────────────
map("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
map("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git blame" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git diff split" })
map("n", "<leader>gl", "<cmd>Git log --oneline<cr>", { desc = "Git log" })
map("n", "<leader>gH", "<cmd>0Gclog<cr>", { desc = "File history (quickfix)" })
map("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" })
map("n", "<leader>gP", "<cmd>Git pull<cr>", { desc = "Git pull" })
map("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
map("n", "<leader>gw", "<cmd>Gwrite<cr>", { desc = "Git stage file" })

map("n", "<leader>cc", function()
  require("snacks").picker.files({
    cwd = vim.fn.stdpath("config"),
  })
end, { desc = "Find config files" })

-- ── snacks picker ─────────────────────────────────────────────────────────────
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>fg", function()
  Snacks.picker.grep()
end, { desc = "Live grep" })
map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Find buffers" })
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help tags" })
map("n", "<leader>fr", function()
  Snacks.picker.recent()
end, { desc = "Recent files" })
map("n", "<leader>fs", function()
  Snacks.picker.grep_word()
end, { desc = "Grep string under cursor" })
map("n", "<leader>fd", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>xx", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnostics list" })
map("n", "<leader>xX", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer diagnostics" })
map("n", "<leader>xl", function()
  Snacks.picker.loclist()
end, { desc = "Location list" })
map("n", "<leader>xq", function()
  Snacks.picker.qflist()
end, { desc = "Quickfix list" })
map("n", "<leader>fc", function()
  Snacks.picker.commands()
end, { desc = "Commands" })
map("n", "<leader>fk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>fz", function()
  Snacks.picker.lines()
end, { desc = "Fuzzy find buffer" })
map("n", "<leader>fw", function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = "Workspace symbols" })
map("n", "<leader>ft", function()
  Snacks.picker.lsp_symbols()
end, { desc = "Document symbols" })
map("n", "<leader>gt", function()
  Snacks.picker.git_status()
end, { desc = "Git status (Snacks)" })

-- ── picker extras (marks, filtered diagnostics, LSP) ──────────────────────────
map("n", "gm", function()
  Snacks.picker.marks()
end, { desc = "Marks" })
map("n", "<leader>da", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>ds", function()
  Snacks.picker.diagnostics({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Diagnostics (errors)" })
map("n", "gR", function()
  Snacks.picker.lsp_references()
end, { desc = "References" })
map("n", "<leader>fO", function()
  -- Razor outline via Snacks collector (Roslyn returns no razor symbols),
  -- else LSP document symbols
  if vim.bo.filetype == "razor" then
    require("tools.razor_outline").pick()
    return
  end
  Snacks.picker.lsp_symbols()
end, { desc = "Symbols / Razor Outline" })
map("n", "<leader>i", function()
  Snacks.picker.lsp_implementations()
end, { desc = "Implementations" })
map("n", "T", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fo", function()
  Snacks.picker.recent()
end, { desc = "Old files" })
map("n", "<leader>qo", function()
  Snacks.picker.qflist()
end, { desc = "Quickfix" })
map("n", "<leader>qO", function()
  Snacks.picker.grep({ need_search = true })
end, { desc = "Grep" })
map("n", "<leader>?", function()
  Snacks.picker.pickers()
end, { desc = "Pickers" })
map("n", "<leader>gu", function()
  require("tools.git_hunks").pick()
end, { desc = "Git hunks current buffer" })

-- ── general (ported NvChad habits) ────────────────────────────────────────────
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Go normal mode" })
map("i", "<C-h>", "<C-w>", { desc = "Delete word (CTRL+Backspace)" })
map("n", "<S-Tab>", ":b#<CR>", { desc = "Previous buffer" })

-- ── LSP workspace extras (gd/gr/gi/K/<leader>ca stay in lsp/keymaps.lua) ─────
map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "LSP Workspace add" })
map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP Workspace remove" })
map("n", "<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "WS list" })
map("n", "<F12>", vim.lsp.buf.definition, { desc = "LSP Definition" })

-- ── misc: slugify + markdown checkbox ─────────────────────────────────────────
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

-- ── show file in explorer (<leader>e is diagnostic float, so <leader>E) ──────
pcall(require, "tools.clemens_tree")
map("n", "<leader>E", "<cmd>ShowFileInTree<CR>", { desc = "Show file in tree" })
