------------------------------------------------------------
-- Underline highlight groups
------------------------------------------------------------
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
  undercurl = true,
  sp = "#e06c75",
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
  undercurl = true,
  sp = "#e5c07b",
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {
  undercurl = true,
  sp = "#61afef",
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {
  undercurl = true,
  sp = "#98c379",
})
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})
