local ok, fzf = pcall(require, "fzf-lua")
if not ok then
  return
end

fzf.setup({
  -- preview window is in fullscreen and takes 70% of the space and is above the search results
  winopts = {
    fullscreen = true,
    preview = {
      layout = "vertical",
      vertical = "up:70%",
    },
  },

  -- use exact string matching, but only for the files picker
  grep_curbuf = {
    fzf_opts = {
      ["--exact"] = "",
      ["--no-sort"] = "",
    },
  },
  files = {
    fzf_opts = {
      ["--exact"] = "",
      ["--no-sort"] = "",
    },
  },

  -- use ctrl-q to select all items and convert to quickfix list (as in telescope)
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },

  diagnostics = {
    cwd_only = false,
    file_icons = false,
    git_icons = false,
    color_headings = true,
    diag_icons = true,
    diag_source = true,
    diag_code = true,
    icon_padding = "",
    multiline = 2,
  },
})
-- vim.ui.select owned by snacks.picker (ui_select=true) — do not register fzf here
