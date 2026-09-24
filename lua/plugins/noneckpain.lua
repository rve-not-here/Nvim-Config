local ok, nnp = pcall(require, "no-neck-pain")
if not ok then
  return
end

nnp.setup({
  width = 120,
  minSideBufferWidth = 10,
  -- we define our own <leader>z below
  mappings = { enabled = false },
  buffers = {
    -- anonymous scratch pads: never named, never in buffer lists
    setNames = false,
  },
  -- single global statusline while centered: side panes get no bar at all.
  -- also wrap long lines at the centered edge (global wrap is off).
  callbacks = {
    postEnable = function()
      vim.o.laststatus = 3
      vim.wo.wrap = true
      vim.wo.linebreak = true
    end,
    preDisable = function()
      vim.o.laststatus = 2
      vim.wo.wrap = false
      vim.wo.linebreak = false
    end,
  },
})

vim.keymap.set("n", "<leader>z", "<cmd>NoNeckPain<cr>", { desc = "Toggle center" })

-- resize centered width in steps of 10 (plugin default is 5)
local function resize_by(delta)
  local cfg = _G.NoNeckPain and _G.NoNeckPain.config
  local cur = cfg and cfg.width or 120
  vim.cmd("NoNeckPainResize " .. math.max(20, cur + delta))
end
-- NOTE: kept off the <leader>z prefix ([z / ]z instead) so the toggle
-- fires instantly instead of waiting timeoutlen for a follow-up key
vim.keymap.set("n", "]z", function() resize_by(10) end, { desc = "Widen center (+10)" })
vim.keymap.set("n", "[z", function() resize_by(-10) end, { desc = "Narrow center (-10)" })

-- auto-center prose buffers (never auto-disables)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("noneckpain_auto", { clear = true }),
  pattern = { "markdown", "text" },
  callback = function()
    local state_ok, state = pcall(require, "no-neck-pain.state")
    local enabled = state_ok and state and state.enabled
    if not enabled then
      vim.cmd("NoNeckPain")
    end
  end,
})
