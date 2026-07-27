
local ok, snacks = pcall(require, "snacks")
if not ok then return end

require("snacks").setup({
  -- ============================================================
  -- Notifier: replacement for rcarriga/nvim-notify
  -- ============================================================
  notifier = {
    enabled = true,
    timeout = 5000,
    top_down = false, -- false = bottom-right, matches your old notify.lua
    width = { min = 50, max = 80 },
    height = { min = 1, max = 20 },
    style = "compact", -- "compact" | "fancy" | "minimal"
    icons = {
      error = "",
      warn = "",
      info = "",
      debug = "",
      trace = "󰌆",
    },
    -- fancy-style border/background hooks, roughly equivalent to your
    -- old on_open border override
    border = "single",
  },

  -- ============================================================
  -- A few small, genuinely useful, low-risk modules to enable
  -- alongside the notifier. Everything else stays off by default.
  -- ============================================================

  -- Faster startup on huge files (disables treesitter/LSP-heavy
  -- features above a size threshold instead of hanging)
  bigfile = { enabled = true },

  -- Renders the buffer instantly on `nvim file.txt` before plugins
  -- finish loading -- pure QoL, no conflicts with your setup
  quickfile = { enabled = true },

  -- Pretty status column (line numbers, signs, folds) -- optional;
  -- turn off if it fights with your heirline/mini.statusline setup
  statuscolumn = { enabled = false },

  -- Smooth scrolling -- purely cosmetic, safe to toggle off if you
  -- don't like animated cursor movement
  scroll = { enabled = false },
})

-- ============================================================
-- Wire vim.notify to the snacks notifier
-- ============================================================
local snacks_notify = require("snacks").notifier.notify

-- Keep your existing noise filter, just retarget it at snacks
local banned_patterns = {
  "No information available",
  -- "roslyn_ls: .*", -- re-enable if roslyn gets noisy again
}

vim.notify = function(msg, level, opts)
  opts = opts or {}
  for _, pattern in ipairs(banned_patterns) do
    if type(msg) == "string" and msg:match(pattern) then
      return
    end
  end
  snacks_notify(msg, level, opts)
end

-- ============================================================
-- Keymaps
-- ============================================================
vim.keymap.set("n", "<leader>nh", function()
  require("snacks").notifier.hide()
end, { desc = "Dismiss all notifications" })

vim.keymap.set("n", "<leader>nl", function()
  require("snacks").notifier.show_history()
end, { desc = "Notification history" })


