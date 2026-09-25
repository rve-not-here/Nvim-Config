local ok, oil = pcall(require, "oil")
if not ok then
  return
end

oil.setup({
  default_file_explorer = true,

  columns = {
    "icon",
  },

  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
  delete_to_trash = false,
  skip_confirm_for_simple_edits = false,
  prompt_save_on_select_new_entry = true,
  cleanup_delay_ms = 2000,
  lsp_file_methods = {
    timeout_ms = 1000,
    autosave_changes = false,
  },
  constrain_cursor = "editable",
  watch_for_changes = false,

  view_options = {
    show_hidden = true,
    natural_order = true,
    case_insensitive = false,
    sort = {
      { "type", "asc" },
      { "name", "asc" },
    },
  },

  use_default_keymaps = false,

  keymaps = {
    ["<CR>"] = "actions.select",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["g?"] = "actions.show_help",
    ["<C-h>"] = "actions.toggle_hidden",
    -- ported from NvChad oil-config
    ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
    ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["`"] = "actions.cd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },

  float = {
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = "rounded",
    win_options = { winblend = 0 },
    preview_split = "auto",
  },
  preview = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    max_height = 0.9,
    min_height = { 5, 0.1 },
    border = "rounded",
    win_options = { winblend = 0 },
    update_on_cursor_moved = false,
  },
  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    border = "rounded",
    minimized_border = "none",
    win_options = { winblend = 0 },
  },
})

vim.keymap.set("n", "<A-a>", function()
  require("oil").open_float()
end, { desc = "Oil float" })
