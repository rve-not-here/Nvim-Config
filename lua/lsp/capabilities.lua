local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- Merge blink.cmp capabilities (adds snippetSupport, resolveSupport, etc.)
local ok, blink = pcall(require, "blink.cmp")
if ok then
  M.capabilities = vim.tbl_deep_extend("force", M.capabilities, blink.get_lsp_capabilities())
else
  -- Fallback: ensure snippet support even without blink
  M.capabilities.textDocument = M.capabilities.textDocument or {}
  M.capabilities.textDocument.completion = M.capabilities.textDocument.completion or {}
  M.capabilities.textDocument.completion.completionItem = M.capabilities.textDocument.completion.completionItem or {}
  M.capabilities.textDocument.completion.completionItem.snippetSupport = true
end

return M
