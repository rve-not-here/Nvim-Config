local ok, comment = pcall(require, "Comment")
if not ok then
  return
end

comment.setup()

local function toggle_comment()
  require("Comment.api").toggle.linewise.current()
end

vim.api.nvim_create_user_command("ToggleComment", toggle_comment, {})

-- gc (built into Comment.nvim) is primary; <leader>/ is a convenient alias.
-- NOTE: <C-k> avoided — it conflicts with window-nav <C-k> in core/keymaps.lua
-- and makes every <C-k> wait on timeoutlen.
vim.keymap.set("n", "<leader>/", toggle_comment, { desc = "Toggle comment" })
vim.keymap.set("x", "<leader>/", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment selection" })
