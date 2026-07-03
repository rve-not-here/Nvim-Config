require('oil').setup({
  default_file_explorer = true,

  columns = {
    "icon",
  },

  view_options = {
    show_hidden = true,
  },

  use_default_keymaps = false,

  keymaps = {
    ["<CR>"] = "actions.select",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["g?"] = "actions.show_help",
    ["<C-h>"] = "actions.toggle_hidden",
  },
})

