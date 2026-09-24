vim.diagnostic.config({
  underline = true,
  -- native EOL overlay: text never shifts; long messages truncate
  -- at the window edge.
  virtual_text = {
    current_line = true,
    spacing = 2,
    prefix = "→",
    format = function(diag)
      local icons = {
        [vim.diagnostic.severity.ERROR] = vim.fn.nr2char(0xf06a),
        [vim.diagnostic.severity.WARN] = vim.fn.nr2char(0xf071),
        [vim.diagnostic.severity.INFO] = vim.fn.nr2char(0xf05a),
        [vim.diagnostic.severity.HINT] = vim.fn.nr2char(0xf0eb),
      }
      -- normalize: some sources hand severity as "ERROR" string
      local sev = diag.severity
      if type(sev) == "string" then
        sev = vim.diagnostic.severity[sev:upper()] or vim.diagnostic.severity.ERROR
      end
      local parts = { icons[sev] or icons[vim.diagnostic.severity.ERROR] }
      if diag.source and diag.source ~= "" then
        parts[#parts + 1] = ("[%s]"):format(diag.source)
      end
      local msg = (diag.message or ""):gsub("\n", " / "):gsub("%s+", " ")
      if #msg > 120 then
        msg = msg:sub(1, 119) .. "…"
      end
      parts[#parts + 1] = msg
      if diag.code and diag.code ~= "" then
        parts[#parts + 1] = ("(%s)"):format(diag.code)
      end
      return table.concat(parts, " ")
    end,
  },
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = vim.fn.nr2char(0xf06a),
      [vim.diagnostic.severity.WARN] = vim.fn.nr2char(0xf071),
      [vim.diagnostic.severity.HINT] = vim.fn.nr2char(0xf0eb),
      [vim.diagnostic.severity.INFO] = vim.fn.nr2char(0xf05a),
    },
  },
})
