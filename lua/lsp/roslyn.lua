local capabilities = vim.deepcopy(require("lsp.capabilities").capabilities)

-- HACK: Required for roslyn diagnostics
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.diagnostic = capabilities.textDocument.diagnostic or {}
capabilities.textDocument.diagnostic.dynamicRegistration = true

vim.lsp.config("roslyn_ls", {
  cmd = {
    vim.fn.expand("~/.dotnet/tools/roslyn-language-server"),
    "--stdio",
    "--logLevel",
    "Information",
  },
  filetypes = { "cs" },
  root_markers = { "*.sln", "*.slnx", "*.csproj", ".git" },
  capabilities = capabilities,
  handlers = {
    ["workspace/_roslyn_projectNeedsRestore"] = function(_, _, ctx)
      local params = vim.json.decode(ctx.params or "{}")
      local name = params.projectName or "Unknown"
      vim.notify("Roslyn: " .. name .. " needs restore, running dotnet restore...")
      vim.fn.jobstart({ "dotnet", "restore" }, {
        cwd = vim.fn.getcwd(),
        on_exit = function(_, code)
          if code == 0 then
            vim.notify("Roslyn: dotnet restore succeeded", vim.log.levels.INFO)
          else
            vim.notify("Roslyn: dotnet restore failed", vim.log.levels.ERROR)
          end
        end,
      })
    end,
    ["workspace/_roslyn_restore"] = function(_, _, ctx)
      local params = vim.json.decode(ctx.params or "{}")
      local name = params.projectName or "Unknown"
      vim.notify("Roslyn: Restoring " .. name .. "...")
      vim.fn.jobstart({ "dotnet", "restore" }, {
        cwd = vim.fn.getcwd(),
        on_exit = function(_, code)
          if code == 0 then
            vim.notify("Roslyn: dotnet restore succeeded", vim.log.levels.INFO)
          else
            vim.notify("Roslyn: dotnet restore failed", vim.log.levels.ERROR)
          end
        end,
      })
    end,
  },
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "fullSolution",
      dotnet_compiler_diagnostics_scope = "fullSolution",
    },
    ["csharp|completion"] = {
      dotnet_trigger_completion_in_argument_lists = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_completion_items_from_snippets = true,
    },
  },
})

vim.lsp.enable("roslyn_ls")
