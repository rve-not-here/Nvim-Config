local ok, garbage_day = pcall(require, "garbage-day")
if not ok then
  return
end

-- Stops LSP clients idle 15min after nvim loses focus, restarts on return.
-- Keeps roslyn alive: its cold start (~10-20s) costs more than the RAM saved.
garbage_day.setup({
  excluded_lsp_clients = {
    "null-ls",
    "jdtls",
    "marksman",
    "lua_ls",
    "copilot",
    "roslyn",
    "roslyn_ls",
  },
})
