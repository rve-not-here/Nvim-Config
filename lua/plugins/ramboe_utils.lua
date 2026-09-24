-- ramboe-dotnet-utils: dap-dll-autopicker, dap-scope-walker, helpers,
-- fzf-lua-pickers-razor-outline. Ported from NvChad custom-config/ramboe-utils.lua
pcall(function()
  require("dap-scope-walker").setup()
end)
pcall(function()
  require("helpers")
end)

pcall(function()
  require("fzf-lua-pickers-razor-outline").setup({
    fzflua_razor_outline_preview_context = 5,
    fzflua_razor_outline_preview_window = "up:60%",
    fzflua_razor_outline_prompt = "Razor> ",
  })
end)

vim.keymap.set("n", "<leader>aa", function()
  local f = _G.HighlightCSharpMethod
  if type(f) == "function" then
    f()
  else
    vim.notify("HighlightCSharpMethod not available", vim.log.levels.WARN)
  end
end, { desc = "Highlight C# Method Body" })

vim.keymap.set("n", "<leader>co", function()
  local f = _G.CloseOtherBuffers
  if type(f) == "function" then
    f()
  else
    -- fallback: close other buffers natively
    local cur = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= cur and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
        pcall(vim.api.nvim_buf_delete, buf, { force = false })
      end
    end
  end
end, { desc = "Close other buffers" })
