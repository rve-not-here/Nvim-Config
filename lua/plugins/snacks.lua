local ok, snacks = pcall(require, "snacks")
if not ok then return end

local banned_patterns = {
  "No information available",
  -- "roslyn_ls: .*", -- re-enable if roslyn gets noisy again
}

local last_msg, last_time = nil, 0

require("snacks").setup({
  notifier = {
    enabled = true,
    timeout = 5000,
    top_down = false,
    width = { min = 50, max = 80 },
    height = { min = 1, max = 20 },
    style = "minimal", -- "compact" | "fancy" | "minimal"
    icons = {
      error = "",
      warn = "",
      info = "",
      debug = "",
      trace = "󰌆",
    },
    border = "single",
    filter = function(notif)
      for _, pattern in ipairs(banned_patterns) do
        if (notif.msg and notif.msg:match(pattern))
          or (notif.title and notif.title:match(pattern)) then
          return false
        end
      end
      -- dedup: drop if same msg fired <1s after the last one
      local now = vim.loop.now()
      if notif.msg == last_msg and (now - last_time) < 1000 then
        return false
      end
      last_msg, last_time = notif.msg, now
      return true
    end,
  },
  bigfile = {
    enabled = true,
    size = 1024 * 1024, -- 1MB, tighter than default 1.5MB, for Roslyn-generated .g.cs files
    setup = function(ctx)
      if vim.fn.exists(":NoMatchParen") ~= 0 then
        vim.cmd("NoMatchParen")
      end
      vim.b.completion = false
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ctx.buf) then
          vim.bo[ctx.buf].syntax = ctx.ft
        end
      end)
    end,
  },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  input = { enabled = true },
  indent = { -- ibl style
    enabled = true,
    scope = { enabled = false }, -- highlight scope / sakit sa mata
    animate = { enabled = false },
  },
  scroll = { enabled = false },
  picker = {
    enabled = true,
    ui_select = true,
  },
})

-- Keymaps
vim.keymap.set("n", "<leader>nh", function()
  require("snacks").notifier.hide()
end, { desc = "Dismiss all notifications" })
vim.keymap.set("n", "<leader>nl", function()
  require("snacks").notifier.show_history()
end, { desc = "Notification history" })
