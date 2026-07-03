-- core/commands.lua

vim.api.nvim_create_user_command("ReloadConfig", function()
  vim.cmd("source $MYVIMRC")
  print("Config reloaded")
end, {})

vim.api.nvim_create_user_command("Format", function()
  vim.lsp.buf.format()
end, {})
