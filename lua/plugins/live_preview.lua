-- markdown / html live preview, ported from NvChad config
-- start with `:LivePreview start`
local ok, livepreview = pcall(require, "livepreview")
if not ok then
  return
end

pcall(function()
  require("livepreview.config").set({
    -- defaults are generally fine
    -- dynamic_root = true
  })
end)

-- keep it lazy: no keymaps, filetype plugin loads on demand
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("live_preview_ft", { clear = true }),
  pattern = { "markdown", "html", "asciidoc", "svg" },
  callback = function()
    -- no-op, ensures livepreview module is loadable for these filetypes
    pcall(require, "livepreview")
  end,
})
