local ok, aerial = pcall(require, "aerial")
if not ok then return end

aerial.setup({
	backends = { "lsp", "treesitter" },
	layout = {
		default_direction = "prefer_right",
		width = 30,
	},
	on_attach = function(bufnr)
		vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Previous symbol" })
		vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next symbol" })
	end,
})

-- Keymap
vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>", { desc = "Code outline" })
