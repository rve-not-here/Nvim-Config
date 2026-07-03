local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- Add blink.cmp capabilities
local ok, blink = pcall(require, "blink.cmp")
if ok then
  M.capabilities = vim.tbl_deep_extend("force", M.capabilities, blink.get_lsp_capabilities())
end

return M
