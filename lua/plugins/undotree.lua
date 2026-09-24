local ok, undotree = pcall(require, "undotree")
if not ok then
  return
end

undotree.setup({
  position = "left",
  window = {
    border = "rounded",
  },
})

-- <leader>u is free (only <leader>gu "git hunks" uses the u suffix)
vim.keymap.set("n", "<leader>u", function()
  require("undotree").toggle()
end, { desc = "Undo tree" })

vim.api.nvim_create_user_command("Undotree", function(opts)
  local cb = require("undotree")[opts.fargs[1]]
  if cb == nil then
    vim.notify("Invalid subcommand: " .. (opts.fargs[1] or ""), vim.log.levels.ERROR)
  else
    cb()
  end
end, {
  nargs = 1,
  complete = function(arg_lead)
    return vim.tbl_filter(function(cmd)
      return vim.startswith(cmd, arg_lead)
    end, { "toggle", "open", "close" })
  end,
  desc = "Undotree command with subcommands: toggle, open, close",
})
