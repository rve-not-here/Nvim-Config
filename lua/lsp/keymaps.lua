vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
    end

    -- Navigation
    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gr", vim.lsp.buf.references, "Go to references")
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
    map("K", vim.lsp.buf.hover, "Hover docs")
    map("<leader>k", vim.lsp.buf.signature_help, "Signature help")

    -- Actions
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>cf", vim.lsp.buf.format, "Format")

    -- Diagnostics
    map("]d", vim.diagnostic.goto_next, "Next diagnostic")
    map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    map("<leader>e", vim.diagnostic.open_float, "Diagnostic float")

    -- Inlay hints
    map("<leader>ci", function()
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
        { bufnr = event.buf }
      )
    end, "Toggle inlay hints")
  end,
})
