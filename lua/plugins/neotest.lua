-- neotest + adapter only load on first use (startup saving): every
-- mapping goes through ensure(), which runs setup exactly once
local did_setup = false
local function nt()
  local neotest = require("neotest")
  if not did_setup then
    did_setup = true
    neotest.setup({
      adapters = {
        require("neotest-dotnet")({
          dap = { justMyCode = false },
        }),
      },
    })
  end
  return neotest
end

-- Keymaps
vim.keymap.set("n", "<leader>tr", function()
	nt().run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>tf", function()
	nt().run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })

vim.keymap.set("n", "<leader>ts", function()
	nt().summary.toggle()
end, { desc = "Test summary" })

vim.keymap.set("n", "<leader>td", function()
	nt().run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })

vim.keymap.set("n", "<leader>tp", function()
	nt().run.run({ suite = true })
end, { desc = "Run all tests (suite)" })

vim.keymap.set("n", "<leader>to", function()
	nt().output.open({ enter = true })
end, { desc = "Test output" })

vim.keymap.set("n", "<leader>tj", function()
	nt().jump.next({ status = "failed" })
end, { desc = "Next failed test" })

vim.keymap.set("n", "<leader>tk", function()
	nt().jump.prev({ status = "failed" })
end, { desc = "Prev failed test" })
