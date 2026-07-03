local ok, dap = pcall(require, "dap")
if not ok then return end

-- ── Adapter ──────────────────────────────────────────────────────────────────
dap.adapters.coreclr = {
  type    = "executable",
  command = "netcoredbg",
  args    = { "--interpreter=vscode" },
}

-- ── Helpers ───────────────────────────────────────────────────────────────────
--- Returns the dll path, auto-detecting TFM when possible.
--- Falls back to a prompt if no dll is found or multiple are found.
local function get_dll()
  local cwd   = vim.fn.getcwd()
  -- glob across any TFM (net8.0, net9.0, net10.0, …)
  local dlls  = vim.fn.glob(cwd .. "/bin/Debug/*/**.dll", true, true)

  -- filter to just the project dll (same name as the cwd folder)
  local project = vim.fn.fnamemodify(cwd, ":t")
  local matches = vim.tbl_filter(function(f)
    return vim.fn.fnamemodify(f, ":t:r") == project
  end, dlls)

  if #matches == 1 then
    return matches[1]
  elseif #matches > 1 then
    -- let the user pick when there are multiple build outputs
    return vim.fn.input("Path to dll: ", matches[1], "file")
  else
    return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
  end
end

-- ── Configurations ────────────────────────────────────────────────────────────
dap.configurations.cs = {
  {
    type         = "coreclr",
    name         = "Launch - .NET",
    request      = "launch",
    program      = get_dll,       -- called at debug-time, not at config load
    cwd          = "${workspaceFolder}",
    stopAtEntry  = false,
    env = {
      ASPNETCORE_ENVIRONMENT = "Development",
    },
  },
  {
    type      = "coreclr",
    name      = "Attach - .NET",
    request   = "attach",
    processId = require("dap.utils").pick_process,
  },
}

-- ── dap-ui ────────────────────────────────────────────────────────────────────
local ok_ui, dapui = pcall(require, "dapui")
if not ok_ui then return end

dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes",      size = 0.4 },
        { id = "breakpoints", size = 0.2 },
        { id = "stacks",      size = 0.2 },
        { id = "watches",     size = 0.2 },
      },
      size     = 40,
      position = "left",
    },
    {
      elements = {
        { id = "repl",    size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size     = 12,
      position = "bottom",
    },
  },
})

dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
