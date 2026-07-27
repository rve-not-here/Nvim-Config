local ok, neotest = pcall(require, "neotest")
if not ok then return end

neotest.setup({
	adapters = {
		require("neotest-dotnet")({
			dap = { justMyCode = false },
		}),
	},
})

-- Keymaps
vim.keymap.set("n", "<leader>tr", function()
	neotest.run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>tf", function()
	neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })

vim.keymap.set("n", "<leader>ts", function()
	neotest.summary.toggle()
end, { desc = "Test summary" })

vim.keymap.set("n", "<leader>to", function()
	neotest.output.open({ enter = true })
end, { desc = "Test output" })
