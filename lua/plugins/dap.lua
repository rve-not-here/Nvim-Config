local ok, dap = pcall(require, "dap")
if not ok then return end

-- ── Adapter ──────────────────────────────────────────────────────────────────
-- Prefer mason netcoredbg when present (ported from NvChad), fall back to PATH.
local mason_netcoredbg = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
local netcoredbg_cmd = "netcoredbg"
if vim.fn.executable(mason_netcoredbg) == 1 then
  netcoredbg_cmd = mason_netcoredbg
end
dap.adapters.coreclr = {
  type = "executable",
  command = netcoredbg_cmd,
  args = { "--interpreter=vscode" },
}
dap.adapters.netcoredbg = dap.adapters.coreclr

-- ── Helpers ───────────────────────────────────────────────────────────────────
--- Returns the dll path, auto-detecting TFM when possible.
--- Searches from the nearest .csproj upward (supports sln-root cwd and
--- multi-project), covers Debug+Release. Falls back to a prompt.
--- NOTE: must stay synchronous (vim.fn.input) — program_for_cs expects
--- a string return, so async vim.ui.select can't be used here.
local function get_dll()
  local cwd = vim.fn.getcwd()
  -- nearest csproj upward; falls back to cwd basename for loose files
  local csproj = vim.fs.find(function(n)
    return n:match("%.csproj$")
  end, { upward = true, type = "file", limit = 1 })[1]
  local search_root = csproj and vim.fs.dirname(csproj) or cwd
  local project = csproj and vim.fn.fnamemodify(csproj, ":t:r") or vim.fn.fnamemodify(cwd, ":t")

  -- glob across any TFM (net8.0, net9.0, net10.0, …) in Debug and Release
  local dlls = {}
  for _, cfg in ipairs({ "Debug", "Release" }) do
    vim.list_extend(dlls, vim.fn.glob(search_root .. "/bin/" .. cfg .. "/**/*.dll", true, true))
  end

  -- filter to just the project dll (skip ref/, runtimes/, testhost deps)
  local matches = vim.tbl_filter(function(f)
    if f:find("/ref/", 1, true) or f:find("/runtimes/", 1, true) then
      return false
    end
    return vim.fn.fnamemodify(f, ":t:r") == project
  end, dlls)

  if #matches == 1 then
    return matches[1]
  elseif #matches > 1 then
    table.sort(matches)
    -- let the user pick when there are multiple build outputs
    return vim.fn.input("Path to dll: ", matches[1], "file")
  else
    return vim.fn.input("Path to dll: ", search_root .. "/bin/Debug/", "file")
  end
end

-- ── Configurations ────────────────────────────────────────────────────────────
local function program_for_cs()
  -- prefer ramboe dap-dll-autopicker when available (ported from NvChad)
  local ok_picker, picker = pcall(require, "dap-dll-autopicker")
  if ok_picker and picker and type(picker.build_dll_path) == "function" then
    local ok_path, dll = pcall(picker.build_dll_path)
    if ok_path and dll and dll ~= "" then
      return dll
    end
  end
  return get_dll()
end

dap.configurations.cs = {
  {
    type         = "coreclr",
    name         = "Launch - .NET",
    request      = "launch",
    program      = program_for_cs,       -- called at debug-time, not at config load
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

-- ── F-key maps + peek (ported from NvChad custom-config) ─────────────────────
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "WarningMsg", linehl = "", numhl = "" })

vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "DAP: Continue/Start" })
vim.keymap.set("n", "<F9>", function() dap.toggle_breakpoint() end, { desc = "DAP: Toggle breakpoint" })
vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "DAP: Step over" })
vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "DAP: Step into" })
vim.keymap.set("n", "<F8>", function() dap.step_out() end, { desc = "DAP: Step out" })
vim.keymap.set("n", "<F6>", function()
  local ok_nt, neotest = pcall(require, "neotest")
  if ok_nt then
    neotest.run.run({ strategy = "dap" })
  else
    vim.notify("neotest not available", vim.log.levels.WARN)
  end
end, { desc = "Debug nearest test" })
vim.keymap.set({ "n", "v" }, "<leader>dw", function()
  dapui.eval(nil, { enter = true })
end, { desc = "DAP: Watches (eval under cursor)" })
-- NOTE: bare `Q` avoided — it kills macro-repeat. Use <leader>dK instead.
vim.keymap.set({ "n", "v" }, "<leader>dK", function()
  dapui.eval()
end, { desc = "DAP: Peek" })
