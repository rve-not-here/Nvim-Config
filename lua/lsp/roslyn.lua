local uv = vim.uv
local fs = vim.fs

local capabilities = vim.deepcopy(require("lsp.capabilities").capabilities)
-- HACK: Required for roslyn diagnostics
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.diagnostic = capabilities.textDocument.diagnostic or {}
capabilities.textDocument.diagnostic.dynamicRegistration = true

local group = vim.api.nvim_create_augroup("lspconfig.roslyn_ls", { clear = true })

---@param client vim.lsp.Client
---@param target string
local function on_init_sln(client, target)
  vim.notify("Initializing: " .. target, vim.log.levels.TRACE, { title = "roslyn_ls" })
  client:notify("solution/open", {
    solution = vim.uri_from_fname(target),
  })
end

---@param client vim.lsp.Client
---@param project_files string[]
local function on_init_project(client, project_files)
  vim.notify("Initializing: projects", vim.log.levels.TRACE, { title = "roslyn_ls" })
  client:notify("project/open", {
    projects = vim.tbl_map(function(file)
      return vim.uri_from_fname(file)
    end, project_files),
  })
end

---@param client vim.lsp.Client
---@param only_buf? integer refresh just this buffer (save path); nil refreshes all
local function refresh_diagnostics(client, only_buf)
  local identifiers = {}
  local ok, caps = pcall(function()
    return client.dynamic_capabilities.capabilities.diagnosticProvider
  end)
  if ok and type(caps) == "table" then
    identifiers = vim
      .iter(caps)
      :map(function(cap)
        return cap.registerOptions and cap.registerOptions.identifier
      end)
      :filter(function(id)
        return id ~= nil
      end)
      :totable()
  end
  if vim.tbl_isempty(identifiers) then
    -- fallback: no identifiers registered (or dynamic_capabilities unavailable
    -- on this Neovim build) — send a single unkeyed request as before
    identifiers = { nil }
  end

  local function refresh(buf)
    if not vim.api.nvim_buf_is_loaded(buf) then
      return
    end
    for _, id in pairs(identifiers) do
      client:request(vim.lsp.protocol.Methods.textDocument_diagnostic, {
        identifier = id,
        textDocument = vim.lsp.util.make_text_document_params(buf),
      }, nil, buf)
    end
  end

  if only_buf then
    refresh(only_buf)
    return
  end
  for buf, _ in pairs(client.attached_buffers) do
    refresh(buf)
  end
end

---@param bufname string
---@return boolean
local function is_decompiled(bufname)
  local _, endpos = bufname:find("[/\\]MetadataAsSource[/\\]")
  if endpos == nil then
    return false
  end
  return vim.fn.finddir(bufname:sub(1, endpos), uv.os_tmpdir()) ~= ""
end

---@param client vim.lsp.Client
---@param action table
local function apply_action(client, action)
  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  end
  if action.command then
    client:exec_cmd(action.command)
  end
end

---@param client vim.lsp.Client
---@param command table
---@param bufnr integer
local function handle_fix_all_action(client, command, bufnr)
  local arg = command.arguments and command.arguments[1]
  if type(arg) ~= "table" then
    vim.notify("roslyn_ls: invalid fixAllCodeAction arguments", vim.log.levels.ERROR)
    return
  end

  local flavors = arg.FixAllFlavors
  if type(flavors) ~= "table" or vim.tbl_isempty(flavors) then
    vim.notify("roslyn_ls: fixAllCodeAction has no FixAllFlavors", vim.log.levels.WARN)
    return
  end

  vim.ui.select(flavors, {
    prompt = "Fix All Scope:",
  }, function(chosen_scope)
    if not chosen_scope then
      return
    end

    client:request("codeAction/resolveFixAll", {
      title = command.title,
      data = arg,
      scope = chosen_scope,
    }, function(err, resolved)
      if err then
        vim.notify(
          "roslyn_ls: fixAllCodeAction resolve error: " .. (err.message or tostring(err)),
          vim.log.levels.ERROR
        )
        return
      end
      if resolved then
        apply_action(client, resolved)
      end
    end, bufnr)
  end)
end

-- Razor cohosting (`--extension Microsoft.VisualStudioCode.RazorExtension.dll`)
-- is loaded when the extension DLL is found next to the server. Note: loading
-- this extension can make the server return empty diagnostics for some
-- `textDocument/diagnostic` pulls; verify C# errors still surface after a
-- restart and disable it again if they disappear.

local server_bin = vim.fn.expand("~/.dotnet/tools/roslyn-language-server")
if vim.fn.executable(server_bin) ~= 1 then
  vim.notify("roslyn_ls: not executable: " .. server_bin, vim.log.levels.WARN, { title = "roslyn_ls" })
  return
end

local server_root = fs.dirname(vim.fn.resolve(server_bin))

local extension_path = fs.find("RoslynExtension.dll", { path = server_root })[1]
  or fs.find("Microsoft.VisualStudioCode.RazorExtension.dll", { path = server_root })[1]

local cmd = {
  server_bin,
  "--logLevel",
  "Information",
  "--extensionLogDirectory",
  fs.joinpath(uv.os_tmpdir(), "roslyn_ls/logs"),
}

local filetypes = { "cs" }

if extension_path and vim.uv.fs_stat(extension_path) then
  table.insert(cmd, "--extension")
  table.insert(cmd, extension_path)
  table.insert(filetypes, "razor")
end

table.insert(cmd, "--stdio")

vim.lsp.config("roslyn_ls", {
  cmd = cmd,

  cmd_env = {
    -- Fixes LSP navigation in decompiled files for systems with symlinked TMPDIR (mainly macOS;
    -- harmless no-op on Linux since TMPDIR is usually unset)
    TMPDIR = vim.env.TMPDIR and vim.env.TMPDIR ~= "" and vim.fn.resolve(vim.env.TMPDIR) or nil,
  },

  -- razor is added dynamically above only if the cohosting extension files
  -- were actually found, so this always reflects what the launched server
  -- instance can really handle.
  filetypes = filetypes,

  root_dir = function(bufnr, cb)
    -- honor an explicitly selected solution (:RoslynTarget)
    local selected = vim.g.roslyn_nvim_selected_solution
    if type(selected) == "string" and selected ~= "" and uv.fs_stat(selected) then
      cb(fs.dirname(selected))
      return
    end
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if not is_decompiled(bufname) then
      -- prefer solution root
      local root_dir = fs.root(bufnr, function(fname, _)
        return fname:match("%.sln[x]?$") ~= nil
      end)

      if not root_dir then
        -- fall back to project root
        root_dir = fs.root(bufnr, function(fname, _)
          return fname:match("%.csproj$") ~= nil
        end)
      end

      if root_dir then
        cb(root_dir)
      else
        cb(vim.fn.getcwd())
      end
    else
      -- decompiled MetadataAsSource file: reuse existing client's root
      local prev_buf = vim.fn.bufnr("#")
      local client = vim.lsp.get_clients({
        name = "roslyn_ls",
        bufnr = prev_buf ~= 1 and prev_buf or nil,
      })[1]
      if client then
        cb(client.config.root_dir)
      end
    end
  end,

  on_init = {
    function(client)
      local root_dir = client.config.root_dir
      if not root_dir then
        return
      end

      -- honor an explicitly selected solution (:RoslynTarget)
      local selected = vim.g.roslyn_nvim_selected_solution
      if type(selected) == "string" and selected ~= "" and uv.fs_stat(selected) then
        on_init_sln(client, selected)
        return
      end

      -- prefer top-level .sln/.slnx, then recursive search (e.g. src/*.sln)
      local sln = vim.fn.glob(fs.joinpath(root_dir, "*.sln"), false, true)[1]
        or vim.fn.glob(fs.joinpath(root_dir, "*.slnx"), false, true)[1]
        or vim.fn.glob(fs.joinpath(root_dir, "**/*.sln"), false, true)[1]
        or vim.fn.glob(fs.joinpath(root_dir, "**/*.slnx"), false, true)[1]
      if sln then
        on_init_sln(client, sln)
        return
      end

      local projs = vim.fn.glob(fs.joinpath(root_dir, "**/*.csproj"), false, true)
      if #projs > 0 then
        -- single notification with all projects, not one per file
        on_init_project(client, projs)
      end
    end,
  },

  on_attach = function(client, bufnr)
    if vim.api.nvim_get_autocmds({ buffer = bufnr, group = group })[1] then
      return
    end

    local timer = nil
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      group = group,
      buffer = bufnr,
      callback = function()
        -- debounce: InsertLeave can fire rapidly in large solutions
        if timer then
          timer:stop()
          timer:close()
          timer = nil
        end
        timer = vim.uv.new_timer()
        timer:start(300, 0, function()
          timer:stop()
          timer:close()
          timer = nil
          vim.schedule(function()
            -- only the saved buffer; full refresh happens on
            -- projectInitializationComplete below
            if vim.api.nvim_buf_is_valid(bufnr) then
              refresh_diagnostics(client, bufnr)
            end
          end)
        end)
      end,
      desc = "roslyn_ls: refresh diagnostics (debounced)",
    })
  end,

  capabilities = capabilities,

  commands = {
    ["roslyn.client.completionComplexEdit"] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local args = command.arguments or {}
      local uri, edit = args[1], args[2]

      if uri and edit and edit.newText and edit.range then
        local workspace_edit = {
          changes = {
            [uri.uri] = {
              {
                range = edit.range,
                newText = edit.newText,
              },
            },
          },
        }
        vim.lsp.util.apply_workspace_edit(workspace_edit, client.offset_encoding)
      else
        vim.notify("roslyn_ls: completionComplexEdit args not understood: " .. vim.inspect(args), vim.log.levels.WARN)
      end
    end,

    ["roslyn.client.nestedCodeAction"] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local arg = command.arguments and command.arguments[1]

      if type(arg) ~= "table" then
        vim.notify("roslyn_ls: invalid nestedCodeAction arguments", vim.log.levels.ERROR)
        return
      end

      local function handle(action)
        if not action then
          return
        end

        if action.data and not action.edit and not action.command then
          client:request("codeAction/resolve", action, function(err, resolved)
            if err then
              vim.notify(err.message or tostring(err), vim.log.levels.ERROR)
              return
            end
            if resolved then
              handle(resolved)
            end
          end, ctx.bufnr)
          return
        end

        local nested = vim.islist(action) and action or action.NestedCodeActions
        if type(nested) ~= "table" or vim.tbl_isempty(nested) then
          apply_action(client, action)
          return
        end

        if #nested == 1 then
          handle(nested[1])
          return
        end

        vim.ui.select(nested, {
          prompt = action.title or "Select code action",
          format_item = function(item)
            return item.title or (item.command and item.command.title) or "Unnamed action"
          end,
        }, function(choice)
          if choice then
            handle(choice)
          end
        end)
      end

      handle(arg)
    end,

    ["roslyn.client.fixAllCodeAction"] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      handle_fix_all_action(client, command, ctx.bufnr)
    end,
  },

  handlers = {
    ["workspace/projectInitializationComplete"] = function(_, _, ctx)
      vim.notify("Roslyn project initialization complete", vim.log.levels.INFO, { title = "roslyn_ls" })
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      refresh_diagnostics(client)
      return vim.NIL
    end,

    ["razor/provideDynamicFileInfo"] = function(_, _, _)
      -- Legacy Razor method: only fires when the cohosting extension is NOT
      -- loaded. Kept as a safety net in case a razor file is somehow opened
      -- without the extension DLL being found.
      vim.notify(
        "roslyn_ls: razor/provideDynamicFileInfo received but razor cohosting extension was not loaded",
        vim.log.levels.WARN,
        { title = "roslyn_ls" }
      )
      return vim.NIL
    end,

    -- Correct upstream implementation: the server notifies us a project needs
    -- restoring, and `result` already IS the decoded payload (not ctx.params).
    -- We forward it back to the server as a REQUEST on 'workspace/_roslyn_restore'
    -- (not a separate incoming handler) and let Roslyn perform the restore itself.
    ["workspace/_roslyn_projectNeedsRestore"] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      client:request("workspace/_roslyn_restore", result, function(err, response)
        if err then
          vim.notify(err.message, vim.log.levels.ERROR, { title = "roslyn_ls" })
        end
        if response then
          for _, v in ipairs(response) do
            vim.notify(v.message, vim.log.levels.INFO, { title = "roslyn_ls" })
          end
        end
      end)
      return vim.NIL
    end,
  },

  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "fullSolution",
      dotnet_compiler_diagnostics_scope = "fullSolution",
    },
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_indexer_parameters = true,
      dotnet_enable_inlay_hints_for_literal_parameters = true,
      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
      dotnet_enable_inlay_hints_for_other_parameters = true,
      dotnet_enable_inlay_hints_for_parameters = true,
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
    },
    ["csharp|symbol_search"] = {
      dotnet_search_reference_assemblies = true,
    },
    ["csharp|completion"] = {
      -- official upstream settings:
      dotnet_show_name_completion_suggestions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_provide_regex_completions = true,
      -- from your original config:
      -- dotnet_trigger_completion_in_argument_lists is a real, documented Roslyn
      -- setting (confirmed via Zed's csharp LSP docs) — just not in nvim-lspconfig's
      -- curated defaults. Safe to keep.
      dotnet_trigger_completion_in_argument_lists = true,
      -- dotnet_show_completion_items_from_snippets: could not confirm this is a real
      -- setting anywhere. C# LSP snippet completion has open GitHub issues describing
      -- it as unsupported/missing, so this may be a silent no-op. Worth testing
      -- whether it visibly changes anything for you; drop it if not.
      dotnet_show_completion_items_from_snippets = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

vim.lsp.enable("roslyn_ls")

-- ═══════════════════════════════════════════════════════════════
-- DOC-COMMENT AUTO-INSERT (from roslyn.nvim wiki tips):
-- typing `/` after `//` expands the server's /// template.
-- ═══════════════════════════════════════════════════════════════

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("roslyn_autoinsert", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    if not client or (client.name ~= "roslyn_ls" and client.name ~= "roslyn") then
      return
    end
    vim.api.nvim_create_autocmd("InsertCharPre", {
      desc = "Roslyn: expand /// doc template on '/'",
      buffer = bufnr,
      callback = function()
        if vim.v.char ~= "/" then
          return
        end
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        row, col = row - 1, col + 1
        local params = {
          _vs_textDocument = { uri = vim.uri_from_bufnr(bufnr) },
          _vs_position = { line = row, character = col },
          _vs_ch = "/",
          _vs_options = {
            tabSize = vim.bo[bufnr].tabstop,
            insertSpaces = vim.bo[bufnr].expandtab,
          },
        }
        -- send only after the buffer actually changed
        vim.defer_fn(function()
          client:request("textDocument/_vs_onAutoInsert", params, function(err, result)
            if err or not result or not result._vs_textEdit then
              return
            end
            vim.snippet.expand(result._vs_textEdit.newText)
          end, bufnr)
        end, 1)
      end,
    })
  end,
})

-- ═══════════════════════════════════════════════════════════════
-- ROSLYN TARGET SWITCHING:
-- ═══════════════════════════════════════════════════════════════

vim.api.nvim_create_user_command("RoslynTarget", function()
  local cwd = vim.fn.getcwd()
  local solutions = vim.fn.glob(cwd .. "/**/*.sln", false, true)

  if #solutions == 0 then
    vim.notify("No solutions found", vim.log.levels.WARN)
    return
  end

  if #solutions == 1 then
    vim.notify("Only one solution: " .. vim.fn.fnamemodify(solutions[1], ":t"), vim.log.levels.INFO)
    return
  end

  vim.ui.select(solutions, {
    prompt = "Select solution:",
    format_item = function(item)
      return vim.fn.fnamemodify(item, ":~:.")
    end,
  }, function(choice)
    if choice then
      vim.g.roslyn_nvim_selected_solution = choice
      -- native restart (:LspRestart is nvim-lspconfig-only and doesn't exist here)
      for _, c in ipairs(vim.lsp.get_clients({ name = "roslyn_ls" })) do
        c:stop()
      end
      vim.defer_fn(function()
        vim.cmd("edit")
      end, 300)
      vim.notify("Switched to: " .. vim.fn.fnamemodify(choice, ":t"), vim.log.levels.INFO)
    end
  end)
end, { desc = "Switch Roslyn solution target" })
