local ok, notify = pcall(require, "notify")
if not ok then
  return
end

notify.setup({
  -- Appearance
  background_colour = "#0a0a0a", -- Matches your bg1
  fps = 60,
  render = "compact", -- Options: "compact", "default", "minimal"
  stages = "fade", -- Options: "fade", "slide", "static", "fade_in_slide_out", "slide_in_fade_out"

  -- Position
  top_down = false, -- false = bottom, true = top
  max_width = 80,
  minimum_width = 50,
  max_height = 20,

  -- Timeouts
  timeout = 5000, -- How long notifications stay (ms)

  -- Icons (Nerd Font)
  icons = {
    ERROR = "", -- nf-cod-error
    WARN = "", -- nf-cod-warning
    INFO = "", -- nf-cod-info
    DEBUG = "", -- nf-fa-bug
    TRACE = "󰌆", -- nf-md-pencil
  },

  -- Log level
  level = vim.log.levels.INFO, -- Show INFO and above
  -- level = vim.log.levels.WARN,  -- Only show WARN and above (less noise)

  -- Border style
  on_open = function(win)
    vim.api.nvim_win_set_config(win, {
      border = "single", -- Matches your Solarized theme
      style = "minimal",
    })
  end,

  -- Additional options
  replace = {
    merge = false, -- Don't merge duplicate notifications
  },
})

-- Replace vim.notify with nvim-notify
vim.notify = notify

-- Optional: Filter out noisy messages
local banned_patterns = {
  "No information available",
  -- "roslyn_ls: .*", -- Temporarily disabled to debug lambda completion issue
}

local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  opts = opts or {}

  -- Check if message should be filtered
  for _, pattern in ipairs(banned_patterns) do
    if msg:match(pattern) then
      return -- Silently drop this notification
    end
  end

  -- Convert vim.log.levels to notify levels
  local notify_level = level
  if type(level) == "number" then
    notify_level = level
  end

  original_notify(msg, notify_level, opts)
end

-- Optional: Keymaps for notification history
vim.keymap.set("n", "<leader>nh", function()
  require("notify").dismiss({ pending = true, silent = true })
end, { desc = "Dismiss all notifications" })

vim.keymap.set("n", "<leader>nl", function()
  vim.cmd("Notifications") -- Show notification history
end, { desc = "Notification history" })
