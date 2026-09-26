-- Native commenting via built-in gc (remap=true triggers the built-ins).
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })

vim.api.nvim_create_user_command("ToggleComment", function()
  vim.cmd("normal gcc")
end, { desc = "Toggle comment on current line" })
