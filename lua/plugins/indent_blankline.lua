local ok, ibl = pcall(require, "ibl")
if not ok then return end

ibl.setup({
  indent = { char = "│" },
  scope = { char = "│", show_start = false, show_end = false },
  exclude = {
    filetypes = { "help", "terminal", "dashboard", "NvimTree", "oil", "markdown" },
  },
})
